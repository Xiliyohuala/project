LIBRARY IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.std_logic_arith.all;

entity timer is
PORT( clk  :  IN  STD_LOGIC;
    data_out:  OUT STD_LOGIC_VECTOR(6 downto 0);
    segcom  :  OUT STD_LOGIC_VECTOR(3 downto 0);
	 led    :  OUT STD_LOGIC_VECTOR(7 downto 0);
	 segdot  :  out std_LOGIC;
	 key1 	: 	IN  STD_LOGIC;   
	 key2 	: 	IN  STD_LOGIC     
 );
END timer;
ARCHITECTURE behav OF timer IS
  SIGNAL bcd_led  :  STD_LOGIC_VECTOR(3 DOWNTO 0):=(others=>'0'); 
  SIGNAL clkcnt   :  STD_LOGIC_VECTOR(30 DOWNTO 0) := (others =>'0');----初始化为0"00000000000000000";
  signal bcddata : std_logic_vector(15 downto 0):=(others=>'0');  --初始化为0
  signal  a: integer range 0 to 24999999 :=0;  --初始化为0
  signal  clk_1Hz,q: STD_LOGIC :='0';
  signal  keyout1: STD_LOGIC ;         --初始化为0
  signal  clear: STD_LOGIC ;
  --声明要使用到的模块
component keyfilt is
  port (clk  : in  std_logic;
		key : in  std_logic;
		keyout : out std_logic
		);
	end component keyfilt;
component flashLED is
  port (clk_1Hz  : in  std_logic;
		  led8  : out std_logic_vector
		);
	end component flashLED;
begin
akeyfilt: keyfilt port map
 (
	clk =>clk,
	key => key1,
	keyout=>keyout1
 );
aled: flashLED port map
 (
	clk_1Hz =>clk_1Hz,
	led8 =>led
 );

process(clk)
begin
	if(clk'event and clk='1') then
		if a=24999999 then
			a<=0;
			q<= not q;
		else
			a<=a+1;
		end if;
	end if;
	clk_1Hz<=q;
end process;


end behav;
