library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux4 is
port(a, b, c: in signed (63 downto 0);
	 sel: in std_logic_vector (1 downto 0);
	 d: out signed (63 downto 0));
end entity;

architecture behaviour of mux4 is
begin
	with sel select
		d <= a when "00",
			 b when "01",
			 c when "10",
			 (others => '0') when others;
end behaviour;