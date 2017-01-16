function boxes = DropRepWin(boxes)

win = boxes(:,1:4);

bRep = 1;

nStart = 1;
while(bRep==1)
    nWin = size(win,1);
    
    for k=nStart:nWin
        tmp = sum(abs(win-repmat(win(k,:),[nWin 1])), 2);
        nSame = sum(tmp==0)-1;
        nStart = nStart+1;
        if(nSame>0)
            tmp(k) = 1;
            win = win(tmp>0,:);
            boxes = boxes(tmp>0,:);
            bRep = 1;
            break;
        else
            bRep = 0;
        end
    end
    if(nStart>nWin)
        bRep = 0;
    end
        
end