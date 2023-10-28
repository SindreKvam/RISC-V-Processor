library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package riscv_pkg is

  -- 2**10 = 1024 32-bit words
  constant ram_word_addr_bits : natural := 10;

  -- Byte address size (4 bytes per 32-bit word)
  constant ram_byte_addr_bits : natural := ram_word_addr_bits + 2;

  -- Memory mapped address of the UART TX interface
  constant UART_TX_MEM_ADDR : std_logic_vector(31 downto 0) := x"10000000";

  -- RISC-V operation
  type op_t is (
    NOP, -- No operation
    UNKNOWN, -- Instruction not recognized by decoder
    ADDI, -- Add immediate
    LUI, -- Load upper immediate
    SB, -- Store byte
    LBU, -- Load byte unsigned
    BEQ, -- Branch if equal
    BNE, -- Branch if not equal
    BLT, -- Branch if less than
    BGE, -- Branch if greater or equals
    JAL, -- Jump and link
    JALR  -- Jump and link register
  );

  -- ALU operation
  type alu_op_t is (ADD, SUB);

  function convert_endianness(w: std_logic_vector(31 downto 0)) return std_logic_vector;

  procedure debug_unsupported_instruction;
  
end package;

package body riscv_pkg is

  -- Convert between little and big-endianness for a 32-bit word.
  function convert_endianness(w: std_logic_vector(31 downto 0)) return std_logic_vector is
    variable ret: std_logic_vector(31 downto 0);
  begin
    for i in 0 to 3 loop
      ret(8 * i + 7 downto 8 * i) := w(8 * (3 - i) + 7 downto 8 * (3 - i));
    end loop;
  
    return ret;
  end function convert_endianness;

  procedure debug_unsupported_instruction is
    alias instr is << signal DUT.RISCV.DECODER.instr : std_logic_vector >>;
    alias opcode is << signal DUT.RISCV.DECODER.opcode : std_logic_vector >>;
    alias funct3 is << signal DUT.RISCV.DECODER.funct3 : std_logic_vector >>;
    alias funct7 is << signal DUT.RISCV.DECODER.funct7 : std_logic_vector >>;
    alias rs1 is << signal DUT.RISCV.DECODER.rs1 : std_logic_vector >>;
    alias rs2 is << signal DUT.RISCV.DECODER.rs2 : std_logic_vector >>;
    alias rd is << signal DUT.RISCV.DECODER.rd : std_logic_vector >>;
    alias imm_i is << signal DUT.RISCV.DECODER.imm_i : std_logic_vector >>;
    alias imm_s is << signal DUT.RISCV.DECODER.imm_s : std_logic_vector >>;
    alias imm_b is << signal DUT.RISCV.DECODER.imm_b : std_logic_vector >>;
    alias imm_u is << signal DUT.RISCV.DECODER.imm_u : std_logic_vector >>;
    alias imm_j is << signal DUT.RISCV.DECODER.imm_j : std_logic_vector >>;
  begin
    
    report "Unsupported instruction 0x" & to_hstring(instr) &
      " (little-endian: 0x" & to_hstring(convert_endianness(instr)) & ")" & LF & LF &
      "opcode: 0b" & to_string(opcode) & LF &
      "funct3: 0b" & to_string(funct3) & LF &
      "funct7: 0b" & to_string(funct7) & LF & LF &
      "rs1: 0d" & to_string(to_integer(unsigned(rs1))) & LF &
      "rs2: 0d" & to_string(to_integer(unsigned(rs2))) & LF &
      "rd:  0d" & to_string(to_integer(unsigned(rd))) & LF & LF &
      "imm_i: 0x" & to_hstring(imm_i) & LF &
      "imm_s: 0x" & to_hstring(imm_s) & LF &
      "imm_b: 0x" & to_hstring(imm_b) & LF &
      "imm_u: 0x" & to_hstring(imm_u) & LF &
      "imm_j: 0x" & to_hstring(imm_j)
      severity failure;
  
  end procedure;

end package body;