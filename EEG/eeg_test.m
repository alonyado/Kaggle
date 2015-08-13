dbConn = database('postgres','matlab','viper','Vendor','PostGreSQL');

curr = exec(dbConn,['SELECT  tot_id, frame_id,  fp1 ,  fp2 ,  f7 ,  f3 ,  fz ,  f4 ,  f8 ,  fc5 ,  fc1 ,  fc2 ,  fc6 ,  t7 ,  c3 ,  cz ,  c4 ,  t8 ,  tp9 ,  cp5 ,  cp1 ,  cp2 ,  cp6 ,  tp10 ,  p7 ,  p3 ,  pz ,  p4 ,  p8 ,  po9 ,  o1 ,  oz , o2 , po10 , goal_val ' ...
    'FROM kaggle.eeg_prefix ' ...
    ' where subject_num = 2 and series_numeric <= 5 and seq_id <= 4' ...
    'order by tot_id, frame_id ']);
dataRows = fetch(curr);
data = dataRows.Data;
%%
s_id = [data{:,1}];
frame_id = [data{:,2}];
fp_v = [];
for i=3:size(data,2)-1
    fp = [data{:,i}];
    fp_v = [fp_v ; fp];
end
goal_val = [data{:,end}];
%% plot fft twice
[kl_d, mkld, mkld2, sm_f, sm_t] = exploreFFT(s_id, fp_v, 6);

av_t = sum(sm_t);
av_t = av_t(1:round(length(av_t)/2));

av_f = sum(sm_f);
av_f = av_f(1:round(length(av_f)/2));

falses_arr = plotFFT( av_f);
[true_arr, st] = plotFFT( av_t);

plotFFT( av_f);
hold on
plot( st:length(true_arr)+ ...
    st-1 ,true_arr, 'r');

fPeak = st+GetPeak(falses_arr);
tPeak = st+GetPeak(true_arr);
fprintf('falsePaek = %d, truePeak=%d\n', round(fPeak), round(tPeak));

%%
% 6
clc;
close all force;
good_feats = nan(1,size(fp_v,1));
kld_f = nan(1,size(fp_v,1));
for feat_num = 1:size(fp_v,1)
    [kl_d, mkld, mkld2] = exploreHist(s_id, fp_v, feat_num);
    kld_f(feat_num) = mkld;
    if (kl_d > max(mkld, mkld2))
        good_feats(feat_num) = kl_d / max(mkld, mkld2);
        fprintf('feat_num=%d, Good %f, mkld = (%f, %f)\n',feat_num, kl_d, mkld, mkld2);
    end
end

%%
close all force;
figure;
hold on;

% 10:15, 15:20, 20:25, 30:35
for i=10:20
    f_val = fp_v(i,:);
    frames = frame_id;
    plot(frames, f_val, '-', 'Color',[rand(1,3)]);
end

%%
ffff = 6;
vv = unique(s_id);
close all force;
figure;
hold on;
j = 0;
for i=vv
    ind = s_id == i;
    frames = frame_id(ind);
    f_val = fp_v(ffff, ind);
    f_val = f_val - median(f_val);
    f_val= zscore(f_val);
%     figure;
% fprintf('%d\n', i);
    
    j = j +1;
    if j<0
        continue;
    end
    if j >= 2
        break;
    end
    plot(frames, f_val, '.-', 'Color',[rand(1,3)]);
end
