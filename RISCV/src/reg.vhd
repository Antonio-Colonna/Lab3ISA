library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reg is
GENERIC(N:INTEGER:=219);
port(D: in std_logic_vector(N-1 downto 0);
	 clk, rst_n, R_Wn: std_logic;
	 Q: out std_logic_vector(N-1 downto 0));
end entity;

architecture behaviour of reg is
begin
	process(clk, rst_n, R_Wn)
	begin
		if(rst_n = '0')then
			Q <= (others => '0');
		elsif(clk'event and clk = '1')then
			if(R_Wn = '1')then
				Q <= D;
			end if;
		end if;
	end process;
end behaviour;