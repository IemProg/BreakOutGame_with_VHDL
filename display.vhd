----------------------------------------------------------------------------------
-- Company: UPMC
-- Engineer: Julien Denoulet
--
--	Selection des Couleurs des Pixels a Afficher
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.pong_pack.ALL;

entity display is
    Port ( pad : in  STD_LOGIC;			-- Pixel Courant = Raquette
           wall : in  STD_LOGIC;			-- Pixel Courant = Mur
           bluebox : in  STD_LOGIC;		-- Pixel Courant = Case Bleue
           ball : in  STD_LOGIC;			-- Pixel Courant = Balle
           brick : in  tableau;			-- Pixel Courant = Brique
           win : in  STD_LOGIC;			-- Partie Gagnee
           miss : in  STD_LOGIC;			-- Partie Perdue
           red : out  STD_LOGIC;			-- Commande Affichage Rouge
           green : out  STD_LOGIC;		-- Commande Affichage Vert
           blue : out  STD_LOGIC);		-- Commande Affichage Bleu
end display;

architecture Behavioral of display is

begin

	process (pad,wall,bluebox,ball,brick,win,miss)

	begin

		-- LE PIXEL COURAT APPARTIENT AU DECOR

		-- Si le Pixel Courant Appartient a un Mur
		--	Couleur = Blanc
		if wall = '1' then
			red <= '1'; green <= '1'; blue <= '1';

		-- Sinon, si le Pixel Courant Appartient a une case Bleue du Decor
		--	Couleur = Bleu
		elsif bluebox = '1' then
			red <= '0'; green <= '0'; blue <= '1';

		else
		-- Sinon, le Pixel Courant Est Noir S'Il Fait Partie du Decor
		--	Couleur = Bleu
			red <= '0'; green <= '0'; blue <= '0';
		end if;


		-- LE PIXEL COURANT EST UNE BRIQUE

		-- Couleur = Blanc
		for i in 0 to 1 loop
			for j in 0 to 8 loop
				if brick(i)(j)='1' then
					red<='1'; green<='1'; blue<='1';
				end if;
			end loop;
		end loop;

		-- LE PIXEL COURANT APPARTIENT A LA BALLE OU LA RAQUETTE

		-- Couleur = Jaune
		if (pad or ball) = '1' then
			red <= '1'; green <= '1'; blue <= '0';
		end if;

		-- PARTIE GAGNEE -> Couleur Vert
		-- PARTIE PERDUE -> Couleur Rouge

		if win = '1' then
			red <= '0'; green <= '1'; blue <= '0';
      if( (xpos>47 and xpos<95 and ypos>123 and ypos<317) or (xpos>122 and xpos<169 and ypos>123 and ypos<317) or (xpos>197 and xpos<244 and ypos>123 and ypos<317)
       or (xpos>94 and xpos<123 and ypos>272 and ypos<317) or (xpos>168 and xpos<198 and ypos>272 and ypos<317) or (xpos>302 and xpos<349 and ypos>123 and ypos<317)
       or (xpos>408 and xpos<449 and ypos>123 and ypos<317) or (xpos>471 and xpos<512 and ypos>123 and ypos<317) or (xpos>537 and xpos<577 and ypos>123 and ypos<317)
       or (xpos>448 and xpos<472 and ypos>123 and ypos<168) or (xpos>511 and xpos<538 and ypos>272 and ypos<317)
      )then
              red <= '1'; green <= '1'; blue <= '1';
      else
              red <= '0'; green <= '1'; blue <= '0';
      end if;

		elsif miss='1' then
			red <= '1'; green <= '0'; blue <= '0';
      		if( (xpos>172 and xpos<220 and ypos>47 and ypos<214) or (xpos>219 and xpos<289 and ypos>173 and ypos<214) or (xpos>314 and xpos<346 and ypos>47 and ypos<214)
      		 or (xpos>396 and xpos<428 and ypos>47 and ypos<214) or (xpos>345 and xpos<397 and ypos>47 and ypos<92) or (xpos>345 and xpos<397 and ypos>169 and ypos<214)
               or (xpos>172 and xpos<289 and ypos>249 and ypos<290) or (xpos>172 and xpos<289 and ypos>314 and ypos<351) or (xpos>172 and xpos<289 and ypos>375 and ypos<412)
               or (xpos>172 and xpos<211 and ypos>288 and ypos<315) or (xpos>248 and xpos<289 and ypos>350 and ypos<376) or (xpos>314 and xpos<431 and ypos>249 and ypos<290)
               or (xpos>314 and xpos<346 and ypos>249 and ypos<376) or (xpos>314 and xpos<431 and ypos>314 and ypos<351) or (xpos>314 and xpos<431 and ypos>375 and ypos<412)
                 )then
                     red <= '1'; green <= '1'; blue <= '1';
                 else
                     red <= '1'; green <= '0'; blue <= '0';
                 end if;

		end if;

end process;


end Behavioral;
