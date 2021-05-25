clc
clear
close all

rand('state',0)

load cadata_train_test
n_folds = 8;
poly_degree = 10;
lambda = 0.001;



[m,d]=size(Xtrain_norm);

validation_loss = zeros(1,poly_degree);

%shuffle training input and labels
idx=randperm(m);
Xtrain_norm=Xtrain_norm(idx,:);
ytrain=ytrain(idx);


for k = 1 : 1 : poly_degree
    
% generate the polynomial features calling generate_poly_features
  X_poly = generate_poly_features(Xtrain_norm,k);

% Call cross_validation_rls for each degree of the polynomial to try and record the validation loss
  
  validation_loss(k) = cross_validation_rls(X_poly, ytrain, lambda, n_folds);

end


plot( 1 : poly_degree, validation_loss, '- r .');
