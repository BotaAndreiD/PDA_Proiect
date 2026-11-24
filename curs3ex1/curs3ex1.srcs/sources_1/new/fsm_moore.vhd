library ieee;
use ieee.std_logic_1164.all;
entity fsm_moore is
port(clk, rst, bit_tick, bit_in : in std_logic;
detected : out std_logic);
end entity;
architecture rtl of fsm_moore is
type state_t is (S0, S1, S10, S101, S1011);
signal state : state_t := S0;
begin
process(clk)
begin
if rising_edge(clk) then
if rst = '1' then
state <= S0;
elsif bit_tick = '1' then
case state is
when S0 => if bit_in='1' then state<=S1; else state<=S0; end if;
when S1 => if bit_in='0' then state<=S10; else state<=S1; end if;
when S10 => if bit_in='1' then state<=S101; else state<=S0; end if;
when S101 => if bit_in='1' then state<=S1011; else state<=S10; end if;
when S1011 => if bit_in='0' then state<=S10; else state<=S1; end if;
end case;
end if;
end if;
end process;
detected <= '1' when state=S1011 else '0';
end architecture;