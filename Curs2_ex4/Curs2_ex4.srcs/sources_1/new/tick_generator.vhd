library ieee;
use ieee.std_logic_1164.all;
entity tick_generator is
 generic (CLOCK_HZ : positive := 100000000);
 port (clk : in std_logic; 
 tick : out std_logic);
end entity;
architecture rtl of tick_generator is
 signal count : natural range 0 to CLOCK_HZ-1 := 
0;
 signal tick_reg : std_logic := '0';
begin
process(clk)
 begin
 if rising_edge(clk) then
 tick_reg <= '0';
 if count = CLOCK_HZ-1 then
 count <= 0;
 tick_reg <= '1';
 else
 count <= count + 1;
 end if;
 end if;
 end process;
 tick <= tick_reg;
end architecture;
