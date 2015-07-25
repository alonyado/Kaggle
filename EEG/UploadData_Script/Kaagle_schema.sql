create table kaggle.eeg_subjects 
(
subject_num numeric,
series_numeric numeric,
frame_numeric numeric,
is_test boolean,
Fp1 numeric,
Fp2 numeric,
F7  numeric,
F3  numeric,
Fz  numeric,
F4  numeric,
F8 numeric,
FC5 numeric,
FC1  numeric,
FC2 numeric,
FC6  numeric,
T7 numeric,
C3 numeric,
Cz numeric,
C4 numeric,
T8 numeric,
TP9 numeric,
CP5 numeric,
CP1 numeric,
CP2 numeric,
CP6 numeric,
TP10 numeric,
P7 numeric,
P3 numeric,
Pz numeric,
P4 numeric,
P8 numeric,
PO9 numeric,
O1 numeric,
Oz numeric,
O2 numeric,
PO10 numeric
);


create table kaggle.eeg_tagging_train
(
subject_num numeric,
series_numeric numeric,
frame_numeric numeric,
is_HandStart boolean,
is_FirstDigitTouch boolean,
is_BothStartLoadPhase boolean,
is_LiftOff boolean,
is_Replace boolean,
is_BothReleased boolean
);

create table kaggle.eeg_tagging_results
(
subject_num numeric,
series_numeric numeric,
frame_numeric numeric,
is_HandStart boolean,
is_FirstDigitTouch boolean,
is_BothStartLoadPhase boolean,
is_LiftOff boolean,
is_Replace boolean,
is_BothReleased boolean
);