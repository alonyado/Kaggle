function [y, st]=plotFFT(x)

printRes = true;
if nargout >0
    printRes = false;
end

mltFactor = 5;
stFactor = 0.1;



y = fft(x, length(x) * mltFactor );
y = abs(y);

st = round(stFactor * length(y));
y = y(st:round(length(y)/2));

if printRes
%     figure;
    plot( st:length(y)+st-1 ,y);
end

end
