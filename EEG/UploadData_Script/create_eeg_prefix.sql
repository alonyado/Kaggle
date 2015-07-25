create table kaggle.eeg_prefix as
select k.*, 
dense_rank() over (order by subject_num, series_numeric, seq_id) as tot_id,
dense_rank() over (partition by subject_num, series_numeric, seq_id order by frame_numeric) as frame_id
 from kaggle.eeg_seq_data k
where frame_numeric <= end_frame
order by subject_num, series_numeric, seq_id, frame_numeric;