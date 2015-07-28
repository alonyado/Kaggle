function [kl_d, maxD,maxD2, smp_falses, smp_true]=exploreHist( ...
    s_id, fp_v, feat_num)

if ~exist('feat_num', 'var')
    feat_num = 6;
end

prtRes = true;
if nargout > 0
    prtRes = false;
end

fs = 150; %each 100 ms

vv = unique(s_id);

if prtRes
    figure;
    hold on;
end

smp_falses =[];
smp_true =[];

mmin = -300;
mmax = 300;
ssz = 15;

rng = mmin:((mmax-mmin)/ssz):mmax;
for i=vv
    ind = s_id == i;
    f_val = fp_v(feat_num,ind);
    f_val = f_val - median(f_val);
    for k=1:fs:size(f_val,2)
        fft_vec = hist(f_val(k:min(k+fs,end)), rng) ;
        
        if k >= 600
            continue;
        end
        if k+fs >= 500
            %             plot(fft_vec(1:round(end/2)), 'o');
            fft_vec = hist(f_val(500:650), rng) ;
            %             f = f(10:end);
            % plot(f,fft_vec(1:round(length(fft_vec)/2)), 'o');
            smp_true = [smp_true; fft_vec];
        else
            %             plot(fft_vec(1:round(end/2)), 'Color',[rand(1,3)]);
            if prtRes
                plot(fft_vec, 'Color',rand(1,3));
            end
            smp_falses = [smp_falses; fft_vec];
        end
    end
end
avg_falses = sum(smp_falses) / size(smp_falses,1);
avg_true = sum(smp_true) / size(smp_true,1);


% kl_f = [];
% disnaceFunc = @kld;
% disnaceFunc = 'euclidean';
disnaceFunc = 'correlation';

allD = pdist2(smp_falses, smp_falses, disnaceFunc);
rr = allD(1,:) ;
rr = rr(~isnan(rr));
maxD = sum(rr)/ length(rr);
allD2 = pdist2(smp_true, smp_true, disnaceFunc);

rr = allD2(1,:) ;
rr = rr(~isnan(rr));
maxD2 = sum(rr)/ length(rr);

kl_d = pdist2(avg_true, avg_falses, disnaceFunc);

if prtRes
    fprintf('max_kld = %f, max_kld2 = %f, kld = %f\n',maxD,maxD2, kl_d);
end

if prtRes
    figure;
    plot(avg_falses, 'r');
    hold on
    plot(avg_true ) ;
end;

end