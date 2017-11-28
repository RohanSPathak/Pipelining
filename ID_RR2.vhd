library ieee;
use ieee.std_logic_1164.all;


entity ID_RR2 is
 	port(
 	pc_ID,pcplus1_ID : in std_logic_vector(15 downto 0);
 	clk,reset,enable: in std_logic;
 	pc_RR, pcplus1_RR : out std_logic_vector(15 downto 0));
end entity;



architecture bhv of ID_RR2 is

component dregister is
  generic (nbits : integer);                    -- no. of bits
  port (
    din  : in  std_logic_vector(nbits-1 downto 0);
    dout : out std_logic_vector(nbits-1 downto 0);
    enable: in std_logic;
    clk,reset : in  std_logic);
end component;


begin



pc_decblock: dregister generic map(nbits => 16)
					  port map( din => pc_ID ,
					  			dout => pc_RR,
					  			enable => enable ,
					  			clk => clk ,
					  			reset => reset );

pc_1_deccblock: dregister generic map(nbits => 16)
					  port map( din => pcplus1_ID ,
					  			dout => pcplus1_RR ,
					  			enable => enable ,
					  			clk => clk ,
					  			reset => reset );

end bhv;
