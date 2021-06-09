library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU_ctrl is
port (instr: in std_logic_vector(3 downto 0);
	  ALU_op: in std_logic_vector(1 downto 0);
	  ALU_ctrl_out: out std_logic_vector(3 downto 0));
end entity;

architecture behaviour of ALU_ctrl is

signal condition: std_logic_vector(5 downto 0);

begin

condition <= ALU_op & instr;

	with condition select
		ALU_ctrl_out <= "0010" when "000000",  -- "0010" -> add
					  "0010" when "000001",
					  "0010" when "000010",
					  "0010" when "000011",
					  "0010" when "000100",
					  "0010" when "000101",
					  "0010" when "000110",
					  "0010" when "000111",
					  "0010" when "001000",
					  "0010" when "001001",
					  "0010" when "001010",
					  "0010" when "001011",
					  "0010" when "001100",
					  "0010" when "001101",
					  "0010" when "001110",
					  "0010" when "001111",
					  "0110" when "010000",  -- "0110" -> sub
					  "0110" when "010001",
					  "0110" when "010010",
					  "0110" when "010011",
					  "0110" when "010100",
					  "0110" when "010101",
					  "0110" when "010110",
					  "0110" when "010111",
					  "0110" when "011000",
					  "0110" when "011001",
					  "0110" when "011010",
					  "0110" when "011011",
					  "0110" when "011100",
					  "0110" when "011101",
					  "0110" when "011110",
					  "0110" when "011111",
					  "0010" when "100000",
					  "0110" when "101000",
					  "0000" when "100111",  -- "0000" -> and
					  "0001" when "100110",	 -- "0001" -> or
					  "0011" when "100100",  -- "0011" -> xor
					  "1111" when others;
					  
end behaviour;
