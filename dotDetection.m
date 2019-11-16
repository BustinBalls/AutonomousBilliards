function [TopLine,BottomLine,RightLine,LeftLine]=dotDetection(img)
global img RotTable
%----------------------------------------------------
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
%masked image to grey for edge detection
grey=rgb2gray(maskedImage);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%NEED to find pixel Ratio determind on img size%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[cDot, r, m] = imfindcircles(grey,[2 6],'Sensitivity', 0.9, 'EdgeThreshold', 0.5);
%shows all circles detected
viscircles(cDot, r,'Color','b');
%shows circles used
%viscircles(cSelect, rSelect,'Color','r','LineStyle','--');
%used to create averages
L=[];
R=[];
T=[];
B=[];
for i=1:length(cDot)
    if cDot(i,2)<= 100
        %top
        T=[T,cDot(i,2)];
        
    end
end
    %%
    %Finds the max x and y cordinates for the top Row
    x=[cDot(find(cDot(:,2)==min(T),5),1),cDot(find(cDot(:,2)==max(T),5),1)];
    y=[cDot(find(cDot(:,2)==min(T),5),2),cDot(find(cDot(:,2)==max(T),5),2)];
    %Finds the slope of the top line and takes the arctan to find angle
    RotTable=atand((x(2)-x(1))/(y(2)-y(1)));
    RotTable=90-RotTable;
    %Rotates the grey image so you dont have to apply mask again
    grey=imrotate(grey,RotTable);
    imshow(imrotate(grey,RotTable));
    img=imrotate(img,RotTable);
    [cDot] = imfindcircles(grey,[2 6],'Sensitivity', 0.9, 'EdgeThreshold', 0.5);
    L=[];
    R=[];
    T=[];
    B=[];
    try
        cSelect = cDot(1:18,:);
    catch
        try
            cSelect = cDot(1:17,:);
        catch
            try
                cSelect = cDot(1:16,:);
            catch
                try
                    cSelect = cDot(1:15,:);
                catch
                    cSelect = cDot(1:14,:);
                end
            end
        end
    end
    for i=1:length(cSelect)
        if cSelect(i,1) <= 100
            %left side
            L=[L,;cSelect(i,1)];
        elseif cSelect(i,1) >= 1200
            %Right side
            R=[R,;cSelect(i,1)];
        else
            if cSelect(i,2)<= 100
                %top
                T=[T,cSelect(i,2)];
            elseif cSelect(i,2)>= 600
                %Bottom
                B=[B,cSelect(i,2)];
            end
        end
    end
    TopLine=sum(T)/length(T);
    BottomLine=sum(B)/length(B);
    RightLine=sum(R)/length(R);
    LeftLine=sum(L)/length(L);
end
