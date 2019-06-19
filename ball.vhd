----------------------------------------------------------------------------------
-- Company: UPMC
-- Engineer: Julien Denoulet
-- 
--	Gestion de la Balle
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ball is
    Port ( clk25 : in  STD_LOGIC;								-- Horloge
           reset : in  STD_LOGIC;								-- Reset Asynchrone
           endframe : in  STD_LOGIC;							-- Fin de Trame
           freeze : in  STD_LOGIC;								-- Commande Pause
           speed : in  STD_LOGIC;								-- Vitesse du Jeu
           miss_timer: in std_logic_vector(5 downto 0);	-- Mode Echec
			  xbounce : in  STD_LOGIC;								-- Rebond Horizontal
           ybounce : in  STD_LOGIC;								-- Rebond Vertical
           pad_left_bounce : in  STD_LOGIC;					-- Rebond sur Moitie Gauche Raquette
           pad_right_bounce : in  STD_LOGIC;					-- Rebond sur Moitie Droite Raquette
           xpos : in  STD_LOGIC_VECTOR(9 downto 0);		-- Coordonnees X de la Raquette
           ypos : in  STD_LOGIC_VECTOR(9 downto 0);		-- Coordonnees Y de la Raquette
           ball : out  STD_LOGIC);								-- Pixel Courant = Balle
end ball;

architecture Behavioral of ball is

signal xballdir,yballdir: std_logic;					-- Direction de la Balle
signal xball,yball: std_logic_vector(9 downto 0);	-- Coordonnees de la Balle

signal inc: integer range 0 to 4;					-- Pas de Deplacement de la Balle

begin


	-- Pas de Deplacement de la Balle
	-- 	en Fonction de la Vitesse
	inc <= 4 when speed = '1' else 2;


----------------------------------------------------------------------

	-- GESTION DE LA DIRECTION DE LA BALLE
		-- XBallDir: 0 = Gauche / 1 = Droite
		-- YBallDir: 0 = Haut 	/ 1 = Bas
	
	process(clk25,reset)

		begin
	
			if reset = '0' then
	
				-- Au Reset, la Balle va en Bas à Droite
				xballdir <= '1'; yballdir <= '1';

			elsif rising_edge(clk25) then
	
				-- Si on Est a la Fin de l'Image
				if endframe = '1' then
			
					-- Si on a Repéré une Collision Horizontale
					--		au Cours de Cette Image
					if xbounce = '1' then 
						-- Changement de Direction Horizontale
						xballdir <= not xballdir; 
					end if;
			
					-- Si on a Repéré une Collision Verticale
					--		au Cours de Cette Image
					if ybounce = '1' then 
						-- Changement de Direction Verticale
						yballdir <= not yballdir;
					end if;
				
					-- Si on a Repéré une Collision avec la Moitie Gauche
						--		de la Raquette au Cours de Cette Image
					if pad_left_bounce='1' then 
						-- La Balle Doit Repartir vers la Gauche
						xballdir<='0'; 
					end if;

					-- Si on a Repéré une Collision avec la Moitie Droite
						--		de la Raquette au Cours de Cette Image
					if pad_right_bounce='1' then 
						-- La Balle Doit Repartir vers la Droite
						xballdir<='1'; 
					end if;
				end if;
			end if;
	end process;

----------------------------------------------------------------------

	-- CALCUL PROCHAINE PROSITION DE LA BALLE
	process (clk25,reset)

		begin

			if reset='0' then 
				-- Position Intiale
				xball <= "0101100000"; -- 352
				yball <= "0010100000"; -- 160
	
			elsif rising_edge(clk25) then

				-- Si on Est pas en Mode Pause
				-- Si on Est a la Fin de l'Image
				--		On Remet a Jour la Position de la Balle
				if freeze = '0' and endframe = '1' then
			
					-- Si la Balle Va Vers la Gauche et Rebondit sur un Mur Latéral
					-- OU Si la Balle Va vers la Droite Sans Rebond sur un Mur Lateral
					if (xbounce xor xballdir) = '1' then
						
						-- Alors la Balle doit Aller vers la Droite
						xball <= xball + inc;
					
					-- Sinon, la Balle doit Aller a Gauche
					else
						xball <= xball - inc;
					end if;

			
					-- Si la Balle Va Vers le Bas et Rebondit sur la Raquette ou une Brique
					-- OU Si la Balle Va vers le Haut sans Rebondir Nulle Part
					if (ybounce xor yballdir) = '1' then
					
						-- La Balle Doit Repartir vers le Haut
						yball <= yball + inc;

					-- Sinon, la Balle doit Aller vers le Haut
					else
						-- Incrementation en Fonction de la Vitesse
						yball <= yball - inc;
					end if;
			
				end if;

				-- Si on Est en Mode "Perdu"
				-- On Remet la Balle en Position Initiale
				if (endframe = '1') and (miss_timer /= 0) then 
					xball <= "0101100000";
					yball <= "0010100000";
				end if;
			end if;
	end process;

------------------------------------------------------------------

	-- GESTION DU FLAG BALLE
		-- Flag = 1 si le Pixel Courant
		-- Est un des 64 Pixels de la Balle
	process (xball,yball,xpos,ypos)

		begin

			ball <= '0';
	
			if (xpos >= xball) and (xpos <= xball+7) and
				(ypos >= yball) and (ypos <= yball+7) then
					ball<='1';
			end if;

	end process;

------------------------------------------------------------------


end Behavioral;

