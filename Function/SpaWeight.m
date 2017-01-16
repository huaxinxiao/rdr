function [SpatialWei,ObjWei] = SpaWeight(img,SegNum,SegRegion)

addpath('.\geObj_code');
addpath('.\seg_code');

[H,W,~] = size(img);
object_on   = 3000;

% objectness prior
[~, allboxes] = runObjectness(img,0);
[~,index]     = sort(allboxes(:,5),'descend');
boxes         = floor(allboxes(index(1:object_on),:));
ObjectPrior   = zeros(H,W);

for j=1:object_on
    ObjectPrior(boxes(j,2):boxes(j,4),boxes(j,1):boxes(j,3))=ObjectPrior(boxes(j,2):boxes(j,4),boxes(j,1):boxes(j,3))+1;
end
if max(ObjectPrior(:))
    ObjectPrior = normalize(ObjectPrior);
end

SpatialWei = zeros(SegNum,1);
ObjWei = zeros(SegNum,1);
[X,Y] = meshgrid(1:W,1:H);
Obj_X = X.* ObjectPrior;
Obj_Y = Y.* ObjectPrior;
xcenter = sum(Obj_X(:))/sum(ObjectPrior(:));
ycenter = sum(Obj_Y(:))/sum(ObjectPrior(:));

X = X(:); Y = Y(:); 
for j = 1:SegNum
    meanX = mean(X(SegRegion{j}));  
    meanY = mean(Y(SegRegion{j}));  
    SpatialWei(j) = exp(-(meanX-xcenter)^2/(2*(0.25*W)^2) - (meanY-ycenter)^2/(2*(0.25*H)^2));
    ObjWei(j)     = exp(mean(ObjectPrior(SegRegion{j})));
end
SpatialWei = normalize(SpatialWei);
ObjWei = normalize(ObjWei);



