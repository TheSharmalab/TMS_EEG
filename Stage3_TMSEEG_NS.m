% ERP Peak Analysis - Uses STUDY structure formed from the output of eeglab ERPs 
% this script is being modifed and does not work

mydir = ('/omega/TMS_EEG_Data');
mycon=[ 1 2 3 4];
mychan = [1:63];
mywin = [-100  300];
addpath(genpath('/Applications/MATLAB_R2019a.app/toolbox/eeglab14_1_1b'))
mymdir = ('/omega/TMS_EEG_Data/marker_data'); % this is data from Signal

mypeaks = ["N15" "1001:1021" ;"P30" "1016:1036";"N45" "1032:1056" ;"P60" "1049:1071";"N100" "1091:1151" ; "P180" "1151:1251"];
myGMFPpeaks = ["GMFP1" ;"GMFP2";"GMFP3"];
mywt = [1016, 1031, 1046, 1061, 1101, 1181 ]; % this is the time point to take the missing data wave form if the peak is empty
mycon = [1 "70" ;2 "70.70"; 3 "70.120" ;4 "120"];
myoutpeaks ={};



% % this esee to be downloaded
addpath '/Applications/MATLAB_R2017a.app/toolbox/fdr_bh'
addpath '/Applications/MATLAB_R2017a.app/toolbox/raacampbell-shadedErrorBar-0dc4de5'
addpath '/Applications/MATLAB_R2017a.app/toolbox/bonf_holm'
addpath '/Applications/MATLAB_R2017a.app/toolbox/swtest'
addpath '/Applications/MATLAB_R2017a.app/toolbox/dnafinder-wilcoxon-2f43343'
 



% if this doesnt work then can do it manuelly via the GUI. The instructions
% for this is https://sccn.ucsd.edu/wiki/Chapter_02:_STUDY_Creation
[STUDY ALLEEG] = std_editset( STUDY, [], 'commands', { ...
{ 'index' 1 'load' '/omega/TMS_EEG_Data/S1_70.set' 'subject' 'subj1' 'condition' '70' }, ...
{ 'index' 2 'load' '/omega/TMS_EEG_Data/S1_7070.set' 'subject' 'subj1' 'condition' '70.70' }, ...
{ 'index' 3 'load' '/omega/TMS_EEG_Data/S1_70120.set' 'subject' 'subj1' 'condition' '70.120' }, ...
{ 'index' 4 'load' '/omega/TMS_EEG_Data/S1_120.set' 'subject' 'subj1' 'condition' '120' }, ...
{ 'index' 5 'load' '/omega/TMS_EEG_Data/S2_70.set' 'subject' 'subj2' 'condition' '70' }, ...
{ 'index' 6 'load' '/omega/TMS_EEG_Data/S2_7070.set' 'subject' 'subj2' 'condition' '70.70' }, ...
{ 'index' 7 'load' '/omega/TMS_EEG_Data/S2_70120.set' 'subject' 'subj2' 'condition' '70.120' }, ...
{ 'index' 8 'load' '/omega/TMS_EEG_Data/S2_120.set' 'subject' 'subj2' 'condition' '120' }, ...
{ 'index' 9 'load' '/omega/TMS_EEG_Data/S3_70.set' 'subject' 'subj3' 'condition' '70' }, ...
{ 'index' 10 'load' '/omega/TMS_EEG_Data/S3_7070.set' 'subject' 'subj3' 'condition' '70.70' }, ...
{ 'index' 11 'load' '/omega/TMS_EEG_Data/S3_70120.set' 'subject' 'subj3' 'condition' '70.120' }, ...
{ 'index' 12 'load' '/omega/TMS_EEG_Data/S3_120.set' 'subject' 'subj3' 'condition' '120' }, ...
{ 'index' 13 'load' '/omega/TMS_EEG_Data/S4_70.set' 'subject' 'subj4' 'condition' '70' }, ...
{ 'index' 14 'load' '/omega/TMS_EEG_Data/S4_7070.set' 'subject' 'subj4' 'condition' '70.70' }, ...
{ 'index' 15 'load' '/omega/TMS_EEG_Data/S4_70120.set' 'subject' 'subj4' 'condition' '70.120' }, ...
{ 'index' 16 'load' '/omega/TMS_EEG_Data/S4_120.set' 'subject' 'subj4' 'condition' '120' }, ...
{ 'index' 17 'load' '/omega/TMS_EEG_Data/S5_70.set' 'subject' 'subj5' 'condition' '70' }, ...
{ 'index' 18 'load' '/omega/TMS_EEG_Data/S5_7070.set' 'subject' 'subj5' 'condition' '70.70' }, ...
{ 'index' 19 'load' '/omega/TMS_EEG_Data/S5_70120.set' 'subject' 'subj5' 'condition' '70.120' }, ...
{ 'index' 20 'load' '/omega/TMS_EEG_Data/S5_120.set' 'subject' 'subj5' 'condition' '120' }, ...
{ 'index' 21 'load' '/omega/TMS_EEG_Data/S6_70.set' 'subject' 'subj6' 'condition' '70' }, ...
{ 'index' 22 'load' '/omega/TMS_EEG_Data/S6_7070.set' 'subject' 'subj6' 'condition' '70.70' }, ...
{ 'index' 23 'load' '/omega/TMS_EEG_Data/S6_70120.set' 'subject' 'subj6' 'condition' '70.120' }, ...
{ 'index' 24 'load' '/omega/TMS_EEG_Data/S6_120.set' 'subject' 'subj6' 'condition' '120' }, ...
{ 'index' 25 'load' '/omega/TMS_EEG_Data/S7_70.set' 'subject' 'subj7' 'condition' '70' }, ...
{ 'index' 26 'load' '/omega/TMS_EEG_Data/S7_7070.set' 'subject' 'subj7' 'condition' '70.70' }, ...
{ 'index' 27 'load' '/omega/TMS_EEG_Data/S7_70120.set' 'subject' 'subj7' 'condition' '70.120' }, ...
{ 'index' 28 'load' '/omega/TMS_EEG_Data/S7_120.set' 'subject' 'subj7' 'condition' '120' }, ...
{ 'index' 29 'load' '/omega/TMS_EEG_Data/S8_70.set' 'subject' 'subj8' 'condition' '70' }, ...
{ 'index' 30 'load' '/omega/TMS_EEG_Data/S8_7070.set' 'subject' 'subj8' 'condition' '70.70' }, ...
{ 'index' 31 'load' '/omega/TMS_EEG_Data/S8_70120.set' 'subject' 'subj8' 'condition' '70.120' }, ...
{ 'index' 32 'load' '/omega/TMS_EEG_Data/S8_120.set' 'subject' 'subj8' 'condition' '120' }, ...
{ 'dipselect' 0.15 } });
STUDY = pop_savestudy( STUDY, EEG );






for i = 1:15; % per subject 
    for j = 1:4; % per condition
        % the number are electrode location within the study changrp 
        % this should cycle between the conditions with j
        m1_tep_data = [STUDY.changrp(8).erpdata{j, 1}(:,i) STUDY.changrp(12).erpdata{j, 1}(:,i) STUDY.changrp(40).erpdata{j, 1}(:,i) STUDY.changrp(43).erpdata{j, 1}(:,i)];
        m1_tep = mean((m1_tep_data)');
        m1_tep_array(i,:) = m1_tep; % this is the time wave 
        for k=1:6; % per peak
            if rem(k,2) == 0 % if even ie we need a postive numbers
                myoutpeaks(j,k) = -findpeaks(-m1_tep(str2num(mypeaks(k,2)))); % this needs to be altered with the negative. 
            else
               myoutpeaks(j,k) = findpeaks(m1_tep(str2num(mypeaks(k,2)))); % this needs to be altered with the negative. 
            end
            if  isempty(cell2mat(myoutpeaks(j,k))) == 1
                myoutpeaks(j,k) = num2cell(m1_tep(i,mywt(:,k)));
            end
        end
    end     
end


% unclear why we need this? Presume that there are multiple waves identified?
% 


for j = 1:6
    sp_peaks{1,j} = min(sp_peaks{1,j}); %N15
    sp_peaks{2,j} = max(sp_peaks{2,j}); %P30
    sp_peaks{3,j} = min(sp_peaks{3,j}); %N45
    sp_peaks{4,j} = max(sp_peaks{4,j}); %P60
    sp_peaks{5,j} = min(sp_peaks{5,j}); %N100
    sp_peaks{6,j} = max(sp_peaks{6,j}); %P180
    
    sici_peaks{1,j} = min(sici_peaks{1,j}); %N15
    sici_peaks{2,j} = max(sici_peaks{2,j}); %P30
    sici_peaks{3,j} = min(sici_peaks{3,j}); %N45
    sici_peaks{4,j} = max(sici_peaks{4,j}); %P60
    sici_peaks{5,j} = min(sici_peaks{5,j}); %N100
    sici_peaks{6,j} = max(sici_peaks{6,j}); %P180
end

% 
% 
% for i = 1:15; % per subject 
%         % the number are electrode location within the study changrp 
%         sp_m1_tep_data = [STUDY.changrp(8).erpdata{1, 1}(:,i) STUDY.changrp(12).erpdata{1, 1}(:,i) STUDY.changrp(40).erpdata{1, 1}(:,i) STUDY.changrp(43).erpdata{1, 1}(:,i)];
%         sp_m1_tep = mean((sp_m1_tep_data)');
%         sp_m1_tep_array(i,:) = sp_m1_tep; % this is the time wave 
% 
%         sp_N15 = -findpeaks(-sp_m1_tep(1001:1021));
%         sp_P30 = findpeaks(sp_m1_tep(1016:1036));
%         sp_N45 = -findpeaks(-sp_m1_tep(1032:1056));
%         sp_P60 = findpeaks(sp_m1_tep(1049:1071));
%         sp_N100 = -findpeaks(-sp_m1_tep(1091:1151));
%         sp_P180 = findpeaks(sp_m1_tep(1151:1251));
% 
%         sici_m1_tep_data = [STUDY.changrp(8).erpdata{2, 1}(:,i) STUDY.changrp(12).erpdata{2, 1}(:,i) STUDY.changrp(40).erpdata{2, 1}(:,i) STUDY.changrp(43).erpdata{2, 1}(:,i)];
%         sici_m1_tep = mean((sici_m1_tep_data)');
%         sici_m1_tep_array(i,:) = sici_m1_tep;
% 
%         sici_N15 = -findpeaks(-sici_m1_tep(1001:1021));
%         sici_P30 = findpeaks(sici_m1_tep(1016:1036));
%         sici_N45 = -findpeaks(-sici_m1_tep(1032:1056));
%         sici_P60 = findpeaks(sici_m1_tep(1049:1071));
%         sici_N100 = -findpeaks(-sici_m1_tep(1091:1151));
%         sici_P180 = findpeaks(sici_m1_tep(1151:1251));
% 
%         sici_peaks(:,i) = {sici_N15; sici_P30; sici_N45; sici_P60; sici_N100; sici_P180};
%         sp_peaks(:,i) = {sp_N15; sp_P30; sp_N45; sp_P60; sp_N100; sp_P180};
% 
% 
%         if  isempty(cell2mat(sp_peaks(1,i))) == 1
%             sp_peaks(1,i) = num2cell(sp_m1_tep(1016));
%         end
%         if isempty(cell2mat(sp_peaks(2,i))) == 1
%             sp_peaks(2,i) = num2cell(sp_m1_tep(1031));
%         end
%         if isempty(cell2mat(sp_peaks(3,i))) == 1
%             sp_peaks(3,i) = num2cell(sp_m1_tep(1046));
%         end
%         if isempty(cell2mat(sp_peaks(4,i))) == 1
%             sp_peaks(4,i) = num2cell(sp_m1_tep(1061));
%         end
%         if isempty(cell2mat(sp_peaks(5,i))) == 1
%             sp_peaks(5,i) = num2cell(sp_m1_tep(1101));
%         end
%         if isempty(cell2mat(sp_peaks(6,i))) == 1
%             sp_peaks(6,i) = num2cell(sp_m1_tep(1181));
%         end
% 
%         if  isempty(cell2mat(sici_peaks(1,i))) == 1
%             sici_peaks(1,i) = num2cell(sici_m1_tep(1016));
%         end
%         if isempty(cell2mat(sici_peaks(2,i))) == 1
%             sici_peaks(2,i) = num2cell(sici_m1_tep(1031));
%         end
%         if isempty(cell2mat(sici_peaks(3,i))) == 1
%             sici_peaks(3,i) = num2cell(sici_m1_tep(1046));
%         end
%         if isempty(cell2mat(sici_peaks(4,i))) == 1
%             sici_peaks(4,i) = num2cell(sici_m1_tep(1061));
%         end
%         if isempty(cell2mat(sici_peaks(5,i))) == 1
%             sici_peaks(5,i) = num2cell(sici_m1_tep(1101));
%         end
%         if isempty(cell2mat(sici_peaks(6,i))) == 1
%             sici_peaks(6,i) = num2cell(sici_m1_tep(1181));
%         end
% end
% 
% for j = 1:length(sp_peaks) 
%     sp_peaks{1,j} = min(sp_peaks{1,j}); %N15
%     sp_peaks{2,j} = max(sp_peaks{2,j}); %P30
%     sp_peaks{3,j} = min(sp_peaks{3,j}); %N45
%     sp_peaks{4,j} = max(sp_peaks{4,j}); %P60
%     sp_peaks{5,j} = min(sp_peaks{5,j}); %N100
%     sp_peaks{6,j} = max(sp_peaks{6,j}); %P180
%     
%     sici_peaks{1,j} = min(sici_peaks{1,j}); %N15
%     sici_peaks{2,j} = max(sici_peaks{2,j}); %P30
%     sici_peaks{3,j} = min(sici_peaks{3,j}); %N45
%     sici_peaks{4,j} = max(sici_peaks{4,j}); %P60
%     sici_peaks{5,j} = min(sici_peaks{5,j}); %N100
%     sici_peaks{6,j} = max(sici_peaks{6,j}); %P180
% end
% 

