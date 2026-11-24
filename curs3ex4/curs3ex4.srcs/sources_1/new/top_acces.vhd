library ieee;
use ieee.std_logic_1164.all;
entity top_access is
generic(DEBOUNCE_CYCLES : positive := 1_000_000; DISPLAY_CYCLES : positive := 25_000);
port(clk, btnU, btnC : in std_logic;
sw : in std_logic_vector(3 downto 0);
led : out std_logic_vector(1 downto 0);
seg : out std_logic_vector(6 downto 0);
an : out std_logic_vector(3 downto 0); dp : out std_logic);
end entity;
architecture structural of top_access is
signal confirm_pulse, reset_pulse : std_logic;
signal digit_sync_1, digit_sync_2 : std_logic_vector(3 downto 0) := (others=>'0');
signal granted, denied : std_logic;
signal status : std_logic_vector(2 downto 0);
signal chars : std_logic_vector(15 downto 0);
attribute ASYNC_REG : string;
attribute ASYNC_REG of digit_sync_1 : signal is "TRUE";
attribute ASYNC_REG of digit_sync_2 : signal is "TRUE";
begin
process(clk) 
begin
if rising_edge(clk) then
digit_sync_1 <= sw;
digit_sync_2 <= digit_sync_1;
end if;
end process;
u_confirm: entity work.button_conditioner
generic map(STABLE_CYCLES=>DEBOUNCE_CYCLES)
port map(clk=>clk, button_raw=>btnU, pressed=>confirm_pulse
);
u_reset: entity work.button_conditioner
generic map(STABLE_CYCLES=>DEBOUNCE_CYCLES)
port map(clk=>clk, button_raw=>btnC, pressed=>reset_pulse
);
u_fsm: entity work.access_fsm
port map(clk=>clk, reset=>reset_pulse, confirm_pulse=>confirm_pulse,
digit=>digit_sync_2, granted=>granted, denied=>denied, status=>status
);
u_text: entity work.access_display
port map(status=>status, digit=>digit_sync_2, chars=>chars
);
u_display: entity work.display4
    generic map(SCAN_CYCLES => DISPLAY_CYCLES)
    port map(
      clk    => clk, 
      digits => chars, 
      seg    => seg, 
      an     => an, 
      dp     => dp
    );
led(0)<=granted;
led(1)<=denied;
end architecture;
