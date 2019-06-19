----------------------------------------------------------------------------------
-- Company: UPMC
-- Engineer: Julien Denoulet
--
--	Gestion des Briques
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.pong_pack.all;

entity brick_ctrl is
    Port ( xpos :in  std_logic_vector(9 downto 0);	-- Coordonnees X du Pixel Courant
           ypos : in std_logic_vector(9 downto 0);	-- Coordonnees Y du Pixel Courant
           brick_bounce : in tableau;					      -- Drapeaux des Collisions Briques
			     brick : out tableau							        -- Pixel = Brique(i)(j)
			  );
end brick_ctrl;

architecture Behavioral of brick_ctrl is


begin


	-- GESTION DES FLAGS BRIQUE
		-- 1 Flag par Brique
		-- Flag = 1 si la Brique Est Intacte
		-- Flag = 0 si la Brique Est Cassee
	process(ypos,xpos,brick_bounce)

		begin

		-- Pour Chaque Brique
		for i in 0 to 1 loop
			for j in 0 to 8 loop
				if (ypos > 50+i*100) and (ypos < 58+i*100) and -- Coordonnee Ligne
					(xpos > 40+j*64) and (xpos < 88+j*64) and 	-- Coordonnee Colonne
					(brick_bounce(i)(j) = '0') then				-- Brique Non Detruite

						brick(i)(j) <= '1';		-- Ce Pixel est le 1er de la Brique
				else
						brick(i)(j) <= '0';		-- Ce n'est pas le 1er Pixel de la Brique
				end if;
			end loop;
		end loop;
	end process;
-----------------------------------------------------------------------------------------


end Behavioral;
