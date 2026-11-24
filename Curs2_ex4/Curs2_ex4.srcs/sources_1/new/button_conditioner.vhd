library ieee;
use ieee.std_logic_1164.all;
entity button_conditioner is
 generic (STABLE_CYCLES : positive := 
1000000);
 port (clk : in std_logic; 
 button_raw : in std_logic; 
 pressed : out std_logic);
end entity;
architecture structural of button_conditioner is
 signal synced, filtered : std_logic;
begin
 u_sync : entity work.sync_2ff
 port map(clk => clk, async_in => button_raw, sync_out => synced);
 u_debounce : entity work.debounce
 generic map(STABLE_CYCLES => STABLE_CYCLES)
 port map(clk => clk, din => synced, dout => filtered);
 u_edge : entity work.edge_detector
 port map(clk => clk, din => filtered, rise_pulse => pressed);
end architecture;
