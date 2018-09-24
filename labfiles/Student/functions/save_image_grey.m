% function save_image_grey(name, image)
%
% Method: save the image (double format) with the name
% 
% Input: the name of a file and the image as a double array
%
% Output: cell of images in double format 
%         
%

function save_image_grey(name, image)

% convert the image first
image2 = uint8(image');
imwrite(image2,name,'jpg') 

