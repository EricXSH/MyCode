function [w,b,obj] = train_logistic_regression_gd(X,y,eta,T,w0,b0)
w1 = [b0;w0];
[row, col] = size (X);
x1 = [ones(row,1) X];

   for t = 1: 1: T
       a =  sum( log( 1 + exp (-y .* (x1 * w1))));
       g = -sum( (y .* x1) ./ ( 1 + exp (y .*( x1 * w1 ))))';
       w1 = w1  - eta .*g;
       obj(t,:) = a;
   end

w = w1 ( 2 : end );
b = w1 (1,:);
    

    
end

