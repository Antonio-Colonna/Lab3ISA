library ieee;
use ieee.std_logic_1164.all;

entity mux2 is
generic (N : integer := 64);
port(a, b: in std_logic_vector(N-1 downto 0);
	 sel: in std_logic;
	 c: out std_logic_vector(N-1 downto 0));
end entity;

architecture behaviour of mux2 is
begin
	with sel select
		c <= a when '0',
			 b when '1',
			 (others => '0') when others;
end behaviour;
