%function [newrefpoints,NewModSeg,BendNrj]=tps(lambda,index_pairs,ModSeg,ImgSeg,refpoints);
function [newrefpoints,NewModSeg,BendNrj]=tps(lambda,index_pairs,ModSeg,ImgSeg,refpoints);
ImgEle=ImgSeg(index_pairs(:,2),:);
ModEle=ModSeg(index_pairs(:,1),:);

n=size(index_pairs,1);
[x,y]=seg2pt(ModEle);
dist=DIST(x,y);

K11=U(dist);
K=K11+lambda*eye(n);

P=[ones(n,1) x y];
[vx,vy]=seg2pt(ImgEle);
L=[K  P;...
      P' zeros(3,3)];
wax=L\[vx; zeros(3,1)];
wx=wax(1:n,1);
ax=wax(n+1:n+3,1);
way=L\[vy; zeros(3,1)];
wy=way(1:n,1);
ay=way(n+1:n+3,1);

x1=ModSeg(:,1);
y1=ModSeg(:,2);
x2=ModSeg(:,3);
y2=ModSeg(:,4);

n2=size(x1,1);

dist2=DIST2(x,y,x1,y1);
K2=U(dist2);
NewModSegx1=[ones(n2,1) x1 y1]*ax + K2'*wx;
NewModSegy1=[ones(n2,1) x1 y1]*ay + K2'*wy;

dist2=DIST2(x,y,x2,y2); %changed from x1,y1
K2=U(dist2);
NewModSegx2=[ones(n2,1) x2 y2]*ax + K2'*wx;
NewModSegy2=[ones(n2,1) x2 y2]*ay + K2'*wy;

NewModSeg=[NewModSegx1 NewModSegy1 NewModSegx2 NewModSegy2];

BendNrj=wx'*K11*wx+wy'*K11*wy;

NewModEle=NewModSeg(index_pairs(:,1),:);

xmin1=min(x1);
xmax1=max(x1);
ymin1=min(y1);
ymax1=max(y1);
xmin2=min(x2);
xmax2=max(x2);
ymin2=min(y2);
ymax2=max(y2);

xmin=min(xmin1,xmin2);
xmax=max(xmax1,xmax2);
ymin=min(ymin1,ymin2);
ymax=max(ymax1,ymax2);

xmin10=10*floor(xmin/10);
xmax10=10*ceil(xmax/10);
ymin10=10*floor(ymin/10);
ymax10=10*ceil(ymax/10);

refptdist=(xmax10-xmin10)/20;

xref=[xmin10:refptdist:xmax10]';
yref=[ymin10:refptdist:ymax10]';

xrefsz=size(xref,1);
yrefsz=size(yref,1);

xrefmat=xref*ones(1,yrefsz);
yrefmat=ones(xrefsz,1)*yref';

xrefcomb=reshape(xrefmat,xrefsz*yrefsz,1);
yrefcomb=reshape(yrefmat,xrefsz*yrefsz,1);

totsz=xrefsz*yrefsz;

if exist('refpoints','var')
  xrefcomb=refpoints(:,1);
  yrefcomb=refpoints(:,2);
  clear refpoints;
  totsz=size(xrefcomb,1);
end

dist2=DIST2(x,y,xrefcomb,yrefcomb);
K2=U(dist2);
clear dist2;
newrefpointsx=[ones(totsz,1) xrefcomb yrefcomb]*ax + K2'*wx;
newrefpointsy=[ones(totsz,1) xrefcomb yrefcomb]*ay + K2'*wy;
clear xrefcomb;
clear yrefcomb;
clear K2;
newrefpoints=[newrefpointsx newrefpointsy];
clear newrepointsx;
clear newrepointsy;
