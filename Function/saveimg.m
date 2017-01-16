function saveimg(flag,sal,H,W,saveroot)

if(flag) 
    saliency=zeros(H,W); 
    saliency(flag+1:H-flag,flag+1:W-flag)=sal;
else
    saliency=sal;
end

saliency=normalize(saliency);
imwrite(saliency,saveroot);


