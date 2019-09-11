% ERP Peak Analysis - Creates STUDY from .set files created in
% Stage_2_Generate_ConMEP. Requires .set files to be in current directory.
% Script then extracts peaks of average M1 TEP waveforms (see below) and 
% plots data for comparison.
% Vishal Rawji 09/09/2019

mydir = ('/Users/Isabella/Documents/thesharmalab/TMS_EEG/Additional_Experiments/Preprocessed_data/set_files');
mycon=[ 1 2 3 4];
mychan = [1:63];
mywin = [-100  300];
addpath(genpath('/Applications/MATLAB_R2019a.app/toolbox/eeglab14_1_1b'))
mymdir = ('/Users/Isabella/Documents/thesharmalab/TMS_EEG/Additional_Experiments/Preprocessed_data/set_files/marker_data'); % this is data from Signal

mypeaks = {'N15';'P30';'N45';'P60';'N100';'P180'};
myGMFPpeaks = ["GMFP1" ;"GMFP2";"GMFP3"];

addpath(genpath('/Applications/MATLAB_R2017a.app/toolbox/eeglab-952938e2c0ae800ef6ccf50f471595c0969a2890/eeglab14_1_1b'))

% 1 is 120, 2 is 70, 3 70.120 4 70.70

% addpath '/Applications/MATLAB_R2019a.app/toolbox/fdr_bh'
% addpath '/Applications/MATLAB_R2019a.app/toolbox/raacampbell-shadedErrorBar-0dc4de5'
% addpath '/Applications/MATLAB_R2019a.app/toolbox/bonf_holm'
% addpath '/Applications/MATLAB_R2019a.app/toolbox/swtest'
% addpath '/Applications/MATLAB_R2019a.app/toolbox/dnafinder-wilcoxon-2f43343'

%% Create STUDY

STUDY =[];
[STUDY ALLEEG] = std_editset( STUDY, [], 'commands', { ...
{ 'index' 1 'load' 'HV001_ADD_con1_eeg.set' 'subject' 'subj1' 'condition' '70' }, ...
{ 'index' 2 'load' 'HV001_ADD_con2_eeg.set' 'subject' 'subj1' 'condition' '70.70' }, ...
{ 'index' 3 'load' 'HV001_ADD_con3_eeg.set' 'subject' 'subj1' 'condition' '70.120' }, ...
{ 'index' 4 'load' 'HV001_ADD_con4_eeg.set' 'subject' 'subj1' 'condition' '120' }, ...
{ 'index' 5 'load' 'HV002_ADD_con1_eeg.set' 'subject' 'subj2' 'condition' '70' }, ...
{ 'index' 6 'load' 'HV002_ADD_con2_eeg.set' 'subject' 'subj2' 'condition' '70.70' }, ...
{ 'index' 7 'load' 'HV002_ADD_con3_eeg.set' 'subject' 'subj2' 'condition' '70.120' }, ...
{ 'index' 8 'load' 'HV002_ADD_con4_eeg.set' 'subject' 'subj2' 'condition' '120' }, ...
{ 'index' 9 'load' 'HV003_ADD_con1_eeg.set' 'subject' 'subj3' 'condition' '70' }, ...
{ 'index' 10 'load' 'HV003_ADD_con2_eeg.set' 'subject' 'subj3' 'condition' '70.70' }, ...
{ 'index' 11 'load' 'HV003_ADD_con3_eeg.set' 'subject' 'subj3' 'condition' '70.120' }, ...
{ 'index' 12 'load' 'HV003_ADD_con4_eeg.set' 'subject' 'subj3' 'condition' '120' }, ...
{ 'index' 13 'load' 'HV004_ADD_con1_eeg.set' 'subject' 'subj4' 'condition' '70' }, ...
{ 'index' 14 'load' 'HV004_ADD_con2_eeg.set' 'subject' 'subj4' 'condition' '70.70' }, ...
{ 'index' 15 'load' 'HV004_ADD_con3_eeg.set' 'subject' 'subj4' 'condition' '70.120' }, ...
{ 'index' 16 'load' 'HV004_ADD_con4_eeg.set' 'subject' 'subj4' 'condition' '120' }, ...
{ 'index' 17 'load' 'HV005_ADD_con1_eeg.set' 'subject' 'subj5' 'condition' '70' }, ...
{ 'index' 18 'load' 'HV005_ADD_con2_eeg.set' 'subject' 'subj5' 'condition' '70.70' }, ...
{ 'index' 19 'load' 'HV005_ADD_con3_eeg.set' 'subject' 'subj5' 'condition' '70.120' }, ...
{ 'index' 20 'load' 'HV005_ADD_con4_eeg.set' 'subject' 'subj5' 'condition' '120' }, ...
{ 'index' 21 'load' 'HV006_ADD_con1_eeg.set' 'subject' 'subj6' 'condition' '70' }, ...
{ 'index' 22 'load' 'HV006_ADD_con2_eeg.set' 'subject' 'subj6' 'condition' '70.70' }, ...
{ 'index' 23 'load' 'HV006_ADD_con3_eeg.set' 'subject' 'subj6' 'condition' '70.120' }, ...
{ 'index' 24 'load' 'HV006_ADD_con4_eeg.set' 'subject' 'subj6' 'condition' '120' }, ...
{ 'index' 25 'load' 'HV007_ADD_con1_eeg.set' 'subject' 'subj7' 'condition' '70' }, ...
{ 'index' 26 'load' 'HV007_ADD_con2_eeg.set' 'subject' 'subj7' 'condition' '70.70' }, ...
{ 'index' 27 'load' 'HV007_ADD_con3_eeg.set' 'subject' 'subj7' 'condition' '70.120' }, ...
{ 'index' 28 'load' 'HV007_ADD_con4_eeg.set' 'subject' 'subj7' 'condition' '120' }, ...
{ 'index' 29 'load' 'HV008_ADD_con1_eeg.set' 'subject' 'subj8' 'condition' '70' }, ...
{ 'index' 30 'load' 'HV008_ADD_con2_eeg.set' 'subject' 'subj8' 'condition' '70.70' }, ...
{ 'index' 31 'load' 'HV008_ADD_con3_eeg.set' 'subject' 'subj8' 'condition' '70.120' }, ...
{ 'index' 32 'load' 'HV008_ADD_con4_eeg.set' 'subject' 'subj8' 'condition' '120' }});
STUDY = pop_savestudy( STUDY, EEG, 'filename','ADD_STUDY' ); %saves STUDY



[STUDY ALLEEG] = pop_loadstudy('ADD_STUDY.study') %load study and EEG files

%% Calculate mean ERPs for each condition

[STUDY ALLEEG customres] = std_precomp(STUDY, ALLEEG, 'channels', 'customfunc', @(EEG,varargin)(mean(EEG.data,3)')); %Compute ERPs for all channels, subjects and timepoints

%customres contains 4 cells, one for each contition. Each cell contains
%ERPs for that condition, for all subjects, for all electrodes. The code
%below splits them up into separate variables. 
sp_70 = cell2mat(customres(mycon(1),1)); % ERPs for all channels for all subjects for condition 1
pp_70_70 = cell2mat(customres(mycon(2),1)); %Condition 2
pp_70_120 = cell2mat(customres(mycon(3),1)); %Condition 3
sp_120 = cell2mat(customres(mycon(4),1)); %Condition 4
erptimes = [-1000:1:999]; %Timescale is from -1000 ms to 999 ms

%Code below inserts ERP data and times into STUDY.changrp.erpdata for each
%electrode. It can then be used to compute specific peaks below. 
for i = 1:length(STUDY.changrp)
STUDY.changrp(i).erpdata{1,1} = squeeze(sp_70(:,i,:)); 
STUDY.changrp(i).erpdata{2,1} = squeeze(pp_70_70(:,i,:));
STUDY.changrp(i).erpdata{3,1} = squeeze(pp_70_120(:,i,:));
STUDY.changrp(i).erpdata{4,1} = squeeze(sp_120(:,i,:));
STUDY.changrp(i).erptimes = erptimes;
end

%% Extract peaks for each TEP waveform

peaks = ones(6,length(STUDY.subject),4); %Sets up the array where the peaks will be stored
output = {};
k = [1:6];

for i = 1:length(STUDY.subject)
    for j = 1:length(mycon)
    
    tep_data = [STUDY.changrp(8).erpdata{j, 1}(:,i) STUDY.changrp(12).erpdata{j, 1}(:,i) STUDY.changrp(40).erpdata{j, 1}(:,i) STUDY.changrp(43).erpdata{j, 1}(:,i)];
    mean_tep = mean((tep_data)');
    tep_array(i,:,j) = mean_tep; %Calculates the mean M1 TEP and puts it into a 3D array (subjects x time x condition)

    % This section extracts each peak. Finds the min/max peak between time
    % intervals. 
    N15 = min(-findpeaks(-mean_tep(1001:1021)));
    P30 = max(findpeaks(mean_tep(1016:1036)));
    N45 = min(-findpeaks(-mean_tep(1032:1056)));
    P60 = max(findpeaks(mean_tep(1049:1071)));
    N100 = min(-findpeaks(-mean_tep(1091:1151)));
    P180 = max(findpeaks(mean_tep(1151:1251)));

    %Next section fills in the value of the ERP at that time point (extrapolates) if a peak
    %cannot be found. 

    if isempty(N15) == 1
        N15 = mean_tep(1016);
    end
    if isempty(P30) == 1
        P30 = mean_tep(1031);
    end
    if isempty(N45) == 1
        N45 = mean_tep(1046);
    end
    if isempty(P60) == 1
        P60 = mean_tep(1061);
    end
    if isempty(N100) == 1
        N100 = mean_tep(1101);
    end
    if isempty(P180) == 1
        P180 = mean_tep(1181);
    end

    peaks(:,i,j) = [N15; P30; N45; P60; N100; P180;]; %summary 3D array (peak x subject x condition)
    output(k,[1:4]) = {'N15',N15,i,j;'P30',P30,i,j;'N45',N45,i,j;'P60',P60,i,j;'N100',N100,i,j;'P180',P180,i,j};%prepares output structure for transfer to R.
    % Col1 = peak name, Col2 = peak amplitude, Col3 = subjectID, Col4 =
    % condition. 

    k = k+6;
end
end

save('combo_myeeg_tep_peaks.txt', 'output'); 

%% Calculate mean and SEM of each TEP for each condition

mean_tep_output=[];

for j = 1:length(mycon)
        temp = [];
        temp = (mean(tep_array(:,:,j),1))';
        temp(:,2) = std(tep_array(:,:,j)/sqrt(length(STUDY.subject)));
        temp(:,3) = j;
        temp(:,4) = STUDY.changrp(1).erptimes';
        mean_tep_output = vertcat(mean_tep_output,temp);
        %resultant array is 8000 x 4. Col1 = TEP amplitude, Col2 = TEP SEM,
        %Col3 = condition, Col4 = time
end

save('combo_myeeg_tep_waveforms.txt', 'mean_tep_output'); 

%% Plot average TEPs and calculate arithmetic difference between one TEP and another
%70 vs 70.70
figure
plot(STUDY.changrp(1).erptimes,mean_tep_output(find(mean_tep_output(:,3) == 2))); %plots condition 2 (70)
hold on
plot(STUDY.changrp(1).erptimes,mean_tep_output(find(mean_tep_output(:,3) == 4))); %plots condition 4 (70.70)
plot(STUDY.changrp(1).erptimes,mean_tep_output(find(mean_tep_output(:,3) == 2))-mean_tep_output(find(mean_tep_output(:,3) == 4))); %plots the subtraction of 4 from 2
xlim([-100 300])
title('70 (blue), 70.70(red), subtraction (70 - 70.70) (green)')

%120 vs 70.120
figure
plot(STUDY.changrp(1).erptimes,mean_tep_output(find(mean_tep_output(:,3) == 1))) %plots condition 1 (120)
hold on
plot(STUDY.changrp(1).erptimes,mean_tep_output(find(mean_tep_output(:,3) == 3))) %plots condition 3 (70.120)
plot(STUDY.changrp(1).erptimes,mean_tep_output(find(mean_tep_output(:,3) == 1))-mean_tep_output(find(mean_tep_output(:,3) == 3))); %plots the subtraction of 3 from 1
xlim([-100 300])
title('120 (blue), 70.120(red), subtraction (120 - 70.120) (green)')

%% Correlations 
subtracted_waveform = tep_array(:,:,1) - tep_array(:,:,3);
for i = 1:length(STUDY.subject)
    
    % This section extracts each peak. Finds the min/max peak between time
    % intervals. 
    N15 = min(-findpeaks(-subtracted_waveform(i,1001:1021)));
    P30 = max(findpeaks(subtracted_waveform(i,1016:1036)));
    N45 = min(-findpeaks(-subtracted_waveform(i,1032:1056)));
    P60 = max(findpeaks(subtracted_waveform(i,1049:1071)));
    N100 = min(-findpeaks(-subtracted_waveform(i,1091:1151)));
    P180 = max(findpeaks(subtracted_waveform(i,1151:1251)));

    %Next section fills in the value of the ERP at that time point (extrapolates) if a peak
    %cannot be found. 

    if isempty(N15) == 1
        N15 = subtracted_waveform(1016);
    end
    if isempty(P30) == 1
        P30 = subtracted_waveform(1031);
    end
    if isempty(N45) == 1
        N45 = subtracted_waveform(1046);
    end
    if isempty(P60) == 1
        P60 = subtracted_waveform(1061);
    end
    if isempty(N100) == 1
        N100 = subtracted_waveform(1101);
    end
    if isempty(P180) == 1
        P180 = subtracted_waveform(1181);
    end

    subtracted_peaks(:,i) = [N15; P30; N45; P60; N100; P180;]; %summary array (peak x subject)

end

mep_70_120 = []; %sets up array containing mean MEP values for 70.120 condition
for n = 1:length(STUDY.subject)
        file = dlmread(strcat('HV00',num2str(n),'_CONMEP','.txt')); %read in combined file from Stage_2_Generate_ConMEP
        index = find(file(:,1)==3); %find indices for 70.120 trials
        mep_70_120(n,1) = mean(file(index,2)); %calculate mean MEP for each subject       
end

[rho,pval] = corr(mep_70_120,subtracted_peaks','type','spearman'); %spearman rank correlation calculation

figure
for m = 1:length(mypeaks)
        subplot(2,3,m)
        scatter(mep_70_120',subtracted_peaks(m,:)); %plots MEP against TEP peak amplitude
        xlabel('MEP amplitude')
        ylabel('Peak amplitude')
        title([mypeaks{m},', rho= ',num2str(rho(m)),', p=',num2str(pval(m))]) 
        
        %this section is for plotting line of best fit onto graphs
        coefficients = polyfit(mep_70_120', subtracted_peaks(m,:), 1);
        xFit = linspace(min(mep_70_120'), max(mep_70_120'), 1000);
        yFit = polyval(coefficients , xFit);
        hold on;
        plot(xFit, yFit, 'r-', 'LineWidth', 2);
end