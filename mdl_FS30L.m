%%
clear all
multipler_frames=3;
close all
%{
rad2deg = 180/pi;
Series='F';
Application='Assembly';
MaxPayload=30;%kg
ReachType='Long';

L(1)=Revolute(Revolute(  'alpha', -pi/2, 'a', 150,   'd', -165,'offset',pi/2,'qlim',[-(8*pi)/9 (8*pi)/9]));
L(2)=Revolute(  'alpha', pi,    'a', 950,   'd', 0,'offset',-pi/2,'qlim',[-(7*pi)/12 (7*pi)/9]);
L(3)=Revolute(   'alpha', pi/2,  'a', 90,    'd', 0,'qlim',[-(5*pi)/4 (59*pi)/36]);
L(4)=Revolute(  'alpha', -pi/2, 'a', 0.0,   'd', 1000,  'qlim',[-(3*pi)/2 (3*pi)/2]);
L(5)=Revolute(  'alpha', pi/2,  'a', -165.6, 'd', 0,'offset',pi/2,     'qlim',[-(13*pi)/18 (13*pi)/18]);
L(6)=Revolute(    'alpha', 0,     'a', 0.0,   'd', -112.2,'offset',pi/2);


%FS30L=SerialLink(L,'name','FS30L');
%robotEOF=SerialLink(Prismatic( 'theta',0,'alpha',0,'a',0, 'qlim',[.165 1.000]),'name','EOF');   
%FS30L_full=FS30L*robotEOF;
%}
 
L(1)=Revolute(  'alpha', -pi/2, 'a', 150,   'd', -165,'offset',pi/2);
L(2)=Revolute(  'alpha', pi,    'a', 950,   'd', 0,'offset',-pi/2);
L(3)=Revolute(  'alpha', pi/2,  'a', 90,    'd', 0);
L(4)=Revolute(  'alpha', -pi/2, 'a', 0.0,   'd', 1000);
L(5)=Revolute(  'alpha', pi/2,  'a', -165.6, 'd', 0,'offset',pi/2);
L(6)=Revolute(  'alpha', 0,     'a', 0.0,   'd', -112.2,'offset',pi/2);
%for tool% L(6)=Revolute(  'alpha', pi/2,'a', 0.0,'d', 0,'offset',pi/2);

FS30L=SerialLink(L,'name','FS30L');
robotEOFRot=SerialLink(Prismatic( 'theta',0,'alpha',-pi/2,'a',0, 'qlim',[0 0]),'name','EOF');
robotEOF=SerialLink(Prismatic( 'theta',0,'alpha',-pi/2,'a',0, 'qlim',[0 900]),'name','EOF'); 
FS30L_full=FS30L*robotEOFRot*robotEOF;
%FS30L.teach()
%figure;
FS30L_full.teach()
%FS30L.model3d = 'Kawasaki';
%{
syms DH
syms q [1,10]
%   joint       degree  theta       d       a       alpha       q   show frame
DH(q1, q2, q3, q4, q5, q6)=['Revolute','Radian','q1',  '0',    '.150', '-pi/2',    '0',1;
    'Revolute','Radian','q2',  '0',     '.950', 'pi',       '0',1;
    'Revolute','Radian','q3',  '0',     '.090', 'pi/2',     '0',1;
    'Revolute','Radian','q4',  '1000',  '0',    '-pi/2',    '0',1;
    'Revolute','Radian','q5',  '0',     '0',    'pi/2',     '0',1;
    'Revolute','Radian','q6',  '0',     '0',    '0',        '0',1];

%   joint       degree  theta       d       a       alpha       q   show frame
DH={'Revolute','Radian','q1',       '0',    '.150', '-pi/2',    '0',1;
    'Revolute','Radian','q2-pi/2',  '0',    '.950', 'pi',       '0',1;
    'Revolute','Radian','q3+pi/2',  '0',    '.090', 'pi/2',     '0',1;
    'Revolute','Radian','q4',       '1',    '0',    '-pi/2',    '0',0;
    'Revolute','Radian','q5',       '0',    '0',    'pi/2',     '0',0;
    'Revolute','Radian','q6',       '0',    '0',    '0',        '0',0};

W=[-3,3,-3,3,0,3];
q=[0,0,0,0,0,0];
%V='x';
%FS30L.plot3d(q,'workspace', W,'view',V);
%FS30L.display();
%FS30L.fkine(Home)


%cg = CodeGenerator(s6);
%cg.geneverything();
%%

maxSpeed=[160 140 160 240 240 340];     %deg/sec
WristRatedTorque=[0 0 0 176.4 176.4 98];%N*m
WristRatedMomentofInertia=[0 0 0 7.2 7.2 3.3];%kg*m^2
VerticalReach=2.799;     %m
HorizontalReach=2.269;   %m
Weight=585;              %kg
%Drive Motors Brushless AC Servo Motor
% and build a serial link manipulator

%qlim   kinematic: joint variable limits [min max]
%m      dynamic: link mass
%r      dynamic: link COG wrt link coordinate frame 3x1
%I      dynamic: link inertia matrix, symmetric 3x3, about link COG. (3x1, 6x1 or 3x3)
%B      dynamic: link viscous friction (motor referred)
%Tc     dynamic: link Coulomb friction
%G      actuator: gear ratio
%Jm     actuator: motor inertia (motor refer141red)
% all parameters are in SI units: m, radians, kg, kg.m2, N.m, N.m.s etc.
 
L(1)=Revolute(  'alpha', pi/2, ...              link twist (Dennavit-Hartenberg notation)
    'a', 0.15, ...                  link offset (Dennavit-Hartenberg notation)
    'd', 0.680);%                 link length (Dennavit-Hartenberg notation)
%'I', [0, 0.35, 0, 0, 0, 0], ... inertia tensor of link with respect to center of mass I = [L_xx, L_yy, L_zz, L_xy, L_yz, L_xz]
%'r', [0, 0, 0], ...             distance of ith origin to center of mass [x,y,z] in link reference frame
%'m', 0, ...                     mass of link
%'Jm', 200e-6, ...               actuator inertia
%'G', -62.6111, ...              gear ratio
%'B', 1.48e-3, ...               actuator viscous friction coefficient (measured at the motor)
%'Tc', [0.395 -0.435], ...       actuator Coulomb friction coefficient for direction [-,+] (measured at the motor)
%'qlim', [-160 160]*deg );
%minimum and maximum joint angle

L(2)=Revolute(  'alpha', pi/2, ...                 link twist (Dennavit-Hartenberg notation)
    'a', 0.95, ...                  link offset (Dennavit-Hartenberg notation)
    'd', 0.0);%, ...                   link length (Dennavit-Hartenberg notation)
%'I', [0, 0.35, 0, 0, 0, 0], ... inertia tensor of link with respect to center of mass I = [L_xx, L_yy, L_zz, L_xy, L_yz, L_xz]
%'r', [0, 0, 0], ...             distance of ith origin to center of mass [x,y,z] in link reference frame
%'m', 0, ...                     mass of link
%'Jm', 200e-6, ...               actuator inertia
%'G', -62.6111, ...              gear ratio
%'B', 1.48e-3, ...               actuator viscous friction coefficient (measured at the motor)
%'Tc', [0.395 -0.435], ...       actuator Coulomb friction coefficient for direction [-,+] (measured at the motor)
%'qlim', [-105 140]*deg, ...     minimum and maximum joint angle
%'offset', pi/2);                %joint variable offset

L(3)=Revolute(  'alpha', pi/2, ...              link twist (Dennavit-Hartenberg notation)
    'a', 0.09, ...                  link offset (Dennavit-Hartenberg notation)
    'd', 0.0);%, ...                   link length (Dennavit-Hartenberg notation)
%'I', [0, 0.35, 0, 0, 0, 0], ... inertia tensor of link with respect to center of mass I = [L_xx, L_yy, L_zz, L_xy, L_yz, L_xz]
%'r', [0, 0, 0], ...             distance of ith origin to center of mass [x,y,z] in link reference frame
%'m', 0, ...                     mass of link
%'Jm', 200e-6, ...               actuator inertia
%'G', -62.6111, ...              gear ratio
%'B', 1.48e-3, ...               actuator viscous friction coefficient (measured at the motor)
%'Tc', [0.395 -0.435], ...       actuator Coulomb friction coefficient for direction [-,+] (measured at the motor)
%'qlim', [-155 120]*deg );       %minimum and maximum joint angle

L(4)=Revolute(  'alpha', -pi/2, ...             link twist (Dennavit-Hartenberg notation)
    'a', 0.0, ...                   link offset (Dennavit-Hartenberg notation)
    'd', 1.0);%, ...                   link length (Dennavit-Hartenberg notation)
%'I', [0, 0.35, 0, 0, 0, 0], ... inertia tensor of link with respect to center of mass I = [L_xx, L_yy, L_zz, L_xy, L_yz, L_xz]
%'r', [0, 0, 0], ...             distance of ith origin to center of mass [x,y,z] in link reference frame
%'m', 0, ...                     mass of link
%'Jm', 200e-6, ...               actuator inertia
%'G', -62.6111, ...              gear ratio
%'B', 1.48e-3, ...               actuator viscous friction coefficient (measured at the motor)
%'Tc', [0.395 -0.435], ...       actuator Coulomb friction coefficient for direction [-,+] (measured at the motor)
%'qlim', [-270 270]*deg);        %minimum and maximum joint angle

L(5)=Revolute(  'alpha', pi/2, ...              link twist (Dennavit-Hartenberg notation)
    'a', 0.0, ...                   link offset (Dennavit-Hartenberg notation)
    'd', 0.0);%, ...                   link length (Dennavit-Hartenberg notation)
%'I', [0, 0.35, 0, 0, 0, 0], ... inertia tensor of link with respect to center of mass I = [L_xx, L_yy, L_zz, L_xy, L_yz, L_xz]
%'r', [0, 0, 0], ...             distance of ith origin to center of mass [x,y,z] in link reference frame
%'m', 0, ...                     mass of link
%'Jm', 200e-6, ...               actuator inertia
%'G', -62.6111, ...              gear ratio
%'B', 1.48e-3, ...               actuator viscous friction coefficient (measured at the motor)
%'Tc', [0.395 -0.435], ...       actuator Coulomb friction coefficient for direction [-,+] (measured at the motor)
%'qlim', [-130 130]*deg );       %minimum and maximum joint angle

L(6)=Revolute(  'alpha', 0, ...                 link twist (Dennavit-Hartenberg notation)
    'a', 0.0, ...                   link offset (Dennavit-Hartenberg notation)
    'd', 0.165);%, ...                 link length (Dennavit-Hartenberg notation)
%'I', [0, 0.35, 0, 0, 0, 0], ... inertia tensor of link with respect to center of mass I = [L_xx, L_yy, L_zz, L_xy, L_yz, L_xz]
%'r', [0, 0, 0], ...             distance of ith origin to center of mass [x,y,z] in link reference frame
%'m', 0, ...                     mass of link
%'Jm', 200e-6, ...               actuator inertia
%'G', -62.6111, ...              gear ratio
%'B', 1.48e-3, ...               actuator viscous friction coefficient (measured at the motor)
%'Tc', [0.395 -0.435], ...       actuator Coulomb friction coefficient for direction [-,+] (measured at the motor)
%'qlim', [-360 360]*deg);        %minimum and maximum joint angle

robot=SerialLink(L,'name','FS30L');

robot = SerialLink([
    Revolute('alpha', 0     ,   'a',    .00     ,   'd',    .000    ,'qlim',[-(8*pi)/9 (8*pi)/9])
    Revolute('alpha', 0     ,   'a',    .15     ,   'd',    .475    ,'qlim',[-(7*pi)/12 (7*pi)/9])
    Revolute('alpha', pi/2  ,   'a',    .60     ,   'd',    .000    ,'qlim',[-(5*pi)/4 (59*pi)/36] )
    Revolute('alpha', -pi/2 ,   'a',    .12     ,   'd',    .000    ,'qlim',[-(3*pi)/2 (3*pi)/2] )
    Revolute('alpha', pi/2  ,   'a',    .00     ,   'd',    .805    ,'qlim',[-(13*pi)/18 (13*pi)/18] )
    Revolute('alpha', 0     ,   'a',    .00     ,   'd',    .000    )
    ], ...
    'name', 'FS30L');


%%

%%
%toggle robot to 'home' and run cmd returns joint angles in radian
%Home=robot.getpos
Aj_r(q1,q2,q3,q4)=trotz(q1)*transl([0;0;q2])*transl([q3;0;0])*trotx(q4);
Aj_d(q1,q2,q3,q4)=[cosd(q1),      -sind(q1)*cosd(q4), sind(q1)*sind(q4),  q3*cosd(q1);
    sind(q1),      cosd(q1)*cosd(q4),  -cosd(q1)*sind(q4), q3*sind(q1);
    0,          sind(q4),           cosd(q4),           q2;
    0,          0,                  0,                  1           ];
[DHrow,DHcol]=size(DH);
syms q [1,DHrow];
qValue=zeros(1,DHrow);
for m=1:DHrow
    qValue(1,m)=double(str2sym(DH{m,7}));%This helps for next loop
end

%%
%Finds H using DH
%and all other Homogeneous functions
for m=1:DHrow+1%col
    n=m;
    
    while n>=1
        if m==n
            H{m,n}=Aj_r(0,0,0,0);
            SolvedH{m,n}=double(subs(H{m,n},q,qValue));
        elseif (m-n==1)
            DHtheta=str2sym(DH{m-1,3});
            DHd=str2sym(DH{m-1,4});
            DHa=str2sym(DH{m-1,5});
            DHalpha=str2sym(DH{m-1,6});
            if DH{m-1,2}=="Radian" %Radian
                H{m,n}=Aj_r(DHtheta,DHd,DHa,DHalpha);
                SolvedH{m,n}=double(subs(H{m,n},q,qValue));
            elseif DH{m-1,2}=="Degree" %Degree
                H{m,n}=Aj_d(DHtheta,DHd,DHa,DHalpha);
                SolvedH{m,n}=double(subs(H{m,n},q,qValue));
            end
        else
            H{m,n}=H{m-1,n}*H{m,m-1};
            SolvedH{m,n}=double(subs(H{m,n},q,qValue));
        end
        n=n-1;
    end
end
%%
% parameters for axis


framePlotLims=[ -1,1,-1,1,-1,1].*multipler_frames;
axisLength=.15*multipler_frames;
            %Makes frame plot
            trplot(SolvedH{1,1},'rgb','frame',num2str(0),'axis',framePlotLims,'length',axisLength)
            hold on
            for m=1:DHrow
                if DH{m,8}==1
                    trplot(SolvedH{m+1,1},'rgb','frame',num2str(m),'axis',framePlotLims,'length',axisLength)
                    hold on
                end
            end
            hold off
%%
%Makes Jacobean
SolvedJ=zeros(6,DHrow);
for m=2:DHrow+1
    if DH{m-1,1}=="Revolute" %Is Rotational
        SolvedMax=SolvedH{DHrow+1,1}(1:3,4);
        SolvedCurr=SolvedH{m-1,1}(1:3,4);
        SolvedDiff=SolvedMax-SolvedCurr;
        SolvedR=SolvedH{m-1,1}(1:3,3);
        SolvedC=cross(SolvedR,SolvedDiff);
        SolvedJ(:,m-1)=[SolvedC;SolvedH{m-1,1}(1:3,3)];
        dMax=H{DHrow+1,1}(1:3,4);
        dCurr=H{m-1,1}(1:3,4);
        dDiff=dMax-dCurr;
        R=H{m-1,1}(1:3,3);
        c=cross(R,dDiff);
        J{m-1}=[c(1,1);c(2,1);c(3,1);H{m-1,1}(1,3);H{m-1,1}(2,3);H{m-1,1}(3,3)];
        JacobianString{m-1}=['Jv' num2str(m-1) '= ' mat2str(SolvedR) 'X (' mat2str(SolvedMax) '-' mat2str(SolvedCurr) ')' ' Jw' num2str(m-1) '= ' mat2str(SolvedR) ];
    elseif DH{m-1,1}=="Prismatic"%is Prismatic
        J{m-1}={H{m-1,1}(1,3);H{m-1,1}(2,3);H{m-1,1}(3,3);0;0;0};
        
        SolvedJ(:,m-1)=[SolvedH{m-1,1}(1:3,3);0;0;0];
        JacobianString{m-1}=['Jv' num2str(m-1) '= ' mat2str(SolvedH{m-1,1}(1:3,3)) ' Jw' num2str(m-1) '= ' mat2str([0;0;0])];
    end
end
FinalH=SolvedH{DHrow+1,1};
%}