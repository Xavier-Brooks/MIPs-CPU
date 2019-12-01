library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Mux is
  Port (pc_source :in std_logic_vector(27 downto 0);
        jumpto :in std_logic_vector(27 downto 0);
        sel    :in std_logic;
        nextPC :out std_logic_vector(27 downto 0)
        );
end Mux;

architecture beh of Mux is
     begin
        nextPCq : with sel select
            nextPC <= pc_source when '0',
                      jumpto when '1',
                      pc_source when others;
end beh;
