library ieee;
use ieee.std_logic_1164.all;

entity top_fsm_compare is
generic(DEBOUNCE_CYCLES : positive := 1000000);
port(clk : in std_logic;
sw0, btnu, btnc : in std_logic;
led0, led1, led2 : out std_logic);
end entity;

architecture rtl of top_fsm_compare is
signal bit_tick, reset_tick, bit_sync : std_logic;
signal moore_found, mealy_found : std_logic;
signal moore_latch, mealy_latch : std_logic := '0';
begin


u_btn: entity work.button_conditioner
generic map(STABLE_CYCLES=>DEBOUNCE_CYCLES)
port map(
    clk => clk,
    button_raw => btnu,  
    pressed => bit_tick 
);


u_rst: entity work.button_conditioner
generic map(STABLE_CYCLES=>DEBOUNCE_CYCLES)
port map(
    clk => clk,
    button_raw => btnc,  
    pressed => reset_tick 
);

u_sw: entity work.sync_2ff 
port map(clk=>clk,async_in=>sw0,sync_out=>bit_sync
);

u_moore: entity work.fsm_moore
port map(clk=>clk,rst=>reset_tick,bit_tick=>bit_tick,bit_in=>bit_sync,detected=>moore_found
);

u_mealy: entity work.fsm_mealy
port map(clk=>clk,rst=>reset_tick,bit_tick=>bit_tick,bit_in=>bit_sync,detected=>mealy_found
);

process(clk)
begin
if rising_edge(clk) then
if reset_tick='1' then
moore_latch<='0'; mealy_latch<='0';
else
if moore_found='1' then moore_latch<='1'; end if;
if mealy_found='1' then mealy_latch<='1'; end if;
end if;
end if;
end process;

led0<=moore_latch;
led1<=mealy_latch;
led2<=bit_sync;
end architecture;