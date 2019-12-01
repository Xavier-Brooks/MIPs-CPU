library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity AND2 is
  GENERIC (N :INTEGER);
  Port (A, B :in std_logic_vector(N-1 downto 0);
        Y    :out std_logic_vector(N-1 downto 0));
end AND2;

architecture dataflow of AND2 is
begin 
    Y <= A and B;
end dataflow;
