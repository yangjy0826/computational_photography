function plot_elect(corrpts,ModSeg,ImgSeg,ImgPic,ModEle,ImgEle,ModPic,refpoints,thick,Vot,index_type,maxchoice)

x1m=ModSeg(:,1);
y1m=ModSeg(:,2);
x2m=ModSeg(:,3);
y2m=ModSeg(:,4);
xm=.5*(x1m+x2m);
ym=.5*(y1m+y2m);
x1i=ImgSeg(:,1);
y1i=ImgSeg(:,2);
x2i=ImgSeg(:,3);
y2i=ImgSeg(:,4);
xi=.5*(x1i+x2i);
yi=.5*(y1i+y2i);

if exist('maxchoice','var')
  if maxchoice==1
    if ~isempty(Vot)

      

        
      set(figure,'Color','white');
      hold on
      axis equal
      axis off
      
      for i=1:size(ModSeg,1)
	plot([x1m(i),x2m(i)],[y1m(i),y2m(i)],'b');
      end
      for i=1:size(ImgSeg,1)
	plot([x1i(i),x2i(i)],[y1i(i),y2i(i)],'r');
      end


      
      for modi=1:size(Vot,1)
	[zzz,imgi]=max(Vot(modi,:));
	plot([xm(modi),xi(imgi)],[ym(modi),yi(imgi)],'g');
      end
      %print %tmp

      set(figure,'Color','white');
      hold on
      axis equal
      axis off
      
      for i=1:size(ModSeg,1)
	plot([x1m(i),x2m(i)],[y1m(i),y2m(i)],'b');
      end
      for i=1:size(ImgSeg,1)
	plot([x1i(i),x2i(i)],[y1i(i),y2i(i)],'r');
      end

      for imgi=1:size(Vot,2)
	[zzz,modi]=max(Vot(:,imgi));
	plot([xm(modi),xi(imgi)],[ym(modi),yi(imgi)],'k');
      end
      %print %tmp
      
    end
  return
  end
end



if exist('Vot','var')
  if ~isempty(Vot)
    max_vote=max(Vot(:));
    n=ceil(sqrt(size(Vot,1)/5));
    iii=0;
    for ii=1:size(Vot,1)
      iii=iii+1;
      if mod(iii,16)==1
	%print
	%close
	set(figure,'Color','white');
	hold on
	axis equal
	axis off
      end
      subplot(4,4,1+mod(iii-1,16))
      hold on
      axis equal
      axis off
      
      for i=1:size(ModSeg,1)
	plot([x1m(i),x2m(i)],[y1m(i),y2m(i)],'b');
      end
      
      for i=1:size(ImgSeg,1)
	%plot a blob proportional to the number of votes
	max_vote=max(Vot(ii,:));
	if max_vote>0
	  plot(xi(i),yi(i),'ko','MarkerFaceColor','k','MarkerSize',1+floor(Vot(ii,i)/max_vote*10));
	end
	plot([x1i(i),x2i(i)],[y1i(i),y2i(i)],'r');
      end
      plot(xm(ii),ym(ii),'ko','MarkerSize', 5);
      hold off
    end
    return
  end
end

%plot ModSeg on ImgPic
if length(ImgPic)>0
  set(figure,'Color','white');
  hold on
  axis equal
  axis off
  
  
  %show ImgPic
  img=imread(['.doc/',ImgPic,'.jpg'],'jpg');
  img=flipdim(img,1);
  image(img);

  %plot ModSeg
  n=size(ModSeg,1);
  for i=1:n
    plot([ModSeg(i,1),ModSeg(i,3)],[ModSeg(i,2),ModSeg(i,4)],'w');
    hold on
  end %for i
  hold off
  
end


set(figure,'Color','white');
hold on
axis equal
axis off

for i=1:size(ModSeg,1)
  plot([x1m(i),x2m(i)],[y1m(i),y2m(i)],'b');
end

for i=1:size(ImgSeg,1)
  plot([x1i(i),x2i(i)],[y1i(i),y2i(i)],'r');
end


if size(ModPic)==size('stefans')
  if ModPic=='stefans'
    for i=1:size(ModSeg,1)
      plot([x1m(i),x2m(i)],[y1m(i),y2m(i)],'bx');
    end
    
    for i=1:size(ImgSeg,1)
      plot([x1i(i),x2i(i)],[y1i(i),y2i(i)],'ro');
    end
  end
end


for i=1:size(corrpts,1)
  modi=corrpts(i,1);
  imgi=corrpts(i,2);
  if exist('thick','var')
    if thick==1
      plot([x1m(modi),x2m(modi)],[y1m(modi),y2m(modi)],'b','LineWidth',3);
      plot([x1i(imgi),x2i(imgi)],[y1i(imgi),y2i(imgi)],'r','LineWidth',3);
    end
  end
  plot([xm(modi),xi(imgi)],[ym(modi),yi(imgi)],'g');
  if size(ModPic)==size('stefans')
    if ~ModPic=='stefans'
      text((xm(modi)+xi(imgi))/2,(ym(modi)+yi(imgi))/2,num2str(i));
    end
  end
end

if exist('refpoints','var');
  for i=1:size(refpoints,1)
    plot(refpoints(i,1),refpoints(i,2))
  end
end

      for i=1:size(ModSeg,1)
	plot(x1m(i),y1m(i),'bo');
      end
      for i=1:size(ImgSeg,1)
	plot(x1i(i),y1i(i),'rx');
      end


hold off

t=rem(floor(rem(now/10000,1)*1000000000),1000);
