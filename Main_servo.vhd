library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Main_servo is
    Port (   
        clk_Master :  in  STD_LOGIC;
        selector  :  in  STD_LOGIC;
        PWM       :  out STD_LOGIC
    );
end Main_servo;

architecture Arqu_Serv of Main_servo is

    signal servo_PWM : STD_LOGIC;
    signal divisor_out1 : STD_LOGIC;

    component MicroServo is
        generic (
            Max: natural := 500000
        );
        Port (
            clk : in STD_LOGIC;
            selector : in STD_LOGIC;
            PWM : out STD_LOGIC
        );
    end component;

    component DivisorFrecuencia is
        Port (
            clk : in STD_LOGIC;
            rst : in STD_LOGIC;
            out1 : buffer STD_LOGIC
        );
    end component;

begin

    
    Servo_Instance: MicroServo
        generic map (
            Max => 500000
        )
        port map (
            clk => clk_Master,
            selector => selector,
            PWM => servo_PWM
        );

    Divisor_Instance: DivisorFrecuencia
        port map (
            clk => clk_Master,
            rst => '0',  
            out1 => divisor_out1
        );

   
    PWM <= servo_PWM and divisor_out1;

end Arqu_Serv;