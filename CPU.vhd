library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity CPU is
 Port (CPU_clk, CPU_rst:in std_logic);
end CPU;

architecture MIPs_arch of CPU is

component InstructionFetch is
     Port (CLK, RST, JMP :in std_logic; --JMP is the select for the mux
           JMPADDR : in std_logic_vector(27 downto 0);
           instruction :out std_logic_vector(31 downto 0));
end component;

component register_file is
	PORT (
		rst, clk, we : IN STD_LOGIC;
		rd1, rd2, wr : IN STD_LOGIC_VECTOR(4 downto 0);
		din          : IN STD_LOGIC_VECTOR(31 downto 0);
		out1, out2   : OUT STD_LOGIC_VECTOR(31 downto 0)
	);
end component;

component Decode_Stage is
  Port (Instruction, RegDataA, RegDataB : in std_logic_vector(31 downto 0);
        Jmp, MemWr, MemRD, RegEnWB :out std_logic;
        ValA, ValB, words:out std_logic_vector(31 downto 0);
        JmpADDR :out std_logic_vector(27 downto 0);
        ALUop :out std_logic_vector(3 downto 0);
        RegIdxA, RegIdxB, RegIdxWB :out std_logic_vector(4 downto 0));
end component;

component Execute_Stage is
    Port (ALUop :in std_logic_vector(3 downto 0);--determines operation being performed by alu
          IdExA :in std_logic_vector(31 downto 0); -- first ALU input in execute stage
          IdExB, StoreData :in std_logic_vector(31 downto 0); -- second ALU input and MemWrData in execute stage
          IdExWbIdx :in std_logic_vector(4 downto 0); -- memory writeback index
          IdExWbEn, IdExMemRD, IdExMemWr :in std_logic; --determines if writeback is enabled, whether reading/writing from data mem
          
          MemWrData :out std_logic_vector(31 downto 0); --data to be written to memory
          AluResult :out std_logic_vector(31 downto 0); -- result of the alu operation
          ExMemWbIdx :out std_logic_vector(4 downto 0); --memory writeback index
          ExWbEn, ExMemRD, ExMemWr :out std_logic);
end component;

component Mem_Stage is
port(CLK:in std_logic;
     AluResult :in std_logic_vector(31 downto 0);
     MemWrData:in std_logic_vector(31 downto 0);
     ExMemWr, ExMemRD :in std_logic;
     ExMemWbIdx:in std_logic_vector(4 downto 0); 
     RegData :out std_logic_vector(31 downto 0);
     MemData :out std_logic_vector(31 downto 0);
     MemWr, MemRD :out std_logic; 
     WbIdx:out std_logic_vector(4 downto 0));
end component;

component WriteBack_Stage is
port(MemWr, MemRD:in std_logic;
     MemWbIdx :in std_logic_vector(4 downto 0);
     Reg_Data :in std_logic_vector(31 downto 0);
     Mem_Data :in std_logic_vector(31 downto 0);
     WbEn :out std_logic;
     WbIdx :out std_logic_vector(4 downto 0);
     WbData :out std_logic_vector(31 downto 0));
end component;

--instruction fetch output signals
signal ins_fetch_output: std_logic_vector(31 downto 0);--the instruction to be decoded 
signal dff_instruction: std_logic_vector(31 downto 0);

--instruction decode output signals
signal Decode_regIdA_output, Decode_regIdB_output, Decode_RegIdxWb_out: std_logic_vector(4 downto 0);
signal Decode_ValA_out, Decode_ValB_out, Decode_words_out: std_logic_vector(31 downto 0);
signal Decode_Aluop_out: std_logic_vector(3 downto 0);
signal Decode_JmpADDR_out: std_logic_vector(27 downto 0):=x"0000000";
signal Decode_jmp_out, Decode_MemWr_out, Decode_MemRD_out, Decode_RegEnWB: std_logic;

signal dff_ValA_out, dff_ValB_out, dff_words_out: std_logic_vector(31 downto 0);
signal dff_Aluop_out: std_logic_vector(3 downto 0);
signal dff_JmpADDR_out: std_logic_vector(27 downto 0):=x"0000000";
signal dff_jmp_out, dff_MemWr_out, dff_MemRD_out, dff_RegEnWB: std_logic;
signal dff_RegIdxWb_out:std_logic_vector(4 downto 0);

--register file output signals
signal reg_file_read1, reg_file_read2: std_logic_vector(31 downto 0);

-- Execute Stage output results --
signal Execute_AluResult_out :std_logic_vector(31 downto 0);
signal Execute_MemWrData_out :std_logic_vector(31 downto 0); 
signal Execute_ExMemWbIdx_out :std_logic_vector(4 downto 0); 
signal Execute_ExWbEn_out, Execute_ExMemRD_out, Execute_ExMemWr_out: std_logic;

signal dff_MemRD, dff_MemWr:std_logic;
signal dff_AluResult_out :std_logic_vector(31 downto 0);
signal dff_MemWrData_out :std_logic_vector(31 downto 0); 
signal dff_ExMemWbIdx_out :std_logic_vector(4 downto 0);

-- Mem Stage outputs
signal RegData_out : std_logic_vector(31 downto 0);
signal MemData_out : std_logic_vector(31 downto 0);
signal MemWr_out, MemRD_out :std_logic; 
signal WbIdx_out : std_logic_vector(4 downto 0);

-- Writeback signals --
signal Final_MemWr, Final_MemRD, Final_WbEn:std_logic;
signal Final_MemWbIdx, spare_signal:std_logic_vector(4 downto 0);
signal Final_Reg_Data, Final_Mem_Data, Final_Wb_Data:std_logic_vector(31 downto 0);

-- D flip flop --
signal dff2_jmp_out:std_logic:='0';
signal dff2_JmpADDR_out: std_logic_vector(27 downto 0):=x"0000000";
signal dff2_RegEnWB,dff3_RegEnWB :std_logic; 

signal sample:std_logic_vector(27 downto 0):=x"0000000";

begin
--Phase One --
IF0:InstructionFetch
port map(CLK => CPU_clk, RST => CPU_rst, JMP => dff2_jmp_out,
         JMPADDR => dff2_JmpADDR_out,
         instruction => ins_fetch_output);

dff1_2: process(CPU_clk,CPU_rst) is
    begin
    if (CPU_rst = '1') then
        dff_instruction <= x"00000000";
    elsif (CPU_clk = '1') then 
        dff_instruction <= ins_fetch_output;
    end if; 
end process;

-- Phase Two -- 
ID0:Decode_Stage
port map(Instruction => dff_instruction, RegDataA => reg_file_read1, RegDataB => reg_file_read2, 
         Jmp => Decode_jmp_out, MemWr => Decode_MemWr_out, MemRD => Decode_MemRD_out, RegEnWB => Decode_RegEnWB,
         ValA => Decode_ValA_out, ValB => Decode_ValB_out, words => Decode_words_out, 
         JmpADDR => Decode_JmpADDR_out, ALUop => Decode_Aluop_out,
         RegIdxA => Decode_regIdA_output, RegIdxB => Decode_regIdB_output,
         RegIdxWB => Decode_RegIdxWb_out);

RF0:register_file
port map(rst => CPU_rst, clk => CPU_clk, we => Final_WbEn, rd1 => Decode_regIdA_output, rd2 => Decode_regIdB_output, wr => Final_MemWbIdx,
		 din => Final_Wb_Data, out1 => reg_file_read1, out2 => reg_file_read2);
    
dff2_3: process(CPU_clk,CPU_rst) is
    begin
    if (CPU_rst = '1') then 
         dff_ValA_out <= x"00000000";
         dff_ValB_out <= x"00000000";
         dff_words_out <= x"00000000";
         dff_Aluop_out <= "0000";
         dff_JmpADDR_out <= x"0000000";
         dff_jmp_out <= '0'; 
         dff_MemWr_out <= '0';
         dff_MemRD_out <= '0';
         dff_RegEnWB <= '0';
         dff_RegIdxWb_out <= "00000"; 
    elsif (CPU_clk = '1') then 
         dff_ValA_out <= Decode_ValA_out;
         dff_ValB_out <= Decode_ValB_out;
         dff_words_out <= Decode_words_out;
         dff_Aluop_out <= Decode_Aluop_out;
         dff_JmpADDR_out <= Decode_JmpADDR_out;
         dff_jmp_out <= Decode_jmp_out;
         dff_MemWr_out <= Decode_MemWr_out;
         dff_MemRD_out <= Decode_MemRD_out;
         dff_RegEnWB <= Decode_RegEnWB;
         dff_RegIdxWb_out <= Decode_RegIdxWb_out;
    end if;
end process;

-- Phase Three --
EX0:Execute_Stage
port map(ALUop => dff_Aluop_out, 
         IdExA => dff_ValA_out, 
         IdExB => dff_ValB_out, StoreData => dff_words_out,  
         IdExWbIdx => dff_RegIdxWb_out, 
         IdExWbEn => dff_RegEnWB, IdExMemRD => dff_MemRD_out, IdExMemWr => dff_MemWr_out, 
          
         MemWrData => Execute_MemWrData_out, 
         AluResult => Execute_AluResult_out, 
         ExMemWbIdx => Execute_ExMemWbIdx_out, 
         ExWbEn => Execute_ExWbEn_out, ExMemRD => Execute_ExMemRD_out, ExMemWr => Execute_ExMemWr_out);


dff3_4: process(CPU_clk,CPU_rst) is
    begin
    if (CPU_rst = '1') then 
        dff2_jmp_out <= '0';
        dff2_JmpADDR_out <= x"0000000";
        dff_MemRD <= '0';
        dff_MemWr <= '0';
        dff2_RegEnWB <= '0';
        dff_AluResult_out <= x"00000000";
        dff_MemWrData_out <= x"00000000";
        dff_ExMemWbIdx_out <= "00000";
    elsif (CPU_clk = '1') then
        dff2_RegEnWB <= dff_RegEnWB;
        dff_ExMemWbIdx_out <= Execute_ExMemWbIdx_out;
        dff_MemWrData_out <= Execute_MemWrData_out;
        dff_AluResult_out <= Execute_AluResult_out;
        dff2_jmp_out <= dff_jmp_out;
        dff2_JmpADDR_out <= dff_JmpADDR_out;
        dff_MemRD <= Execute_ExMemRD_out;
        dff_MemWr <= Execute_ExMemWr_out;
    end if;
end process;

--Phase Four --
M0:Mem_Stage
port map(CLK => CPU_clk, AluResult => dff_AluResult_out, MemWrData => dff_MemWrData_out,
         ExMemWr => dff_MemWr, ExMemRD => dff_MemRD,
         ExMemWbIdx => dff_ExMemWbIdx_out,
         RegData => RegData_out,
         MemData => MemData_out,
         MemWr => MemWr_out, MemRD => MemRD_out, 
         WbIdx => WbIdx_out);

dff4_5: process(CPU_clk,CPU_rst) is
    begin if (CPU_rst = '1') then 
        dff3_RegEnWB <= '0';
        Final_MemWr <= '0';
        Final_MemRD <= '0';
        Final_MemWbIdx <= "00000";
        Final_Reg_Data <= x"00000000";
        Final_Mem_Data <= x"00000000"; 
    elsif (CPU_clk = '1') then
        dff3_RegEnWB <= dff2_RegEnWB;
        Final_MemWr <= MemWr_out;
        Final_MemRD <= MemRD_out;
		Final_MemWbIdx <= WbIdx_out;
        Final_Reg_Data <= RegData_out;
        Final_Mem_Data <= MemData_out;
    end if;
end process;
   
--Phase Five --  
W0:WriteBack_Stage
port map(MemWr => Final_MemWr, MemRD => Final_MemRD,
     MemWbIdx => Final_MemWbIdx,
     Reg_Data => Final_Reg_Data, 
     Mem_Data => Final_Mem_Data,
     WbEn => Final_WbEn,
     WbIdx => spare_signal,
     WbData => Final_Wb_Data); 
     
end MIPs_arch;
   