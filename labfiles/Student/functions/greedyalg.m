%greedyalg.m

function cor=greedyalg(mch)

[z_,VotVecInd] = sort(-mch(:));

ele=zeros(size(mch));
NofVotRow=size(mch,1);
NofVotCol=size(mch,2);
cont=1;
cor=[]
i=0;
while cont
  i=i+1;
  VotRow=rem(VotVecInd(i)-1,NofVotRow)+1;
  VotCol=(VotVecInd(i)-VotRow)/NofVotRow+1;
  if sum(ele(VotRow,:))==1 | sum(ele(:,VotCol))==1
    ;
  else
    cor=[cor; VotRow VotCol];
    ele(VotRow,VotCol)=1;
  end
  
  
  if i==size(mch(:),1)
    cont=0;
  end
  if sum(ele(:))==min(size(mch))
    cont=0;
  end
  
end
