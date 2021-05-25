function [X_poly] = generate_poly_features(X,k)


X_poly = X;

for i = 2 : 1 : k
    
    a = X .^i;
    
    X_poly = [ X_poly a]; 


end

end 

