library ieee;
use ieee.std_logic_1164.all;

entity BitAdder is
port(A, B:in std_logic; 
     Cin :in std_logic;
     Cout:out std_logic;
     Sum :out std_logic);
end BitAdder;

Architecture beh of BitAdder is
begin

Sum <= A xor B xor Cin;
Cout <= (A and B) or (Cin and (A XOR B));

end beh;