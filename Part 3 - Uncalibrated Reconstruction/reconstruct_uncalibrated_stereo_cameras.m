% function [cams, cam_centers] = reconstruct_uncalibrated_stereo_cameras(F); 
%
% Method: Calculate the first and second uncalibrated camera matrix
%         from the F-matrix. 
% 
% Input:  F - Fundamental matrix with the last singular value 0 
%
% Output:   cams is a 3x4x2 array, where cams(:,:,1) is the first and 
%           cams(:,:,2) is the second camera matrix.
%
%           cam_centers is a 4x2 array, where (:,1) is the first and (:,2) 
%           the second camera center.

function [cams, cam_centers] = reconstruct_uncalibrated_stereo_cameras( F )


%------------------------------
% TODO: FILL IN THIS PART
I = eye(3);
Ma = cat(2,I,[0;0;0]);
S = [0,-1,1;1,0,-1;-1,1,0];
[~,~,V] = svd(F');
h = V(:,end);
Mb = cat(2, S*F, h);
[~,~,V1] = svd(Ma);
ta = V1(:,end);
[~,~,V2] = svd(Mb);
tb = V2(:,end);
cams(:,:,1) = Ma;
cams(:,:,2) = Mb;
cam_centers(:,1) = ta;
cam_centers(:,2) = tb;

end