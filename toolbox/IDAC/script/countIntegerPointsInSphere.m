function points = countIntegerPointsInSphere(N, R)
    
    points = [];
    idx = 1;
    for x = -R(2)+N(1): R(2)+N(1)
        for y = -R(2)+N(2): R(2)+N(2)
            for z = -R(2)+N(3): R(2)+N(3)
                if (x-N(1))^2 + (y-N(2))^2 + (z-N(3))^2 <= R(2)^2 && (x-N(1))^2 + (y-N(2))^2 + (z-N(3))^2 >= R(1)^2
                    points(idx, :) = [x,y,z];
                    idx = idx + 1;
                end
            end
        end
    end
    
end