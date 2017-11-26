library ieee;
use ieee.std_logic_1164.all;
 
entity dregister is
  generic (
    nbits : integer);                    -- no. of bits
  port (
    din  : in  std_logic_vector(nbits-1 downto 0);
    dout : out std_logic_vector(nbits-1 downto 0);
    enable: in std_logic;
    clk,reset : in  std_logic);
end dregister;

architecture behave of dregister is

begin  -- behave
process(clk,reset,enable)
begin 
  
if reset ='1' then
  dout <= (others => '0');
elsif (rising_edge(clk) and enable = '1') then
      dout <= din;
end if;

end process;
end behave;
