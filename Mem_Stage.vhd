library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Mem_Stage is
port(CLK:in std_logic;
     AluResult :in std_logic_vector(31 downto 0);
     MemWrData:in std_logic_vector(31 downto 0);
     ExMemWr, ExMemRD :in std_logic;
     ExMemWbIdx:in std_logic_vector(4 downto 0); 
     RegData :out std_logic_vector(31 downto 0);
     MemData :out std_logic_vector(31 downto 0);
     MemWr, MemRD :out std_logic; 
     WbIdx:out std_logic_vector(4 downto 0));
end Mem_Stage;

architecture struct of Mem_Stage is

component Data_Mem is
generic (width: integer := 32;
         addr_space: integer := 10); 
port(clk, w_en:in std_logic;
     addr :in std_logic_vector(addr_space-1 downto 0);
     d_in :in std_logic_vector(width-1 downto 0);
     d_out :out std_logic_vector(width-1 downto 0));
end component;

begin
Data_Mem0:Data_Mem
port map(clk => CLK, w_en => ExMemWr, addr => AluResult(9 downto 0), d_in => MemWrData, d_out => MemData);

RegData <= AluResult;
MemWr <= ExMemWr;
MemRD <= ExMemRD;
WbIdx <= ExMemWbIdx; 
end struct;