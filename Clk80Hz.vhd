----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01.04.2019 19:08:19
-- Design Name: 
-- Module Name: Clk80Hz - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Clk80Hz is
    Port ( clk100,reset : in  STD_LOGIC;	-- Horloge 100 Mhz et Reset Asynchrone
           clk80 : out  STD_LOGIC);			-- Horloge 25 MHz
end Clk80Hz;

architecture Behavioral of Clk80Hz is

-- Registre Horloge 80Hz
signal clk: std_logic_vector(15 downto 0);

begin

-- Affectation Port de Sortie
clk80<=clk(15);

--------------------------------------------
-- DIVISION PAR 4 DE L'HORLOGE 100 MHZ
process(clk100,reset)
	begin
		if reset = '0' then 
			clk <= x"30DA";
		elsif rising_edge(clk100) then
			clk <= clk + '1';
		end if;
end process;
	

end Behavioral;
