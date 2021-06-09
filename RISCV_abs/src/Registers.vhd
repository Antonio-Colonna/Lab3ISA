library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Registers is
port(R_reg1, R_reg2, W_reg: in std_logic_vector(4 downto 0);
	 W_data: in signed(63 downto 0);
	 clk, RegW, rst_n: in std_logic;
	 R_data1, R_data2: out signed(63 downto 0));
end Registers;

architecture behaviour of Registers is
type Reg_file is ARRAY(0 to 31) of SIGNED (63 downto 0);
signal REG: Reg_file;
begin
	process(clk, RegW, rst_n)
	begin
		if (rst_n = '0') then
			for i in 0 to 31 loop
				REG(i) <= (others => '0');
			end loop;
		elsif(clk'event and clk ='1' and RegW = '1') then
			REG(TO_INTEGER(UNSIGNED(W_reg))) <= W_data;
		else
			R_data1 <= REG(TO_INTEGER(UNSIGNED(R_reg1)));
			R_data2 <= REG(TO_INTEGER(UNSIGNED(R_reg2)));
		end if;
	end process;
end behaviour;

