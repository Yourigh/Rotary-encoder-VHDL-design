----------------------------------------------------------------------------------
-- SHAFT ENCODER
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;
use IEEE.NUMERIC_STD.ALL;

entity rotary_top is
    Port ( clk : in STD_LOGIC;
           rotary_a : in STD_LOGIC;
           rotary_b : in STD_LOGIC;
           sw_in : in STD_LOGIC;
           sw_out : out STD_LOGIC;
		   UD_out : out STD_LOGIC_VECTOR (1 downto 0);
           UD_latching_out : out STD_LOGIC_VECTOR (1 downto 0);
		   clear_latch : in std_logic
           );
end rotary_top;

architecture Behavioral of rotary_top is

signal rotary_a_deb : STD_LOGIC := '0';
signal rotary_b_deb : STD_LOGIC := '0';
signal updown_out : STD_LOGIC_VECTOR (1 downto 0);
signal UD_latching_d, UD_latching_q : STD_LOGIC_VECTOR (1 downto 0);

begin
debsw: entity work.debounce
    generic map (counter_size => 20) --10.5ms
	port map(clk => clk , button => not(sw_in) , result => sw_out);
deba: entity work.debounce
    generic map (counter_size => 15) --327us
	port map(clk => clk , button => not(rotary_a) , result => rotary_a_deb);
debb: entity work.debounce
    generic map (counter_size => 15) --327us
	port map(clk => clk , button => not(rotary_b) , result => rotary_b_deb);
enc:entity work.x1enc2
	port map(AB => rotary_a_deb & rotary_b_deb, Clk => clk , UD => updown_out);
	
UD_latching_out <= UD_latching_q;
UD_out <= updown_out;
lch:process(clk)
begin
	if rising_edge(clk) then
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