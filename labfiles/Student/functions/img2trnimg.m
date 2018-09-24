% mod2trnimg.m
function [imgseg,sx,sy,tx,ty]=img2trnimg(cor,modseg,imgseg,separate);

nofcorpts=size(cor,1);     %Number of corr pts

cormodseg=modseg(cor(:,1),:);
corimgseg=imgseg(cor(:,2),:);

[xmod,ymod]=seg2pt(cormodseg);
[ximg,yimg]=seg2pt(corimgseg);
xmodavg=sum(xmod)/nofcorpts;
ymodavg=sum(ymod)/nofcorpts;
ximgavg=sum(ximg)/nofcorpts;
yimgavg=sum(yimg)/nofcorpts;

if ~separate
    
    %s=sumi((ximgi-ximgavg)*(xmodi-xmodavg)+(yimgi-yimgavg)*(ymodi-ymodavg))/sumi((xmodi-xmodavg)^2+(ymodi-ymodavg)^2)
    s=(ones(1,nofcorpts)*((ximg-ximgavg).*(xmod-xmodavg)+(yimg-yimgavg).*(ymod-ymodavg)))/(ones(1,nofcorpts)*((ximg-ximgavg).^2+(yimg-yimgavg).^2));
    %s=10;
    sx=s;
    sy=s;
    
    %tx=ximgavg-s*xmodavg
    tx=xmodavg-s*ximgavg;
    %ty=yimgavg-s*ymodavg
    ty=ymodavg-s*yimgavg;
    
else
    
    sx=(xmod'*ximg-xmodavg*sum(ximg))/(ximg'*ximg-ximgavg*sum(ximg));
    sy=(ymod'*yimg-ymodavg*sum(yimg))/(yimg'*yimg-yimgavg*sum(yimg));
    
    tx=(xmodavg*(ximg'*ximg)-ximgavg*(xmod'*ximg))/(ximg'*ximg-ximgavg*sum(ximg));
    ty=(ymodavg*(yimg'*yimg)-yimgavg*(ymod'*yimg))/(yimg'*yimg-yimgavg*sum(yimg));
    
end

%PtsIn -> PtsOut
%PtsOut=PtsIn;
PtsIn=imgseg;
nofiopairs=size(PtsIn,2)/2;   %Number of xy pairs in io
for i=1:nofiopairs
    xc=(i-1)*2+1; % col nr
    yc=xc+1;  % col nr
    PtsOut(:,xc)=sx*PtsIn(:,xc)+tx;
    PtsOut(:,yc)=sy*PtsIn(:,yc)+ty;
end
imgseg=PtsOut;
