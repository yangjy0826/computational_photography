% function [cams, cam_centers] = reconstruct_stereo_cameras(E, K1, K2, data); 
%
% Method:   Calculate the first and second camera matrix. 
%           The second camera matrix is unique up to scale. 
%           The essential matrix and 
%           the internal camera matrices are known. Furthermore one 
%           point is needed in order solve the ambiguity in the 
%           second camera matrix.
%
%           Requires that the number of cameras is C=2.
%
% Input:    E is a 3x3 essential matrix with the singular values (a,a,0).
%
%           K is a 3x3xC array storing the internal calibration matrix for
%           each camera.
%
%           points2d is a 3xC matrix, storing an image point for each camera.
%
% Output:   cams is a 3x4x2 array, where cams(:,:,1) is the first and 
%           cams(:,:,2) is the second camera matrix.
%
%           cam_centers is a 4x2 array, where (:,1) is the first and (:,2) 
%           the second camera center.
%

function [cams, cam_centers] = reconstruct_stereo_cameras( E, K, points2d )

%------------------------------
% TODO: FILL IN THIS PART
verify = true;
Ma = K(:,:,1) * [1,0,0,0;0,1,0,0;0,0,1,0];
[U, S, V] = svd(E);
t = V(:, end);
I = eye(3,3);
W = [0,-1,0;1,0,0;0,0,1];
R1 = U*W*V';
R2 = U*W'*V';
if (det(R1)~=1)
% if (det(R1)==-1)
    R1 = -1*R1;
end
if (det(R2)~=1)
    R2 = -1*R2;
end
Mb = zeros(3,4,4);
Mb(:,:,1) = K(:,:,2)*R1*cat(2,I,t);   % center_cam2 = -t
Mb(:,:,2) = K(:,:,2)*R1*cat(2,I,-t);  % center_cam2 = t
Mb(:,:,3) = K(:,:,2)*R2*cat(2,I,t);   % center_cam2 = -t   rotation 180
Mb(:,:,4) = K(:,:,2)*R2*cat(2,I,-t);  % center_cam2 = t    rotation 180

for i=1:4
   cams =  zeros(3,4,2);
   cams(:,:,1) =Ma;
   cams(:,:,2) =Mb(:,:,i);
   cam_centers = zeros(4,2);
   cam_centers(:,1) = [0,0,0,1]';
   cam_centers(:,2) = [(-1)^i*t;1];
   points3d= reconstruct_point_cloud( cams, points2d );
   
   points3d_a = pinv(K(:,:,1))*cams(:,:,1)*points3d;
   points3d_b = pinv(K(:,:,2))*cams(:,:,2)*points3d;
   
   if ((points3d_a(3)>0) && (points3d_b(3)>cam_centers(3,2)))
        break
   end

   if verify
      scale_factor = ( R2 * [0,-t(3),t(2);t(3),0,-t(1);-t(2),t(1),0])./E;
      scale_factor = scale_factor/scale_factor(1,1)
   end
   
end

end


