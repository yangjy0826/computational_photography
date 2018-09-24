function dist_mat=DIST2(x1,y1,x2,y2)

o1=ones(size(x1));
o2=ones(size(x2));
xdiff=x1*o2'-o1*x2';
ydiff=y1*o2'-o1*y2';
dist_mat=sqrt(xdiff.^2 + ydiff.^2);

