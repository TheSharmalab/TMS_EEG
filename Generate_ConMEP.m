
% This file requires the text files output from Signal including markers
% and the MEP peak. It assumes that there are four files per subject
% rrequires the .mat from stage 1 
% N Sharma 8/21/19

mydir = ('/Users/Isabella/Documents/thesharmalab/TMS_EEG/Additional_Experiments/Preprocessed_data');
mymdir = ('/Users/Isabella/Documents/thesharmalab/TMS_EEG/Additional_Experiments/Preprocessed_data/marker_data'); % this is data from Signal

cd(mymdir);  

mydata = [];
mycon = [];
for k=1:8;
    mycon = []; 
    for j=1:4;
        filename = strcat('HV00',num2str(k),'_add_preprocessed','.mat');  % alter this to include Izzy's filename from stage 1 
        load(filename); % loads the .mat
        file = strcat('HV00',num2str(k),'_ADD_',num2str(j),'.txt'); 
        mytempcon = dlmread(file,'\t',1,0); % reads in all the MEP and conditions
        mycon = vertcat(mycon,mytempcon); 
    end
        mycon(index_rejected_trials,:) = 0; % removes the rejected files
        mycon( ~any(mycon,2), : ) = [];  %delete rows with 0
    save(strcat('HV00',num2str(k),'_CONMEP.txt'), 'mycon', '-ascii'); 
    %separate trials into each condition
    rereferenced_eeg = pop_reref(EEG,[]); %re-references EEG to common average
     for l=1:4; %for each condition (we have 4 conditions)
         index = find(mycon(:,1)==l); %finds indices for each condition
         data = rereferenced_eeg; %sets up an EEG structure from the re-referenced EEG
         data.data = rereferenced_eeg.data(:,:,index); %takes out the EEG data pertaining to condition
         data.trials = size(data.data,3); %changes number of trials to suit
         data.epoch = rereferenced_eeg.epoch(:,index); %changes epoch labels to suit
           filename = strcat('HV00',num2str(k),'_ADD_','con',num2str(l),'_eeg'); %sets up filename
           pop_saveset(data,'filename',filename,'filepath',mydir) %saves filename in mydir
     end
    mycon(:,3) = [k];
    mydata = vertcat(mydata,mycon);
end
save('allsubjects_conMEP.txt', 'mydata', '-ascii'); 

