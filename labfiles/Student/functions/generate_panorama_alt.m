% function image1 = generate_panorama(images, homographies)
%
% Method:   Warp all the images into one image according to the
%           corresponding homography. The order of the images determine 
%           which image is on top.
%
%           Let C be the number of cameras.
% 
% Input:    images is a Cx1 cell-array of images (double).
%
%           homographies is a 3x3xC array of all homographies.
%           It is: point(image ref) = homographies(:,:,c) * point(image c)
% 
% Output:   The new warped image in (double)

function image1 = generate_panorama(images, homographies)

% get Info 
am_cams = size(images,1);

% Convert format:
new_homographies = cell(am_cams,1);
for c=1:am_cams
    new_homographies{c} = homographies(:,:,c);
end
homographies = new_homographies;

% get the size of the new image  
minx = 1;
miny = 1;
maxx = 1; 
maxy = 1;

for hi1 = 1:am_cams
  
  % the original corners
  sizex = size(images{hi1},1);
  sizey = size(images{hi1},2);
  cor1 = zeros(3,0);
  cor1 = [cor1,[1,1,1]'];
  cor1 = [cor1,[sizex,1,1]'];
  cor1 = [cor1,[1,sizey,1]'];
  cor1 = [cor1,[sizex,sizey,1]'];
  
  % warp the corners
  cor2 = homographies{hi1} * cor1;
  for hi2 = 1:4 
    cor2(:,hi2) = round(cor2(:,hi2) / cor2(3,hi2)); 
  end

  % get the maxs and mins 
  for hi2 = 1:4 
    if(cor2(1,hi2) < minx)
      minx = cor2(1,hi2);
    end
    if(cor2(1,hi2) > maxx)
      maxx = cor2(1,hi2);
    end
    if(cor2(2,hi2) < miny)
      miny = cor2(2,hi2);
    end
    if(cor2(2,hi2) > maxy)
      maxy = cor2(2,hi2);
    end
  end 

end

% determine the shift and size
pan_shiftx = 1-minx;
pan_shifty = 1-miny;
pan_sizex = maxx+pan_shiftx;
pan_sizey = maxy+pan_shifty;

% initialze the new image 
image1 = zeros(pan_sizex,pan_sizey); % black image 

% Info 
fprintf('The panoramic image will be of size (x,y): %d , %d \n\n', pan_sizex, pan_sizey);

% speed it up - determine inverse Homographies first
hom_inv = cell(am_cams,1);
sizex_vec = zeros(am_cams,1);
sizey_vec = zeros(am_cams,1);
 
for hi1 = 1:am_cams
  hom_inv{hi1} = inv(homographies{hi1}); 
  sizex_vec(hi1) = size(images{hi1},1); 
  sizey_vec(hi1) = size(images{hi1},2); 
end

% warp all the images into image1
fprintf('The current x (1,%d) value is:',pan_sizex); 
for hi1 = 1:pan_sizex
  fprintf('%d ',hi1); % for information
  for hi2 = 1:pan_sizey
    point = [hi1-pan_shiftx,hi2-pan_shifty,1]'; 
    hi3 = 1; 
    while(hi3 <= am_cams) 
      point_map = hom_inv{hi3} * point; 
      point_map = round( point_map / point_map(3,1)); 
      if all ( [ (point_map(1,1)>1), (point_map(1,1)<(sizex_vec(hi3)+1)), ...
                 (point_map(2,1)>1), (point_map(2,1)<(sizey_vec(hi3)+1)) ] ) 
        image1(hi1,hi2) = images{hi3}(point_map(1,1),point_map(2,1));
        hi3 = am_cams+1; 
      else
        hi3 = hi3+1;
      end
    end
  end
end

% next info line
fprintf('\n\n');
