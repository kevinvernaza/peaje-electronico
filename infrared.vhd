LIBRARY IEEE;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.all;

entity infrared is

port ( sensorin : in std_logic;
	    sensorout : out std_logic);
end infrared;


architecture architecture_IR of infrared is
begin
    process(sensorin)
		 begin
			  if sensorin = '1' then
					sensorout <= '1';
			  else
					sensorout <= '0';
			  end if; 
    end process;
end architecture_IR;