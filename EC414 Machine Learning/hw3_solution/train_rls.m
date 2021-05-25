function [w, b] = train_rls(X, y, lambda)
%train_rls ridge regression
%   X: training data matrix m*d
%   y: label vector m*1
%   lambda: regularization parameter
%   w: coefficients
%   b: bias
[m,d] = size(X);
Xtilde = [ones(m,1) X];
C = Xtilde'*Xtilde + [0 zeros(1,d); zeros(d,1) lambda*eye(d)];
% the pseudo-inverse works also when C is not invertible
wtilde = pinv(C)*Xtilde'*y;
b = wtilde(1);
w = wtilde(2:end);
end

