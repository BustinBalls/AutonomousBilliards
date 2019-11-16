function DrawTableFeatures(L,R,T,B)
%globals to other Directories
global pocket img color
%globals from other directories
global ball_d bumper_w CroppedTable
%{
bOS=bumper_w+(ball_d/2);%ball offset
%draw this to check params
line([L,L],[T ,B],'Color', 'm','LineWidth', 1);%L
line([R,R],[T ,B],'Color', 'm','LineWidth', 1);%R
line([L,R],[T ,T],'Color', 'm','LineWidth', 1);%T
line([L,R],[B ,B],'Color', 'm','LineWidth', 1);%B
%%
%commented out to save computing time
plot(L,T,'om','LineWidth',1);                              %top Left
plot(R,T,'om','LineWidth',1);    %top Right
plot(L,B,'om','LineWidth',1);    %Bottom Left
plot(R,B,'om','LineWidth',1);    %Bottom Right Magenta
plot(((L+R)/2),B,'oc','LineWidth',1);    %Bottom center
plot(((L+R)/2),T,'oc','LineWidth',1);    %Top center
%%
%Apply offset to get wall bumbper size
line([L+bumper_w,L+bumper_w],[T+bumper_w ,B-bumper_w],'Color', 'r','LineWidth', 1);%L
line([R-bumper_w,R-bumper_w],[T+bumper_w ,B-bumper_w],'Color', 'r','LineWidth', 1);%R
line([L+bumper_w,R-bumper_w],[T+bumper_w ,T+bumper_w],'Color', 'r','LineWidth', 1);%T
line([L+bumper_w,R-bumper_w],[B-bumper_w ,B-bumper_w],'Color', 'r','LineWidth', 1);%B

%%
line([L+bOS,L+bOS],[T+bOS ,B-bOS],'Color', 'w','LineWidth', 1);%L
line([R-bOS,R-bOS],[T+bOS ,B-bOS],'Color', 'w','LineWidth', 1);%R
line([L+bOS,R-bOS],[T+bOS ,T+bOS],'Color', 'w','LineWidth', 1);%T
line([L+bOS,R-bOS],[B-bOS ,B-bOS],'Color', 'w','LineWidth', 1);%B 
%%
%Pocket Locations
          %Top Right  %Bottom Right %Bottom middle %Bottom Left %Top Left    %Top Middle
pocket = [R-bOS T+bOS; R-bOS B-bOS; (L+R)/2 B-bOS; L+bOS B-bOS; L+bOS T+bOS; (L+R)/2 T+bOS];  
Cpocket = [R-bumper_w T+bumper_w; R-bumper_w B-bumper_w; (L+R)/2 B-bumper_w; L+bumper_w B-bumper_w; L+bumper_w T+bumper_w; (L+R)/2 T+bumper_w];  
color = {[0 0 0];[1 0 0];[0.4660 0.6740 0.1880];[0 0 1];[0.8500 0.3250 0.0980];[1 0 1]}; %color matrix
for i=1:6
    viscircles(Cpocket(i,:), ball_d, 'Color', color{i}, 'LineStyle', '-.');
end
%}
bOS=(ball_d/2);%balls offset
%draw this to check params
line([L L],[T B],'Color', 'm','LineWidth', 1);%L
line([R R],[T B],'Color', 'm','LineWidth', 1);%R
line([L R],[T T],'Color', 'm','LineWidth', 1);%T
line([L R],[B B],'Color', 'm','LineWidth', 1);%B
%commented out to save computing time
%{
plot(L,T,'om','LineWidth',1);                              %top Left
plot(R,T,'om','LineWidth',1);    %top Right
plot(L,B,'om','LineWidth',1);    %Bottom Left
plot(R,B,'om','LineWidth',1);    %Bottom Right Magenta
plot(((L+R)/2),B,'oc','LineWidth',1);    %Bottom center
plot(((L+R)/2),T,'oc','LineWidth',1);    %Top center
line([0+bumper_w,0+bumper_w],[0+bumper_w ,yCrop-bumper_w],'Color', 'r','LineWidth', 1);%0
line([xCrop-bumper_w,xCrop-bumper_w],[0+bumper_w ,yCrop-bumper_w],'Color', 'r','LineWidth', 1);%xCrop
line([0+bumper_w,xCrop-bumper_w],[0+bumper_w ,0+bumper_w],'Color', 'r','LineWidth', 1);%0
line([0+bumper_w,xCrop-bumper_w],[yCrop-bumper_w ,yCrop-bumper_w],'Color', 'r','LineWidth', 1);%B
%}
CroppedTable=[L+bumper_w T+bumper_w R-L-bumper_w*2 B-T-bumper_w*2];
img=imcrop(img,CroppedTable);
imshow(img)
[yCrop,xCrop]=size(rgb2gray(img));
line([0+bOS,0+bOS],[0+bOS ,yCrop-bOS],'Color', 'w','LineWidth', 1);%0
line([xCrop-bOS,xCrop-bOS],[0+bOS ,yCrop-bOS],'Color', 'w','LineWidth', 1);%xCrop
line([0+bOS,xCrop-bOS],[0+bOS ,0+bOS],'Color', 'w','LineWidth', 1);%0
line([0+bOS,xCrop-bOS],[yCrop-bOS ,yCrop-bOS],'Color', 'w','LineWidth', 1);%yCrop
%Top Right  %Bottom Right %Bottom middle %Bottom Left %Top Left    %Top Middle
pocket = [xCrop-bOS 0+bOS; xCrop-bOS yCrop-bOS; (0+xCrop)/2 yCrop-bOS; 0+bOS yCrop-bOS; 0+bOS 0+bOS; (0+xCrop)/2 0+bOS];
color = {[0 0 0];[1 0 0];[0.4660 0.6740 0.1880];[0 0 1];[0.8500 0.3250 0.0980];[1 0 1]}; %color matrix
for i=1:6
    viscircles(pocket(i,:), ball_d, 'Color', color{i}, 'LineStyle', '-.');
end

end