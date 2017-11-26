library IEEE;
use IEEE.STD_LOGIC_1164.all;
 
entity pe_lmsm is
 port(input : in std_logic_vector(7 downto 0);
      S0,S1,S2,Z: out std_logic;
      output: out std_logic_vector(7 downto 0);
 reset : in std_logic);
end pe_lmsm;
 
architecture bhv of pe_lmsm is
begin
process (input,reset) is
begin

output <= input;
  if (reset = '1') then output<="00000000"; 
  elsif (input(0) = '1') then
	output(0) <= '0';
	S0 <= '0';
	S1 <= '0';
	S2 <= '0';
	Z <= '0';
  elsif (input(1) = '1') then
	output(1) <= '0';
	S0 <= '1';
	S1 <= '0';
	S2 <= '0';
	Z <= '0';
  elsif (input(2) = '1') then
	output(2) <= '0';
	S0 <= '0';
	S1 <= '1';
	S2 <= '0';
	Z <= '0';
  elsif (input(3) = '1') then
	output(3) <= '0';
	S0 <= '1';
	S1 <= '1';
	S2 <= '0';
	Z <= '0';
  elsif (input(4) = '1') then
	output(4) <= '0';
	S0 <= '0';
	S1 <= '0';
	S2 <= '1';
	Z <= '0';
  elsif (input(5) = '1') then
	output(5) <= '0';
	S0 <= '1';
	S1 <= '0';
	S2 <= '1';
	Z <= '0';
  elsif (input(6) = '1') then
	output(6) <= '0';
	S0 <= '0';
	S1 <= '1';
	S2 <= '1';
	Z <= '0';
  elsif (input(7) = '1') then
	output(7) <= '0';
	S0 <= '1';
	S1 <= '1';
	S2 <= '1';
	Z <= '0';
  else
	S0 <= '0';
	S1 <= '0';
	S2 <= '0';
	Z <= '1';
  end if;
 
end process;
end bhv;
