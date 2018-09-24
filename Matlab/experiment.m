%%
clear all;close all;
clc
%% Params
ComPort = 3;
BaudRate = 250000;
KindMove = 0;

SubjectName = 'Trial_Maan';

Number_Stimulations = 5;
X_Center = 190; %in absolute coordinate
Y_Center = 91; %in absolute coordinate
R_NoStim = 10;% [mm]
R_Stim = 20; %[mm]
ISI_Min = 5;
ISI_Max = 8;
Zstart = 21;
Zend = 31;
Plot = 1;
backHome = 1;

%% The experiment itself
[robot] = initPinprickRobot(ComPort,BaudRate,KindMove);
[X_Coord1,Y_Coord1,Z_Coord1] = oneMovePinprickRobot(robot,X_Center,Y_Center,0,2000,2000,2000);
fprintf(robot,'G28');
pause(5)
[X_Coord2,Y_Coord2,Z_Coord2] = oneMovePinprickRobot(robot,X_Center,Y_Center,0,2000,2000,2000);
pause(12)
[X_Coord,Y_Coord,ISI] = makingTrialsPinprickRobot(robot,Number_Stimulations,X_Center,Y_Center,R_NoStim,R_Stim,ISI_Min,ISI_Max,Zstart,Zend,Plot);
[sessionName] = stopPinprickRobot(robot,backHome);

%% Save the data related to the stimulation
save(SubjectName)
