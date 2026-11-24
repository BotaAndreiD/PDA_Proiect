library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity top_traffic is
Port (
clk : in STD_LOGIC;
btnC : in STD_LOGIC;
led : out STD_LOGIC_VECTOR(2 downto 0)
);
end top_traffic;
architecture rtl of top_traffic is
signal tick_signal : STD_LOGIC;
signal red_signal : STD_LOGIC;
signal green_signal : STD_LOGIC;
signal yellow_signal : STD_LOGIC;
signal reset_meta : STD_LOGIC := '0';
signal reset_sync : STD_LOGIC := '0';
attribute ASYNC_REG : string;
attribute ASYNC_REG of reset_meta : signal is "TRUE";
attribute ASYNC_REG of reset_sync : signal is "TRUE";
begin
-- Sincronizarea butonului de reset
process(clk)
begin
if rising_edge(clk) then
reset_meta <= btnC;
reset_sync <= reset_meta;
end if;
end process;
-- Generator de impulsuri de 1 Hz
u_tick: entity work.tick_1hz
generic map (
CLK_FREQ => 100_000_000
)
port map (
clk => clk,
reset => reset_sync,
tick => tick_signal
);
-- Masina cu stari finite
u_fsm: entity work.traffic_fsm
port map (
clk => clk,
reset => reset_sync,
tick => tick_signal,
red_led => red_signal,
green_led => green_signal,
yellow_led => yellow_signal
);
-- Conectarea la LED-urile placii
led(0) <= red_signal;
led(1) <= green_signal;
led(2) <= yellow_signal;
end rtl;
