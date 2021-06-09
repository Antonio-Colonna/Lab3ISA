library ieee;
use ieee.std_logic_1164.all;

entity Prog_counter is
port(pc_in: in std_logic_vector(63 downto 0);
	 clk, rst_n, wr: in std_logic;
	 pc_out: out std_logic_vector(63 downto 0));
end entity;

architecture beh of Prog_counter is
begin
	process(clk, rst_n)
	begin
		if(rst_n = '0')then
			pc_out <= (others => '0');
		elsif(clk'event and clk = '1' and wr = '1') then
			pc_out <= pc_in;
		end if;
	end process;
end architecture;