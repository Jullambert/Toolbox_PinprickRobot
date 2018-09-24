%%
clear all;close all;
clc
%% Params to adjust for each participant
SubjectName = 'PP11';
Number_Stimulations = 20;
X_Center = 143; %in absolute coordinate
Y_Center = 90; %in absolute coordinate
R_NoStim = 5;% [mm]
R_Stim = 16; %[mm]
ISI_Min = 2;
ISI_Max = 4;
Zend = 19;
Zstart = Zend-10; % usual it's equal to Zend-20

% %Setting up the parallel port
% ParallelPort_InpOut('init', 'C:\Users\Butler\Documents\MATLAB\ParallelPort_InpOut\inpoutx64.dll', hex2dec('BFF8'));
% ParallelPort_InpOut('OUTPUT', 0)

%% Params defined for the experiment
ComPort = 7;
BaudRate = 250000;
KindMove = 0;
backHome = 1;

%% Preparing the random coordinates for the movement
X_Coord = zeros(Number_Stimulations,1);
Y_Coord = zeros(Number_Stimulations,1);
ISI = randi([ISI_Min,ISI_Max],Number_Stimulations,1);
R = randi([R_NoStim+1,R_Stim-1],Number_Stimulations,1); %produces a random vector whose length is <=radius
Theta = randn(Number_Stimulations,1).*2.*pi; % produces a random angle
for i=1:Number_Stimulations
    X_Coord(i,1) = R(i).*cos(Theta(i)); %calculate x coord
    Y_Coord(i,1) = R(i).*sin(Theta(i)); % calculate y coord
end

n=1;
while n<Number_Stimulations
    n=n+1;
    if ((round(X_Coord(n-1))== round(X_Coord(n))) && (round(Y_Coord(n-1))==round(Y_Coord(n))))||(abs(round(X_Coord(n-1))-round(X_Coord(n)))<2 && abs(round(Y_Coord(n-1))-round(Y_Coord(n)))<2)
        R = randi([R_NoStim,R_Stim],Number_Stimulations,1); %produces a random vector whose length is <=radius
        Theta = randn(Number_Stimulations,1).*2.*pi; % produces a random angle
        for i=1:Number_Stimulations
            X_Coord = R(i).*cos(Theta(i)); %calculate x coord
            Y_Coord = R(i).*sin(Theta(i)); % calculate y coord
        end
        n=1;
    end
end
X_Coord = X_Coord+X_Center;
Y_Coord = Y_Coord+Y_Center;
%% Eyelink initialisation - Joe Butler
% initalise psychtoolbox
AssertOpenGL;
screens      = Screen ('Screens');
screenNumber = max (screens);
white = WhiteIndex (screenNumber);
black = BlackIndex (screenNumber);
gray = (white + black)/2;

if round (gray) == white
    gray = black;
end
inc = white - gray;
[w, wRect]      = Screen ('OpenWindow', screenNumber, 0, [], 32, 2);
[width, height] = Screen ('WindowSize', w);
fix_cord        = [width/2-2 width/2+2];
fprintf ('\n%s%4d', 'screen width:  ', width);
fprintf ('\n%s%4d', 'screen height: ', height);
fprintf ('\n');
% Initialise eye-link
  if EyelinkInit () ~= 1
     return;
   end;
   status = Eyelink ('command', 'link_sample_data = LEFT,RIGHT,GAZE,AREA');
   if status ~= 0
   disp('link sample data error, status:')
   error(status)
   end

   [v vs] = Eyelink ('GetTrackerVersion');
   fprintf ('Running experiment on a ''%s'' tracker.\n', vs);
   el = EyelinkInitDefaults (w);
  
   EyelinkDoTrackerSetup (el);
   status = Eyelink ('command', 'link_sample_data = LEFT,RIGHT,GAZE,AREA');
  numFrames = 1; % temporal period, in frames, of the drifting grating
  Eyelink('Message', 'SYNCTIME'); % 
 % status = Eyelink('Message','testing_session %d', testing_session) %
 %% Initialization of the NI
 clc
 disp('****************************************************')
disp('Check Eyelink setting for recording pupil DIAMETER')
 disp('****************************************************')
SamplingRate = 1000; %frerquency expressed in hertz
TriggerDuration = 10 ; %duration expressed in second
Trigger = zeros(TriggerDuration*SamplingRate,1);
Trigger([1:100],1) = 10;

Pinprick.NI = daq.createSession('ni');
Pinprick.NI.Rate = SamplingRate;
Pinprick.Rate = SamplingRate;
addAnalogOutputChannel(Pinprick.NI,'Dev1',0,'Voltage');
addAnalogInputChannel(Pinprick.NI,'Dev1',0,'Voltage');
addAnalogInputChannel(Pinprick.NI,'Dev1',1,'Voltage');

disp('DAQ initialized')
%% Initialisation of the robot
[robot] = initPinprickRobot(ComPort,BaudRate,KindMove); %initialise  robot/open comms
fprintf(robot,['G1 ' 'Y' num2str(round(Y_Center)) ' F2000']);  % Y = 95 from the switch on position to postion the robot in the middle of the foam
fprintf(robot,['G1 ' 'X' num2str(round(X_Center)) ' F2000']); % X= 100 to be in the middle of the X-axis
fprintf(robot,['G1 ' 'Z' num2str(round(Zstart)) ' F2000']); % X= 100 to be in the middle of the X-axis
% [X_Coord2,Y_Coord2,Z_Coord2] = oneMovePinprickRobot(robot,X_Center,Y_Center,Zstart,2000,2000,2000);
pause(7)
%% The experiment itself
blockNum=input('Number of the block?');
edfFile = [char(SubjectName) num2str(blockNum)] ;
eyelinkfilename = [edfFile '.edf'];
Eyelink ('Openfile', eyelinkfilename);
% pause(12)

for j=1:Number_Stimulations % each loop a trial
    fprintf(robot,['G1 ' 'Y' num2str(round(Y_Coord(j))) ' F1500']);  % Y = 95 from the switch on position to postion the robot in the middle of the foam
    fprintf(robot,['G1 ' 'X' num2str(round(X_Coord(j))) ' F1500']); % X= 100 to be in the middle of the X-axis
    % ParallelPort_InpOut('OUTPUT', 8);  
    % pause(0.2)
    % ParallelPort_InpOut('OUTPUT', 0);    %
    %Beginning recording data
    queueOutputData(Pinprick.NI,Trigger);
    prepare(Pinprick.NI);
    pause(2)
    Pinprick.clock_start{j} = clock;
    % trigger for synchronization with EEG via parallel port
    Eyelink('StartRecording');
    Eyelink('CheckRecording');
    [data,time]=Pinprick.NI.startForeground();
    Eyelink('Message', 'start trial');
    disp(['Data Acquisition started - trial number : ' num2str(j)])
    pupilFixationOn
    pause(ISI(j))
    fprintf(robot,['G1' 'Z' num2str(Zend) 'F1000']); % Z=-35 --> contact with the skin / in absolute coordinate
    pause(1.2) %constant
    fprintf(robot,['G1' 'Z' num2str(Zstart) 'F1000']);
    pause(5)
    Pinprick.Xcoord(1,j) = X_Coord(j);
    Pinprick.Ycoord(1,j) = Y_Coord(j);
    Pinprick.Analog1(:,j) = data(:,1);
    Pinprick.Analog2(:,j) = data(:,2);
    Pinprick.Time(:,j) = time;
    Pinprick.clock_stop{j} = clock;
    % slot in function here to remove fixation cross % joe
    pupilFixationOff;
    Eyelink('Message', 'end trial');
    Eyelink('StopRecording');
end
fprintf(robot,['G1 ' 'Y' num2str(round(Y_Coord(j))) ' F2000']);  % Y = 95 from the switch on position to postion the robot in the middle of the foam
fprintf(robot,['G1 ' 'X' num2str(round(X_Coord(j))) ' F2000']); % X= 100 to be in the middle of the X-axis
fprintf(robot,['G1 ' 'Z' num2str(round(0)) ' F2000']); % X= 100 to be in the middle of the X-axis
%% Closing the communication session with the robot and saving the data 
% [X_Coord,Y_Coord,ISI] = makingTrialsPinprickRobot_pupil(robot,Number_Stimulations,X_Center,Y_Center,R_NoStim,R_Stim,ISI_Min,ISI_Max,Zstart,Zend,Plot,blockNum);
[sessionName] = stopPinprickRobot(robot,backHome);
fileName = [SubjectName num2str(blockNum)];
save(SubjectName)

fprintf('Receiving Data File');
Eyelink('closefile')
status = Eyelink('ReceiveFile');
 if status > 0 
     fprintf('status 0')
 end 
 if 2 == exist(edfFile, 'file')
 fprint('Data file can be found', edfFile,pwd);
 end
 Eyelink('shutdown');
 
 save(fileName);