clear all
clc
addpath /Applications/MATLAB_R2016b.app/toolbox/eeglab14_1_1b
eeglab


%% 

% load eeg using .vhdr - PUT CORRECT FILENAME HERE
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
EEG = pop_loadbv('/omega/HV011/HV011_S1', 'HV011_S1_rfdi_pre.vhdr');
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 0,'gui','off'); 

%% 

% lookup channel locations
EEG=pop_chanedit(EEG, 'lookup','/Applications/MATLAB_R2016b.app/toolbox/eeglab14_1_1b/plugins/dipfit2.2/standard_BESA/standard-10-5-cap385.elp');
[ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
EEG = eeg_checkset( EEG );

% extract epochs and demean - longer epochs - check number of event ('S126' for Brainamp)

EEG = pop_epoch( EEG, {  'S 13'  }, [-1.3  1.3], 'epochinfo', 'yes');
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'gui','off'); 
EEG = eeg_checkset( EEG );
EEG = pop_rmbase( EEG, [-1000 -10]);
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 2,'gui','off'); 

% Plot Data to MARK bad trials
EEG = eeg_checkset( EEG );
pop_eegplot( EEG, 1, 1, 0);
uiwait;

% Index of rejected trials
index_rejected_trials = EEG.reject.rejmanual == 1;
index_rejected_trials = find(index_rejected_trials);

% Plot Data to reject bad trials
EEG = eeg_checkset( EEG );
pop_eegplot( EEG, 1, 1, 1);
uiwait;

% Interpolate bad electrodes
EEG = eeg_checkset( EEG );
EEG = pop_interp(EEG);

% remove stimulation artefact
EEG = eeg_checkset( EEG );
EEG = pop_tesa_removedata( EEG, [-5 15] );
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 3,'gui','off'); 

% downsample to 1000 Hz
EEG = eeg_checkset( EEG );
EEG = pop_resample( EEG, 1000);
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 5,'gui','off'); 

%fastICA 1st round
EEG = pop_tesa_fastica( EEG, 'approach', 'symm', 'g', 'tanh', 'stabilization', 'off' );
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 4,'gui','off'); 
EEG = pop_tesa_compselect( EEG,'compCheck','on','comps',15,'figSize','large','plotTimeX',[-200 500],'plotFreqX',[1 100],'tmsMuscle','on','tmsMuscleThresh',8,'tmsMuscleWin',[11 30],'tmsMuscleFeedback','off','blink','off','blinkThresh',2.5,'blinkElecs',{'Fp1','Fp2'},'blinkFeedback','off','move','off','moveThresh',2,'moveElecs',{'F7','F8'},'moveFeedback','off','muscle','off','muscleThresh',0.6,'muscleFreqWin',[30 100],'muscleFeedback','off','elecNoise','off','elecNoiseThresh',4,'elecNoiseFeedback','off' );
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 5,'gui','off'); 

% interpolate removed data
EEG = eeg_checkset( EEG );
EEG = pop_tesa_interpdata( EEG, 'cubic', [1 1] );
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 4,'gui','off'); 

% Bandpass (1-100 Hz) filter and Bandstop (48-52 Hz) filter
EEG = pop_tesa_filtbutter( EEG, 1, 100, 4, 'bandpass' );
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 5,'gui','off'); 
EEG = eeg_checkset( EEG );
EEG = pop_tesa_filtbutter( EEG, 48, 52, 4, 'bandstop' );

% extract epochs and demean - shorter epochs to cut edge artefacts - check number of event ('S126' for Brainamp)
EEG = pop_epoch( EEG, {  'S 13'  }, [-1  1], 'epochinfo', 'yes');
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'gui','off'); 
EEG = eeg_checkset( EEG );
EEG = pop_rmbase( EEG, [-1000 -10]);
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 2,'gui','off'); 

% remove TMS artefact before second ICA 
EEG = pop_tesa_removedata( EEG, [-5 15] );
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 7,'gui','off'); 

EEG = pop_tesa_fastica( EEG, 'approach', 'symm', 'g', 'tanh', 'stabilization', 'off' );
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 10,'gui','off'); 
EEG = pop_tesa_compselect( EEG,'compCheck','on','comps',[],'figSize','large','plotTimeX',[-999 999],'plotFreqX',[1 100],'tmsMuscle','on','tmsMuscleThresh',8,'tmsMuscleWin',[11 30],'tmsMuscleFeedback','off','blink','on','blinkThresh',2.5,'blinkElecs',{'Fp1','Fp2'},'blinkFeedback','off','move','on','moveThresh',2,'moveElecs',{'F7','F8'},'moveFeedback','off','muscle','on','muscleThresh',0.6,'muscleFreqWin',[30 100],'muscleFeedback','off','elecNoise','on','elecNoiseThresh',4,'elecNoiseFeedback','off' );
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 11,'gui','off');

% interpolate removed data
EEG = eeg_checkset( EEG );
EEG = pop_tesa_interpdata( EEG, 'cubic', [1 1] );
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 10,'gui','off'); 

%% Split trials into single pulse and SICI 70, 80, 90
conditions(index_rejected_trials) = 0;
conditions = conditions(conditions ~= 0);

re_referenced_eeg = pop_reref( EEG, []);

single_pulse_eeg = EEG;
sici_70_eeg = EEG;
sici_80_eeg = EEG;
sici_90_eeg = EEG;
reref_single_pulse_eeg = EEG;
reref_sici_70_eeg = EEG;
reref_sici_80_eeg = EEG;
reref_sici_90_eeg = EEG;

single_pulse_index = conditions==1;
single_pulse_index = find(single_pulse_index);
sici_70_index = conditions==2;
sici_70_index = find(sici_70_index);
sici_80_index = conditions==3;
sici_80_index = find(sici_80_index);
sici_90_index = conditions==4;
sici_90_index = find(sici_90_index);

single_pulse_eeg.data = EEG.data(:,:,single_pulse_index);
sici_70_eeg.data = EEG.data(:,:,sici_70_index);
sici_80_eeg.data = EEG.data(:,:,sici_80_index);
sici_90_eeg.data = EEG.data(:,:,sici_90_index);

reref_single_pulse_eeg.data = re_referenced_eeg.data(:,:,single_pulse_index);
reref_sici_70_eeg.data = re_referenced_eeg.data(:,:,sici_70_index);
reref_sici_80_eeg.data = re_referenced_eeg.data(:,:,sici_80_index);
reref_sici_90_eeg.data = re_referenced_eeg.data(:,:,sici_90_index);

single_pulse_eeg.trials = size(single_pulse_eeg.data); % Insert correct number of trials to produce ERP maps
single_pulse_eeg.trials = single_pulse_eeg.trials(3);
sici_70_eeg.trials = size(sici_70_eeg.data);
sici_70_eeg.trials = sici_70_eeg.trials(3);
sici_80_eeg.trials = size(sici_80_eeg.data);
sici_80_eeg.trials = sici_80_eeg.trials(3);
sici_90_eeg.trials = size(sici_90_eeg.data);
sici_90_eeg.trials = sici_90_eeg.trials(3);

single_pulse_eeg.trials = size(single_pulse_eeg.data); % Insert correct number of trials to produce ERP maps
reref_single_pulse_eeg.trials = single_pulse_eeg.trials(3);
sici_70_eeg.trials = size(sici_70_eeg.data);
reref_sici_70_eeg.trials = sici_70_eeg.trials(3);
sici_80_eeg.trials = size(sici_80_eeg.data);
reref_sici_80_eeg.trials = sici_80_eeg.trials(3);
sici_90_eeg.trials = size(sici_90_eeg.data);
reref_sici_90_eeg.trials = sici_90_eeg.trials(3);
%% Raw plots

figure; pop_plottopo(single_pulse_eeg, [1:63] , 'single pulse', 0, 'ydir',1);
figure; pop_timtopo(single_pulse_eeg, [-100  300], [NaN]), 'single pulse ERP data and scalp maps';

figure; pop_plottopo(sici_70_eeg, [1:63] , 'sici 70', 0, 'ydir',1);
figure; pop_timtopo(sici_70_eeg, [-100  300], [NaN]), 'sici 70 ERP data and scalp maps';

figure; pop_plottopo(sici_80_eeg, [1:63] , 'sici 80', 0, 'ydir',1);
figure; pop_timtopo(sici_80_eeg, [-100  300], [NaN]), 'sici 80 ERP data and scalp maps';

figure; pop_plottopo(sici_90_eeg, [1:63] , 'sici 90', 0, 'ydir',1);
figure; pop_timtopo(sici_90_eeg, [-100  300], [NaN]), 'sici 90 ERP data and scalp maps';

%% Re-referenced plots

figure; pop_plottopo(reref_single_pulse_eeg, [1:63] , 'single pulse', 0, 'ydir',1);
figure; pop_timtopo(reref_single_pulse_eeg, [-100  300], [NaN]), 'single pulse ERP data and scalp maps';

figure; pop_plottopo(reref_sici_70_eeg, [1:63] , 'sici 70', 0, 'ydir',1);
figure; pop_timtopo(reref_sici_70_eeg, [-100  300], [NaN]), 'sici 70 ERP data and scalp maps';

figure; pop_plottopo(reref_sici_80_eeg, [1:63] , 'sici 80', 0, 'ydir',1);
figure; pop_timtopo(reref_sici_80_eeg, [-100  300], [NaN]), 'sici 80 ERP data and scalp maps';

figure; pop_plottopo(reref_sici_90_eeg, [1:63] , 'sici 90', 0, 'ydir',1);
figure; pop_timtopo(reref_sici_90_eeg, [-100  300], [NaN]), 'sici 90 ERP data and scalp maps';

%% TEP Analysis
single_pulse_LMFP = pop_tesa_tepextract( reref_single_pulse_eeg, 'ROI', 'elecs', {'FC1','FC3','C1','C3'} );
single_pulse_GMFP = pop_tesa_tepextract( reref_single_pulse_eeg, 'GMFA');
single_pulse_n100_LMFP = pop_tesa_peakanalysis( single_pulse_LMFP, 'ROI', 'negative', 100, [80,120] );
single_pulse_p30_p60_LMFP = pop_tesa_peakanalysis( single_pulse_LMFP, 'ROI', 'positive', [30,60], [15,35;55,75], 'method','centre', 'samples', 5);
single_pulse_GMFP_peaks = pop_tesa_peakanalysis( single_pulse_GMFP, 'GMFA', 'positive', [30,60,180],[20,40;50,70;170,190]);
%% 

% save dataset - CHANGE FILENAME 
EEG = pop_saveset( EEG, 'filename','Lorenzo_single_pulse.set','filepath','/Users/Vish 1/Desktop/MND/SICI');
[ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);

% clear EEGLAB
ALLEEG = pop_delset( ALLEEG, [1] );
STUDY = []; CURRENTSTUDY = 0; ALLEEG = []; EEG=[]; CURRENTSET=[];