----------------------------------------------------------------------------------
-- Company: Sorbonne Université (ex: UPMC)
-- Engineer: Imad Eddine MAROUF
-- 
-- Create Date: 28.03.2019 15:17:24
-- Design Name: 
-- Module Name: score_to_segment - Behavioral
-- Project Name: CasseBrique 
-- Additional Comments:
-- Reference: 
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;

entity score_to_segment is
    port (
        i_Clk        : in  std_logic;
        reset: in std_logic;
        i_Binary_Num : in  std_logic_vector(3 downto 0);
        o_Segment_A  : out std_logic;
        o_Segment_B  : out std_logic;
        o_Segment_C  : out std_logic;
        o_Segment_D  : out std_logic;
        o_Segment_E  : out std_logic;
        o_Segment_F  : out std_logic;
        o_Segment_G  : out std_logic
        );
end score_to_segment;

architecture Behavioral of score_to_segment is
signal r_Hex_Encoding : std_logic_vector(7 downto 0) := (others => '0');

begin   
  -- Purpose: Creates a case statement for all possible input binary numbers.
  -- Drives r_Hex_Encoding appropriately for each input combination.
  process (i_Clk) is
  begin
    if rising_edge(i_Clk) then
      case i_Binary_Num is
        when "0000" =>
          r_Hex_Encoding <= X"7E";
        when "0001" =>
          r_Hex_Encoding <= X"30";
        when "0010" =>
          r_Hex_Encoding <= X"6D";
        when "0011" =>
          r_Hex_Encoding <= X"79";
        when "0100" =>
          r_Hex_Encoding <= X"33";          
        when "0101" =>
          r_Hex_Encoding <= X"5B";
        when "0110" =>
          r_Hex_Encoding <= X"5F";
        when "0111" =>
          r_Hex_Encoding <= X"70";
        when "1000" =>
          r_Hex_Encoding <= X"7F";
        when "1001" =>
          r_Hex_Encoding <= X"7B";
        when "1010" =>                  -- A
          r_Hex_Encoding <= X"77";
        when "1011" =>                 --- B
          r_Hex_Encoding <= X"1F";
        when "1100" =>                 --- C
          r_Hex_Encoding <= X"4E";
        when "1101" =>                 --- D
          r_Hex_Encoding <= X"3D";
        when "1110" =>                 --- E
          r_Hex_Encoding <= X"4F";
        when "1111" =>                 --- F
          r_Hex_Encoding <= X"47";
      end case;
    end if;
  end process;
 
  -- r_Hex_Encoding(7) is unused
  o_Segment_A <= r_Hex_Encoding(6);
  o_Segment_B <= r_Hex_Encoding(5);
  o_Segment_C <= r_Hex_Encoding(4);
  o_Segment_D <= r_Hex_Encoding(3);
  o_Segment_E <= r_Hex_Encoding(2);
  o_Segment_F <= r_Hex_Encoding(1);
  o_Segment_G <= r_Hex_Encoding(0);

end Behavioral;
