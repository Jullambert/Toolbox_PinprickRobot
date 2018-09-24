function [sessionName] = initPinprickRobot(COM,BaudRate,KindMove)
%% initPinprickRobot initiate the communication through serial port with the robot.
% COM = value of the serial COM number while the robot is connected. Go to
% Deice manager (win 7) or Settings>Device to check which port is used for
% the robot
% By default, the baudRate of the communication is set to  115200
% KindMove = 0 if absolute and 1 if incremental

COM = ['COM' num2str(COM)];
sessionName = serial(COM);
set(sessionName,'BaudRate',BaudRate);
fopen(sessionName);
pause(2);
fprintf(sessionName,'G21'); % G-code for working in [mm]
switch KindMove
    case 0
        fprintf(sessionName,'G90');
    case 1
        fprintf(sessionName,'G91');
end