% pointsCartesian = homogeneous_to_cartesian( pointsHomogeneous )
%
% Convert from homogeneous coordiantes to Cartesian coordinates. We check
% additionally that the last homogeneous coordinate is bigger than eps.
% 
% pointsHomogeneous     (DIMENSIONS+1)xPOINTS array.
% 
% pointsCartesian       DIMENSIONSxPOINTS array.

function pointsCartesian = homogeneous_to_cartesian( pointsHomogeneous )

POINTS = size( pointsHomogeneous, 2 );

%DIMENSIONS = size( pointsHomogeneous, 1 ) - 1;
%if DIMENSIONS ~= 2 && DIMENSIONS ~= 3
%    error( 'Sorry but the dim of the data has to be 3 or 4' );
%end
        
pointsCartesian = pointsHomogeneous(1:end-1,:);
for n = 1:POINTS
    OK_NUMBERS = sum( isnan( pointsHomogeneous(:,n) ) ) == 0;
    if OK_NUMBERS
        s = pointsHomogeneous(end,n);
        if  abs(s) > eps
            pointsCartesian(:,n) = pointsCartesian(:,n) / s; 
        else
            warning( 'A model point is at infity - we leave it !' );
        end
    end
end
