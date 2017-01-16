function [SalMap,Error] = Error2Map(Error,H,W,SegNum,SegRegion)

SalMap = zeros(H,W);
Error  = normalize(Error);
for j = 1:SegNum
   SalMap(SegRegion{j}) = Error(j); 
end