
library IEEE;
use IEEE.STD_LOGIC_1164.all;
 

 entity mux_4in is
  generic (
    mbits : integer := 8 );	-- no. of bits of input

  port (
    d0,d1,d2,d3 : in std_logic_vector(mbits-1 downto 0);
    enable  : in  std_logic_vector(1 downto 0);
    dout : out std_logic_vector(mbits-1 downto 0));
end mux_4in;


 
architecture bhv of mux_4in is
begin
process (d0,d1,d2,enable) is
begin
  if (enable ="00" ) then
      dout <= d0;
  elsif (enable = "01") then
      dout <= d1;
  elsif (enable = "10") then 
      dout <= d2;
  else 
      dout <= d3;
  end if;
 
end process;
end bhv;

