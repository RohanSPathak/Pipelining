library ieee;
use ieee.std_logic_1164.all;


entity EX_MEM is
 	port(alu_output_EX,alu_temp_EX,pc_EX : in std_logic_vector(15 downto 0);
 	clk,reset,enable, mem_wr_en_EX ,zero_en_EX : in std_logic;
 	optype_EX : in std_logic_vector(1 downto 0);
 	main_opcode_EX : in std_logic_vector(3 downto 0);
 	main_opcode_MEM : out std_logic_vector(3 downto 0);
 	optype_MEM : out std_logic_vector(1 downto 0);
 	mem_wr_en_MEM ,zero_en_MEM : out std_logic;
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


signal  zero_en_inp_temp, mem_wr_en_inp_temp,  zero_en_out_temp, mem_wr_en_out_temp : std_logic_vector(0 downto 0) := "0";



begin

optype_block: dregister generic map(nbits => 2)
					  port map( din =>optype_EX ,
					  			dout =>optype_MEM ,
					  			enable => enable ,
					  			clk => clk ,
					  			reset => reset );



main_opcode_block: dregister generic map(nbits => 4)
					  port map( din =>main_opcode_EX ,
					  			dout =>main_opcode_MEM ,
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



zero_en_inp_temp(0) <= zero_en_EX ;

zero_en_block: dregister generic map(nbits => 1)
					  port map( din => zero_en_inp_temp ,
					  			dout => zero_en_out_temp ,
					  			enable => enable ,
					  			clk => clk ,
					  			reset => reset );

zero_en_MEM <= zero_en_out_temp(0);

mem_wr_en_inp_temp(0) <= mem_wr_en_EX;


mem_wr_en_block: dregister generic map(nbits => 1)
					  port map( din => mem_wr_en_inp_temp ,
					  			dout => mem_wr_en_out_temp ,
					  			enable => enable ,
					  			clk => clk ,
					  			reset => reset );

mem_wr_en_MEM <= mem_wr_en_out_temp(0);


end bhv;
