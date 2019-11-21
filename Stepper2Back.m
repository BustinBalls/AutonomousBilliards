function Stepper2Back()

global arduinoUno ballScrewBack 
try
    readDigitalPin(arduinoUno,'D10');
catch
    arduinoUno = arduino('COM8','uno');
end

for i=1:ballScrewBack
    %% Move Reverse
    writeDigitalPin(arduinoUno,'D4',1);
    writePWMDutyCycle(arduinoUno,'D3',0.7);
end
writeDigitalPin(arduinoUno,'D3',0);
end
