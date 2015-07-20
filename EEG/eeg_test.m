dbConn = database('postgres','matlab','viper','Vendor','PostGreSQL');

curr = exec(dbConn,['SELECT  tot_id, frame_id,  fp1 ,  fp2 ,  f7 ,  f3 ,  fz ,  f4 ,  f8 ,  fc5 ,  fc1 ,  fc2 ,  fc6 ,  t7 ,  c3 ,  cz ,  c4 ,  t8 ,  tp9 ,  cp5 ,  cp1 ,  cp2 ,  cp6 ,  tp10 ,  p7 ,  p3 ,  pz ,  p4 ,  p8 ,  po9 ,  o1 ,  oz , o2 , po10 , goal_val ' ...
    'FROM kaggle.eeg_prefix ' ...
    ' where subject_num = 3 and series_numeric <= 4 and seq_id <= 3' ...
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

%%
% 6
clc;

ffff = 6;

fs = 100;
ffs = fs*5;

vv = unique(s_id);
st = 10;

close all force;
figure;
hold on;
smp_falses =[];
smp_true =[];
for i=vv
    ind = s_id == i;
    f_val = fp_v(ffff,ind);
    for k=1:fs:size(f_val,2)
        fft_vec = abs(fft(f_val(k:min(k+fs,end)),ffs));
        
        f = fs/2*linspace(0,1,round(length(fft_vec)/2));
        fft_vec = fft_vec(st:end);
        f = f(st/2:end);
        if k >= 600
            continue;
        end
        if k+fs >= 500
%             plot(fft_vec(1:round(end/2)), 'o');
            
            fft_vec = abs(fft(f_val(500:650), ffs));
            fft_vec = fft_vec(st:end);
%             f = f(10:end);
plot(f,fft_vec(1:round(length(fft_vec)/2)), 'o');
smp_true = [smp_true; fft_vec];
        else
%             plot(fft_vec(1:round(end/2)), 'Color',[rand(1,3)]);
            plot(f,fft_vec(1:round(length(fft_vec)/2)), 'Color',[rand(1,3)]);
            smp_falses = [smp_falses; fft_vec];
        end
    end
end
avg_falses = sum(smp_falses) / size(smp_falses,1);
avg_true = sum(smp_true) / size(smp_true,1);


kl_f = [];
allD = pdist2(smp_falses, smp_falses,@kld);
maxD = max(allD(:));
allD2 = pdist2(smp_true, smp_true,@kld);
maxD2 = max(allD2(:));

kl_d = kld(avg_true, avg_falses);

fprintf('max_kld = %f, max_kld2 = %f, kld = %f\n',maxD,maxD2, kl_d);
% plot(abs(fft(fp_v(13,1:500))), '.-r');
% hold on;
% plot(abs(fft(fp_v(13,500:end))), '.-')
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
% vv = unique(s_id);
% close all force;
% figure;
% hold on;
% j = 0;
% for i=vv
%     ind = s_id == i;
%     frames = frame_id(ind);
%     f_val = fp(ind);
% %     figure;
% % fprintf('%d\n', i);
%     plot(frames, f_val, '-', 'Color',[rand(1,3)]);
%     j = j +1;
%     if j >= 2
%         break;
%     end
% end