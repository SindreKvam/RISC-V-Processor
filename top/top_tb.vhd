library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library vunit_lib;
context vunit_lib.vunit_context;
context vunit_lib.com_context;

entity top_tb is
  generic(runner_cfg : string);
end top_tb;

architecture sim of top_tb is

  constant clk_hz : integer := 100e6;
  constant clk_period : time := 1 sec / clk_hz;

  constant baud_rate : integer := 115200;
  
  -- DUT signals
  signal clk : std_logic := '1';
  signal rst_async : std_logic := '1';
  signal uart_rx : std_logic;
  signal uart_tx : std_logic;
  signal uart_rx_fifo_full : std_logic;
  signal uart_rx_stop_bit_error : std_logic;

  -- UART BFM signals
  signal data_out : std_logic_vector(7 downto 0);
  signal data_out_valid : boolean;

begin

  clk <= not clk after clk_period / 2;

  DUT : entity work.top(str)
    generic map (
      clk_hz => clk_hz,
      baud_rate => baud_rate,
      program_hex_file => "../../program/4.hex"
    )
    port map (
      clk => clk,
      rst_async => rst_async,
      uart_rx => uart_rx,
      uart_tx => uart_tx,
      uart_rx_fifo_full => uart_rx_fifo_full,
      uart_rx_stop_bit_error => uart_rx_stop_bit_error
    );

  UART_BFM : entity work.uart_bfm(beh)
    generic map (
      baud_rate => baud_rate
    )
    port map (
      data_in => (others => '0'),
      data_in_ready => open,
      data_in_valid => false,

      data_out => data_out,
      data_out_valid => data_out_valid,

      rx => uart_tx,
      tx => uart_rx
    );
  
  UART_RECV_PROC : process
  begin
    
    wait until data_out_valid;
    info("UART received char: " & character'val(to_integer(unsigned(data_out))));
    
  end process;

  SEQUENCER_PROC : process
  begin

    -------------------------------
    -- VUNIT setup
    -------------------------------

    test_runner_setup(runner, runner_cfg);


    wait for clk_period * 10;
    rst_async <= '0';

    if run("test_1") then

      -- Replace this with a proper test
      -- wait for 20 us;
      wait for 2 ms;
      
    end if;
      
    -------------------------------
    -- VUNIT cleanup
    -------------------------------

    test_runner_cleanup(runner);

  end process;

end architecture;