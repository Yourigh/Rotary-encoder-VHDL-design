----------------------------------------------------------------------------------
-- SHAFT ENCODER
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;
use IEEE.NUMERIC_STD.ALL;

entity rotary_top is
    Port ( clk              : in STD_LOGIC;
           rotary_a         : in STD_LOGIC;
           rotary_b         : in STD_LOGIC;
           sw_in            : in STD_LOGIC;
		       UD_out           : out STD_LOGIC_VECTOR (1 downto 0);
           UD_latching_out  : out STD_LOGIC_VECTOR (1 downto 0);
           SW_rise_latching : out STD_LOGIC;
           SW_rise          : out STD_LOGIC;
		       clear_latch      : in std_logic
           );
end rotary_top;

architecture Behavioral of rotary_top is

signal rotary_a_deb : STD_LOGIC := '0';
signal rotary_b_deb : STD_LOGIC := '0';
signal updown_out : STD_LOGIC_VECTOR (1 downto 0);
signal AB_deb: STD_LOGIC_VECTOR (1 downto 0);
signal UD_latching_d, UD_latching_q : STD_LOGIC_VECTOR (1 downto 0);
signal sw_deb,sw_deb_delay 	: std_logic;
signal SW_rise_latch_q,SW_rise_latch_d 	: std_logic;

--inverted signals
signal n_sw_in  : std_logic;
signal n_rotary_a  : std_logic;
signal n_rotary_b  : std_logic;

begin
n_sw_in <= not sw_in;
n_rotary_a <= not rotary_a;
n_rotary_b <= not rotary_b;
AB_deb <= rotary_a_deb & rotary_b_deb;

debsw: entity work.debounce
    generic map (counter_size => 20) --10.5ms
	port map(clk => clk , button =>  n_sw_in, result => sw_deb);
deba: entity work.debounce
    generic map (counter_size => 15) --327us
	port map(clk => clk , button =>  n_rotary_a, result => rotary_a_deb);
debb: entity work.debounce
    generic map (counter_size => 15) --327us
	port map(clk => clk , button =>  n_rotary_b, result => rotary_b_deb);
enc:entity work.x1enc2
	port map(AB => AB_deb, Clk => clk , UD => updown_out);

swrise: process(clk)
begin
   if rising_edge(clk) then
       sw_deb_delay <= sw_deb;
       SW_rise <= '0';
       SW_rise_latch_q <= SW_rise_latch_d; --remember
       if (((sw_deb_delay xor sw_deb) and sw_deb)='1') then
           --rising edge detector for switch
           SW_rise <= '1';
           SW_rise_latch_q <= '1';
       end if;
       if (clear_latch = '1') then
   			SW_rise_latch_q <= '0';
   		 end if;
   end if;
end process swrise;
SW_rise_latch_d <= SW_rise_latch_q;
SW_rise_latching <= SW_rise_latch_q;

UD_latching_out <= UD_latching_q;
UD_out <= updown_out;
lch:process(clk)
begin

	if rising_edge(clk) then
    UD_latching_q <= UD_latching_d;
		if (updown_out>"00") then
			UD_latching_q <= updown_out;
		end if;
		if (clear_latch = '1') then
			UD_latching_q <= "00";
		end if;
	end if;
end process lch;
UD_latching_d <= UD_latching_q;

end Behavioral;
