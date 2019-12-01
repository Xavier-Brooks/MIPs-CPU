library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Decode_Stage is
  Port (Instruction, RegDataA, RegDataB : in std_logic_vector(31 downto 0);
        Jmp, MemWr, MemRD, RegEnWB :out std_logic;
        ValA, ValB, words :out std_logic_vector(31 downto 0);
        JmpADDR :out std_logic_vector(27 downto 0);
        ALUop :out std_logic_vector(3 downto 0);
        RegIdxA, RegIdxB, RegIdxWB :out std_logic_vector(4 downto 0));
end Decode_Stage;

architecture beh of Decode_Stage is
begin
process(Instruction, RegDataA, RegDataB) is
    begin
	if Instruction(31 downto 26) = "000000" then 
            ValA <= RegDataA;
		    MemRD <= '0';
		    MemWr <= '0';
		    Jmp   <= '0';
		    JmpADDR <= x"0000000";	
    		RegIdxA <= Instruction(25 downto 21);
    		RegIdxB <= Instruction(20 downto 16);
    		RegIdxWB <= Instruction(15 downto 11);
    		RegEnWB <= '1'; 		

		case Instruction(5 downto 0) is 
			when "100000" => ALUop <= "0100";
			      ValB <= RegDataB;
			      words <= RegDataB;
			when "100100" => ALUop <= "1010";
			      ValB <= RegDataB;
			      words <= RegDataB;
			when "011001" => ALUop <= "0110";
			      ValB <= RegDataB;
			      words <= RegDataB;
			when "100101" => ALUop <= "1000";
			      ValB <= RegDataB;
			      words <= RegDataB;
			when "000000" => ALUop <= "1100";
			      ValB <= x"000000" & "000" & Instruction(10 downto 6);
			      words <= x"000000" & "000" & Instruction(10 downto 6);
			when "000011" => ALUop <= "1110";
			      ValB <= x"000000" & "000" & Instruction(10 downto 6);
			      words <= x"000000" & "000" & Instruction(10 downto 6);
			when "000010" => ALUop <= "1101";
			      ValB <= x"000000" & "000" & Instruction(10 downto 6);
			      words <= x"000000" & "000" & Instruction(10 downto 6);
			when "100011" => ALUop <= "0101";
			      ValB <= RegDataB;
			      words <= RegDataB;
			when "100110" => ALUop <= "1011";
		          ValB <= RegDataB;
		          words <= RegDataB;
			when others => ALUop <= "0100";
		          ValB <= RegDataB;
		          words <= RegDataB;
		end case;
	
	elsif Instruction(31 downto 26) = "000010" or Instruction(31 downto 26) = "000011" then        
	           MemWr <= '0';
	           MemRD <= '0';
       		   Jmp <= '1';
        	   JmpADDR <= "00" & Instruction(25 downto 0);
        	   RegEnWB <= '0';
        	   ValA <= RegDataA;
        	   ValB <= RegDataB;
        	   words <= RegDataB;
        	   RegIdxA <= "00000";
        	   RegIdxB <= "00000";
        	   RegIdxWB <= "00000";
        	   ALUop <= "0000";
	else
		       RegIdxA <= Instruction(25 downto 21);
		       RegIdxB <= "00000";
    		   RegIdxWB <= Instruction(20 downto 16);
		       Jmp   <= '0';
               JmpADDR <= x"0000000";
		   case Instruction(31 downto 26) is
	    		when "001000" => ALUop <= "0100"; --Immediate Add 
	    		                 ValB <= x"0000" & Instruction(15 downto 0);
	    		                 words <= x"0000" & Instruction(15 downto 0);
	    		                 MemWr <= '0';
	    		                 MemRD <= '0';
	    		                 RegEnWB <= '1';
	    		                 ValA <= RegDataA;
                when "001100" => ALUop <= "1010"; --Immediate AND
                                 ValB <= x"0000" & Instruction(15 downto 0);
                                 words <= x"0000" & Instruction(15 downto 0);
                                 MemWr <= '0';
                                 MemRD <= '0';
                                 RegEnWB <= '1';
                                 ValA <= RegDataA;
                when "001101" => ALUop <= "1000"; --Immediate OR 
                                 ValB <= x"0000" & Instruction(15 downto 0);
                                 words <= x"0000" & Instruction(15 downto 0);
                                 MemWr <= '0';
                                 MemRD <= '0';
                                 RegEnWB <= '1';
                                 ValA <= RegDataA;
                when "001110" => ALUop <= "1011"; --Immediate XOR
                                 ValB <= x"0000" & Instruction(15 downto 0); 
                                 words <= x"0000" & Instruction(15 downto 0);
                                 MemWr <= '0';
                                 MemRD <= '0';
                                 RegEnWB <= '1';
                                 ValA <= RegDataA;
                when "001111" => ALUop <= "0100"; --Immediate SW, ADD 
             			         MemWr <= '1';
             			         MemRD <= '0';
             			         RegEnWB <= '0';
             			         ValA <= "000000000000000000000000000" & Instruction(25 downto 21);
                                 ValB <= "000000000000000000000000000" & Instruction(20 downto 16);
                                 words <= x"0000" & Instruction(15 downto 0);
                when "100011" => ALUop <= "0100"; --Immediate LW, ADD
                                 MemRD <= '1';
                                 MemWr <= '0';
                                 RegEnWB <= '1';
                                 ValA <= "000000000000000000000000000" & Instruction(25 downto 21);
                                 ValB <= "000000000000000000000000000" & Instruction(20 downto 16);
                                 words <= x"0000" & Instruction(15 downto 0);
			    when others => ALUop <= "0100";
			                     ValB <= x"0000" & Instruction(15 downto 0);
			                     words <= x"0000" & Instruction(15 downto 0);
			                     MemWr <= '0';
			                     MemRD <= '0';
			                     ValA <= RegDataA;
			                     RegEnWB <= '1';		                     
        end case;
	end if;  
 end process;       
end beh;

