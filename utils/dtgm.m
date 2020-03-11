function [Pi,xhat,xf] = dtgm(ts,x,nf,h)
% Copyright 2020, All Rights Reserved
% Code by Baolei Wei
% For paper, "On novel framework for discrete-time grey models: 
%                         unification, extension and applications"
% by Baolei Wei, Naiming Xie

% ts: time instant series 
% x:  multi-variable time series
% nf: forcasting steps
% h: time interval in ts 

% Pi: estimated parameters
% xhat: fitted series corresponding to x
% xf:   forecasting series with length nf 


[nobs,nvar] = size(x);

% step 1: cumulative sum 
y = zeros(nobs,nvar);
for icol=1:nvar
    y(:,icol) = cumsum([1;diff(ts)].*x(:,icol)); % time iterval
end

% step 2: least-square estimates 
Theta = [y(1:end-1,:), ones(nobs-1,1)];
Pi = Theta\x(2:end,:);

% step 3: fits
xhat = [nan nan; Theta*Pi];

% step 4: recursive forecasts
yn = y(nobs,:);
xf = zeros(nf,2);

for irow=1:nf
    if irow == 1
        xf(irow,:)=[yn 1]*Pi; 
    else
        xf(irow,:)=[yn+h*sum(xf) 1]*Pi;
    end
end

end












