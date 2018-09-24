%  function show_image_grey(image, resolution, zmin, zmax)
% 
%  Method: displays the image (array of double) as a gray-scale 
%          image on the screen.
%
%
%  INPUT: image (array of double)
%
%         resoultion, is a scalar value (normally between 1 and 255). 
%         It defines the number of equidistantly spacing (distinct gray-levels)
%         of the range of grey values between 0 (black) and 1 (white). 
%         If resolution is a vector, its elements (which should lie in the 
%         interval [ 0, 1]) are used as gray-levels (colormap).
%
%         zmin, zmax: The values zmin and zmax are mapped to black and
%         white respectively. For a quantized image, it is often advisable 
%         to set zmax to the first quantization level outside actual range.
%         Values in ] zmin, zmax[ are mapped by linear interpolation, whereas
%         values outside this interval are mapped to either black or white by
%         truncation.
% 
%         If zmin and zmax are omitted, they are set to the true max
%         and min values of the elements of image.
%
%         If resolution is also omitted, it is assumed to be 64.
%         If zmin = zmax, the displayed image is thresholded at zmax.
 
function show_image_grey(image1, res, zmin, zmax)

if isempty(image1)
  error( 'Bad argument: arg #1 (image) must not be empty.')
  return
end

if (nargin < 1)
  error( 'Wrong number of input arguments.')
  return
end
if (nargin <= 1)
  res = 64;
end
if (nargin <= 3)
  zmin = min( image1( :));
  zmax = max( image1( :));
end

rsize = size( res);

if all( rsize ~= 1)
  error( 'Bad argument: arg #2 (res) must be a vector (or scalar).')
  return
elseif any( size( zmax) ~= 1)
  error( 'Bad argument: arg #3 (zmax) must be scalar.')
  return
elseif any( size( zmin) ~= 1)
  error( 'Bad argument: arg #3 (zmin) must be scalar.')
  return
end


if all( rsize == 1)
  col = linspace( 0, 1, res)';

  if res <= 1
    error( 'Bad argument: scalar arg #2 (res) < 2 .')
    return
  end
else
  if rsize( 1) == 1
    col = res';
  else
    col = res;
  end

  res = length( col);
end

range = zmax - zmin;

if ~range
  range = eps;
end

% swap for display 
image2 = image1';

image( 1 + res / range * ( image2 - zmin));
colormap( [ col col col]);

axis image
axis on


