library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RISCV is
port( clk, rst_n, IF_flush: in std_logic;
	 instr: in std_logic_vector(31 downto 0);
	 data_out: in signed(63 downto 0);
	 addr_data, addr_instr: out std_logic_vector(63 downto 0);
	 wr_data: out signed(63 downto 0);
	 mem_rd, mem_wr: out std_logic);
end entity;

architecture Structure of RISCV is

component Prog_counter
	port(pc_in: in std_logic_vector(63 downto 0);
		 clk, rst_n, wr: in std_logic;
		 pc_out: out std_logic_vector(63 downto 0));
end component;

component Registers
port(R_reg1, R_reg2, W_reg: in std_logic_vector(4 downto 0);
	 W_data: in signed(63 downto 0);
	 clk, RegW, rst_n: in std_logic;
	 R_data1, R_data2: out signed(63 downto 0));
end component;		

component mux2
generic (N : integer := 64);
port(a, b: in std_logic_vector(N-1 downto 0);
	 sel: in std_logic;
	 c: out std_logic_vector(N-1 downto 0));
end component;

component mux4
port(a, b, c: in signed (63 downto 0);
	 sel: in std_logic_vector (1 downto 0);
	 d: out signed (63 downto 0));
end component;

component ImmGen
port(a: in std_logic_vector (31 downto 0);
	 b: out std_logic_vector (63 downto 0));
end component;

component Adder
GENERIC(N:INTEGER:=64);
port(a, b: in std_logic_vector (N-1 downto 0);
	 c: out std_logic_vector (N-1 downto 0));
end component;

component ALU_ctrl
port (instr: in std_logic_vector(3 downto 0);
	  ALU_op: in std_logic_vector(1 downto 0);
	  ALU_ctrl_out: out std_logic_vector(3 downto 0));
end component;

component ALU
port(A, B: in signed(63 downto 0);
	 ALU_ctrl: in std_logic_vector(3 downto 0);
	 C: out signed(63 downto 0);
	 zero: out std_logic);
end component;

component ctrl
port(instr: in std_logic_vector (31 downto 0);
	 WB: out std_logic_vector(1 downto 0);
	 M: out std_logic_vector(2 downto 0);
	 EX: out std_logic_vector(2 downto 0));
end component;

component forward_unit
port (rs1, rs2, rd_ex_mem, rd_mem_wb: in std_logic_vector(4 downto 0);
	  reg_write_ex_mem, reg_write_mem_wb: in std_logic;
	  for_a, for_b: out std_logic_vector(1 downto 0));
end component;

component hazard_detection_unit
port(mem_read: in std_logic;
	 rd_id_ex, rs1_if_id, rs2_if_id: in std_logic_vector(4 downto 0);
	 PC_w, if_id_w, mux_sel: out std_logic);
end component;

component reg
GENERIC(N:INTEGER:=219);
port(D: in std_logic_vector(N-1 downto 0);
	 clk, rst_n, R_Wn: std_logic;
	 Q: out std_logic_vector(N-1 downto 0));
end component;

component spec_function
port(op_code: in std_logic_vector(6 downto 0);
	 RD1: in signed(63 downto 0);
	 sel: out std_logic;
	 funct_out: out signed(63 downto 0));
end component;

signal pc_wr, IF_ID_wr, RegWrite, haz_sel, IF_ID_rst, zero, pc_src, cmp, f_mux, f_mux_sel: std_logic;
signal pctmp_in, pctmp_out, incr_add_out, add_sum_in, add_sum_out, immgen_out, ALU_in2_1, wb_mux_out, cmp_reg, func_mux: std_logic_vector (63 downto 0);
signal reg_IF_ID_in, reg_IF_ID_out: std_logic_vector (95 downto 0);
signal reg_ID_EX_in, reg_ID_EX_out: std_logic_vector(289 downto 0);
signal reg_EX_MEM_in, reg_EX_MEM_out: std_logic_vector (138 downto 0);
signal reg_MEM_WB_in, reg_MEM_WB_out: std_logic_vector (134 downto 0);
signal RD_1, RD_2, ALU_in1, ALU_in2, ALU_out, ALU_mux2_out, wb_mux, func_out: signed (63 downto 0);
signal ctrl_M, ctrl_EX: std_logic_vector(2 downto 0);
signal ctrl_WB, fwd_out1, fwd_out2: std_logic_vector(1 downto 0);
signal ctrl_out, ctrl_mux_out: std_logic_vector(7 downto 0);
signal ALU_ctrl_out: std_logic_vector(3 downto 0);

begin
IF_ID_rst <= (rst_n and (not IF_flush) and (not pc_src));

PC_MUX: mux2 generic map (N => 64) port map (incr_add_out, add_sum_out, pc_src, pctmp_in);

ProgramCnt: Prog_counter port map (pctmp_in, clk, rst_n, pc_wr, pctmp_out);

addr_instr <= pctmp_out;
incr_add: Adder generic map (N => 64) port map (pctmp_out, "0000000000000000000000000000000000000000000000000000000000000100", incr_add_out);

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

IF_ID: reg generic map (N => 96) port map (reg_IF_ID_in, clk, IF_ID_rst, IF_ID_wr, reg_IF_ID_out);
reg_IF_ID_in <=  pctmp_out & instr;

ImmGenerator: ImmGen port map (reg_IF_ID_out(31 downto 0), immgen_out);

RegFile: Registers port map (reg_IF_ID_out(19 downto 15), reg_IF_ID_out (24 downto 20), reg_MEM_WB_out(4 downto 0), wb_mux, clk, reg_MEM_WB_out(134), rst_n, RD_1, RD_2);

control: ctrl port map (reg_IF_ID_out(31 downto 0), ctrl_WB, ctrl_M, ctrl_EX);
ctrl_out <= ctrl_WB & ctrl_M & ctrl_EX;

ctrl_mux: mux2 generic map (N => 8) port map (ctrl_out, "00000000", haz_sel, ctrl_mux_out);

haz_det: hazard_detection_unit port map(reg_ID_EX_out(279), reg_ID_EX_out(4 downto 0), reg_IF_ID_out (24 downto 20), reg_IF_ID_out(19 downto 15), pc_wr, IF_ID_wr, haz_sel);


-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

ID_EX: reg generic map (N => 290) port map (reg_ID_EX_in, clk, rst_n, '1', reg_ID_EX_out);
reg_ID_EX_in <= (reg_IF_ID_out(6 downto 0) & ctrl_mux_out & reg_IF_ID_out(95 downto 32) & std_logic_vector(RD_1) & std_logic_vector(RD_2) & immgen_out & reg_IF_ID_out(30) & reg_IF_ID_out(14 downto 12) & reg_IF_ID_out (24 downto 20) & reg_IF_ID_out(19 downto 15) & reg_IF_ID_out (11 downto 7));

add_sum_in <= reg_ID_EX_out(82) & reg_ID_EX_out(80 downto 19) & '0';
add_sum: Adder generic map (N => 64) port map (add_sum_in, reg_ID_EX_out(274 downto 211), add_sum_out);

pc_src <= reg_ID_EX_out(280) and zero;

ALU_mux1: mux4 port map (signed(reg_ID_EX_out(210 downto 147)), wb_mux, signed(reg_EX_MEM_out(132 downto 69)), fwd_out1, ALU_in1);
ALU_mux2: mux4 port map (signed(reg_ID_EX_out(146 downto 83)), wb_mux, signed(reg_EX_MEM_out(132 downto 69)), fwd_out2, ALU_mux2_out);

SFU: spec_function port map(reg_ID_EX_out(289 downto 283), ALU_in1, f_mux_sel, func_out);
SFU_MUX: mux2 generic map (N => 64) port map (std_logic_vector(ALU_in1), std_logic_vector(func_out), f_mux_sel, func_mux);

f_mux <= f_mux_sel or (ALU_in2_1(0) and (not f_mux_sel));

ALU_in2 <= signed(ALU_in2_1(63 downto 1) & f_mux);
ALU_mux2_1: mux2 generic map (N => 64) port map (std_logic_vector(ALU_mux2_out), reg_ID_EX_out(82 downto 19), reg_ID_EX_out(275), ALU_in2_1);

ALU_unit: ALU port map (signed(func_mux), ALU_in2, ALU_ctrl_out, ALU_out, zero);
ALU_control: ALU_ctrl port map (reg_ID_EX_out(18 downto 15), reg_ID_EX_out(277 downto 276), ALU_ctrl_out);

fwd_unit: forward_unit port map (reg_ID_EX_out(9 downto 5), reg_ID_EX_out(14 downto 10), reg_EX_MEM_out(4 downto 0), reg_MEM_WB_out(4 downto 0), reg_EX_MEM_out(138), reg_MEM_WB_out(134), fwd_out1, fwd_out2);

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

EX_MEM: reg generic map (N => 139) port map (reg_EX_MEM_in, clk, rst_n, '1', reg_EX_MEM_out);
reg_EX_MEM_in <= reg_ID_EX_out(282 downto 278) & zero & std_logic_vector(ALU_out) & std_logic_vector(ALU_mux2_out) & reg_ID_EX_out(4 downto 0);


addr_data <= reg_EX_MEM_out(132 downto 69);
wr_data <= signed(reg_EX_MEM_out(68 downto 5));
mem_rd <= reg_EX_MEM_out(135);
mem_wr <= reg_EX_MEM_out(134);

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

MEM_WB: reg generic map (N => 135) port map (reg_MEM_WB_in, clk, rst_n, '1', reg_MEM_WB_out);
reg_MEM_WB_in <= reg_EX_MEM_out(138 downto 137) & std_logic_vector(data_out) & reg_EX_MEM_out(132 downto 69) & reg_EX_MEM_out(4 downto 0);

wb_mux <= signed(wb_mux_out);
mux_WB: mux2 generic map (N => 64) port map (reg_MEM_WB_out(68 downto 5), reg_MEM_WB_out(132 downto 69), reg_MEM_WB_out(133), wb_mux_out);

end Structure;
