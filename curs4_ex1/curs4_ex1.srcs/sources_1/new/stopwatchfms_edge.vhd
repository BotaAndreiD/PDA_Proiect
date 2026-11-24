library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity stopwatch_fsm_edge is
port (
clk, reset, press_pulse, mode_sw : in std_logic;
enCnt, resCnt : out std_logic
);
end stopwatch_fsm_edge;
architecture RTL of stopwatch_fsm_edge is
type state_type is (stReset, stRun, stStop);
signal state, next_state : state_type := stReset;
begin
process(clk)
begin
if rising_edge(clk) then
if reset = '1' then
state <= stReset;
else
state <= next_state;
end if;
end if;
end process;
process(state, press_pulse, mode_sw)
begin
next_state <= state;
case state is
when stReset =>
if press_pulse = '1' then
next_state <= stRun;
end if;
when stRun =>
if press_pulse = '1' then
next_state <= stStop;
end if;
when stStop =>
if press_pulse = '1' then
if mode_sw = '1' then
next_state <= stRun;
else
next_state <= stReset;
end if;
end if;
when others =>
next_state <= stReset;
end case;
end process;
-- Moore: iesirile depind exclusiv de starea curenta.
enCnt <= '1' when state = stRun else '0';
resCnt <= '1' when state = stReset else '0';
end RTL;
