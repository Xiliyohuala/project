library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
entity keyfilt is
  port (clk  : in  std_logic;
		key1 : in  std_logic;
		keypausefilt : BUFFER std_logic;
		keyclrfilt : BUFFER std_logic;
		key2 : in  std_logic;
		keyshiftfilt : BUFFER std_logic;
		keysettingfilt : BUFFER std_logic;
		key3 : in  std_logic;
		keyupfilt : BUFFER std_logic
		);
end keyfilt;
architecture behavioral of keyfilt is
	signal cnt : integer range 0 to 150000000; 
	constant N :integer := 5000000;	--消抖时间，对于50Mhz的基准时钟，这相当于0.1S
	constant M :integer := 150000000;
begin
	process (clk)
	begin 
		if clk'event and clk = '1' then
			if key1 = '0' then 	
				if cnt /= M then
					cnt<=cnt+1;
					end if;
				else
				 cnt<=0;
				   if cnt = M then
					keyclrfilt<='1';
					elsif cnt>N then
					keypausefilt<='1';
				   end if;
				end if;
				if keypausefilt<='1' then
				keypausefilt<='0';
				end if;
				if keyclrfilt<='1' then
				keyclrfilt<='0';
				end if;
				

			if key2 = '0' then 	
				if cnt /= M then 
				   cnt<=cnt+1;
					end if;
				else
				 cnt<=0;
				   if cnt = M then
					keysettingfilt<='1';
					elsif cnt>N then
					keyshiftfilt<='1';
				   end if;
				end if;
				if keysettingfilt<='1' then
				keysettingfilt<='0';
				end if;
				if keyshiftfilt<='1' then
				keyshiftfilt<='0';
				end if;
									
			if key3 = '0' then 	
				if cnt /= M then 
				  cnt<=cnt+1;
					end if;
				else
				 cnt<=0;
					if cnt>N then
					keyupfilt<='1';
				   end if;
				end if;
				if keyupfilt<='1' then
				  keyupfilt<='0';
				end if;
			
		end if;	--clk'event
	end process;		
		
end behavioral;