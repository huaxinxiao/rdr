clc;
clear all;
close all;

addpath('.\Function');

%parameter
compactness = 15;
spnumber    = 150;
FgParam     = 1;
imgRoot = '.\input\'; % test image path
outRoot = '.\output\';
imnames=dir([imgRoot '*' 'png']);


for i = 1:length(imnames)
    disp(['Process # ',num2str(i),' ...']);
    imname  = [imgRoot imnames(i).name]; 
    img = imread(imname);
    [H_Ori,W_Ori,~] = size(img);
    [img,flag] = cutframe(img); 
    img = uint8(img);
    [H,W,~] = size(img);
        
    %graph cut
    [AA,g] = GraphCut(img);
    
    %SLIC
    [SegNum,SLIClabel,SegRegion] = Fast_SLIC(H,W,img,compactness,spnumber);
    
    %Feature
    [MeanFeat,~] = ExtractFeature(img,SegNum,SegRegion);

    %boundry
    BgSegLabel = Extract_bg_sp(SLIClabel,H,W);
    
    %spatial weight based on object prior
    [SpatialWei,ObjWei] = SpaWeight(img,SegNum,SegRegion);

    %feature vector difference weight
    DiffWei = DiffWeight(MeanFeat,SegNum,BgSegLabel);
 
    %saliency
    saliency = SpatialWei.*sum(DiffWei(:,BgSegLabel), 2).*ObjWei;
    saliency = normalize(saliency);
    clear SpatialWei ObjWei DiffWei;
    
    %saliency to map
    Map = Error2Map(saliency,H,W,SegNum,SegRegion);
    
    %GRAPH CUT
    Cut1 = graphcut0(AA,g,Map); 
    saveroot = [outRoot,imnames(i).name(1:end-4),'-step2.jpg'];
    saveimg(flag,Cut1,H_Ori,W_Ori,saveroot);
    clear Map;
        
    %Low rank and sparse decompose
    SalMap = LRSD(Cut1,MeanFeat,SegNum,SegRegion,FgParam,H,W,BgSegLabel);
    Cut2 = graphcut0(AA,g,SalMap); 
    saveroot = [outRoot,imnames(i).name(1:end-4),'-setp4.jpg'];
    saveimg(flag,Cut2,H_Ori,W_Ori,saveroot);
    
     %combine
%      SalMap = normalize(Cut1 + Cut2);
%      saveroot = [outRoot,imnames(i).name(1:end-4),'.jpg'];
%      saveimg(flag,SalMap,H_Ori,W_Ori,saveroot);
end

