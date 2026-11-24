library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity stopwatch_fsm is
port (clk, reset, button, mode_sw : in std_logic;
enCnt, resCnt : out std_logic);
end stopwatch_fsm;
architecture RTL of stopwatch_fsm is
type state_type is (stRes0, stRes1, stRun0, stRun1, stStop0, stStop1);
signal state, next_state : state_type := stRes0;
begin
process(clk)
begin
if rising_edge(clk) then
if reset = '1' then state <= stRes0;
else state <= next_state;
end if;
end if;
end process;
process(state, button, mode_sw)
begin
next_state <= state;
case state is
when stRes0 =>
if button = '0' then next_state <= stRes1; end if;
when stRes1 =>
if button = '1' then next_state <= stRun0; end if;
when stRun0 =>
if button = '0' then next_state <= stRun1; end if;
when stRun1 =>
if button = '1' then next_state <= stStop0; end if;
when stStop0 =>
if button = '0' then next_state <= stStop1; end if;
when stStop1 =>
if button = '1' then
if mode_sw = '1' then next_state <= stRun0;
else next_state <= stRes0;
end if;
end if;
when others => next_state <= stRes0;
end case;
end process;
-- Iesiri Moore.
enCnt <= '1' when state = stRun0 or state = stRun1 else '0';
resCnt <= '1' when state = stRes0 else '0';
end RTL;
