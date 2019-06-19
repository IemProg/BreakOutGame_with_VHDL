----------------------------------------------------------------------------------
-- Company: UPMC
-- Engineer: Julien Denoulet
-- 
-- Generation du Decor
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity decor is
    Port ( visible : in  STD_LOGIC;							-- Zone Visible de l'Image
           xpos : in  STD_LOGIC_VECTOR (9 downto 0);	-- Coordonnee X du Pixel Courant
           ypos : in  STD_LOGIC_VECTOR (9 downto 0);	-- Coordonnee Y du Pixel Courant
           bluebox : out  STD_LOGIC;						-- Pixel Courant = Case Bleue
           bottom : out  STD_LOGIC;							-- Pixel Courant = Bas de l'Ecran
           wall_top : out  STD_LOGIC;						-- Pixel Courant = Mur du Haut
			  wall_left : out  STD_LOGIC;						-- Pixel Courant = Mur de Gauche
			  wall_right : out  STD_LOGIC;					-- Pixel Courant = Mur de Droite
			  wall : out  STD_LOGIC);							-- Pixel Courant = Mur
end decor;

architecture Behavioral of decor is

begin

	-- GESTION DU DECOR
		-- Damier Bleu et Noir de Fond d'Ecran
		-- Mur Haut, Gauche et Droit
		-- Bas d'Ecran
	process (xpos,ypos,visible)

	begin

		wall			<= '0';
		wall_left	<=	'0';
		wall_right	<=	'0';
		wall_top 	<=	'0';
		bottom 		<=	'0';
		bluebox		<=	'0';
		
		-- Si on Est dans la Zone Visible de l'Image
		if visible='1' then 
			
			-- Delimitation des Cases Bleues
				-- Tous les 32x32 Pixels
			bluebox <= xpos(5) xor ypos(5);
		
			-- Mur Gauche
			if (xpos < 4) then 
				wall_left <= '1'; wall <= '1';
			end if;
		
			-- Mur Droit
			if (xpos > 635) then 
				wall_right <= '1'; wall <= '1';
			end if;
		
			-- Mur Haut
			if (ypos < 4) then 
				wall_top <= '1'; wall <= '1';
			end if;
		
			-- Bas de l'ecran
			if (ypos > 475) then 
				bottom <= '1'; 
			end if;
		end if;

	end process;


end Behavioral;

