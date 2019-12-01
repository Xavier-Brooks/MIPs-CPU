library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity alu32 is
generic (N : INTEGER := 32);
port    ( A, B :IN std_logic_vector(N-1 downto 0);
          OP   :IN std_logic_vector(3 downto 0);
          Y    :OUT STD_LOGIC_VECTOR(N-1 downto 0));
end alu32;

architecture structural of alu32 is

component multiplier is
generic (N:integer := 32);
port (m, q :in std_logic_vector(N-1 downto 0);
      product :out std_logic_vector(2*N-1 downto 0));
end component;

component RippleAdder is
generic(N: integer := 32);
port(X, Y:in std_logic_vector(N-1 downto 0); 
     selects :in std_logic;
     co:out std_logic := '0';
     sum :out std_logic_vector(N-1 downto 0));
end component;

component AND2 is 
GENERIC (N : INTEGER  := 32);  --bit  width
PORT (
        A,B : IN  std_logic_vector(N-1 downto 0);
        Y   : OUT std_logic_vector(N-1 downto 0));
end component;

component OR2 is 
GENERIC (N : INTEGER  := 32);  --bit  width
PORT (
        A,B : IN  std_logic_vector(N-1 downto 0);
        Y   : OUT std_logic_vector(N-1 downto 0));
end component;

component XOR2 is
GENERIC (N : INTEGER  := 32);  --bit  width
PORT (
        A,B : IN  std_logic_vector(N-1 downto 0);
        Y   : OUT std_logic_vector(N-1 downto 0));
end component;

component srll32 is
GENERIC (N : INTEGER  := 32); --bit  width
PORT (
        A         : IN   std_logic_vector(N-1 downto 0);
        SHIFT_AMT : IN   std_logic_vector(N-1 downto 0);
        Y         : OUT  std_logic_vector(N-1 downto 0));
end component;

component srac32 is 
GENERIC (N : INTEGER  := 32); --bit  width
PORT (
        A : IN  std_logic_vector(N-1 downto 0);
        SHIFT_AMT : IN  std_logic_vector(N-1 downto  0);
        Y         : OUT  std_logic_vector(N-1 downto 0)
      );
end  component;

signal  and_result  : std_logic_vector (N-1 downto 0);
signal  or32_result : std_logic_vector (N-1 downto 0);
signal  xor_result  : std_logic_vector (N-1 downto 0);
signal  srll_result : std_logic_vector (N-1 downto 0);
signal  srac_result : std_logic_vector (N-1 downto 0);
signal  sselects, sco : std_logic;
signal  addersub    : std_logic_vector (N-1 downto 0);
signal  mult_result : std_logic_vector (2*N-1 downto 0);

begin 
M:multiplier
    generic map(N => 32)
    port map(m => A, q => B, product => mult_result);
AdderSubtractor:RippleAdder
    generic map(N => 32)
    port map(X => A, Y => B, selects => OP(0), co => sco, sum => addersub);
and_comp: AND2
    generic map (N => 32)
    port map (A => A, B => B, Y => and_result);    
or_comp: OR2
    generic map (N => 32)
    port map (A => A, B => B, Y => or32_result);
xor_comp: XOR2
    generic map (N => 32)
    port map (A => A, B => B, Y => xor_result);
srll_comp: srll32
    generic map (N => 32)
    port map (A => A, SHIFT_AMT => B, Y => srll_result);
srac_comp: srac32
    generic map (N => 32)
    port map (A => A, SHIFT_AMT => B, Y => srac_result);

Y <= and_result when OP = "1010" else
     or32_result when OP = "1000" else
     xor_result  when OP = "1011" else
     srll_result when OP = "1101" else
     srac_result when OP = "1110" else
     addersub when OP = "0100" else
     addersub when OP = "0101" else
     mult_result(31 downto 0) when OP = "0110" else 
     and_result;  
 
 end structural;