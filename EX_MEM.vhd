library ieee;
use ieee.std_logic_1164.all;


entity EX_MEM is
 	port(alu_output_EX,alu_temp_EX,pc_EX : in std_logic_vector(15 downto 0);
 	clk,reset,enable : in std_logic;
 	optype_EX : in std_logic_vector(1 downto 0);
 	optype_MEM : out std_logic_vector(1 downto 0);
 	alu_output_MEM,alu_temp_MEM,pc_MEM : out std_logic_vector(15 downto 0));
end entity;

architecture bhv of EX_MEM is


component dregister is
  generic (nbits : integer);                    -- no. of bits
  port (
    din  : in  std_logic_vector(nbits-1 downto 0);
    dout : out std_logic_vector(nbits-1 downto 0);
    enable: in std_logic;
    clk,reset : in  std_logic);
end component;

begin

optype_block: dregister generic map(nbits => 2)
					  port map( din =>optype_EX ,
					  			dout =>optype_MEM ,
					  			enable => enable ,
					  			clk => clk ,
					  			reset => reset );



aluoutput_block: dregister generic map(nbits => 16)
					  port map( din =>alu_output_EX ,
					  			dout =>alu_output_MEM ,
					  			enable => enable ,
					  			clk => clk ,
					  			reset => reset );



alutemp_block: dregister generic map(nbits => 2)
					  port map( din =>alu_temp_EX ,
					  			dout =>alu_temp_MEM ,
					  			enable => enable ,
					  			clk => clk ,
					  			reset => reset );



pc_block: dregister generic map(nbits => 2)
					  port map( din =>pc_EX ,
					  			dout =>pc_MEM ,
					  			enable => enable ,
					  			clk => clk ,
					  			reset => reset );




end bhv;
