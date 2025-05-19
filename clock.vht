-- Copyright (C) 1991-2013 Altera Corporation
-- Your use of Altera Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Altera Program License 
-- Subscription Agreement, Altera MegaCore Function License 
-- Agreement, or other applicable license agreement, including, 
-- without limitation, that your use is for the sole purpose of 
-- programming logic devices manufactured by Altera and sold by 
-- Altera or its authorized distributors.  Please refer to the 
-- applicable agreement for further details.

-- ***************************************************************************
-- This file contains a Vhdl test bench template that is freely editable to   
-- suit user's needs .Comments are provided in each section to help the user  
-- fill out necessary details.                                                
-- ***************************************************************************
-- Generated on "05/15/2025 23:07:58"
                                                            
-- Vhdl Test Bench template for design  :  clock
-- 
-- Simulation tool : ModelSim (VHDL)
-- 

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                

ENTITY clock_vhd_tst IS
END clock_vhd_tst;
ARCHITECTURE clock_arch OF clock_vhd_tst IS
-- constants                                                 
-- signals                                                   
SIGNAL clk : STD_LOGIC;
SIGNAL data_out : STD_LOGIC_VECTOR(6 DOWNTO 0):=(others=>'0');
SIGNAL key1 : STD_LOGIC:='1';
SIGNAL key2 : STD_LOGIC:='1';
SIGNAL segcom : STD_LOGIC_VECTOR(3 DOWNTO 0):=(others=>'0');
SIGNAL segdot : STD_LOGIC:='0';
COMPONENT clock
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
	i1 : clock
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
                                     
END clock_arch;
