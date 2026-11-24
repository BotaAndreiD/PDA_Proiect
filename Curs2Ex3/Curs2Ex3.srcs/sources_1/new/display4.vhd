library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity display4 is
  generic(
    SCAN_CYCLES : positive := 25000 -- Am adăugat portul generic aici
  );
  port(
    clk : in std_logic;
    digits : in std_logic_vector(15 downto 0);
    seg : out std_logic_vector(6 downto 0);
    an : out std_logic_vector(3 downto 0);
    dp : out std_logic
  );
end entity;

architecture rtl of display4 is
  -- Am înlocuit 24999 cu SCAN_CYCLES - 1 pentru ca semnalul să se adapteze dinamic
  signal cnt : integer range 0 to SCAN_CYCLES - 1 := 0; 
  signal sel : unsigned(1 downto 0) := (others => '0');
  signal nib : std_logic_vector(3 downto 0);
 
begin 
 
  process(clk)
  begin
    if rising_edge(clk) then
      if cnt = SCAN_CYCLES - 1 then -- Am înlocuit și aici valoarea hardcodată
        cnt <= 0;
        sel <= sel + 1;
      else
        cnt <= cnt + 1;
      end if;
    end if;
  end process;

  with sel select
    nib <= digits(3 downto 0)   when "00",
           digits(7 downto 4)   when "01",
           digits(11 downto 8)  when "10",
           digits(15 downto 12) when others; 
          
  with sel select
    an <= "1110" when "00",
          "1101" when "01",
          "1011" when "10",
          "0111" when others;
         
  u_dec: entity work.hex7seg
  port map(
    hex => nib, 
    seg => seg
  );
 
  dp <= '1';

end architecture;