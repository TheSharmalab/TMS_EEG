clear all
clc
addpath '/Applications/MATLAB_R2017a.app/toolbox/eeglab-952938e2c0ae800ef6ccf50f471595c0969a2890/eeglab14_1_1b'
eeglab
conditions=[];

%% 

% load eeg using .vhdr - PUT CORRECT FILENAME HERE
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
EEG = pop_loadbv('/Users/Vish 1/Desktop/TEP/HV007/Francesca session 2', 'fran rfdi sici pre s2.vhdr');

[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 0,'gui','off'); 

%% 

% lookup channel locations
EEG=pop_chanedit(EEG, 'lookup','/Applications/MATLAB_R2017a.app/toolbox/eeglab-952938e2c0ae800ef6ccf50f471595c0969a2890/eeglab/plugins/dipfit2.2/standard_BESA/standard-10-5-cap385.elp');

EEG.data( [ 1 : 16, 18 : 63 ], : ) = ...
                          EEG.data( [ 1 : 16, 18 : 63 ], : ) - ...
                      repmat( EEG.data( 17, : ), 62, 1 );
EEG.data( 17, : ) = EEG.data( 17, : ) * -1;
% Overwrite chan locs field
load CHANLOCS2
EEG.chanlocs = CHANLOCS2;

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

% remove uneccesary variables
clear('ALLCOM', 'ALLEEG', 'ans', 'CURRENTSET', 'CURRENTSTUDY', 'eeglabUpdater', 'LASTCOM', 'PLUGINLIST', 'STUDY', 'tmpstr');

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

reref_single_pulse_eeg.epoch = reref_single_pulse_eeg.epoch(:,single_pulse_index);
reref_sici_70_eeg.epoch = reref_sici_70_eeg.epoch(:,sici_70_index);
reref_sici_80_eeg.epoch = reref_sici_80_eeg.epoch(:,sici_80_index);
reref_sici_90_eeg.epoch = reref_sici_90_eeg.epoch(:,sici_90_index);

pop_saveset(reref_single_pulse_eeg);
pop_saveset(reref_sici_70_eeg);
pop_saveset(reref_sici_80_eeg);
pop_saveset(reref_sici_90_eeg);
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

%% TEP Analysis Re-referenced Data
reref_single_pulse_eeg = pop_tesa_tepextract( reref_single_pulse_eeg, 'ROI', 'elecs', {'FC1','FC3','C1','C3'} ); %Average M1 TEP
    reref_single_pulse_eeg = pop_tesa_tepextract( reref_single_pulse_eeg, 'ROI', 'elecs', {'FC1','FC3','C1','C3'} ); %Average M1 TEP
    reref_single_pulse_eeg.ROI.R2.tseries = abs(reref_single_pulse_eeg.ROI.R2.tseries);
reref_single_pulse_eeg = pop_tesa_peakanalysis( reref_single_pulse_eeg, 'ROI', 'negative', [45,100], [35,55;75,150], 'method','centre', 'samples', 5);
reref_single_pulse_eeg = pop_tesa_peakanalysis( reref_single_pulse_eeg, 'ROI', 'positive', [30,60,180], [15,35;55,75;150,250], 'method','centre', 'samples', 5);
reref_single_pulse_eeg = pop_tesa_tepextract( reref_single_pulse_eeg, 'GMFA');
reref_single_pulse_eeg = pop_tesa_peakanalysis( reref_single_pulse_eeg, 'GMFA', 'positive', [50,110,200],[30,70;70,150;150,250], 'method','largest', 'samples', 5);

reref_sici_70_eeg = pop_tesa_tepextract( reref_sici_70_eeg, 'ROI', 'elecs', {'FC1','FC3','C1','C3'} ); %Average M1 TEP
    reref_sici_70_eeg = pop_tesa_tepextract( reref_sici_70_eeg, 'ROI', 'elecs', {'FC1','FC3','C1','C3'} ); %Average M1 TEP
    reref_sici_70_eeg.ROI.R2.tseries = abs(reref_sici_70_eeg.ROI.R2.tseries );
reref_sici_70_eeg = pop_tesa_peakanalysis( reref_sici_70_eeg, 'ROI', 'negative', [45,100], [35,55;75,150], 'method','centre', 'samples', 5);
reref_sici_70_eeg = pop_tesa_peakanalysis( reref_sici_70_eeg, 'ROI', 'positive', [30,60,180], [15,35;55,75;150,250], 'method','centre', 'samples', 5);
reref_sici_70_eeg = pop_tesa_tepextract( reref_sici_70_eeg, 'GMFA');
reref_sici_70_eeg = pop_tesa_peakanalysis( reref_sici_70_eeg, 'GMFA', 'positive', [50,110,200],[30,70;70,150;150,250], 'method','largest', 'samples', 5);

reref_sici_80_eeg = pop_tesa_tepextract( reref_sici_80_eeg, 'ROI', 'elecs', {'FC1','FC3','C1','C3'} ); %Average M1 TEP
    reref_sici_80_eeg = pop_tesa_tepextract( reref_sici_80_eeg, 'ROI', 'elecs', {'FC1','FC3','C1','C3'} ); %Average M1 TEP
    reref_sici_80_eeg.ROI.R2.tseries = abs(reref_sici_80_eeg.ROI.R2.tseries );
reref_sici_80_eeg = pop_tesa_peakanalysis( reref_sici_80_eeg, 'ROI', 'negative', [45,100], [35,55;75,150], 'method','centre', 'samples', 5);
reref_sici_80_eeg = pop_tesa_peakanalysis( reref_sici_80_eeg, 'ROI', 'positive', [30,60,180], [15,35;55,75;150,250], 'method','centre', 'samples', 5);
reref_sici_80_eeg = pop_tesa_tepextract( reref_sici_80_eeg, 'GMFA');
reref_sici_80_eeg = pop_tesa_peakanalysis( reref_sici_80_eeg, 'GMFA', 'positive', [50,110,200],[30,70;70,150;150,250], 'method','largest', 'samples', 5);

reref_sici_90_eeg = pop_tesa_tepextract( reref_sici_90_eeg, 'ROI', 'elecs', {'FC1','FC3','C1','C3'} ); %Average M1 TEP
    reref_sici_90_eeg = pop_tesa_tepextract( reref_sici_90_eeg, 'ROI', 'elecs', {'FC1','FC3','C1','C3'} ); %Average M1 TEP
    reref_sici_90_eeg.ROI.R2.tseries = abs(reref_sici_90_eeg.ROI.R2.tseries );
reref_sici_90_eeg = pop_tesa_peakanalysis( reref_sici_90_eeg, 'ROI', 'negative', [45,100], [35,55;75,150], 'method','centre', 'samples', 5);
reref_sici_90_eeg = pop_tesa_peakanalysis( reref_sici_90_eeg, 'ROI', 'positive', [30,60,180], [15,35;55,75;150,250], 'method','centre', 'samples', 5);
reref_sici_90_eeg = pop_tesa_tepextract( reref_sici_90_eeg, 'GMFA');
reref_sici_90_eeg = pop_tesa_peakanalysis( reref_sici_90_eeg, 'GMFA', 'positive', [50,110,200],[30,70;70,150;150,250], 'method','largest', 'samples', 5);
%% Plot re-ref M1 TEP
plot(reref_single_pulse_eeg.ROI.R1.time, reref_single_pulse_eeg.ROI.R1.tseries)
hold on
plot(reref_sici_70_eeg.ROI.R1.time, reref_sici_70_eeg.ROI.R1.tseries)
hold on
plot(reref_sici_80_eeg.ROI.R1.time, reref_sici_80_eeg.ROI.R1.tseries)
hold on
plot(reref_sici_90_eeg.ROI.R1.time, reref_sici_90_eeg.ROI.R1.tseries)

%% Plot re-ref M1 LMFP
plot(reref_single_pulse_eeg.ROI.R2.time, reref_single_pulse_eeg.ROI.R2.tseries)
hold on
plot(reref_sici_70_eeg.ROI.R2.time, reref_sici_70_eeg.ROI.R2.tseries)
hold on
plot(reref_sici_80_eeg.ROI.R2.time, reref_sici_80_eeg.ROI.R2.tseries)
hold on
plot(reref_sici_90_eeg.ROI.R2.time, reref_sici_90_eeg.ROI.R2.tseries)

%% TEP Analysis Raw Data
single_pulse_eeg = pop_tesa_tepextract( single_pulse_eeg, 'ROI', 'elecs', {'FC1','FC3','C1','C3'} ); %Average M1 TEP
    single_pulse_eeg = pop_tesa_tepextract( single_pulse_eeg, 'ROI', 'elecs', {'FC1','FC3','C1','C3'} ); %Average M1 TEP
    single_pulse_eeg.ROI.R2.tseries = abs(single_pulse_eeg.ROI.R2.tseries);
single_pulse_eeg = pop_tesa_peakanalysis( single_pulse_eeg, 'ROI', 'negative', [45,100], [35,55;75,150], 'method','centre', 'samples', 5);
single_pulse_eeg = pop_tesa_peakanalysis( single_pulse_eeg, 'ROI', 'positive', [30,60,180], [15,35;55,75;150,250], 'method','centre', 'samples', 5);
single_pulse_eeg = pop_tesa_tepextract( single_pulse_eeg, 'GMFA');
single_pulse_eeg = pop_tesa_peakanalysis( single_pulse_eeg, 'GMFA', 'positive', [50,110,200],[30,70;70,150;150,250], 'method','largest', 'samples', 5);

sici_70_eeg = pop_tesa_tepextract( sici_70_eeg, 'ROI', 'elecs', {'FC1','FC3','C1','C3'} ); %Average M1 TEP
    sici_70_eeg = pop_tesa_tepextract( sici_70_eeg, 'ROI', 'elecs', {'FC1','FC3','C1','C3'} ); %Average M1 TEP
    sici_70_eeg.ROI.R2.tseries = abs(sici_70_eeg.ROI.R2.tseries );
sici_70_eeg = pop_tesa_peakanalysis( sici_70_eeg, 'ROI', 'negative', [45,100], [35,55;75,150], 'method','centre', 'samples', 5);
sici_70_eeg = pop_tesa_peakanalysis( sici_70_eeg, 'ROI', 'positive', [30,60,180], [15,35;55,75;150,250], 'method','centre', 'samples', 5);
sici_70_eeg = pop_tesa_tepextract( sici_70_eeg, 'GMFA');
sici_70_eeg = pop_tesa_peakanalysis( sici_70_eeg, 'GMFA', 'positive', [50,110,200],[30,70;70,150;150,250], 'method','largest', 'samples', 5);

sici_80_eeg = pop_tesa_tepextract( sici_80_eeg, 'ROI', 'elecs', {'FC1','FC3','C1','C3'} ); %Average M1 TEP
    sici_80_eeg = pop_tesa_tepextract( sici_80_eeg, 'ROI', 'elecs', {'FC1','FC3','C1','C3'} ); %Average M1 TEP
    sici_80_eeg.ROI.R2.tseries = abs(sici_80_eeg.ROI.R2.tseries );
sici_80_eeg = pop_tesa_peakanalysis( sici_80_eeg, 'ROI', 'negative', [45,100], [35,55;75,150], 'method','centre', 'samples', 5);
sici_80_eeg = pop_tesa_peakanalysis( sici_80_eeg, 'ROI', 'positive', [30,60,180], [15,35;55,75;150,250], 'method','centre', 'samples', 5);
sici_80_eeg = pop_tesa_tepextract( sici_80_eeg, 'GMFA');
sici_80_eeg = pop_tesa_peakanalysis( sici_80_eeg, 'GMFA', 'positive', [50,110,200],[30,70;70,150;150,250], 'method','largest', 'samples', 5);

sici_90_eeg = pop_tesa_tepextract( sici_90_eeg, 'ROI', 'elecs', {'FC1','FC3','C1','C3'} ); %Average M1 TEP
    sici_90_eeg = pop_tesa_tepextract( sici_90_eeg, 'ROI', 'elecs', {'FC1','FC3','C1','C3'} ); %Average M1 TEP
    sici_90_eeg.ROI.R2.tseries = abs(sici_90_eeg.ROI.R2.tseries );
sici_90_eeg = pop_tesa_peakanalysis( sici_90_eeg, 'ROI', 'negative', [45,100], [35,55;75,150], 'method','centre', 'samples', 5);
sici_90_eeg = pop_tesa_peakanalysis( sici_90_eeg, 'ROI', 'positive', [30,60,180], [15,35;55,75;150,250], 'method','centre', 'samples', 5);
sici_90_eeg = pop_tesa_tepextract( sici_90_eeg, 'GMFA');
sici_90_eeg = pop_tesa_peakanalysis( sici_90_eeg, 'GMFA', 'positive', [50,110,200],[30,70;70,150;150,250], 'method','largest', 'samples', 5);

%% Plot raw M1 TEP
plot(single_pulse_eeg.ROI.R1.time, single_pulse_eeg.ROI.R1.tseries)
hold on
plot(sici_70_eeg.ROI.R1.time, sici_70_eeg.ROI.R1.tseries)
hold on
plot(sici_80_eeg.ROI.R1.time, sici_80_eeg.ROI.R1.tseries)
hold on
plot(sici_90_eeg.ROI.R1.time, sici_90_eeg.ROI.R1.tseries)

%% Plot raw M1 LMFP
plot(single_pulse_eeg.ROI.R2.time, single_pulse_eeg.ROI.R2.tseries)
hold on
plot(sici_70_eeg.ROI.R2.time, sici_70_eeg.ROI.R2.tseries)
hold on
plot(sici_80_eeg.ROI.R2.time, sici_80_eeg.ROI.R2.tseries)
hold on
plot(sici_90_eeg.ROI.R2.time, sici_90_eeg.ROI.R2.tseries)

%% Summary re-ref
reref_single_tep_peaks = [reref_single_pulse_eeg.ROI.R1.P30.amp, reref_single_pulse_eeg.ROI.R1.N45.amp, reref_single_pulse_eeg.ROI.R1.P60.amp, reref_single_pulse_eeg.ROI.R1.N100.amp, reref_single_pulse_eeg.ROI.R1.P180.amp];  
reref_sici_70_tep_peaks = [reref_sici_70_eeg.ROI.R1.P30.amp, reref_sici_70_eeg.ROI.R1.N45.amp, reref_sici_70_eeg.ROI.R1.P60.amp, reref_sici_70_eeg.ROI.R1.N100.amp, reref_sici_70_eeg.ROI.R1.P180.amp];  
reref_sici_80_tep_peaks = [reref_sici_80_eeg.ROI.R1.P30.amp, reref_sici_80_eeg.ROI.R1.N45.amp, reref_sici_80_eeg.ROI.R1.P60.amp, reref_sici_80_eeg.ROI.R1.N100.amp, reref_sici_80_eeg.ROI.R1.P180.amp];  
reref_sici_90_tep_peaks = [reref_sici_90_eeg.ROI.R1.P30.amp, reref_sici_90_eeg.ROI.R1.N45.amp, reref_sici_90_eeg.ROI.R1.P60.amp, reref_sici_90_eeg.ROI.R1.N100.amp, reref_sici_90_eeg.ROI.R1.P180.amp];  
reref_tep_peaks = [reref_single_tep_peaks, reref_sici_70_tep_peaks, reref_sici_80_tep_peaks, reref_sici_90_tep_peaks];

reref_single_tep_latency = [reref_single_pulse_eeg.ROI.R1.P30.lat, reref_single_pulse_eeg.ROI.R1.N45.lat, reref_single_pulse_eeg.ROI.R1.P60.lat, reref_single_pulse_eeg.ROI.R1.N100.lat, reref_single_pulse_eeg.ROI.R1.P180.lat];  
reref_sici_70_tep_latency = [reref_sici_70_eeg.ROI.R1.P30.lat, reref_sici_70_eeg.ROI.R1.N45.lat, reref_sici_70_eeg.ROI.R1.P60.lat, reref_sici_70_eeg.ROI.R1.N100.lat, reref_sici_70_eeg.ROI.R1.P180.lat];  
reref_sici_80_tep_latency = [reref_sici_80_eeg.ROI.R1.P30.lat, reref_sici_80_eeg.ROI.R1.N45.lat, reref_sici_80_eeg.ROI.R1.P60.lat, reref_sici_80_eeg.ROI.R1.N100.lat, reref_sici_80_eeg.ROI.R1.P180.lat];  
reref_sici_90_tep_latency = [reref_sici_90_eeg.ROI.R1.P30.lat, reref_sici_90_eeg.ROI.R1.N45.lat, reref_sici_90_eeg.ROI.R1.P60.lat, reref_sici_90_eeg.ROI.R1.N100.lat, reref_sici_90_eeg.ROI.R1.P180.lat];  
reref_tep_latency = [reref_single_tep_latency, reref_sici_70_tep_latency, reref_sici_80_tep_latency, reref_sici_90_tep_latency];

reref_single_GMFP_peaks = [reref_single_pulse_eeg.GMFA.R1.P50.amp, reref_single_pulse_eeg.GMFA.R1.P110.amp, reref_single_pulse_eeg.GMFA.R1.P200.amp];  
reref_sici_70_GMFP_peaks = [reref_sici_70_eeg.GMFA.R1.P50.amp, reref_sici_70_eeg.GMFA.R1.P110.amp, reref_sici_70_eeg.GMFA.R1.P200.amp];  
reref_sici_80_GMFP_peaks = [reref_sici_80_eeg.GMFA.R1.P50.amp, reref_sici_80_eeg.GMFA.R1.P110.amp, reref_sici_80_eeg.GMFA.R1.P200.amp];  
reref_sici_90_GMFP_peaks = [reref_sici_90_eeg.GMFA.R1.P50.amp, reref_sici_90_eeg.GMFA.R1.P110.amp, reref_sici_90_eeg.GMFA.R1.P200.amp];  
reref_GMFP_peaks = [reref_single_GMFP_peaks, reref_sici_70_GMFP_peaks, reref_sici_80_GMFP_peaks, reref_sici_90_GMFP_peaks];

reref_LMFP = [reref_single_pulse_eeg.ROI.R2.tseries, reref_sici_70_eeg.ROI.R2.tseries, reref_sici_80_eeg.ROI.R2.tseries, reref_sici_90_eeg.ROI.R2.tseries];
reref_GMFP = [reref_single_pulse_eeg.GMFA.R1.tseries, reref_sici_70_eeg.GMFA.R1.tseries, reref_sici_80_eeg.GMFA.R1.tseries, reref_sici_90_eeg.GMFA.R1.tseries];

reref_m1_teps = [reref_single_pulse_eeg.ROI.R1.tseries, reref_sici_70_eeg.ROI.R1.tseries, reref_sici_80_eeg.ROI.R1.tseries, reref_sici_90_eeg.ROI.R1.tseries];

%% Summary raw
single_tep_peaks = [single_pulse_eeg.ROI.R1.P30.amp, single_pulse_eeg.ROI.R1.N45.amp, single_pulse_eeg.ROI.R1.P60.amp, single_pulse_eeg.ROI.R1.N100.amp, single_pulse_eeg.ROI.R1.P180.amp];  
sici_70_tep_peaks = [sici_70_eeg.ROI.R1.P30.amp, sici_70_eeg.ROI.R1.N45.amp, sici_70_eeg.ROI.R1.P60.amp, sici_70_eeg.ROI.R1.N100.amp, sici_70_eeg.ROI.R1.P180.amp];  
sici_80_tep_peaks = [sici_80_eeg.ROI.R1.P30.amp, sici_80_eeg.ROI.R1.N45.amp, sici_80_eeg.ROI.R1.P60.amp, sici_80_eeg.ROI.R1.N100.amp, sici_80_eeg.ROI.R1.P180.amp];  
sici_90_tep_peaks = [sici_90_eeg.ROI.R1.P30.amp, sici_90_eeg.ROI.R1.N45.amp, sici_90_eeg.ROI.R1.P60.amp, sici_90_eeg.ROI.R1.N100.amp, sici_90_eeg.ROI.R1.P180.amp];  
raw_tep_peaks = [single_tep_peaks, sici_70_tep_peaks, sici_80_tep_peaks, sici_90_tep_peaks];

single_tep_latency = [single_pulse_eeg.ROI.R1.P30.lat, single_pulse_eeg.ROI.R1.N45.lat, single_pulse_eeg.ROI.R1.P60.lat, single_pulse_eeg.ROI.R1.N100.lat, single_pulse_eeg.ROI.R1.P180.lat];  
sici_70_tep_latency = [sici_70_eeg.ROI.R1.P30.lat, sici_70_eeg.ROI.R1.N45.lat, sici_70_eeg.ROI.R1.P60.lat, sici_70_eeg.ROI.R1.N100.lat, sici_70_eeg.ROI.R1.P180.lat];  
sici_80_tep_latency = [sici_80_eeg.ROI.R1.P30.lat, sici_80_eeg.ROI.R1.N45.lat, sici_80_eeg.ROI.R1.P60.lat, sici_80_eeg.ROI.R1.N100.lat, sici_80_eeg.ROI.R1.P180.lat];  
sici_90_tep_latency = [sici_90_eeg.ROI.R1.P30.lat, sici_90_eeg.ROI.R1.N45.lat, sici_90_eeg.ROI.R1.P60.lat, sici_90_eeg.ROI.R1.N100.lat, sici_90_eeg.ROI.R1.P180.lat];  
raw_tep_latency = [single_tep_latency, sici_70_tep_latency, sici_80_tep_latency, sici_90_tep_latency];

single_GMFP_peaks = [single_pulse_eeg.GMFA.R1.P50.amp, single_pulse_eeg.GMFA.R1.P110.amp, single_pulse_eeg.GMFA.R1.P200.amp];  
sici_70_GMFP_peaks = [sici_70_eeg.GMFA.R1.P50.amp, sici_70_eeg.GMFA.R1.P110.amp, sici_70_eeg.GMFA.R1.P200.amp];  
sici_80_GMFP_peaks = [sici_80_eeg.GMFA.R1.P50.amp, sici_80_eeg.GMFA.R1.P110.amp, sici_80_eeg.GMFA.R1.P200.amp];  
sici_90_GMFP_peaks = [sici_90_eeg.GMFA.R1.P50.amp, sici_90_eeg.GMFA.R1.P110.amp, sici_90_eeg.GMFA.R1.P200.amp];  
raw_GMFP_peaks = [single_GMFP_peaks, sici_70_GMFP_peaks, sici_80_GMFP_peaks, sici_90_GMFP_peaks];

raw_LMFP = [single_pulse_eeg.ROI.R2.tseries, sici_70_eeg.ROI.R2.tseries, sici_80_eeg.ROI.R2.tseries, sici_90_eeg.ROI.R2.tseries];
raw_GMFP = [single_pulse_eeg.GMFA.R1.tseries, sici_70_eeg.GMFA.R1.tseries, sici_80_eeg.GMFA.R1.tseries, sici_90_eeg.GMFA.R1.tseries];
