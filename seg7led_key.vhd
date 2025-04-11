library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.std_logic_arith.all;

entity seg7led_key is
PORT( clk  :  IN  STD_LOGIC;
    data_out:  OUT STD_LOGIC_VECTOR(6 downto 0);
    segcom  :  OUT STD_LOGIC_VECTOR(3 downto 0);
	 led2:  OUT STD_LOGIC;
	 segdot  :  out std_LOGIC;
	 key1 	: 	IN  STD_LOGIC;    --启动暂停/清零键
	 key2 	: 	IN  STD_LOGIC;    --设置分钟
	 key3 	: 	IN  STD_LOGIC;     --设置秒钟
	 key4 	: 	IN  STD_LOGIC
 );
END seg7led_key;
ARCHITECTURE behav OF seg7led_key IS
  SIGNAL bcd_led  :  STD_LOGIC_VECTOR(3 DOWNTO 0):=(others=>'0'); 
  SIGNAL clkcnt   :  STD_LOGIC_VECTOR(30 DOWNTO 0) := (others =>'0');----初始化为0"00000000000000000";
--  SIGNAL clkcnt   :  STD_LOGIC_VECTOR(16 DOWNTO 0);
--  constantbcddata : std_logic_vector(15 downto 0):= x"1234";
  signal  bcddata : std_logic_vector(15 downto 0):=(others=>'0');  --初始化为0
  signal  bcddata1 : std_logic_vector(15 downto 0):=(others=>'0'); 
  signal  a: integer range 0 to 24999999 :=0;  --初始化为0
  signal  clk_1Hz,q: STD_LOGIC :='0';          --初始化为0
  signal  keypausefilt: STD_LOGIC ;
  signal  pause: STD_LOGIC :='0';          --初始化为0
  signal  clear: STD_LOGIC ;
  signal  presstime:integer := 0; --3s
  signal  keysec: STD_LOGIC ;
  signal  keymin: STD_LOGIC ;
  signal	 keysecfilt :std_logic;
  signal	 keyminfilt :std_logic;
  signal  keyset:std_logic;
  signal  keysetfilt:std_logic:='0';
  signal  mode:std_logic:='0';
  signal  pled2:std_logic:='1';
  --声明要使用到的模块
  component keyfilt is
  port (clk  : in  std_logic;
	keypause : in  std_logic;
   keypausefilt : out std_logic;
	keysec : in  std_logic;
	keysecfilt : out std_logic;
	keymin : in  std_logic;
	keyminfilt : out std_logic;
	keyset : in  std_logic;
	keysetfilt : out std_logic
		);
	end component keyfilt;

begin
--例化按键消抖模块
akeyfilt: keyfilt port map
 (
	clk =>clk,
	keypause => key1,
	keypausefilt =>keypausefilt,
	keyset=>key2,
	keymin=> key3,
	keysec=>key4,
	keysetfilt=>keysetfilt,
	keysecfilt=>keysecfilt,
	keyminfilt=>keyminfilt
 );

process(clk,clkcnt)
begin
  if(rising_edge(clk))then
clkcnt<= clkcnt + 1;
  end if;
end process;


process(clk)
begin
        if rising_edge(clk) then
			if keypausefilt = '1' then
            presstime <= presstime + 1;
         end if;
				-- 按键释放，判断按下时长
			if keypausefilt = '0' then
            if presstime > 0 and presstime < 50000000 then  -- <1秒
                pause <= not pause;
            elsif presstime > 150000000 then
                clear <= '1'; 
                -- 自动触发清零
            end if;
            presstime <= 0; -- 清零计时
            if clear = '1' then
                -- 在下一个时钟周期复位 clear 信号
                clear <= '0';
				end if;

			end if;
			end if;
			if keysetfilt'event and keysetfilt='1'then
				mode<=not mode;
				led2<= not pled2;
				pled2<=not pled2;
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

process(clk_1Hz ,clear,keysetfilt,keyminfilt,keysecfilt)
begin
	  if clear = '1' then   --异步清零
			bcddata(15 downto 0)<= x"0000";	
			elsif mode= '1' then 
         if keysecfilt'event and keysecfilt = '1' then
			if bcddata1(7 downto 0) = x"59" then
        bcddata1(7 downto 0) <= x"00";
    else
        -- 否则，秒数加 1
        bcddata1(3 downto 0) <= bcddata1(3 downto 0) + 1;
        
        -- 检查个位是否满 10（BCD 码 9+1=10，需要进位）
        if bcddata1(3 downto 0) = x"9" then
            bcddata1(3 downto 0) <= x"0";  -- 个位归零
            bcddata1(7 downto 4) <= bcddata1(7 downto 4) + 1;  -- 十位加 1
        end if;
    end if;
end if;
         if keyminfilt'event and keyminfilt = '1' then
			if bcddata1(15 downto 8) = x"59" then
        bcddata1(15 downto 8) <= x"00";
    else
        -- 否则，分钟数加 1
        bcddata1(11 downto 8) <= bcddata1(11 downto 8) + 1;
        
        -- 检查个位是否满 10（BCD 码 9+1=10，需要进位）
        if bcddata1(11 downto 8) = x"9" then
            bcddata1(11 downto 8) <= x"0";  -- 个位归零
            bcddata1(15 downto 12) <= bcddata1(15 downto 12) + 1;  -- 十位加 1
        end if;
    end if;
end if;


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
    if mode = '1' then -- 设置模式，显示 bcddata1
        bcddata <= bcddata1;
    else -- 运行模式，bcddata1 跟随 bcddata
        bcddata1 <= bcddata;
    end if;
		  
end process;



process(clkcnt(16 downto 15))
 begin
		if mode = '0' then 
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
		 else
		 case clkcnt(16 downto 15) is
				when "00" =>	bcd_led<=bcddata1(3  downto 0);
									segcom<= "1110";
									segdot<='1';
				when "01" =>	bcd_led<=bcddata1(7  downto 4);
									segcom <= "1101";
									segdot<='1';
				when "10" =>	bcd_led<=bcddata1(11 downto 8);
									segcom <= "1011";
									segdot<='0' or clk_1Hz;
				when "11" =>	bcd_led<=bcddata1(15 downto 12);
									segcom <= "0111";
									segdot<='1';
				when others => NULL;
			end case;
	end if;
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

