function [x,y] = CueTip(RGB)
% Convert RGB image to chosen color space
I = rgb2lab(RGB);

% Define thresholds for channel 1 based on histogram settings
channel1Min = 77.246;
channel1Max = 91.149;

% Define thresholds for channel 2 based on histogram settings
channel2Min = -12.915;
channel2Max = 23.090;

% Define thresholds for channel 3 based on histogram settings
channel3Min = -6.489;
channel3Max = 68.534;

% Create mask based on chosen histogram thresholds
sliderBW = (I(:,:,1) >= channel1Min ) & (I(:,:,1) <= channel1Max) & ...
    (I(:,:,2) >= channel2Min ) & (I(:,:,2) <= channel2Max) & ...
    (I(:,:,3) >= channel3Min ) & (I(:,:,3) <= channel3Max);
BW = sliderBW;

% Initialize output masked image based on input image.
maskedRGBImage = RGB;

% Set background pixels where BW is false to zero.
maskedRGBImage(repmat(~BW,[1 1 3])) = 0;
%%
%figure('Name','Original Image','NumberTitle','off');        %creates 1st figure,
%imshow(RGB);
grey = rgb2gray(maskedRGBImage);                            %grey scale for edge function
BW = edge(grey,'canny');                                    %does its thing
%[yMax_img,xMax_img]=size(grey);                             %max values of image for squaring image
[H,theta,rho] = hough(BW);
%figure('Name','Masked Image for Line Detection','NumberTitle','off');   %second Image
%imshow(maskedRGBImage);
P = houghpeaks(H,100,'threshold',ceil(0.5*max(H(:))));
lines = houghlines(BW,theta,rho,P,'FillGap',10,'MinLength',1);
%figure('Name','Image with Lines Drawn','NumberTitle','off');
%imshow(RGB);
hold on; axis on;
x=[];
y=[];
for k = 1:length(lines)
    if lines(k).theta >= -1 && lines(k).theta<=1
        xy = [lines(k).point1; lines(k).point2];
        plot(xy(:,1),xy(:,2),'LineWidth',1,'Color','b');
        x=[x ; lines(k).point1(1); lines(k).point2(1) ];
        y=[y ; lines(k).point1(2); lines(k).point2(2) ];
        
    elseif lines(k).theta > -92 && lines(k).theta<-88
        xy = [lines(k).point1; lines(k).point2];
        plot(xy(:,1),xy(:,2),'LineWidth',1,'Color','b');
        x=[x ; lines(k).point1(1); lines(k).point2(1) ];
        y=[y ; lines(k).point1(2); lines(k).point2(2) ];
    end
    
end
try
    %x=(max(x)+min(x))/2;
    x=max(x);
    y=max(y);
catch
    try
        x=max(x);
        y=max(y);
    catch
        for k = 1:length(lines)
            if lines(k).theta >= -5 && lines(k).theta<=5
                xy = [lines(k).point1; lines(k).point2];
                plot(xy(:,1),xy(:,2),'LineWidth',1,'Color','b');
                x=[x ; lines(k).point1(1); lines(k).point2(1) ];
                y=[y ; lines(k).point1(2); lines(k).point2(2) ];
            elseif lines(k).theta > -95 && lines(k).theta<-85
                xy = [lines(k).point1; lines(k).point2];
                plot(xy(:,1),xy(:,2),'LineWidth',1,'Color','b');
                x=[x ; lines(k).point1(1); lines(k).point2(1) ];
                y=[y ; lines(k).point1(2); lines(k).point2(2) ];
            end
            x=max(x);
            y=max(y);
        end
    end
end
end