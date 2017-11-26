library ieee;
use ieee.std_logic_1164.all;

entity decoder is
 	port(IR	     		 : in std_logic_vector(15 downto 0);
 	cflag,zflag			 : in std_logic;
 	dec_temp			 : out std_logic_vector(15 downto 0);
	dec_a1,dec_a2,dec_a3 : out std_logic_vector(2 downto 0);
	nineto8 			 : out std_logic_vector(7 downto 0);
	dec_opcode 			 :out std_logic_vector(1 downto 0);
	wr_en 				 : out std_logic);
end entity;

architecture bhv of decoder is

signal ra,rb,rc : std_logic_vector(2 downto 0):="000";
signal opcode : std_logic_vector(3 downto 0):="0000";
signal imm6 : std_logic_vector(5 downto 0):="000000";
signal imm9 : std_logic_vector(8 downto 0):="000000000";
signal cz,enable_temp : std_logic_vector(1 downto 0):="00";
signal se9_temp,se6_temp,sl6_temp : std_logic_vector(15 downto 0):="0000000000000000";

component Nine_To_Eight is
port(A: in std_logic_vector(8 downto 0);
	Z: out std_logic_vector(7 downto 0));
end component;

 
component se6 is
port(A: in std_logic_vector(5 downto 0);
	Z: out std_logic_vector(15 downto 0));
end component;
 

component se9 is
port(A: in std_logic_vector(8 downto 0);
	Z: out std_logic_vector(15 downto 0));
end component;
 

component sl6 is
port(A: in std_logic_vector(8 downto 0);
	Z: out std_logic_vector(15 downto 0));
end component;

component mux_3in is
  generic (
    mbits : integer );	-- no. of bits of input
  port ( d0,d1,d2 : in std_logic_vector(mbits-1 downto 0);
    enable  : in  std_logic_vector(1 downto 0);
    dout : out std_logic_vector(mbits-1 downto 0));
end component;


begin
process (IR) is
begin
  
opcode <= IR(15 downto 12);
ra <= IR(11 downto 9);
rb <= IR(8 downto 6);
rc <= IR(5 downto 3);
cz <= IR(1 downto 0);
imm6 <= IR(5 downto 0);
imm9 <= IR(8 downto 0);

dec_a1 <= ra;
dec_a2 <= rb;
dec_a3 <= rc;



--I1: Nine_To_Eight port map(imm9,nineto8);

--pe_map1	: Nine_To_Eight port map(A=> imm9, Z=> nineto8);

if (opcode = "0010") then 
		dec_opcode <= "10"; 
else 
		dec_opcode <= "00"; 
end if ;


if (opcode = "0101" or opcode = "0111" or opcode = "1100") then 
	wr_en <= '0';
else 
		if (opcode(3 downto 1) = "000" and cz(1) = '1' and cflag = '0' ) then
			wr_en <= '0';
		elsif (opcode(3 downto 1) = "000" and cz(0) = '1' and zflag = '0') then
			wr_en <= '0';
		else 
			wr_en <= '1'; 
	  	end if ; 
end if ;

if (opcode = "1000") then --For JAL 
	enable_temp <= "01";    --We want output as SE9
elsif (opcode = "0011") then --For LHI
	enable_temp <= "10";    --We want output as SL6
else 
	enable_temp <= "00";
end if ;

end process;


Nine_To_Eightblock: Nine_To_Eight port map(A => imm9, Z => nineto8);

sl6block: sl6 port map(A => imm9, Z => sl6_temp);

se9block: se9 port map(A => imm9, Z => se9_temp);--

se6block: se6 port map(A => imm6, Z => se6_temp);

mux_3inblock: mux_3in generic map(mbits => 16)
			port map (d0 =>se6_temp, d1 => se9_temp, d2 => sl6_temp, enable => enable_temp	, dout => dec_temp);

end bhv;

