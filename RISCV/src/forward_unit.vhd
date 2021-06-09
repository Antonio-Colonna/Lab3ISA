library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity forward_unit is
port (rs1, rs2, rd_ex_mem, rd_mem_wb: in std_logic_vector(4 downto 0);
	  reg_write_ex_mem, reg_write_mem_wb: in std_logic;
	  for_a, for_b: out std_logic_vector(1 downto 0));
end entity;

architecture beh of forward_unit is
signal en, hem1, hem2, hmw1, hmw2, r_em, r_mw: std_logic;
signal haz_ex_mem1, haz_mem_wb1: std_logic_vector(4 downto 0);
signal haz_ex_mem2, haz_mem_wb2: std_logic_vector(4 downto 0);

begin
	haz_ex_mem1 <= rs1 xnor rd_ex_mem;
	haz_ex_mem2 <= rs2 xnor rd_ex_mem;
	
	haz_mem_wb1 <= rs1 xnor rd_mem_wb;
	haz_mem_wb2 <= rs2 xnor rd_mem_wb;
	
	hem1 <= haz_ex_mem1(4) and haz_ex_mem1(3) and haz_ex_mem1(2) and haz_ex_mem1(1) and haz_ex_mem1(0);
	hem2 <= haz_ex_mem2(4) and haz_ex_mem2(3) and haz_ex_mem2(2) and haz_ex_mem2(1) and haz_ex_mem2(0);
	
	hmw1 <= haz_mem_wb1(4) and haz_mem_wb1(3) and haz_mem_wb1(2) and haz_mem_wb1(1) and haz_mem_wb1(0);
	hmw2 <= haz_mem_wb2(4) and haz_mem_wb2(3) and haz_mem_wb2(2) and haz_mem_wb2(1) and haz_mem_wb2(0);
	
	r_em <= (not rd_ex_mem(4)) and (not rd_ex_mem(3)) and (not rd_ex_mem(2)) and (not rd_ex_mem(1)) and (not rd_ex_mem(0));
	r_mw <= (not rd_mem_wb(4)) and (not rd_mem_wb(3)) and (not rd_mem_wb(2)) and (not rd_mem_wb(1)) and (not rd_mem_wb(0));
	
	en <= (reg_write_ex_mem or reg_write_mem_wb) and ((not r_em) and (not r_mw)) ;
	
	for_a <= (hem1 and en) & (hmw1 and en);
	for_b <= (hem2 and en) & (hmw2 and en);
end architecture;
