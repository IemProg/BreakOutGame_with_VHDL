----------------------------------------------------------------------------------
-- Company: Sorbonne Universit� (ex: UPMC)
-- Engineer: Imad Eddine MAROUF
--
-- Create Date: 23.03.2019 14:51:33
-- Design Name:
-- Module Name: AllIn - Behavioral
-- Project Name: CasseBrique
-- Additional Comments:
--
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.all;
use IEEE.std_logic_signed.all;
use work.pong_pack.ALL;

entity AllIn is
   Port
   (
    RESET: IN STD_LOGIC;
    Press: IN STD_LOGIC;
    ClkSys : IN STD_LOGIC;
    MISO: IN STD_LOGIC;


    Speed: IN STD_LOGIC;
    Taille: IN STD_LOGIC;

    ---------------------For VGA -----------------------------
    redOut, blueOut, greenOut: OUT std_logic_vector(3 downto 0);
    hsyncOut, vsyncOut: OUT std_logic;

    --------------- For the accelorometer --------------------
    SCLK       : out STD_LOGIC;
    MOSI       : out STD_LOGIC;
    SS         : out STD_LOGIC;

    ------------- For 7 segment display ----------------------
    Anode_Activate : out STD_LOGIC_VECTOR (3 downto 0);
    LED_out : out STD_LOGIC_VECTOR (6 downto 0);

    -------- Additionnel leds for verification -------------
    rot_left : out std_logic;
    rot_right : out std_logic
);
end AllIn;

architecture Behavioral of AllIn is
----- Essential Clock Signals ----------
signal clk_5hz : std_logic;
signal clk_25 : std_logic;
signal clk_25Khz: std_logic;
signal clk_80Hz: std_logic;
signal res: std_logic;
signal score: std_logic_vector(3 downto0);

signal visible, endframe: std_logic;
signal r, g, b: std_logic;
signal red, green, blue: std_logic_vector(3 downto 0);
signal xpos, ypos : std_logic_vector(9 downto 0);
signal h_sync, v_sync : std_logic;


signal left, right : std_logic;
signal accel_y : std_logic_vector(11 downto 0);

---- Vecteur pour le niveau de jeu
--signal int_taille, int_speed: std_logic;
--signal niveau: std_logic_vector(1 downto 0);

-- OBJETS CORRESPONDANT AU PIXEL COURANT
signal int_bluebox : STD_LOGIC;							-- Pixel Courant = Case Bleue
signal int_bottom : STD_LOGIC;							-- Pixel Courant = Bas de l'Ecran
signal int_wall : STD_LOGIC;								-- Pixel Courant = Mur
signal int_pad: std_logic;									-- Pixel Appartient a la Raquette
signal int_briquecasse : std_logic;
signal int_ball : STD_LOGIC;								-- Pixel Courant = Balle
signal int_brick : tableau;
signal int_brick_bounce: tableau;

----- Segment Displays ----------------
signal Anode : STD_LOGIC_VECTOR (3 downto 0);
signal LED : STD_LOGIC_VECTOR (6 downto 0);

signal misstimer : STD_LOGIC_VECTOR (5 downto 0);	    -- Timer Mode Partie Perdue
signal missout : std_logic;				                -- Partie Perdue
signal winout  : std_logic;                             -- Partie Gagnee
signal freeze : STD_LOGIC;								-- Mode Pause

begin
    res <= not RESET;
    ------------------Calling  ClkDiv for 5Hz Component-------
    Clk5Kh: entity work.ClkDiv_5Hz(Behavioral)
    Port Map (CLK => ClkSys, RST => RESET, CLKOUT => clk_5hz);

    ------------------Calling  ClkDiv for 5Hz Component-------
    Clk80Hz: entity work.Clk80Hz(Behavioral)
    Port Map (clk100 => ClkSys, reset => RESET, clk80 => clk_80Hz);

    ------------------Calling  ClkDiv for 25KHz Component-------
    Clk25Khz: entity work.ClkDiv25kHz(Behavioral)
    Port Map (clk => ClkSys, reset => RESET, clock_out => clk_25Khz);

    ------------------Calling  ClkDiv for 25MHz Component-------
    CompDiv: entity work.ClkDiv(Behavioral)
    port map(clk100 => ClkSys, RESET => RESET, clk25 => clk_25);

    ------------------Calling  Accelo Component-----------------
    Accelo: entity work.Accelo(Behavioral)
    Port Map( sysclock => ClkSys, RESET => res, LED_Y => accel_y, SCLK => SCLK,
            MOSI => MOSI, MISO => MISO, SS => SS, rot_left => left, rot_right => right);

    ------------------Calling  Game Component-----------------
    Game: entity work.Game(Behavioral)
    port map (
             clk25 => clk_25,
             reset => RESET,
             press => Press,
             endframe => endframe,
             visible => visible,
             wall => int_wall,                   -- Pixel Courant = Mur
             bottom => int_bottom,               -- Pixel Courant = Bas de l'Ecran
             bluebox => int_bluebox,             -- Pixel Courant = Case Bleue
             pad => int_pad,                     -- Pixel Courant = Raquette
             ball => int_ball,                   -- Pixel Courant = Balle
             brick => int_brick,                 -- Pixel Courant = Brique
             brick_bounce => int_brick,                -- Rebond Contre une Brique
             red => r,                              -- Affichage Rouge
             green => g,                           -- Affichage Vert
             blue => b,                             -- Affichage Bleu
             miss_timer => misstimer,           -- Timer Mode Partie Perdue
             miss_out => missout,                -- Partie Perdue
             win_out  => winout,                -- Partie Gagnee
             freeze => freeze                                    -- Mode Pause
    );

    ------------------Calling  Objects Component-----------------
    Objects: entity work.Objects(Behavioral)
    port map(
                clk25Khz => clk_25Khz,                  --- to Speed up the paddle :D
                clk25 => clk_25, clk5Hz => clk_5hz, reset => RESET,
                visible => visible, endframe => endframe,
                xpos => xpos,
                ypos => ypos,
                rot_left => left,
                rot_right => right,
                taille => taille,
                speed => Speed,
                freeze => freeze,
                miss_timer=> misstimer,
                bluebox => int_bluebox,
                bottom => int_bottom,
                wall => int_wall,
                pad => int_pad,
                brick => int_brick,
                brick_bounce => int_brick_bounce,
                briquecasse => int_briquecasse,
                ball => int_ball,
                score => score
    );
    ---------------------------------------------------------------
    red <= r & "000";
    green <= g & "000";
    blue <= b & "000";
    --niveau <= speed & taille;
    ---------------------------------------------------------------

    ---------------Calling the VGA_Component-----------------------
    CompVGA: entity work.vga(archi)
    port map( clk25 => clk_25, reset => RESET,
              r => red, g => green, b => blue,
              red => redOut, blue => blueOut, green => greenOut,
              hsync => h_sync, vsync => v_sync,
              visible => visible, endframe => endframe, xpos => xpos, ypos => ypos);
    ----------------------------------------------------------------

    ------------ BCD_to_Segment TIME in Hexa ------------------------------------
    BCDtoSegment: entity work.BCD_to_Segment(Behavioral)
    port map( clock_100Mhz => ClkSys, reset => res,
              Anode_Activate => Anode, LED_out => LED);


    ------------ BCD_to_Segment Score in Hexa ------------------------------------

    ------------------- Passer � un autre niveau -------------------
   --process(winout)
    --begin
      -- if (winout = '1')then
        --    niveau <= unsigned(niveau) + 1;
       --end if;
    --end process;

    --int_speed <= niveau(0);
    --int_taille <= niveau(1);
    -----------------------------------------------------------------

    ----------------- Outputs of the system -------------------------
    hsyncOut <= h_sync;
    vsyncOut <= v_sync;

    rot_left <= left ;
    rot_right <= right;
    -----------------------------------------------------------------
end Behavioral;
