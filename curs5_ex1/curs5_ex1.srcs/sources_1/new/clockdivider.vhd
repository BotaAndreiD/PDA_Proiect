library ieee;
use ieee.std_logic_1164.all;

entity ClockDivider is
    port (
        ck100MHz : in  std_logic;
        ck25MHz  : out std_logic
    );
end ClockDivider;

architecture RTL of ClockDivider is
    signal cstPresc : integer := 4; -- divizor cu 4
    signal counter  : integer := 0;
    signal testFlag : std_logic := '0';
begin
    process(ck100MHz)
    begin
        if rising_edge(ck100MHz) then
            if counter = cstPresc - 1 then
                counter  <= 0;
                testFlag <= '1';
            else
                counter  <= counter + 1;
                testFlag <= '0';
            end if;
        end if;
    end process;

    ck25MHz <= testFlag; -- Adaugat ';' care lipsea
end architecture RTL;