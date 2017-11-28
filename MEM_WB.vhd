library ieee;
use ieee.std_logic_1164.all;


entity MEM_WB is
 	port(memory_MEM, pc_MEM : in std_logic_vector(15 downto 0);
 	clk,reset,enable : in std_logic;
 	carry_MEM ,zero_en_MEM : in std_logic;
  main_opcode_MEM : in std_logic_vector(3 downto 0);
  main_opcode_WB : out std_logic_vector(3 downto 0);
 	carry_WB, zero_en_WB : out std_logic;
 	memory_WB, pc_WB : out std_logic_vector(15 downto 0));
end entity;

architecture bhv of MEM_WB is


component dregister is
  generic (nbits : integer);                    -- no. of bits
  port (
    din  : in  std_logic_vector(nbits-1 downto 0);
    dout : out std_logic_vector(nbits-1 downto 0);
    enable: in std_logic;
    clk,reset : in  std_logic);
end component;
signal  carry_temp_MEM,carry_temp_WB : std_logic_vector(0 downto 0):= "0";

signal  zero_en_inp_temp, zero_en_out_temp : std_logic_vector(0 downto 0) := "0";


begin

carry_temp_MEM(0) <= carry_MEM;

carry_block: dregister generic map(nbits => 1)
					  port map( din =>carry_temp_MEM ,
					  			dout =>carry_temp_WB ,
					  			enable => enable ,
					  			clk => clk ,
					  			reset => reset );

carry_WB <= carry_temp_WB(0);


memory_block: dregister generic map(nbits => 16)
            port map( din =>memory_MEM ,
                  dout =>memory_WB ,
                  enable => enable ,
                  clk => clk ,
                  reset => reset );




pc_block: dregister generic map(nbits => 16)
            port map( din =>pc_MEM ,
                  dout =>pc_WB ,
                  enable => enable ,
                  clk => clk ,
                  reset => reset );




main_opcode_block: dregister generic map(nbits => 4)
            port map( din =>main_opcode_MEM ,
                  dout =>main_opcode_WB ,
                  enable => enable ,
                  clk => clk ,
                  reset => reset );



zero_en_inp_temp(0) <= zero_en_MEM ;

zero_en_block: dregister generic map(nbits => 1)
            port map( din => zero_en_inp_temp ,
                  dout => zero_en_out_temp ,
                  enable => enable ,
                  clk => clk ,
                  reset => reset );

zero_en_WB <= zero_en_out_temp(0);


end bhv;
