
library IEEE;
use IEEE.STD_LOGIC_1164.all;
 

 entity mux_2in is
  generic (
    mbits : integer := 8 );	-- no. of bits of input

  port (
    din0,din1 : in std_logic_vector(mbits-1 downto 0);
    enable  : in  std_logic;
    dout : out std_logic_vector(mbits-1 downto 0));
end mux_2in;


 
architecture bhv of mux_2in is
begin
process (din0,din1,enable) is
begin
  if (enable ='0' ) then
      dout <= din0;
  else
      dout <= din1;
  
  end if;
 
end process;
end bhv;

