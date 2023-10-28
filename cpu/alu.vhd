library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.riscv_pkg.all;

entity alu is
    port (
        op : in alu_op_t;
        src_1 : in signed(31 downto 0);
        src_2 : in signed(31 downto 0);
        res : out signed(31 downto 0)
    );
end alu;

architecture rtl of alu is
begin

    ALU_PROC : process(all)
    begin
        
        case op is
        
            when ADD =>
                res <= src_1 + src_2;

            when SUB =>
                res <= src_1 - src_2;

        end case;
    end process;

end architecture;