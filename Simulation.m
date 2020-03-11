% Copyright 2020, All Rights Reserved
% Code by Baolei Wei
% For paper, "On discrete-time grey models: 
% 			  unification, extension and applications"
% by Baolei Wei, Naiming Xie

clc; clear; close
addpath('./utils')
addpath('./results')

%% closed-form solutions for ODE 
syms x1(t) x2(t)                             % time variable 
x = [x1; x2];                                % state variables 
A = [-0.25 0.60; 0.75 -0.25];                % true parameters 
cond = x(0) == [7.0; 5.0];                   % initial condition 
odes = diff(x) == A*x;                       % system of ODEs
[x1Sol(t), x2Sol(t)] = dsolve(odes, cond);   % analytic solution

%%
hSet = [0.05 0.10 0.20];
sigmaSet = [0.5 1.0 1.5];
sss = [10 15 20];
nf = 10;  % forecasting horizon
for i=1:length(hSet)
    % observation equation 
    h = hSet(i);                              % time interval
    ts = (0:h:5)';                            % time span
    x = [eval(subs(x1Sol(t),t,ts)), ...
         eval(subs(x2Sol(t),t,ts)) ];         % numerical values
    ts = ts(1:end-nf);             			  % In-sample time
    xs = x(1:end-nf,:);                       % In-sample period 
    xf = x(end-nf+1:end,:);                   % Out-of-sample period 
    
    for j=1:length(sigmaSet)
        sigma = sigmaSet(j);
        mapeX1 = zeros(500,4);                % [fitting, 1-step, 5-step, 10-step]
        mapeX2 = zeros(500,4);                % [fitting, 1-step, 5-step, 10-step]
        
        for k = 1:500
            rng(k);
            y = xs + sigma*normrnd(0,1,size(xs));          % noisy observations

            [Pi,xshat,xfhat] = dtgm(ts,y,10,h);            % fits and forecasts

            apeIn = abs((xs-xshat)./xs)*100;               % fitting errors
            apeOut = abs((xf-xfhat)./xf)*100;              % forecasting errors
            
            mapeX1(k,:) = [mean(apeIn(2:end,1)) apeOut(1,1) mean(apeOut(1:5,1)) mean(apeOut(1:10,1))];
            mapeX2(k,:) = [mean(apeIn(2:end,2)) apeOut(1,2) mean(apeOut(1:5,2)) mean(apeOut(1:10,2))];
        end
		
        name = sprintf('x1mape_%d_%d.csv', sss(j), 5/h-9); 
        csvwrite(['results/',name], mapeX1)
        name = sprintf('x2mape_%d_%d.csv', sss(j), 5/h-9); 
        csvwrite(['results/',name], mapeX2)
    end
end

%%




