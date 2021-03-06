function [X_Coord,Y_Coord,ISI] = makingTrialsPinprickRobot_pupil(sessionName,Number_Stimulations,X_Middle,Y_Middle,R_NoStim,R_Stim,ISI_Min,ISI_Max,Zstart,Zend,Plot,blockNum)
%% makingTrialsPinprickRobot create a block of movements designed for a pinprick experiment.
% Number_Stimulations is the number of stimulation delivered within the
% block
% X_Middle,in absolute coordinate, define the X origin of the two circles for
% the stimulation
% Y_Middle ,in absolute coordinate, define the Y origin of the two circles for
% the stimulation
% R_NoStim in [mm], is the radius whithin which no stimulations will be
% delivered
% R_Stim in [mm], is the radius of the external circle whithin which 
% stimulations will be delivered
% ISI_Min and ISI_Max define, in [s], the range of inter stimulaus interval
% for the stimulations
% Plot is a flag defined to create a figure with the positions of the 
% stimulations delivered by the robot
% exemple : 
%[X_Coord,Y_Coord,ISI] = makingTrialsPinprickRobot(20,175,108,10,20)
% Julien Lambert 2016


%% added by Joe
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

%
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


   eyelinkfilename = [edfFile num2str(blockNum)];
   Eyelink ('Openfile', eyelinkfilename);

   EyelinkDoTrackerSetup (el);
   status = Eyelink ('command', 'link_sample_data = LEFT,RIGHT,GAZE,AREA');

  numFrames = 1; % temporal period, in frames, of the drifting grating
  Eyelink('Message', 'SYNCTIME'); % 

 % status = Eyelink('Message','testing_session %d', testing_session) %
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
X_Coord = X_Coord+X_Middle;
Y_Coord = Y_Coord+Y_Middle;

for j=1:Number_Stimulations % each loop a trial
    
 % slot in a function here to draw fixation cross % joe
 pupilFixationOn
% typical block of movement for one trial

% remove bottom open brackets
% trigger for synchronization with EEG via parallel port
ParallelPort_InpOut('OUTPUT', 8); Eyelink('Message', 'start trial'); % 
pause(0.2)
ParallelPort_InpOut('OUTPUT', 0);    %

fprintf(sessionName,['G1 ' 'Y' num2str(round(Y_Coord(j))) ' F1500']);  % Y = 95 from the switch on position to postion the robot in the middle of the foam
fprintf(sessionName,['G1 ' 'X' num2str(round(X_Coord(j))) ' F1500']); % X= 100 to be in the middle of the X-axis
pause(ISI(j)) %random pause between 3 and 6 secondes
fprintf(sessionName,['G1' 'Z' num2str(Zend) 'F1000']); % Z=-35 --> contact with the skin / in absolute coordinate
pause(1.2) %constant
fprintf(sessionName,['G1' 'Z' num2str(Zstart) 'F1000']);
waitsecs(10)
% slot in function here to remove fixation cross % joe
pupilFixationOff; Eyelink('Message', 'end trial');
 % just to show concept - jb
end

%%Check 
if Plot
    R1 = R_NoStim;
    Theta1 = 0:0.1:2*pi;
    X1 = X_Middle+ R1.*cos(Theta1); 
    Y1 = Y_Middle+ R1.*sin(Theta1);
    R2 = R_Stim;
    X2 = X_Middle + R2.*cos(Theta1); 
    Y2 = Y_Middle + R2.*sin(Theta1);
    figure
    plot(X1,Y1,'r')
    hold on
    plot(X2,Y2,'r')
    for i=1:Number_Stimulations
    plot(X_Coord(i),Y_Coord(i),'*')
    text(X_Coord(i),Y_Coord(i),num2str(i))
    end
end

fprintf('Receiving Data File');

status = Eyelink('ReceiveFile');

 if status > 0 
     fprintf('status 0')
 end
 
 if 2 == exist(edfile, 'file')
 fprint('Data file can be found', edfFile,pwd);
 end
 
 







