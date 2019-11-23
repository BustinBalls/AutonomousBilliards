%function InitiateMatLabParameters()
global arduinoUno rasp cam cameraParams
Directory2Zip='C://Users/ryanl/Downloads/Senior_Project_kyle/Senior_Project/MatlabBilliards';%directory to this  Zip
%{
try
    readDigitalPin(arduinoUno,'D10');
catch
    try
        arduinoUno = arduino('COM8','uno');
    catch
        try
            arduinoUno=arduino('COM6','uno');
        catch
            try
                arduinoUno=arduino('COM7','uno');
            catch
                try
                    arduinoUno=arduino('COM5','uno');
                catch
                    arduinoUno=arduino('COM4','uno');
                end
            end
        end
    end
end
try
    img2 = snapshot(cam2);%
catch
    rasp2 = raspi('10.100.105.132','pi','raspberry');
    cam2 = cameraboard(rasp2,'Resolution','1280x720','Quality',100,...
        'Brightness',55,'Contrast', 0,'Saturation',0,'Sharpness',0);
    img2 = snapshot(cam2);%capture image
end
try
    img = snapshot(cam);%
catch
    rasp = raspi('10.100.114.59','pi','SeniorProject');
    cam = cameraboard(rasp,'Resolution','1280x720','Quality',100,...
        'Brightness',55,'Contrast', 0,'Saturation',0,'Sharpness',0);
    img = snapshot(cam);%capture image
end
%}
try
    img = undistortImage(img,cameraParams);
catch
    for i=1:40
        if (i<10)
            imageFileNames{i}=[Directory2Zip '/Photos/image_000'  num2str(i) '.png'];
        else
            imageFileNames{i}=[Directory2Zip '/Photos/image_00'  num2str(i) '.png'];
        end
    end
    [imagePoints, boardSize, imagesUsed] = detectCheckerboardPoints(imageFileNames);
    imageFileNames = imageFileNames(imagesUsed);
    originalImage = imread(imageFileNames{1});
    [mrows, ncols, ~] = size(originalImage);
    squareSize = 22;  % in units of 'millimeters'
    worldPoints = generateCheckerboardPoints(boardSize, squareSize);
    [cameraParamsOut, imagesUsed, estimationErrors] = estimateCameraParameters(imagePoints, worldPoints, ...
        'EstimateSkew', false, 'EstimateTangentialDistortion', false, ...
        'NumRadialDistortionCoefficients', 2, 'WorldUnits', 'millimeters', ...
        'InitialIntrinsicMatrix', [], 'InitialRadialDistortion', [], ...
        'ImageSize', [mrows, ncols]);
    cameraParams = cameraParamsOut;
end
%end
