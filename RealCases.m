% Copyright 2020, All Rights Reserved
% Code by Baolei Wei
% For paper, "On novel framework for discrete-time grey models: 
%                         unification, extension and applications"
% by Baolei Wei, Naiming Xie

clc; clear; close
addpath('./utils')

%% Cases 
ncase = 3;  % 1 2 3
switch ncase
    case 1  % compared with grey prediction model GMC(1,n)
    vvf = [555 477 444 415 363  302 277 255 223 201]';
    xxs = [1931 1724 1517 1345 1207  1069 952 848 745 669]';

    ns = 5; 
    v = vvf(1:ns); vf = vvf(ns+1:end);
    x = xxs(1:ns); xs = xxs(ns+1:end);
    
    case 2 % compared with grey prediction model IGDMC(1,n)
    vvf = [285 285 280 275 270 260 240  230 215 200 190 185]';
    xxs = [896 979 966 952 924 890 848  793 745 697 662 635]';

    ns = 7;
    v = vvf(1:ns); vf = vvf(ns+1:end);
    x = xxs(1:ns); xs = xxs(ns+1:end);
    
    case 3 % compared with grey prediction model FGMC(1,n)		
    vvf = [401 388 375 375 363   352 321 293 269 229]';
    xxs = [1297 1283 1269 1242 1214   1166 1104 1007 897 759]';
    
    ns = 5;
    v = vvf(1:ns); vf = vvf(ns+1:end);
    x = xxs(1:ns); xs = xxs(ns+1:end);
end

%% Fitting and Forecasting 
[xf, fitInfo] = dsgxm(x, v, vf); 

xhat = fitInfo.fit;             % fits of x
apeIn = fitInfo.ape;            % fitting APEs
apeOut = abs((xs-xf)./xs)*100;  % forecasting APEs

% fitting and forecating results
format short g
disp(array2table( [x xhat round(apeIn,4)], ...
                  'VariableNames',{'true', 'fits', 'ape'}) )              
disp(array2table( [xs xf round(apeOut,4)], ...
                  'VariableNames',{'true', 'forecasts', 'ape'}) )

% fitInfo.par
[mean(apeIn(2:end)) mean(apeOut)]











