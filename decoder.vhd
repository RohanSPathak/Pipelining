library ieee;
use ieee.std_logic_1164.all;

entity decoder is
 	port(IR	       : in std_logic_vector(15 downto 0);
 	decoder_output : out std_logic_vector(44 downto 0));
-- 	dec_temp			 : out std_logic_vector(15 downto 0);
--	dec_a1,dec_a2,dec_a3 : out std_logic_vector(2 downto 0);
--	nineto8 			 : out std_logic_vector(7 downto 0);
--	dec_opcode 			 : out std_logic_vector(1 downto 0);
--	wr_en 				 : out std_logic);
end entity;

architecture bhv of decoder is

signal ra,rb,rc : std_logic_vector(2 downto 0):="000";
signal opcode : std_logic_vector(3 downto 0):="0000";
signal imm6 : std_logic_vector(5 downto 0):="000000";
signal imm9 : std_logic_vector(8 downto 0):="000000000";
signal cz,enable_temp : std_logic_vector(1 downto 0):="00";
signal se9_temp,se6_temp,sl6_temp : std_logic_vector(15 downto 0):="0000000000000000";

signal	dec_temp			 : std_logic_vector(15 downto 0) := (others => '0');
signal	dec_a1,dec_a2,dec_a3 : std_logic_vector(2 downto 0) := "000";
signal	nineto8 			 : std_logic_vector(7 downto 0) := "00000000";
signal	dec_opcode 			 : std_logic_vector(1 downto 0) := "00";
signal	wr_en 				 : std_logic := '0';

signal  zero_en, carry_en, mem_wr_en  : std_logic_vector(0 downto 0) := "0";

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
  
--opcode <= IR(15 downto 12);
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

if (IR(15 downto 12) = "0010") then 
		dec_opcode <= "10"; 
else 
		dec_opcode <= "00"; 
end if ;


if (IR(15 downto 12) = "0101" or IR(15 downto 12) = "0111" or IR(15 downto 12) = "1100") then 
	wr_en <= '0';
else  
	wr_en <= '1'; 
end if ;

if (IR(15 downto 12) = "1000") then --For JAL 
	enable_temp <= "01";    --We want output as SE9
elsif (IR(15 downto 12) = "0011") then --For LHI
	enable_temp <= "10";    --We want output as SL6
else 
	enable_temp <= "00";
end if ;



-- Carry enable is 1 for ADD, ADC, ADZ, ADI i.e 0000 and 0001
-- Zero enable is 1 for ADD, ADC, ADZ, ADI, NDU, NDC, NDZ, LW i.e 0000, 0001, 0010 and 0100
if (IR(15 downto 12) = "0000" or IR(15 downto 12) = "0001") then
	carry_en(0) <= '1';
else 
	carry_en(0) <= '0';
end if ;

if (IR(15 downto 12) = "0000" or IR(15 downto 12) = "0001" or IR(15 downto 12) ="0010" or IR(15 downto 12) = "0100") then
	zero_en(0) <= '1';
else 
	zero_en(0) <= '0';
end if ;

-- mem_wr_en is 1 for SM and SW i.e 0101 and 0111
if (IR(15 downto 12) = "0101" or IR(15 downto 12) = "0111") then
	mem_wr_en(0) <= '1';
else 
	mem_wr_en(0) <= '0';
end if ;




end process;


Nine_To_Eightblock: Nine_To_Eight port map(A => imm9, Z => nineto8);

sl6block: sl6 port map(A => imm9, Z => sl6_temp);

se9block: se9 port map(A => imm9, Z => se9_temp);--

se6block: se6 port map(A => imm6, Z => se6_temp);

mux_3inblock: mux_3in generic map(mbits => 16)
			port map (d0 =>se6_temp, d1 => se9_temp, d2 => sl6_temp, enable => enable_temp	, dout => dec_temp);



decoder_output(0) <= wr_en ;
decoder_output(2 downto 1) <= dec_opcode;
decoder_output(5 downto 3) <= dec_a1;
decoder_output(8 downto 6) <= dec_a2;
decoder_output(11 downto 9) <= dec_a3;
decoder_output(19 downto 12) <= nineto8;
decoder_output(35 downto 20) <= dec_temp;
decoder_output(37 downto 36) <= cz;
decoder_output(41 downto 38) <= IR(15 downto 12);

decoder_output(42) <= carry_en(0) ;
decoder_output(43) <= zero_en(0) ;
decoder_output(44) <= mem_wr_en(0) ;
	
end bhv;

