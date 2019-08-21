
% This file requires the text files output from Signal including markers
% and the MEP peak. It assumes that there are four files per subject
% N Sharma 8/21/19

mydir = ('/omega/TMS_EEG_Data');
mymdir = ('/omega/TMS_EEG_Data/marker_data'); % this is data from Signal

cd(mymdir);  

mydata = [];
for k=1:8;
    mycon = []; 
    for j=1:4;
        file = strcat('HV00',num2str(k),'_ADD_',num2str(j),'.txt'); 
        mytempcon = dlmread(file,'\t',1,0);
        mycon = vertcat(mycon,mytempcon); 
    end
    save(strcat('HV00',num2str(k),'_CONMEP.txt'), 'mycon'); 
    mycon(:,3) = [k];
    mydata = vertcat(mydata,mycon);
end
save('allsubjects_conMEP.txt', 'mydata'); 