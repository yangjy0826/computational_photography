
% Method: Performs a reconstruction of two calibrated cameras
%         by solving first for the essentila matrix E. From
%         E the rotation and translation is obtained and finally
%         the two cameras. 
%         The point-structure is obtained by triangulation.

clear all                   % Remove all old variables
close all                   % Close all figures
clc                         % Clear the command window
addpath( genpath( '../' ) );% Add paths to all subdirectories of the parent directory

REFERENCE_VIEW      = 1;
CAMERAS             = 2;
image_names_file    = 'names_images_teapot.txt';

SYNTHETIC_DATA      = 1;    % Choose this to use the synthetic data.
REAL_DATA_CLICK     = 2;    % Choose this to measure and save new real data.
REAL_DATA_LOAD      = 3;    % Choose this to load real data.
VERSION             = SYNTHETIC_DATA;

if VERSION == SYNTHETIC_DATA
    points2d_file = '../data/data_sphere.mat';
else
    points2d_file = '../data/data_teapot.mat';
end

%% The internal camera parameters

K = zeros(3,3,CAMERAS);
if VERSION == SYNTHETIC_DATA
  K(:,:,1) = [5 0 3;
              0 4 2;
              0 0 1];
          
  K(:,:,2) = [ 7 0 1;
              0 10 5;
              0  0 1];
else
  K(:,:,1) = [2250    0 400;
                 0 2250 300;
                 0    0   1];

  K(:,:,2) = K(:,:,1);
end


%% Get data: synthetic or real

if VERSION == SYNTHETIC_DATA
    
    load( points2d_file );
    images = cell(CAMERAS,1);
    
elseif VERSION == REAL_DATA_CLICK
    
    [images image_names] = load_images_grey( image_names_file, CAMERAS ); 
    points2d = click_multi_view( images );%, CAMERAS, data, 0); % for clicking and displaying data
    save( points2d_file, 'points2d' );
    
elseif VERSION == REAL_DATA_LOAD
        
    [images,image_names] = load_images_grey( image_names_file, CAMERAS ); 
    load( points2d_file );
    
else
    return
end


%% Get the Essential matrix & Cameras & points3d

E = compute_E_matrix( points2d, K );

[cameras camera_centers] = reconstruct_stereo_cameras( E, K, points2d(:,1,:) ); 

points3d = reconstruct_point_cloud( cameras, points2d );

% Check the reprojection error:
[error_average error_max] = check_reprojection_error( points2d, cameras, points3d );
fprintf( '\n\nThe reprojection error is: \n' );
fprintf( 'Average error: %5.2fpixel; Maximum error: %5.2fpixel \n', error_average, error_max );


% Rotate to a coordinate system that suits MATLAB's visualization:
R = [0 0 -1 0;
     1 0 0 0;
     0 -1 0 0;
     0 0 0 1];
points3d       = R * points3d;
camera_centers = R * camera_centers;

visualize_reconstruction( points3d, camera_centers, ...
    points2d( :, :, REFERENCE_VIEW ), images{REFERENCE_VIEW} )
