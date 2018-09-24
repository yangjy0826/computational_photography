clear all
close all
clc


O3D = [0 1 0]';
A3D = [1 0 0]';
B3D = [1 1 1]';

O2D = [150 350]';
A2D = O2D + [300 -50]';
B2D = O2D + [50 -250]';

points3d = [O3D A3D B3D];
points2d = [O2D A2D B2D];

img = imread('peppers.png');  %# Sample image for texture map

figure
subplot(1,2,1)
hold on
DrawTexturedTriangle( points3d, points2d, img, 256 );
axis equal            %# Use equal scaling on axes
axis([0 1 0 1 0 1]);  %# Set axes limits
xlabel('x-axis');     %# x-axis label
ylabel('y-axis');     %# y-axis label
zlabel('z-axis');     %# z-axis label

subplot(1,2,2)
image(img)
hold on
points = [points2d points2d(:,1)];
plot( points(1,:), points(2,:), 'w-' )

colors = {'r','g','b'};
for v=1:3
    subplot(1,2,2)
    plot( points2d(1,v), points2d(2,v), [colors{v} 'o'] )
    
    subplot(1,2,1)
    plot3( points3d(1,v), points3d(2,v), points3d(3,v), [colors{v} 'o'] )
end

