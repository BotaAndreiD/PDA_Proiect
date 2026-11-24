library ieee;
use ieee.std_logic_1164.all;

-- Definitii pentru modul video 640 x 480.
-- Ordine: zona vizibila -> front porch -> sync -> back porch.
package DisplayDefinition is
    -- Numar de perioade de pixel pe orizontala.
    constant H_VISIBLE     : positive := 640;
    constant H_FRONT_PORCH : positive := 16;
    constant H_SYNC_PULSE  : positive := 96;
    constant H_BACK_PORCH  : positive := 48;
    constant H_SYNC_START  : natural  := H_VISIBLE + H_FRONT_PORCH;
    constant H_SYNC_END    : natural  := H_SYNC_START + H_SYNC_PULSE;
    constant H_TOTAL       : positive := H_SYNC_END + H_BACK_PORCH;

    -- Numar de linii pe verticala.
    constant V_VISIBLE     : positive := 480;
    constant V_FRONT_PORCH : positive := 10;
    constant V_SYNC_PULSE  : positive := 2;
    constant V_BACK_PORCH  : positive := 33;
    constant V_SYNC_START  : natural  := V_VISIBLE + V_FRONT_PORCH;
    constant V_SYNC_END    : natural  := V_SYNC_START + V_SYNC_PULSE;
    constant V_TOTAL       : positive := V_SYNC_END + V_BACK_PORCH;

    constant H_SYNC_ACTIVE : std_logic := '0';
    constant V_SYNC_ACTIVE : std_logic := '0';

    -- Basys3: cate 4 biti pentru fiecare componenta de culoare.
    subtype color_component is std_logic_vector(3 downto 0);

    -- Culoare implicita: rosu la intensitate maxima.
    constant DEFAULT_RED   : color_component := "1111";
    constant DEFAULT_GREEN : color_component := "1111";
    constant DEFAULT_BLUE  : color_component := "1111";
end package DisplayDefinition;