% Method:   compute all normalization matrices.  
%           It is: point_norm = norm_matrix * point. The norm_points 
%           have centroid 0 and average distance = sqrt(2))
% 
%           Let N be the number of points and C the number of cameras.
%
% Input:    points2d is a 3xNxC array. Stores un-normalized homogeneous
%           coordinates for points in 2D. The data may have NaN values.
%        
% Output:   norm_mat is a 3x3xC array. Stores the normalization matriceks
%           for all cameras, i.e. norm_mat(:,:,c) is the normalization
%           matrix for camera c.

function norm_mat = compute_normalization_matrices( points2d )
[~,n,k]=size(points2d);
norm_mat = zeros(3,3,k);
for i = 1:k
    points = points2d(:,:,i);
    c = [];
    for j = 1:n
        if isnan(points(1,j)) == 1
            c = [c j];
        end
    end
    points(:,c) = [];
    [~,n]=size(points);
    p = 1/n*sum(points,2) ;
    sum_d = 0;
    for j = 1:n
        sum_d = sum_d + sqrt(dot(points(:,j)-p,points(:,j)-p));
    end
    d = sum_d/n;
    N = sqrt(2)/d*[1  0 -p(1); 0 1 -p(2); 0 0 d/sqrt(2)];
    norm_mat(:,:,i) = N;
end
%-------------------------
% TODO: FILL IN THIS PART