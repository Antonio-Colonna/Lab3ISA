library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ctrl is
port(instr: in std_logic_vector (31 downto 0);
	 WB: out std_logic_vector(1 downto 0);
	 M: out std_logic_vector(2 downto 0);
	 EX: out std_logic_vector(2 downto 0));
end entity;

architecture behaviour of ctrl is
signal sig_out: std_logic_vector (7 downto 0); -- WB & M & EX
begin
	with instr(6 downto 0)  select
		sig_out <= "10000100" when "0110011", -- R
			 "10000001" when "0010011", -- immediate
			 "11010001" when "0000011", --load
			 "00001001" when "0100011", --store
			 "00100010" when "1100011", --branch
			 "10100010" when "0010111", --auipc
			 "11010001" when "0110111", --lui
			 "10100010" when "1101111",
			 "00000000" when others; --jump
			 
	WB <= sig_out(7 downto 6);
	M <= sig_out(5 downto 3);
	EX <= sig_out(2 downto 0);
	
end behaviour;
			 
