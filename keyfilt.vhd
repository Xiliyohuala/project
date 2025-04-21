library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
entity keyfilt is
  port (clk  : in  std_logic;
		key1 : in  std_logic;
		keypause : out std_logic;
		keyclr : out std_logic;
		key2 : in  std_logic;
		keyshift : out std_logic;
		keysetting : out std_logic;
		key3 : in  std_logic;
		keyup : out std_logic
		);
end keyfilt;
architecture behavioral of keyfilt is
	signal cnt1 : integer range 0 to 150000000; 
	signal cnt2 : integer range 0 to 150000000; 
	signal cnt3 : integer range 0 to 150000000; 
	signal keypausefilt  : std_logic := '0';
	signal keyclrfilt  : std_logic := '0';
	signal keyshiftfilt  : std_logic := '0';
	signal keysettingfilt  : std_logic := '0';
	signal keyupfilt  : std_logic := '0';
	constant N :integer := 5000000;	
	constant M :integer := 150000000;
begin
	process (clk)
	begin 
		if clk'event and clk = '1' then
			if key1 = '0' then 	
				if cnt1 /= M then
					cnt1<=cnt1+1;
					end if;
				else
				 cnt1<=0;
				   if cnt1 = M then
					keyclrfilt<='1';
					elsif cnt1>N then
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
				if cnt2 /= M then 
				   cnt2<=cnt2+1;
					end if;
				else
				 cnt2<=0;
				   if cnt2 = M then
					keysettingfilt<='1';
					elsif cnt2>N then
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
				if cnt3 /= M then 
				  cnt3<=cnt3+1;
					end if;
				else
				 cnt3<=0;
					if cnt3>N then
					keyupfilt<='1';
				   end if;
				end if;
				if keyupfilt<='1' then
				  keyupfilt<='0';
				end if;
			
		end if;	--clk'event
		  keypause   <= keypausefilt;
		  keyclr   <= keyclrfilt;
  	     keyshift  <= keyshiftfilt;
  	     keysetting <= keysettingfilt;
  	     keyup      <= keyupfilt;
	end process;		
		
end behavioral;
