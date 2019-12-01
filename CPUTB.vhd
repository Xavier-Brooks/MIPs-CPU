library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity CPUTB is
--  Port ( );
end CPUTB;

architecture Behavioral of CPUTB is

component CPU is
 Port (CPU_clk, CPU_rst:in std_logic);
end component;

signal sclk :std_logic:= '0';
signal srst :std_logic:= '1';
begin

C0:CPU
port map(CPU_clk => sclk, CPU_rst => srst);

clk_proc:process(sclk) is
begin
    sclk <= not sclk after 15ns;
end process;

srst <= '0' when sclk = '1';
 
end Behavioral;