library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

use work.riscv_pkg.all;


entity mem is
  generic (
    program_hex_file : string
  );
  port (
    clk : in std_logic;
    wr_en : in std_logic;
    addr : in unsigned(ram_word_addr_bits - 1 downto 0);
    din : in std_logic_vector(31 downto 0);
    dout : out std_logic_vector(31 downto 0)
  );
end mem;
 
architecture rtl of mem is

  subtype word_index_type is integer range 0 to 2**ram_word_addr_bits - 1;
 
  type ram_type is array (word_index_type) of std_logic_vector(31 downto 0);
 

  impure function init_ram_hex return ram_type is
    variable ram_content : ram_type;
    file text_file : text open read_mode is program_hex_file;
    variable text_line : line;
    variable byte : std_logic_vector(7 downto 0);
    variable word : std_logic_vector(31 downto 0) := (others => '0');
    variable read_ok : boolean;
    variable byte_index : integer := 3;
    variable word_index : word_index_type := 0;
  begin
    while not endfile(text_file) loop
      readline(text_file, text_line);

      for i in 0 to 3 loop
        hread(text_line, byte, read_ok);

        if not read_ok then
          exit;
        end if;

        word(((byte_index + 1) * 8) - 1 downto (byte_index * 8)) := byte;
        ram_content(word_index) := word;
        byte_index := byte_index - 1;

        if byte_index = -1 then
          byte_index := 3;
          word_index := word_index + 1;
          word := (others => '0');
        end if;

      end loop;

    end loop;

    return ram_content;
  end function;

  signal ram : ram_type := init_ram_hex;
 
begin
 
  RAM_PROC : process(clk)
  variable addr_i : integer;
  begin
    if rising_edge(clk) then

      addr_i := to_integer(addr);

      dout <= ram(addr_i);
 
      if wr_en = '1' then
        ram(addr_i) <= din;
      end if;
    end if;
  end process;
 
end architecture;