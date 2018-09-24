% function save_vrml(data, model, triang, filename, name_image, image_size, para1, para2);
%
% Method: Saves the model with tringulation as a textured model 
%         in vrml 2.0
%
% Input: image data size (3*m,n)
%        model size (4,n)
%        triang size (n,3) all indeces of the model
%        name_file: name of the VRML file 
%        name_image: the name of the reference images
%        image_size: (1,2) with xsize, ysize of the reference image 
%        para1: 0 - with texture; 1 - without texture; 
%        para2: number of the reference image 
% 

function save_vrml(data, model, triang, filename, name_image, image_size, para1, para2)

% Info 
am_points = size(model,2); 
am_triang = size(triang,1); 

%----------------------------------------------------
% first scale the obect that it has max size 1
%----------------------------------------------------

size_x = max(model(1,:))-min(model(1,:));
size_y = max(model(2,:))-min(model(2,:));
size_z = max(model(3,:))-min(model(3,:));
scale = 5.0/max([size_x, size_y, size_z]);
model = model * scale;
model(4,:) = ones(1,size(model,2)); 

%----------------------------------------------------
% now move the center of the object into (0,0,0,1)
%----------------------------------------------------

trans(1,1) = sum(model(1,:))/size(model,2);
trans(2,1) = sum(model(2,:))/size(model,2);
trans(3,1) = sum(model(3,:))/size(model,2);
trans(4,1) = 0; 

for hi1 = 1:am_points
  model(:,hi1) = model(:,hi1) - trans; 
end

%----------------------------------------------------
% open the file 
%----------------------------------------------------

fid=fopen(filename,'w');

%----------------------------------------------------
% the start lines 
%----------------------------------------------------

fprintf(fid,'#VRML V2.0 utf8\n\n');
fprintf(fid,'WorldInfo { title "Model" }\n\n');

fprintf(fid,'Viewpoint\n');
fprintf(fid,'{ \n');
fprintf(fid,'   position 0 0 5.0 \n');
fprintf(fid,'   orientation 0 0 1 0 \n');
fprintf(fid,'   fieldOfView 1.2 # fieldOfView 0.785398 - normal field of view 45deg \n');
fprintf(fid,'} \n\n');

fprintf(fid,'Background {\n');
fprintf(fid,'  skyColor [0.7 0.7 1, 0.7 0.7 1, 0.7 0.7 1]\n');
fprintf(fid,'}\n\n');

fprintf(fid,'DEF ROOT Transform {\n');
fprintf(fid,'  translation 0 0 0 \n');
fprintf(fid,'  children [\n');
if (para1 == 0)
  fprintf(fid,'    Shape { appearance Appearance { texture ImageTexture {url "%s"} }\n',name_image);
elseif (para1 == 1)
  fprintf(fid,'    Shape { appearance Appearance { material Material {diffuseColor 1.0 0.0 0.0} }\n');
end
fprintf(fid,'            geometry IndexedFaceSet { \n');
fprintf(fid,'              solid FALSE \n');
fprintf(fid,'	           convex FALSE  \n');

%----------------------------------------------------
% Store all the points
%----------------------------------------------------
fprintf(fid,'	           coord Coordinate { point [ \n');
for hi1 = 1:am_points
  fprintf(fid,'                     %f %f %f',model(1:3,hi1)' );
  if (hi1 ~= am_points)
    fprintf(fid,',\n');
  else
    fprintf(fid,'\n');
  end
end
fprintf(fid,'               ] } \n');

%----------------------------------------------------
% store all the triangles 
%----------------------------------------------------
fprintf(fid,'	          coordIndex [ \n');

%------------------------------
%
% FILL IN THIS PART
%
%------------------------------

fprintf(fid,'               ] \n');

%----------------------------------------------------
% store all the texture 
%----------------------------------------------------
if (para1 == 0)
  fprintf(fid,'	           texCoord TextureCoordinate { point [ \n');

%------------------------------
%
% FILL IN THIS PART
%
%------------------------------

  fprintf(fid,'               ] } \n');
end

fprintf(fid,'	         }	\n');	    	  
fprintf(fid,'          }  \n');
fprintf(fid,'  ]  \n');
fprintf(fid,'}  \n');

fclose(fid);

