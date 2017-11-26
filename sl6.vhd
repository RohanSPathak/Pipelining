library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
 
entity sl6 is
port(A: in std_logic_vector(8 downto 0);
	Z: out std_logic_vector(15 downto 0));
end entity;
 
architecture Behavioral of sl6 is
 
begin
 
process (A) is
begin
Z(15 downto 7)<= A;
Z(6 downto 0)<= "0000000";
end process;
 
end Behavioral;
