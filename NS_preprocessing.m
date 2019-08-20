


%This is a conversation of Vish's script
% it has simply introduced loops into so the structure is easier to see 
% N Sharma Aug 2019
 
mydir = ('/omega/TMS_EEG_Data');
mycon=[ 1 2 3 4];
mychan = [1:63];
mywin = [-100  300];
addpath(genpath('/Applications/MATLAB_R2019a.app/toolbox/eeglab14_1_1b'))

cd(mydir); 
load('bob'); % this is function so need to load the data. 

% Split trials into single pulse and SICI 70, 80, 90
conditions(index_rejected_trials) = 0;
conditions = conditions(conditions ~= 0);
re_referenced_eeg = pop_reref( EEG, []);

for k=1:4; % for each condition

    myeeg = EEG;
    myref = EEG;
    myindex = conditions==(k);
    myindex = find(myindex);  
    myeeg.data = EEG.data(:,:,myindex);
    myref.data = re_referenced_eeg.data(:,:,myindex);
    %myeeg.trials = size(myeeg.trials); % single_pulse_eeg.trials Insert correct number of trials to produce ERP maps
    %myeeg.trials = myeeg.trials(3); % same as reref_sici_90_eeg.trials 
    %myref.trials = myeeg.trials(3); % this is werid in the script I think it shouold be myref.trials = myeeg.trials;
    myref.epoch = myref.epoch(:,myindex);
    %pop_saveset(myref);
    %Raw plots
    figure; pop_plottopo(myeeg, mychan , strcat('Condition',num2str(k),'ERP data and scalp maps'), 0, 'ydir',1);
    figure; pop_timtopo(myeeg,mywin, NaN), strcat('Condition',num2str(k),'ERP data and scalp maps'); % this looks wrong 
    % Re-referenced plots
    figure; pop_plottopo(myref,mychan , strcat('Condition',num2str(k),'ERP data and scalp maps'), 0, 'ydir',1);
    figure; pop_timtopo(myref,mywin,NaN), strcat('Condition',num2str(k),'ERP data and scalp maps'); 
    % TEP Analysis Re-referenced Data
    myref = pop_tesa_tepextract( myref, 'ROI', 'elecs', {'FC1','FC3','C1','C3'} ); %Average M1 TEP
    myref = pop_tesa_tepextract( myref, 'ROI', 'elecs', {'FC1','FC3','C1','C3'} ); %Average M1 TEP
    myref.ROI.R2.tseries = abs(myref.ROI.R2.tseries);
    myref = pop_tesa_peakanalysis( myref, 'ROI', 'negative', [45,100], [35,55;75,150], 'method','centre', 'samples', 5);
    myref = pop_tesa_peakanalysis( myref, 'ROI', 'positive', [30,60,180], [15,35;55,75;150,250], 'method','centre', 'samples', 5);
    myref = pop_tesa_tepextract( myref, 'GMFA');
    myref = pop_tesa_peakanalysis( myref, 'GMFA', 'positive', [50,110,200],[30,70;70,150;150,250], 'method','largest', 'samples', 5);
    % Plot re-ref M1 TEP
    plot(myref.ROI.R1.time, myref.ROI.R1.tseries)
    hold on
    % Plot re-ref M1 LMFP
    plot(myref.ROI.R2.time, myref.ROI.R2.tseries)
    hold on
    % TEP Analysis Raw Data
    myeeg = pop_tesa_tepextract( myeeg, 'ROI', 'elecs', {'FC1','FC3','C1','C3'} ); %Average M1 TEP
    myeeg = pop_tesa_tepextract( myeeg, 'ROI', 'elecs', {'FC1','FC3','C1','C3'} ); %Average M1 TEP
    myeeg.ROI.R2.tseries = abs(myeeg.ROI.R2.tseries);
    myeeg = pop_tesa_peakanalysis( myeeg, 'ROI', 'negative', [45,100], [35,55;75,150], 'method','centre', 'samples', 5);
    myeeg = pop_tesa_peakanalysis( myeeg, 'ROI', 'positive', [30,60,180], [15,35;55,75;150,250], 'method','centre', 'samples', 5);
    myeeg = pop_tesa_tepextract( myeeg, 'GMFA');
    myeeg = pop_tesa_peakanalysis( myeeg, 'GMFA', 'positive', [50,110,200],[30,70;70,150;150,250], 'method','largest', 'samples', 5);
    % Plot raw M1 TEP
    plot(myeeg.ROI.R1.time, myeeg.ROI.R1.tseries)
    hold on
    % Plot raw M1 LMFP
    plot(myeeg.ROI.R2.time, myeeg.ROI.R2.tseries)
    hold on
    % Summary re-ref NEED TO CHECK THIS BIT AND ADD THE OUT OF LOOP STUFF
    myref_tep_peaks(k) = [myref.ROI.R1.P30.amp, myref.ROI.R1.N45.amp, myref.ROI.R1.P60.amp, myref.ROI.R1.N100.amp, myref.ROI.R1.P180.amp];  
    myref_tep_latency(k) = [myref.ROI.R1.P30.lat, myref.ROI.R1.N45.lat, myref.ROI.R1.P60.lat, myref.ROI.R1.N100.lat, myref.ROI.R1.P180.lat];  
    myref_GMFP_peaks(k) = [myref.GMFA.R1.P50.amp, myref.GMFA.R1.P110.amp, myref.GMFA.R1.P200.amp];  
    % summary raw
    myeeg_tep_peaks(k) = [myeeg.ROI.R1.P30.amp, myeeg.ROI.R1.N45.amp, myeeg.ROI.R1.P60.amp, myeeg.ROI.R1.N100.amp, myeeg.ROI.R1.P180.amp];  
    myeeg_tep_latency(k) = [myeeg.ROI.R1.P30.lat, myeeg.ROI.R1.N45.lat, myeeg.ROI.R1.P60.lat, myeeg.ROI.R1.N100.lat, myeeg.ROI.R1.P180.lat];  
    myeeg_GMFP_peaks(k) = [myeeg.GMFA.R1.P50.amp, myeeg.GMFA.R1.P110.amp, myeeg.GMFA.R1.P200.amp];  
    %summary
    mysumref(k)=myref;
    mysumeeg(k)=myeeg;
end

% I have kept the labels here incase they are called in another script.
% This could be tided up as well

ref_tep_peaks = [myref_tep_peaks(1), myref_tep_peaks(2),myref_tep_peaks(3), myref_tep_peaks(3)];
reref_tep_latency = [myref_tep_latency(1), myref_tep_latency(2), myref_tep_latency(3), myref_tep_latency(4)];
reref_GMFP_peaks = [myref_GMFP_peaks(1), myref_GMFP_peaks(2), myref_GMFP_peaks(3), myref_GMFP_peaks(4)];

% this call may not work
reref_LMFP = [mysumref(1).ROI.R2.tseries, mysumref(2).ROI.R2.tseries, mysumref(3).ROI.R2.tseries, mysumref(3).ROI.R2.tseries];
reref_GMFP = [mysumref(1).GMFA.R1.tseries, mysumref(2).GMFA.R1.tseries, mysumref(3).GMFA.R1.tseries, mysumref(4).GMFA.R1.tseries];
reref_m1_teps = [mysumref(1).ROI.R1.tseries, mysumref(2).ROI.R1.tseries, mysumref(3).ROI.R1.tseries, mysumref(4).ROI.R1.tseries];
raw_tep_peaks = [myeeg_tep_peaks(1), myeeg_tep_peaks(2), myeeg_tep_peaks(3), myeeg_tep_peaks(4)];
raw_tep_latency = [myeeg_tep_latency(1), myeeg_tep_latency(2), myeeg_tep_latency(3), myeeg_tep_latency(4)];
raw_GMFP_peaks = [myeeg_GMFP_peaks(1), myeeg_GMFP_peaks(2), myeeg_GMFP_peaks(3), myeeg_GMFP_peaks(4)];
raw_LMFP = [mysumeeg(1).ROI.R2.tseries, mysumeeg(2).ROI.R2.tseries, mysumeeg(3).ROI.R2.tseries, mysumeeg(4).ROI.R2.tseries];
raw_GMFP = [mysumeeg(1).GMFA.R1.tseries, mysumeeg(2).GMFA.R1.tseries, mysumeeg(3).GMFA.R1.tseries, mysumeeg(4).GMFA.R1.tseries];

