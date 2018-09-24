% colinear.m

function bool=colinear(x1,y1,x2,y2,x3,y3);

A=[x2-x1 x3-x1; y2-y1 y3-y1];
eps=20;
len2=sqrt((x2-x1).^2+(y2-y1).^2);
len3=sqrt((x3-x1).^2+(y3-y1).^2);
theta=asin(det(A)/(len2*len3));
bool=~(abs(theta)>pi/9);
