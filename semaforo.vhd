LIBRARY IEEE;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.all;

entity semaforo is
    Port (
        ForBsensor : in std_logic;
        led_r    : out std_logic;
        led_g    : out std_logic
    );
end semaforo;

architecture architecture_sem of semaforo is

    -- Definir estados de LED
    constant GREEN : std_logic_vector(1 downto 0) := "10";
    constant RED   : std_logic_vector(1 downto 0) := "01";

    -- Estado inicial
    signal led_state : std_logic_vector(1 downto 0) := GREEN;

begin

    -- Proceso para controlar el LED RGB
    process(ForBsensor)
    begin
        if ForBsensor = '1' then
            -- Sensor detecta algo: LED verde
            led_state <= GREEN;
        else
            -- Sensor no detecta nada: LED rojo
            led_state <= RED;
        end if;
    end process;

    -- Asignar los colores del LED RGB
    led_r <= led_state(1);
    led_g <= led_state(0);

end architecture_sem;