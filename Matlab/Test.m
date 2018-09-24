%% Create Pinprick Robot Stimulations

Number_Stimulation = 20;
X_Middle = 100;
Y_Middle = 95;
R_NoStim = 10;% [mm]
R_Stim = 20; %[mm]


ISI = randi([3,6],20,1);

R = randi([R_NoStim,R_Stim],Number_Stimulation,1); %produces a random vector whose length is <=radius
Theta = randn(Number_Stimulation,1).*2.*pi; % produces a random angle
for i=1:Number_Stimulation
X_Coord(i,1) = R(i).*cos(Theta(i)); %calculate x coord
Y_Coord(i,1) = R(i).*sin(Theta(i)); % calculate y coord
end

n=1;
while n<Number_Stimulation
    n=n+1;
    if ((X_Coord(n-1)==X_Coord(n)) && (Y_Coord(n-1)==Y_Coord(n)))||(abs(X_Coord(n-1)-X_Coord(n))<2 && abs(Y_Coord(n-1)-Y_Coord(n))<2)
        R = randi([R_NoStim,R_Stim],Number_Stimulation,1); %produces a random vector whose length is <=radius
        Theta = randn(Number_Stimulation,1).*2.*pi; % produces a random angle
        for i=1:Number_Stimulation
            X_Coord = R(i).*cos(Theta(i)); %calculate x coord
            Y_Coord = R(i).*sin(Theta(i)); % calculate y coord
        end
    end    
end
X_Coord = X_Coord+X_Middle;
Y_Coord = Y_Coord+Y_Middle;

for j=1:Number_Stimulation
% typical block of movement for one trial

fprintf(robot,['G1 ' 'Y' num2str(round(Y_Coord(j),2)) ' F1000']);  % Y = 95 from the switch on position to postion the robot in the middle of the foam
fprintf(robot,['G1 ' 'X' num2str(round(X_Coord(j),2)) ' F1000']); % X= 100 to be in the middle of the X-axis
pause(ISI(j)) %random pause between 3 and 6 secondes
fprintf(robot,'G1 Z-20 F1000'); % Z=-20 --> contact with the skin
pause(1.6) %constant
fprintf(robot,'G1 Z20 F1000');
end

%%Check 
R1 = 10;
Theta1=0:0.1:2*pi;
X1= R1.*cos(Theta1); 
Y1 = R1.*sin(Theta1);
R2 = 20;
X2= R2.*cos(Theta1); 
Y2 = R2.*sin(Theta1);
figure
plot(X1,Y1,'r')
hold on
plot(X2,Y2,'r')
plot(X_Coord,Y_Coord,'*')