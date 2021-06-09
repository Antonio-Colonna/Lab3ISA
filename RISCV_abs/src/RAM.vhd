library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RAM is
GENERIC (N: natural := 64);
port(address: in std_logic_vector (15 downto 0);
	 data: in signed (N-1 downto 0);
	 WE_n, clk, CS, rst_n: std_logic;
	 Q: out signed (N-1 downto 0));
end entity;

architecture beh of RAM is
	type ram_array is array (0 to 2**16-1) of signed(N-1 downto 0);
	signal mem: ram_array;
	begin
	p0: process(clk, rst_n) is
		begin
			if(rst_n = '0') then
				for i in 0 to 2**16-1 loop
					mem(i) <= (others => '0');
				end loop;			
			elsif (clk = '1' and clk'event) then
				if WE_n = '0' then
					mem(to_integer(unsigned(address))) <= data;
				end if;
			end if;
	end process;
	Q <= mem(to_integer(unsigned(address)));
end architecture;
