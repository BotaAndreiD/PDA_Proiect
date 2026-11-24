library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity alu4_tb is
end alu4_tb;

architecture Behavioral of alu4_tb is
    signal A, B   : std_logic_vector(3 downto 0) := (others => '0');
    signal OP     : std_logic_vector(1 downto 0) := (others => '0');
    signal RESULT : std_logic_vector(3 downto 0);
begin
    uut: entity work.alu4
        port map (A => A, B => B, OP => OP, RESULT => RESULT);

    stim: process
    begin
        for o in 0 to 3 loop
            OP <= std_logic_vector(to_unsigned(o, 2));
            for i in 0 to 15 loop
                A <= std_logic_vector(to_unsigned(i, 4));
                for j in 0 to 15 loop
                    B <= std_logic_vector(to_unsigned(j, 4));
                    wait for 10 ns;
                end loop;
            end loop;
        end loop;
        wait;
    end process;
end Behavioral;