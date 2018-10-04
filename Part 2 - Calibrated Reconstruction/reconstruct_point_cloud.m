% function model = reconstruct_point_cloud(cam, data)
%
% Method:   Determines the 3D model points by triangulation
%           of a stereo camera system. We assume that the data 
%           is already normalized 
% 
%           Requires that the number of cameras is C=2.
%           Let N be the number of points.
%
% Input:    points2d is a 3xNxC array, storing all image points.
%
%           cameras is a 3x4xC array, where cameras(:,:,1) is the first and 
%           cameras(:,:,2) is the second camera matrix.
% 
% Output:   points3d 4xN matrix of all 3d points.


function points3d = reconstruct_point_cloud( cameras, points2d )

%------------------------------
% TODO: FILL IN THIS PART
Ma = cameras(:,:,1);
Mb = cameras(:,:,2);
N = size(points2d,2);
points3d = zeros(4,N);
for i=1:N
   W = zeros(4,4);
   xa = points2d(1,i,1); 
   ya = points2d(2,i,1);
   xb = points2d(1,i,2); 
   yb = points2d(2,i,2);
   W(1,:) = [xa*Ma(3,1)-Ma(1,1), xa*Ma(3,2)-Ma(1,2),xa*Ma(3,3)-Ma(1,3), xa*Ma(3,4)-Ma(1,4)];
   W(2,:) = [ya*Ma(3,1)-Ma(2,1), ya*Ma(3,2)-Ma(2,2),ya*Ma(3,3)-Ma(2,3), ya*Ma(3,4)-Ma(2,4)];
   W(3,:) = [xb*Mb(3,1)-Mb(1,1), xb*Mb(3,2)-Mb(1,2),xb*Mb(3,3)-Mb(1,3), xb*Mb(3,4)-Mb(1,4)];
   W(4,:) = [yb*Mb(3,1)-Mb(2,1), yb*Mb(3,2)-Mb(2,2),yb*Mb(3,3)-Mb(2,3), yb*Mb(3,4)-Mb(2,4)];
   [~, ~, V] = svd(W);
   h = V(:,end);
   points3d(:,i)=h/h(4);
end

end
