library ieee;
use ieee.std_logic_1164.all;
entity stopwatch_top is
port (ck100MHz, btnC, btnU, sw0 : in std_logic;
cat : out std_logic_vector(6 downto 0);
an : out std_logic_vector(3 downto 0);
dp : out std_logic);
end entity;
architecture structural of stopwatch_top is
begin
u_system: entity work.stopwatch_system
generic map(USE_EDGE=>false)
port map(ck100MHz=>ck100MHz, 
btnC=>btnC, 
btnU=>btnU,
sw0=>sw0, 
cat=>cat, 
an=>an, 
dp=>dp);
end architecture;
library ieee;
use ieee.std_logic_1164.all;
entity stopwatch_top_edge is
port (ck100MHz, btnC, btnU, sw0 : in std_logic;
cat : out std_logic_vector(6 downto 0);
an : out std_logic_vector(3 downto 0);
dp : out std_logic);
end entity;
architecture structural of stopwatch_top_edge is
begin
u_system: entity work.stopwatch_system
generic map(USE_EDGE=>true)
port map(ck100MHz=>ck100MHz, 
btnC=>btnC, 
btnU=>btnU,
sw0=>sw0, 
cat=>cat, 
an=>an, 
dp=>dp);
end architecture;
