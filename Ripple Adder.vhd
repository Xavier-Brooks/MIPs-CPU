library ieee;
use ieee.std_logic_1164.all;

entity RippleAdder is
generic(N: integer);
port(X, Y:in std_logic_vector(N-1 downto 0); 
     selects :in std_logic;
     co:out std_logic := '0';
     sum :out std_logic_vector(N-1 downto 0));
end RippleAdder;

Architecture Struct of RippleAdder is

component BitAdder is
port(A, B:in std_logic; 
     Cin :in std_logic;
     Cout:out std_logic;
     Sum :out std_logic);
end component;

signal xorresults:std_logic_vector(N-1 downto 0):= (others => '0');
signal carryouts :std_logic_vector(N-1 downto 0):= (others => '0');

begin

xorresults(0) <= Y(0) xor selects; 

BitAdder0:BitAdder
port map(A => X(0), B => xorresults(0), Cin => selects, Cout => carryouts(0), Sum => sum(0));

generator : for i in 1 to N-1 generate
xorresults(i) <= Y(i) xor Selects;
BitAdders :BitAdder
	port map(A => X(i), B => xorresults(i), Cin => carryouts(i-1), Cout => carryouts(i), Sum => sum(i));
end generate;

end struct;