-- ============================================================================
-- 
-- DESCRIPTION:
-- This VHDL file contains the implementation of a display controller.
-- The display controller is responsible for managing the output to a display
-- device, handling the necessary inputs and control signals. To display left or right -- shift of the LED lights. ============================================================================

library ieee;
use ieee.std_logic_1164.all;

entity displaycontroller is
    port(
        i_reset, left, right : in std_logic;
        i_clock            : in std_logic;
        o_display            : out STD_LOGIC_VECTOR(7 downto 0));
end displaycontroller;

architecture rtl of displaycontroller is
    signal i_resetBar : std_logic;
    signal o_Value : std_logic_vector(7 downto 0);
    signal i_load_left, i_load_right, i_shift_left, i_shift_right, i_load_lmask, i_load_rmask : std_logic;
    
    component datapath
        port(
            i_resetBar, i_load_left, i_load_right, i_shift_left, i_shift_right, i_load_lmask, i_load_rmask, left, right : in std_logic;
            i_clock            : in std_logic;
            o_Value            : out STD_LOGIC_VECTOR(7 downto 0));
    end component;

    component controlpath
        port(
            i_resetBar, left, right : in std_logic;
            i_clock            : in std_logic;
            o_load_left, o_load_right, o_shift_left, o_shift_right, o_load_lmask, o_load_rmask            : out STD_LOGIC);
    end component;

    begin
        i_resetBar <= not i_reset;
        controlpath_inst: controlpath 
            port map(
                i_resetBar => i_resetBar,
                left => left,
                right => right,
                i_clock => i_clock,
                o_load_left => i_load_left,
                o_load_right => i_load_right,
                o_shift_left => i_shift_left,
                o_shift_right => i_shift_right,
                o_load_lmask => i_load_lmask,
                o_load_rmask => i_load_rmask
            );

        datapath_inst: datapath
            port map(
                i_resetBar => i_resetBar,
                i_load_left => i_load_left,
                i_load_right => i_load_right,
                i_shift_left => i_shift_left,
                i_shift_right => i_shift_right,
                i_load_lmask => i_load_lmask,
                i_load_rmask => i_load_rmask,
                left => left,
                right => right,
                i_clock => i_clock,
                o_Value => o_Value
            );
        
        o_display <= o_Value;
end rtl;
            