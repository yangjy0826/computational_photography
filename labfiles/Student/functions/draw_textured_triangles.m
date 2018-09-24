% handles = draw_textured_triangles( indices, X, Y, Z, U, V, img, textureSize )
%
% Draws a set of triangles with an image attached to their surfaces.
%
% Let T be the number of triangles.
% Let N be the number of points.
%
% indices       Tx3 matrix. Each row contains the three indices to the
%               points that represent the vertices of the triangle. In this
%               way the triangles can share vertices. The indices are
%               between 1 and N.
%
% X             1xN vector containing the X-coordinates for each point.
% Y             1xN vector containing the Y-coordinates for each point.
% Z             1xN vector containing the Z-coordinates for each point.
%
% U             1xN vector containing the U-texture-coordinates for each point.
% V             1xN vector containing the V-texture-coordinates for each point.
%
% img           The image used for the texture. Can be color or gray-scale.
%
% textureSize   The texture covering each triangle is resampled to a square
%               image with this size.

function handles = draw_textured_triangles( indices, X, Y, Z, U, V, img, textureSize )

TRIANGLES = size( indices, 1 );
handles = [];
for t=1:TRIANGLES
    vertices = indices(t,:);
    
    vertices3d = [  X(vertices);
                    Y(vertices);
                    Z(vertices)];
                
    vertices2d = [  U(vertices);
                    V(vertices)];
    
    h = draw_textured_triangle( vertices3d, vertices2d, img, textureSize );
    handles = [handles; h];
end

end

