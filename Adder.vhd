library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity Adder is
  Port (oldPC :in std_logic_vector(27 downto 0);
        add4  :in std_logic_vector(3 downto 0); 
        pc_next :out std_logic_vector(27 downto 0));
end Adder;

architecture beh of Adder is
begin
     pc_next <= std_logic_vector(unsigned(add4) + unsigned(oldPC));
end beh;
