library ieee;
use ieee.std_logic_1164.all;
entity access_fsm is
port(clk, reset, confirm_pulse : in std_logic;
digit : in std_logic_vector(3 downto 0);
granted, denied : out std_logic;
status : out std_logic_vector(2 downto 0));
end entity;
architecture rtl of access_fsm is
type state_t is (WAIT_1, WAIT_2, WAIT_3, ACCESS_GRANTED, ACCESS_DENIED);
signal state, next_state : state_t := WAIT_1;
begin
process(clk) begin
if rising_edge(clk) then
if reset='1' then state <= WAIT_1;
elsif confirm_pulse='1' then state <= next_state;
end if;
end if;
end process;
process(state, digit) begin
next_state <= state;
case state is
when WAIT_1 =>
if digit=x"1" then 
next_state <= WAIT_2; 
else 
next_state <= ACCESS_DENIED; 
end if;
when WAIT_2 =>
if digit=x"2" then 
next_state <= WAIT_3; 
else 
next_state <= ACCESS_DENIED; 
end if;
when WAIT_3 =>
if digit=x"3" then 
next_state <= ACCESS_GRANTED; 
else 
next_state <= ACCESS_DENIED; 
end if;
when ACCESS_GRANTED => 
next_state <= ACCESS_GRANTED;
when ACCESS_DENIED => 
next_state <= ACCESS_DENIED;
end case;
end process;
granted <= '1' when state=ACCESS_GRANTED else '0';
denied <= '1' when state=ACCESS_DENIED else '0';
with state select status <=
"000" when WAIT_1, "001" when WAIT_2, "010" when WAIT_3,
"011" when ACCESS_GRANTED, "100" when ACCESS_DENIED;
end architecture;
