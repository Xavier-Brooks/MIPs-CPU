library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity XOR2 is
  GENERIC (N :INTEGER);
  Port (A, B :in std_logic_vector(N-1 downto 0);
        Y    :out std_logic_vector(N-1 downto 0));
end XOR2;

architecture dataflow of XOR2 is
begin 
    Y <= A xor B;
end dataflow;
