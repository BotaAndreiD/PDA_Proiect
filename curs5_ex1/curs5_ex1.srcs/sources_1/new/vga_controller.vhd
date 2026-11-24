library ieee;
use ieee.std_logic_1164.all;
use work.DisplayDefinition.all;

entity VGA_Controller is
    port (
        ck100MHz     : in  std_logic;
        pixel_tick   : in  std_logic;
        hsync        : out std_logic;
        vsync        : out std_logic;
        active_video : out std_logic;
        x_pos        : out integer range 0 to H_VISIBLE - 1;
        y_pos        : out integer range 0 to V_VISIBLE - 1
    );
end entity VGA_Controller;

architecture RTL of VGA_Controller is
    signal h_count  : integer range 0 to H_TOTAL - 1 := 0;
    signal v_count  : integer range 0 to V_TOTAL - 1 := 0;
    signal video_on : std_logic;
begin

    ------------------------------------------------------------
    -- 1. Contoarele orizontal și vertical
    ------------------------------------------------------------
    process(ck100MHz)
    begin
        if rising_edge(ck100MHz) then
            if pixel_tick = '1' then
                if h_count = H_TOTAL - 1 then
                    h_count <= 0;
                    if v_count = V_TOTAL - 1 then
                        v_count <= 0;
                    else
                        v_count <= v_count + 1;
                    end if;
                else
                    h_count <= h_count + 1;
                end if;
            end if;
        end if;
    end process;

    ------------------------------------------------------------
    -- 2. Sincronizarea orizontală (activă pe 0)
    ------------------------------------------------------------
    hsync <= H_SYNC_ACTIVE when (h_count >= H_SYNC_START and h_count < H_SYNC_END) else not H_SYNC_ACTIVE;

    ------------------------------------------------------------
    -- 3. Sincronizarea verticală (activă pe 0)
    ------------------------------------------------------------
    vsync <= V_SYNC_ACTIVE when (v_count >= V_SYNC_START and v_count < V_SYNC_END) else not V_SYNC_ACTIVE;

    ------------------------------------------------------------
    -- 4. Identificarea zonei vizibile
    ------------------------------------------------------------
    video_on <= '1' when (h_count < H_VISIBLE and v_count < V_VISIBLE) else '0';
    active_video <= video_on;

    ------------------------------------------------------------
    -- 5. Coordonatele pixelului vizibil
    ------------------------------------------------------------
    x_pos <= h_count when video_on = '1' else 0;
    y_pos <= v_count when video_on = '1' else 0;

end architecture RTL;