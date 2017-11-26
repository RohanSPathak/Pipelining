library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
 
entity Nine_To_Eight is
port(A: in std_logic_vector(8 downto 0);
	Z: out std_logic_vector(7 downto 0));
end entity;
 
architecture Behavioral of Nine_To_Eight is
 
begin
 
process (A) is
begin
Z<= A(7 downto 0);
end process;
 
end Behavioral;
