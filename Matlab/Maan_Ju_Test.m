% !!! Coordinates are relative to the previous postion of the robot !!!!
% Coordinates are expressed in mm

robot = serial('COM3');
set(robot,'BaudRate',115200);
fopen(robot);
pause(2);
fprintf(robot,'G90'); %91 for incremental positioning, 90 for absolute
fprintf(robot,'G1 Y108 F1000');  % Y = 95 from the switch on position to postion the robot in the middle of the foam
pause(4);
fprintf(robot,'G1 X175 F1000'); % X= 100 to be in the middle of the X-axis
pause(5);
fprintf(robot,'G1 Z-35 F1000'); % Z=-20 --> contact with the skin
pause(1.6)
fprintf(robot,'G1 Z-15 F1000'); % Z=20 --> back to the previous position 
pause(3);

%(55,18,-15) coordinate init position
% typical block of movement for one trial
fprintf(robot,'G1 Y-5 F1000');  % Y = 95 from the switch on position to postion the robot in the middle of the foam
fprintf(robot,'G1 X5 F1000'); % X= 100 to be in the middle of the X-axis
pause(4) %random pause between 3 and 6 secondes
fprintf(robot,'G1 Z-20 F1000'); % Z=-20 --> contact with the skin
pause(1.6) %constant
fprintf(robot,'G1 Z20 F1000');

fclose(robot);
delete(robot);
clear robot;


%G91 G21 G01 Y10 F500


