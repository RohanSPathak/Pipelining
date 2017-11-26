library ieee;
use ieee.std_logic_1164.all;

entity IF_ID is
 	port(pc_IF,pcplus1_IF, imem_IF: in std_logic_vector(15 downto 0);
 	clk,reset,enable : in std_logic;
 	pc_ID,pcplus1_ID, imem_ID: out std_logic_vector(15 downto 0));
end entity;

architecture bhv of IF_ID is


component dregister is
  generic (nbits : integer);                    -- no. of bits
  port (
    din  : in  std_logic_vector(nbits-1 downto 0);
    dout : out std_logic_vector(nbits-1 downto 0);
    enable: in std_logic;
    clk,reset : in  std_logic);
end component;


begin

memblock: dregister generic map(nbits => 16)
					  port map( din =>imem_IF ,
					  			dout =>imem_ID,
					  			enable => enable ,
					  			clk => clk ,
					  			reset => reset );


pc_block: dregister generic map(nbits => 16)
					  port map( din =>pc_IF ,
					  			dout =>pc_ID ,
					  			enable => enable ,
					  			clk => clk ,
					  			reset => reset );


Pcplus1_block: dregister generic map(nbits => 16)
					  port map( din =>pcplus1_IF ,
					  			dout =>pcplus1_ID ,
					  			enable => enable ,
					  			clk => clk ,
					  			reset => reset );



end bhv;
