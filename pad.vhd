----------------------------------------------------------------------------------
-- Company: UPMC
-- Engineer: Julien
-- 
-- Gestion de la Raquette
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity pad is
    Port ( 	clk25 : in  STD_LOGIC;							-- Horloge
				reset: in std_logic;								-- Reset Asynchrone
				taille: in std_logic;							-- Paramètre Taille
				freeze: in std_logic;							-- Commande Mode Pause
				rot_left: in std_logic;							-- Commande Deplacement Gauche
				rot_right: in std_logic;						-- Commande Deplacement Droite
				xpos: in std_logic_vector(9 downto 0);		-- Coordonnees X du Pixel Courant
				ypos: in std_logic_vector(9 downto 0);		-- Coordonnees Y du Pixel Courant
				pad: out std_logic;								-- Pixel Appartient a la Raquette
				pad_left: out std_logic;						-- Pixel Appartient a la Moitie Gauche
				pad_right: out std_logic						-- Pixel Appartient a la Moitie Droite
	 );
end pad;

architecture Behavioral of pad is

signal longueur: integer range 0 to 120;		-- Longueur en Pixels de la Raquette
signal moitie: integer range 0 to 60;			-- Longueur / 2

signal xpad: std_logic_vector(9 downto 0);	-- Coordonnees en X de la Raquette
signal ypad: std_logic;								-- Coordonnees en Y de la Raquette

begin

------------------
	-- Taille de la Raquette
	longueur <= 120 when taille = '1' else 60;
	moitie 	<= 60  when taille = '1' else 30;

---------------------------------------------------------------------------

	-- CALCUL DES COORDONNEES DE LA RAQUETTE

	-- Position en Ordonnee
	ypad <= '1' when (ypos > 440) and (ypos < 448) else '0';

	-- Position en Abscisse
	process(clk25,reset)

		begin

		if reset='0' then xpad <= "0110001001"; -- (X = 200)

	elsif rising_edge(clk25) then
	
		-- Si on n'Est pas en Mode Pause
		if freeze='0' then
		
			-- Si Commande de Rotation Gauche
				-- Deplacement a Gauche de la Raquette
			if rot_left='1' then 
				if (xpad > 3) then		-- Pour ne pas Sortir de l'Ecran
					xpad<=xpad-4;
				end if;
		
			-- Si Commande de Rotation Droite
				-- Deplacement a Droite de la Raquette
			elsif rot_right='1' then
				if (xpad < 632-longueur) then 	-- Pour ne pas Sortir de l'Ecran
					xpad<=xpad+4; 
				end if;
			end if;
		end if;
	
	end if;

end process;
-----------------------------------------------------------------

	-- DETERMINATION DES PIXELS ET DES ZONES DE LA RAQUETTE

	process (xpos,ypos,xpad,ypad,longueur,moitie)

		begin

			-- Par Defaut, le Pixel Courant n'Appartient pas a la Raquette
			pad_left <= '0'; pad_right <= '0'; pad <= '0';
	
			-- Si l'Ordonnee Appartient a la Zone de la Raquette
			if ypad='1' then
		
				-- Si l'Abscisse Correspond a la Moitie Gauche de la Raquette
				if (xpos > xpad) and (xpos <= (xpad+moitie)) then
					pad_left <= '1';	pad <= '1';
				
				-- Si l'Abscisse Correspond a la Moitie Gauche de la Raquette
				elsif (xpos > xpad+moitie) and (xpos < (xpad+longueur)) then
					pad_right <= '1'; pad <= '1';
				end if;
			end if;
	end process;

---------------------------------------------------------



end Behavioral;

