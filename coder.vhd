LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
ENTITY coder IS
	PORT(
	data_out:  OUT STD_LOGIC_VECTOR(6 downto 0);
   segcom  :  OUT STD_LOGIC;
	clk     :  IN  STD_LOGIC;
	key     : IN  STD_LOGIC_VECTOR(7 DOWNTO 0));  -- 按键向量
END coder;

ARCHITECTURE dataflow OF coder IS

SIGNAL bcd_led  :  STD_LOGIC_VECTOR(3 DOWNTO 0):=(others=>'0');  --初始化为0
signal keyout  : STD_LOGIC_VECTOR(7 DOWNTO 0);
signal	A     : STD_LOGIC_VECTOR(2 DOWNTO 0);
SIGNAL b: integer range 0 to 24999999 :=0; --初始化为 0
SIGNAL clk_1Hz,q: STD_LOGIC :='0'; 
SIGNAL clkcnt : STD_LOGIC_VECTOR(16 DOWNTO 0) := (others => '0');
component keyfilt is
port (clk  : in  std_logic;
		key : in  std_logic;
		keyout : out std_logic
		);
end component keyfilt;
BEGIN	

filt: FOR x IN 0 TO 7 GENERATE 
        keyfiltx: keyfilt 
        PORT MAP (
            clk    => clk,
            key    => key(x),
            keyout => keyout(x)
        );
END GENERATE;


process(clk,clkcnt)
begin
		if(clk'event and clk='1') then
				if b=24999999 then        --25000000个clk脉冲（20ns）即0.5秒为低电平，0.5秒为高电平，即产生周期1秒的方波信号。
				  b<=0;
				  q<= not q;
				else
				  b<=b+1;		
				end if;
			end if;	
		clk_1Hz<=q;
end process;	

PROCESS(keyout)
	BEGIN	
	CASE keyout IS
	WHEN "10000000" => A <= "111";
	WHEN "01000000" => A <= "110";
	WHEN "00100000" => A <= "101";
	WHEN "00010000" => A <= "100";
	WHEN "00001000" => A <= "011";
	WHEN "00000100" => A <= "010";
	WHEN "00000010" => A <= "001";
	WHEN OTHERS => A <= "000";
	END CASE;
END PROCESS;


process(A)
	begin
		bcd_led<='0' & A(2  downto 0);
	   segcom<= '0';
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

END dataflow;
	