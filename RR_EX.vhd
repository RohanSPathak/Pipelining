library ieee;
use ieee.std_logic_1164.all;


entity RR_EX is
 	port(alu_inp1_RR, alu_inp2_RR, reg_temp_RR, pc_RR : in std_logic_vector(15 downto 0);
 	clk,reset,enable, mem_wr_en_RR, carry_en_RR, zero_en_RR: in std_logic;
 	alu_opcode_RR,optype_RR : in std_logic_vector(1 downto 0);
 	main_opcode_RR : in std_logic_vector(3 downto 0);
 	alu_opcode_EX,optype_EX : out std_logic_vector(1 downto 0);
 	main_opcode_EX : out std_logic_vector(3 downto 0);
 	mem_wr_en_EX, carry_en_EX, zero_en_EX: out std_logic;
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


signal  carry_en_inp_temp, zero_en_inp_temp, mem_wr_en_inp_temp, carry_en_out_temp, zero_en_out_temp, mem_wr_en_out_temp : std_logic_vector(0 downto 0) := "0";


begin

alu_opcode_block: dregister generic map(nbits => 2)
					  port map( din =>alu_opcode_RR ,
					  			dout =>alu_opcode_EX ,
					  			enable => enable ,
					  			clk => clk ,
					  			reset => reset );



optype_block: dregister generic map(nbits => 2)
					  port map( din =>optype_RR ,
					  			dout =>optype_EX ,
					  			enable => enable ,
					  			clk => clk ,
					  			reset => reset );



main_opcode_block: dregister generic map(nbits => 4)
					  port map( din =>main_opcode_RR ,
					  			dout =>main_opcode_EX ,
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






carry_en_inp_temp(0) <= carry_en_RR ;

carry_en_block: dregister generic map(nbits => 1)
					  port map( din => carry_en_inp_temp ,
					  			dout => carry_en_out_temp ,
					  			enable => enable ,
					  			clk => clk ,
					  			reset => reset );

carry_en_EX <= carry_en_out_temp(0); 

zero_en_inp_temp(0) <= zero_en_RR ;

zero_en_block: dregister generic map(nbits => 1)
					  port map( din => zero_en_inp_temp ,
					  			dout => zero_en_out_temp ,
					  			enable => enable ,
					  			clk => clk ,
					  			reset => reset );

zero_en_EX <= zero_en_out_temp(0);

mem_wr_en_inp_temp(0) <= mem_wr_en_RR;


mem_wr_en_block: dregister generic map(nbits => 1)
					  port map( din => mem_wr_en_inp_temp ,
					  			dout => mem_wr_en_out_temp ,
					  			enable => enable ,
					  			clk => clk ,
					  			reset => reset );

mem_wr_en_EX <= mem_wr_en_out_temp(0);

end bhv;
