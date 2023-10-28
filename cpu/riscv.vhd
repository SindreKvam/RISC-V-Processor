library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

use work.riscv_pkg.all;

entity riscv is
  generic (program_hex_file : string);
  port (
    clk : in std_logic;
    rst : in std_logic;

    -- Byte to send over UART
    uart_tx_tdata : out std_logic_vector(7 downto 0);
    uart_tx_tvalid : out std_logic

  );
end riscv;

architecture rtl of riscv is

  signal ram_wr_en : std_logic;
  signal ram_din : std_logic_vector(31 downto 0);
  signal ram_dout : std_logic_vector(31 downto 0);
  signal ram_byte_addr : unsigned(ram_byte_addr_bits - 1 downto 0);
  signal ram_word_addr : unsigned(ram_word_addr_bits - 1 downto 0);

  -- Decoder signals
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

  -- ALU signals
  signal alu_op : alu_op_t;
  signal alu_src_1 : signed(31 downto 0);
  signal alu_src_2 : signed(31 downto 0);
  signal alu_res : signed(31 downto 0);

begin

  ram_word_addr <= ram_byte_addr(ram_byte_addr_bits - 1 downto 2);

  MEM : entity work.mem(rtl)
    generic map (program_hex_file => program_hex_file)
    port map(
      clk => clk,
      wr_en => ram_wr_en,
      addr => ram_word_addr,
      din => ram_din,
      dout => ram_dout
    );

  DECODER : entity work.decoder(rtl)
    port map(
      clk => clk,
      rst => rst,
      enable => decoder_en,
      ram_dout => ram_dout,
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

  ALU : entity work.alu(rtl)
    port map(
      op => alu_op,
      src_1 => alu_src_1,
      src_2 => alu_src_2,
      res => alu_res
    );

  CONTROL : entity work.control(rtl)
  port map(
    clk => clk,
    rst => rst,

    -- Decoder interface
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

    -- ALU interface
    alu_op => alu_op,
    alu_src_1 => alu_src_1,
    alu_src_2 => alu_src_2,
    alu_res => alu_res,

    -- RAM interface
    ram_wr_en => ram_wr_en,
    ram_byte_addr => ram_byte_addr,
    ram_din => ram_din,
    ram_dout => ram_dout,

    -- UART interface
    uart_tx_tdata => uart_tx_tdata,
    uart_tx_tvalid => uart_tx_tvalid
);

end architecture;