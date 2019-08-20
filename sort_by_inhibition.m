conditions(index_rejected_trials,:) = 0;
conditions( ~any(conditions,2), : ) = [];  %delete rows with 0
for i=1:length(conditions)
    conditions(i,3) = i;
end

EEG = pop_reref( EEG, []);

single_pulse_eeg = EEG;
sici_eeg = EEG;

single_pulse_index = conditions(:,1)==1;
single_pulse_index = find(single_pulse_index);
single_pulse_eeg.data = EEG.data(:,:,single_pulse_index);
single_pulse_eeg.epoch = single_pulse_eeg.epoch(:,single_pulse_index);

sici_index = conditions(:,1)>1;
sici_index = find(sici_index);
sici_eeg.data = EEG.data(:,:,sici_index);
sici_eeg.epoch = sici_eeg.epoch(:,sici_index);

sici_conditions = conditions(sici_index,:);
sici_conditions = sortrows(sici_conditions,2); %Sorts data by MEP

first_index = 1:round(length(sici_conditions)/3); %Indexes for smallest 1/3 MEPs
first_conditions = sici_conditions(first_index,:);
second_index = round(length(sici_conditions)/3):round(length(sici_conditions)*2/3); %Indexes for medium sized MEPs
second_conditions = sici_conditions(second_index,:);
third_index = round(length(sici_conditions)*2/3):length(sici_conditions); %Indexes for largest MEPs
third_conditions = sici_conditions(third_index,:);

first = EEG;
second = EEG;
third = EEG;

first.data = EEG.data(:,:,first_conditions(:,3));
second.data = EEG.data(:,:,second_conditions(:,3));
third.data = EEG.data(:,:,third_conditions(:,3));

first.epoch = EEG.epoch(:,first_conditions(:,3));
second.epoch = EEG.epoch(:,second_conditions(:,3));
third.epoch = EEG.epoch(:,third_conditions(:,3));

first_mep = mean(first_conditions(:,2));
second_mep = mean(second_conditions(:,2));
third_mep = mean(third_conditions(:,2));

meps = [first_mep, second_mep, third_mep];

pop_saveset(single_pulse_eeg);
pop_saveset(first);
pop_saveset(second);
pop_saveset(third);

%% Re-referenced plots

figure; pop_plottopo(first, [1:63] , 'first', 0, 'ydir',1);
figure; pop_plottopo(second, [1:63] , 'second', 0, 'ydir',1);
figure; pop_plottopo(third, [1:63] , 'third', 0, 'ydir',1);
figure; pop_plottopo(single_pulse_eeg, [1:63] , 'single pulse', 0, 'ydir',1);