
-- ============================================================================
-- 
-- DESCRIPTION:
-- This VHDL file implements a 2-to-4 multiplexer. This specific multiplexer has 2 select lines and 4 output
-- lines.
-- 
-- ============================================================================
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Entity declaration for 2-to-4 MUX
entity mux2to4 is
    Port (
        sel : in  STD_LOGIC_VECTOR(1 downto 0); -- 2-bit select lines
        d0  : in  STD_LOGIC_VECTOR(7 downto 0); -- 8-bit input 0
        d1  : in  STD_LOGIC_VECTOR(7 downto 0); -- 8-bit input 1
        d2  : in  STD_LOGIC_VECTOR(7 downto 0); -- 8-bit input 2
        d3  : in  STD_LOGIC_VECTOR(7 downto 0); -- 8-bit input 3
        y   : out STD_LOGIC_VECTOR(7 downto 0)  -- 8-bit output selected by sel
    );
end mux2to4;

-- Architecture declaration for 2-to-4 MUX
architecture rtl of mux2to4 is
begin
    -- Process to implement MUX functionality
    process(sel, d0, d1, d2, d3)
    begin
        -- Output selected by sel
        case sel is
            when "00" =>
                y <= d0;
            when "01" =>
                y <= d1;
            when "10" =>
                y <= d2;
            when "11" =>
                y <= d3;
            when others =>
                y <= (others => '0'); -- Default case for safety
        end case;
    end process;

end rtl;
