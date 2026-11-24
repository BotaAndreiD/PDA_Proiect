library ieee;
use ieee.std_logic_1164.all;
-- Integrare: modulele initiale isi pastreaza interfetele.
entity stopwatch_system is
generic (USE_EDGE : boolean := true;
STABLE_CYCLES : positive := 1_000_000);
port (ck100MHz, btnC, btnU, sw0 : in std_logic;
cat : out std_logic_vector(6 downto 0);
an : out std_logic_vector(3 downto 0);
dp : out std_logic);
end entity;
architecture structural of stopwatch_system is
signal button_cmd, reset_cmd, mode_sync, button_sync : std_logic;
signal enCnt, resCnt, run_actual, core_reset : std_logic;
signal toggle_run, timer_enable, tick_second : std_logic;
signal digits : std_logic_vector(15 downto 0);
signal an_internal : std_logic_vector(3 downto 0);
begin
u_sw: entity work.sync_2ff
port map(clk=>ck100MHz, 
async_in=>sw0, 
sync_out=>mode_sync);
u_btnU: entity work.button_conditioner
generic map(STABLE_CYCLES=>STABLE_CYCLES)
port map(clk=>ck100MHz, button_raw=>btnU, pressed=>reset_cmd);
g_edge: if USE_EDGE generate
u_btnC: entity work.button_conditioner
generic map(STABLE_CYCLES=>STABLE_CYCLES)
port map(clk=>ck100MHz, button_raw=>btnC, pressed=>button_cmd);
u_fsm: entity work.stopwatch_fsm_edge
port map(clk=>ck100MHz, reset=>reset_cmd,
press_pulse=>button_cmd, mode_sw=>mode_sync,
enCnt=>enCnt, resCnt=>resCnt);
end generate;
g_level: if not USE_EDGE generate
u_sync: entity work.sync_2ff
port map(clk=>ck100MHz, async_in=>btnC, sync_out=>button_sync);
u_db: entity work.debounce
generic map(STABLE_CYCLES=>STABLE_CYCLES)
port map(clk=>ck100MHz, din=>button_sync, dout=>button_cmd);
u_fsm: entity work.stopwatch_fsm
port map(clk=>ck100MHz, reset=>reset_cmd,
button=>button_cmd, mode_sw=>mode_sync,
enCnt=>enCnt, resCnt=>resCnt);
end generate;
-- Adaptarea comenzilor FSM la interfata core-ului initial.
-- Core-ul inverseaza running la fiecare impuls start_stop_pulse.
-- Un singur impuls este produs cand running difera de enCnt.
core_reset <= resCnt or reset_cmd;
toggle_run <= (enCnt xor run_actual) and not core_reset;
-- Nu avansam timpul pe ciclul de oprire sau de sincronizare Start.
timer_enable <= enCnt and run_actual and not core_reset;
u_tick: entity work.tick_1Hz
port map(clk=>ck100MHz, 
tick=>tick_second);
u_core: entity work.stopwatch_core
port map(clk=>ck100MHz, 
tick_1hz=>tick_second,
start_stop_pulse=>toggle_run, 
reset_pulse=>core_reset,
digits=>digits, 
running=>run_actual);
u_display: entity work.display4
port map(clk=>ck100MHz,
digits=>digits,
seg=>cat,
an=>an_internal, 
dp=>open);
an <= an_internal;
-- MM.SS: separator dupa cifra unitatilor de minute.
dp <= an_internal(2);
end architecture;
