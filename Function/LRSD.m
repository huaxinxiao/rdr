function SalMap = LRSD(Cut,MeanFeat,SegNum,SegRegion,FgParam,H,W,OriBgSegLabel)

addpath('.\PROPACK');

BgSegLabel = [];
FgSegLabel = [];
MeanCut = mean(Cut);
for j = 1:SegNum
    CurrCut = mean(Cut(SegRegion{j}));
    if CurrCut > FgParam*MeanCut
        FgSegLabel = [FgSegLabel,j];
    elseif CurrCut < 0.5*MeanCut
        BgSegLabel = [BgSegLabel,j];
    end
end
BgSegLabel = unique([BgSegLabel,OriBgSegLabel]);

% LRR
D_Bg = MeanFeat(:,BgSegLabel);
D_Fg = MeanFeat(:,FgSegLabel);
D    = [D_Bg,D_Fg];
Z    = Ladmp(MeanFeat,1,1.9,0,D);

ReconError_Bg = sum((MeanFeat - D_Bg * Z(1:length(BgSegLabel),:)).^2);
ReconError_Fg = sum((MeanFeat - D_Fg * Z(length(BgSegLabel)+1:end,:)).^2);
ReconError_Bg = normalize(ReconError_Bg);
ReconError_Fg = normalize(ReconError_Fg);
ReconError    = ReconError_Bg.*(1-ReconError_Fg);
%ReconError    = max(ReconError_Bg,1-ReconError_Fg);

%Build affine weight matrix
% AffineScale = 10;  %scale = 1/(sigma^2)
% WeiRowNorm = AffineMatrix(MeanFeat,SLIClabel,SegNum,AffineScale);
% [~,ReconError] = ErrorPropagation(ReconError, WeiRowNorm, SegNum);
SalMap = Error2Map(ReconError,H,W,SegNum,SegRegion);
% SalMap1 = Error2Map(ReconError_Bg,H,W,SegNum,SegRegion);
% SalMap2 = Error2Map(ReconError_Fg,H,W,SegNum,SegRegion);

% E = sum(abs(E));
% SalMap1 = Error2Map(E,H,W,SegNum,SegRegion);
% figure,imshow(SalMap1);






