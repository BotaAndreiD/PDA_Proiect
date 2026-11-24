library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity bcd4 is
 port(clk, tick, rst : in std_logic;
 value : out std_logic_vector(15 downto 0));
end entity;
architecture rtl of bcd4 is
 signal d0,d1,d2,d3 : unsigned(3 downto 0) := (others=>'0');
begin
 process(clk)
 begin
 if rising_edge(clk) then
 if rst='1' then
 d0 <= (others=>'0'); 
 d1 <= (others=>'0');
 d2 <= (others=>'0'); 
 d3 <= (others=>'0');
elsif tick='1' then
 if d0=9 then
 d0 <= (others=>'0');
 if d1=9 then
 d1 <= (others=>'0');
 if d2=9 then
 d2 <= (others=>'0');
 if d3=9 then d3 <= (others=>'0');
 else d3 <= d3+1; end if;
 else d2 <= d2+1; end if;
 else d1 <= d1+1; end if;
 else d0 <= d0+1; end if;
 end if;
 end if;
 end process;
 value <= std_logic_vector(d3 & d2 & d1 & d0);
end architecture;
