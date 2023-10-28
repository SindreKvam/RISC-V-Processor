onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -group TB /top_tb/clk
add wave -noupdate -group TB /top_tb/rst_async
add wave -noupdate -group TB /top_tb/uart_rx
add wave -noupdate -group TB /top_tb/uart_tx
add wave -noupdate -group TB /top_tb/uart_rx_fifo_full
add wave -noupdate -group TB /top_tb/uart_rx_stop_bit_error
add wave -noupdate -group TB /top_tb/data_out
add wave -noupdate -group TB /top_tb/data_out_valid
add wave -noupdate -group MEM /top_tb/DUT/RISCV/MEM/program_hex_file
add wave -noupdate -group MEM /top_tb/DUT/RISCV/MEM/clk
add wave -noupdate -group MEM /top_tb/DUT/RISCV/MEM/wr_en
add wave -noupdate -group MEM -radix hexadecimal /top_tb/DUT/RISCV/MEM/addr
add wave -noupdate -group MEM -radix hexadecimal /top_tb/DUT/RISCV/MEM/din
add wave -noupdate -group MEM -radix hexadecimal /top_tb/DUT/RISCV/MEM/dout
add wave -noupdate -group MEM /top_tb/DUT/RISCV/MEM/ram
add wave -noupdate -expand -group DECODER /top_tb/DUT/RISCV/DECODER/clk
add wave -noupdate -expand -group DECODER /top_tb/DUT/RISCV/DECODER/rst
add wave -noupdate -expand -group DECODER /top_tb/DUT/RISCV/DECODER/enable
add wave -noupdate -expand -group DECODER /top_tb/DUT/RISCV/DECODER/ram_dout
add wave -noupdate -expand -group DECODER /top_tb/DUT/RISCV/DECODER/op
add wave -noupdate -expand -group DECODER /top_tb/DUT/RISCV/DECODER/rd
add wave -noupdate -expand -group DECODER /top_tb/DUT/RISCV/DECODER/rs1
add wave -noupdate -expand -group DECODER /top_tb/DUT/RISCV/DECODER/rs2
add wave -noupdate -expand -group DECODER /top_tb/DUT/RISCV/DECODER/imm_i
add wave -noupdate -expand -group DECODER /top_tb/DUT/RISCV/DECODER/imm_s
add wave -noupdate -expand -group DECODER /top_tb/DUT/RISCV/DECODER/imm_b
add wave -noupdate -expand -group DECODER /top_tb/DUT/RISCV/DECODER/imm_u
add wave -noupdate -expand -group DECODER /top_tb/DUT/RISCV/DECODER/imm_j
add wave -noupdate -expand -group DECODER /top_tb/DUT/RISCV/DECODER/instr
add wave -noupdate -expand -group DECODER /top_tb/DUT/RISCV/DECODER/opcode
add wave -noupdate -expand -group DECODER /top_tb/DUT/RISCV/DECODER/funct7
add wave -noupdate -expand -group DECODER /top_tb/DUT/RISCV/DECODER/funct3
add wave -noupdate -expand -group CONTROL -radix unsigned /top_tb/DUT/RISCV/CONTROL/clk
add wave -noupdate -expand -group CONTROL -radix unsigned /top_tb/DUT/RISCV/CONTROL/rst
add wave -noupdate -expand -group CONTROL -radix unsigned /top_tb/DUT/RISCV/CONTROL/decoder_en
add wave -noupdate -expand -group CONTROL -radix unsigned /top_tb/DUT/RISCV/CONTROL/op
add wave -noupdate -expand -group CONTROL -radix unsigned -childformat {{/top_tb/DUT/RISCV/CONTROL/rd(4) -radix unsigned} {/top_tb/DUT/RISCV/CONTROL/rd(3) -radix unsigned} {/top_tb/DUT/RISCV/CONTROL/rd(2) -radix unsigned} {/top_tb/DUT/RISCV/CONTROL/rd(1) -radix unsigned} {/top_tb/DUT/RISCV/CONTROL/rd(0) -radix unsigned}} -subitemconfig {/top_tb/DUT/RISCV/CONTROL/rd(4) {-height 15 -radix unsigned} /top_tb/DUT/RISCV/CONTROL/rd(3) {-height 15 -radix unsigned} /top_tb/DUT/RISCV/CONTROL/rd(2) {-height 15 -radix unsigned} /top_tb/DUT/RISCV/CONTROL/rd(1) {-height 15 -radix unsigned} /top_tb/DUT/RISCV/CONTROL/rd(0) {-height 15 -radix unsigned}} /top_tb/DUT/RISCV/CONTROL/rd
add wave -noupdate -expand -group CONTROL -radix unsigned /top_tb/DUT/RISCV/CONTROL/rs1
add wave -noupdate -expand -group CONTROL -radix unsigned /top_tb/DUT/RISCV/CONTROL/rs2
add wave -noupdate -expand -group CONTROL -radix unsigned /top_tb/DUT/RISCV/CONTROL/imm_i
add wave -noupdate -expand -group CONTROL -radix unsigned /top_tb/DUT/RISCV/CONTROL/imm_s
add wave -noupdate -expand -group CONTROL -radix unsigned /top_tb/DUT/RISCV/CONTROL/imm_b
add wave -noupdate -expand -group CONTROL -radix unsigned /top_tb/DUT/RISCV/CONTROL/imm_u
add wave -noupdate -expand -group CONTROL -radix unsigned /top_tb/DUT/RISCV/CONTROL/imm_j
add wave -noupdate -expand -group CONTROL -radix unsigned /top_tb/DUT/RISCV/CONTROL/alu_op
add wave -noupdate -expand -group CONTROL -radix decimal /top_tb/DUT/RISCV/CONTROL/alu_src_1
add wave -noupdate -expand -group CONTROL -radix decimal /top_tb/DUT/RISCV/CONTROL/alu_src_2
add wave -noupdate -expand -group CONTROL -radix decimal /top_tb/DUT/RISCV/CONTROL/alu_res
add wave -noupdate -expand -group CONTROL -radix unsigned /top_tb/DUT/RISCV/CONTROL/ram_wr_en
add wave -noupdate -expand -group CONTROL -radix unsigned /top_tb/DUT/RISCV/CONTROL/ram_byte_addr
add wave -noupdate -expand -group CONTROL -radix unsigned /top_tb/DUT/RISCV/CONTROL/ram_din
add wave -noupdate -expand -group CONTROL -radix unsigned /top_tb/DUT/RISCV/CONTROL/ram_dout
add wave -noupdate -expand -group CONTROL -radix unsigned /top_tb/DUT/RISCV/CONTROL/uart_tx_tdata
add wave -noupdate -expand -group CONTROL -radix unsigned /top_tb/DUT/RISCV/CONTROL/uart_tx_tvalid
add wave -noupdate -expand -group CONTROL -radix unsigned /top_tb/DUT/RISCV/CONTROL/state
add wave -noupdate -expand -group CONTROL -radix hexadecimal /top_tb/DUT/RISCV/CONTROL/pc
add wave -noupdate -expand -group CONTROL -radix hexadecimal /top_tb/DUT/RISCV/CONTROL/current_pc
add wave -noupdate -expand -group CONTROL -radix unsigned -childformat {{/top_tb/DUT/RISCV/CONTROL/regs(0) -radix unsigned} {/top_tb/DUT/RISCV/CONTROL/regs(1) -radix hexadecimal} {/top_tb/DUT/RISCV/CONTROL/regs(2) -radix unsigned} {/top_tb/DUT/RISCV/CONTROL/regs(3) -radix unsigned} {/top_tb/DUT/RISCV/CONTROL/regs(4) -radix unsigned} {/top_tb/DUT/RISCV/CONTROL/regs(5) -radix unsigned} {/top_tb/DUT/RISCV/CONTROL/regs(6) -radix unsigned} {/top_tb/DUT/RISCV/CONTROL/regs(7) -radix unsigned} {/top_tb/DUT/RISCV/CONTROL/regs(8) -radix unsigned} {/top_tb/DUT/RISCV/CONTROL/regs(9) -radix unsigned} {/top_tb/DUT/RISCV/CONTROL/regs(10) -radix unsigned} {/top_tb/DUT/RISCV/CONTROL/regs(11) -radix unsigned} {/top_tb/DUT/RISCV/CONTROL/regs(12) -radix unsigned} {/top_tb/DUT/RISCV/CONTROL/regs(13) -radix unsigned} {/top_tb/DUT/RISCV/CONTROL/regs(14) -radix unsigned} {/top_tb/DUT/RISCV/CONTROL/regs(15) -radix unsigned} {/top_tb/DUT/RISCV/CONTROL/regs(16) -radix unsigned} {/top_tb/DUT/RISCV/CONTROL/regs(17) -radix unsigned} {/top_tb/DUT/RISCV/CONTROL/regs(18) -radix unsigned} {/top_tb/DUT/RISCV/CONTROL/regs(19) -radix unsigned} {/top_tb/DUT/RISCV/CONTROL/regs(20) -radix unsigned} {/top_tb/DUT/RISCV/CONTROL/regs(21) -radix unsigned} {/top_tb/DUT/RISCV/CONTROL/regs(22) -radix unsigned} {/top_tb/DUT/RISCV/CONTROL/regs(23) -radix unsigned} {/top_tb/DUT/RISCV/CONTROL/regs(24) -radix unsigned} {/top_tb/DUT/RISCV/CONTROL/regs(25) -radix unsigned} {/top_tb/DUT/RISCV/CONTROL/regs(26) -radix unsigned} {/top_tb/DUT/RISCV/CONTROL/regs(27) -radix unsigned} {/top_tb/DUT/RISCV/CONTROL/regs(28) -radix unsigned} {/top_tb/DUT/RISCV/CONTROL/regs(29) -radix unsigned} {/top_tb/DUT/RISCV/CONTROL/regs(30) -radix unsigned} {/top_tb/DUT/RISCV/CONTROL/regs(31) -radix unsigned}} -expand -subitemconfig {/top_tb/DUT/RISCV/CONTROL/regs(0) {-radix unsigned} /top_tb/DUT/RISCV/CONTROL/regs(1) {-radix hexadecimal} /top_tb/DUT/RISCV/CONTROL/regs(2) {-radix unsigned} /top_tb/DUT/RISCV/CONTROL/regs(3) {-radix unsigned} /top_tb/DUT/RISCV/CONTROL/regs(4) {-radix unsigned} /top_tb/DUT/RISCV/CONTROL/regs(5) {-radix unsigned} /top_tb/DUT/RISCV/CONTROL/regs(6) {-radix unsigned} /top_tb/DUT/RISCV/CONTROL/regs(7) {-radix unsigned} /top_tb/DUT/RISCV/CONTROL/regs(8) {-radix unsigned} /top_tb/DUT/RISCV/CONTROL/regs(9) {-radix unsigned} /top_tb/DUT/RISCV/CONTROL/regs(10) {-radix unsigned} /top_tb/DUT/RISCV/CONTROL/regs(11) {-radix unsigned} /top_tb/DUT/RISCV/CONTROL/regs(12) {-radix unsigned} /top_tb/DUT/RISCV/CONTROL/regs(13) {-radix unsigned} /top_tb/DUT/RISCV/CONTROL/regs(14) {-radix unsigned} /top_tb/DUT/RISCV/CONTROL/regs(15) {-radix unsigned} /top_tb/DUT/RISCV/CONTROL/regs(16) {-radix unsigned} /top_tb/DUT/RISCV/CONTROL/regs(17) {-radix unsigned} /top_tb/DUT/RISCV/CONTROL/regs(18) {-radix unsigned} /top_tb/DUT/RISCV/CONTROL/regs(19) {-radix unsigned} /top_tb/DUT/RISCV/CONTROL/regs(20) {-radix unsigned} /top_tb/DUT/RISCV/CONTROL/regs(21) {-radix unsigned} /top_tb/DUT/RISCV/CONTROL/regs(22) {-radix unsigned} /top_tb/DUT/RISCV/CONTROL/regs(23) {-radix unsigned} /top_tb/DUT/RISCV/CONTROL/regs(24) {-radix unsigned} /top_tb/DUT/RISCV/CONTROL/regs(25) {-radix unsigned} /top_tb/DUT/RISCV/CONTROL/regs(26) {-radix unsigned} /top_tb/DUT/RISCV/CONTROL/regs(27) {-radix unsigned} /top_tb/DUT/RISCV/CONTROL/regs(28) {-radix unsigned} /top_tb/DUT/RISCV/CONTROL/regs(29) {-radix unsigned} /top_tb/DUT/RISCV/CONTROL/regs(30) {-radix unsigned} /top_tb/DUT/RISCV/CONTROL/regs(31) {-radix unsigned}} /top_tb/DUT/RISCV/CONTROL/regs
add wave -noupdate -expand -group CONTROL -radix unsigned /top_tb/DUT/RISCV/CONTROL/reg_wr_back
add wave -noupdate -group ALU /top_tb/DUT/RISCV/ALU/op
add wave -noupdate -group ALU /top_tb/DUT/RISCV/ALU/src_1
add wave -noupdate -group ALU /top_tb/DUT/RISCV/ALU/src_2
add wave -noupdate -group ALU /top_tb/DUT/RISCV/ALU/res
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {64859142 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 224
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 1
configure wave -timelineunits ns
update
WaveRestoreZoom {64244279 ps} {64885153 ps}
