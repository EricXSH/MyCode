function [c,obj,y] = k_means_clustering(X, c0, T)
    [row, col] = size (X);
    [k, d] = size (c0);
    y = zeros (row,1);
    obj = 0;
    
    for ite = 1 : 1 : T
        for i = 1 : 1 : row
            dist = zeros (k,1);
            for j = 1 : 1 : k
                dist(j,:) = norm (X(i,:) - c0(j,:));
            end
            [a,b] = min (dist);
            y(i,:) = b(1);
            obj = obj + a;
        end
        
        new_c = zeros(k,d);
        for i = 1 : 1 : k
            new_c(i,:) = mean(X(y == i,:));
        end
        
        c0 = new_c;
    end
    
    c = c0;
end 