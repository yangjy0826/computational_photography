
% Method: click points and display the dataset in multiple views.
%
% images    Cx1 cell array of images.
%           Each image should be in double format.
%
% data      3xNxC array of the clicked image points in all views, in
%           homogeneous coordinates.

function [data] = click_multi_view( images )
%function [data] = click_multi_view(images, am_cams, dataset, para)

disp('Options:  left( and middle) button - click a point in each view (green)');
disp('          right button - finish a correspondence of points (red)');
disp('          u - (up) change to next image (active)');
disp('          d - (down) change to previouse image (active)');
disp('          e - (end) stop the clicking process');

am_cams = length( images );
am_points = 0;
data = zeros(3*am_cams,am_points);

% set default 
% if (nargin == 2)
%   am_points = 0; 
%   para = 0; 
%   data = zeros(3*am_cams,am_points);
% elseif (nargin == 3)
%   am_points = size(dataset,2); 
%   data = dataset; 
%   para = 0; 
% else 
%   am_points = size(dataset,2);  
%   data = dataset; 
% end
x_size_def = 100;
y_size_def = 100;

% initialize
fig_handle = zeros(am_cams); 
 
% load all the images 
if (~isempty(images))
  for hi1 = 1:am_cams
    fig_handle(hi1) = figure(hi1); 
    clf; 
    show_image_grey(images{hi1}); 
  end 
else 
  for hi1 = 1:am_cams 
    fig_handle(hi1) = figure(hi1); 
    if (nargin < 3) 
       plot(0,0,x_size_def,y_size_def); % default size 
    else
      % get max element 
      maxx = max(data(1,:)); 
      maxy = max(data(2,:));
      for hi2 = 2:am_cams
        if (maxx < max(data(hi2*3-2,:)))
          maxx = max(data(hi2*3-2,:));
        end
        if (maxy < max(data(hi2*3-1,:)))
          maxy = max(data(hi2*3-1,:));
        end
      end
      plot(0,0,maxx+50,maxy+50); 
    end
    axis ij
    axis on;
  end
end

% display the current point set
if (am_points > 0)
  for hi1 = 1:am_cams
    figure(fig_handle(hi1)); 
    for hi2 = 1:am_points
      if (sum(isnan(data(hi1*3-2:hi1*3,hi2))) == 0)
        if (para == 0)
          hold; plot(data(hi1*3-2,hi2), data(hi1*3-1,hi2), 'ro'); hold;
        elseif (para == 1)
          string = sprintf('%d', hi2);
          hold; text(data(hi1*3-2,hi2)+2, data(hi1*3-1,hi2), string, 'FontSize',18, 'Color', 'magenta'); hold;
        else
          string = sprintf('%d', hi2);
          hold; text(data(hi1*3-2,hi2)+2, data(hi1*3-1,hi2), string, 'FontSize',18, 'Color', 'magenta'); hold;
          hold; plot(data(hi1*3-2,hi2), data(hi1*3-1,hi2), 'ro'); hold;
        end
      end
    end
  end
end

% first figure as start
cur_fig = 1; 
figure(fig_handle(cur_fig));  

% input loop 
finished = 1;
new_point = zeros(3*am_cams,1); 
new_point(:) = NaN; 

while (finished > 0)

  % get new input
  [x, y, button] = ginput(1);

  % switches
  switch(button)
    case {1,2}
      if (sum(isnan(new_point(cur_fig*3-2:cur_fig*3,1))) == 0) 
        disp('already marked!'); 
      else
        new_point(cur_fig*3-2:cur_fig*3,1) = [x,y,1]';
        hold; plot(x, y, 'go'); hold;
      end
    case {3}
      for hi1 = 1:am_cams
        figure(fig_handle(hi1)); 
        if (sum(isnan(new_point(hi1*3-2:hi1*3,1))) == 0) 
          hold; plot(new_point(hi1*3-2,1), new_point(hi1*3-1,1), 'ro'); hold;
        end
      end
      data = [data,new_point];
      new_point(:) = NaN; 
      figure(fig_handle(cur_fig)); 
    case {101, 69}
      finished = 0;
    case {117, 85}
      cur_fig = cur_fig + 1; 
      if (cur_fig == am_cams+1)
        cur_fig = 1; 
      end
      figure(fig_handle(cur_fig)); 
    case {100, 68}
      cur_fig = cur_fig - 1; 
      if (cur_fig == 0)
        cur_fig = am_cams; 
      end
      figure(fig_handle(cur_fig)); 
    otherwise
      disp('no influence'); 
   end
end

% Change to 3xNxC format:
am_points = size( data, 2 );
new_data = zeros( 3, am_points, am_cams );
for c=1:am_cams
    new_data(:,:,c) = data(c*3-2:c*3,:);
end
data = new_data;



