library ieee;
use ieee.std_logic_1164.all;

entity tick_1hz is
  generic (
    CLK_FREQ : integer := 100_000_000 
  );
  port(
    clk : in std_logic;
    tick : out std_logic
  );
end entity;

architecture rtl of tick_1hz is
 
  signal cnt : integer range 0 to CLK_FREQ - 1 := 0;
begin
  process(clk)
  begin
    if rising_edge(clk) then
        if cnt = CLK_FREQ - 1 then
          cnt <= 0;
          tick <= '1';
        else
          cnt <= cnt + 1;
          tick <= '0';
        end if;
      end if;
  end process;
end architecture;