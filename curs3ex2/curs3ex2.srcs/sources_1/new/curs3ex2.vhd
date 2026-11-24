library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity traffic_fsm is
Port (
clk : in STD_LOGIC;
reset : in STD_LOGIC;
tick : in STD_LOGIC;
red_led : out STD_LOGIC;
green_led : out STD_LOGIC;
yellow_led : out STD_LOGIC
);
end traffic_fsm;
architecture rtl of traffic_fsm is
type state_t is (RED, GREEN, YELLOW);
signal state : state_t := RED;
signal next_state : state_t := RED;
signal seconds : integer range 0 to 9 := 0;
signal duration : integer range 1 to 10;
begin

with state select
duration <= 10 when RED,
8 when GREEN,
2 when YELLOW;

process(clk)
begin
if rising_edge(clk) then
if reset = '1' then
state <= RED;
seconds <= 0;
elsif tick = '1' then
if seconds = duration - 1 then
state <= next_state;
seconds <= 0;
else
seconds <= seconds + 1;
end if;
end if;
end if;
end process;

process(state)
begin
case state is
when RED =>
next_state <= GREEN;
when GREEN =>
next_state <= YELLOW;
when YELLOW =>
next_state <= RED;
end case;
end process;

red_led <= '1' when state = RED else '0';
green_led <= '1' when state = GREEN else '0';
yellow_led <= '1' when state = YELLOW else '0';
end rtl;
