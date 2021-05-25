function [alpha, b, obj, zeroOneAverageLoss] = train_ksvm_sd(X, y, T, c, gamma)

  [row, col] = size (X); 

  a = zeros ( row + 1, 1 );

  K = Kernel(X, gamma);
  
  obj = zeros ( T, 1 );

  zeroOneAverageLoss = zeros( T, 1);

  

  for t = 1 : 1 : T
    
      obj(t) = obj_f(K, y, a, c); 
    
      zeroOneAverageLoss(t) = 1 / row * sum(y ~= sign(a'* [ones(1,length(K));K])');
    
      s1 = [zeros(row+1,1), [zeros(1,row);K]] * a;
    
      s2 = s_hinge(K, y, a, c);
    
      s = s1 + s2;
    
      a = a - 1 / t * s;
    
  end

  b = a (1);
  
  alpha = a (2:end);

end



function v = hinge(t)

  zeros ( length(t), 1 );
 
  i = find ( t < 1 );
 
  v(i) = 1 - t(i);
 
end




function val = obj_f(K,y,a1,c)

  l = length(K);
 
  k1 = [ones(1,l);K];
 
  K_2 = [zeros(l + 1,1),[zeros(1,l);K]];
 
  val = 1/2*(a1' * K_2 * a1) + c * sum (hinge(y'.*(a1'*k1)));
 
end

function [K] = Kernel( X, gamma )

  x_norm = full (sum(X.^2,2));
  
  K = repmat (x_norm,1,size(X,1)) + repmat (x_norm',size(X,1),1) -  2 * full(X*X');
  
  K = exp ( -K * gamma );

end



function v = s_hinge(K,y,a1,c)

   [l] = length(K);
 
   k1 = [ones(1,l);K];
 
   v = zeros(l,1);
 
   t = zeros(l + 1,l);
 
   con = y'.* ( a1' * k1);
  
   i = find ( con < 1 );
 
   t( :,i) = -c * y(i)'.*k1(:,i);
 
   v = sum ( t, 2 );
 
end



