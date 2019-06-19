----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date:    14:29:20 02/08/2013
-- Design Name:
-- Module Name:    bounce - Behavioral
-- Project Name:
-- Target Devices:
-- Tool versions:
-- Description:
--
-- Dependencies:
--
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
----------------------------------------------------------------------------------
library IEEE,work;
use IEEE.STD_LOGIC_1164.ALL;
use work.pong_pack.all;


entity bounce is
    Port ( 	clk25 : in  STD_LOGIC;				    -- Horloge
				reset : in  STD_LOGIC;				-- Reste Asynchrone
				endframe : in  STD_LOGIC;			-- Signal de Fin de Trame
				ball : in  STD_LOGIC;				-- Pixel Courant = Balle
				pad : in  STD_LOGIC;				-- Pixel Courant = Raquette
				pad_left : in  STD_LOGIC;			-- Pixel Courant = Moitie Gauche
				pad_right : in  STD_LOGIC;			-- Pixel Courant = Moitie Droite
				wall_left : in  STD_LOGIC;			-- Pixel Courant = Mur Gauche
				wall_right : in  STD_LOGIC;		    -- Pixel Courant = Mur Droit
				wall_top : in  STD_LOGIC;			-- Pixel Courant = Mur Haut
				brick: in tableau;					-- Pixel Courant = Brique
        xbounce : out  STD_LOGIC;			-- Rebond Horizontal
				ybounce : out  STD_LOGIC;			-- Rebond Vertical
				briquecasse : out STD_LOGIC;
				brick_bounce : out  tableau;		-- Rebond Contre une Brique
				pad_left_bounce : out STD_LOGIC;	-- Rebond Contre Moitie Gauche de Raquette
				pad_right_bounce : out STD_LOGIC	-- Rebond Contre Moitie Droite de Raquette
        score : out std_logic_vector(3 downto 0);
			);
end bounce;

architecture Behavioral of bounce is
signal score : std_logic_vector(7 downto 0);
begin

	-- GESTION DES REBONDS
	process(clk25,reset)

		begin

			-- Au Reset, pas de Rebond sur les Murs,
			--		la Raquette ou les Briques
			if reset = '0' then

				xbounce <= '0'; ybounce <= '0'; briquecasse <= '0';
				pad_left_bounce <= '0'; pad_right_bounce <= '0'; score <= '0';

				for i in 0 to 1 loop
					for j in 0 to 8 loop
						brick_bounce(i)(j) <= '0';
					end loop;
				end loop;

			elsif rising_edge(clk25) then

				-- Si on n'Est pas a la Fin de l'Image
				if endframe = '0' then

					-- Collision sur le Mur Gauche ou Droit
					if ball = '1' then

						-- Collision avec le Mur Gauche ou Droit
						if (wall_left or wall_right) = '1' then
							xbounce <= '1';
							briquecasse <= '0';

						end if;

						-- Collision avec le Mur Haut ou la Raquette
						if (pad or wall_top) = '1' then
							ybounce <= '1';
							briquecasse <= '0';
						end if;

						-- Collision avec Partie Gauche de la Raquette
						if (pad_left = '1') then
							pad_left_bounce <= '1';
							briquecasse <= '0';
						end if;

						-- Collision avec Partie Droite de la Raquette
						if (pad_right = '1') then
							pad_right_bounce <= '1';
							briquecasse <= '0';
						end if;

						-- Collision avec une Brique
						for i in 0 to 1 loop
							for j in 0 to 8 loop
								if brick(i)(j) = '1' then
									brick_bounce(i)(j) <= '1';
									ybounce <= '1';
									briquecasse <='1';
                  score <= score + '1';
								end if;
							end loop;
						end loop;
					end if;

			-- Si on Est a la Fin de l'Image
			else

				-- Reinitialisation des Flags de Rebond
				xbounce <= '0'; ybounce <= '0'; briquecasse <= '0';
				pad_left_bounce <= '0'; pad_right_bounce <= '0';

			end if;
		end if;
	end process;


end Behavioral;
