----------------------------------------------------------------------------------
-- Company: UPMC
-- Engineer: Julien Denoulet
--
--	Gestion des Objets du Jeu (Balle, Raquette, Briques, Decor)
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.std_logic_arith.all;
use work.pong_pack.ALL;

entity objects is
    Port ( 	clk25 : in  STD_LOGIC;								-- Horloge 25 MHz
				clk5Hz	: in STD_LOGIC;
				reset : in  STD_LOGIC;								-- Reset Asynchrone

				-- SIGNAUX DU CTRL VGA
				visible : in  STD_LOGIC;							-- Zone Visible de l'Image
				endframe : in  STD_LOGIC;							-- Signal de Fin de Trame
				xpos : in  STD_LOGIC_VECTOR (9 downto 0);		-- Coordonnee X du Pixel Courant
				ypos : in  STD_LOGIC_VECTOR (9 downto 0);		-- Coordonnee Y du Pixel Courant

				-- SIGNAUX ENCODEUR ROTATIF
				rot_left: in std_logic;								-- Commande Deplacement Gauche
				rot_right: in std_logic;							-- Commande Deplacement Droite

				-- MODES DU JEU
				taille: in std_logic;								-- Paramtre Taille
				speed : in  STD_LOGIC;								-- Vitesse du Jeu
				freeze: in std_logic;								-- Commande Mode Pause
				miss_timer: in std_logic_vector(5 downto 0);	-- Mode Echec

				-- OBJETS CORRESPONDANT AU PIXEL COURANT
				bluebox : out  STD_LOGIC;							-- Pixel Courant = Case Bleue
				bottom : out  STD_LOGIC;							-- Pixel Courant = Bas de l'Ecran
				wall : out  STD_LOGIC;								-- Pixel Courant = Mur
				pad: out std_logic;									-- Pixel Appartient a la Raquette
				brick: out tableau;									-- Pixel Courant = Brique
				brick_bounce : out tableau;						-- Rebond Contre une Brique
				briquecasse : out std_logic;
				ball : out  STD_LOGIC								-- Pixel Courant = Balle
        score : out std_logic_vector(7 downto 0) -- score de jeux
			  );
end objects;

architecture Behavioral of objects is

signal wall_top : STD_LOGIC;				-- Pixel Courant = Mur du Haut
signal wall_left :STD_LOGIC;				-- Pixel Courant = Mur de Gauche
signal wall_right: STD_LOGIC;				-- Pixel Courant = Mur de Droite
signal pad_tmp: std_logic;					-- Pixel Courant = Raquette
signal pad_left: std_logic;				-- Pixel Appartient a la Moitie Gauche
signal pad_right: std_logic;				-- Pixel Appartient a la Moitie Droite
signal pad_left_bounce : STD_LOGIC;		-- Rebond Contre Moitie Gauche de Raquette
signal pad_right_bounce : STD_LOGIC;	-- Rebond Contre Moitie Droite de Raquette
signal xbounce : STD_LOGIC;				-- Rebond Horizontal
signal ybounce : STD_LOGIC;				-- Rebond Vertical
signal brick_tmp : tableau;				-- Rebond Vertical
signal brick_bounce_tmp: tableau;		-- Rebond Vertical
signal ball_tmp: std_logic;				-- Pixel Courant = Balle
signal briquecasse_tmp : std_logic;
signal score : std_logic_vector(3 downto 0);

begin

	-- GESTION DU DECOR
	fond_ecran: entity work.decor
		port map (
			visible 		=> visible,		-- Zone Visible de l'Image
			xpos 			=> xpos,			-- Coordonnee X du Pixel Courant
         ypos 			=> ypos,			-- Coordonnee Y du Pixel Courant
         bluebox 		=> bluebox,		-- Pixel Courant = Case Bleue
         bottom 		=> bottom,		-- Pixel Courant = Bas de l'Ecran
         wall_top 	=> wall_top,	-- Pixel Courant = Mur du Haut
			wall_left	=> wall_left,	-- Pixel Courant = Mur de Gauche
			wall_right 	=> wall_right, -- Pixel Courant = Mur de Droite
			wall 			=>	wall);		-- Pixel Courant = Mur

----------------------------------------------------------------------


	pad <= pad_tmp;

	-- CONTROLEUR DE RAQUETTE
	pad_ctrl: entity work.pad
		port map (
			clk25 => clk5Hz,				-- Horloge
			reset => reset,				-- Reset Asynchrone
			taille => taille,				-- Commande de Taille Raquette
			freeze => freeze,				-- Commande de Pause du Jeu
			rot_left => rot_left,		-- Commande de Rotation a Gauche
			rot_right => rot_right,		-- Commande de Rotation a Droite
			xpos => xpos,					-- Coordonnee X du Pixel Courant
			ypos => ypos,					-- Coordonnee Y du Pixel Courant
			pad => pad_tmp,				-- Pixel Appartient a la Raquette
			pad_left => pad_left,		-- Pixel Appartient a Moitie Gauche
			pad_right => pad_right);	-- Pixel Appartient a Moitie Droite

---------------------------------------------------------------------------

	-- GESTION DES REBONDS
	bounce_ctrl: entity work.bounce
		port map (
			clk25 				=> clk25,				-- Horloge
         reset 				=> reset,				-- Reset Asynchrone
			endframe 			=> endframe,			-- Signal Fin de Trame
         ball 					=> ball_tmp,			-- Pixel Courant = Balle
			pad 					=> pad_tmp,					-- Pixel Courant = Raquette
			pad_left 			=> pad_left,			-- Pixel Courant = Moiti Gauche
			pad_right 			=> pad_right,			-- Pixel Courant = Moiti Droite
			wall_left 			=> wall_left,			-- Pixel Courant = Mur Gauche
			wall_right 			=> wall_right,			-- Pixel Courant = Mur Droit
			wall_top 			=> wall_top,			-- Pixel Courant = Mur Haut
			brick 				=> brick_tmp,				-- Pixel Courant = Brique
			xbounce 				=> xbounce,				-- Rebond Horizontal
      ybounce 				=> ybounce,				-- Rebond Vertical
         briquecasse            => briquecasse_tmp,
         brick_bounce 		=> brick_bounce_tmp,		-- Rebond sur une Brique
         pad_left_bounce 	=> pad_left_bounce,	-- Rebond sur Partie Gauche de Raquette
         pad_right_bounce	=> pad_right_bounce,	-- Rebond sur Partie Droite de Raquette
         score => score
		);

	monostable_inst : entity work.monostable(comport)
        port map(
            clk => clk25,
            reset => reset,
            commande => briquecasse_tmp,
            impulse => briquecasse);
---------------------------------------------------------------------------------------

	ball <= ball_tmp;

	-- GESTION DE LA BALLE
	ball_ctrl: entity work.ball
		port map (
			clk25 				=> clk25,				-- Horloge
         reset 				=> reset,				-- Reset Asynchrone
			endframe 			=> endframe,			-- Signal Fin de Trame
         freeze				=> freeze,				-- Mode Pause
         speed					=> speed,				-- Vitesse du Jeu
			miss_timer 			=> miss_timer,			-- Partie Perdue
			xbounce 				=> xbounce,				-- Rebond Horizontal
         ybounce 				=> ybounce,				-- Rebond Vertical
         pad_left_bounce 	=> pad_left_bounce,	-- Rebond sur Partie Gauche de Raquette
         pad_right_bounce	=> pad_right_bounce,	-- Rebond sur Partie Droite de Raquette
			xpos 					=> xpos,					-- Coordonnee X du Pixel Courant
         ypos 					=> ypos,					-- Coordonnee Y du Pixel Courant
			ball 					=> ball_tmp				-- Pixel Courant = Balle
		);

-----------------------------------------------------------------------------------

	-- GESTION DES BRIQUES

	process(brick_tmp,brick_bounce_tmp)

	begin

		for i in 0 to 1 loop
			for j in 0 to 8 loop
				brick_bounce(i)(j) <= brick_bounce_tmp(i)(j);
				brick(i)(j) <= brick_tmp(i)(j);
			end loop;
		end loop;
	end process;

	brick_ctrl: entity work.brick_ctrl
		port map (
			xpos 					=> xpos,					-- Coordonnee X du Pixel Courant
      ypos 					=> ypos,					-- Coordonnee Y du Pixel Courant
			brick_bounce		=> brick_bounce_tmp,	-- Drapeaux des Collisions Briques
			brick 				=> brick_tmp			-- Pixel Courant = Brique
		);

--------------------------------------------------------------------------------------

end Behavioral;
