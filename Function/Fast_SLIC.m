function [SegNum,SLIClabel,SegRegion] = Fast_SLIC(H,W,img,compactness,spnumber)

im_double = double(img);  
ImgVecR = reshape( im_double(:,:,1)', H*W, 1); 
ImgVecG = reshape( im_double(:,:,2)', H*W, 1);
ImgVecB = reshape( im_double(:,:,3)', H*W, 1);
ImgProp = [H, W, spnumber, compactness, H*W];
[raw_label, ~, ~, ~, SegNum] = SLIC(ImgVecR,ImgVecG,ImgVecB,ImgProp);
label = reshape(raw_label, W, H);
SLIClabel = label' + 1;
SegRegion = getSegRegion(SLIClabel,SegNum);

