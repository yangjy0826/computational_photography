% function [error_average, error_max] = check_reprojection_error(data, cam, model)
%
% Method:   Evaluates average and maximum error 
%           between the reprojected image points (cam*model) and the 
%           given image points (data), i.e. data = cam * model 
%
%           We define the error as the Euclidean distance in 2D.
%
%           Requires that the number of cameras is C=2.
%           Let N be the number of points.
%
% Input:    points2d is a 3xNxC array, storing all image points.
%
%           cameras is a 3x4xC array, where cams(:,:,1) is the first and 
%           cameras(:,:,2) is the second camera matrix.
%
%           point3d 4xN matrix of all 3d points.
%       
% Output:   
%           The average error (error_average) and maximum error (error_max)
%      

function [error_average, error_max] = check_reprojection_error( points2d, cameras, point3d )

%------------------------------
% TODO: FILL IN THIS PART
N = size(point3d, 2);
Error = zeros(N,2);
for i = 1:N
    points2d1 = cameras(:,:,1)*point3d(:,i);
%     points2d1 = points2d1/points2d1(end);
    points2d1 = homogeneous_to_cartesian(points2d1);
    points2d2 = cameras(:,:,2)*point3d(:,i);
%     points2d2 = points2d2/points2d2(end);
    points2d2 = homogeneous_to_cartesian(points2d2);
     points2d1_ = homogeneous_to_cartesian(points2d(:,i,1));
     points2d2_ = homogeneous_to_cartesian(points2d(:,i,2));
    Error(i,1) = sqrt(sum((points2d1_ - points2d1).^2));
    Error(i,2) = sqrt(sum((points2d2_ - points2d2).^2));
%     Error(i,1) = sqrt(sum((points2d(:,i,1) - points2d1).^2));
%     Error(i,2) = sqrt(sum((points2d(:,i,2) - points2d2).^2));
end
error_max = max(max(Error))
error_average = mean(mean(Error))
end