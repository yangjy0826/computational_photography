function K=U(dist)
[i,j]=find(dist==0);
for ii=1:size(i,1)
   dist(i(ii),j(ii))=1; % r^2*log(r) is zero for both r==1 and r==0, but matlab
   % cannot handle log(0)
end
K=dist.^2 .* log(dist);
