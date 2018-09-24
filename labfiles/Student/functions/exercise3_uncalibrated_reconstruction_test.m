% Test script for exercise 3

clear all                   % Remove all old variables
close all                   % Close all figures
clc                         % Clear the command window
addpath( genpath( '../' ) );% Add paths to all subdirectories of the parent directory

REFERENCE_VIEW      = 1;
CAMERAS             = 2;

load( '../debug/part3/points2d.mat'              );
load( '../debug/part3/F.mat'                     );
load( '../debug/part3/cameras.mat'               );
load( '../debug/part3/camera_centers.mat'        );
load( '../debug/part3/H.mat'                     );
load( '../debug/part3/points3d_few.mat'          );
load( '../debug/part3/points3d_ground_truth.mat' );

%% Test the function compute_F_matrix

fprintf('--------------------------\n')
fprintf(' FUNDAMENTAL MATRIX ERROR \n')
fprintf('--------------------------\n')

F_test = compute_F_matrix( points2d );

F      = fix_homogeneous_scale( F      );
F_test = fix_homogeneous_scale( F_test );

F_error = F - F_test

%% Test the function reconstruct_stereo_cameras 

fprintf('-----------------------------\n')
fprintf(' CAMERA RECONSTRUCTION ERROR \n')
fprintf('-----------------------------\n')

load( '../debug/part3/F.mat' );

[cameras_test camera_centers_test] = ...
    reconstruct_uncalibrated_stereo_cameras( F );

for c=1:CAMERAS
    cameras(:,:,c)           = fix_homogeneous_scale( cameras(:,:,c)           );
    cameras_test(:,:,c)      = fix_homogeneous_scale( cameras_test(:,:,c)      );
    camera_centers(:,c)      = fix_homogeneous_scale( camera_centers(:,c)      );
    camera_centers_test(:,c) = fix_homogeneous_scale( camera_centers_test(:,c) );
end

cameras_error        = cameras        - cameras_test
camera_centers_error = camera_centers - camera_centers_test


%% Test the function compute_rectification_matrix 

fprintf('----------------------------\n')
fprintf(' RECTIFICATION MATRIX ERROR \n')
fprintf('----------------------------\n')

Htest = compute_rectification_matrix( points3d_few, points3d_ground_truth );

H       = fix_homogeneous_scale( H      );
H_test  = fix_homogeneous_scale( Htest  );

H_error = H - H_test

