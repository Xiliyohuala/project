library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.std_logic_arith.all;

entity seg7led_key is
PORT( clk  :  IN  STD_LOGIC;
    data_out:  OUT STD_LOGIC_VECTOR(6 downto 0);
    segcom  :  OUT STD_LOGIC_VECTOR(3 downto 0);
	segdot  :  out std_LOGIC;
	 key1 	: 	IN  STD_LOGIC;    --启动暂停键
	 key2 	: 	IN  STD_LOGIC     --
 );
END seg7led_key;
ARCHITECTURE behav OF seg7led_key IS
  SIGNAL bcd_led  :  STD_LOGIC_VECTOR(3 DOWNTO 0):=(others=>'0'); 
  SIGNAL clkcnt   :  STD_LOGIC_VECTOR(30 DOWNTO 0) := (others =>'0');----初始化为0"00000000000000000";
--  SIGNAL clkcnt   :  STD_LOGIC_VECTOR(16 DOWNTO 0);
--  constantbcddata : std_logic_vector(15 downto 0):= x"1234";
  signal   bcddata : std_logic_vector(15 downto 0):=(others=>'0');  --初始化为0
  signal  a: integer range 0 to 24999999 :=0;  --初始化为0
  signal  clk_1Hz,q: STD_LOGIC :='0';          --初始化为0
  signal  keypausefilt: STD_LOGIC ;
  signal  pause: STD_LOGIC :='0';          --初始化为0
  signal  clear: STD_LOGIC ;
  --声明要使用到的模块
  component keyfilt is
  port (clk  : in  std_logic;
		keypause : in  std_logic;
		keypausefilt : out std_logic;
		keyclr : in  std_logic;
		keyclrfilt : out std_logic
		);
	end component keyfilt;

begin
--例化按键消抖模块
akeyfilt: keyfilt port map
 (
	clk =>clk,
	keypause => key1,
	keypausefilt =>keypausefilt,
	keyclr => key2,
	keyclrfilt => clear
 );

process(clk,clkcnt)
begin
  if(rising_edge(clk))then
clkcnt<= clkcnt + 1;
  end if;
end process;

process(clk)
begin
  if(rising_edge(clk))then
	  if keypausefilt = '1' then
		pause<= not pause;
	  end if;
  end if;
end process;

------------------------------产生 1Hz 的时钟信号---------------
process(clk)
begin
		if(clk'event and clk='1') then
			if clear = '1' then
				a<=0;
				q<='0';
			else
				if a=24999999 then        --25000000个clk脉冲（20ns）即0.5秒为低电平，0.5秒为高电平，即产生周期1秒的方波信号。
				  a<=0;
				  q<= not q;
				elsif pause = '0' then 
				  a<=a+1;		
				end if;
			end if;
		 end if;	
		clk_1Hz<=q;
end process;
------------------------------------

process(clk_1Hz ,clear)
begin
	  if clear = '1' then   --异步清零
			bcddata(15 downto 0)<= x"0000";
	  else 
		  if clk_1Hz'event and clk_1Hz='1' then
			  if bcddata(3 downto 0)=x"9" then                  --秒的个位(十进制)
				bcddata(3 downto 0)<=x"0";    
			  else
				bcddata(3 downto 0)<=bcddata(3 downto 0)+1;   
			  end if;
			
			  if bcddata(7 downto 0)=x"59" then                 --秒的十位(六进制)
				bcddata(7 downto 0)<=x"00";    
			elsif bcddata(3 downto 0)=x"9"  then 
				bcddata(7 downto 4)<=bcddata(7 downto 4)+1;   
			  end if;
				
			  if bcddata(11 downto 0)=x"959" then                --分的个位(十进制)
				bcddata(11 downto 0)<=x"000";    
			elsif bcddata(7 downto 0)=x"59" then
				bcddata(11 downto 8)<=bcddata(11 downto 8)+1;   
			  end if;
			
			  if bcddata(15 downto 0)=x"5959" then               --分的十位(六进制)
				bcddata(15 downto 0)<=x"0000";    
			elsif bcddata(11 downto 0) =x"959" then
				bcddata(15 downto 12)<=bcddata(15 downto 12)+1;   
			  end if;
		  end if; -- end clk_1Hz 
	  end if; --end clear
end process;

process(clkcnt(16 downto 15))
 begin
   case clkcnt(16 downto 15) is
      when "00" =>	bcd_led<=bcddata(3  downto 0);
							segcom<= "1110";
							segdot<='1';
      when "01" =>	bcd_led<=bcddata(7  downto 4);
							segcom <= "1101";
							segdot<='1';
      when "10" =>	bcd_led<=bcddata(11 downto 8);
							segcom <= "1011";
							segdot<='0' or clk_1Hz;
      when "11" =>	bcd_led<=bcddata(15 downto 12);
							segcom <= "0111";
							segdot<='1';
      when others => NULL;

   end case;
end process;

process(bcd_led)
	begin
			case bcd_led is
										  -- "abcdefg"
				WHEN "0000"=>data_out<="0000001";
				WHEN "0001"=>data_out<="1001111";
				WHEN "0010"=>data_out<="0010010";
				WHEN "0011"=>data_out<="0000110";
				WHEN "0100"=>data_out<="1001100";
				WHEN "0101"=>data_out<="0100100";
				WHEN "0110"=>data_out<="0100000";
				WHEN "0111"=>data_out<="0001111";
				WHEN "1000"=>data_out<="0000000";
				WHEN "1001"=>data_out<="0000100";
				WHEN OTHERS=>data_out<="1111111";
			end case;
	end process;
end behav;

--按键消抖模块子程序：
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
entity keyfilt is
  port (clk  : in  std_logic;
		keypause : in  std_logic;
		keypausefilt : out std_logic;
		keyclr : in  std_logic;
		keyclrfilt : out std_logic
		);
end keyfilt;
architecture behavioral of keyfilt is
	signal keypausecnt : integer range 0 to 50000000; 
	signal keyclrcnt : integer range 0 to 50000000;
	constant N :integer := 5000000;	--消抖时间，对于50Mhz的基准时钟，这相当于0.1S
begin
	process (clk)
	begin 
		if clk'event and clk = '1' then
			if keypause = '0' then 	--当keypause输入低电平，即按键按下
				if keypausecnt /= N then --一直计数到N
					keypausecnt<= keypausecnt + 1;
				end if;
				if keypausecnt = N-1 then --最后一个计数时输出keypausefilt脉冲
					keypausefilt<= '1';
				else
					keypausefilt<= '0';
				end if;
			else 					--若keypause输入高电平，表明按键被释放
				keypausecnt<= 0;
			end if;
		
			if keyclr = '0' then 	--当keypause输入低电平，即按键按下
				if keyclrcnt /= N then --一直计数到N
					keyclrcnt<= keyclrcnt + 1;
				end if;
				if keyclrcnt = N-1 then --最后一个计数时输出keypausefilt脉冲
					keyclrfilt<= '1';
				else
					keyclrfilt<= '0';
				end if;
			else 					--若keypause输入高电平，表明按键被释放
				keyclrcnt<= 0;
			end if;
			
		end if;	--clk'event
	end process;		
		
end behavioral;
