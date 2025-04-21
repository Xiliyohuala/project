LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                

ENTITY seg7led_key_vhd_tst IS
END seg7led_key_vhd_tst;
ARCHITECTURE seg7led_key_arch OF seg7led_key_vhd_tst IS
-- constants                                                 
-- signals                                                   
SIGNAL clk : STD_LOGIC:='0';
SIGNAL data_out : STD_LOGIC_VECTOR(6 DOWNTO 0):=(others=>'0');
SIGNAL key1 : STD_LOGIC:='1';
SIGNAL key2 : STD_LOGIC:='1';
SIGNAL key3 : STD_LOGIC:='1';
SIGNAL key4 : STD_LOGIC:='1';
SIGNAL led2 : STD_LOGIC:='1';
SIGNAL segcom : STD_LOGIC_VECTOR(3 DOWNTO 0):=(others=>'0');
SIGNAL segdot : STD_LOGIC:='1';
COMPONENT seg7led_key
	PORT (
	clk : IN STD_LOGIC;
	data_out : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
	key1 : IN STD_LOGIC;
	key2 : IN STD_LOGIC;
	key3 : IN STD_LOGIC;
	key4 : IN STD_LOGIC;
	led2 : OUT STD_LOGIC;
	segcom : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
	segdot : OUT STD_LOGIC
	);
END COMPONENT;
BEGIN
	i1 : seg7led_key
	PORT MAP (
-- list connections between master ports and signals
	clk => clk,
	data_out => data_out,
	key1 => key1,
	key2 => key2,
	key3 => key3,
	key4 => key4,
	led2 => led2,
	segcom => segcom,
	segdot => segdot
	);
init : PROCESS                                               
-- variable declarations                                     
BEGIN                                                        
        -- code that executes only once                      
WAIT;                                                       
END PROCESS init;                                           
always : PROCESS                                              
-- optional sensitivity list                                  
-- (        )                                                 
-- variable declarations                                      
BEGIN                                                         
        -- code executes for every event on sensitivity list  
clk<='0'; 
wait for 10 ns; 
clk<='1'; 
wait for 10 ns; 
--WAIT;                                                        
END PROCESS always;   

--key1test: PROCESS
--BEGIN
--key1<='0'; 
--wait for 1 sec; 
--key1<='1'; 
--wait for 0.5 sec;
--key1<='0'; 
--wait for 4 sec; 
--key1<='1'; 
--wait for 0.5 sec;
--key1<='0'; 
--wait for 20 ms; 
--key1<='1'; 
--wait for 20 ms; 
--END PROCESS key1test;    


key2test: PROCESS
BEGIN
key2<='0'; 
wait for 1 sec; 
key2<='1'; 
wait for 5 sec;
END PROCESS key2test;  

key3test: PROCESS
BEGIN
key3<='0'; 
wait for 1 sec; 
key3<='1'; 
wait for 6 sec;
END PROCESS key3test;  

key4test: PROCESS
BEGIN
key4<='0'; 
wait for 1 sec; 
key4<='1'; 
wait for 6 sec;
END PROCESS key4test;  
                                   
END seg7led_key_arch;
