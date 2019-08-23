clear all
clc

% This is the modified script by N Sharma 
% this script require CHANLOCS2. This has been uploaded to github
% There are a number of dependences on toolboxs NEED TO DOWNLOAD bvaio1.57
% from https://github.com/openroc/eeglab/tree/master/tags/EEGLAB8_0_0_0beta/plugins
% and put into  eeglab14_1_1b/plugins/bvaio1.57

mycap = ('/Applications/MATLAB_R2019a.app/toolbox/eeglab14_1_1b/plugins/dipfit2.3/standard_BESA/standard-10-5-cap385.elp') ; % NOTE this is version 2.3. previously 2.2
mydir = ('/Users/Isabella/Documents/thesharmalab/TMS_EEG/Additional_Experiments/EEG_data');
mymdir = ('/Users/Isabella/Documents/thesharmalab/TMS_EEG/Additional_Experiments/MEP_PEAKS');
mysavedir = ('/Users/Isabella/Documents/thesharmalab/TMS_EEG/Additional_Experiments/Preprocessed_data')

%addpath('/Applications/MATLAB_R2019a.app/toolbox/eeglab14_1_1b');
%addpath('/Applications/MATLAB_R2019a.app/toolbox/eeglab14_1_1b/functions/popfunc');
%addpath('/Applications/MATLAB_R2019a.app/toolbox/eeglab14_1_1b/plugins/bvaio1.57');
addpath(genpath('/Applications/MATLAB_R2019a.app/toolbox/eeglab14_1_1b'))
addpath(genpath('/Applications/MATLAB_R2019a.app/toolbox/FastICA_25'))


conditions=[];




% load eeg using .vhdr - PUT CORRECT FILENAME HERE
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
EEG = pop_loadbv(mydir, 'HV005_ADD.vhdr');

[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 0,'gui','off'); 

%% 

% lookup channel locations
EEG=pop_chanedit(EEG, 'lookup',mycap);

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

%% Index of rejected trials
index_rejected_trials = EEG.reject.rejmanual == 1;
index_rejected_trials = find(index_rejected_trials);

% Plot Data to reject bad trials
EEG = eeg_checkset( EEG );
pop_eegplot( EEG, 1, 1, 1);
uiwait;

%% Interpolate bad electrodes
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

%% fastICA 1st round  % This requires the efast ICA toolbox 
EEG = pop_tesa_fastica( EEG, 'approach', 'symm', 'g', 'tanh', 'stabilization', 'off' );
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 4,'gui','off'); 
EEG = pop_tesa_compselect( EEG,'compCheck','on','comps',15,'figSize','large','plotTimeX',[-200 500],'plotFreqX',[1 100],'tmsMuscle','on','tmsMuscleThresh',8,'tmsMuscleWin',[11 30],'tmsMuscleFeedback','off','blink','off','blinkThresh',2.5,'blinkElecs',{'Fp1','Fp2'},'blinkFeedback','off','move','off','moveThresh',2,'moveElecs',{'F7','F8'},'moveFeedback','off','muscle','off','muscleThresh',0.6,'muscleFreqWin',[30 100],'muscleFeedback','off','elecNoise','off','elecNoiseThresh',4,'elecNoiseFeedback','off' );
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 5,'gui','off'); 

%% interpolate removed data
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

%% fastICA 2nd round
EEG = pop_tesa_fastica( EEG, 'approach', 'symm', 'g', 'tanh', 'stabilization', 'off' );
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 10,'gui','off'); 
EEG = pop_tesa_compselect( EEG,'compCheck','on','comps',[],'figSize','large','plotTimeX',[-999 999],'plotFreqX',[1 100],'tmsMuscle','on','tmsMuscleThresh',8,'tmsMuscleWin',[11 30],'tmsMuscleFeedback','off','blink','on','blinkThresh',2.5,'blinkElecs',{'Fp1','Fp2'},'blinkFeedback','off','move','on','moveThresh',2,'moveElecs',{'F7','F8'},'moveFeedback','off','muscle','on','muscleThresh',0.6,'muscleFreqWin',[30 100],'muscleFeedback','off','elecNoise','on','elecNoiseThresh',4,'elecNoiseFeedback','off' );
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 11,'gui','off');

%% interpolate removed data
EEG = eeg_checkset( EEG );
EEG = pop_tesa_interpdata( EEG, 'cubic', [1 1] );
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 10,'gui','off'); 

% remove uneccesary variables
clear('ALLCOM', 'ALLEEG', 'ans', 'CURRENTSET', 'CURRENTSTUDY', 'eeglabUpdater', 'LASTCOM', 'PLUGINLIST', 'STUDY', 'tmpstr');

%% Save

save(strcat(mysavedir,'/HV005_add_preprocessed.mat'), 'EEG', 'index_rejected_trials');