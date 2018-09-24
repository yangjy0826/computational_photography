function dist_mat=DIST(x,y)

o=ones(size(x));
xdiff=o*x'-x*o';
ydiff=o*y'-y*o';
dist_mat=sqrt(xdiff.^2 + ydiff.^2);

