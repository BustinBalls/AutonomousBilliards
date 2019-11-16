function [center_x,center_y] = identi_que(img)
try
    %createMask  Threshold RGB image using auto-generated code from colorThresholder app.
    I = rgb2lab(img);
    % Define thresholds for channel 1 based on histogram settings
    channel1Min = 81.726;
    channel1Max = 99.901;
    % Define thresholds for channel 2 based on histogram settings
    channel2Min = -42.737;
    channel2Max = 13.244;
    % Define thresholds for channel 3 based on histogram settings
    channel3Min = -20.820;
    channel3Max = 37.376;
    % Create mask based on chosen histogram thresholds
    sliderBW = (I(:,:,1) >= channel1Min ) & (I(:,:,1) <= channel1Max) & ...
        (I(:,:,2) >= channel2Min ) & (I(:,:,2) <= channel2Max) & ...
        (I(:,:,3) >= channel3Min ) & (I(:,:,3) <= channel3Max);
    BW = sliderBW;
    % Initialize output masked image based on input image.
    maskedRGBImage = img;
    % Set background pixels where BW is false to zero.
    maskedRGBImage(repmat(~BW,[1 1 3])) = 0;
    %%
    [c, r] = imfindcircles(maskedRGBImage,[16 26],'Sensitivity', .9, 'EdgeThreshold', .5);
    cSelect = c(1,:);%takes strongest possibilty of white
catch
    try
        %If the L*A*B fails then try HSV distortion
        I = rgb2hsv(img);
        % Define thresholds for channel 1 based on histogram settings
        channel1Min = 0.057;
        channel1Max = 0.443;
        % Define thresholds for channel 2 based on histogram settings
        channel2Min = 0.000;
        channel2Max = 0.605;
        % Define thresholds for channel 3 based on histogram settings
        channel3Min = 0.626;
        channel3Max = 1.000;
        % Create mask based on chosen histogram thresholds
        sliderBW = (I(:,:,1) >= channel1Min ) & (I(:,:,1) <= channel1Max) & ...
            (I(:,:,2) >= channel2Min ) & (I(:,:,2) <= channel2Max) & ...
            (I(:,:,3) >= channel3Min ) & (I(:,:,3) <= channel3Max);
        BW = sliderBW;
        % Initialize output masked image based on input image.
        maskedRGBImage = img;
        % Set background pixels where BW is false to zero.
        maskedRGBImage(repmat(~BW,[1 1 3])) = 0;
        [c, r] = imfindcircles(maskedRGBImage,[16 26],'Sensitivity', .9, 'EdgeThreshold', .5);
        cSelect = c(1,:);
    catch
        try
            I = rgb2lab(img);
            % Define thresholds for channel 1 based on histogram settings
            channel1Min = 66.406;
            channel1Max = 95.155;
            % Define thresholds for channel 2 based on histogram settings
            channel2Min = -20.330;
            channel2Max = 8.198;
            % Define thresholds for channel 3 based on histogram settings
            channel3Min = -8.430;
            channel3Max = 57.936;
            % Create mask based on chosen histogram thresholds
            sliderBW = (I(:,:,1) >= channel1Min ) & (I(:,:,1) <= channel1Max) & ...
                (I(:,:,2) >= channel2Min ) & (I(:,:,2) <= channel2Max) & ...
                (I(:,:,3) >= channel3Min ) & (I(:,:,3) <= channel3Max);
            BW = sliderBW;
            % Initialize output masked image based on input image.
            maskedRGBImage = img;
            % Set background pixels where BW is false to zero.
            maskedRGBImage(repmat(~BW,[1 1 3])) = 0;
            [c, r] = imfindcircles(maskedRGBImage,[16 26],'Sensitivity', .9, 'EdgeThreshold', .5);
            
            cSelect = c(1,:);
        catch
            %this is just to avoid errors so i can can still run to test
            %locations
            [center_y,center_x]=size(rgb2gray(img));
            center_y=center_y/2;
            center_x=center_x/2;
            return
        end
    end
end
viscircles(c(1,:), r(1),'Color',[0.8500 0.3250 0.0980],'LineWidth',3,'LineStyle',':');
center_x=cSelect(1);
center_y=cSelect(2);
end