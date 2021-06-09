library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use ieee.numeric_std.all;

library std;
use std.textio.all;

entity tb is
end tb;

architecture beh of tb is

component RISCV
port( clk, rst_n, IF_flush: in std_logic;
	 instr: in std_logic_vector(31 downto 0);
	 data_out: in signed(63 downto 0);
	 addr_data, addr_instr: out std_logic_vector(63 downto 0);
	 wr_data: out signed(63 downto 0);
	 mem_rd, mem_wr: out std_logic);
end component;

component RAM
GENERIC (N: natural := 64);
port(address: in std_logic_vector (15 downto 0);
	 data: in signed (N-1 downto 0);
	 WE_n, clk, CS, rst_n: std_logic;
	 Q: out signed (N-1 downto 0));
end component;

signal clk, rst_n, IF_flush, reset, reset_n: std_logic;
signal instr, data_instr: std_logic_vector(31 downto 0);
signal data_out: signed(63 downto 0);
signal addr_data, addr_instr: std_logic_vector(63 downto 0);
signal wr_data: signed(63 downto 0);
signal instr_data: signed(31 downto 0);
signal mem_rd, mem_wr, w_r: std_logic;
signal WE_n: std_logic := '0';
constant clk_period : time := 5.95 ns;

begin

clk_process :process
   begin
        clk <= '0';
        wait for clk_period/2;  
        clk <= '1';
        wait for clk_period/2;  
   end process;
   
process
  begin  -- process
    rst_n <= '0';
    wait for 3*clk_period/2;
    rst_n <= '1';
    wait;
  end process;
  
 w_r <= mem_rd or (not mem_wr);
 reset_n <= reset and rst_n;
  
UUT: RISCV port map (clk, reset_n, IF_flush, instr, data_out, addr_data, addr_instr, wr_data, mem_rd, mem_wr);
 
 instr <= std_logic_vector(instr_data);
 instr_memory: RAM generic map (N => 32) port map (addr_instr(15 downto 0), signed(data_instr), WE_n, clk, '1', '1', instr_data);

 data_memory: RAM generic map (N => 64) port map (addr_data(15 downto 0), wr_data, w_r, clk, '1', reset_n, data_out);
 
 process (CLK, RST_n)

	file fp_in : text open READ_MODE is "./instr_prog.txt";
	variable line_in : line;
	variable x : std_logic_vector(31 downto 0);

	begin
		if (CLK'event and CLK = '1') then
			if (not endfile(fp_in)) then
				WE_n <= '0';
				readline(fp_in, line_in);
				read(line_in, x);
				data_instr <= x;
			else
				WE_n <= '1';
			end if;
		end if;
	end process;

 process
  begin
	reset <= '1';
	IF_flush <= '1';
	wait on WE_n;
	IF_flush <= '0';
	reset <= '0';
	wait for clk_period/2;
	IF_flush <= '0';
	reset <= '1';
	wait;
 end process;

end architecture;
