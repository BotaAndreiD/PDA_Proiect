library ieee;
use ieee.std_logic_1164.all;
use work.DisplayDefinition.all;

entity VGA_Top is
    port (
        ck100MHz : in  std_logic;
        
        -- Cele 4 butoane de pe placa FPGA (ex. Basys 3)
        btnL     : in  std_logic; -- Stânga
        btnR     : in  std_logic; -- Dreapta
        btnU     : in  std_logic; -- Sus
        btnD     : in  std_logic; -- Jos
        
        hsync    : out std_logic;
        vsync    : out std_logic;
        vgaRed   : out color_component;
        vgaGreen : out color_component;
        vgaBlue  : out color_component
    );
end entity VGA_Top;

architecture Structural of VGA_Top is
    signal pixel_tick : std_logic;
    signal video_on   : std_logic;
    signal x_pos      : integer range 0 to H_VISIBLE - 1;
    signal y_pos      : integer range 0 to V_VISIBLE - 1;

    -- Raza cercului
    constant RADIUS : positive := 50;

    -- Limitele ecranului (pentru a nu ieși cercul în afara zonei vizibile)
    constant X_MIN : integer := RADIUS;
    constant X_MAX : integer := H_VISIBLE - 1 - RADIUS; -- 639 - 50 = 589
    constant Y_MIN : integer := RADIUS;
    constant Y_MAX : integer := V_VISIBLE - 1 - RADIUS; -- 479 - 50 = 429

    -- Viteza de deplasare (pixeli la fiecare cadru)
    constant MOVE_STEP : positive := 4;

    -- Coordonatele centrului (poziția inițială în mijlocul ecranului)
    signal X_CENTER : integer range X_MIN to X_MAX := H_VISIBLE / 2;
    signal Y_CENTER : integer range Y_MIN to Y_MAX := V_VISIBLE / 2;

    signal frame_tick  : std_logic;
    signal distance_sq : integer range 0 to H_VISIBLE * H_VISIBLE + V_VISIBLE * V_VISIBLE;
    signal circle_on   : std_logic;

begin

    ------------------------------------------------------------
    -- 1. Divizor de ceas (25 MHz)
    ------------------------------------------------------------
    u_divider : entity work.ClockDivider
        port map (
            ck100MHz => ck100MHz,
            ck25MHz  => pixel_tick
        );

    ------------------------------------------------------------
    -- 2. Controller-ul VGA
    ------------------------------------------------------------
    u_vga : entity work.VGA_Controller
        port map (
            ck100MHz     => ck100MHz,
            pixel_tick   => pixel_tick,
            hsync        => hsync,
            vsync        => vsync,
            active_video => video_on,
            x_pos        => x_pos,
            y_pos        => y_pos
        );

    ------------------------------------------------------------
    -- 3. Detecția sfârșitului de cadru (~60 Hz)
    ------------------------------------------------------------
    frame_tick <= '1' when (pixel_tick = '1' and video_on = '1' and 
                            x_pos = H_VISIBLE - 1 and y_pos = V_VISIBLE - 1) else '0';

    ------------------------------------------------------------
    -- 4. Actualizarea poziției X și Y în funcție de butoane
    ------------------------------------------------------------
    process(ck100MHz)
    begin
        if rising_edge(ck100MHz) then
            if frame_tick = '1' then
                
                -- --- Control Orizontal (X) ---
                if btnR = '1' and btnL = '0' then
                    -- Dreapta:
                    if X_CENTER <= X_MAX - MOVE_STEP then
                        X_CENTER <= X_CENTER + MOVE_STEP;
                    else
                        X_CENTER <= X_MAX;
                    end if;
                elsif btnL = '1' and btnR = '0' then
                    -- Stânga: 
                    if X_CENTER >= X_MIN + MOVE_STEP then
                        X_CENTER <= X_CENTER - MOVE_STEP;
                    else
                        X_CENTER <= X_MIN;
                    end if;
                end if;

                -- --- Control Vertical (Y) ---
                if btnD = '1' and btnU = '0' then
                    -- Jos: 
                    if Y_CENTER <= Y_MAX - MOVE_STEP then
                        Y_CENTER <= Y_CENTER + MOVE_STEP;
                    else
                        Y_CENTER <= Y_MAX;
                    end if;
                elsif btnU = '1' and btnD = '0' then
                    -- Sus: s
                    if Y_CENTER >= Y_MIN + MOVE_STEP then
                        Y_CENTER <= Y_CENTER - MOVE_STEP;
                    else
                        Y_CENTER <= Y_MIN;
                    end if;
                end if;

            end if;
        end if;
    end process;

    ------------------------------------------------------------
    distance_sq <= (x_pos - X_CENTER) * (x_pos - X_CENTER) + 
                   (y_pos - Y_CENTER) * (y_pos - Y_CENTER);

    circle_on <= '1' when (video_on = '1' and distance_sq <= RADIUS * RADIUS) else '0';

    vgaRed   <= "1111" when circle_on = '1' else "0000";
    vgaGreen <= "1111" when circle_on = '1' else "0000";
    vgaBlue  <= "0000";

end architecture Structural;