% function F = compute_F_matrix(points1, points2);
%
% Method:   Calculate the F matrix between two views from
%           point correspondences: points2^T * F * points1 = 0
%           We use the normalize 8-point algorithm and 
%           enforce the constraint that the three singular 
%           values are: a,b,0. The data will be normalized here. 
%           Finally we will check how good the epipolar constraints:
%           points2^T * F * points1 = 0 are fullfilled.
% 
%           Requires that the number of cameras is C=2.
% 
% Input:    points2d is a 3xNxC array storing the image points.
%
% Output:   F is a 3x3 matrix where the last singular value is zero.

function F = compute_F_matrix( points2d )


%------------------------------
% TODO: FILL IN THIS PART
C = size(points2d,3);
if C~=2
    msg = 'Requires that the number of cameras is C=2.';
    error(msg)
end
N = size(points2d,2);

normalization = true;
correctness = true;
check_epipolar = true;

Num_points = N;
% sprev = rng(12,'v5uniform');
% index  = randperm(N,Num_points);
index = 1:N;
% index = 1:floor(N/8):floor(N/8)*8;
points1 = points2d(:,:,1);
points2 = points2d(:,:,2);


if normalization
    % to improve accuracy by normalization
    norm1 = compute_normalization_matrices( points1);
    norm2 = compute_normalization_matrices( points2);
    points1 = norm1 * points1;
    points2 = norm2 * points2;
end

% form matrix W
W = zeros(Num_points,9);
for i = 1:Num_points
    xa = points1(1,index(i));
    ya = points1(2,index(i));
    xb = points2(1,index(i));
    yb = points2(2,index(i));
    W(i,:) = [xb*xa, xb*ya, xb, yb*xa, yb*ya, yb, xa, ya, 1];  
end
[~, ~, V] = svd(W);

h = V(:,end);
F = reshape(h,[3,3])';
if normalization
    F = norm2'*F*norm1;
end
if correctness
    [U, S, V] = svd(F);
    F = U *[S(1,1),0,0;0,S(2,2),0;0,0,0]*V'; 
end

if check_epipolar
    % check epipolar constraint
    check_epipolar = zeros(N,1);
    for i = 1:N
        if normalization
           points2(:,i) =  pinv(norm2)*points2(:,i);
           points1(:,i) =  pinv(norm1)*points1(:,i);
        end
        check_epipolar(i)= points2(:,i)'*F*points1(:,i);
        
    end
    fprintf(' EPIPOLAR CONSTRAINT ERROR \n')
    max_epipolar_constraint_error = max(check_epipolar)
end

end