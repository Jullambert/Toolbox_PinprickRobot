%%
clear all;close all;
clc
%% Params
ComPort = 3;
BaudRate = 250000;
KindMove = 0;

SubjectName = 'Trial_Maan_Setup';

Number_Stimulations = 5;
X_Center = 160; %in absolute coordinate
Y_Center = 88; %in absolute coordinate
R_NoStim = 10;% [mm]
R_Stim = 20; %[mm]
ISI_Min = 5;
ISI_Max = 8;
Zstart = 13;
Zend = 23;
Plot = 1;
backHome = 1;
%Setting up the parallel port
ParallelPort_InpOut('init', 'C:\Users\Butler\Documents\MATLAB\ParallelPort_InpOut\inpoutx64.dll', hex2dec('BFF8'));
ParallelPort_InpOut('OUTPUT', 0)


%% The experiment itself


blockNum=input('Number of the block?');
[robot] = initPinprickRobot(ComPort,BaudRate,KindMove); %initialise  robot/open comms


[X_Coord1,Y_Coord1,Z_Coord1] = oneMovePinprickRobot(robot,X_Center,Y_Center,0,2000,2000,2000);
pause(5)%[X_Coord2,Y_Coord2,Z_Coord2] = oneMovePinprickRobot(robot,X_Center,Y_Center,0,2000,2000,2000);
pause(12)
[X_Coord,Y_Coord,ISI] = makingTrialsPinprickRobot_pupil(robot,Number_Stimulations,X_Center,Y_Center,R_NoStim,R_Stim,ISI_Min,ISI_Max,Zstart,Zend,Plot,blockNum);
[sessionName] = stopPinprickRobot(robot,backHome);
%% Save the data related to the stimulation
save(SubjectName)
