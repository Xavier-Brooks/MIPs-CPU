library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity PC is
  Port (pc_in :in std_logic_vector(27 downto 0); 
        rst   :in std_logic;
        clk   :in std_logic;
        outPC :out std_logic_vector(27 downto 0));
end PC;

architecture beh of PC is
begin
    process(clk) is
     begin
      if rising_edge(clk) then
        if rst = '1' then 
            outPC <= x"0000000";
        else 
            outPC <= pc_in;
        end if;
      end if;  
    end process;
end beh;