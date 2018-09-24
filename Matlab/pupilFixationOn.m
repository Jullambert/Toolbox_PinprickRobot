

screens      = Screen ('Screens');
screenNumber = max (screens);
white = WhiteIndex (screenNumber);
black = BlackIndex (screenNumber);
gray = (white + black)/2;
sigma       = 5.0;
if round (gray) == white
    gray = black;
end
inc = white - gray;
fix_mat = [Circle(6)];
[x, y] = meshgrid (-20:20, -20:20);
m      = exp ((-x.^2 - y.^2)/(2*sigma^2));
m1     = x ./x;
% [w, wRect]      = Screen ('OpenWindow', screenNumber, 0, [], 32, 2);
[width, height] = Screen ('WindowSize', w);
fix_cord        = [width/2-2 width/2+2];
fix1      = Screen ('MakeTexture', w, gray - inc*fix_mat);
tex       = Screen ('MakeTexture', w, gray + inc*m);
frameRate = Screen ('FrameRate', screenNumber);

%Screen ('FillRect', w, gray);
%Screen ('Flip', w);
% waitsecs(1)
  Screen ('FillRect', w, gray);
  Screen ('DrawTexture', w, fix1);
  Screen ('Flip', w);
