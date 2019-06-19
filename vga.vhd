----------------------------------------------------------------------------------
-- Company: UPMC
-- Engineer: Julien Denoulet
--
--	Controleur VGA - Generation des Coordonnees Pixels et Signaux de Synchro
-- 
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity VGA is
port (
		clk25,reset: in std_logic;							-- Horloge, Reset Asynchrone
		r,g,b: in std_logic_vector(3 downto 0);									-- Couleur Envoyee par le Controleur de Jeu
		red,green,blue: out std_logic_vector(3 downto 0);						-- Affichage Couleur vers Ecran VGA
		hsync,vsync: out std_logic;						-- Synchro Ligne (H) et Trame (V)
		visible: out std_logic;								-- Partie Visible de l'Image
		endframe: out std_logic;							-- Dernier Pixel Visible d'une Trame
		xpos,ypos: out std_logic_vector(9 downto 0)	-- Coordonnees du Pixel Courant
	);
end VGA;

architecture archi of VGA is

-- Compteur Coordonnnees Pixel
signal xcord,ycord: std_logic_vector(9 downto 0);

-- Signal de Fin de Ligne
signal endline: std_logic;

begin

	-- Affichage Couleur
	red <= r; green <= g; blue <= b;


	-- Affectation en Sortie des Coordonnnees Pixel
	xpos <= xcord; 
	ypos <= ycord;

	-- Partie Visible de l'Image (Matrice 640 Colonnes x 480 Lignes)
	visible <= '1' when (xcord < 640) and (ycord < 480)
	else '0';

	-- Signal de Fin de Ligne (Partie Visible + Non Visible)
	endline <='1' when xcord = 799 else '0';

	-- Fin de Trame (Dernier Pixel Visible de l'Image
	endframe <='1' when (xcord=0) and (ycord=480) else '0';

-------------------------------------------------------------------------
	-- COMPTEURS LIGNE ET COLONNE
	process(clk25,reset)

		begin

			if reset = '0' then 
			
				xcord <= (others=>'0');
				ycord <= (others=>'0');
		
			elsif rising_edge(clk25) then
				
				-- Incrementation Compteur Colonne
				xcord <= xcord + 1;
			
				-- Si on Arrive en Fin de Ligne
				if (endline = '1') then
				
					-- RAZ Compteur Colonne
					xcord <= (others=>'0');
				
					-- Incrementation Compteur Ligne
					-- RAZ apres 521 Lignes
					if (ycord = 520) then 
						ycord <= (others =>'0');
					else 
						ycord <= ycord + 1;
					end if;

				end if;

			end if;
	end process;

	
-------------------------------------------------------------------------
	-- GENERATION DES SIGNAUX DE SYNCHRO
	
		-- SYNCHRO LIGNE (HSYNC)
			-- Colonne 0 	--> 639 : Partie Visible
			-- Colonne 640 --> 664 : Pre-Synchro
			-- Colonne 665 --> 759 : Synchro
			-- Colonne 760 --> 799 : Post-Synchro
	
		-- SYNCHRO TRAME (VSYNC)
			-- Colonne 0 	--> 479 : Partie Visible
			-- Colonne 480 --> 489 : Pre-Synchro
			-- Colonne 490 --> 491 : Synchro
			-- Colonne 492 --> 520 : Post-Synchro
	
	process (clk25,reset)

		begin
	
			if reset = '0' then
		
				hsync <= '1';
				vsync <= '1';
		
			elsif rising_edge(clk25) then
		
				-- Synchro Ligne
				if (xcord > 664) and (xcord <= 759) then 
					hsync <= '0';
				else 
					hsync <= '1';
				end if;
		
				-- Synchro Trame
				if (ycord = 490) or (ycord = 491) then 
					vsync <= '0';
				else
					vsync <= '1';
				end if;
		
			end if;
	end process;

end archi;