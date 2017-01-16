function ObjPrior = objectprior(input_im)

addpath('geObj_code');
addpath('seg_code');
[m,n,p] = size(input_im);
on = 3000;
[~, allboxes]=runObjectness(input_im,0);
[~,index]=sort(allboxes(:,5),'descend');
boxes=floor(allboxes(index(1:on),:));
mm0=zeros(m,n);
for i=1:on
   mm0(boxes(i,2):boxes(i,4),boxes(i,1):boxes(i,3))=mm0(boxes(i,2):boxes(i,4),boxes(i,1):boxes(i,3))+1;
end
if max(mm0(:))
    mm0=normalize(mm0);
end
ObjPrior = mm0;
