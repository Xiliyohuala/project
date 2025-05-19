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
-- Generated on "05/12/2025 19:10:21"
                                                            
-- Vhdl Test Bench template for design  :  coder
-- 
-- Simulation tool : ModelSim (VHDL)
-- 

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                

ENTITY coder_vhd_tst IS
END coder_vhd_tst;
ARCHITECTURE coder_arch OF coder_vhd_tst IS
-- constants                                                 
-- signals                                                   
SIGNAL clk : STD_LOGIC;
SIGNAL data_out : STD_LOGIC_VECTOR(6 DOWNTO 0):=(others=>'0');
SIGNAL key : STD_LOGIC_VECTOR(7 DOWNTO 0):=(others=>'0');
SIGNAL led2 : STD_LOGIC;
SIGNAL segcom : STD_LOGIC;
COMPONENT coder
	PORT (
	clk : IN STD_LOGIC;
	data_out : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
	key : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	led2 : OUT STD_LOGIC;
	segcom : OUT STD_LOGIC
	);
END COMPONENT;
BEGIN
	i1 : coder
	PORT MAP (
-- list connections between master ports and signals
	clk => clk,
	data_out => data_out,
	key => key,
	led2 => led2,
	segcom => segcom
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
  
keytest: PROCESS
BEGIN
key<="01111111"; 
wait for 200 ms; 
key<="10111111"; 
wait for 200 ms;
END PROCESS keytest;  
                                       
END coder_arch;
