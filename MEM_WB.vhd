library ieee;
use ieee.std_logic_1164.all;


entity MEM_WB is
 	port(memory_MEM, pc_MEM : in std_logic_vector(15 downto 0);
 	clk,reset,enable : in std_logic;
 	carry_MEM : in std_logic;
 	carry_WB : out std_logic;
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





end bhv;
