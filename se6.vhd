library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
 
entity se6 is
port(A: in std_logic_vector(5 downto 0);
	Z: out std_logic_vector(15 downto 0));
end se6;
 
architecture Behavioral of se6 is
 
begin
 
process (A) is
begin
Z(5 downto 0)<= A;
if (a(5) ='0') then
Z(15 downto 6) <= "0000000000";
else
Z(15 downto 6) <= "1111111111";
end if;
end process;
 
end Behavioral;
