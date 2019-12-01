library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity WriteBack_Stage is
port(MemWr, MemRD:in std_logic;
     MemWbIdx :in std_logic_vector(4 downto 0);
     Reg_Data :in std_logic_vector(31 downto 0);
     Mem_Data :in std_logic_vector(31 downto 0);
     WbEn :out std_logic;
     WbIdx :out std_logic_vector(4 downto 0);
     WbData :out std_logic_vector(31 downto 0));
end WriteBack_Stage;

architecture beh of WriteBack_Stage is
begin
    wr_proc:process(Mem_Data, MemRD, Reg_Data) is
        begin
        if (MemRD = '1') then
            WbData <= Mem_Data;
        else 
            WbData <= Reg_Data;
        end if;
    end process;
     WbIdx <= MemWbIdx;
     WbEn <= not MemWR;      
end beh;