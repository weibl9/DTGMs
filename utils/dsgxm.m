function [xf, fitInfo] = dsgxm(x, v, vf)
% Copyright 2020, All Rights Reserved
% Code by Baolei Wei
% For paper, "On novel framework for discrete-time grey models: 
%                         unification, extension and applications"
% by Baolei Wei, Naiming Xie

% x:  response [x]
% v:  input matrix [v1 v2]
% vf: input vector 

% Pi: estimated parameters
% xf: forecasting series with length nf 

%% fitting model: in-sample time series
% cumulative sum 
y = cumsum(x);

% close neighbour means for input matrix
u = cumsum(v);
z = (u(1:end-1,:)+u(2:end,:))/2;

% least squares estimation
Theta = [y(1:end-1) z ones(size(z,1),1)];
Pi = Theta\x(2:end);

% fitted values
xhat = [nan; Theta*Pi];
ape = abs((x-xhat)./x)*100;

%% recursive extrapolation: out-of-sample time series
yn = y(end,:);      % fixed last sample of response
vn = v(end,:);      % fixed last sample of input matrix

zf = z(end,:)+( cumsum([vn;vf(1:end-1,:)])+cumsum(vf) )/2;
xf = zeros(size(vf,1),1);
for k=1:length(vf)
%     if k == 1
%         xf(k) = [yn zf(k) 1]*Pi;
%     else
        xf(k) = [yn+sum(xf) zf(k,:) 1]*Pi; % note: sum(xf)=0 when k=1
%     end
end

%% return results
fitInfo.par = Pi;
fitInfo.fit = xhat;
fitInfo.ape = ape;

end

