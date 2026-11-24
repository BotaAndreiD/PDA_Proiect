library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;
-- Uncomment the following library declaration if
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;
entity bistabil is
Port ( clk100MHz : in STD_LOGIC;
D_Pin : in STD_LOGIC;
Reset_Pin : in STD_LOGIC;
Enable_Pin : in STD_LOGIC;
Q_Pin : out STD_LOGIC);
end bistabil;
architecture Behavioral of bistabil is
begin
process(clk100MHz)
begin
if rising_edge(clk100MHz) then
if Reset_Pin = '1' then
Q_Pin <= '0';
elsif Enable_Pin = '1' then
Q_Pin <= D_Pin;
end if;
end if;
end process;
end Behavioral;