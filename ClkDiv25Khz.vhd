----------------------------------------------------------------------------------
-- Company: Imad Eddine MAROUF
-- Engineer: 
-- 
-- Create Date: 28.03.2019 14:39:49
-- Project Name: CasseBrique 
-- Additional Comments:
-- Module Name: ClkDiv25Khz - Behavioral
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

entity ClkDiv25Khz is
	port ( clk,reset: in std_logic;
	clock_out: out std_logic);
end ClkDiv25Khz;

architecture Behavioral of ClkDiv25Khz is
signal count: integer:=1;
signal tmp : std_logic := '0';

begin
    process(clk,reset)
        begin
            if(reset='0') then
                count<=1;
                tmp<='0';
            elsif(clk'event and clk='1') then
                count <=count+1;
                if (count = 600000) then
                    tmp <= NOT tmp;
                    count <= 1;
                end if;
            end if;
        clock_out <= tmp;
	end process;

end Behavioral;
