%% Same as above, but input output is offset one idex to accurately be predictive data
y = engine_speed_rps(2:end)- mean(engine_speed_rps(2:end));
u = AllData(1:end-1,[1:6,8:end]) - mean(AllData(1:end-1,[1:6,8:end])); 

testIndexes = 1:10728;
valIndexes = 10729:14001;

ze = iddata(y(testIndexes,1),u(testIndexes,:),1);
zv = iddata(y(valIndexes,1),u(valIndexes,:),1);
%Generate model-order combinations for:
na = 1:4;
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
M = arx(ze,order)

% na 1, nb 0:1, nk 1 => Polynomial orders:   na=1   nb=[1 0 1 0 1 1 1 1 0 0 1 1]   nk=[1 1 1 1 1 1 1 1 1 1 1 1]
% Fit to estimation data: 93.14% (prediction focus), FPE: 0.07482, MSE: 0.07468 
% same, but nb 0:2 =>   Polynomial orders:   na=1   nb=[2 2 2 2 2 2 1 2 2 1 2 1]   nk=[1 1 1 1 1 1 1 1 1 1 1 1]
% Fit to estimation data: 93.58% (prediction focus), FPE: 0.06578, MSE: 0.06549  


autocorr(y - sim(M,u ), 'NumLags',1000)