library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
entity keyfilt is
  port (clk  : in  std_logic;
		key : in  std_logic;
		keyout : out std_logic
		);
end keyfilt;
architecture behavioral of keyfilt is
	signal keycnt : integer range 0 to 1500000000; 
	constant N :integer := 5000000;	--0.1S
begin
	process (clk)
	begin 
		if rising_edge(clk) then
            if key = '0' then  -- 按键按下（低电平有效）
                if keycnt < N then 
                    keycnt <= keycnt + 1;
                end if;
                
                -- 消抖完成后持续输出高电平
                if keycnt >= N then
                    keyout <= '1';
                end if;
            else                -- 按键释放
                keycnt <= 0;
                keyout <= '0';
            end if;
        end if;
	end process;	
end behavioral;