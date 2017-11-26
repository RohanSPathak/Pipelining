
library IEEE;
use IEEE.STD_LOGIC_1164.all;
 

 entity mux_5in is
  generic (
    mbits : integer);	-- no. of bits of input

  port (
    d0,d1,d2,d3,d4 : in std_logic_vector(mbits-1 downto 0);
    enable  : in  std_logic_vector(2 downto 0);
    dout : out std_logic_vector(mbits-1 downto 0));
end mux_5in;


 
architecture bhv of mux_5in is
begin
process (d0,d1,d2,d3,d4,enable) is
begin
  if (enable ="000" ) then
      dout <= d0;
  elsif (enable = "001") then
      dout <= d1;
  elsif (enable = "010") then 
      dout <= d2;
  elsif (enable = "011") then
      dout <= d3;
  elsif (enable = "100") then
      dout <= d4;
  else   
      dout <= d0;
  end if;
 
end process;
end bhv;

