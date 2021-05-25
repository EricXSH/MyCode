function [validation_loss] = cross_validation_rls(X, y, lambda, n_folds)
[m,d]=size(X);

loss = 0;
% Divide training data in n_folds folds and for each fold train and record
% validation error. Return the average of the validation losses over the
% folds
% The loss is the square loss

for k=1:n_folds
    % create validation indexes for fold k
    index = X(((k-1) * m/n_folds + 1) : k*m/n_folds,:);
    value  = y(((k-1) * m/n_folds + 1) : k*m/n_folds);

    % create training indexes for fold k
    if k == 1
        t_index = X( (k*m/n_folds+1):m,:);
        y2 = y( (k*m/n_folds+1):m);
        
    end
    
    if k == n_folds
     t_index = X( 1:(k-1) * m/n_folds,:);
     y2 = y( 1:(k-1) * m/n_folds);
    end
    
        t_index= [X( 1:(k-1) * m/n_folds,:); X((k*m/n_folds+1):m,:)];
        y2 = [y( 1:(k-1) * m/n_folds); y((k*m/n_folds+1):m)];
    
    
    % train on the n_folds-1 training folds using RLS 
    [w,b] = train_rls ( t_index, y2 , lambda);
    % test on the validation fold
    loss = loss + mean ( ( value - ( index * w + b)).^2);

end

validation_loss = loss / n_folds;

end 
