function [y]=plotFFT(x)

printRes = true;
if nargout >0
    printRes = false;
end

st = round(0.05 * length(x));

y = fft(x, length(x) * 5 );
y = abs(y);
y = y(st:round(length(y)/2));
if printRes
%     figure;
    plot( st:length(y)+st-1 ,y);
end

end
