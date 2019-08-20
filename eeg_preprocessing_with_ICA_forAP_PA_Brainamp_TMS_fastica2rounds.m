clear all
clc
eeglab


%% 

% load eeg using .vhdr - PUT CORRECT FILENAME HERE
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
% EEG = pop_loadbv('/Users/Vish 1/Desktop/MND/SICI', 'Lorenzo.vhdr', [1 2250900], [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64]);

EEG = pop_loadbv('/Users/Vish 1/Desktop/Vish raw data', '2_pa_pa.vhdr');

[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 0,'gui','off'); 

%% 

% lookup channel locations
EEG=pop_chanedit(EEG, 'lookup','/Applications/MATLAB_R2017a.app/toolbox/eeglab-952938e2c0ae800ef6ccf50f471595c0969a2890/eeglab/plugins/dipfit2.2/standard_BESA/standard-10-5-cap385.elp');
[ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
EEG = eeg_checkset( EEG );

% extract epochs and demean - longer epochs - check number of event ('S126' for Brainamp)

% for i = 2:length(EEG.event)
%     if EEG.event(i).type == 'S 14' %find cases when a SICI conditioning pulse was given
%         EEG.event(i+2).type = 'S 11'; %change the SICI test pulse code to 'S 11'
%     end
% end

conditions = num2str(conditions);
j = 0;
for i = 2:length(EEG.event) 
    if EEG.event(i).type == 'S 13'
        j = j+1;
        EEG.event(i).type = conditions(j);
    end
end

EEG = pop_epoch( EEG, {  'S255'  }, [-1.3  1.3], 'epochinfo', 'yes');
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'gui','off'); 
EEG = eeg_checkset( EEG );
EEG = pop_rmbase( EEG, [-1000 -10]);
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 2,'gui','off'); 

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
EEG = pop_epoch( EEG, {  'S255'  }, [-1  1], 'epochinfo', 'yes');
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

%% 

EEG = eeg_checkset( EEG );
figure; pop_plottopo(EEG, [1:63] , ' pruned with ICA resampled pruned with ICA', 0, 'ydir',1);
EEG = eeg_checkset( EEG );
figure; pop_timtopo(EEG, [-100  300], [NaN]), 'ERP data and scalp maps of  pruned with ICA resampled pruned with ICA';

%%

%re-reference to average
EEG = pop_reref( EEG, []);

%% 

% save dataset - CHANGE FILENAME 
EEG = pop_saveset( EEG, 'filename','Lorenzo_single_pulse.set','filepath','/Users/Vish 1/Desktop/MND/SICI');
[ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);

% clear EEGLAB
ALLEEG = pop_delset( ALLEEG, [1] );
STUDY = []; CURRENTSTUDY = 0; ALLEEG = []; EEG=[]; CURRENTSET=[];

