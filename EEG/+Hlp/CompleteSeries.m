function [ newVec, sectionsInd, endInd ] = CompleteSeries( vec, skipCount )
%CompleteSeries likeimclose for boolean vector

goodInd = find(vec);
sectionsInd = [];
endInd = [];

newVec = vec;

startInd = -1;
for i = 1:length(goodInd)
    gI = goodInd(i);
    if (startInd == -1)
        startInd = gI;
    end;
    sk = 1;
    toUpdate = [];
    while (sk <= skipCount && (gI + sk) <= length(vec) && ~vec(gI + sk))
        toUpdate = [toUpdate (gI + sk)];
        sk = sk + 1;
    end;
    if ((gI + sk) > length(vec))
        succ = false;
    else
        succ = vec(gI + sk);
    end;
    
    if (succ && ~isempty(toUpdate))
        newVec(toUpdate) = true;
    end;
    
    if (~succ || (gI + sk) > length(vec)) % reach new section!
        sectionsInd = [sectionsInd startInd];
        endInd = [endInd gI];
        startInd = -1;
    end;
    
end


end

