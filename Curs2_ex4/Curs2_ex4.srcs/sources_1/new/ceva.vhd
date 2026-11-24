library ieee;
use ieee.std_logic_1164.all;
entity debounce is
 generic (STABLE_CYCLES : positive := 1000000); 
 port (clk : in std_logic; din : in std_logic; dout : out std_logic);
end entity;
architecture rtl of debounce is
 signal stable_value : std_logic := '0';
 signal counter : natural range 0 to STABLE_CYCLES-1 := 0;
begin
process(clk)
 begin
 if rising_edge(clk) then
 if din = stable_value then
 counter <= 0;
 elsif counter = STABLE_CYCLES-1 
then
 stable_value <= din;
 counter <= 0;
 else
 counter <= counter + 1;
 end if;
 end if;
 end process;
 dout <= stable_value;
end architecture;
