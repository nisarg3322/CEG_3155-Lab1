-- This file is a control path for the display controller.
-- It generates the correct control signals based on the input.
library ieee;
use ieee.std_logic_1164.all;

entity controlpath is
    port(
        i_resetBar, left, right : in std_logic;
        i_clock            : in std_logic;
        o_load_left, o_load_right, o_shift_left, o_shift_right, o_load_lmask, o_load_rmask            : out STD_LOGIC);
end controlpath;

architecture rtl of controlpath is
    signal s0, s0_bar, s1, s1_bar, s2, s2_bar, s3, s3_bar, reset : std_logic;

    component dFF_2
        port(
            i_d, i_clock : in std_logic;
            o_q, o_qBar : out std_logic);
    end component;
    begin
        reset <= not i_resetBar;
        o_load_lmask <= s0;
        o_load_rmask <= s0;

        dFF_20: dFF_2 port map(i_d => reset, i_clock => i_clock, o_q => s0, o_qBar => s0_bar);

        dFF_21: dFF_2 port map(i_d => left and right and s0_bar, i_clock => i_clock, o_q => s1, o_qBar => s1_bar);

        dFF_22: dFF_2 port map(i_d => left and s0_bar, i_clock => i_clock, o_q => s2, o_qBar => s2_bar);

        dFF_23: dFF_2 port map(i_d => right and s0_bar, i_clock => i_clock, o_q => s3, o_qBar => s3_bar);

        o_load_left <= s0 or s1 or s2;
        o_load_right <= s0 or s1 or s3;
        o_shift_left <= s1 or s2;
        o_shift_right <= s1 or s3;
end rtl;
