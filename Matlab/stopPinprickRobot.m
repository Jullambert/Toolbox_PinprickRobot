function [sessionName] = stopPinprickRobot(sessionName,backHome)
%% stopPinprickRobot function will close the session of the pinprick robot 
%and if the flag backHome is set, the robot will return to his initial 
%position
if backHome
    fprintf(sessionName,'G28');
%     fprintf(sessionName,'G90'); %91 for incremental positioning, 90 for absolute
%     fprintf(sessionName,'G1 Z0 F1500');  % Y = 95 from the switch on position to postion the robot in the middle of the foam
%     pause(4);
%     fprintf(sessionName,'G1 Y0 F1500');  % Y = 95 from the switch on position to postion the robot in the middle of the foam
%     pause(7);
%     fprintf(sessionName,'G1 X0 F1500'); % X= 100 to be in the middle of the X-axis
%     pause(7);
end
fclose(sessionName);
delete(sessionName);
