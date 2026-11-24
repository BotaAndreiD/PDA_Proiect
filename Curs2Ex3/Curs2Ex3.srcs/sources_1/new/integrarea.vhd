library ieee;
use ieee.std_logic_1164.all;
entity top_counter is
 port(clk,rst : in std_logic;
 seg : out std_logic_vector(6 downto 0);
 an : out std_logic_vector(3 downto 0);
 dp : out std_logic);
end entity;
architecture rtl of top_counter is
 signal tick : std_logic := '0';
 signal bcd : std_logic_vector(15 downto 0);
begin
 u_tick: entity work.tick1hz
 port map(clk=>clk,tick=>tick);
 u_bcd: entity work.bcd4
 port map(clk=>clk,tick=>tick,rst=>rst,value=>bcd);
 u_disp: entity work.display4
 port map(clk=>clk,
 digits=>bcd,
 seg=>seg,
 an=>an,
 dp=>dp);
end architecture;
