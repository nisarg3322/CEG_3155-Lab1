LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY eightBitRightShiftRegister IS
    PORT(
        i_resetBar, i_load : IN STD_LOGIC;
        i_clock           : IN STD_LOGIC;
        i_Value           : IN STD_LOGIC_VECTOR(7 downto 0);
        o_Value           : OUT STD_LOGIC_VECTOR(7 downto 0));
END eightBitRightShiftRegister;

ARCHITECTURE rtl OF eightBitRightShiftRegister IS
    SIGNAL int_Value, int_notValue : STD_LOGIC_VECTOR(7 downto 0);

    COMPONENT enARdFF_2
        PORT(
            i_resetBar : IN STD_LOGIC;
            i_d        : IN STD_LOGIC;
            i_enable   : IN STD_LOGIC;
            i_clock    : IN STD_LOGIC;
            o_q, o_qBar : OUT STD_LOGIC);
    END COMPONENT;

BEGIN

-- MSB Flip-Flop (7th bit)
msb: enARdFF_2
    PORT MAP (
        i_resetBar => i_resetBar,
        i_d => i_Value(7), 
        i_enable => i_load,
        i_clock => i_clock,
        o_q => int_Value(6),
        o_qBar => int_notValue(6));

-- 6th Bit Flip-Flop
bit6: enARdFF_2
    PORT MAP (
        i_resetBar => i_resetBar,
        i_d => i_Value(6),
        i_enable => i_load, 
        i_clock => i_clock,
        o_q => int_Value(5),
        o_qBar => int_notValue(5));

-- 5th Bit Flip-Flop
bit5: enARdFF_2
    PORT MAP (
        i_resetBar => i_resetBar,
        i_d => i_Value(5),
        i_enable => i_load, 
        i_clock => i_clock,
        o_q => int_Value(4),
        o_qBar => int_notValue(4));

-- 4th Bit Flip-Flop
bit4: enARdFF_2
    PORT MAP (
        i_resetBar => i_resetBar,
        i_d => i_Value(4),
        i_enable => i_load, 
        i_clock => i_clock,
        o_q => int_Value(3),
        o_qBar => int_notValue(3));

-- 3rd Bit Flip-Flop
bit3: enARdFF_2
    PORT MAP (
        i_resetBar => i_resetBar,
        i_d => i_Value(3),
        i_enable => i_load, 
        i_clock => i_clock,
        o_q => int_Value(2),
        o_qBar => int_notValue(2));

-- 2nd Bit Flip-Flop
bit2: enARdFF_2
    PORT MAP (
        i_resetBar => i_resetBar,
        i_d => i_Value(2),
        i_enable => i_load, 
        i_clock => i_clock,
        o_q => int_Value(1),
        o_qBar => int_notValue(1));

-- 1st Bit Flip-Flop
bit1: enARdFF_2
    PORT MAP (
        i_resetBar => i_resetBar,
        i_d => i_Value(1),
        i_enable => i_load, 
        i_clock => i_clock,
        o_q => int_Value(0),
        o_qBar => int_notValue(0));

-- LSB Flip-Flop (0th bit)
lsb: enARdFF_2
    PORT MAP (
        i_resetBar => i_resetBar,
        i_d => i_Value(0), 
        i_enable => i_load,
        i_clock => i_clock,
        o_q => int_Value(7),
        o_qBar => int_notValue(7));

-- Output Driver
o_Value <= int_Value;

END rtl;
