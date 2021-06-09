library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU is
port(A, B: in signed(63 downto 0);
	 ALU_ctrl: in std_logic_vector(3 downto 0);
	 C: out signed(63 downto 0);
	 zero: out std_logic);
end entity;

architecture behaviour of ALU is
signal tmp: signed (63 downto 0);

begin
	with ALU_ctrl select
		tmp <= A+B when "0010",
			 A-B when "0110",
			 A and B when "0000",
			 A or B when "0001",
			 A xor B when "0011",
			 (others => '0') when others;
			 
	C <= tmp;
	
	with tmp select
	zero <= '1' when "0000000000000000000000000000000000000000000000000000000000000000",
			'0' when others;

end behaviour;
