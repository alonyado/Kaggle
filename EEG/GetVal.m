function [peakArr]=GetVal(s_id, fp_v, feat_num)

if ~exist('feat_num', 'var')
    feat_num = 6;
end
prtRes = true;
if nargout > 0
    prtRes = false;
end

fs = 100; %each 100 ms
vv = unique(s_id);

peakArr = [];
for i=vv
    ind = s_id == i;
    f_val = fp_v(feat_num,ind);
    for k=1:fs:size(f_val,2)
        fft_vec = plotFFT(f_val(k:min(k+fs,end)) );                
        [fft_vec2 , st] = plotFFT(fft_vec);
        peak = st + GetPeak(fft_vec2);
        peakArr = [peakArr peak];
      
    end
end

if prtRes
    figure;
    plot(peakArr);
    hold on;
    plot(1:length(peakArr), 260*ones(1,length(peakArr)), 'r');
end


end