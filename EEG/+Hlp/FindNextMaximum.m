
function [maxValue, valVectorEdit, diffAreas]= FindNextMaximum(valVector, ...
    fromMaxPerc, wrapSz)
% this function finds the next maximum in the value vector - the search is
% iterative. first we search for all the indexes that pass the maximum
% threshold. valVector >= max(valVector) * threshold (named fromMaxPerc)  
% and then iteratevly it removes those valVector indexes from valVectorEdit
% that we can search for next maximum afterwards. it also uses wrapSz to
% wrap the maximum area to remove for next time
% it returns the maximum value, the valVector after removing the maximum
% points and how many peaks(diffrent zones not connected) are there in this
% threshold the function promise that the next maximum value will create a
% new indexes zone
%
% example: [maxIs2, vactorWithNo2, diffIs2] = Helper.FindNextMaximum([1 1 1 1 2 1 1 1 2 1 1 1 1], 0.95, 1);
% algoKnights 2014

wrapDiff = 2; % Parameter to be set
if ~exist('fromMaxPerc', 'var')
    fromMaxPerc = 0.97; % Parameter to be set
end
if ~exist('wrapSz', 'var')
    wrapSz = 20;  % Parameter to be set
end

valVectorEdit = valVector;

[maxValue, ~] = max(valVector);
toRemove = valVectorEdit >= maxValue * fromMaxPerc;
[toRemove, ss, ~] = Hlp.WrapSeries(toRemove , wrapSz); % wraps the maximum zone
valVectorEdit(toRemove) = -Inf;
diffAreas = length(ss);
if (diffAreas > 1)
    diffAreas = 1 + sum((ss(2:end)-ss(1:end-1)) > 50);
end;

[~, sZ, eZ] = Hlp.CompleteSeries( valVectorEdit == -Inf, 1);

[mTempVal, ~ ] =  max(valVectorEdit);
toRemove = valVectorEdit>=mTempVal * fromMaxPerc;
[~, s, e] = Hlp.WrapSeries( toRemove , wrapSz);
% numS = length(s);
%check if all series are connected to previos areas found!
removeAgain = mTempVal > 0;
while removeAgain
    removeAgain = false;
    for i = 1:length(s)
        for j = 1:length(sZ)
            condBefore = (sZ(j) - e(i) >= 0 && sZ(j) - e(i) <= wrapDiff) || (e(i) > sZ(j) && e(i) < eZ(j));
            condAfter =   (s(i) - eZ(j) >= 0 && s(i) - eZ(j) <= wrapDiff) || (s(i) > sZ(j) && s(i) < eZ(j));
            cond = condBefore || condAfter;
            if (cond)
                removeAgain = true;
                if (condBefore)
                    sZ(j) = s(i);
                else
                    eZ(j) = e(i);
                end;
                valVectorEdit(sZ(j):eZ(j)) = -Inf;
            end;
        end;
    end;
    
    if removeAgain
        [mTempVal, ~ ] =  max(valVectorEdit);
        toRemove = valVectorEdit>=mTempVal*fromMaxPerc;
        [~, s, e] = Helper.WrapSeries( toRemove , wrapSz);
%         numS = length(s);
        removeAgain = mTempVal > 0;
    end;
end;

end
