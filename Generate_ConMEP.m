
% This file requires the text files output from Signal including markers
% and the MEP peak. It assumes that there are four files per subject
% rrequires the .mat from stage 1 
% N Sharma 8/21/19

mydir = ('/Users/Isabella/Documents/thesharmalab/TMS_EEG/Additional_Experiments/Preprocessed_data');
mymdir = ('/Users/Isabella/Documents/thesharmalab/TMS_EEG/Additional_Experiments/Preprocessed_data/marker_data'); % this is data from Signal

cd(mymdir);  

mydata = [];
for k=1:8;
    mycon = []; 
    for j=1:4;
        filename = strcat('HV00',num2str(k),'_add_preprocessed','.mat');  % alter this to include Izzy's filename from stage 1 
        load(filename); % loads the .mat
        file = strcat('HV00',num2str(k),'_ADD_',num2str(j),'.txt'); 
        mytempcon = dlmread(file,'\t',1,0); % reads in all the MEP and conditions
        mytempcon(index_rejected_trials,:) = 0; % removes the rejected files
        mytempcon( ~any(mytempcon,2), : ) = [];  %delete rows with 0
        mycon = vertcat(mycon,mytempcon); 
    end
    save(strcat('HV00',num2str(k),'_CONMEP.txt'), 'mycon', '-ascii'); 
    mycon(:,3) = [k];
    mydata = vertcat(mydata,mycon);
end
save('allsubjects_conMEP.txt', 'mydata', '-ascii'); 