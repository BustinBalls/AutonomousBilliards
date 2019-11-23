%function [robotSend]=ClusterClean()
close all
global Shots img ballDiam pocket color ballRad xCrop yCrop ballScrewBack stepperCount arduinoUno rasp cam cameraParams greyCue
Directory2Zip='C://Users/ryanl/Downloads/Senior_Project_kyle/Senior_Project/MatlabBilliards';%directory to this  Zip
mm2pixel=1/1.4992;
pixel2mm=1.4992;
ballDiam=58*mm2pixel;
bumper_w=68*mm2pixel;
ballRad = ballDiam/2;
color = {[0 0 0];[1 0 0];[0.4660 0.6740 0.1880];[0 0 1];[0.8500 0.3250 0.0980];[1 0 1]};
Shots={};
Ball={};

Left=[];
Right=[];
Top=[];
Bot=[];
img=imread([Directory2Zip '/Photos/img(5.0511).png']);
%{
img = snapshot(cam);
img = snapshot(cam);
img = snapshot(cam);
img = snapshot(cam);
img = snapshot(cam);
%}
while ((isempty(Left) | isempty(Right) | isempty(Top) | isempty(Bot))==1)==1
    Left=[];
    Right=[];
    Top=[];
    Bot=[];
    %img = snapshot(cam);
    img = undistortImage(img,cameraParams);
    figure('Name','Original Image','NumberTitle','off');
    imshow(img);
    for hide=1:1
        X = rgb2lab(img);
        BW = false(size(X,1),size(X,2));
        xPos = [58.4829 1227.7684 1227.7684 58.4829 ];
        yPos = [50.8932 50.8932 672.7325 672.7325 ];
        m = size(BW, 1);
        n = size(BW, 2);
        ROI = poly2mask(xPos,yPos,m,n);
        foregroundInd = [];
        backgroundInd = [];
        L = superpixels(X,4708,'IsInputLab',true);
        scaledX = prepLab(X);
        BW = BW | grabcut(scaledX,L,ROI,foregroundInd,backgroundInd);
        xPos = [577.4846 724.0829 724.0829 577.4846 ];
        yPos = [0.5000 0.5000 137.5393 137.5393 ];
        m = size(BW, 1);
        n = size(BW, 2);
        ROI = poly2mask(xPos,yPos,m,n);
        foregroundInd = [];
        backgroundInd = [];
        L = superpixels(X,4708,'IsInputLab',true);
        scaledX = prepLab(X);
        BW = BW | grabcut(scaledX,L,ROI,foregroundInd,backgroundInd);
        xPos = [1137.1838 1280.2812 1280.2812 1137.1838 ];
        yPos = [570.3325 570.3325 720.5000 720.5000 ];
        m = size(BW, 1);
        n = size(BW, 2);
        ROI = poly2mask(xPos,yPos,m,n);
        foregroundInd = [820025 820026 820744 822184 822904 824343 824369 825782 826535 826539 826543 827222 827253 827264 827266 827962 827987 827988 828679 828710 829431 830101 832271 834421 836577 836597 838028 838029 838741 838750 839471 840901 841635 843061 843078 845960 846664 847401 849562 850990 854594 854595 854605 858919 858926 860360 861081 863966 866124 866844 868286 871167 871887 873325 874696 874698 875413 875422 875485 876130 876210 876850 876865 877567 877585 877644 878287 879006 879007 879745 880447 880521 881887 881905 882695 883343 883415 884768 884837 885501 885576 886935 887636 887637 887650 887711 888355 889070 889071 889073 889075 889091 889099 889797 889805 890517 890519 890521 890532 890542 890585 890586 890615 891262 892739 893415 894173 894866 895589 896326 897018 897034 897094 897758 897761 899901 899972 902063 904225 905008 905669 907833 908602 910718 910719 911444 911473 912165 912893 912904 ];
        backgroundInd = [];
        L = superpixels(X,4708,'IsInputLab',true);
        scaledX = prepLab(X);
        BW = BW | grabcut(scaledX,L,ROI,foregroundInd,backgroundInd);
        xPos = [0.5000 143.3786 143.3786 0.5000 ];
        yPos = [592.2128 592.2128 720.5000 720.5000 ];
        m = size(BW, 1);
        n = size(BW, 2);
        ROI = poly2mask(xPos,yPos,m,n);
        foregroundInd = [18629 19345 21486 22253 28020 30185 30186 30188 30939 32288 32347 33008 33011 33046 33736 34462 34467 34474 34533 35201 35931 35954 36625 36627 36663 36674 39553 39559 41718 42444 43809 45327 46042 47489 50366 51812 53968 56129 56135 57565 58289 61165 61179 61890 65490 65500 66930 69810 69821 73408 74119 74142 75563 76998 78436 78462 79154 79871 79872 79878 79879 83502 84918 86382 87102 88541 89260 89957 89979 94995 95715 100033 ];
        backgroundInd = [];
        L = superpixels(X,4708,'IsInputLab',true);
        scaledX = prepLab(X);
        BW = BW | grabcut(scaledX,L,ROI,foregroundInd,backgroundInd);
        xPos = [0.5000 176.1991 176.1991 0.5000 ];
        yPos = [0.5000 0.5000 137.1017 137.1017 ];
        m = size(BW, 1);
        n = size(BW, 2);
        ROI = poly2mask(xPos,yPos,m,n);
        foregroundInd = [17335 18057 18780 19503 21667 21692 24553 24593 25275 25314 27426 28157 30318 31017 31759 32480 35331 36840 41820 41828 42534 42557 43964 44002 44003 44690 44726 44729 45410 45454 45456 45458 45459 49005 52602 55478 55480 56199 57638 59076 59796 61235 62673 65553 68432 70592 73469 80666 85704 115953 ];
        backgroundInd = [];
        L = superpixels(X,4708,'IsInputLab',true);
        scaledX = prepLab(X);
        BW = BW | grabcut(scaledX,L,ROI,foregroundInd,backgroundInd);
        xPos = [1130.6197 1280.2812 1280.2812 1130.6197 ];
        yPos = [0.5000 0.5000 139.7274 139.7274 ];
        m = size(BW, 1);
        n = size(BW, 2);
        ROI = poly2mask(xPos,yPos,m,n);
        foregroundInd = [843874 844587 845307 846746 847465 850342 853220 854660 858260 860433 861860 861873 865461 871222 874823 877000 879145 879865 882043 882747 887087 887790 887791 890692 891394 891479 891480 892114 892198 893577 894996 894997 895075 895743 895792 897161 897909 897947 898680 899382 899399 900078 900766 900767 900806 901531 901536 902211 903656 903705 905103 905829 905844 ];
        backgroundInd = [];
        L = superpixels(X,4708,'IsInputLab',true);
        scaledX = prepLab(X);
        BW = BW | grabcut(scaledX,L,ROI,foregroundInd,backgroundInd);
        xPos = [568.2949 720.5821 720.5821 568.2949 ];
        yPos = [565.9564 565.9564 720.5000 720.5000 ];
        m = size(BW, 1);
        n = size(BW, 2);
        ROI = poly2mask(xPos,yPos,m,n);
        foregroundInd = [440601 440602 442763 446366 449968 455011 455731 460052 465092 465812 470131 473731 477330 478770 482368 485247 486686 488841 491715 493871 494585 494586 ];
        backgroundInd = [];
        L = superpixels(X,4708,'IsInputLab',true);
        scaledX = prepLab(X);
        BW = BW | grabcut(scaledX,L,ROI,foregroundInd,backgroundInd);
        BW = imcomplement(BW);
        maskedImage = img;
        maskedImage(repmat(~BW,[1 1 3])) = 0;
    end
    grey=rgb2gray(maskedImage);
    [cDot, r] = imfindcircles(grey,[3 8],'Sensitivity', 0.9, 'EdgeThreshold', 0.2);
    rNew=[];
    cDotNew=[];
    for i=1:length(cDot)
        if r(i)<5.2 && r(i)>4.5
            rNew=[rNew;r(i)];
            cDotNew=[cDotNew; cDot(i,:)];
        end
    end
    cDot=cDotNew;
    r=rNew;
    if length(cDot)> 18
        cDot=cDot(1:18,:);
        r=r(1:18);
    end
    viscircles(cDot, r,'Color','b');
    for i=1:length(cDot)
        if cDot(i,1) <= 100
            Left=[Left,cDot(i,1)];
        elseif cDot(i,1) >= 1200
            Right=[Right,cDot(i,1)];
        else
            if cDot(i,2)<= 100
                Top=[Top,cDot(i,2)];
            elseif cDot(i,2)>= 600
                Bot=[Bot,cDot(i,2)];
            end
        end
    end
end
tDotDeviation=max(Top)-min(Top);
bDotDeviation=max(Bot)-min(Bot);
lDotDeviation=max(Left)-min(Left);
rDotDeviation=max(Right)-min(Right);

disp(['tmax-tmin: ' num2str(tDotDeviation)]);
disp(['max(Bot)-min(Bot);: ' num2str(bDotDeviation)]);
disp(['max(Left)-min(Left): ' num2str(lDotDeviation)]);
disp(['max(Right)-min(Right): ' num2str(rDotDeviation)]); 
Top=sum(Top)/length(Top);
Bot=sum(Bot)/length(Bot);
Right=sum(Right)/length(Right);
Left=sum(Left)/length(Left);
CroppedTable=[Left+bumper_w Top+bumper_w Right-Left-bumper_w*2 Bot-Top-bumper_w*2];
img=imcrop(img,CroppedTable);
imshow(img)
[yCrop,xCrop]=size(rgb2gray(img));
pocket =    [ballRad ballRad; (xCrop)/2 ballRad;   xCrop-ballRad ballRad; xCrop-ballRad yCrop-ballRad; (xCrop)/2 yCrop-ballRad; ballRad yCrop-ballRad];
for i=1:6
    viscircles(pocket(i,:), ballDiam, 'Color', color{i}, 'LineStyle', '--');
end
[cBall,r] = imfindcircles(img,[15 23],'Sensitivity', .9, 'EdgeThreshold', .2);
viscircles(cBall, r,'Color','b');
[imgY,imgX]=size(rgb2gray(img));
cueCrop=imcrop(img,[0,0,(imgX/2)+.1*imgX,.1*imgY]);
[CueX,CueY] = CueTip(cueCrop);
disp(['Cue tip max position: (' num2str(CueX) ',' num2str(CueY) ')'])
count=1;
i=1;
while isempty(cBall)==0
    if i==1
        Ball{i,14}=[];
        Ball{i,1}=i;
        [Ball{i,2},Ball{i,3}]=identi_que(img);
        img=insertText(img,[Ball{i,2}-ballRad,Ball{i,3}-ballRad],'cue','FontSize',18,'TextColor','black','BoxOpacity',0);
        index_x= find(round(Ball{i,2})<(round(cBall(:,1))+30) & (round(Ball{i,2})>(round(cBall(:,1))-30)),1);
        index_y= find(round(Ball{i,3})<(round(cBall(:,2))+30) & (round(Ball{i,3})>(round(cBall(:,2))-30)),1);
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
        if Ball{1,2} > imgX/2
            if Ball{1,3} > imgY/2
                if (pocket(4,1)-Ball{1,2}<75*mm2pixel || pocket(4,2)-Ball{1,3}<75*mm2pixel)
                    A=30;
                    rotWeight=5;
                elseif (pocket(4,1)-Ball{1,2}<150*mm2pixel || pocket(4,2)-Ball{1,3}<150*mm2pixel)
                    A=20;
                    rotWeight=2;
                else
                    A=15;
                    rotWeight=1;
                end
            elseif Ball{1,3} <= imgY/2
                if (pocket(3,1)-Ball{1,2}<75*mm2pixel || pocket(3,2)-Ball{1,3}>-75*mm2pixel)
                    A=30;
                    rotWeight=5;
                elseif (pocket(3,1)-Ball{1,2}<150*mm2pixel || pocket(3,2)-Ball{1,3}>-150*mm2pixel)
                    A=20;
                    rotWeight=2;
                else
                    A=15;
                    rotWeight=1;
                end
            end
        elseif Ball{1,2} <= imgX/2
            if Ball{1,3} > imgY/2
                if (pocket(6,1)-Ball{1,2}>-75*mm2pixel || pocket(6,2)-Ball{1,3}<75*mm2pixel)
                    A=30;
                    rotWeight=5;
                elseif (pocket(6,1)-Ball{1,2}>-150*mm2pixel || pocket(6,2)-Ball{1,3}<150*mm2pixel)
                    A=20;
                    rotWeight=2;
                else
                    A=15;
                    rotWeight=1;
                end
            elseif Ball{1,3} <= imgY/2
                if (pocket(1,1)-Ball{1,2}>-75*mm2pixel || pocket(1,2)-Ball{1,3}>-75*mm2pixel)
                    A=30;
                    rotWeight=5;
                elseif (pocket(1,1)-Ball{1,2}>-150*mm2pixel || pocket(1,2)-Ball{1,3}>-150*mm2pixel)
                    A=20;
                    rotWeight=2;
                else
                    A=15;
                    rotWeight=1;
                end
            end
        end
        Z=80;%for now z is to remain constant
        Ts=90;
    else
        Ball{i,1}=i;
        Ball{i,2}=cBall(1,1);
        Ball{i,3}=cBall(1,2);
        img=insertText(img,[Ball{i,2}-ballRad,Ball{i,3}-ballRad],num2str(Ball{i,1}),'FontSize',18,'TextColor','black','BoxOpacity',0);
        cBall(1,:)=[];
        for j = 1:6
            Ball{i,4} = [Ball{i,4} sqrt((Ball{i,2}-pocket(j,1))^2+(Ball{i,3}-pocket(j,2))^2)];
            Ball{i,5} = [Ball{i,5}  (pocket(j,1)-Ball{i,2})/Ball{i,4}(j)];%vectx
            Ball{i,6} = [Ball{i,6}  (pocket(j,2)-Ball{i,3})/Ball{i,4}(j)];%vecty
            Ball{i,7} = [Ball{i,7}  Ball{i,2}-ballDiam*Ball{i,5}(j)];
            Ball{i,8} = [Ball{i,8}  Ball{i,3}-ballDiam*Ball{i,6}(j)];
            Ball{i,9} = [Ball{i,9}  sqrt((Ball{i,7}(j)-Ball{1,2})^2+(Ball{i,8}(j)-Ball{1,3})^2)]; %distance cue Ball travel
            Ball{i,10} = [Ball{i,10}  (Ball{i,7}(j)-Ball{1,2})/(Ball{i,9}(j))]; %distance cue Ball travelx
            Ball{i,11} = [Ball{i,11}  (Ball{i,8}(j)-Ball{1,3})/(Ball{i,9}(j))]; %distance cue Ball travely
            Ball{i,12} = [Ball{i,12}  acosd(dot([Ball{i,10}(j) Ball{i,11}(j)],[Ball{i,5}(j) Ball{i,6}(j)]))];
            targetBall2wallWeight=[];
            if Ball{i,12}(j)<65
                if Ball{i,7}(j) > imgX/2
                    if Ball{i,8}(j) > imgY/2 %
                        if pocket(4,1)-Ball{i,7}(j)<50
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
                        if (Ball{i,7}(j)>pocket(4,1)||Ball{i,8}(j)>pocket(4,2))
                            Ball{i,13}=[Ball{i,13} 0];%shotpossible==FALSE
                        else
                            Ball{i,13}=[Ball{i,13} 1];%not eliminated yet
                        end
                    elseif Ball{i,8}(j) <= imgY/2
                        if pocket(3,1)-Ball{i,7}(j)<50
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
                        if (Ball{i,7}(j)>pocket(3,1)||Ball{i,8}(j)<pocket(3,2))
                            Ball{i,13}=[Ball{i,13} 0];%shotpossible==FALSE
                        else
                            Ball{i,13}=[Ball{i,13} 1];%not eliminated yet
                        end
                    end
                elseif Ball{i,7}(j) <= imgX/2
                    if Ball{i,8}(j) > imgY/2
                        if pocket(6,1)-Ball{i,7}(j)>-50
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
                        if (Ball{i,7}(j)<pocket(6,1)||Ball{i,8}(j)>pocket(6,2))
                            Ball{i,13}=[Ball{i,13} 0];%shotpossible==FALSE
                        else
                            Ball{i,13}=[Ball{i,13} 1];%not eliminated yet
                        end
                    elseif Ball{i,8}(j) <= imgY/2
                        if pocket(1,1)-Ball{i,7}(j)>-50
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
            if Ball{i,13}(j)==1
                %X=(round((Ball{1,2}-CueX)*pixel2mm+6.3250,2));%835.624 is offset to corner +6.3250 is cuestick radius if farthest edge detected
                %Y=(round((Ball{1,3}-CueY)*pixel2mm,2));%+58.532 og offset from corner
                X=(round((Ball{1,2}-571)*pixel2mm,2));%835.624 is offset to corner +6.3250 is cuestick radius if farthest edge detected
                Y=(round((Ball{1,3}-41)*pixel2mm,2));%+58.532 og offset from corner
                GG=@(AA,BB) [dot(AA,BB) -norm(cross(AA,BB)) 0 ;norm(cross(AA,BB)) dot(AA,BB) 0 ; 0 0 1];
                FFi = @(AA,BB) [ AA (BB-dot(AA,BB)*AA)/norm(BB-dot(AA,BB)*AA) cross(BB,AA) ];
                UU = @(Fi,G) Fi*G*inv(Fi);
                aa=[-1 0 0]';bb=[Ball{i,10}(j) Ball{i,11}(j) 0]';
                U = UU(FFi(aa,bb), GG(aa,bb));
                O=round(tr2eul(U)*(180/pi),2);
                O=O(3)+2;
                A=abs(A);
                Ts=abs(Ts);
                disp([num2str(X) ' ' num2str(Y) ' ' num2str(Z) ' ' num2str(O) ' ' num2str(A) ' ' num2str(Ts)])
                Shots{count,1}=[num2str(X) ' ' num2str(Y) ' ' num2str(Z) ' ' num2str(O) ' ' num2str(A) ' ' num2str(Ts)];
                DistanceBeforeCollision=sqrt(abs(Ball{1,2}-Ball{i,7}(j))^2+abs(Ball{1,3}-Ball{i,8}(j))^2);
                DistanceAfterCollision=sqrt(abs(pocket(j,1)-Ball{i,2})^2+abs(pocket(j,2)-Ball{i,3})^2);
                deltaDistance=(DistanceBeforeCollision+DistanceAfterCollision)*pixel2mm;
                
                Shots{count,10}=(Ball{i,12}(j)*6)+(DistanceAfterCollision*.5)+(DistanceBeforeCollision*.1)*rotWeight;%rank
                Shots{count,2}=[Ball{1,2},Ball{i,7}(j)];
                Shots{count,3}=[Ball{1,3},Ball{i,8}(j)];
                Shots{count,4}=[Ball{i,7}(j), Ball{i,8}(j)];
                Shots{count,5}=[pocket(j,1),Ball{i,2}];
                Shots{count,6}=[pocket(j,2),Ball{i,3}];
                Shots{count,7}=[Ball{i,2},Ball{i,7}(j)];
                Shots{count,8}=[Ball{i,3},Ball{i,8}(j)];
                Shots{count,9}=color{j};
                deltaDistance=.1*deltaDistance;
                if deltaDistance<50
                    deltaDistance=50;
                elseif deltaDistance>200
                    deltaDistance=200;
                end
                Shots{count,11}=deltaDistance;
                
                
                count=count+1;
            end
        end
    end
    i=i+1;
end
Shots=cell2table(Shots);
Shots.Properties.VariableNames={'XYZOATs','Draw1_1','Draw1_2','Draw2_1','Draw3_1','Draw3_2','Draw4_1','Draw4_2','Color','Rank','deltaDistance'};
Ball=cell2table(Ball);
Ball.Properties.VariableNames={'Num','X','Y','TargetBall2Pocket_mag','TargetBall2Pocket_UnitX','TargetBall2Pocket_UnitY','GhostBall_x','GhostBall_y','CueBall2TargetBall_mag','CueBall2TargetBall_UnitX','CueBall2TargetBall_UnitY','Phi','Possible','Rank'};
rankedShots=sort(Shots.Rank(:));
robotSend=DrawShot(find(Shots.Rank(:)==rankedShots(1)));
%end%this ends function%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [x,y] = CueTip(img)
global greyCue
I = rgb2hsv(img);

% Define thresholds for channel 1 based on histogram settings
channel1Min = 0.493;
channel1Max = 0.046;

% Define thresholds for channel 2 based on histogram settings
channel2Min = 0.204;
channel2Max = 1.000;

% Define thresholds for channel 3 based on histogram settings
channel3Min = 0.000;
channel3Max = 0.981;

% Create mask based on chosen histogram thresholds
sliderBW = ( (I(:,:,1) >= channel1Min) | (I(:,:,1) <= channel1Max) ) & ...
    (I(:,:,2) >= channel2Min ) & (I(:,:,2) <= channel2Max) & ...
    (I(:,:,3) >= channel3Min ) & (I(:,:,3) <= channel3Max);
BW = sliderBW;

% Initialize output masked image based on input image.
maskedRGBImage = img;

% Set background pixels where BW is false to zero.
maskedRGBImage(repmat(~BW,[1 1 3])) = 0;

% Convert RGB image into L*a*b* color space.

greyCue = rgb2gray(maskedRGBImage);                            %greyCue scale for edge function
%BW = edge(greyCue,'canny');                                    %does its thing
[H,theta,rho] = hough(BW);
P = houghpeaks(H,100,'threshold',ceil(0.5*max(H(:))));
lines = houghlines(BW,theta,rho,P,'MinLength',3);
hold on; axis on;
x=[];
y=[];
for k = 1:length(lines)
    if lines(k).theta >= -10 && lines(k).theta<=10 && lines(k).point1(1)>500
        xy = [lines(k).point1; lines(k).point2];
        plot(xy(:,1),xy(:,2),'LineWidth',1,'Color','b');
        x=[x ; lines(k).point1(1); lines(k).point2(1) ];
        y=[y ; lines(k).point1(2); lines(k).point2(2) ];
    end
end
x=max(x);
y=max(y);
end
function out = prepLab(in)
out = in;
out(:,:,1) = in(:,:,1) / 100;  % L range is [0 100].
out(:,:,2) = (in(:,:,2) + 86.1827) / 184.4170;  % a* range is [-86.1827,98.2343].
out(:,:,3) = (in(:,:,3) + 107.8602) / 202.3382;  % b* range is [-107.8602,94.4780].
end
function [center_x,center_y] = identi_que(img)
try
    I = rgb2lab(img);
    channel1Min = 81.222;
    channel1Max = 99.926;
    channel2Min = -20.671;
    channel2Max = 51.529;
    channel3Min = -13.072;
    channel3Max = 29.768;
    sliderBW = (I(:,:,1) >= channel1Min ) & (I(:,:,1) <= channel1Max) & ...
        (I(:,:,2) >= channel2Min ) & (I(:,:,2) <= channel2Max) & ...
        (I(:,:,3) >= channel3Min ) & (I(:,:,3) <= channel3Max);
    BW = sliderBW;
    maskedRGBImage = img;
    maskedRGBImage(repmat(~BW,[1 1 3])) = 0;
    [c, r] = imfindcircles(maskedRGBImage,[13 23],'Sensitivity', .9, 'EdgeThreshold', .5);
    cSelect = c(1,:);
catch
    try
        I = rgb2lab(img);
        channel1Min = 50.271;
        channel1Max = 94.043;
        channel2Min = -18.303;
        channel2Max = 6.299;
        channel3Min = -8.918;
        channel3Max = 51.470;
        sliderBW = (I(:,:,1) >= channel1Min ) & (I(:,:,1) <= channel1Max) & ...
            (I(:,:,2) >= channel2Min ) & (I(:,:,2) <= channel2Max) & ...
            (I(:,:,3) >= channel3Min ) & (I(:,:,3) <= channel3Max);
        BW = sliderBW;
        maskedRGBImage = img;
        maskedRGBImage(repmat(~BW,[1 1 3])) = 0;
        [c, r] = imfindcircles(maskedRGBImage,[13 23],'Sensitivity', .9, 'EdgeThreshold', .5);
        cSelect = c(1,:);
    catch
        try
            I = rgb2lab(img);
            channel1Min = 81.726;
            channel1Max = 99.901;
            channel2Min = -42.737;
            channel2Max = 13.244;
            channel3Min = -20.820;
            channel3Max = 37.376;
            sliderBW = (I(:,:,1) >= channel1Min ) & (I(:,:,1) <= channel1Max) & ...
                (I(:,:,2) >= channel2Min ) & (I(:,:,2) <= channel2Max) & ...
                (I(:,:,3) >= channel3Min ) & (I(:,:,3) <= channel3Max);
            BW = sliderBW;
            maskedRGBImage = img;
            maskedRGBImage(repmat(~BW,[1 1 3])) = 0;
            [c, r] = imfindcircles(maskedRGBImage,[13 23],'Sensitivity', .9, 'EdgeThreshold', .5);
            cSelect = c(1,:);
        catch
            try
                %If the L*A*Bot fails then try HSV distortion
                I = rgb2hsv(img);
                channel1Min = 0.057;
                channel1Max = 0.443;
                channel2Min = 0.000;
                channel2Max = 0.605;
                channel3Min = 0.626;
                channel3Max = 1.000;
                sliderBW = (I(:,:,1) >= channel1Min ) & (I(:,:,1) <= channel1Max) & ...
                    (I(:,:,2) >= channel2Min ) & (I(:,:,2) <= channel2Max) & ...
                    (I(:,:,3) >= channel3Min ) & (I(:,:,3) <= channel3Max);
                BW = sliderBW;
                maskedRGBImage = img;
                maskedRGBImage(repmat(~BW,[1 1 3])) = 0;
                [c, r] = imfindcircles(maskedRGBImage,[13 23],'Sensitivity', .9, 'EdgeThreshold', .5);
                cSelect = c(1,:);
            catch
                disp('No cue Found')
                center_x=300;
                center_y=300;
                return
            end
        end
    end
end
viscircles(c(1,:), r(1),'Color',[0.8500 0.3250 0.0980],'LineWidth',3,'LineStyle',':');
center_x=cSelect(1);
center_y=cSelect(2);
end
function [robotNextShot]=DrawShot(shotNum)
global Shots img ballDiam pocket color ballRad xCrop yCrop ballScrewBack
line([ballRad,ballRad],[ballRad ,yCrop-ballRad],'Color', 'w','LineWidth', 1);
line([xCrop-ballRad,xCrop-ballRad],[ballRad ,yCrop-ballRad],'Color', 'w','LineWidth', 1);
line([ballRad,xCrop-ballRad],[ballRad ,ballRad],'Color', 'w','LineWidth', 1);
line([ballRad,xCrop-ballRad],[yCrop-ballRad ,yCrop-ballRad],'Color', 'w','LineWidth', 1);
figure('Name',['Shot Rank ' num2str(Shots.Rank(shotNum,:))],'NumberTitle','off');
imshow(img),title(Shots.XYZOATs(shotNum,:));
line([ballRad,ballRad],[ballRad ,yCrop-ballRad],'Color', 'w','LineWidth', 1);
line([xCrop-ballRad,xCrop-ballRad],[ballRad ,yCrop-ballRad],'Color', 'w','LineWidth', 1);
line([ballRad,xCrop-ballRad],[ballRad ,ballRad],'Color', 'w','LineWidth', 1);
line([ballRad,xCrop-ballRad],[yCrop-ballRad ,yCrop-ballRad],'Color', 'w','LineWidth', 1);
for i=1:6
    viscircles(pocket(i,:), ballDiam, 'Color', color{i}, 'LineStyle', '-.');
end
line(Shots.Draw1_1(shotNum,:),Shots.Draw1_2(shotNum,:),'Color',Shots.Color(shotNum,:),'LineWidth',2);
viscircles(Shots.Draw2_1(shotNum,:) , ballDiam/2, 'Color', Shots.Color(shotNum,:), 'LineStyle', '-.');
line(Shots.Draw3_1(shotNum,:), Shots.Draw3_2(shotNum,:),'Color', Shots.Color(shotNum,:),'LineWidth',2);
line(Shots.Draw4_1(shotNum,:),Shots.Draw4_2(shotNum,:),'Color',Shots.Color(shotNum,:),'LineWidth',2);
robotNextShot=Shots.XYZOATs{shotNum,:};
ballScrewBack=Shots.deltaDistance(shotNum);
end