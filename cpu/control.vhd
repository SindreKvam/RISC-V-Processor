library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.riscv_pkg.all;

entity control is
    port (
        clk : in std_logic;
        rst : in std_logic;
    
        -- Decoder interface
        decoder_en : out std_logic;
        op : in op_t;
        rd : in std_logic_vector(4 downto 0);
        rs1 : in std_logic_vector(4 downto 0);
        rs2 : in std_logic_vector(4 downto 0);
        imm_i : in std_logic_vector(31 downto 0);
        imm_s : in std_logic_vector(31 downto 0);
        imm_b : in std_logic_vector(31 downto 0);
        imm_u : in std_logic_vector(31 downto 0);
        imm_j : in std_logic_vector(31 downto 0);

        -- ALU interface
        alu_op : out alu_op_t;
        alu_src_1 : out signed(31 downto 0);
        alu_src_2 : out signed(31 downto 0);
        alu_res : in signed(31 downto 0);

        -- RAM interface
        ram_wr_en : out std_logic;
        ram_byte_addr : out unsigned(ram_byte_addr_bits - 1 downto 0);
        ram_din : out std_logic_vector(31 downto 0);
        ram_dout : in std_logic_vector(31 downto 0);

        -- UART interface
        uart_tx_tdata : out std_logic_vector(7 downto 0);
        uart_tx_tvalid : out std_logic
    );
end control;

architecture rtl of control is

    type state_t is (
        FETCH_1,
        FETCH_2,
        DECODE_1,
        DECODE_2,
        EXECUTE_1,
        EXECUTE_2,
        MEM_READ_1,
        MEM_READ_2,
        MEM_WRITE,
        WRITEBACK);
    signal state : state_t;

    -- Program counter
    signal pc : unsigned(31 downto 0);

    -- PC address of the operation currently being executed
    signal current_pc : unsigned(31 downto 0);

    -- General purpose registers x0-x31
    -- Page 32 in riscv-spec-20191213.pdf
    type regs_t is array (0 to 31) of std_logic_vector(31 downto 0);
    signal regs : regs_t;

    -- Word to write back to the registers
    signal reg_wr_back : std_logic_vector(31 downto 0);

begin

    FSM_PROC : process(clk)

        variable byte : std_logic_vector(7 downto 0);

    begin
        if rising_edge(clk) then
            if rst = '1' then

                -- Output signals
                decoder_en <= '0';
                alu_op <= ADD;
                alu_src_1 <= (others => '0');
                alu_src_2 <= (others => '0');
                ram_wr_en <= '0';
                ram_byte_addr <= (others => '0');
                ram_din <= (others => '0');
                uart_tx_tdata <= (others => '0');
                uart_tx_tvalid <= '0';

                -- Internal signals
                state <= FETCH_1;
                pc <= (others => '0');
                current_pc <= (others => '0');
                regs <= (others => (others => '0'));
                reg_wr_back <= (others => '0');

            else
                
                -- Pulsed signals
                ram_wr_en <= '0';
                uart_tx_tvalid <= '0';
                decoder_en <= '0';

            STATE_CASE : case state is
            
                when FETCH_1 =>
                    ram_byte_addr <= pc(ram_byte_addr_bits - 1 downto 0);
                    current_pc <= pc;
                    pc <= pc + 4; -- 32 bit processor, increment by 4
                    state <= FETCH_2;

                when FETCH_2 =>
                    decoder_en <= '1';
                    state <= DECODE_1;

                when DECODE_1 =>
                    -- decoder is enabled, but values are still the old values from the decoder.
                    -- wait one clock cycle
                    state <= DECODE_2;

                when DECODE_2 =>

                    -- Determine next state based on the operation
                    DECODE_OP_CASE : case op is

                        -- I-type
                        when ADDI | LBU | JALR =>
                            alu_op <= ADD;
                            alu_src_1 <= signed(regs(to_integer(unsigned(rs1))));
                            alu_src_2 <= signed(imm_i); -- I-type format
                            state <= EXECUTE_1;

                        -- U-type
                        when LUI =>
                            state <= EXECUTE_1;

                        -- S-type
                        when SB =>
                            alu_op <= ADD;
                            alu_src_1 <= signed(regs(to_integer(unsigned(rs1))));
                            alu_src_2 <= signed(imm_s);
                            state <= MEM_WRITE;

                        -- B-type
                        when BNE | BEQ | BGE | BLT =>
                            alu_op <= SUB;
                            alu_src_1 <= signed(regs(to_integer(unsigned(rs1))));
                            alu_src_2 <= signed(regs(to_integer(unsigned(rs2))));
                            state <= EXECUTE_1;

                        -- J-type
                        when JAL =>
                            alu_op <= ADD;
                            alu_src_1 <= signed(current_pc);
                            alu_src_2 <= signed(imm_j);
                            state <= EXECUTE_1;

                        when others =>
                            null;

                            debug_unsupported_instruction;
                    
                    end case DECODE_OP_CASE;

                when EXECUTE_1 =>

                    EXECUTE_1_OP_CASE : case op is

                        when ADDI =>
                            reg_wr_back <= std_logic_vector(alu_res);
                            state <= WRITEBACK;

                        when LUI =>
                            reg_wr_back <= imm_u; -- U-type format
                            state <= WRITEBACK;

                        when LBU =>
                            ram_byte_addr <= unsigned(alu_res(ram_byte_addr_bits - 1 downto 0));
                            state <= MEM_READ_1;

                        when BEQ =>
                            -- If the two values are equal
                            if alu_res = x"00000000" then
                                -- Calculate new program counter
                                alu_op <= ADD;
                                alu_src_1 <= signed(current_pc);
                                alu_src_2 <= signed(imm_b);
                                state <= EXECUTE_2;
                            else
                                -- We are not going to do any branching
                                -- Since the values were not identical.
                                state <= FETCH_1;
                            end if;

                        when BNE =>

                            -- If the two values are not equal
                            if alu_res /= x"00000000" then
                                -- Calculate new program counter
                                alu_op <= ADD;
                                alu_src_1 <= signed(current_pc);
                                alu_src_2 <= signed(imm_b);
                                state <= EXECUTE_2;
                            else
                                -- We are not going to do any branching
                                -- Since the values were not identical.
                                state <= FETCH_1;
                            end if;

                        when BLT =>
                            -- If src_1 is less than src_2
                            -- if alu_res is smaller than 0
                            if alu_res < x"00000000" then
                                -- Calculate new program counter
                                alu_op <= ADD;
                                alu_src_1 <= signed(current_pc);
                                alu_src_2 <= signed(imm_b);
                                state <= EXECUTE_2;
                            else
                                -- We are not going to do any branching
                                -- Since the values were not identical.
                                state <= FETCH_1;
                            end if;

                        when BGE =>
                            -- If src_1 is greater or equals to src_2
                            -- if alu_res is equal to or greater than 0.
                            if alu_res >= x"00000000" then
                                -- Calculate new program counter
                                alu_op <= ADD;
                                alu_src_1 <= signed(current_pc);
                                alu_src_2 <= signed(imm_b);
                                state <= EXECUTE_2;
                            else
                                -- We are not going to do any branching
                                -- Since the values were not identical.
                                state <= FETCH_1;
                            end if;

                        when JAL | JALR =>
                            pc <= unsigned(alu_res);
                            -- pc is not yet updated, 
                            -- write this value to be able to jump back to this address later.
                            reg_wr_back <= std_logic_vector(pc);
                            state <= WRITEBACK;
                            

                        when others =>
                            null;

                    end case EXECUTE_1_OP_CASE;

                when EXECUTE_2 =>

                    EXECUTE_2_OP_CASE : case op is

                        when BEQ | BNE | BGE | BLT =>
                            pc <= unsigned(alu_res);
                            state <= FETCH_1;

                        when others =>
                            null;

                    end case EXECUTE_2_OP_CASE;

                when MEM_READ_1 =>
                    -- Execute step will set the memory address,
                    -- Have to wait one clock cycle for the data to appear.
                    state <= MEM_READ_2;

                when MEM_READ_2 =>

                    MEM_READ_OP_CASE : case op is

                        when LBU =>
                            
                            case ram_byte_addr(1 downto 0) is
                                
                                when "00" =>
                                    byte := ram_dout(31 downto 24);
                                when "01" =>
                                    byte := ram_dout(23 downto 16);
                                when "10" =>
                                    byte := ram_dout(15 downto 8);
                                when others => -- when "11"
                                    byte := ram_dout(7 downto 0);

                            end case;
                            reg_wr_back <= (others => '0');
                            reg_wr_back(7 downto 0) <= byte;

                            state <= WRITEBACK;

                        when others =>
                            null;

                    end case MEM_READ_OP_CASE;

                when MEM_WRITE =>

                    MEM_WRITE_OP_CASE : case op is

                        when SB =>
                            -- alu_res now contains the mem address
                            
                            -- If this is a write to the memory mapped UART interface
                            if std_logic_vector(alu_res) = UART_TX_MEM_ADDR then
                                uart_tx_tvalid <= '1';
                                uart_tx_tdata <= regs(to_integer(unsigned(rs2)))(7 downto 0);

                            else

                                report "RAM writes not supported yet" 
                                    severity failure;

                                -- read the whole word from memory
                                -- then change one byte and write it back again

                                -- byte addressable writing. This is possible in some FPGAs

                            end if;

                            state <= FETCH_1;

                        when others =>
                            null;

                    end case MEM_WRITE_OP_CASE;

                when WRITEBACK =>

                    regs(to_integer(unsigned(rd))) <= reg_wr_back;

                    -- Register x0 is hardwired to all-zeros.
                    regs(0) <= (others => '0');

                    state <= FETCH_1;

            
            end case STATE_CASE;
                
            end if;
        end if;
    end process;

end architecture;