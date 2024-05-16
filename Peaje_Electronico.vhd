library ieee;
use ieee.std_logic_1164.all;

entity Peaje_Electronico is
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
		  led_cat_id         :out std_logic);
		  
end Peaje_Electronico;

architecture arq_pejae of Peaje_Electronico is


	type estados is( estado0, estado1 , estado2 , estado3 , estado4 , estado5 , estado6 );--crear los estados
	signal estado_presente , estado_siguiente : estados;
	
	--señal auxiliar para controlar el cambio de estados
	signal x : std_logic;
	
	--crear el vector cat-id
	signal entrada_concatenada : std_logic_vector(4 downto 0);
			
			

begin
	
	state_memory: process (clk , reset)--siempre es asi
		begin
			if (reset = '0') then
				estado_presente <= estado0;
			elsif (clk' event and clk='1') then
				estado_presente <= estado_siguiente;
			end if;
	end process;
	
	
	next_state: process(estado_presente , estado_via ,categoria ,identificacion,pagar,sensor_entrada,sensor_salida)
		begin
		
			case (estado_presente) is	
				when estado0 => if(estado_via='1') then
										estado_siguiente <= estado1;
										x<='1';
									 else
										estado_siguiente <= estado0;
										x<='0';
									 end if;
								
				when estado1 => if(sensor_entrada='1') then
										estado_siguiente <= estado2;
										x<='1';
									 else
										estado_siguiente <= estado1;
										x<='0';
									 end if;
							  
				when estado2 => if( categoria&identificacion =  "01001")then
										estado_siguiente <= estado3;
										x<='1';
									 elsif(categoria&identificacion ="10010")then
										estado_siguiente <= estado3;
										x<='1';
									 elsif(categoria&identificacion ="11100")then
										estado_siguiente <= estado3;
										x<='1';
									 else
										estado_siguiente <= estado2;
										x<='0';
									 end if;
							  
				when estado3 => if(pagar=categoria) then
										estado_siguiente <= estado6;
										x<='1';
									 else
										estado_siguiente <= estado4;
										x<='0';
									end if;
							  
				when estado4 => if(pagar=categoria) then
										estado_siguiente <= estado6;
										x<='1';
									 else
										estado_siguiente <= estado5;
										x<='0';
									 end if;
								
				when estado5 => if(pagar=categoria) then
										estado_siguiente <= estado6;
										x<='1';
									 else
										estado_siguiente <= estado6;
										x<='0';
									 end if;
								
				when estado6 => if(sensor_salida='1') then
										estado_siguiente <= estado0;
										x<='1';
									 else
										estado_siguiente <= estado6;
										x<='0';
									 end if;
			end case;				
	end process;
	
	
	output_logic : process (x) --que pasa con las salidas 
		begin
			case (estado_presente) is
		
				when estado0 =>  if ( x = '1' ) then
											semaforo_entrada    <= '1';
											semaforo_salida     <= '1';
											talanquera_entrada  <= "10";
											talanquera_salida   <= "10";
											mostrador_categoria <= "0000001";
											mostrador_tarifa    <= "0000001";
											alarma              <= '0';
											led_cat_id          <= '0';
					              else
											semaforo_entrada    <= '0';
											semaforo_salida     <= '0';
											talanquera_entrada  <= "00";
											talanquera_salida   <= "00";
											mostrador_categoria <= "1111111";
											mostrador_tarifa    <= "1111111";
											alarma              <= '0';
											led_cat_id          <= '0';
					              end if;
							  
				
				when estado1 => if ( x = '1' ) then
											semaforo_entrada    <= '1';
											semaforo_salida     <= '1';
											talanquera_entrada  <= "10";
											talanquera_salida   <= "11";
											mostrador_categoria <= "0000001";
											mostrador_tarifa    <= "0000001";
											alarma              <= '0';
											led_cat_id          <= '0';
									 else
											semaforo_entrada    <= '0';
											semaforo_salida     <= '1';
											talanquera_entrada  <= "01";
											talanquera_salida   <= "10";
											mostrador_categoria <= "0000001";
											mostrador_tarifa    <= "0000001";
											alarma              <= '0';
											led_cat_id          <= '0';
									 end if;
						  
							  
				when estado2 => if ( x = '1' ) then
					                  entrada_concatenada <= categoria & identificacion;
											case categoria is
												when "01"   => mostrador_categoria <= "1001111";
												when "10"   => mostrador_categoria <= "0010010";
												when "11"   => mostrador_categoria <= "0000110";
												when others => mostrador_categoria <= "1111111";
											end case;
											
											case categoria is
												when "01"   => mostrador_tarifa <= "1001111";
												when "10"   => mostrador_tarifa <= "0010010";
												when "11"   => mostrador_tarifa <= "0000110";
												when others => mostrador_tarifa <= "1111111";
											end case;
											
											case entrada_concatenada is
												when "01001" | "10010" | "11100" => led_cat_id <= '1';
												when others                      => led_cat_id <= '0';
											end case;
						
										semaforo_entrada   <= '1';
										semaforo_salida    <= '0';
										talanquera_entrada <= "10";
										talanquera_salida  <= "10";
										alarma             <= '0';
						         else
										semaforo_entrada   <= '0';
										semaforo_salida    <= '0';
										talanquera_entrada <= "10";
										talanquera_salida  <= "10";
										alarma             <= '0';
						         end if;
							  
				when estado3 => if ( x = '1' ) then
											semaforo_entrada    <= '1';
											semaforo_salida     <= '0';
											talanquera_entrada  <= "10";
											talanquera_salida   <= "10";
											mostrador_categoria <= "0000001";
											mostrador_tarifa    <= "0000001";
											alarma              <= '0';
											led_cat_id          <= '1';
						          else
											semaforo_entrada    <= '1';
											semaforo_salida     <= '1';
											talanquera_entrada  <= "10";
											talanquera_salida   <= "10";
											mostrador_categoria <= "0000001";
											mostrador_tarifa    <= "0000001";
											alarma              <= '0';
											led_cat_id          <= '1';
						          end if;
													  
				when estado4 => if ( x = '1' ) then
											semaforo_entrada    <= '1';
											semaforo_salida     <= '0';
											talanquera_entrada  <= "10";
											talanquera_salida   <= "10";
											mostrador_categoria <= "0000001";
											mostrador_tarifa    <= "0000001";
											alarma              <= '0';
											led_cat_id          <= '1';
									else
											semaforo_entrada    <= '1';
											semaforo_salida     <= '1';
											talanquera_entrada  <= "10";
											talanquera_salida   <= "10";
											mostrador_categoria <= "0000001";
											mostrador_tarifa    <= "0000001";
											alarma              <= '0';
											led_cat_id          <= '1';	
									end if;
							  
				when estado5 => if ( x = '1' ) then
											semaforo_entrada    <= '1';
											semaforo_salida     <= '0';
											talanquera_entrada  <= "10";
											talanquera_salida   <= "10";
											mostrador_categoria <= "0000001";
											mostrador_tarifa    <= "0000001";
											alarma              <= '0';
											led_cat_id          <= '1';
									else
											semaforo_entrada    <= '0';
											semaforo_salida     <= '0';
											talanquera_entrada  <= "10";
											talanquera_salida   <= "10";
											mostrador_categoria <= "0000001";
											mostrador_tarifa    <= "0000001";
											alarma              <= '1';
											led_cat_id          <= '1';
									end if;
							  
				when estado6 => if ( x = '1' ) then
											semaforo_entrada    <= '0';
											semaforo_salida     <= '0';
											talanquera_entrada  <= "01";
											talanquera_salida   <= "01";
											mostrador_categoria <= "0000001";
											mostrador_tarifa    <= "0000001";
											alarma              <= '0';
											led_cat_id          <= '1';
											
										else 
											semaforo_entrada    <= '1';
											semaforo_salida     <= '0';
											talanquera_entrada  <= "10";
											talanquera_salida   <= "10";
											mostrador_categoria <= "0000001";
											mostrador_tarifa    <= "0000001";
											alarma              <= '1';
											led_cat_id          <= '1';
					              end if;		
			end case;
	end process;
end arq_pejae;