function [peak]=GetPeak(x)

th = 0.95;
[mve, ve, dfA]=Hlp.FindNextMaximum(x, th, 10);
if (dfA ==1)
    st = find(x >= mve*th,1,'first');
    ed = find(x >= mve*th,1,'last');
    ind = round((st+ed)/2);
    peak = ind;
else
    figure;
    plot(x);
    
    error(['more then one peak - ' num2str(dfA) ]);
end

end