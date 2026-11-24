library ieee;
use ieee.std_logic_1164.all;
entity edge_detector is
 port (clk : in std_logic; 
 din : in std_logic; 
 rise_pulse : out std_logic);
end entity;
architecture rtl of edge_detector is
 signal previous : std_logic := '0';
 signal pulse_reg : std_logic := '0';
begin
 process(clk)
 begin
 if rising_edge(clk) then
 pulse_reg <= din and not previous;
 previous <= din;
 end if;
 end process;
 rise_pulse <= pulse_reg;
end architecture;
