library ieee;
use ieee.std_logic_1164.all;
entity top_one_digit is
 port(sw : in std_logic_vector(3 downto 0);
 seg : out std_logic_vector(6 downto 0);
 an : out std_logic_vector(3 downto 0);
 dp : out std_logic);
end entity;
architecture rtl of top_one_digit is
begin
 u_dec: entity work.hex7seg
 port map(
hex => sw, 
seg => seg
 );
 an <= "1110";
 dp <= '1';
end architecture;
