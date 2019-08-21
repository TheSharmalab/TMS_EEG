
% This file requires the text files output from Signal including markers
% and the MEP peak. It assumes that there are four files per subject
% N Sharma 8/21/19

mydir = ('/omega/TMS_EEG_Data');
cd(mydir);  
mycon = ["70","70.70","70.120","120"];

S1_70.set

for j=1:8
    for k=1:length(mycon)
        filename = strcat('S',num2str(k),'_ADD_',num2str(j),'.mat');  % alter this to include Izzy's filenam,e
        load(filename);
        state=mycon{k};
        mysave = strcat('S',num2str(j),'_',state,'.set'); 
        % save dataset - CHANGE FILENAME 
        EEG = pop_saveset( EEG, 'filename',mysave,'filepath',mydir);
        [ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);

        ALLEEG = pop_delset( ALLEEG, [1] );
        STUDY = []; CURRENTSTUDY = 0; ALLEEG = []; EEG=[]; CURRENTSET=[];
    end
end 

S1_70.set

mydata = [];
for k=1:8;
    mycon = []; 
    for j=1:4;
        file = strcat('S',num2str(k),'_ADD_',num2str(j),'.txt'); 
        mytempcon = dlmread(file,'\t',1,0);
        mycon = vertcat(mycon,mytempcon); 
    end
    save(strcat('HV00',num2str(k),'_CONMEP.txt'), 'mycon'); 
    mycon(:,3) = [k];
    mydata = vertcat(mydata,mycon);
end
save('allsubjects_conMEP.txt', 'mydata'); 