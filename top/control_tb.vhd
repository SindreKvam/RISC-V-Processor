library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.riscv_pkg.all;

library vunit_lib;
context vunit_lib.vunit_context;
context vunit_lib.com_context;

entity control_tb is
    generic(runner_cfg : string);
end control_tb;

architecture sim of control_tb is

    constant clk_hz : integer := 100e6;
    constant clk_period : time := 1 sec / clk_hz;

    signal clk : std_logic := '1';
    signal rst : std_logic := '1';

    -- Decoder interface
    signal decoder_en : std_logic;
    signal op : op_t;
    signal rd : std_logic_vector(4 downto 0);
    signal rs1 : std_logic_vector(4 downto 0);
    signal rs2 : std_logic_vector(4 downto 0);
    signal imm_i : std_logic_vector(31 downto 0);
    signal imm_s : std_logic_vector(31 downto 0);
    signal imm_b : std_logic_vector(31 downto 0);
    signal imm_u : std_logic_vector(31 downto 0);
    signal imm_j : std_logic_vector(31 downto 0);

    -- ALU interface
    signal alu_op : alu_op_t;
    signal alu_src_1 : signed(31 downto 0);
    signal alu_src_2 : signed(31 downto 0);
    signal alu_res : signed(31 downto 0);

    -- RAM interface
    signal ram_wr_en : std_logic;
    signal ram_byte_addr : unsigned(ram_byte_addr_bits - 1 downto 0);
    signal ram_din : std_logic_vector(31 downto 0);
    signal ram_dout : std_logic_vector(31 downto 0);

    -- UART interface
    signal uart_tx_tdata : std_logic_vector(7 downto 0);
    signal uart_tx_tvalid : std_logic;

begin

    clk <= not clk after clk_period / 2;

    DUT : entity work.control(rtl)
    port map (
        clk => clk,
        rst => rst,

        -- DECODER
        decoder_en => decoder_en,
        op => op,
        rd => rd,
        rs1 => rs1,
        rs2 => rs2,
        imm_i => imm_i,
        imm_s => imm_s,
        imm_b => imm_b,
        imm_u => imm_u,
        imm_j => imm_j,

        -- ALU
        alu_op => alu_op,
        alu_src_1 => alu_src_1,
        alu_src_2 => alu_src_2,
        alu_res => alu_res,

        -- RAM
        ram_wr_en => ram_wr_en,
        ram_byte_addr => ram_byte_addr,
        ram_din => ram_din,
        ram_dout => ram_dout,

        -- UART
        uart_tx_tdata => uart_tx_tdata,
        uart_tx_tvalid => uart_tx_tvalid
        
    );

    ALU_INST : entity work.alu(rtl)
    port map (
        op => alu_op,
        src_1 => alu_src_1,
        src_2 => alu_src_2,
        res => alu_res
    );

    SEQUENCER_PROC : process
    begin

        -------------------------------
        -- VUNIT setup
        -------------------------------

        test_runner_setup(runner, runner_cfg);


        wait for clk_period * 2;
        

        if run("test_ADDI") then

            op <= ADDI;
            rd <= b"00101"; -- Address 5
            rs1 <= b"00101"; -- Address 5
            -- Don't care about rs2
            imm_i <= x"00000010"; -- Immediate 0x10

            rst <= '0';

            wait for clk_period * 7;

            -- After first add, register 5 should have been updated with the value 5
            assert alu_res = x"00000010"; -- regs(5)

            wait for clk_period * 7;

            -- After second add, register 5 should have been updated with the value 5+5=10
            assert alu_res = x"00000020"; -- regs(5)
        end if;

        wait for clk_period * 10;
        
        -------------------------------
        -- VUNIT cleanup
        -------------------------------

        test_runner_cleanup(runner);
    end process;

end architecture;