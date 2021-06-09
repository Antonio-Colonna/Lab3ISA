library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity hazard_detection_unit is
port(mem_read: in std_logic;
	 rd_id_ex, rs1_if_id, rs2_if_id: in std_logic_vector(4 downto 0);
	 PC_w, if_id_w, mux_sel: out std_logic);
end entity;

architecture behaviour of hazard_detection_unit is
signal en, comp1, comp2: std_logic;
signal comp_rs1, comp_rs2: std_logic_vector(4 downto 0);

begin
	comp_rs1 <= rs1_if_id xnor rd_id_ex;
	comp_rs2 <= rs2_if_id xnor rd_id_ex;
	
	comp1 <= comp_rs1(4) and comp_rs1(3) and comp_rs1(2) and comp_rs1(1) and comp_rs1(0);

	comp2 <= comp_rs2(4) and comp_rs2(3) and comp_rs2(2) and comp_rs2(1) and comp_rs2(0);
	
	en <= mem_read and (comp1 or comp2);
	
	with en select
		PC_w <= '0' when '1',
				'1' when '0',
				'0' when others;
	with en select
		if_id_w <= '0' when '1',
				   '1' when '0',
				   '0' when others;
	
	mux_sel <= en;
end behaviour;
