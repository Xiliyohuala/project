---按键消抖模块子程序：
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
entity keyfilt is
  port (clk  : in  std_logic;
		keypause : in  std_logic;
		keypausefilt : out std_logic;
		keymin : in  std_logic;
		keyminfilt : out std_logic;
		keysec : in  std_logic;
		keysecfilt : out std_logic;
		keyset: in  std_logic;
		keysetfilt : out std_logic
		);
end keyfilt;
architecture behavioral of keyfilt is
	signal keypausecnt : integer range 0 to 500000000; 
	signal keyseccnt : integer range 0 to 500000000; 
	signal keymincnt : integer range 0 to 500000000; 
	signal keysetcnt : integer range 0 to 500000000; 
	constant N :integer := 5000000;	--消抖时间，对于50Mhz的基准时钟，这相当于0.1S
	constant M :integer := 15000000;	--消抖时间，对于50Mhz的基准时钟，这相当于0.3S
begin
	process (clk)
	begin 
		if (clk'event and clk = '1' )then
			if keypause = '0' then 	--当keypause输入低电平，即按键按下
			keypausecnt<=0;
				if keypausecnt /= N then --一直计数到N
					keypausecnt<= keypausecnt + 1;
				end if;
				if keypausecnt = N-1 then --最后一个计数时输出keypausefilt脉冲
					keypausefilt<= '1';
				--else
					--keypausefilt<= '0';
				end if;
			else 					--若keypause输入高电平，表明按键被释放
				keypausecnt<= 0;
				keypausefilt<= '0';
			end if;
		
		if keysec = '0' then 	--当keypause输入低电平，即按键按下
			keyseccnt<=0;
				if keyseccnt /= M then --一直计数到N
					keyseccnt<= keyseccnt + 1;
				end if;
				if keyseccnt = M-1 then --最后一个计数时输出keypausefilt脉冲
					keysecfilt<= '1';
				else
					keysecfilt<= '0';
				end if;
			else 					--若keypause输入高电平，表明按键被释放
				keyseccnt<= 0;
			end if;

		if keymin = '0' then 	--当keypause输入低电平，即按键按下
			keymincnt<=0;
				if keymincnt /= M then --一直计数到N
					keymincnt<= keymincnt + 1;
				end if;
				if keymincnt = M-1 then --最后一个计数时输出keypausefilt脉冲
					keyminfilt<= '1';
				else
					keyminfilt<= '0';
				end if;
			else 					--若keypause输入高电平，表明按键被释放
				keymincnt<= 0;
			end if;
			
			if keyset = '0' then 	--当keypause输入低电平，即按键按下
			  keysetcnt<=0;
				if keysetcnt /= M then --一直计数到N
					keysetcnt<= keysetcnt + 1;
				end if;
				if keysetcnt = M-1 then --最后一个计数时输出keypausefilt脉冲
					keysetfilt<= '1';
				else
					keysetfilt<= '0';
				end if;
			else 					--若keypause输入高电平，表明按键被释放
				keysetcnt<= 0;
			end if;

			
		end if;	--clk'event	
	end process;		
		
end behavioral;