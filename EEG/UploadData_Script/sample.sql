SELECT * FROM
(SELECT subject_num, series_numeric, frame_numeric, is_test, fp1, fp2, 
       f7, f3, fz, f4, f8, fc5, fc1, fc2, fc6, t7, c3, cz, c4, t8, tp9, 
       cp5, cp1, cp2, cp6, tp10, p7, p3, pz, p4, p8, po9, o1, oz, o2, 
       po10,
       row_number() OVER (ORDER BY null) AS i
  FROM kaggle.eeg_subjects ) T
  where i<= 10
