function PossibleShots(img)
%%
global ball_d bumper_w mm2pixel pixel2mm ballInfo pocket X Y Z O A Ts balls cc color RotTable CroppedTable
[cc, r] = imfindcircles(img,[15 23],'Sensitivity', .9, 'EdgeThreshold', .2);
viscircles(cc, r,'Color','b');
img_size=size(rgb2gray(img));
for i=1:length(cc)
    balls{i,16}=0;
    if i==1
        balls{i,1}=i;
        %set que at this position
        [balls{i,2},balls{i,3}]=identi_que(img);
        index_x= find(round(balls{i,2})<(round(cc(:,1))+1) & (round(balls{i,2})>(round(cc(:,1))-1)),1);
        index_y= find(round(balls{i,3})<(round(cc(:,2))+1) & (round(balls{i,3})>(round(cc(:,2))-1)),1);
        if index_y==index_x
            cc(index_x,:)=[];
        end
        %balls{i,4:15} = [0 0 0 0 0 0];
    else
        balls{i,1}=i;           %Ball number
        balls{i,2}=cc(i-1,1);      %Ball [x y]
        balls{i,3}=cc(i-1,2);      %Ball y
        %index_x= find(round(balls{i,2})<(round(cc(:,1))+1) & (round(balls{1,2})>(round(cc(:,1))-1)),1);
        %index_y= find(round(balls{i,3})<(round(cc(:,2))+1) & (round(balls{1,3})>(round(cc(:,2))-1)),1);
        %if index_y==index_x
        %    cc(index_x,:)=[];
        %end
        for j = 1:6
            
            %mag
            balls{i,4} = [balls{i,4}; sqrt((pocket(j,1)-balls{i,2})^2+(pocket(j,2)-balls{i,3})^2)];
            %unitvector from pocket 2 target balls
            balls{i,5} = [balls{i,5};  (balls{i,2}-pocket(j,1))/balls{i,4}(j)];%vectx
            balls{i,6} = [balls{i,6};  (balls{i,3}-pocket(j,2))/balls{i,4}(j)];%vecty
            %find new location for cue balls
            balls{i,7} = [balls{i,7};  balls{i,2}+ball_d*balls{i,5}(j)];%TargetX
            balls{i,8} = [balls{i,8};  balls{i,3}+ball_d*balls{i,6}(j)];%target Y
            %used to find unit vector from target balls to pocket
            balls{i,9} = [balls{i,9};  (pocket(j,1)-balls{i,2}) / (balls{i,4}(j))];%vectortoPocketX
            balls{i,10} = [balls{i,10};  (pocket(j,2)-balls{i,3}) / (balls{i,4}(j))];%   vectortoPocketY
            %used to find unit vector for cue balls directio
            balls{i,11} = [balls{i,11};  sqrt((balls{i,7}(j)-balls{1,2})^2+(balls{i,8}(j)-balls{1,3})^2)]; %distance cue balls travel
            balls{i,12} = [balls{i,12};  (balls{i,7}(j)-balls{1,2})/(balls{i,11}(j))]; %distance cue balls travelx
            balls{i,13} = [balls{i,13};  (balls{i,8}(j)-balls{1,3})/(balls{i,11}(j))]; %distance cue balls travely
            %angle
            balls{i,14} = [balls{i,14};  acosd(dot([balls{i,12}(j) balls{i,13}(j)],[balls{i,9}(j) balls{i,10}(j)]))];
            %%
            if balls{i,14}(j)<85%test if each shot can make contact at less than 85 deg
                %next will test if Ghost balls will exceed boundries since item is abritary
                if ((([balls{i,7}(j),balls{i,8}(j)]) >=(img_size./2))==[1 1])%bottom right
                    %balls{i,16}=[balls{i,16}  4];
                    %target balls center is in bottom right of img so tb_x or tb_y cant be
                    %greater than bottom right pockets x,y
                    if (balls{i,7}(j)>pocket(2,1)|balls{i,8}(j)>pocket(2,2))%bottom right
                        balls{i,15}=[balls{i,15} 0];%shotpossible==FALSE
                    else
                        balls{i,15}=[balls{i,15} 1];%not eliminated yet
                    end
                elseif((([balls{i,7}(j),balls{i,8}(j)])>=(img_size./2))==[1 0])% top right
                    %balls{i,16}=[balls{i,16} 1];
                    if (balls{i,7}(j)>pocket(1,1)|balls{i,8}(j)<pocket(1,2))%check if GB exceeds boundries
                        balls{i,15}=[balls{i,15}  0];%shotpossible==FALSE
                    else
                        balls{i,15}=[balls{i,15}  1];%not eliminated yet
                    end
                elseif((([balls{i,7}(j),balls{i,8}(j)])>=(img_size./2))==[0 0])%top left
                    %balls{i,16}=[balls{i,16}  2];
                    if (balls{i,7}(j)<pocket(5,1)|balls{i,8}(j)<pocket(5,2))%check if GB exceeds boundries
                        balls{i,15}=[balls{i,15}  0];%shotpossible==FALSE
                    else
                        balls{i,15}=[balls{i,15}  1];%not eliminated yet
                    end
                else%bottom left [0 1]
                    %balls{i,16}=[balls{i,16}  1];
                    if (balls{i,7}(j)<pocket(4,1)|balls{i,8}(j)>pocket(4,2))%check if GB exceeds boundries
                        balls{i,15}=[balls{i,15} ; 0];%shotpossible==FALSE
                    else
                        balls{i,15}=[balls{i,15}  1];%not eliminated yet
                    end
                end
            else
                balls{i,15}=[balls{i,15}  0];%
            end
            %%
            if balls{i,15}(j)==1
                X=(round((balls{1,2})*pixel2mm,2)-6.71);
                Y=(round((balls{1,3})*pixel2mm,2)-6.71);
                Z=90;
                GG=@(A,B) [dot(A,B) -norm(cross(A,B)) 0 ;norm(cross(A,B)) dot(A,B) 0 ; 0 0 1];
                FFi = @(A,B) [ A (B-dot(A,B)*A)/norm(B-dot(A,B)*A) cross(B,A) ];
                UU = @(Fi,G) Fi*G*inv(Fi);
                a=[-1 0 0]';b=[balls{i,12}(j) balls{i,13}(j) 0]';
                U = UU(FFi(a,b), GG(a,b));
                O=round(tr2eul(U)*(180/pi),2);
                O=O(3);
                A=15;
                Ts=90;
                disp([num2str(X) ' ' num2str(Y) ' ' num2str(Z) ' ' num2str(O) ' ' num2str(A) ' ' num2str(Ts)])
                
                input('Enter to continue and get image')
                imgChecker=[];
                %while isempty(imgChecker)==1
                    %figure(10);
                    %imgCheck = snapshot(cam);%capture image
                    %imshow(imgCheck)
                    %imgChecker=input("check img");
                %end
                figure('Name',['MASTER ' num2str(X) ' ' num2str(Y) ' ' num2str(Z) ' ' num2str(O) ' ' num2str(A) ' ' num2str(Ts)],'NumberTitle','off');
                %imgCheck = imrotate(imgCheck,RotTable);
                %imgCheck = imcrop(imgCheck,CroppedTable);
                imshow(img);axis on;
                line([balls{1,2},balls{i,7}(j)],[balls{1,3},balls{i,8}(j)],'Color',color{j},'LineWidth',2); %line from cue to target cue center
                viscircles([balls{i,7}(j) balls{i,8}(j)] , ball_d/2, 'Color', color{j}, 'LineStyle', '--');
                %waitkeyin=input('enter to go to next step:');
                line([pocket(j,1),cc(i-1,1)], [pocket(j,2),cc(i-1,2)],'Color', color{j},'LineWidth',2); %draw pocket to target balls center line
                line([balls{i,2},balls{i,7}(j)],[balls{i,3},balls{i,8}(j)],'Color',color{j},'LineWidth',2); %line add behind target direction
            end
        end
    end
end
ballInfo=cell2table(balls);
ballInfo.Properties.VariableNames={'num','x','y','p2gb_mag','p2gb_vectX','p2gb_vect_Y','ghost_x','ghost_y','gb2p_x','gb2p_y','cue_mag','cue_magX','cue_magY','angle','Possible','Bullshit Col'};




end