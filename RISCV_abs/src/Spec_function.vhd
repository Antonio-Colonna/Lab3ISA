library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity spec_function is
port(op_code: in std_logic_vector(6 downto 0);
	 RD1: in signed(63 downto 0);
	 sel: out std_logic;
	 funct_out: out signed(63 downto 0));
end entity;

architecture behavior of spec_function is
signal tmp: signed(63 downto 0);
begin
	with op_code select
		sel <= RD1(63) when "0011111",
			   '0' when others;

	tmp <= (others => RD1(63));
	funct_out <= RD1 xor tmp;

end behavior;
