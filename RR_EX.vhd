library ieee;
use ieee.std_logic_1164.all;


entity RR_EX is
 	port(alu_inp1_RR, alu_inp2_RR, reg_temp_RR, pc_RR : in std_logic_vector(15 downto 0);
 	clk,reset,enable : in std_logic;
 	opcode_RR,optype_RR : in std_logic_vector(1 downto 0);
 	opcode_EX,optype_EX : out std_logic_vector(1 downto 0);
 	alu_inp1_EX, alu_inp2_EX, reg_temp_EX, pc_EX : out std_logic_vector(15 downto 0));
end entity;

architecture bhv of RR_EX is


component dregister is
  generic (nbits : integer);                    -- no. of bits
  port (
    din  : in  std_logic_vector(nbits-1 downto 0);
    dout : out std_logic_vector(nbits-1 downto 0);
    enable: in std_logic;
    clk,reset : in  std_logic);
end component;

begin

opcode_block: dregister generic map(nbits => 2)
					  port map( din =>opcode_RR ,
					  			dout =>opcode_EX ,
					  			enable => enable ,
					  			clk => clk ,
					  			reset => reset );



optype_block: dregister generic map(nbits => 2)
					  port map( din =>optype_RR ,
					  			dout =>optype_EX ,
					  			enable => enable ,
					  			clk => clk ,
					  			reset => reset );



alu_inp1_block: dregister generic map(nbits => 16)
					  port map( din =>alu_inp1_RR ,
					  			dout =>alu_inp1_EX ,
					  			enable => enable ,
					  			clk => clk ,
					  			reset => reset );


alu_inp2_block: dregister generic map(nbits => 16)
					  port map( din =>alu_inp2_RR ,
					  			dout =>alu_inp2_EX ,
					  			enable => enable ,
					  			clk => clk ,
					  			reset => reset );


reg_temp_block: dregister generic map(nbits => 16)
					  port map( din =>reg_temp_RR ,
					  			dout =>reg_temp_EX ,
					  			enable => enable ,
					  			clk => clk ,
					  			reset => reset );


pc_RR_block: dregister generic map(nbits => 16)
					  port map( din =>pc_RR ,
					  			dout =>pc_EX ,
					  			enable => enable ,
					  			clk => clk ,
					  			reset => reset );



end bhv;
