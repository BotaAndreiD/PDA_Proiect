library ieee;
use ieee.std_logic_1164.all;
entity sync_2ff is 
 port (clk : in std_logic; 
 async_in : in std_logic; 
 sync_out : out std_logic);
end entity;
architecture rtl of sync_2ff is 
 signal ff1 : std_logic := '0'; 
 signal ff2 : std_logic := '0'; 
 attribute ASYNC_REG : string; 
 attribute ASYNC_REG of ff1 : signal is "TRUE"; 
 attribute ASYNC_REG of ff2 : signal is "TRUE";
begin 
 process(clk) 
 begin 
 if rising_edge(clk) then 
 ff1 <= async_in; 
 ff2 <= ff1; 
 end if; 
 end process; 
 sync_out <= ff2;
end architecture;
