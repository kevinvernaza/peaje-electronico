library ieee;
use ieee.std_logic_1164.all;

entity peaje_full is
	port(
	     --entradas del sistema
	     clock                :in std_logic;
		  rst              :in std_logic;
		  categoria                :in std_logic;
		  sensor1     :in std_logic;
		  sensor2      :in std_logic;
		  
		  --salidas del sistema
		  semaforo1R   :out std_logic;
		  semaforo1V    :out std_logic;
		  semaforo2R   :out std_logic;
		  semaforo2V    :out std_logic;
		  talanquera1 :out std_logic;
		  talanquera2  :out std_logic;
		  buzzer1             :out std_logic);
end peaje_full;

architecture arq_pejae of peaje_full is

component maquina is
	port(
	     --entradas del sistema
	     clk                :in std_logic;
		  reset              :in std_logic;
		  cat                :in std_logic;
		  sensor_entrada     :in std_logic;
		  sensor_salida      :in std_logic;
		  
		  --salidas del sistema
		  semaforo_entrada   :out std_logic;
		  semaforo_salida    :out std_logic;
		  talanquera_entrada :out std_logic;
		  talanquera_salida  :out std_logic;
		  alarma             :out std_logic );
end component;


component MicroServo is
    generic( Max: natural := 500000);
    Port (   clk :  in  STD_LOGIC;--reloj de 50MHz
             selector :  in  STD_LOGIC;--selecciona las 4 posiciones
             PWM :  out  STD_LOGIC);--terminal donde sale la señal de PWM
end component;


component semaforo is
    Port (
        ForBsensor : in std_logic;
        led_r    : out std_logic;
        led_g    : out std_logic );
end component;

component BUZZER is
port(
        CLK , RESET : in STD_LOGIC;
        BEEP: buffer STD_LOGIC );
end component;

component infrared is
port ( sensorin : in std_logic;
	    sensorout : out std_logic);
end component;

signal  sinsen1,sinsen2,sinsem1,sinsem2,sintal1,sintal2,xuzzer1 : std_logic;
	
begin

SEN1 : infrared port map(sensor1 ,sinsen1);
SEN2 : infrared port map(sensor2 ,sinsen2);
SEM1 : semaforo port map(sinsem1 ,semaforo1R,SEMaforo1V);
SEM2 : semaforo port map(sinsem2,semaforo2R,semaforo2V);
Tal1 : microServo port map(clock,sinsen1,talanquera1);
Tal2 : microServo port map(clock,sinsen2,talanquera2);
Me: maquina port map(clock ,rst ,categoria,sinsen1,sinsen2,sinsem1,sinsem2,sintal1,sintal2,buzzer1);























end arq_pejae;