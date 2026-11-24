----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/13/2026 05:02:41 PM
-- Design Name: 
-- Module Name: alu4 - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity alu4 is
    Port ( A : in STD_LOGIC_VECTOR (3 downto 0);
           B : in STD_LOGIC_VECTOR (3 downto 0);
           OP : in STD_LOGIC_VECTOR (1 downto 0);
           RESULT : out STD_LOGIC_VECTOR (3 downto 0));
end alu4;

architecture Behavioral of alu4 is
begin
process(A, B, OP)
begin
case OP is
    when "00" =>
        RESULT <= std_logic_vector(unsigned(A) + unsigned(B));
    when "01" =>
        RESULT <= std_logic_vector(unsigned(A) - unsigned(B));
    when "10" =>
        RESULT <= A and B;
    when others =>
        RESULT <= A xor B;
end case;
end process;
end Behavioral;



