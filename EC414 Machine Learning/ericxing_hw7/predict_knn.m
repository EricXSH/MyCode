 function [yhat] = predict_knn(X, y, Xtest, k)
  
     [row, col] = size(X);
     [r, c ] = size (Xtest);
  
    yhat = zeros (r,1);
     for e = 1 : 1 : r
        S = zeros (row, 1);

         for i = 1 : 1 : row
             S(i, :) = norm ( X(i,:) - Xtest(e,:));
         end

         [a, b] = sort (S, 1);
         s = zeros (k,1 );
         for i = 1 : 1 : k
             s(i) = y(b(i));
         end
         q = mode(s);
         yhat(e,:) = q;


     end 
   
 end 
%%
num = [100 1000];
den = conv ([1 50], [1 2]);
sys = tf (num, den);
bode (sys);
grid;
