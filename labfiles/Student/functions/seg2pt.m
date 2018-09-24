 function [x,y]=seg2pt(seg);
%function [x,y]=seg2pt(seg);

x=(seg(:,1)+seg(:,3))/2;
y=(seg(:,2)+seg(:,4))/2;
