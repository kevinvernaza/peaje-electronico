library ieee;
use ieee.std_logic_1164.all;

entity Main_Peaje_electronico is
	port(
	     --entradas
	     clokc                  :in std_logic;
		  rst                    :in std_logic;
		  
		  habilitador_via        :in std_logic;
		  
		  entrada_categoria      :in std_logic_vector(1 downto 0);
		  entrada_identificacion :in std_logic_vector(2 downto 0);
		  
		  costear                :in std_logic_vector(1 downto 0);
		  
		  front_sensor           :in std_logic;
		  bank_sensor            :in std_logic;
		  
		  --salidas
		  semaforo_entradaR   :out std_logic;
		  semaforo_entradaV   :out std_logic;
		  
		  semaforo_salidaR    :out std_logic;
		  semaforo_salidaV    :out std_logic;
		  
		  front_talanquera    :out std_logic;
		  bank_talanquera     :out std_logic;
		  
		  categoria_7seg      :out std_logic_vector(6 downto 0);
		  tarifa_7seg         :out std_logic_vector(6 downto 0);
		  
		  alarma_aviso        :out std_logic;
		  led                 :out std_logic );
		  
end Main_Peaje_electronico;

architecture Arch_Peaje of main_Peaje_electronico is

--componente para los sesores
		component infrared is
			port (sensorin  : in std_logic;
					sensorout : out std_logic);
		end component;
		
--componente para la maquina de estdaos	
		component Peaje_Electronico is
			port(
				  --entradas del sistema
				  clk                :in std_logic;
				  reset              :in std_logic;
				  estado_via         :in std_logic;
				  categoria          :in std_logic_vector(1 downto 0);
				  identificacion     :in std_logic_vector(2 downto 0);
				  pagar              :in std_logic_vector(1 downto 0);
				  sensor_entrada     :in std_logic;
				  sensor_salida      :in std_logic;
				  
				  --salidas del sistema
				  semaforo_entrada   :out std_logic;
				  semaforo_salida    :out std_logic;
				  talanquera_entrada :out std_logic_vector(1 downto 0);
				  talanquera_salida  :out std_logic_vector(1 downto 0);
				  mostrador_categoria:out std_logic_vector(6 downto 0);
				  mostrador_tarifa   :out std_logic_vector(6 downto 0);
				  alarma             :out std_logic;
				  led_cat_id         :out std_logic );
				  
		end component;
		
--componente para los RGB
		component semaforo is
			 Port ( ForBsensor : in std_logic;
					  led_r      : out std_logic;
					  led_g      : out std_logic );
		end component;

----componente para los ServoMotores		
		component MicroServo is
			 generic(Max: natural := 500000);
			 Port   (clk          : in STD_LOGIC;                      -- Reloj de 50MHz
					   selector     : in STD_LOGIC_VECTOR (1 downto 0);  -- Selección de las 4 posiciones
					   PWM          : out STD_LOGIC);                    -- Terminal donde sale la señal de PWM
		end component;
		
--componete para la alarma	
		component BUZZER is
			port( CLK , RESET : in STD_LOGIC;
					BEEP        : buffer STD_LOGIC );
		end component;

		
--creacion de señales
	signal xsen1   : std_logic;
	signal xsen2   : std_logic;
	
	signal xsem1   : std_logic;
	signal xsem2   : std_logic;
	signal xtal1   : std_logic_vector(1 downto 0);
	signal xtal2   : std_logic_vector(1 downto 0);
	signal xalarma : std_logic;

begin

	sen1 : infrared port map(front_sensor , xsen1);
	sen2 : infrared port map(bank_sensor  , xsen2);


	ME : peaje_Electronico port map (clokc , rst , habilitador_via, entrada_categoria,entrada_identificacion,costear,xsen1,xsen2,xsem1,xsem2,xtal1,xtal2,categoria_7seg,tarifa_7seg,xalarma,led);
	S1 : semaforo          port map (xsem1 , semaforo_entradaR , semaforo_entradaV);
	S2 : semaforo          port map (xsem2 , semaforo_salidaR  , semaforo_salidaV );
	T1 : microServo        port map (clokc , xtal1 , front_talanquera);
	T2 : microServo        port map (clokc , xtal2 , bank_talanquera );
	AL : BUZZER            port map (clokc , xalarma , alarma_aviso  );

end arch_Peaje;