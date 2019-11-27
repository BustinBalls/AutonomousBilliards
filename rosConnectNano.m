nano=jetson('192.168.0.7','ryan','P');
openShell(nano);%opens shell
%Enter 'roslaunch zed_wrapper zed.launch'
%wait while it initializes
%5W
%sudo nvpmodel -m 1
%10W
%sudo nvpmodel -m 0
open_system('zed');
%To run simullink
%In robot Tab click montitor and tune to 

%
%%
%In robot Tab click montitor and tune to 
%to run in cmd window
%{
%helpful commands
%do not run in parallel with simulink
rosinit('http://192.168.0.7:11311','NodeHost','192.168.0.7')
%see topics
rostopic list
%chose a topic to get info
rostopic info /zed/zed_node/left/image_rect_color
ZedImg = rosmessage('sensor_msgs/Image');%   info inside ' ' is found from info and is the type:
%didnt work
readImage(ZedImg);
%again try
rostopic info /zed/zed_node/pose
%rossubscriber('NODE','TOPIC','MessageType',callback)
poseSub = rossubscriber('/zed/zed_node/pose');
rosmessage('geometry_msgs/PoseStamped');
%}
%%
%extra documents
%{
%%notes from matlab
% Create the ROS master and a node
       master = ros.Core;
       node = ros.Node('/test1');
 
       % Create subscriber
       laser = ros.Subscriber(node, '/scan', 'sensor_msgs/LaserScan');
 
       % Show latest message that was received (if any)
       scan = laser.LatestMessage;
 
       % Wait for next message to arrive (blocking)
       scan = receive(laser);
 
       % Create subscriber with callback function
       % The topic type is inferred (if topic /chatter exists)
       chatpub = ros.Publisher(node, '/chatter', 'std_msgs/String');
       chatsub = ros.Subscriber(node, '/chatter', @testCallback);   
      
       % Create subscriber with buffer size of 5
       chatbuf = ros.Subscriber(node, '/chatter', 'BufferSize', 5);
%}
%{
%% Getting Started with the GPU Coder Support Package for NVIDIA GPUs
%
% This example shows how to use the *GPU Coder(TM) Support Package for 
% NVIDIA GPUs* and connect to NVIDIA(R) DRIVE(TM) and Jetson hardware 
% platforms, perform basic operations, generate CUDA(R) executable from a 
% MATLAB(R) function and run the executable on the hardware. A simple 
% vector addition example is used to demonstrate this concept.
%
% <<HSP_image.jpg>>

% Copyright 2018-2019 The MathWorks, Inc.

%% Prerequisites
% *Target Board Requirements*
%
% * NVIDIA DRIVE PX2 or Jetson TX1/TX2 embedded platform. 
% * Ethernet crossover cable to connect the target board and host PC (if 
% the target board cannot be connected to a local network).
% * NVIDIA CUDA toolkit installed on the board.
% * Environment variables on the target for the compilers and libraries. 
% For information on the supported versions of the compilers and libraries 
% and their setup, see <matlab:web(fullfile(docroot,'supportpkg/nvidia/ug/install-and-setup-prerequisites.html'))
%  installing and setting up prerequisites for NVIDIA boards>.
%
% *Development Host Requirements*
%
% * GPU Coder(TM) for code generation. For an overview and tutorials, visit the
% <matlab:web('https://www.mathworks.com/products/gpu-coder/','-browser')
% GPU Coder product page> .
% * NVIDIA CUDA toolkit on the host.
% * Environment variables on the host for the compilers and libraries. For 
% information on the supported versions of the compilers and libraries, see 
% <matlab:web(fullfile(docroot,'gpucoder/gs/install-prerequisites.html'))
% Third-party Products>. For setting up the 
% environment variables, see <matlab:web(fullfile(docroot,'gpucoder/gs/setting-up-the-toolchain.html'))
% Environment Variables>.

%% Create a Folder and Copy Relevant Files
% The following line of code creates a folder in your current working 
% directory (host), and copies all the relevant files into this folder.if 
% you cannot generate files in this folder, change your current working 
% directory before running this command.
gpucoderdemo_setup('nvidia_gettingstarted');

%% Connect to the NVIDIA Hardware
% The GPU Coder Support Package for NVIDIA GPUs uses an SSH connection over 
% TCP/IP to execute commands while building and running the generated CUDA 
% code on the DRIVE or Jetson platforms. You must therefore connect the
% target platform to the same network as the host computer or use an 
% Ethernet crossover cable to connect the board directly to the host
% computer. Refer to the NVIDIA documentation on how to set up and
% configure your board.
%
% To communicate with the NVIDIA hardware, you must create a live hardware
% connection object by using the <matlab:doc('drive') drive> or 
% <matlab:doc('jetson') jetson> function. You must know the host name or IP
% address, username, and password of the target board to create a live
% hardware connection object. For example, use the following command to 
% create live object for Jetson hardware,
%
%   hwobj = jetson('jetson-tx2-name','ubuntu','ubuntu');
hwobj = jetson('192.168.0.99','ryan','P');
%%
% During the hardware live object creation checking of hardware, IO
% server installation and gathering peripheral information on target will be
% performed. This information is displayed in the command window.

%%
% Similarly, use the following command to create live object 
% for DRIVE hardware,
% 
%   hwobj = drive('drive-px2-name','ubuntu','ubuntu'); 
%

%%
% *NOTE:* 
%
% In case of a connection failure, a diagnostics error message is 
% reported on the MATLAB command line. If the connection has failed, the 
% most likely cause is incorrect IP address or hostname.
%
% When a successful connection to the board is established, you can use the
% system method of the board object to execute various Linux shell commands
% on the NVIDIA hardware from MATLAB. For example, to list the contents of 
% the home directory on the target: 
%
%   system(hwobj, 'ls -al ~');

%%
% The hardware object provides basic file manipulation capabilities. To 
% transfer files from from the host to the target use the |putFile()| 
% method of the live hardware object. For example, the following command 
% transfers the file |test.txt| in the current directory to the 
% |remoteBuildDir| on the target.
% 
%   hwobj.putFile('test.txt', '~/remoteBuildDir');

%%
% And to copy a file from the target to host computer, use the |getFile()|
% method of the hardware object. For example, the following command transfers
% the file |test.txt| in the |remoteBuildDir| directory on target to the 
% |current directory| on the host.
%
%   hwobj.getFile('~/remoteBuildDir/test.txt','.');

%% Verify the GPU Environment
% Use the <matlab:doc('coder.checkGpuInstall') coder.checkGpuInstall> function
% and verify that the compilers and libraries needed for running this example
% are set up correctly.
% 
%   envCfg = coder.gpuEnvConfig('jetson'); % Use 'drive' for NVIDIA DRIVE hardware
%   envCfg.BasicCodegen = 1;
%   envCfg.Quiet = 1;
%   envCfg.HardwareObject = hwobj;
%   coder.checkGpuInstall(envCfg);

%% Generate CUDA Code for the Target Using GPU Coder
% This example uses 
% <matlab:edit(fullfile(matlabroot,'toolbox','target','supportpackages','nvidia','nvidiaexamples','myAdd.m'))
% myAdd.m>, a simple vector addition as the entry-point 
% function for code generation. To generate a CUDA executable that can 
% deployed  on to a NVIDIA target, create a GPU code configuration object
% for generating an executable.
cfg = coder.gpuConfig('exe');

%%
% When there are multiple live connection objects for different targets,
% the code generator performs remote build on the target for which a 
% recent live object was created. To choose a hardware board for performing
% remote build, use the |setupCodegenContext()| method of the respective 
% live hardware object. If only one live connection object was created, it is 
% not necessary to call this method.
%
%   hwobj.setupCodegenContext;

%% 
% Use the <matlab:doc('coder.hardware') coder.hardware> function to create 
% a configuration object for the DRIVE or Jetson platform and assign it to
% the |Hardware| property of the code configuration object |cfg|.
% Use |'NVIDIA Jetson'| for the Jetson TX1 or TX2 boards and |'NVIDIA
% Drive'| for the DRIVE board.
cfg.Hardware = coder.hardware('NVIDIA Jetson');

%% 
% Use the |BuildDir| property to specify the directory for performing remote 
% build process on the target. If the specified build directory does not 
% exist on the target then the software creates a directory with the 
% given name. If no value is assigned to |cfg.Hardware.BuildDir|, the remote
% build process happens in the last specified build directory. If 
% there is no stored build directory value, the build process takes place 
% in the home directory.
cfg.Hardware.BuildDir = '~/remoteBuildDir';

%% 
% Certain NVIDIA platforms such as DRIVE PX2 contain multiple GPUs. On such 
% platforms, use the |SelectCudaDevice| property in the GPU configuration 
% object to select a specific GPU.
%
%   cfg.GpuConfig.SelectCudaDevice = 0;

%% 
% The custom <matlab:edit(fullfile('main.cu')) main> file is a wrapper that 
% calls the entry point function in the generated code. The main file passes 
% a vector containing the first 100 natural numbers to the entry point. It 
% writes the results to the 'myAdd.bin' binary file.
% 
cfg.CustomSource  = fullfile('main.cu');

%% 
% To generate CUDA code, use the <matlab:doc('codegen') codegen> function 
% and pass the GPU code configuration along with the size of the inputs for
% and |myAdd| entry-point function. After the  code generation takes place on 
% the host, the generated files are copied over and built on the target.
%
%   codegen('-config ',cfg,'myAdd','-args',{1:100,1:100});

%% Run the Executable on the Target
% Use the |runApplication()| method of the hardware object to launch the
% exectuable on the target hardware.
% 
%   pid = hwobj.runApplication('myAdd');
% 
% Alternatively, you can use the |runExecutable()| method of the hardware
% object to run the executable.
%
%   exe = [hwobj.workspaceDir '/myAdd.elf'];
%   pid = hwobj.runExecutable(exe);

%% Verify the Result from Target
% Copy the output bin file |myAdd.bin| to the MATLAB environment on the 
% host and compare the computed results with those from MATLAB. The property
% |workspaceDir| contains the path to the |codegen| folder on the target.
%
%   pause(0.3); % To ensure that the executable completed the execution.
%   hwobj.getFile([hwobj.workspaceDir '/myAdd.bin']);
%
% Simulation result from the MATLAB.
%
%   simOut = myAdd(0:99,0:99);
%
% Read the copied result binary file from target in MATLAB.
%
%   fId  = fopen('myAdd.bin','r');
%   tOut = fread(fId,'double');

%%
% Find the difference between MATLAB simulation output and GPU coder
% output from target.
%
%   diff = simOut - tOut';

%%
% Display the maximum deviation between the simulation output and GPU coder output from target.
%
%   fprintf('Maximum deviation between MATLAB Simulation output and GPU coder output on Target is: %f\n', max(diff(:)));

%% Cleanup
% Remove the files and return to the original folder.
%
%   cleanup
displayEndOfDemoMessage(mfilename)

%}