library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_arty_s7_50 is
  port (
    clk_100 : in std_logic;
    rst_button : in std_logic; -- The "RESET" button on the board
    uart_rx : in std_logic;
    uart_tx : out std_logic;
    led : out std_logic_vector(3 downto 0)
  );
end top_arty_s7_50;

architecture str of top_arty_s7_50 is

  signal uart_rx_fifo_full : std_logic;
  signal uart_tx_fifo_full : std_logic;
  signal uart_rx_stop_bit_error : std_logic;

begin

  led(0) <= uart_rx_fifo_full; -- LD2
  led(1) <= uart_tx_fifo_full; -- LD3
  led(2) <= uart_rx_stop_bit_error; -- LD4
  led(3) <= '0';

  TOP : entity work.top(str)
    generic map (
      clk_hz => 100e6,
      baud_rate => 115200,
      rst_in_active_value => '0',
      program_hex_file => "../program/hello_world.hex"
    )
    port map (
      clk => clk_100,
      rst_async => rst_button,
      uart_rx => uart_rx,
      uart_tx => uart_tx,
      uart_rx_fifo_full => uart_rx_fifo_full, -- LD2
      uart_tx_fifo_full => uart_tx_fifo_full, -- LD3
      uart_rx_stop_bit_error => uart_rx_stop_bit_error -- LD4
    );

end architecture;