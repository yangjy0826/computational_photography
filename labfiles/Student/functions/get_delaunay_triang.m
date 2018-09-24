% triang = get_delaunay_triang(data, num_ref);
%
% Method:   Gives back a delaunay triangulation in 
%           the reference view: num_ref. The MATLAB 
%           function "delaunay" is used.
%
% Input:    data is a 3xNxC array, storing all image points.
%           OLD: data (3*m,n) matrix
%
% Output: triang (amount triangles,3) a list of all triangles.
%                 Every entry is an index to the data.
%
 

% TODO: This function does not make any sense. Remove it!

function [triang] = get_delaunay_triang( data, ref_view )

%------------------------------
%
% FILL IN THIS PART
%
%------------------------------


x = data( 1, :, ref_view );
y = data( 2, :, ref_view );
triang = delaunay( x, y );