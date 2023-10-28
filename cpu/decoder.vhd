library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.riscv_pkg.all;

entity decoder is
    port (
        clk : in std_logic;
        rst : in std_logic;
        enable : in std_logic;

        -- Instruction word (little-endian)
        ram_dout : in std_logic_vector(31 downto 0);

        op : out op_t;

        -- Instruction fields
        rd : out std_logic_vector(4 downto 0);
        rs1 : out std_logic_vector(4 downto 0);
        rs2 : out std_logic_vector(4 downto 0);
        imm_i : out std_logic_vector(31 downto 0);
        imm_s : out std_logic_vector(31 downto 0);
        imm_b : out std_logic_vector(31 downto 0);
        imm_u : out std_logic_vector(31 downto 0);
        imm_j : out std_logic_vector(31 downto 0)
    );
end decoder;

architecture rtl of decoder is

    signal instr : std_logic_vector(31 downto 0);
    signal opcode : std_logic_vector(6 downto 0);
    signal funct7 : std_logic_vector(6 downto 0);
    signal funct3 : std_logic_vector(2 downto 0);

begin

    instr <= convert_endianness(ram_dout);

    -- From figure 2.3 on p.16 in riscv-spec-20191213.pdf
    funct7 <= instr(31 downto 25);
    funct3 <= instr(14 downto 12);
    opcode <= instr(6 downto 0);

    IMMEDIATES_PROC : process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then

                rd <= (others => '0');
                rs1 <= (others => '0');
                rs2 <= (others => '0');
                imm_i <= (others => '0');
                imm_s <= (others => '0');
                imm_b <= (others => '0');
                imm_u <= (others => '0');
                imm_j <= (others => '0');

            else 

                if enable = '1' then

                    -- Source and destination registers
                    -- From figure 2.3 on p.16 in riscv-spec-20191213.pdf
                    rs2 <= instr(24 downto 20);
                    rs1 <= instr(19 downto 15);
                    rd <= instr(11 downto 7);

                    -- Immediates from figure 2.4 on p. 17 in riscv-spec-20191213.pdf
                    imm_i(31 downto 11) <= (others => instr(31));
                    imm_i(10 downto 5) <= instr(30 downto 25);
                    imm_i(4 downto 1) <= instr(24 downto 21);
                    imm_i(0) <= instr(20);
                    -- imm_i(10 downto 0) <= (others => instr(30 downto 20));

                    imm_s(31 downto 11) <= (others => instr(31));
                    imm_s(10 downto 5) <= instr(30 downto 25);
                    imm_s(4 downto 1) <= instr(11 downto 8);
                    imm_s(0) <= instr(7);

                    imm_b(31 downto 12) <= (others => instr(31));
                    imm_b(11) <= instr(7);
                    imm_b(10 downto 5) <= instr(30 downto 25);
                    imm_b(4 downto 1) <= instr(11 downto 8);
                    imm_b(0) <= '0';

                    imm_u(31) <= instr(31);
                    imm_u(30 downto 20) <= instr(30 downto 20);
                    imm_u(19 downto 12) <= instr(19 downto 12);
                    imm_u(11 downto 0) <= (others => '0');

                    imm_j(31 downto 20) <= (others => instr(31));
                    imm_j(19 downto 12) <= instr(19 downto 12);
                    imm_j(11) <= instr(20);
                    imm_j(10 downto 5) <= instr(30 downto 25);
                    imm_j(4 downto 1) <= instr(24 downto 21);
                    imm_j(0) <= '0';

                end if;

            end if;
        end if;
    end process;


    DECODE_PROC : process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                op <= NOP;

            else

                if enable = '0' then
                    null;
                -- Fetch the following opcode and funct values from riscv-spec-20191213.pdf
                -- page 130 (148 in the pdf)
                -- ADDI
                elsif opcode = "0010011" and funct3 = "000" then
                    op <= ADDI;

                -- LUI
                elsif opcode = "0110111" then
                    op <= LUI;

                -- SB
                elsif opcode = "0100011" and funct3 = "000" then
                    op <= SB;

                -- LBU
                elsif opcode = "0000011" and funct3 = "100" then
                    op <= LBU;

                -- BEQ
                elsif opcode = "1100011" and funct3 = "000" then
                    op <= BEQ;

                -- BNE
                elsif opcode = "1100011" and funct3 = "001" then
                    op <= BNE;

                -- BLT
                elsif opcode = "1100011" and funct3 = "100" then
                    op <= BLT;
                
                -- BGE
                elsif opcode = "1100011" and funct3 = "101" then
                    op <= BGE;

                -- JAL
                elsif opcode = "1101111" then
                    op <= JAL;

                -- JALR
                elsif opcode = "1100111" and funct3 = "000" then
                    op <= JALR;

                -- UNKNOWN command
                else
                    op <= UNKNOWN;

                end if;
            end if;
        end if;
    end process;


end architecture;