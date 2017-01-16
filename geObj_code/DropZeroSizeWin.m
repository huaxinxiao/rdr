function boxes = DropZeroSizeWin(boxes)

win = boxes(:,1:4);
area = (win(:,4)-win(:,2)).*(win(:,3)-win(:,1));
boxes = boxes(area>0,:);