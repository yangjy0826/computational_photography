% function [err2d_mean, err2d_max] = check_error_homographies(H, points1, points2); 
%
% Method: Evaluates average and maximum error 
%         between two point sets connected by a homography:
%         H * points1 ~ points2, 
%         if one of the points is NaN it is ignored 
%
% Input:  H (3,3) matrix 
%         points1, points2 of the form (3,n) 
%       
% Output: the mean error (err2d_mean) and max error (err2d_max)
%      

function [err2d_mean, err2d_max] = check_error_homographies(H, points1, points2); 

% get Info 
am_points = size(points1,2);

% initialize 
err2d_mean = 0; 
err2d_max=0; 
count_points = 0;

% map all the points 
points1_map = H * points1; 

for hi1 = 1:am_points
  if (sum(isnan(points1_map(:,hi1) + points2(:,hi1))) == 0)
    if (and( (abs(points1_map(3,hi1)) > eps), (abs(points2(3,hi1)) > eps) ) )
      hv1 =  points1_map(:,hi1) / points1_map(3,hi1);
      hv2 =  points2(:,hi1) / points2(3,hi1);
      hd1 = sum((hv1-hv2).^2);
      err2d_mean = err2d_mean + sqrt(hd1);
    else
      warning('A point is in the image at infinity - add 1e10');
      hd1 = 1e10; 
      err2d_mean = err2d_mean + 1e10; 
    end

    if (err2d_max < sqrt(hd1))
        err2d_max = sqrt(hd1);
    end
    count_points = count_points + 1; 
  end
end

% final error
err2d_mean = err2d_mean / count_points;

