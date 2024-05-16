library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity BUZZER is
port(
        CLK , RESET : in STD_LOGIC;
        BEEP: buffer STD_LOGIC

    );
end BUZZER;

architecture SenalBuzzer of BUZZER is 
signal CONTADOR_NOTA : INTEGER range 0 to 50E3; 

BEGIN

Crearsonido: process (CLK,RESET)
begin
    if RESET = '1' then 
        CONTADOR_NOTA <= 0;
        BEEP<= '0';
        elsif RISING_EDGE(CLK) then
        
        if CONTADOR_NOTA = 50E3 then
            CONTADOR_NOTA <= 0;
            BEEP <= NOT BEEP;
    
        else
            CONTADOR_NOTA <= CONTADOR_NOTA+1;
        end if;
    end if;

end process;

end senalBuzzer;