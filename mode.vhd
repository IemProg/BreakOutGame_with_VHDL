----------------------------------------------------------------------------------
-- Company: UPMC
-- Engineer: Julien Denoulet
--
--	Gestion du Jeu (Mode Pause, Gagne / Perdu)
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.pong_pack.ALL;

entity mode is
    Port ( clk25 : in  STD_LOGIC;									-- Horloge
           reset : in  STD_LOGIC;									-- Reset Asynchrone
           press: in STD_LOGIC;										-- Appui Bouton Encodeur
			     endframe : in  STD_LOGIC;								-- Fin de l'Image Visible
           visible : in  STD_LOGIC;									-- Zone Visible de l'Image
           ball : in  STD_LOGIC;										        -- Pixel Courant = Balle
           bottom : in  STD_LOGIC;									        -- Pixel Courant = Bas de l'Ecran
           brick_bounce : in tableau;								        -- Rebond Contre une Brique
           miss_timer : out  STD_LOGIC_VECTOR (5 downto 0);	-- Timer Mode Partie Perdue
           miss : out  STD_LOGIC;									-- Partie Perdue
           win : out  STD_LOGIC;										-- Partie Gagnee
           freeze : out  STD_LOGIC);								-- Mode Pause
end mode;

architecture Behavioral of mode is

signal timer: std_logic_vector(5 downto 0);	-- Timer du Mode Echec
signal lock: std_logic_vector(9 downto 0);	-- Anti-Rebond du Bouton de l'Encodeur
signal no_brick: std_logic;
signal pause: std_logic;
begin

miss_timer <= timer;
freeze<=pause;
---------------------------------------------------------
process(clk25,reset)

begin

	if reset='0' then lock<=(others=>'0');pause<='1';

	elsif rising_edge(clk25) then

		if timer = 1 then pause <='1'; end if;

		if press='1' then
			if lock="0000000000" then
				pause<= not pause;
				lock<="1111111111";
			end if;
		else
			if lock /= "0000000000" then
				lock <= lock-1;
			end if;
		end if;
	end if;
end process;
----------------------------------------------------------

-------------------------------------------------------------------------------------
	process(clk25,reset)

		begin
			if reset='0' then
				timer<="111111";
	elsif rising_edge(clk25) then
		if endframe='0' then
			if (ball and bottom) ='1' then
          timer <= "111111";
      end if;
		else
			if (timer /= 0) then
          timer<=timer-1; end if;
			end if;
		end if;
end process;

miss <= '1' when visible='1' and timer > 0 else '0';

-----------------------------------------------------------------------------------------
process(miss, lives)
  variable lives : std_ulogic := '3';
  begin
    if (miss = '1' then)
        lives <= lives - 1;
    end if;
end process;
-----------------------------------------------------------------------------------------
-- GESTION DE LA BASCULE "PLUS DE BRIQUES A CASSER"
process(clk25,reset)
  begin
			if reset='0' then
      no_brick <= '0';
			elsif rising_edge(clk25) then
  			-- Si on Trouve une Brique Non Cassee
  			-- NoBrick Reste a 0
  			-- Sinon, NoBrick Passe a 1
  			  no_brick<='1';

  			for i in 0 to 1 loop
          for j in 0 to 8 loop
            if brick_bounce(i)(j) = '0' then
              no_brick<='0';
  						end if;
  					end loop;
  				end loop;
    end if;
end process;

-- Generation du Signal de Partie Gagnee
win <= no_brick and visible;

end Behavioral;
