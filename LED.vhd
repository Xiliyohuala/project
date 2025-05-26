LIBRARY IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.std_logic_arith.all;

entity flashLED is
PORT( clk_1Hz:IN  STD_LOGIC;
	   led8:  OUT STD_LOGIC_VECTOR(7 downto 0)
 );
END flashLED;

ARCHITECTURE behav OF flashLED IS
  SIGNAL cnt : INTEGER RANGE 0 TO 7 := 0;
BEGIN

PROCESS(clk_1Hz)
BEGIN
    if rising_edge(clk_1Hz) then
			if cnt = 7 then
            cnt <= 0;
			else
            cnt <= cnt + 1;
				led8<= (others => '1'); -- 默认全灭
				led8(cnt) <= '0';        -- 指定位置亮
	     end if;
		 end if;
END PROCESS;
END behav;
