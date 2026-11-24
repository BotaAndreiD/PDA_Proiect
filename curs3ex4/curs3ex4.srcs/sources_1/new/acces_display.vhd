library ieee;
use ieee.std_logic_1164.all;
entity access_display is
port(status : in std_logic_vector(2 downto 0);
digit : in std_logic_vector(3 downto 0);
chars : out std_logic_vector(15 downto 0)
);
end entity;
architecture rtl of access_display is
begin
-- Hex glyphs: OPEN approximated as 0 P E n, Err approximated as E r r blank.
-- For unambiguous display, show 0xxx during entry, 0ACE on success, DEAD on failure.
process(status,digit) 
begin
case status is
when "000" => chars <= x"000" & digit; -- awaiting 1
when "001" => chars <= x"001" & digit; -- awaiting 2
when "010" => chars <= x"002" & digit; -- awaiting 3
when "011" => chars <= x"0ACE"; -- access granted
when others => chars <= x"DEAD"; -- access denied
end case;
end process;
end architecture;
