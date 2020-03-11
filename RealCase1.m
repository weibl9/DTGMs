% Copyright 2020, All Rights Reserved
% Code by Baolei Wei
% For paper, "On novel framework for discrete-time grey models: 
%                         unification, extension and applications"
% by Baolei Wei, Naiming Xie

clc; clear; close all
addpath('./utils')

%% case 1: input-output time series: GMC(1,n) AMC
v = [514 495 444 401 352]';     % input time series for fitting
x = [897 897 890 876 848]';     % output time series for fitting 
 
vf = [293 269 235 201 187]';    % input time series for forecasting 
xs = [814 779 738 669 600]';    % output time series for validating

% fitting and forecasting 
[xf, fitInfo] = dsgxm(x, v, vf); 

xhat = fitInfo.fit;             % fits of x
apeIn = fitInfo.ape;            % fitting APEs
apeOut = abs((xs-xf)./xs)*100;  % forecasting APEs

% fitting and forecating results
format short g
disp(array2table( [x xhat round(apeIn,4)], ...
                  'VariableNames',{'true', 'fitted', 'ape'}) )              
disp(array2table( [xs xf round(apeOut,4)], ...
                  'VariableNames',{'true', 'forecasts', 'ape'}) )

              
              