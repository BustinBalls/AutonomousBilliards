function [robotSend]=ClusterFuck()
clear all
clc
close all
%%
%intialize  Variables
global Shots img ballDiam pocket color ballRad xCrop yCrop ballScrewBack arduinoUno
Directory2Zip='C://Users/ryanl/Downloads/Senior_Project_kyle/Senior_Project/MatlabBilliards';%directory to this  Zip
mm2pixel=1/1.4992;
pixel2mm=1.4992;
ballDiam=58*mm2pixel;
bumper_w=68*mm2pixel;
ballRad = ballDiam/2;
%color matrix
color = {[0 0 0];[1 0 0];[0.4660 0.6740 0.1880];[0 0 1];[0.8500 0.3250 0.0980];[1 0 1]};

try
    arduinoUno=arduino('COM8','uno');
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

%%
%getImage()
%Tries to get image from raspi if fails will catch by asking for image name
%to load in as img.
try
    rasp = raspi('10.100.114.59','pi','SeniorProject');
    cam = cameraboard(rasp,'Resolution','1280x720','Quality',100,...
        'Brightness',55,'Contrast', 0,'Saturation',0,'Sharpness',0);
    img = snapshot(cam);%capture image
    %imgSave=input('Save Image? (y/n): ','s');
    %if imgSave== 'y'
    %    rando=sum(sum(rand(3)));
    %    imwrite(img,[Directory2Zip '/Photos/img(' num2str(rando) ').png'])
    %end
catch
    
    %restOfString=input('Enter photo extension after <Directory2Zip>/Photos/','s');
    path2Photo=[Directory2Zip '/Photos/' 'img(5.2737).png']; %Short cut for debugging
    %path2Photo=[Directory2Zip '/Photos/' restOfString];
    img = imread(path2Photo);
end
%will try to undistort photo using cameraParams, if no cameraParams in
%workspace, will load photos and run camera callibration
try
    %loaded image is already undistorted so its commented out
    img = undistortImage(img,cameraParams);
catch
    %this will calc cameraParams if not defined
    for i=1:40
        if (i<10)
            imageFileNames{i}=[Directory2Zip '/Photos/image_000'  num2str(i) '.png'];
        else
            imageFileNames{i}=[Directory2Zip '/Photos/image_00'  num2str(i) '.png'];
        end
    end
    % Detect checkerboards in images
    [imagePoints, boardSize, imagesUsed] = detectCheckerboardPoints(imageFileNames);
    imageFileNames = imageFileNames(imagesUsed);
    % Read the first image to obtain image size
    originalImage = imread(imageFileNames{1});
    [mrows, ncols, ~] = size(originalImage);
    % Generate world coordinates of the corners of the squares
    squareSize = 22;  % in units of 'millimeters'
    worldPoints = generateCheckerboardPoints(boardSize, squareSize);
    % Calibrate the camera
    [cameraParamsOut, imagesUsed, estimationErrors] = estimateCameraParameters(imagePoints, worldPoints, ...
        'EstimateSkew', false, 'EstimateTangentialDistortion', false, ...
        'NumRadialDistortionCoefficients', 2, 'WorldUnits', 'millimeters', ...
        'InitialIntrinsicMatrix', [], 'InitialRadialDistortion', [], ...
        'ImageSize', [mrows, ncols]);
    cameraParams = cameraParamsOut;
    img = undistortImage(img,cameraParams);
end
%Displays OG image
figure('Name','Original Image','NumberTitle','off');
imshow(img);
%%
%dotDetection()
%{
the below loop was created just to be able to shrink, all it does is apply
%local mask to image to detect dots
%}
for hide=1:1
    % Convert img image into L*a*b* color space.
    X = rgb2lab(img);
    % Create empty mask.
    BW = false(size(X,1),size(X,2));
    % Local graph cut
    xPos = [55.8573 1231.2692 1231.2692 55.8573 ];
    yPos = [43.4538 43.4538 666.6060 666.6060 ];
    m = size(BW, 1);
    n = size(BW, 2);
    ROI = poly2mask(xPos,yPos,m,n);
    foregroundInd = [];
    backgroundInd = [];
    L = superpixels(X,4708,'IsInputLab',true);
    % Convert L*a*b* range to [0 1]
    scaledX = prepLab(X);
    BW = BW | grabcut(scaledX,L,ROI,foregroundInd,backgroundInd);
    % Local graph cut
    xPos = [0.5000 163.0709 163.0709 0.5000 ];
    yPos = [0.5000 0.5000 140.6026 140.6026 ];
    m = size(BW, 1);
    n = size(BW, 2);
    ROI = poly2mask(xPos,yPos,m,n);
    foregroundInd = [];
    backgroundInd = [];
    L = superpixels(X,4708,'IsInputLab',true);
    % Convert L*a*b* range to [0 1]
    scaledX = prepLab(X);
    BW = BW | grabcut(scaledX,L,ROI,foregroundInd,backgroundInd);
    % Local graph cut
    xPos = [582.7359 700.4521 700.4521 582.7359 ];
    yPos = [0.5000 0.5000 115.2214 115.2214 ];
    m = size(BW, 1);
    n = size(BW, 2);
    ROI = poly2mask(xPos,yPos,m,n);
    foregroundInd = [];
    backgroundInd = [];
    L = superpixels(X,4708,'IsInputLab',true);
    % Convert L*a*b* range to [0 1]
    scaledX = prepLab(X);
    BW = BW | grabcut(scaledX,L,ROI,foregroundInd,backgroundInd);
    % Local graph cut
    xPos = [1114.4282 1280.2812 1280.2812 1114.4282 ];
    yPos = [0.5000 0.5000 131.8504 131.8504 ];
    m = size(BW, 1);
    n = size(BW, 2);
    ROI = poly2mask(xPos,yPos,m,n);
    foregroundInd = [];
    backgroundInd = [];
    L = superpixels(X,4708,'IsInputLab',true);
    % Convert L*a*b* range to [0 1]
    scaledX = prepLab(X);
    BW = BW | grabcut(scaledX,L,ROI,foregroundInd,backgroundInd);
    % Local graph cut
    xPos = [1132.8077 1280.2812 1280.2812 1132.8077 ];
    yPos = [570.3325 570.3325 720.5000 720.5000 ];
    m = size(BW, 1);
    n = size(BW, 2);
    ROI = poly2mask(xPos,yPos,m,n);
    foregroundInd = [841624 841655 841656 841658 841659 850975 858900 861060 866820 874017 878282 882653 884092 885530 886230 886231 886232 886234 886236 886240 886245 886950 887661 887670 888381 888382 888383 888384 888385 888387 888388 888389 ];
    backgroundInd = [];
    L = superpixels(X,4708,'IsInputLab',true);
    % Convert L*a*b* range to [0 1]
    scaledX = prepLab(X);
    BW = BW | grabcut(scaledX,L,ROI,foregroundInd,backgroundInd);
    % Local graph cut
    xPos = [581.4231 702.6402 702.6402 581.4231 ];
    yPos = [582.5855 582.5855 720.5000 720.5000 ];
    m = size(BW, 1);
    n = size(BW, 2);
    ROI = poly2mask(xPos,yPos,m,n);
    foregroundInd = [428334 429774 430494 434817 436258 436979 438421 440583 444185 444905 446349 447066 447786 450667 454987 459308 463628 465068 466508 468668 470828 471548 473707 475865 478023 478742 479462 480181 480901 481620 483779 485219 ];
    backgroundInd = [];
    L = superpixels(X,4708,'IsInputLab',true);
    % Convert L*a*b* range to [0 1]
    scaledX = prepLab(X);
    BW = BW | grabcut(scaledX,L,ROI,foregroundInd,backgroundInd);
    % Local graph cut
    xPos = [0.5000 144.6915 144.6915 0.5000 ];
    yPos = [573.3957 573.3957 720.5000 720.5000 ];
    m = size(BW, 1);
    n = size(BW, 2);
    ROI = poly2mask(xPos,yPos,m,n);
    foregroundInd = [17980 21586 25822 25823 25832 25833 25835 26538 30842 40194 41686 41691 41695 43081 43138 43139 45307 46748 49626 53222 56099 58258 58978 60417 61857 64016 65456 66896 71937 76977 78417 79857 80577 87053 ];
    backgroundInd = [];
    L = superpixels(X,4708,'IsInputLab',true);
    % Convert L*a*b* range to [0 1]
    scaledX = prepLab(X);
    BW = BW | grabcut(scaledX,L,ROI,foregroundInd,backgroundInd);
    % Flood fill
    row = 665;
    column = 271;
    tolerance = 5.000000e-02;
    normX = sum((X - X(row,column,:)).^2,3);
    normX = mat2gray(normX);
    addedRegion = grayconnected(normX, row, column, tolerance);
    BW = BW | addedRegion;
    % Flood fill
    row = 8;
    column = 169;
    tolerance = 5.000000e-02;
    normX = sum((X - X(row,column,:)).^2,3);
    normX = mat2gray(normX);
    addedRegion = grayconnected(normX, row, column, tolerance);
    BW = BW | addedRegion;
    % Invert mask
    BW = imcomplement(BW);
    % Create masked image.
    maskedImage = img;
    maskedImage(repmat(~BW,[1 1 3])) = 0;
end
%masked image to grey for edge detection
grey=rgb2gray(maskedImage);
%values to detect dots
[cDot, r] = imfindcircles(grey,[2 6],'Sensitivity', 0.9, 'EdgeThreshold', 0.5);
%shows all circles detected
viscircles(cDot, r,'Color','b');
L=[];
R=[];
T=[];
B=[];
%fills arrays L R T B according to dot location on table
for i=1:length(cDot)
    if cDot(i,1) <= 100
        %left side
        L=[L,;cDot(i,1)];
    elseif cDot(i,1) >= 1200
        %Right side
        R=[R,;cDot(i,1)];
    else
        if cDot(i,2)<= 100
            %top
            T=[T,cDot(i,2)];
        elseif cDot(i,2)>= 600
            %Bottom
            B=[B,cDot(i,2)];
        end
    end
end
%while the values in T differs by more than 7 pixels will apply a rotation to
%level out table before crop occurs
%%%%want to apply a form of std deviation to get more accurate roation
tDotDeviation=max(T)-mean(T);
disp(['tmax-tmean: ' num2str(tDotDeviation)]);


%{
while tDotDeviation>20 
    xT=[cDot(find(cDot(:,2)==min(T),5),1),cDot(find(cDot(:,2)==max(T),5),1)];
    yT=[cDot(find(cDot(:,2)==min(T),5),2),cDot(find(cDot(:,2)==max(T),5),2)];
    %Finds the slope of T and takes the arctan to find angle
    RotTable=atand((xT(2)-xT(1))/(yT(2)-yT(1)));
    if RotTable>0
        RotTable=90-RotTable;
        %Rotates the grey image so you dont have to apply mask again
    else
        RotTable=RotTable+90;
    end
    
    grey=imrotate(grey,RotTable);
    imshow(imrotate(grey,RotTable));
    img=imrotate(img,RotTable);
    

%after roation, new dots are found
[cDot] = imfindcircles(grey,[2 6],'Sensitivity', 0.9, 'EdgeThreshold', 0.5);
%and values are reset
L=[];
R=[];
T=[];
B=[];

%series of try commands to use maximum amount of dots, deemed un-reliable
%data if less than 14 dots found tried to do with for loop
%{
try
    cSelect = cDot(1:18,:);
catch
    %after first catch should apply a length(cc) to get length and if
    %greater than 14 continue should save a couple seconds
    try
        cSelect = cDot(1:17,:);
    catch
        try
            cSelect = cDot(1:16,:);
        catch
            try
                cSelect = cDot(1:15,:);
            catch
                try
                    cSelect = cDot(1:14,:);
                catch
                    cSelect = cDot(1:13,:);
                end
                
            end
        end
    end
end
%}
%fills arrays L R T B according to dot location on table
for i=1:length(cDot)
    %18 is max dots capable of being detected
    if i<=18
        if cDot(i,1) <= 100
            %left side
            L=[L,;cDot(i,1)];
        elseif cDot(i,1) >= 1200
            %Right side
            R=[R,;cDot(i,1)];
        else
            if cDot(i,2)<= 100
                %top
                T=[T,cDot(i,2)];
            elseif cDot(i,2)>= 600
                %Bottom
                B=[B,cDot(i,2)];
            end
        end
    else
        break
    end
end
tDotDeviation=max(T)-mean(T);
end
%}
%averages the values which will define the perimeter of the crop
T=sum(T)/length(T);
B=sum(B)/length(B);
R=sum(R)/length(R);
L=sum(L)/length(L);

%%
%DrawTableFeatures()
%applys crop to the rotated image then gets pocket location, pocket numbers
%start at 1 with top left hole facing robot, and increase clockwise
CroppedTable=[L+bumper_w T+bumper_w R-L-bumper_w*2 B-T-bumper_w*2];
img=imcrop(img,CroppedTable);
imshow(img)
[yCrop,xCrop]=size(rgb2gray(img));
%Pocket     (1)Top Left       (2)Top Mid           (3)Top Right           (4)Bot Right                 (5)Bot Mid               (6)Bot Left
pocket =    [ballRad ballRad; (xCrop)/2 ballRad;   xCrop-ballRad ballRad; xCrop-ballRad yCrop-ballRad; (xCrop)/2 yCrop-ballRad; ballRad yCrop-ballRad];
%{
%%%used in DrawShot()
%Top line for ball offset
line([ballRad,ballRad],[ballRad ,yCrop-ballRad],'Color', 'w','LineWidth', 1);
%Right line for ball offset
line([xCrop-ballRad,xCrop-ballRad],[ballRad ,yCrop-ballRad],'Color', 'w','LineWidth', 1);
%Bottom line for ball offset
line([ballRad,xCrop-ballRad],[ballRad ,ballRad],'Color', 'w','LineWidth', 1);
%Left line for ball offset
line([ballRad,xCrop-ballRad],[yCrop-ballRad ,yCrop-ballRad],'Color', 'w','LineWidth', 1);

%}
%draws circles around holes with respective colors
for i=1:6
    viscircles(pocket(i,:), ballDiam, 'Color', color{i}, 'LineStyle', '--');
end
%%
%possibleShots()
[cBall,r] = imfindcircles(img,[15 23],'Sensitivity', .9, 'EdgeThreshold', .2);
viscircles(cBall, r,'Color','b');
%crops image to top right 1/10 of original size starting at origin to identify cue location
[imgX,imgY]=size(rgb2gray(img));
cueCrop=imcrop(img,[0,0,.1*imgX,.1*imgY]);
%calls function Cue Tip to get local Position of pool stick tip
[CueX,CueY] = CueTip(cueCrop);
%debugger
disp(['Cue tip max position: (' num2str(CueX) ',' num2str(CueY) ')'])
%creates Cell with 14 cols and rows dependent on amount of balls detected
Ball{length(cBall),14}=[];
%used inside loop to
count=1;
i=1;
%The beef of the calculations,
while isempty(cBall)==0
    if i==1
        %Ball number
        Ball{i,1}=i;
        %set que at this position by calling identi_que()
        %Ball[x,y]
        [Ball{i,2},Ball{i,3}]=identi_que(img);
        img=insertText(img,[Ball{i,2}-ballRad,Ball{i,3}-ballRad],'cue','FontSize',18,'TextColor','black','BoxOpacity',0);
        index_x= find(round(Ball{i,2})<(round(cBall(:,1))+30) & (round(Ball{i,2})>(round(cBall(:,1))-30)),1);
        index_y= find(round(Ball{i,3})<(round(cBall(:,2))+30) & (round(Ball{i,3})>(round(cBall(:,2))-30)),1);
        disp(['cueBall index in cBall: (' num2str(CueX) ',' num2str(CueY) ')'])
        if index_y==index_x
            cBall(index_x,:)=[];
        end
        Ball{i,4} = [0 0 0 0 0 0];
        Ball{i,5} = [0 0 0 0 0 0];
        Ball{i,6} = [0 0 0 0 0 0];
        Ball{i,7} = [0 0 0 0 0 0];
        Ball{i,8} = [0 0 0 0 0 0];
        Ball{i,9} = [0 0 0 0 0 0];
        Ball{i,10} = [0 0 0 0 0 0];
        Ball{i,11} = [0 0 0 0 0 0];
        Ball{i,12} = [0 0 0 0 0 0];
        Ball{i,13} = [0 0 0 0 0 0];
        Ball{i,14} = [0 0 0 0 0 0];
        %%
        %determines cue ball quadrent and assigns angle A only has
        %to be computed once
        if Ball{1,2} > imgX/2
            %CueBall is on right side
            if Ball{1,3} > imgY/2 %
                %%
                %CueBall is in Bottom Right
                if (pocket(4,1)-Ball{1,2}<75*mm2pixel || pocket(4,2)-Ball{1,3}<75*mm2pixel)
                    %checks if que ball is within 75 mm of wall
                    A=30;
                    rotWeight=5;
                elseif (pocket(4,1)-Ball{1,2}<150*mm2pixel || pocket(4,2)-Ball{1,3}<150*mm2pixel)
                    %checks if que ball is within 150 mm of wall
                    A=20;
                    rotWeight=2;
                else
                    A=15;
                    rotWeight=1;
                end
                
            elseif Ball{1,3} <= imgY/2
                %%
                %CueBall is in Top Right
                if (pocket(3,1)-Ball{1,2}<75*mm2pixel || pocket(3,2)-Ball{1,3}>-75*mm2pixel)
                    %checks if que ball is within 75 mm of wall
                    A=30;
                    rotWeight=5;
                elseif (pocket(3,1)-Ball{1,2}<150*mm2pixel || pocket(3,2)-Ball{1,3}>-150*mm2pixel)
                    %checks if que ball is within 150 mm of wall
                    A=20;
                    rotWeight=2;
                else
                    A=15;
                    rotWeight=1;
                end
            end
        elseif Ball{1,2} <= imgX/2
            %CueBall on Left side
            if Ball{1,3} > imgY/2 
                %%
                %CueBall is in Bottom Left
                if (pocket(6,1)-Ball{1,2}>-75*mm2pixel || pocket(6,2)-Ball{1,3}<75*mm2pixel)
                    %checks if que ball is within 75 mm of wall
                    A=30;
                    rotWeight=5;
                elseif (pocket(6,1)-Ball{1,2}>-150*mm2pixel || pocket(6,2)-Ball{1,3}<150*mm2pixel)
                    %checks if que ball is within 150 mm of wall
                    A=20;
                    rotWeight=2;
                else
                    A=15;
                    rotWeight=1;
                end
                
            elseif Ball{1,3} <= imgY/2
                %CueBall is in Top Left
                %%
                if (pocket(1,1)-Ball{1,2}>-75*mm2pixel || pocket(1,2)-Ball{1,3}>-75*mm2pixel)
                    %checks if que ball is within 75 mm of wall
                    A=30;
                    rotWeight=5;
                elseif (pocket(1,1)-Ball{1,2}>-150*mm2pixel || pocket(1,2)-Ball{1,3}>-150*mm2pixel)
                    %checks if que ball is within 150 mm of wall
                    A=20;
                    rotWeight=2;
                else
                    A=15;
                    rotWeight=1;
                end
            end
        end
        Z=90;%for now z is to remain constant
        Ts=90;
    else
        %Ball number
        Ball{i,1}=i;
        %Ball x
        Ball{i,2}=cBall(1,1);
        %Ball y
        Ball{i,3}=cBall(1,2);
        %writes text on img labeling Ball
        img=insertText(img,[Ball{i,2}-ballRad,Ball{i,3}-ballRad],num2str(Ball{i,1}),'FontSize',18,'TextColor','black','BoxOpacity',0);
        %Deletes ball identification form array cBall so no dbl counting a ball
        cBall(1,:)=[];
        %Loops 6 times for every pocket
        %so everyball gets data for each pocket
        for j = 1:6
            %%
            %section getting ball Parameters
            %%%%%%targeBall ==> Pocket
            %mag
            Ball{i,4} = [Ball{i,4} sqrt((Ball{i,2}-pocket(j,1))^2+(Ball{i,3}-pocket(j,2))^2)];
            %unitvector targeBall===>Pocket
            Ball{i,5} = [Ball{i,5}  (pocket(j,1)-Ball{i,2})/Ball{i,4}(j)];%vectx
            Ball{i,6} = [Ball{i,6}  (pocket(j,2)-Ball{i,3})/Ball{i,4}(j)];%vecty
            %%%%%%ghostBall x;y
            Ball{i,7} = [Ball{i,7}  Ball{i,2}-ballDiam*Ball{i,5}(j)];
            Ball{i,8} = [Ball{i,8}  Ball{i,3}-ballDiam*Ball{i,6}(j)];
            %%%%%%cue ===>targetBall
            %mag
            Ball{i,9} = [Ball{i,9}  sqrt((Ball{i,7}(j)-Ball{1,2})^2+(Ball{i,8}(j)-Ball{1,3})^2)]; %distance cue Ball travel
            %unitvector
            Ball{i,10} = [Ball{i,10}  (Ball{i,7}(j)-Ball{1,2})/(Ball{i,9}(j))]; %distance cue Ball travelx
            Ball{i,11} = [Ball{i,11}  (Ball{i,8}(j)-Ball{1,3})/(Ball{i,9}(j))]; %distance cue Ball travely
            %angle phi, the rotaion of cueBall_mag onto targetBall===>pocket mag
            Ball{i,12} = [Ball{i,12}  acosd(dot([Ball{i,10}(j) Ball{i,11}(j)],[Ball{i,5}(j) Ball{i,6}(j)]))];
            %%
%%%%%%%%%%%%%%%%%%%SECTION DETERMING if shot is possible%%%%%%%%%%%%%%%%%%%
%and utilizes loop of targetball location to apply weight
%{
            Need to add a section checking for other collisions, Im
            thinking create a copy of image as pathDetection.png, where
            there is an item apply a mask setting those pixel values to 0
            and checking possible shot we can check pixel values of
            img==pathDetection.png along path at width of ballDiam.
%}
            targetBall2wallWeight=[];
            %test if each shot if phi is less than 85 deg
            if Ball{i,12}(j)<65
                %next will test if GhostBall will exceed boundries of table since object is abritary
                if Ball{i,7}(j) > imgX/2
                    %TargetBall is on right side
                    if Ball{i,8}(j) > imgY/2 %
                        %%
                        %TargetBall is in Bottom Right
                        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        if pocket(4,1)-Ball{i,7}(j)<50 
                            %checks if TargetBall is within 50 mm of wall
                            targetBall2wallWeight=targetBall2wallWeight+abs(pocket(4,1)-Ball{i,7}(j))/5;%sum of x and y distance from wall added max==100 then /10 so max multi ==10
                        else
                            targetBall2wallWeight=targetBall2wallWeight+1;
                        end
                        if  pocket(4,2)-Ball{1,8}(j)<50
                            targetBall2wallWeight=targetBall2wallWeight+abs(pocket(4,2)-Ball{1,8}(j))/5;
                        else
                            targetBall2wallWeight=targetBall2wallWeight+1;
                        end
                        targetBall2wallWeight=targetBall2wallWeight/2;
                        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        if (Ball{i,7}(j)>pocket(4,1)||Ball{i,8}(j)>pocket(4,2))
                            Ball{i,13}=[Ball{i,13} 0];%shotpossible==FALSE
                        else
                            Ball{i,13}=[Ball{i,13} 1];%not eliminated yet
                        end
                    elseif Ball{i,8}(j) <= imgY/2
                        %%
                        %TargetBall is in Top Right
                        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        if pocket(3,1)-Ball{i,7}(j)<50 
                            %checks if TargetBall is within 50 mm of wall
                            targetBall2wallWeight=targetBall2wallWeight+abs(pocket(3,1)-Ball{i,7}(j))/5;%sum of x and y distance from wall added max==100 then /10 so max multi ==10
                        else
                            targetBall2wallWeight=targetBall2wallWeight+1;
                        end
                        if  pocket(3,2)-Ball{1,8}(j)>-50
                            targetBall2wallWeight=targetBall2wallWeight+abs(pocket(3,2)-Ball{1,8}(j))/5;
                        else
                            targetBall2wallWeight=targetBall2wallWeight+1;
                        end
                        targetBall2wallWeight=targetBall2wallWeight/2;
                        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        if (Ball{i,7}(j)>pocket(3,1)||Ball{i,8}(j)<pocket(3,2))
                            Ball{i,13}=[Ball{i,13} 0];%shotpossible==FALSE
                        else
                            Ball{i,13}=[Ball{i,13} 1];%not eliminated yet
                        end
                    end
                elseif Ball{i,7}(j) <= imgX/2
                   
                    %TargetBall is on Left side
                    if Ball{i,8}(j) > imgY/2 %
                        %%
                        %TargetBall is in Bottom Left
                        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        if pocket(6,1)-Ball{i,7}(j)>-50 
                            %checks if TargetBall is within 50 mm of wall
                            targetBall2wallWeight=targetBall2wallWeight+abs(pocket(6,1)-Ball{i,7}(j))/5;%sum of x and y distance from wall added max==100 then /10 so max multi ==10
                        else
                            targetBall2wallWeight=targetBall2wallWeight+1;
                        end
                        if  pocket(6,2)-Ball{1,8}(j)<50
                            targetBall2wallWeight=targetBall2wallWeight+abs(pocket(6,2)-Ball{1,8}(j))/5;
                        else
                            targetBall2wallWeight=targetBall2wallWeight+1;
                        end
                        targetBall2wallWeight=targetBall2wallWeight/2;
                        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        if (Ball{i,7}(j)<pocket(6,1)||Ball{i,8}(j)>pocket(6,2))
                            Ball{i,13}=[Ball{i,13} 0];%shotpossible==FALSE
                        else
                            Ball{i,13}=[Ball{i,13} 1];%not eliminated yet
                        end
                    elseif Ball{i,8}(j) <= imgY/2
                        %TargetBall is in Top Left
                        %%
                        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        if pocket(1,1)-Ball{i,7}(j)>-50 
                            %checks if TargetBall is within 50 mm of wall
                            targetBall2wallWeight=targetBall2wallWeight+abs(pocket(1,1)-Ball{i,7}(j))/5;%sum of x and y distance from wall added max==100 then /10 so max multi ==10
                        else
                            targetBall2wallWeight=targetBall2wallWeight+1;
                        end
                        if  pocket(1,2)-Ball{1,8}(j)>-50
                            targetBall2wallWeight=targetBall2wallWeight+abs(pocket(1,2)-Ball{1,8}(j))/5;
                        else
                            targetBall2wallWeight=targetBall2wallWeight+1;
                        end
                        targetBall2wallWeight=targetBall2wallWeight/2;
                        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        if (Ball{i,7}(j)<pocket(1,1)||Ball{i,8}(j)<pocket(1,2))
                            Ball{i,13}=[Ball{i,13} 0];%shotpossible==FALSE
                        else
                            Ball{i,13}=[Ball{i,13} 1];%not eliminated yet
                        end
                    end
                end
            else
                Ball{i,13}=[Ball{i,13} 0];%false by phi being greater than 85
            end
            %%%gets XYZOAT's to send to robot
            %{
            Need to add angle adjustment, if que ball is close to wall
            increase up to 30 deg if by other balls 20 etc
            %}
            
            
            if Ball{i,13}(j)==1
                X=(round((Ball{1,2}-CueX)*pixel2mm+30-6.275,2));
                Y=(round((Ball{1,3}-CueY)*pixel2mm+30,2));
                
                GG=@(AA,BB) [dot(AA,BB) -norm(cross(AA,BB)) 0 ;norm(cross(AA,BB)) dot(AA,BB) 0 ; 0 0 1];
                FFi = @(AA,BB) [ AA (BB-dot(AA,BB)*AA)/norm(BB-dot(AA,BB)*AA) cross(BB,AA) ];
                UU = @(Fi,G) Fi*G*inv(Fi);
                aa=[-1 0 0]';bb=[Ball{i,10}(j) Ball{i,11}(j) 0]';
                U = UU(FFi(aa,bb), GG(aa,bb));
                O=round(tr2eul(U)*(180/pi),2);
                O=O(3);
                %will eliminate joint lock
                %if O<90 && O>0
                    %it actually accomplished nothing
                %    A=-(A);
                %    Ts=-(Ts);
                %    aa=[1 0 0]';bb=[Ball{i,10}(j) Ball{i,11}(j) 0]';
                %    U = UU(FFi(aa,bb), GG(aa,bb));
                %    O=round(tr2eul(U)*(180/pi),2);
                %    O=O(3);
                %else
                A=abs(A);
                Ts=abs(Ts);
                
                disp([num2str(X) ' ' num2str(Y) ' ' num2str(Z) ' ' num2str(O) ' ' num2str(A) ' ' num2str(Ts)])
                Shots{count,1}=[num2str(X) ' ' num2str(Y) ' ' num2str(Z) ' ' num2str(O) ' ' num2str(A) ' ' num2str(Ts)];
                %%
                %Draws on image
                
                %{
                %%%%%%%%%For Debugging shot angle syncing camera and robot
                %input('Enter to continue and get image')
                %imgChecker=[];
                %while isempty(imgChecker)==1
                    %figure(10);
                    %imgCheck = snapshot(cam);%capture image
                    %imshow(imgCheck)
                    %imgChecker=input("check img");
                %end
                %imgCheck = snapshot(cam);%capture image
                %figure('Name',['MASTER ' num2str(X) ' ' num2str(Y) ' ' num2str(Z) ' ' num2str(O) ' ' num2str(A) ' ' num2str(Ts)],'NumberTitle','off');
                %imgCheck=undistortImage(imgCheck,cameraParams);
                %imgCheck = imrotate(imgCheck,RotTable);
                %imgCheck = imcrop(imgCheck,CroppedTable);
                %imshow(imgCheck);axis on;
                %}
                
                %possibleShots saves info to be able to draw lines and
                %provides rank and robot instrunctions
                %ADD Rank IF within distance from wall %DONE FOR CUE NOW
                %Target ball
 
                DistanceBeforeCollision=sqrt(abs(Ball{1,2}-Ball{i,7}(j))^2+abs(Ball{1,3}-Ball{i,8}(j))^2);
                DistanceAfterCollision=sqrt(abs(pocket(j,1)-Ball{i,2})^2+abs(pocket(j,2)-Ball{i,3})^2);
                Shots{count,10}=(Ball{i,12}(j)*6)+(DistanceAfterCollision*.5)+(DistanceBeforeCollision*.1)*rotWeight;%rank
                %rotWeight determines cue balls relativity to wall
                %within 75mm of wall *5
                %within 150mm of wall *2
                %other, *1
                
                Shots{count,2}=[Ball{1,2},Ball{i,7}(j)];
                Shots{count,3}=[Ball{1,3},Ball{i,8}(j)];
                Shots{count,4}=[Ball{i,7}(j), Ball{i,8}(j)];
                Shots{count,5}=[pocket(j,1),Ball{i,2}];
                Shots{count,6}=[pocket(j,2),Ball{i,3}];
                Shots{count,7}=[Ball{i,2},Ball{i,7}(j)];
                Shots{count,8}=[Ball{i,3},Ball{i,8}(j)];
                Shots{count,9}=color{j};
                
                count=count+1;
            end
        end
    end
    i=i+1;
end
Shots=cell2table(Shots);
Shots.Properties.VariableNames={'XYZOATs','Draw1_1','Draw1_2','Draw2_1','Draw3_1','Draw3_2','Draw4_1','Draw4_2','Color','Rank'};
Ball=cell2table(Ball);
Ball.Properties.VariableNames={'Num','X','Y','TargetBall2Pocket_mag','TargetBall2Pocket_UnitX','TargetBall2Pocket_UnitY','GhostBall_x','GhostBall_y','CueBall2TargetBall_mag','CueBall2TargetBall_UnitX','CueBall2TargetBall_UnitY','Phi','Possible','Rank'};
%%
%onto ranking the fucking things and drawing
rankedShots=sort(Shots.Rank(:));
%Display them all
%for i=1:length(rankedShots)
    %analyze Rank and displays shot easiest==>hardest
    %Commented out for auto send
%    DrawShot(find(Shots.Rank(:)==rankedShots(i)));
    %robotSend=input('Send errrr? (y/n): ','s');
    
%end
%comment in for 
robotSend=DrawShot(find(Shots.Rank(:)==rankedShots(1)));
%robotSend=Shots.XYZOATs{1};
ballScrewBack=150;
clear rasp arduinoUno cam
end%this ends function


%%
%Additional Functions appplied more than once so caled to in order to save some space
%called to get max (x,y) of cue stick tip
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
%called for masking
function out = prepLab(in)

% Convert L*a*b* image to range [0,1]
% Convert L*a*b* image to range [0,1]
out = in;
out(:,:,1) = in(:,:,1) / 100;  % L range is [0 100].
out(:,:,2) = (in(:,:,2) + 86.1827) / 184.4170;  % a* range is [-86.1827,98.2343].
out(:,:,3) = (in(:,:,3) + 107.8602) / 202.3382;  % b* range is [-107.8602,94.4780].

end
%just recomend not opening this one... ever...
function [center_x,center_y] = identi_que(img)
try
    % Convert RGB image to chosen color space
    I = rgb2lab(img);
    
    % Define thresholds for channel 1 based on histogram settings
    channel1Min = 50.271;
    channel1Max = 94.043;
    
    % Define thresholds for channel 2 based on histogram settings
    channel2Min = -18.303;
    channel2Max = 6.299;
    
    % Define thresholds for channel 3 based on histogram settings
    channel3Min = -8.918;
    channel3Max = 51.470;
    
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
end
viscircles(c(1,:), r(1),'Color',[0.8500 0.3250 0.0980],'LineWidth',3,'LineStyle',':');
center_x=cSelect(1);
center_y=cSelect(2);
end
%Function that handles all drawings of shots
function [robotNextShot]=DrawShot(shotNum)
global Shots img ballDiam pocket color ballRad xCrop yCrop

%Top line for ball offset
line([ballRad,ballRad],[ballRad ,yCrop-ballRad],'Color', 'w','LineWidth', 1);
%Right line for ball offset
line([xCrop-ballRad,xCrop-ballRad],[ballRad ,yCrop-ballRad],'Color', 'w','LineWidth', 1);
%Bottom line for ball offset
line([ballRad,xCrop-ballRad],[ballRad ,ballRad],'Color', 'w','LineWidth', 1);
%Left line for ball offset
line([ballRad,xCrop-ballRad],[yCrop-ballRad ,yCrop-ballRad],'Color', 'w','LineWidth', 1);
%{
%EXAMPle IF USED befor defined as table
%draws line from cueCenter [x,y] to center of ghostball[x,y]
figure('Name','Shot{enter number or Rank?}','NumberTitle','off');
imshow(img),title(Shots{shotNum,1});
line(Shots{shotNum,2},Shots{shotNum,3},'Color',Shots{shotNum,9},'LineWidth',2); %line from cue to target cue center
%draws circle for ghostball
viscircles(Shots{shotNum,4} , ballDiam/2, 'Color', Shots{shotNum,9}, 'LineStyle', '--');
%draws line from Targetball[x,y] to PocketCenter(j)[x,y]
line(Shots{shotNum,5}, Shots{shotNum,6},'Color', Shots{shotNum,9},'LineWidth',2); %draw pocket to target Ball center line
%draws line from ghostball[x,y] to TargetBall Center[x,y]
line(Shots{shotNum,7},Shots{shotNum,8},'Color',Shots{shotNum,9},'LineWidth',2); %line add behind target direction
%}
%draws line from cueCenter [x,y] to center of ghostball[x,y]
figure('Name',['Shot Rank ' num2str(Shots.Rank(shotNum,:))],'NumberTitle','off');
imshow(img),title(Shots.XYZOATs(shotNum,:));
%%
%Draws TableFeatures
%Top line for ball offset
line([ballRad,ballRad],[ballRad ,yCrop-ballRad],'Color', 'w','LineWidth', 1);
%Right line for ball offset
line([xCrop-ballRad,xCrop-ballRad],[ballRad ,yCrop-ballRad],'Color', 'w','LineWidth', 1);
%Bottom line for ball offset
line([ballRad,xCrop-ballRad],[ballRad ,ballRad],'Color', 'w','LineWidth', 1);
%Left line for ball offset
line([ballRad,xCrop-ballRad],[yCrop-ballRad ,yCrop-ballRad],'Color', 'w','LineWidth', 1);
%draws circles around holes with respective colors
for i=1:6
    viscircles(pocket(i,:), ballDiam, 'Color', color{i}, 'LineStyle', '-.');
end
%%
%Draws ShotFeatures
%line from cue to target cue center
line(Shots.Draw1_1(shotNum,:),Shots.Draw1_2(shotNum,:),'Color',Shots.Color(shotNum,:),'LineWidth',2); 
%Draws circle for ghostball
viscircles(Shots.Draw2_1(shotNum,:) , ballDiam/2, 'Color', Shots.Color(shotNum,:), 'LineStyle', '-.');
%Draws line from Targetball[x,y] to PocketCenter(j)[x,y]
line(Shots.Draw3_1(shotNum,:), Shots.Draw3_2(shotNum,:),'Color', Shots.Color(shotNum,:),'LineWidth',2); 
%draws line from ghostball[x,y] to TargetBall Center[x,y]
line(Shots.Draw4_1(shotNum,:),Shots.Draw4_2(shotNum,:),'Color',Shots.Color(shotNum,:),'LineWidth',2); 
robotNextShot=Shots.XYZOATs{shotNum,:};
end