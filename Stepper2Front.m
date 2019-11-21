function Stepper2Front()
global  arduinoUno ESTOP
%ESTOP WILL BE ADDED to cut all motor power set to pin 2 as NO set LOW
try
    readDigitalPin(arduinoUno,'D10');
catch
    arduinoUno = arduino('COM8','uno');
end
atHome=readDigitalPin(arduinoUno,'D10');
while atHome==1%reads until limit switch is High, used on a normally open switch with a pullDown Resistor
    writeDigitalPin(arduinoUno,'D4',0);
    writePWMDutyCycle(arduinoUno,'D3',0.7);
    atHome=readDigitalPin(arduinoUno,'D10');
end
writeDigitalPin(arduinoUno,'D3',0);

end
