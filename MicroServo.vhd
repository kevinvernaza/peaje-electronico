library IEEE;

use IEEE.STD_LOGIC_1164.ALL;

use IEEE.STD_LOGIC_ARITH.ALL;

use IEEE.STD_LOGIC_UNSIGNED.ALL;

 

ENTITY MicroServo is

    generic( Max: natural := 500000);

    Port (   clk :  in  STD_LOGIC;--reloj de 50MHz

             selector :  in  STD_LOGIC ;--selecciona las 4 posiciones

             PWM :  out  STD_LOGIC);--terminal donde sale la señal de PWM

end MicroServo;

 

ARCHITECTURE PWM of MicroServo is

   signal PWM_Count: integer range 1 to Max;--500000;

begin

 

generacion_PWM:

   process( clk, selector,PWM_Count)

                     constant pos1: integer := 50000;  --representa a 1.00ms = 0°

                     constant pos2: integer := 62500;  --representa a 1.25ms = 45°

                     constant pos3: integer := 75000;  --representa a 1.50ms = 90°

                     constant pos4: integer := 100000; --representa a 2.00ms = 180°

          begin

             if rising_edge(clk)then PWM_Count <= PWM_Count + 1;

             end if;

                     case (selector) is

                                 when'0' =>--con el selector en 00 se posiciona en servo en 0°

                                             if PWM_Count <= pos1 then PWM <= '1';

                                             else                                        PWM <= '0';

                                             end if;

                                 when '1' =>-- con el selector en 01 se posiciona en servo en 45°

                                             if PWM_Count <= pos2 then PWM <= '1';

                                             else                                        PWM <= '0';

                                             end if;


                                 when others => null;

                     end case;

          end process generacion_PWM;

end PWM;