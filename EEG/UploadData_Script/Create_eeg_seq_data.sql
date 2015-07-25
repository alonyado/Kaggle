create table kaggle.eeg_seq_data as
with after_j as
(select es.*, et.is_handstart, et.is_firstdigittouch, et.is_bothstartloadphase, et.is_liftoff, et.is_replace, et.is_bothreleased 
from kaggle.eeg_subjects es join kaggle.eeg_tagging_train et on 
es.subject_num = et.subject_num and es.series_numeric = et.series_numeric and es.frame_numeric = et.frame_numeric
--limit 10
)

,trasn as
( select subject_num, series_numeric, frame_numeric,
  fp1 ,
  fp2 ,
  f7 ,
  f3 ,
  fz ,
  f4 ,
  f8 ,
  fc5 ,
  fc1 ,
  fc2 ,
  fc6 ,
  t7 ,
  c3 ,
  cz ,
  c4 ,
  t8 ,
  tp9 ,
  cp5 ,
  cp1 ,
  cp2 ,
  cp6 ,
  tp10 ,
  p7 ,
  p3 ,
  pz ,
  p4 ,
  p8 ,
  po9 ,
  o1 ,
  oz ,
  o2 ,
  po10 ,
 is_handstart as goal_val
 from after_j ) 

, wt_lag as
 (select trasn.*
 ,lag(goal_val) over(partition by subject_num, series_numeric order by frame_numeric) as lag_val
  from trasn)

, seqs as
  (select wt_lag.*
  , (case when lag_val <> goal_val then
  (case
  when goal_val = True  then 'Start'
  else 'End'
   end)
   end) as state_seq
   , (case when lag_val <> goal_val then
  (case
  when goal_val = True  then frame_numeric
  else frame_numeric - 1
   end)
   end) as fr_num
   from wt_lag)

, start_seq as  (select s.*, dense_rank() over (partition by subject_num, series_numeric order by fr_num) as seq_id
 from seqs s where state_seq = 'Start')
, end_seq as  (select s.*, dense_rank() over (partition by subject_num, series_numeric order by fr_num) as seq_id from seqs s where state_seq = 'End')
, start_end_seq as 
(
select s.subject_num, s.series_numeric, s.seq_id, s.fr_num as start_frame, e.fr_num as end_frame
 from start_seq s join end_seq e on
s.subject_num = e.subject_num and s.series_numeric = e.series_numeric 
and s.seq_id = e.seq_id
)

--select * from start_end_seq;

, seq_data as
(select t.*, ss.seq_id, ss.start_frame, ss.end_frame  from trasn t 
join start_end_seq ss on
ss.subject_num = t.subject_num and ss.series_numeric = t.series_numeric 
and t.frame_numeric >= ss.start_frame - 500 and t.frame_numeric <= ss.end_frame + 500)

select * from seq_data order by subject_num, series_numeric, seq_id, frame_numeric


