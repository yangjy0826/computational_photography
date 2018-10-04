% H = compute_rectification_matrix(points1, points2)
%
% Method: Determines the mapping H * points1 = points2
% 
% Input: points1, points2 of the form (4,n) 
%        n has to be at least 5
%
% Output:  H (4,4) matrix 
% 

function H = compute_rectification_matrix( points1, points2 )

%------------------------------
% TODO: FILL IN THIS PART
N = size(points1,2);
W = zeros(3*N,16);
for i=1:N
    x = points1(1,i);
    y = points1(2,i);
    z = points1(3,i);
    w = points1(4,i);
    x_ = points2(1,i);
    y_ = points2(2,i);
    z_ = points2(3,i);
%     w_ = points2(4,i);
    W(i,:) = [x, y, z, w, 0, 0, 0, 0, 0, 0, 0, 0, -x*x_, -y*x_, -z*x_, -w*x_];
    W(i+N,:) = [0, 0, 0, 0, x, y, z, w, 0, 0, 0, 0, -x*y_, -y*y_, -z*y_, -w*y_];
    W(i+2*N,:) =[0, 0, 0, 0, 0, 0, 0, 0, x, y, z, w,-x*z_, -y*z_, -z*z_, -w*z_];
end
[~,~,V] = svd(W);
h = V(:,end);
H = reshape(h,[4,4])';