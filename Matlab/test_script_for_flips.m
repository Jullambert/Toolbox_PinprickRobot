


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
global w
[w, wRect]      = Screen ('OpenWindow', screenNumber, 0, [], 32, 2);


[width, height] = Screen ('WindowSize', w);
fix_cord        = [width/2-2 width/2+2];

fprintf ('\n%s%4d', 'screen width:  ', width);
fprintf ('\n%s%4d', 'screen height: ', height);
fprintf ('\n');



for i =1:5
    
   waitsecs(0.5)
   pupilFixationOn
   waitsecs(0.5)
   PupilFixationOff
    
end
    

close all, clear all