library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity OR2 is
  GENERIC (N :INTEGER);
  Port (A, B :in std_logic_vector(N-1 downto 0);
        Y    :out std_logic_vector(N-1 downto 0));
end OR2;

architecture dataflow of OR2 is
begin 
    Y <= A or B;
end dataflow;
