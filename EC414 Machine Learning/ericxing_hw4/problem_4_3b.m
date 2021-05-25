% close all plots
close all
% clear the workspace
clc
clear   

% load training and test data
load adult_train_test

% Get number of training samples and their dimension
[m,d]=size(Xtrain);

eta = 1 / 5000;
T = 1000;

for i=1:10
    % Generate a random vector in R^d for the initial solution
    w1 = randn (size (Xtrain,2 ) ,1);
    % Generate a random real number for the initial bias
    b1 = randn;
    
    % store in the matrix obj the values of the objective function during training
    [w,b,obj(i,:)] = train_logistic_regression_gd(Xtrain,ytrain,eta,T,w1,b1);
end

% Plot the 10 different lines for the objective function 
axis = [1:T];
loglog (axis, obj);


% Save plot in a PNG file
print -dpng logistic_obj.png
