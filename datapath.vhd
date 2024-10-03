-- This file is a data path which is responsible for the flow of the data based on the input signals received from the control path.
library ieee;
USE ieee.std_logic_1164.ALL;

Entity datapath IS
    PORT(
        i_resetBar, i_load_left, i_load_right, i_shift_left, i_shift_right, i_load_lmask, i_load_rmask, left, right : IN STD_LOGIC;
        i_clock            : IN STD_LOGIC;
        o_Value            : OUT STD_LOGIC_VECTOR(7 downto 0));
END datapath;

architecture rtl of datapath is
    
    signal int_ValueMuxOut : STD_LOGIC_VECTOR(7 downto 0);
    signal int_ValueRight, int_ValueLeft : STD_LOGIC_VECTOR(7 downto 0);
    signal left_shift_out, right_shift_out : STD_LOGIC_VECTOR(7 downto 0);
    signal left_value_out, right_value_out : STD_LOGIC_VECTOR(7 downto 0); 


    component eightBitLeftShiftRegister
        PORT(
            i_resetBar, i_load : IN STD_LOGIC;
            i_clock           : IN STD_LOGIC;
            i_Value           : IN STD_LOGIC_VECTOR(7 downto 0);
            o_Value           : OUT STD_LOGIC_VECTOR(7 downto 0));
    END component;

    component eightBitRegister
        PORT(
            i_resetBar, i_load : IN STD_LOGIC;
            i_clock            : IN STD_LOGIC;
            i_Value            : IN STD_LOGIC_VECTOR(7 downto 0);
            o_Value            : OUT STD_LOGIC_VECTOR(7 downto 0));
    END component;

    component mux2to4
        PORT (
            sel : in  STD_LOGIC_VECTOR(1 downto 0); -- 2-bit select lines
            d0  : in  STD_LOGIC_VECTOR(7 downto 0); -- 8-bit input 0
            d1  : in  STD_LOGIC_VECTOR(7 downto 0); -- 8-bit input 1
            d2  : in  STD_LOGIC_VECTOR(7 downto 0); -- 8-bit input 2
            d3  : in  STD_LOGIC_VECTOR(7 downto 0); -- 8-bit input 3
            y   : out STD_LOGIC_VECTOR(7 downto 0)  -- 8-bit output selected by sel
        );
    END component;

    component eightBitRightShiftRegister
        PORT(
            i_resetBar, i_load : IN STD_LOGIC;
            i_clock           : IN STD_LOGIC;
            i_Value           : IN STD_LOGIC_VECTOR(7 downto 0);
            o_Value           : OUT STD_LOGIC_VECTOR(7 downto 0));
    END component;
begin
    -- load lmask if i_load_lmask is 1 else load shift register output
    int_ValueLeft <= "00000001" when i_load_lmask = '1' else left_shift_out;

    -- load rmask if i_load_rmask is 1 else load shift register output
    int_ValueRight <= "10000000" when i_load_rmask = '1' else right_shift_out;

    -- Instantiate the left shift register
    left_shift_reg: eightBitLeftShiftRegister
        PORT MAP (
            i_resetBar => i_resetBar,
            i_load     => i_shift_left,
            i_clock    => i_clock,
            i_Value    => left_value_out, -- Feed the output of the left register to the shift register
            o_Value    => left_shift_out
        );

    -- Instantiate the right shift register
    right_shift_reg: eightBitRightShiftRegister
        PORT MAP (
            i_resetBar => i_resetBar,
            i_load     => i_shift_right,
            i_clock    => i_clock,
            i_Value    => right_value_out, -- Feed the output of the right register to the shift register
            o_Value    => right_shift_out
        );

    -- Instantiate the left register
    left_reg: eightBitRegister
        PORT MAP (
            i_resetBar => '1',
            i_load     => i_load_left,
            i_clock    => i_clock,
            i_Value    => int_ValueLeft, -- Use int_ValueLeft in this register
            o_Value    => left_value_out -- Output goes to left_shift_reg
        );

    -- Instantiate the right register
    right_reg: eightBitRegister
        PORT MAP (
            i_resetBar => '1',
            i_load     => i_load_right,
            i_clock    => i_clock,
            i_Value    => int_ValueRight, -- Use int_ValueRight in this register
            o_Value    => right_value_out -- Output goes to right_shift_reg
        );

    -- Mux instantiation 
    mux_inst: mux2to4
        PORT MAP (
            sel(0) => left, 
            sel(1) => right,
            d0  => "00000000",
            d1  =>  left_shift_out ,
            d2  => right_shift_out,
            d3  => left_shift_out or right_shift_out, 
            y   => int_ValueMuxOut
        );

    o_Value <= int_ValueMuxOut; -- Output the muxed value depending on the state.

end rtl;


