function EuclMetric = DiffWeight(MeanFeat,SegNum,BgSegLabel)

%EuclMetric = zeros(SegNum,SegNum,4);
EuclMetric = zeros(SegNum,SegNum);
for j = 1:SegNum
    CurrFeat  = repmat(MeanFeat(:,j),1,length(BgSegLabel));
    diff = sum((CurrFeat - MeanFeat(:,BgSegLabel)).^2);
%     EuclMetric(j,BgSegLabel,1) = sum((CurrFeat(1:3,:) - MeanFeat(1:3,BgSegLabel)).^2); %RGB
%     EuclMetric(j,BgSegLabel,2) = sum((CurrFeat(4:5,:) - MeanFeat(4:5,BgSegLabel)).^2); %LAB
%     EuclMetric(j,BgSegLabel,3) = sum((CurrFeat(6:17,:) - MeanFeat(6:17,BgSegLabel)).^2./(CurrFeat(6:17,:) + MeanFeat(6:17,BgSegLabel) + eps))./2; %HOG
%     EuclMetric(j,BgSegLabel,4) = sum((CurrFeat(18:53,:) - MeanFeat(18:53,BgSegLabel)).^2./(CurrFeat(18:53,:) + MeanFeat(18:53,BgSegLabel) + eps))./2; %HOG
     EuclMetric(j,BgSegLabel) = diff;
end

% for j = 1:4
%     EuclMetric(:,:,j) = normalize(EuclMetric(:,:,j));
% end
% EuclMetric= sum(EuclMetric,3);  
EuclMetric = EuclMetric + EuclMetric';
EuclMetric = abs(-log(1 - EuclMetric + 0.0000001));
EuclMetric = normalize(EuclMetric);