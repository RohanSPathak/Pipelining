library ieee;
use ieee.std_logic_1164.all;

entity ID_RR is
 	port(decoder_input	: in std_logic_vector(35 downto 0);
 	pc,pc_inc : in std_logic_vector(15 downto 0);
 	clk,reset,enable,mux1,mux2 : in std_logic;
 	ID_RR_output : out std_logic_vector(63 downto 0));
end entity;

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
signal pe_zero : std_logic := '0';

begin

wr_enblock: dregister generic map(nbits => 1)
					  port map( din => decoder_input(0 downto 0) ,
					  			dout => ID_RR_output(0 downto 0) ,
					  			enable => enable ,
					  			clk => clk ,
					  			reset => reset );


opcodeblock: dregister generic map(nbits => 2)
					  port map( din =>decoder_input(2 downto 1) ,
					  			dout =>ID_RR_output(2 downto 1) ,
					  			enable => enable ,
					  			clk => clk ,
					  			reset => reset );

a1block: dregister generic map(nbits => 3)
					  port map( din => decoder_input(5 downto 3) ,
					  			dout => ID_RR_output(5 downto 3) ,
					  			enable => enable ,
					  			clk => clk ,
					  			reset => reset  );

a2block: dregister generic map(nbits => 3)
					  port map( din => decoder_input(8 downto 6) ,
					  			dout => ID_RR_output(8 downto 6) ,
					  			enable => enable ,
					  			clk => clk ,
					  			reset => reset  );

mux_a3block: mux_2in generic map( mbits => 3)
					  port map( din0 => decoder_input(11 downto 9) ,
					  			din1 => pe_out ,
					  			enable =>mux1 ,
					  			dout => id_a3_1 );


a3block: dregister generic map(nbits => 3)
					  port map( din =>id_a3_1 ,
					  			dout =>id_a3_2 ,
					  			enable => enable ,
					  			clk => clk ,
					  			reset => reset );

a3A_block: dregister generic map(nbits => 3)
					  port map( din =>id_a3_2 ,
					  			dout =>id_a3_3 ,
					  			enable => enable ,
					  			clk => clk ,
					  			reset => reset );

a3B_block: dregister generic map(nbits => 3)
					  port map( din =>id_a3_3 ,
					  			dout =>id_a3_4 ,
					  			enable => enable ,
					  			clk => clk ,
					  			reset => reset );

a3C_block: dregister generic map(nbits => 3)
					  port map( din =>id_a3_4 ,
					  			dout =>ID_RR_output(11 downto 9) ,
					  			enable => enable ,
					  			clk => clk ,
					  			reset => reset );

mux_pe: mux_2in generic map( mbits => 8)
					  port map( din0 => decoder_input(19 downto 12) ,
					  			din1 => pe_input ,
					  			enable =>mux2 ,
					  			dout => pe_input );


pe_block: pe_lmsm port map( input => pe_input, 
							S0 => pe_out(0), 
							S1 => pe_out(1), 
							S2 => pe_out(2),
							Z => pe_zero, 
							output => pe_reg_out ,
							reset => reset );


pe_regblock: dregister generic map(nbits => 8)
					  port map( din => pe_value ,
					  			dout =>pe_reg_out ,
					  			enable => enable ,
					  			clk => clk ,
					  			reset => reset );



tempblock: dregister generic map(nbits => 16)
					  port map( din => decoder_input(35 downto 16) ,
					  			dout => ID_RR_output(30 downto 15) ,
					  			enable => enable ,
					  			clk => clk ,
					  			reset => reset );

pc_decblock: dregister generic map(nbits => 16)
					  port map( din => pc ,
					  			dout => ID_RR_output(46 downto 31),
					  			enable => enable ,
					  			clk => clk ,
					  			reset => reset );

pc_1_deccblock: dregister generic map(nbits => 16)
					  port map( din => pc_inc ,
					  			dout => ID_RR_output(62 downto 46) ,
					  			enable => enable ,
					  			clk => clk ,
					  			reset => reset );



end bhv;
