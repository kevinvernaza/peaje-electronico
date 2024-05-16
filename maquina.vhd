library ieee;
use ieee.std_logic_1164.all;

entity maquina is
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
end maquina;

architecture arq_pejae of maquina is


	type estados is( estado0, estado1 , estado2 , estado3);--crear los estados
	signal estado_presente , estado_siguiente : estados;
	
	--señal auxiliar para controlar el cambio de estados
	signal x : std_logic := '0';

begin
	
	state_memory: process (clk , reset)--siempre es asi
		begin
			if (reset = '1') then
				estado_presente <= estado0;
			elsif (clk' event and clk='1') then
				estado_presente <= estado_siguiente;
			end if;
	end process;
	
	
	next_state: process(x)
		begin
		
			case (estado_presente) is	
				when estado0 => if(x='1') then
										estado_siguiente <= estado1;
		
									 else
										estado_siguiente <= estado0;
									
									 end if;
								
				when estado1 => if(x='1') then
										estado_siguiente <= estado3;
								
									 else
										estado_siguiente <= estado2;
									
									 end if;
							  
				when estado2 => if(x='1')then
										estado_siguiente <= estado3;
										
									 else
										estado_siguiente <= estado2;
									 end if;
							  
				when estado3 => if(x='1') then
										estado_siguiente <= estado0;
									 else
										estado_siguiente <= estado3;
									end if;

			end case;				
	end process;
	
	
	output_logic : process (sensor_entrada , sensor_salida , cat) --que pasa con las salidas 
		begin
			case (estado_presente) is
		
				when estado0 =>  if ( sensor_entrada = '1' ) then
											semaforo_entrada <='1';
											semaforo_salida <='0';
										   talanquera_entrada <= '0';
											talanquera_salida <= '0';


											x <= '1';
									  else
									      semaforo_entrada <='0';
											semaforo_salida <='0';
											talanquera_entrada <= '1';
											talanquera_salida <= '0';

											x <= '0';
					              end if;
							  
				
				when estado1 => if ( cat = '1' ) then
										semaforo_entrada <='0';
									   semaforo_salida <='1';
										talanquera_entrada <= '0';
										talanquera_salida <= '0';
										x <= '1';
									 else
										semaforo_entrada <='0';
									   semaforo_salida <='0';
										talanquera_entrada <= '0';
										talanquera_salida <= '0';
										x <= '0';

									 end if;
						  
							  
				when estado2 => if ( cat = '1' ) then
										semaforo_entrada <='0';
									   semaforo_salida <='1';
										talanquera_entrada <= '0';
										talanquera_salida <= '0';
										x <= '1';
									 else
										semaforo_entrada <='0';
									   semaforo_salida <='0';
										talanquera_entrada <= '0';
										talanquera_salida <= '0';
										x <= '0';

									 end if;
							  
				when estado3 => if ( sensor_salida = '1' ) then
										semaforo_entrada <='1';
									   semaforo_salida <='0';
										talanquera_entrada <= '1';
										talanquera_salida <= '1';
										x <= '1';
									 else
										semaforo_entrada <='0';
									   semaforo_salida <='1';
										talanquera_entrada <= '0';
										talanquera_salida <= '0';
										x <= '0';
									 end if;
													  		
			end case;
	end process;
end arq_pejae;