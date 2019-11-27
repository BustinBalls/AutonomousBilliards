%%
%helpful links
%%ZED SDK must select jetson
%https://www.stereolabs.com/developers/release/#sdkdownloads_anchor
%%For Jetson in matlab
%https://www.mathworks.com/help/supportpkg/nvidia/examples/getting-started-with-the-gpu-coder-support-package-for-nvidia-gpus.html
%%For information from ros node
%https://www.stereolabs.com/docs/ros/
%https://www.mathworks.com/help/ros/ug/generate-a-standalone-ros-node-from-simulink.html
%%helpful examples
%open_system('robotROSFeedbackControlExample.slx');


%%
%After fresh reinstall only
%{
%Please reflash jetson and run the following:
nano=jetson('192.168.0.7','ryan','P');
openShell(nano);%opens shell
%%%power of nano
%%5W
%sudo nvpmodel -m 1
%%10W
sudo nvpmodel -m 0
%%%Needed for matlab
sudo apt-get install libsdl1.2-dev
sudo apt-get install v4l-utils
%%%install Ros
sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
sudo apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
sudo apt update
sudo apt install ros-melodic-desktop
sudo rosdep init 
rosdep update
echo "source /opt/ros/melodic/setup.bash" >> ~/.bashrc 
source ~/.bashrc
sudo apt-get install cmake python-catkin-pkg python-empy python-nose python-setuptools libgtest-dev python-rosinstall python-rosinstall-generator python-wstool build-essential git
mkdir -p ~/catkin_ws/src
cd ~/catkin_ws/
catkin_make
echo "source ~/catkin_ws/devel/setup.bash" >> ~/.bashrc 
source ~/.bashrc

%%%Zed_Wrapper
cd ~/catkin_ws/src
git clone https://github.com/stereolabs/zed-ros-wrapper.git
cd ~/catkin_ws
rosdep install --from-paths src --ignore-src -r -y
catkin_make -DCMAKE_BUILD_TYPE=Release
%}

%extra docs/notes
%%
%{
%to list the contents of the home directory on the target:
system(hwobj, 'ls -al ~');
%transfers the file test.txt in the current directory to the remoteBuildDir on the target.
hwobj.putFile('test.txt', '~/remoteBuildDir');
%transfers the file test.txt in the remoteBuildDir directory on target to the current directory on the host.
hwobj.getFile('~/remoteBuildDir/test.txt','.');
%}

%%Run Once

%initialize simulink
%%

nano=jetson('192.168.0.7','ryan','P');
openShell(nano);%opens shell
%%Enter into shell: '
%roslaunch zed_wrapper zed.launch
%%back to matlab comand line
open_system('robotROSFeedbackControlExample');
%%Remove the files and return to the original folder.
%cleanup




