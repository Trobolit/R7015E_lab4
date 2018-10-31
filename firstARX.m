% lets try an arx (1,1,1)
% the output is the engine RPM.
% Lets assume Guassian noise with unintersting variance
% and go straight for Least squares.


% Dont remove mean or min:
% Boom angle deg, boom speed
% Bucket angle deg, bucket speed
% Digging, drive axle speed
% Force lift MN, force tilt MN
% lift joystick, throttle
% tilt joystick

% Center around neutral?
% gear index

% Possible removal of trends:
% Engine speed rps


y = engine_speed_rps- mean(engine_speed_rps);
u = AllData(:,[1:6,8:end]) - mean(AllData(:,[1:6,8:end])); 
%y = u*theta => inv(u)*y = thetahat => 
thetahat = u\y;

figure();
hold on;
plot(engine_speed_rps);
plot(u*thetahat + mean(engine_speed_rps));



disp([thetahat,AllDataNames([1:6,8:end])']);
immse(y, u*thetahat)

y = engine_speed_rps- mean(engine_speed_rps);
u = AllData(:,[1:6,8:end]); 
%y = u*theta => inv(u)*y = thetahat => 
thetahat = u\y;
immse(y, (u*thetahat))
%TODO: I think means may be not re added properly.
plot(u*thetahat + mean(engine_speed_rps));
plot(sim(arx441,u));
legend('real','estimated', 'estimated less means','arx441');
hold off;


%%
% Compare generated arx models

figure();
hold on;

plot(engine_speed_rps)
plot(sim(arx111, u))
plot(sim(arx441, u))
plot(sim(arx10101, u))
plot(sim(arx1001001, u))

legend('real data','111','441','10101','1001001');

hold off;

figure();
hold on;

plot(engine_speed_rps- sim(arx111, u))
plot(engine_speed_rps- sim(arx441, u))
plot(engine_speed_rps- sim(arx10101, u))
plot(engine_speed_rps- sim(arx1001001, u))

legend('111','441','10101','1001001');

hold off;

%%
figure();
histogram(engine_speed_rps- sim(arx111, u))
figure();
histogram(engine_speed_rps- sim(arx441, u))
figure();
histogram(engine_speed_rps- sim(arx10101, u))

%%

% index for start of val data: 10728
testIndexes = 1:10728;
valIndexes = 10729:14002;

ze = iddata(engine_speed_rps(testIndexes,1),AllData(testIndexes,[1:6,8:end]),1);
zv = iddata(engine_speed_rps(valIndexes,1),AllData(valIndexes,[1:6,8:end]),1);
%Generate model-order combinations for:
na = 1;
nb = 0:2;
nk = 1;
disp('starting struc');
clear NN;
NN = struc(na, nb,nb,nb,nb,nb,nb,nb,nb,nb,nb,nb,nb, nk,nk,nk,nk,nk,nk,nk,nk,nk,nk,nk,nk);

disp('starting arxstruc');
%Estimate an ARX model for each model order combination.
V = arxstruc(ze,zv,NN);

disp('slectring order etc');
%Select the model order with the best fit to the validation data.
order = selstruc(V,0);

%Estimate an ARX model of selected order.
M = arx(ze,order);


% When nb 0:1, na 1, nk 1 =>  Polynomial orders:   na=1   nb=[1 0 1 1 1 1 1 1 0 0 1 1]   nk=[1 1 1 1 1 1 1 1 1 1 1 1]
% nb 0:2 (took time!) =>      Polynomial orders:   na=1   nb=[0 2 2 2 2 2 2 2 2 2 2 2]   nk=[1 1 1 1 1 1 1 1 1 1 1 1]
