function [X_Coord,Y_Coord,Z_Coord] = oneMovePinprickRobot(sessionName,X_Coord,Y_Coord,Z_Coord,X_Velocity,Y_Velocity,Z_Velocity)
%% oneMovePinprickRobot allow to define the X,Y,Z coordinates and velocities for one movement of the robot.
% sessionName refer to the name of the communication session initiated
% thanks to the function initPinprickRobot

fprintf(sessionName,['G1 ' 'X' num2str(round(X_Coord)) ' F' num2str(X_Velocity)]); % X= 100 to be in the middle of the X-axis
fprintf(sessionName,['G1 ' 'Y' num2str(round(Y_Coord)) ' F' num2str(Y_Velocity)]);  % Y = 95 from the switch on position to postion the robot in the middle of the foam
fprintf(sessionName,['G1' 'Z' num2str(round(Z_Coord)) ' F' num2str(Z_Velocity)]); % Z=-35 --> contact with the skin / in absolute coordinate
