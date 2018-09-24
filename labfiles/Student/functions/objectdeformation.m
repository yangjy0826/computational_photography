%objectdeformation.m
%warps and morphs an image onto another
%according to clicks
[
    '1) Click in the top image                               ';
    '2) Click on the corresponding point in the bottom image ';
    '3) Repeat any number of times                           ';
    '4) End by right-clicking                                ';
]

%close all
clear

stsz=.25;

%Read model and image
%mod = imread('edited_nowindows_wag901.TIF');
%img = imread('wag902.TIF');
mod = imread('bear.bmp');
img = imread('horse.TIF');
mmod = size(mod,1);
mimg = size(img,1);
nmod = size(mod,2);
nimg = size(img,2);
oldmmod=mmod;
oldnmod=nmod;
oldmimg=mimg;
oldnimg=nimg;
space=40;
modimg=mod;
modimg(1:mmod+space+mimg,1:nimg,1:3) = 255;
modimg(1:mmod,1:nmod,1:3)=mod;
modimg(mmod+space+1:mmod+space+mimg,1:nimg,1:3) = img;

%Show modimg
set(figure,'Color','white');
imagesc(modimg);
axis equal
%axis off
clear modimg;

%Get clicks of and plot cor
hold on
orgmodseg=[];
orgimgseg=[];
button=1;
orgmodseg=orgmodseg(1:end,:);
orgimgseg=orgimgseg(1:end,:);
modseg=orgmodseg;
imgseg=orgimgseg;
for i=1:size(modseg,1)
    x1=modseg(i,1);
    y1=modseg(i,2);
    x2=imgseg(i,1);
    y2=imgseg(i,2)+oldmmod+space;
    plot([x1 x2],[y1 y2])
end

while button==1
    [x1 y1 button]=ginput(1);
    if button==1
        [x2 y2 button]=ginput(1);
        if button==1
            plot([x1 x2],[y1 y2])
            xm=x1;
            ym=y1;
            xi=x2;
            yi=(y2-oldmmod-space);
            modseg=[modseg; xm ym xm ym];
            imgseg=[imgseg; xi yi xi yi];
        end
    end
end
hold off

orgmodseg=modseg;
orgimgseg=imgseg;

sz=size(modseg,1);

%Transform the model and plot it onto the image
[xsmat ysmat]=meshgrid(1:nimg,1:mimg);
refpoints=[xsmat(:) ysmat(:)];
clear xsmat;
clear ysmat;

[imgseg,sx,sy,tx,ty]=img2trnimg([1:sz; 1:sz]',modseg,imgseg,0);
orgnewrefpoints=sx*refpoints+ones(size(refpoints,1),1)*[tx ty];

i=0;

for step=0
    i=i+1;
    newrefpoints=step*orgnewrefpoints+(1-step)*refpoints;
    newxs=newrefpoints(:,1);
    newys=newrefpoints(:,2);
    clear newrefpoints;
    newxsmat=reshape(newxs,mimg,nimg);
    newysmat=reshape(newys,mimg,nimg);
    clear newxs;
    clear newys;
    modI=255*ones(mimg,nimg,3);
    modI(1:oldmmod,1:oldnmod,1:3)=double(mod);
    modI1=interp2(modI(:,:,1),newxsmat,newysmat);
    modI2=interp2(modI(:,:,2),newxsmat,newysmat);
    modI3=interp2(modI(:,:,3),newxsmat,newysmat);
    clear newxsmat;
    clear newysmat;
    modI(:,:,1)=modI1;
    modI(:,:,2)=modI2;
    modI(:,:,3)=modI3;
    mod=double(mod);
    modIbw=sum(modI,3);
    mask=modIbw<740;
    clear modIbw;
    mask2=cat(3,mask,mask);
    mask3=cat(3,mask2,mask);
    clear mask;
    clear mask2;
    img=double(img);
    modI(isnan(modI))=0;
    close;
    set(figure,'Color','white');
    imagesc((modI.*mask3+img-img.*mask3)/255);
    %imagesc(((1-step)*modI.*mask3+img-(1-step)*img.*mask3)/255);
    clear modI;
    clear mask3;
    axis equal
    axis off
    M(i) = getframe;
end %step
i=i+1; M(i) = getframe;
i=i+1; M(i) = getframe;
i=i+1; M(i) = getframe;
i=i+1; M(i) = getframe;
i=i+1; M(i) = getframe;

for step=0:stsz:1
    i=i+1;
    newrefpoints=step*orgnewrefpoints+(1-step)*refpoints;
    newxs=newrefpoints(:,1);
    newys=newrefpoints(:,2);
    clear newrefpoints;
    newxsmat=reshape(newxs,mimg,nimg);
    newysmat=reshape(newys,mimg,nimg);
    clear newxs;
    clear newys;
    modI=255*ones(mimg,nimg,3);
    modI(1:oldmmod,1:oldnmod,1:3)=double(mod);
    modI1=interp2(modI(:,:,1),newxsmat,newysmat);
    modI2=interp2(modI(:,:,2),newxsmat,newysmat);
    modI3=interp2(modI(:,:,3),newxsmat,newysmat);
    clear newxsmat;
    clear newysmat;
    modI(:,:,1)=modI1;
    modI(:,:,2)=modI2;
    modI(:,:,3)=modI3;
    clear modI1;
    clear modI2;
    clear modI3;
    mod=double(mod);
    modIbw=sum(modI,3);
    mask=modIbw<740;
    clear modIbw;
    mask2=cat(3,mask,mask);
    mask3=cat(3,mask2,mask);
    clear mask;
    clear mask2;
    img=double(img);
    modI(isnan(modI))=0;
    close;
    set(figure,'Color','white');
    imagesc((modI.*mask3+img-img.*mask3)/255);
    %imagesc(((1-step)*modI.*mask3+img-(1-step)*img.*mask3)/255);
    clear modI;
    clear mask3;
    axis equal
    axis off
    M(i) = getframe;
end %step
i=i+1; M(i) = getframe;
i=i+1; M(i) = getframe;
i=i+1; M(i) = getframe;
i=i+1; M(i) = getframe;
i=i+1; M(i) = getframe;

refpoints=orgnewrefpoints;
clear orgnewrefpoints;
lambda=1000;
[orgnewrefpoints,modseg,BendNrj]=tps(lambda,[1:sz; 1:sz]',imgseg,modseg,refpoints);

for step=0:stsz:1
    i=i+1;
    newrefpoints=step*orgnewrefpoints+(1-step)*refpoints;
    newxs=newrefpoints(:,1);
    newys=newrefpoints(:,2);
    clear newrefpoints;
    newxsmat=reshape(newxs,mimg,nimg);
    newysmat=reshape(newys,mimg,nimg);
    clear newxs;
    clear newys;
    modI=255*ones(mimg,nimg,3);
    modI(1:oldmmod,1:oldnmod,1:3)=double(mod);
    modI1=interp2(modI(:,:,1),newxsmat,newysmat);
    modI2=interp2(modI(:,:,2),newxsmat,newysmat);
    modI3=interp2(modI(:,:,3),newxsmat,newysmat);
    clear newxsmat;
    clear newysmat;
    modI(:,:,1)=modI1;
    modI(:,:,2)=modI2;
    modI(:,:,3)=modI3;
    clear modI1;
    clear modI2;
    clear modI3;
    mod=double(mod);
    modIbw=sum(modI,3);
    mask=modIbw<740;
    clear modIbw;
    mask2=cat(3,mask,mask);
    mask3=cat(3,mask2,mask);
    clear mask;
    clear mask2;
    img=double(img);
    modI(isnan(modI))=0;
    close;
    set(figure,'Color','white');
    imagesc((modI.*mask3+img-img.*mask3)/255);
    %imagesc(((1-step)*modI.*mask3+img-(1-step)*img.*mask3)/255);
    clear modI;
    clear mask3;
    axis equal
    axis off
    M(i) = getframe;
end %step
clear refpoints;

i=i+1; M(i) = getframe;
i=i+1; M(i) = getframe;
i=i+1; M(i) = getframe;
i=i+1; M(i) = getframe;
i=i+1; M(i) = getframe;


for step=0:stsz:1
    i=i+1;
    newrefpoints=orgnewrefpoints;
    newxs=newrefpoints(:,1);
    newys=newrefpoints(:,2);
    clear newrefpoints;
    clear newrefpoints;
    newxsmat=reshape(newxs,mimg,nimg);
    newysmat=reshape(newys,mimg,nimg);
    clear newxs;
    clear newys;
    modI=255*ones(mimg,nimg,3);
    modI(1:oldmmod,1:oldnmod,1:3)=double(mod);
    modI1=interp2(modI(:,:,1),newxsmat,newysmat);
    modI2=interp2(modI(:,:,2),newxsmat,newysmat);
    modI3=interp2(modI(:,:,3),newxsmat,newysmat);
    clear newxsmat;
    clear newysmat;
    modI(:,:,1)=modI1;
    modI(:,:,2)=modI2;
    modI(:,:,3)=modI3;
    clear modI1;
    clear modI2;
    clear modI3;
    mod=double(mod);
    modIbw=sum(modI,3);
    mask=modIbw<740;
    clear modIbw;
    mask2=cat(3,mask,mask);
    mask3=cat(3,mask2,mask);
    clear mask;
    clear mask2;
    img=double(img);
    modI(isnan(modI))=0;
    close;
    set(figure,'Color','white');
    %imagesc((modI.*mask3+img-img.*mask3)/255);
    imagesc(((1-step)*modI.*mask3+img-(1-step)*img.*mask3)/255);
    clear modI;
    clear mask3;
    axis equal
    axis off
    %hgsave(['M',num2str(i)]);
    M(i) = getframe;
end %step
clear orgnewrefpoints;

i=i+1; M(i) = getframe;
i=i+1; M(i) = getframe;
i=i+1; M(i) = getframe;
i=i+1; M(i) = getframe;
i=i+1; M(i) = getframe;

clear modI;
clear mask3;
clear img;

%save M M

%movie2avi(M,'cars.avi');
close all
'movie(M);'
%'save it'
