function SegRegion = getSegRegion(SLIClabel,SegNum)

SegRegion = cell(SegNum,1);
for i = 1:SegNum
   SegRegion{i} = single(find(SLIClabel==i));
end
