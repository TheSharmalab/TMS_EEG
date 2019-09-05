% ERP Peak Analysis - Uses STUDY structure formed from the output of eeglab ERPs 

mydir = ('/Users/Isabella/Documents/thesharmalab/TMS_EEG/Additional_Experiments/Preprocessed_data/set_files');
mycon=[ 1 2 3 4];
mychan = [1:63];
mywin = [-100  300];
addpath(genpath('/Applications/MATLAB_R2019a.app/toolbox/eeglab14_1_1b'))
mymdir = ('/Users/Isabella/Documents/thesharmalab/TMS_EEG/Additional_Experiments/Preprocessed_data/set_files/marker_data'); % this is data from Signal

mypeaks = ["N15" ;"P30" ;"N45";"P60" ;"N100";"P180"];
myGMFPpeaks = ["GMFP1" ;"GMFP2";"GMFP3"];



% 1 is 70sp, 2 is 70.70, 3 70.120 4 120

% 4 electrode
addpath '/Applications/MATLAB_R2019a.app/toolbox/fdr_bh'
addpath '/Applications/MATLAB_R2019a.app/toolbox/raacampbell-shadedErrorBar-0dc4de5'
addpath '/Applications/MATLAB_R2019a.app/toolbox/bonf_holm'
addpath '/Applications/MATLAB_R2019a.app/toolbox/swtest'
addpath '/Applications/MATLAB_R2019a.app/toolbox/dnafinder-wilcoxon-2f43343'

% this is a test. 

[STUDY ALLEEG] = std_editset( STUDY, [], 'commands', { ...
{ 'index' 1 'load' '/Users/Isabella/Documents/thesharmalab/TMS_EEG/Additional_Experiments/Preprocessed_data/set_files/S1_70.set' 'subject' 'subj1' 'condition' '70' }, ...
{ 'index' 2 'load' '/Users/Isabella/Documents/thesharmalab/TMS_EEG/Additional_Experiments/Preprocessed_data/set_files/S1_7070.set' 'subject' 'subj1' 'condition' '70.70' }, ...
{ 'index' 3 'load' '/Users/Isabella/Documents/thesharmalab/TMS_EEG/Additional_Experiments/Preprocessed_data/set_files/S1_70120.set' 'subject' 'subj1' 'condition' '70.120' }, ...
{ 'index' 4 'load' '/Users/Isabella/Documents/thesharmalab/TMS_EEG/Additional_Experiments/Preprocessed_data/set_files/S1_120.set' 'subject' 'subj1' 'condition' '120' }, ...
{ 'index' 5 'load' '/Users/Isabella/Documents/thesharmalab/TMS_EEG/Additional_Experiments/Preprocessed_data/set_files/S2_70.set' 'subject' 'subj2' 'condition' '70' }, ...
{ 'index' 6 'load' '/Users/Isabella/Documents/thesharmalab/TMS_EEG/Additional_Experiments/Preprocessed_data/set_files/S2_7070.set' 'subject' 'subj2' 'condition' '70.70' }, ...
{ 'index' 7 'load' '/Users/Isabella/Documents/thesharmalab/TMS_EEG/Additional_Experiments/Preprocessed_data/set_files/S2_70120.set' 'subject' 'subj2' 'condition' '70.120' }, ...
{ 'index' 8 'load' '/Users/Isabella/Documents/thesharmalab/TMS_EEG/Additional_Experiments/Preprocessed_data/set_files/S2_120.set' 'subject' 'subj2' 'condition' '120' }, ...
{ 'index' 9 'load' '/Users/Isabella/Documents/thesharmalab/TMS_EEG/Additional_Experiments/Preprocessed_data/set_files/S3_70.set' 'subject' 'subj3' 'condition' '70' }, ...
{ 'index' 10 'load' '/Users/Isabella/Documents/thesharmalab/TMS_EEG/Additional_Experiments/Preprocessed_data/set_files/S3_7070.set' 'subject' 'subj3' 'condition' '70.70' }, ...
{ 'index' 11 'load' '/Users/Isabella/Documents/thesharmalab/TMS_EEG/Additional_Experiments/Preprocessed_data/set_files/S3_70120.set' 'subject' 'subj3' 'condition' '70.120' }, ...
{ 'index' 12 'load' '/Users/Isabella/Documents/thesharmalab/TMS_EEG/Additional_Experiments/Preprocessed_data/set_files/S3_120.set' 'subject' 'subj3' 'condition' '120' }, ...
{ 'index' 13 'load' '/Users/Isabella/Documents/thesharmalab/TMS_EEG/Additional_Experiments/Preprocessed_data/set_files/S4_70.set' 'subject' 'subj4' 'condition' '70' }, ...
{ 'index' 14 'load' '/Users/Isabella/Documents/thesharmalab/TMS_EEG/Additional_Experiments/Preprocessed_data/set_files/S4_7070.set' 'subject' 'subj4' 'condition' '70.70' }, ...
{ 'index' 15 'load' '/Users/Isabella/Documents/thesharmalab/TMS_EEG/Additional_Experiments/Preprocessed_data/set_files/S4_70120.set' 'subject' 'subj4' 'condition' '70.120' }, ...
{ 'index' 16 'load' '/Users/Isabella/Documents/thesharmalab/TMS_EEG/Additional_Experiments/Preprocessed_data/set_files/S4_120.set' 'subject' 'subj4' 'condition' '120' }, ...
{ 'index' 17 'load' '/Users/Isabella/Documents/thesharmalab/TMS_EEG/Additional_Experiments/Preprocessed_data/set_files/S5_70.set' 'subject' 'subj5' 'condition' '70' }, ...
{ 'index' 18 'load' '/Users/Isabella/Documents/thesharmalab/TMS_EEG/Additional_Experiments/Preprocessed_data/set_files/S5_7070.set' 'subject' 'subj5' 'condition' '70.70' }, ...
{ 'index' 19 'load' '/Users/Isabella/Documents/thesharmalab/TMS_EEG/Additional_Experiments/Preprocessed_data/set_files/S5_70120.set' 'subject' 'subj5' 'condition' '70.120' }, ...
{ 'index' 20 'load' '/Users/Isabella/Documents/thesharmalab/TMS_EEG/Additional_Experiments/Preprocessed_data/set_files/S5_120.set' 'subject' 'subj5' 'condition' '120' }, ...
{ 'index' 21 'load' '/Users/Isabella/Documents/thesharmalab/TMS_EEG/Additional_Experiments/Preprocessed_data/set_files/S6_70.set' 'subject' 'subj6' 'condition' '70' }, ...
{ 'index' 22 'load' '/Users/Isabella/Documents/thesharmalab/TMS_EEG/Additional_Experiments/Preprocessed_data/set_files/S6_7070.set' 'subject' 'subj6' 'condition' '70.70' }, ...
{ 'index' 23 'load' '/Users/Isabella/Documents/thesharmalab/TMS_EEG/Additional_Experiments/Preprocessed_data/set_files/S6_70120.set' 'subject' 'subj6' 'condition' '70.120' }, ...
{ 'index' 24 'load' '/Users/Isabella/Documents/thesharmalab/TMS_EEG/Additional_Experiments/Preprocessed_data/set_files/S6_120.set' 'subject' 'subj6' 'condition' '120' }, ...
{ 'index' 25 'load' '/Users/Isabella/Documents/thesharmalab/TMS_EEG/Additional_Experiments/Preprocessed_data/set_files/S7_70.set' 'subject' 'subj7' 'condition' '70' }, ...
{ 'index' 26 'load' '/Users/Isabella/Documents/thesharmalab/TMS_EEG/Additional_Experiments/Preprocessed_data/set_files/S7_7070.set' 'subject' 'subj7' 'condition' '70.70' }, ...
{ 'index' 27 'load' '/Users/Isabella/Documents/thesharmalab/TMS_EEG/Additional_Experiments/Preprocessed_data/set_files/S7_70120.set' 'subject' 'subj7' 'condition' '70.120' }, ...
{ 'index' 28 'load' '/Users/Isabella/Documents/thesharmalab/TMS_EEG/Additional_Experiments/Preprocessed_data/set_files/S7_120.set' 'subject' 'subj7' 'condition' '120' }, ...
{ 'index' 29 'load' '/Users/Isabella/Documents/thesharmalab/TMS_EEG/Additional_Experiments/Preprocessed_data/set_files/S8_70.set' 'subject' 'subj8' 'condition' '70' }, ...
{ 'index' 30 'load' '/Users/Isabella/Documents/thesharmalab/TMS_EEG/Additional_Experiments/Preprocessed_data/set_files/S8_7070.set' 'subject' 'subj8' 'condition' '70.70' }, ...
{ 'index' 31 'load' '/Users/Isabella/Documents/thesharmalab/TMS_EEG/Additional_Experiments/Preprocessed_data/set_files/S8_70120.set' 'subject' 'subj8' 'condition' '70.120' }, ...
{ 'index' 32 'load' '/Users/Isabella/Documents/thesharmalab/TMS_EEG/Additional_Experiments/Preprocessed_data/set_files/S8_120.set' 'subject' 'subj8' 'condition' '120' }, ...
{ 'dipselect' 0.15 } });
STUDY = pop_savestudy( STUDY, EEG );

[STUDY ALLEEG] = pop_loadstudy('1MV_study.study') %load study and EEG files


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

peaks = ones(6,15,4); %Sets up the array where the peaks will be stored
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

%Calculate mean and SEM of each TEP for each condition

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

%Calculate arithmetic difference between one TEP and another
%TO ADD WHEN CONDITIONS AND COMPARISONS ARE KNOWN
plot(STUDY.changrp(1).erptimes,mean_tep_output(find(mean_tep_output(:,3) == 1))) %plots condition 1
hold on
plot(STUDY.changrp(1).erptimes,mean_tep_output(find(mean_tep_output(:,3) == 2))) %plots condition 2
hold on
plot(STUDY.changrp(1).erptimes,mean_tep_output(find(mean_tep_output(:,3) == 1))-mean_tep_output(find(mean_tep_output(:,3) == 2))); %plots the subtraction of 2 from 1
