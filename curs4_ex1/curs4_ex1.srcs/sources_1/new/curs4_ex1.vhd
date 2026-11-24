library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity stopwatch_core is
  port (
    clk              : in std_logic;
    tick_1hz         : in std_logic;
    start_stop_pulse : in std_logic;
    reset_pulse      : in std_logic;
    digits           : out std_logic_vector(15 downto 0);
    running          : out std_logic
  );
end entity;

architecture rtl of stopwatch_core is
  signal run_reg : std_logic := '0';
  signal s_units, s_tens, m_units, m_tens : unsigned(3 downto 0) := (others => '0');
begin

  
  process(clk)
  begin
    if rising_edge(clk) then
      if reset_pulse = '1' then
        run_reg <= '0';
        s_units <= (others => '0');
        s_tens  <= (others => '0');
        m_units <= (others => '0');
        m_tens  <= (others => '0');
      else
        if start_stop_pulse = '1' then
          run_reg <= not run_reg;
        end if;

        if tick_1hz = '1' and run_reg = '1' then
          if s_units = 9 then
            s_units <= (others => '0');
            if s_tens = 5 then
              s_tens <= (others => '0');
              if m_units = 9 then
                m_units <= (others => '0');
                if m_tens = 5 then
                  m_tens <= (others => '0');
                else
                  m_tens <= m_tens + 1;
                end if;
              else
                m_units <= m_units + 1;
              end if;
            else
              s_tens <= s_tens + 1;
            end if;
          else
            s_units <= s_units + 1;
          end if;
        end if;
      end if;
    end if;
  end process;

  digits  <= std_logic_vector(m_tens & m_units & s_tens & s_units);
  running <= run_reg;

end architecture;