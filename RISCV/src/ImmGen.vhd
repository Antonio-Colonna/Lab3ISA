library ieee;
use ieee.std_logic_1164.all;

entity ImmGen is
port(a: in std_logic_vector (31 downto 0);
	 b: out std_logic_vector (63 downto 0));
end entity;

architecture behaviour of ImmGen is
begin
	with a(6 downto 0)  select
		b <= (others => '0') when "0110011", -- R
			 a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) &
			 a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) &
			 a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) &
			 a(31) & a(31) & a(31) & a(31) & a(31 downto 20) when "0010011", -- immediate
			 a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) &
			 a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) &
			 a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) &
			 a(31) & a(31) & a(31) & a(31) & a(31 downto 20) when "0000011", --load
			 a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) &
			 a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) &
			 a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) &
			 a(31) & a(31) & a(31) & a(31) & a(31 downto 25) & a(11 downto 7) when "0100011", --store
			 a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) &
			 a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) &
			 a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) &
			 a(31) & a(31) & a(31) & a(31) & a(7) & a(30 downto 25) & a(11 downto 8) & '0' when "1100011", --branch
			 a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) &
			 a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) &
			 a(31 downto 12) & "000000000000" when "0010111", --auipc
			 a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) &
			 a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) &
			 a(31 downto 12) & "000000000000" when "0110111", --lui
			 a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) &
			 a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) &
			 a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(31) & a(19 downto 12) & a(20) 
			 & a(30 downto 21) & '0' when "1101111", --jump
			 (others => '0') when others;
			 
end behaviour;
			 