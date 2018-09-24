% Test script for exercise 2

clear all                   % Remove all old variables
close all                   % Close all figures
clc                         % Clear the command window
addpath( genpath( '../' ) );% Add paths to all subdirectories of the parent directory

REFERENCE_VIEW      = 1;
CAMERAS             = 2;

load( '../debug/part2/points2d.mat'         );
load( '../debug/part2/E.mat'                );
load( '../debug/part2/cameras.mat'          );
load( '../debug/part2/camera_centers.mat'   );
load( '../debug/part2/points3d.mat'         );

K = zeros(3,3,CAMERAS);
K(:,:,1) = [2250    0 400;
               0 2250 300;
               0    0   1];
K(:,:,2) = K(:,:,1);

%% Test the function compute_E_matrix

fprintf('------------------------\n')
fprintf(' ESSENTIAL MATRIX ERROR \n')
fprintf('------------------------\n')

E_test = compute_E_matrix( points2d, K );

E      = fix_homogeneous_scale( E      );
E_test = fix_homogeneous_scale( E_test );

E_error = E - E_test

%% Test the function reconstruct_point_cloud

fprintf('----------------------------------\n')
fprintf(' POINT CLOUD RECONSTRUCTION ERROR \n')
fprintf('----------------------------------\n')

points3d_test = reconstruct_point_cloud( cameras, points2d );

points3d_cartesian      = homogeneous_to_cartesian( points3d(:,1:8)      );
points3d_test_cartesian = homogeneous_to_cartesian( points3d_test(:,1:8) );

point_cloud_error = points3d_cartesian - points3d_test_cartesian


%% Test the function reconstruct_stereo_cameras 

fprintf('-----------------------------\n')
fprintf(' CAMERA RECONSTRUCTION ERROR \n')
fprintf('-----------------------------\n')

[cameras_test camera_centers_test] = ...
    reconstruct_stereo_cameras( E, K, points2d(:,1,:) );

for c=1:CAMERAS
    cameras(:,:,c)           = fix_homogeneous_scale( cameras(:,:,c)           );
    cameras_test(:,:,c)      = fix_homogeneous_scale( cameras_test(:,:,c)      );
    camera_centers(:,c)      = fix_homogeneous_scale( camera_centers(:,c)      );
    camera_centers_test(:,c) = fix_homogeneous_scale( camera_centers_test(:,c) );
end

cameras_error        = cameras        - cameras_test
camera_centers_error = camera_centers - camera_centers_test

%% Test the function check_reprojection_error

fprintf('---------------------------\n')
fprintf(' RE-PROJECTION ERROR ERROR \n')
fprintf('---------------------------\n')

[error_average_test error_max_test] = check_reprojection_error( points2d, cameras, points3d );

fprintf( 'The true average error is:     %3.1f\n', 25.3899              )
fprintf( 'The computed average error is: %3.1f\n', error_average_test   )

fprintf( 'The true max error is:         %3.1f\n', 43.6813              )
fprintf( 'The computed max error is:     %3.1f\n', error_max_test       )







