--------------------------------------------------------------------------------
-- Company: www.controlsystemslab.com
-- Engineer: Dr.Varodom Toochinda
--
-- Create Date:   18:05:33 05/02/2012
-- Design Name:   Encoder x 4 (design B) Tesebench
-- Module Name:   D:/Dewwork/Dew2012/Active/research/hdl/encoder/vhdl/x4enc2/TB1.vhd
-- Project Name:  x4enc2
-- Target Device:
-- Tool versions:
-- Description:
--
-- VHDL Test Bench Created by ISE for module: x4enc2
--
-- Dependencies:
--
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes:
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;

ENTITY TB1 IS
END TB1;

ARCHITECTURE behavior OF TB1 IS


   --Inputs
   signal AB : std_logic_vector(1 downto 0) := (others => '0');
   signal Clk : std_logic := '0';
   signal clear_latch : std_logic := '0';
   signal rot_SW : std_logic := '0';

 	--Outputs
   signal UD : std_logic_vector(1 downto 0);
   signal UD_ce : std_logic_vector(1 downto 0);
   signal SW_rise_sig : std_logic;
   signal slv_reg0 : std_logic_vector(5 downto 0);

   -- Clock period definitions
   constant Clk_period : time := 10 ns;

BEGIN

	-- Instantiate the Unit Under Test (UUT)
   uut: entity work.rotary_top
        port map(
            clk        =>       Clk,
            rotary_a   =>       AB(0),
            rotary_b   =>       AB(1),
            sw_in      =>       rot_SW,
            UD_out      =>      UD_ce,
            UD_latching_out  => slv_reg0(5 downto 4),
            SW_rise_latching => slv_reg0(0),
            SW_rise     =>       SW_rise_sig,
            clear_latch      => clear_latch --reading strobe clears
            );

   -- Clock process definitions
   Clk_process :process
   begin
		Clk <= '0';
		wait for Clk_period/2;
		Clk <= '1';
		wait for Clk_period/2;
   end process;


   -- Stimulus process
   stim_proc: process
   begin
       -- hold reset state for 1000 ns.
      wait for 1 ms;
    clear_latch <= '0';
      wait for Clk_period*5;

      -- insert stimulus here
		-- CW direction: A leads B 90 degree
		AB <= "10";
		wait for 1 ms;
		AB <= "11";
		wait for 1 ms;
		AB <= "01";
		wait for 1 ms;
		AB <= "00";
    rot_SW <= '1';
		wait for 1 ms;
    clear_latch <= '1';
    wait for 40 ns;

    clear_latch <= '0';
		AB <= "10";
		wait for 1 ms;
		AB <= "11";
		wait for 1 ms;
		AB <= "01";
		wait for 1 ms;
		AB <= "00";
		wait for 4 ms;
		clear_latch <= '1';
		wait for 10 ns;
		clear_latch <= '0';
		-- CCW direction: B leads A 90 degree
		AB <= "01";
		wait for 1 ms;
		AB <= "11";
		wait for 1 ms;
		AB <= "10";
		wait for 1 ms;
    rot_SW <= '0';
		AB <= "00";
		wait for 1 ms;
		AB <= "01";
		wait for 1 ms;
		AB <= "11";
		wait for 1 ms;
		AB <= "10";
		wait for 1 ms;
		AB <= "00";
    wait for 5 ms;
    rot_SW <= '0';
    wait for 5 ms;
    clear_latch <= '1';
    wait for 10 ns;
    clear_latch <= '0';
      wait;
   end process;

END;
