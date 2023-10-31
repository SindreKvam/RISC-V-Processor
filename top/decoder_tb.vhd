library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.riscv_pkg.all;

library vunit_lib;
context vunit_lib.vunit_context;
context vunit_lib.com_context;


entity decoder_tb is
    generic(runner_cfg : string);
end decoder_tb;

architecture sim of decoder_tb is

    constant clk_hz : integer := 100e6;
    constant clk_period : time := 1 sec / clk_hz;


    -- DUT signals
    signal clk : std_logic := '1';
    signal rst : std_logic := '1';
    signal enable : std_logic := '0';

    signal ram_dout : std_logic_vector(31 downto 0);

    -- Out
    signal op : op_t;
    
    -- Instruction fields
    signal rd : std_logic_vector(4 downto 0);
    signal rs1 : std_logic_vector(4 downto 0);
    signal rs2 : std_logic_vector(4 downto 0);
    signal imm_i : std_logic_vector(31 downto 0);
    signal imm_s : std_logic_vector(31 downto 0);
    signal imm_b : std_logic_vector(31 downto 0);
    signal imm_u : std_logic_vector(31 downto 0);
    signal imm_j : std_logic_vector(31 downto 0);

begin

    clk <= not clk after clk_period / 2;

    DUT : entity work.decoder(rtl)
    port map (
        -- In
        clk => clk,
        rst => rst,
        enable => enable,
        ram_dout => ram_dout,
        -- Out
        op => op,
        rd => rd,
        rs1 => rs1,
        rs2 => rs2,
        imm_i => imm_i,
        imm_s => imm_s,
        imm_b => imm_b,
        imm_u => imm_u,
        imm_j => imm_j
    );

    SEQUENCER_PROC : process
    begin
        -------------------------------
        -- VUNIT setup
        -------------------------------

        test_runner_setup(runner, runner_cfg);


        wait for clk_period * 10;
        rst <= '0';
        enable <= '1';

        if run("test_ADDI") then

            ram_dout <= X"93024000";
            wait for clk_period * 10;

            assert unsigned(rd) = 5;
            assert unsigned(rs1) = 0;
            assert signed(rs2) = 4;
            assert signed(imm_i) = 4;

        end if;

        -------------------------------
        -- VUNIT cleanup
        -------------------------------

        test_runner_cleanup(runner);

    end process;

end architecture;