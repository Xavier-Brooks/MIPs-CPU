library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Execute_Stage is
    Port (ALUop :in std_logic_vector(3 downto 0);--determines operation being performed by alu
          IdExA :in std_logic_vector(31 downto 0); -- first ALU input in execute stage
          IdExB, StoreData :in std_logic_vector(31 downto 0); -- second ALU input and MemWrData in execute stage
          IdExWbIdx :in std_logic_vector(4 downto 0); -- memory writeback index
          IdExWbEn, IdExMemRD, IdExMemWr :in std_logic; --determines if writeback is enabled, whether reading/writing from data mem
          
          MemWrData :out std_logic_vector(31 downto 0); --data to be written to memory
          AluResult :out std_logic_vector(31 downto 0); -- result of the alu operation
          ExMemWbIdx :out std_logic_vector(4 downto 0); --memory writeback index
          ExWbEn, ExMemRD, ExMemWr :out std_logic);
end Execute_Stage;

architecture struct of Execute_Stage is

component alu32 is -- declares the alu as a component of the execute stage
generic (N : INTEGER := 32);
port    ( A, B :IN std_logic_vector(N-1 downto 0);
          OP   :IN std_logic_vector(3 downto 0);
          Y    :OUT STD_LOGIC_VECTOR(N-1 downto 0)
         );
end component;

begin

alu0:alu32--declares an instance of the alu
port map(A => IdExA, B => IdExB, OP => ALUop, Y => AluResult);

--handles the rest of the outputs of the execute stage
MemWrData <= StoreData;
ExWbEn <= IdExWbEn; 
ExMemRD <= IdExMemRD;
ExMemWR <= IdExMemWr;
ExMemWbIdx <= IdExWbIdx;

end struct;

