%function [strXYZOATS]=MatlabMain() 
clear all
clc

%globals to other Directories
global ball_d bumper_w mm2pixel pixel2mm ballInfo  Directory2Zip img color rasp cam cueCrop
%globals from other directories
global pocket color X Y Z O A Ts balls cameraParams RotTable CroppedTable

Directory2Zip='C://Users/ryanl/Downloads/Senior_Project_kyle/Senior_Project';%directory to this  Zip

mm2pixel=1/1.4992;
pixel2mm=1.4992;
ball_d=58*mm2pixel;
bumper_w=68*mm2pixel;
%calls get image to obtain a img from pi camera or toload img
[img]=getImage();
%done to perform all the mask to identify dots around table, Returns an
%array of four elements representing their respective max values
[T,B,R,L]=dotDetection(img);
%Draws rectangle with respect to dot calbration GOLDEN COLOR
DrawTableFeatures(L,R,T,B);
[x,y,z,o,a,t]=PossibleShots(img);

strXYZOATS=[num2str(x) ' ' num2str(y) ' ' num2str(z) ' ' num2str(o) ' ' num2str(a) ' ' num2str(t)];
%end