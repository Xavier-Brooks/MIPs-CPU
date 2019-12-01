library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity InstructionFetch is
     Port (CLK, RST, JMP :in std_logic; --JMP is the select for the mux
           JMPADDR : in std_logic_vector(27 downto 0):= x"0000000";
           instruction :out std_logic_vector(31 downto 0));
end InstructionFetch;

architecture struct of InstructionFetch is
component Mux is
  Port (pc_source :in std_logic_vector(27 downto 0);
        jumpto :in std_logic_vector(27 downto 0);
        sel    :in std_logic;
        nextPC :out std_logic_vector(27 downto 0)
        );
end component;

component Adder is
  Port (oldPC :in std_logic_vector(27 downto 0);
        add4  :in std_logic_vector(3 downto 0); 
        pc_next :out std_logic_vector(27 downto 0));
end component;

component Mem is
generic(mem_size : integer := 1024);
  Port (
        Addr :in std_logic_vector(27 downto 0);
        Dout :out std_logic_vector(31 downto 0)
        );
end component;

component PC is
  Port (pc_in :in std_logic_vector(27 downto 0); 
        rst   :in std_logic;
        clk   :in std_logic;
        outPC :out std_logic_vector(27 downto 0));
end component;

signal pc_result, mux_result :std_logic_vector(27 downto 0);
signal mem_result   :std_logic_vector(31 downto 0);
signal spcsrc :std_logic_vector(27 downto 0);

begin

mux_comp: Mux
port map(pc_source => spcsrc, jumpto => JMPADDR, sel => JMP, nextPC => mux_result);

pc_comp: PC
port map(pc_in => mux_result, rst => RST, clk => CLK, outPC => pc_result);

adder_comp: Adder
port map(oldPC => pc_result, add4 => "0100", pc_next => spcsrc);

mem_comp: Mem
port map(Addr => pc_result, Dout => mem_result);

instruction <= mem_result;

end struct;
