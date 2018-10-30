% lets try an arx (1,1,1)
% the output is the engine RPM.
% Lets assume Guassian noise with unintersting variance
% and go straight for Least squares.

y = engine_speed_rps- mean(engine_speed_rps);
u = AllData(:,[1:6,8:end]) - mean(AllData(:,[1:6,8:end])); 

%y = u*theta => inv(u)*y = thetahat => 
thetahat = u\y;

figure();
hold on;
plot(engine_speed_rps);
plot(u*thetahat + mean(engine_speed_rps));
legend('real','estimated');
hold off;
disp([thetahat,AllDataNames([1:6,8:end])']);
immse(y, u*thetahat + mean(engine_speed_rps))

%TODO: I think means may be not re added properly.