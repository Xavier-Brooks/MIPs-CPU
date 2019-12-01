library  IEEE;
use  IEEE.STD_LOGIC_1164.ALL;
use  IEEE.STD_LOGIC_UNSIGNED.ALL;
use  IEEE.NUMERIC_STD.ALL;

entity  srac32 is
GENERIC (N : INTEGER ); --bit  width
PORT (
        A : IN  std_logic_vector(N-1 downto 0);
        SHIFT_AMT : IN  std_logic_vector(N-1 downto  0);
        Y         : OUT  std_logic_vector(N-1 downto 0)
      );
end  srac32;

architecture behavioral of srac32 is
begin
    process(A, SHIFT_AMT) is
        variable  int_shamt : integer;
    begin
        int_shamt  :=  to_integer(unsigned(SHIFT_AMT));
        for i in N-1  downto 0 loop
            if (i + int_shamt < N) then
                Y(i) <= A(i + int_shamt);
            else
                Y(i) <= A(N-1);
            end if;
        end loop;
    end process;
end behavioral;