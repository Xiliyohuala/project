LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                

ENTITY seg7led_key_vhd_tst IS
END seg7led_key_vhd_tst;
ARCHITECTURE seg7led_key_arch OF seg7led_key_vhd_tst IS
-- constants                                                 
-- signals                                                   
SIGNAL clk : STD_LOGIC;
SIGNAL data_out : STD_LOGIC_VECTOR(6 DOWNTO 0):=(others=>'0');
SIGNAL key1 : STD_LOGIC:='1';
SIGNAL key2 : STD_LOGIC:='1';
SIGNAL segcom : STD_LOGIC_VECTOR(3 DOWNTO 0):=(others=>'0');
SIGNAL segdot : STD_LOGIC:='0';
COMPONENT seg7led_key
	PORT (
	clk : IN STD_LOGIC;
	data_out : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
	key1 : IN STD_LOGIC;
	key2 : IN STD_LOGIC;
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
--WAIT;  
clk<='0';
wait for 10 ns; 
clk<='1'; 
wait for 10 ns;  
                                           
END PROCESS always;   

--key_test:PROCESS
--BEGIN
--wait for 800 ns; 
--key1<='0'; 
--wait for 800 ns; 
--key1<='1'; 
-- WAIT;                                          
--END PROCESS key_test; 
                                          
key1_test: PROCESS                                                                                 
BEGIN                                                         
key1<='0';
wait for 200 ms;
key1<='1';
wait for 3 sec;
key1<='0';
wait for 10 ms;
key1<='1';
wait for 10 ms;

END PROCESS key1_test;  

key2_test: PROCESS                                                                                 
BEGIN                                                         

key2<='0';
wait for 200 ms;
key2<='1';
wait for 7 sec;

END PROCESS key2_test;                                      
END seg7led_key_arch;
