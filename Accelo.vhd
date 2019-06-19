----------------------------------------------------------------------------------
-- Company: Imad Eddine MAROUF
-- Engineer: 
-- 
-- Create Date: 23.03.2019 14:51:33
-- Design Name: 
-- Module Name: Accelo - Behavioral
-- Project Name: CasseBrique 
-- Additional Comments:
-- 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_signed.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Accelo is
   Port
   (
   sysclock     : in STD_LOGIC; -- System Clock
   RESET      : in STD_LOGIC;
   
   --ACCEL_TMP  : out STD_LOGIC_VECTOR (11 downto 0);
   --Data_Ready : out STD_LOGIC;

   -- Accelerometer data signals
   --LED_X    : out STD_LOGIC_VECTOR (11 downto 0);
   LED_Y    : out STD_LOGIC_VECTOR (11 downto 0);
   --LED_Z    : out STD_LOGIC_VECTOR (11 downto 0);

   --SPI Interface Signals
   SCLK       : out STD_LOGIC;
   MOSI       : out STD_LOGIC;
   MISO       : in STD_LOGIC;
   SS         : out STD_LOGIC;
   
   rot_left : out STD_LOGIC;
   rot_right : out STD_LOGIC
);
end Accelo;

architecture Behavioral of Accelo is

signal x_output : std_logic_vector(11 downto 0);
signal y_output : std_logic_vector(11 downto 0);
signal z_output : std_logic_vector(11 downto 0);

signal   dataready   : STD_LOGIC;
signal   accel   : STD_LOGIC_VECTOR (11 downto 0);

signal SC_LK : STD_LOGIC;
signal  MO_SI  : STD_LOGIC;
signal   s_s   : STD_LOGIC;
signal  rec : STD_LOGIC_VECTOR(5 downto 0); 

begin

--Calling the clock divider
    --CompDiv: entity work.ClkDiv(Behavioral)
    --port map(clk100 => sysclock, reset => RESET, clk25 => clk_int);

    Acceler: entity work.ADXL362Ctrl(Behavioral)
    Port map(SYSCLK => sysclock, RESET => RESET, MISO => MISO, ACCEL_X => x_output, ACCEL_Y => y_output, ACCEL_Z => z_output, 
                    SCLK => SC_LK, MOSI => MO_SI, SS => S_S, Data_Ready => dataready, ACCEL_TMP => accel);
    
    
    rec(5 downto 0) <=  y_output(11 downto 6);
    
    rot_left <= '1' when rec > "000010" else '0';
    rot_right <= '1' when rec < "111110" else '0';

    SCLK <= SC_LK;
    MOSI <= MO_SI;
    SS   <= S_S;
    
    LED_Y <= y_output;
    --LED_X <= x_output;
    --LED_Z <= z_output;
    
    --ACCEL_TMP <= accel;
    --Data_Ready <= dataready;
end Behavioral;
