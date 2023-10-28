library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top is
  generic (
    clk_hz : positive;
    baud_rate : positive := 115200;

    -- The polarity of rst_in when the module is in reset
    rst_in_active_value : std_logic := '1';

    -- RISC-V instructions to run formatted as a
    -- list of 32-bit hex words in little-endian format
    program_hex_file : string
  );
  port (
    clk : in std_logic;
    rst_async : in std_logic;
    uart_rx : in std_logic;
    uart_tx : out std_logic;
    uart_tx_fifo_full : out std_logic;
    uart_rx_fifo_full : out std_logic;
    uart_rx_stop_bit_error : out std_logic
  );
end top;

architecture str of top is

  signal rst : std_logic; -- Sync reset

  signal uart_tx_tdata : std_logic_vector(7 downto 0);
  signal uart_tx_tvalid : std_logic;
  signal uart_tx_tready : std_logic;

begin

  uart_tx_fifo_full <= not uart_tx_tready;

  RESET_SYNC : entity work.reset_sync(rtl)
  generic map (
    rst_in_active_value => rst_in_active_value
  )
  port map (
    clk => clk,
    rst_in => rst_async,
    rst_out => rst
  );

  RISCV : entity work.riscv(rtl)
  generic map (program_hex_file => program_hex_file)
  port map (
    clk => clk,
    rst => rst,
    uart_tx_tdata => uart_tx_tdata,
    uart_tx_tvalid => uart_tx_tvalid
  );

  UART : entity work.uart_buffered(rtl)
  generic map (
    clk_hz => clk_hz,
    baud_rate => baud_rate
  )
  port map (
    clk => clk,
    rst => rst,
    rx => uart_rx,
    tx => uart_tx,
    recv_tdata => open,
    recv_tvalid => open,
    recv_tready => '0',
    send_tdata => uart_tx_tdata,
    send_tvalid => uart_tx_tvalid,
    send_tready => uart_tx_tready,
    rx_fifo_full => uart_rx_fifo_full,
    rx_stop_bit_error => uart_rx_stop_bit_error
  );

end architecture;