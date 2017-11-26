library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
 
entity se9 is
port(A: in std_logic_vector(8 downto 0);
	Z: out std_logic_vector(15 downto 0));
end se9;
 
architecture Behavioral of se9 is
 
begin
 
process (A) is
begin
Z(8 downto 0)<= A;
if (a(8) ='0') then
Z(15 downto 9) <= "0000000";
else
Z(15 downto 9) <= "1111111";
end if;
end process;
 
end Behavioral;
