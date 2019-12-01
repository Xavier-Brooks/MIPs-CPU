library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Data_Mem is
generic (width:integer:=32;
         addr_space:integer:=10); 
port(clk, w_en:in std_logic;
     addr :in std_logic_vector(addr_space-1 downto 0);
     d_in :in std_logic_vector(width-1 downto 0);
     d_out :out std_logic_vector(width-1 downto 0));
end Data_Mem;

architecture beh of Data_Mem is

type memory_type is array (2**addr_space-1 downto 0) of std_logic_vector(width-1 downto 0);
signal mips_mem:memory_type:= (others =>x"00000000"); 

begin
    mem_proc:process(clk) is
        begin
            if rising_edge(clk) then
                if w_en = '1' then
                    mips_mem(to_integer(unsigned(addr))) <= d_in;
                end if;
            end if;                 
    end process;
    
    d_out <= mips_mem(to_integer(unsigned(addr)));  
    
end beh; 