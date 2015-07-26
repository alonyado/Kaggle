function [ newVec, sectionsInd, endInd ] = WrapSeries( vec,wrapCount )
%WrapSeries wraps the bollean vector with ones around each one.
goodInd = find(vec);

newVec = vec;
for i = 1:length(goodInd)
    gI = goodInd(i);
    minIndex = round(max(1, gI - wrapCount));
    maxIndex = round(min(length(vec), gI + wrapCount));
    newVec(minIndex:maxIndex) = 1;
end

[~, sectionsInd, endInd] = Helper.CompleteSeries(newVec, 1);

end

