library ieee;
use ieee.std_logic_1164.all;


entity ID_RR is
 	port(decoder_input	: in std_logic_vector(44 downto 0);
 	--pc_ID,pcplus1_ID : in std_logic_vector(15 downto 0);
 	clk,reset,enable,wr_en_update,mux1_en,mux2_en,mux3_en : in std_logic;
 	wr_en_RR, wr_en_EX, wr_en_MEM, wr_en_WB, pe_zero, mem_wr_en_RR, carry_en_RR, zero_en_RR : out std_logic;
 	alu_opcode_RR,optype_RR : out std_logic_vector(1 downto 0);
 	rf_a1_RR, rf_a2_RR, rf_a3_RR, rf_a3_EX, rf_a3_MEM, rf_a3_WB, pe_out_RR : out std_logic_vector(2 downto 0);
 	main_opcode_RR : out std_logic_vector(3 downto 0);
 	temp_RR : out std_logic_vector(15 downto 0));
--, pc_RR, pcplus1_RR
end entity;


--INPUT
--wr_en_RR 	1 bit
--wr_en_EX	1 bit
--wr_en_MEM	1 bit
--wr_en_WB	1 bit
--alu_opcode_RR	2 bit
--rf_a1_RR	3 bit
--rf_a2_RR 	3 bit
--rf_a3_RR	3 bit
--rf_a3_EX	3 bit
--rf_a3_MEM	3 bit
--rf_a3_WB	3 bit
--pe_out_RR	3 bit
--pe_zero		1 bit
--temp_RR		16 bit
--pc_RR		16 bit
--pcplus1_RR	16 bit



architecture bhv of ID_RR is

component dregister is
  generic (nbits : integer);                    -- no. of bits
  port (
    din  : in  std_logic_vector(nbits-1 downto 0);
    dout : out std_logic_vector(nbits-1 downto 0);
    enable: in std_logic;
    clk,reset : in  std_logic);
end component;

 
 component mux_2in is
  generic ( mbits : integer );	-- no. of bits of input
  port (
    din0,din1 : in std_logic_vector(mbits-1 downto 0);
    enable  : in  std_logic;
    dout : out std_logic_vector(mbits-1 downto 0));
end component;


component pe_lmsm is
 port(input : in std_logic_vector(7 downto 0);
      S0,S1,S2,Z: out std_logic;
      output: out std_logic_vector(7 downto 0);
 reset : in std_logic);
end component;
 
signal pe_out,id_a3_1,id_a3_2,id_a3_3,id_a3_4 : std_logic_vector(2 downto 0):="000";
signal pe_reg_out,pe_value,pe_input : std_logic_vector(7 downto 0):="00000000";
--signal pe_zero : std_logic := '0';

signal wr_en_1, wr_en_2, wr_en_3, wr_en_4, wr_en_5, wr_en_update_temp, carry_en_temp, zero_en_temp, mem_wr_en_temp : std_logic_vector(0 downto 0) := "0";


begin


wr_enblock: dregister generic map(nbits => 1)
					  port map( din => decoder_input(0 downto 0) ,
					  			dout => wr_en_1 ,
					  			enable => enable ,
					  			clk => clk ,
					  			reset => reset );

wr_en_RR <= wr_en_1(0);

wr_en_A_block: dregister generic map(nbits => 1)
					  port map( din => wr_en_1 ,
					  			dout => wr_en_2 ,
					  			enable => enable ,
					  			clk => clk ,
					  			reset => reset );

wr_en_EX <= wr_en_2(0);

wr_en_B_block: dregister generic map(nbits => 1)
					  port map( din => wr_en_2 ,
					  			dout => wr_en_3 ,
					  			enable => enable ,
					  			clk => clk ,
					  			reset => reset );

wr_en_MEM <= wr_en_3(0);

wr_en_update_temp(0) <= wr_en_update;

mux_wr_block: mux_2in generic map( mbits => 1)
					  port map( din0 => wr_en_3 ,
					  			din1 => wr_en_update_temp ,
					  			enable =>mux3_en ,
					  			dout => wr_en_4 );



wr_en_C_block: dregister generic map(nbits => 1)
					  port map( din => wr_en_4 ,
					  			dout => wr_en_5 ,
					  			enable => enable ,
					  			clk => clk ,
					  			reset => reset );

wr_en_WB <= wr_en_5(0);


aluopcodeblock: dregister generic map(nbits => 2)
					  port map( din =>decoder_input(2 downto 1) ,
					  			dout =>alu_opcode_RR ,
					  			enable => enable ,
					  			clk => clk ,
					  			reset => reset );

a1block: dregister generic map(nbits => 3)
					  port map( din => decoder_input(5 downto 3) ,
					  			dout => rf_a1_RR ,
					  			enable => enable ,
					  			clk => clk ,
					  			reset => reset  );

a2block: dregister generic map(nbits => 3)
					  port map( din => decoder_input(8 downto 6) ,
					  			dout => rf_a2_RR ,
					  			enable => enable ,
					  			clk => clk ,
					  			reset => reset  );

mux_a3block: mux_2in generic map( mbits => 3)
					  port map( din0 => decoder_input(11 downto 9) ,
					  			din1 => pe_out ,
					  			enable =>mux1_en ,
					  			dout => id_a3_1 );


a3block: dregister generic map(nbits => 3)
					  port map( din =>id_a3_1 ,
					  			dout =>id_a3_2 ,
					  			enable => enable ,
					  			clk => clk ,
					  			reset => reset );

rf_a3_RR <= id_a3_2 ;

a3A_block: dregister generic map(nbits => 3)
					  port map( din =>id_a3_2 ,
					  			dout =>id_a3_3 ,
					  			enable => enable ,
					  			clk => clk ,
					  			reset => reset );

rf_a3_EX <= id_a3_3 ;

a3B_block: dregister generic map(nbits => 3)
					  port map( din =>id_a3_3 ,
					  			dout =>id_a3_4 ,
					  			enable => enable ,
					  			clk => clk ,
					  			reset => reset );

rf_a3_MEM <= id_a3_4 ;

a3C_block: dregister generic map(nbits => 3)
					  port map( din =>id_a3_4 ,
					  			dout =>rf_a3_WB ,
					  			enable => enable ,
					  			clk => clk ,
					  			reset => reset );

mux_pe: mux_2in generic map( mbits => 8)
					  port map( din0 => decoder_input(19 downto 12) ,
					  			din1 => pe_reg_out ,
					  			enable =>mux2_en ,
					  			dout => pe_input );


pe_block: pe_lmsm port map( input => pe_input, 
							S0 => pe_out(0), 
							S1 => pe_out(1), 
							S2 => pe_out(2),
							Z => pe_zero, 
							output => pe_value ,
							reset => reset );

pe_out_RR <= pe_out;

pe_regblock: dregister generic map(nbits => 8)
					  port map( din => pe_value ,
					  			dout =>pe_reg_out ,
					  			enable => enable ,
					  			clk => clk ,
					  			reset => reset );



tempblock: dregister generic map(nbits => 16)
					  port map( din => decoder_input(35 downto 20) ,
					  			dout => temp_RR ,
					  			enable => enable ,
					  			clk => clk ,
					  			reset => reset );

--pc_decblock: dregister generic map(nbits => 16)
--					  port map( din => pc_ID ,
--					  			dout => pc_RR,
--					  			enable => enable ,
--					  			clk => clk ,
--					  			reset => reset );

--pc_1_deccblock: dregister generic map(nbits => 16)
--					  port map( din => pcplus1_ID ,
--					  			dout => pcplus1_RR ,
--					  			enable => enable ,
--					  			clk => clk ,
--					  			reset => reset );


optype_block: dregister generic map(nbits => 2)
					  port map( din => decoder_input(37 downto 36) ,
					  			dout => optype_RR ,
					  			enable => enable ,
					  			clk => clk ,
					  			reset => reset );


main_opcode_block: dregister generic map(nbits => 4)
					  port map( din => decoder_input(41 downto 38) ,
					  			dout => main_opcode_RR ,
					  			enable => enable ,
					  			clk => clk ,
					  			reset => reset );


--mem_wr_en_RR, carry_en_RR, zero_en_RR

--decoder_output(42) <= carry_en ;
--decoder_output(43) <= zero_en :
--decoder_output(44) <= mem_wr_en ;


carry_en_block: dregister generic map(nbits => 1)
					  port map( din => decoder_input(42 downto 42) ,
					  			dout => carry_en_temp ,
					  			enable => enable ,
					  			clk => clk ,
					  			reset => reset );

carry_en_RR <= carry_en_temp(0);

zero_en_block: dregister generic map(nbits => 1)
					  port map( din => decoder_input(43 downto 43) ,
					  			dout => zero_en_temp ,
					  			enable => enable ,
					  			clk => clk ,
					  			reset => reset );

zero_en_RR <= zero_en_temp(0);

mem_wr_en_block: dregister generic map(nbits => 1)
					  port map( din => decoder_input(44 downto 44) ,
					  			dout => mem_wr_en_temp ,
					  			enable => enable ,
					  			clk => clk ,
					  			reset => reset );

mem_wr_en_RR <= mem_wr_en_temp(0);

end bhv;
