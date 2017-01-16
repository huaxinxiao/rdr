function [MeanFeat,Refeatureimg] = ExtractFeature(img,SegNum,SegRegion)

[height,width,~] = size(img);
dim = 10;
location_param = 0.5;
featureimg = zeros(height,width,dim);
Refeatureimg = zeros(dim,height*width);

%% Color
img1 = double(img);  
img2 = rgb2hsv(double(img)); 
im_lab = colorspace_('Lab<-',img1);  

featureimg(:,:,1:3) = img1; %RGB
featureimg(:,:,4) = (img2(:,:,1)-0.5).*255;  %HSV
featureimg(:,:,5) = img2(:,:,2).*255;  %HSV
featureimg(:,:,6:8) = im_lab;  %LAB

%% location
[X,Y] = meshgrid(1:width,1:height);  %location 
featureimg(:,:,9) = X;
featureimg(:,:,10) = Y;

temp = 1;
for j=1:width
    for i=1:height
        Refeatureimg(:,temp) = reshape(featureimg(i,j,:),dim,1);
        temp = temp+1;
    end
end

for i = 1:dim
    Refeatureimg(i,:) = normalize(Refeatureimg(i,:));
end
Refeatureimg(9:10,:) = location_param.* Refeatureimg(9:10,:);

MeanFeat = zeros(dim,SegNum);
for j = 1:SegNum
    MeanFeat(:,j) = mean(Refeatureimg(:,SegRegion{j}),2);
end
