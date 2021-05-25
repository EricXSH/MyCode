 % close all plots
close all
% clear the workspace
clc
clear


% load training and test data
load adult_train_test

% Get number of training samples and their dimension
[m,d]=size(Xtrain);
% Get number of test samples and their dimension
[m2,d2]=size(Xtest);

eta = 1 / 5000;
T = 1000;
w1 = zeros (size (Xtrain,2 ) ,1);
b1 = zeros;

[w,b,obj] = train_logistic_regression_gd(Xtrain,ytrain,eta,T,w1,b1);

% test your solution on the test set
mistakes=0;
for i=1:m2
    % Calculate prediction on test sample i and put it in hat_y
    hat_y = sign ( Xtest(i,:) * w + b);
    
    % Increase the number of mistakes if hat_y is different than ytest(i)
    mistakes = mistakes + (hat_y ~= ytest(i));
end
fprintf('%d mistakes over %d test samples', mistakes, m2);
