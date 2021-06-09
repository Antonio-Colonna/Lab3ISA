library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity Adder is
GENERIC(N:INTEGER:=64);
port(a, b: in std_logic_vector (N-1 downto 0);
	 c: out std_logic_vector (N-1 downto 0));
end entity;

architecture behaviour of Adder is
begin
	c <= a+b;
end behaviour;