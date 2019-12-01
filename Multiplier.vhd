library ieee; 
use ieee.std_logic_1164.all;

entity multiplier is
generic (N:integer);
port (m, q :in std_logic_vector(N-1 downto 0);
      product :out std_logic_vector(2*N-1 downto 0));
 end multiplier;

architecture struct of multiplier is
--holds intermediate result values of the multiplier operations
type circuit_array is array(N downto 0) of std_logic_vector(N-1 downto 0);

component BitAdder is
port(A, B:in std_logic; 
     Cin :in std_logic;
     Cout:out std_logic;
     Sum :out std_logic);
end component;

signal sign_extends: circuit_array := (others => X"00000000");
signal ands: circuit_array := (others => x"00000000");
signal sums: circuit_array := (others => x"00000000");
signal carry: circuit_array := (others => x"00000000");

begin
q_signe:for C in 0 to (N-1) generate 
	sign_extends(C) <= (others => q(C)); --sign extends each bit of q in preparation of and operations
end generate;

anding:for D in 0 to (N-1) generate
	ands(D) <= sign_extends(D) and m; --creates each of the and outputs 
end generate;

row_one:for F in 0 to N-1 generate 
    row_one_bit:BitAdder --creates the first row of adders
    port map(A => '0', B => ands(0)(F), Cin => '0', Cout => carry(0)(F), Sum => sums(0)(F));
end generate row_one;

G1:for E in 1 to N-1 generate --creates every row except the last
    G2: for F in 0 to N-2 generate    
        Bits:BitAdder --creates each adder in each row except the last
        port map(A => sums(E-1)(F + 1), B => ands(E)(F), Cin => carry(E-1)(F), Cout => carry(E)(F), Sum => sums(E)(F));                            
    end generate G2;
        last_bit:BitAdder --creates the last adder in each row except the first and the last
        port map(A => '0', B => ands(E)(N-1), Cin => carry(E-1)(N-1), Cout => carry(E)(N-1), Sum => sums(E)(N-1));
end generate G1; 

bit0:BitAdder --creates the first adder in the last row of a generic adder
port map(A => sums(N-1)(1), B => carry(N-1)(0), Cin => '0', Cout => carry(N)(0), Sum => sums(N)(0));

G3:for G in 1 to N-2 generate --creates each adder between the first and last in the final row    
    last_row_bit:BitAdder
    port map(A => sums(N-1)(G + 1), B => carry(N-1)(G), Cin => carry(N)(G-1), Cout => carry(N)(G), Sum => sums(N)(G));        
end generate G3;

bitl:BitAdder --creates the final adder in a generic multiplier
port map(A => '0', B => carry(N-1)(N-1), Cin => carry(N)(N-2), Cout => carry(N)(N-1), Sum => sums(N)(N-1));

final_answer:for H in 0 to N generate
    product(H) <= sums(H)(0); --maps the proper output bits to the final product
    Final_bit_set:if H = N generate	--maps the proper bits to the final product in the last row of the multiplier
		product(2*N-1 downto H) <= sums(H);
    end generate;
end generate final_answer;

end struct;