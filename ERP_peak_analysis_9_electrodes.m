%% ERP Peak Analysis - Uses STUDY structure formed from the output of eeglab ERPs 

% 4 electrode
addpath '/Applications/MATLAB_R2017a.app/toolbox/fdr_bh'
addpath '/Applications/MATLAB_R2017a.app/toolbox/raacampbell-shadedErrorBar-0dc4de5'


sp_peaks ={};
sici_peaks = {};
p_value_t_test = [];

for i = 1:15;

sp_m1_tep_data = [STUDY.changrp(8).erpdata{1, 1}(:,i) STUDY.changrp(12).erpdata{1, 1}(:,i) STUDY.changrp(40).erpdata{1, 1}(:,i) STUDY.changrp(43).erpdata{1, 1}(:,i) STUDY.changrp(6).erpdata{1, 1}(:,i) STUDY.changrp(7).erpdata{1, 1}(:,i) STUDY.changrp(11).erpdata{1, 1}(:,i) STUDY.changrp(39).erpdata{1, 1}(:,i) STUDY.changrp(41).erpdata{1, 1}(:,i)];
sp_m1_tep = mean((sp_m1_tep_data)');
sp_m1_tep_array(i,:) = sp_m1_tep;

sp_N15 = -findpeaks(-sp_m1_tep(1001:1021));
sp_P30 = findpeaks(sp_m1_tep(1016:1036));
sp_N45 = -findpeaks(-sp_m1_tep(1032:1056));
sp_P60 = findpeaks(sp_m1_tep(1049:1071));
sp_N100 = -findpeaks(-sp_m1_tep(1091:1151));
sp_P180 = findpeaks(sp_m1_tep(1151:1251));

sici_m1_tep_data = [STUDY.changrp(8).erpdata{2, 1}(:,i) STUDY.changrp(12).erpdata{2, 1}(:,i) STUDY.changrp(40).erpdata{2, 1}(:,i) STUDY.changrp(43).erpdata{2, 1}(:,i) STUDY.changrp(6).erpdata{2, 1}(:,i) STUDY.changrp(7).erpdata{2, 1}(:,i) STUDY.changrp(11).erpdata{2, 1}(:,i) STUDY.changrp(39).erpdata{2, 1}(:,i) STUDY.changrp(41).erpdata{2, 1}(:,i)];
sici_m1_tep = mean((sici_m1_tep_data)');
sici_m1_tep_array(i,:) = sici_m1_tep;

sici_N15 = -findpeaks(-sici_m1_tep(1001:1021));
sici_P30 = findpeaks(sici_m1_tep(1016:1036));
sici_N45 = -findpeaks(-sici_m1_tep(1032:1056));
sici_P60 = findpeaks(sici_m1_tep(1049:1071));
sici_N100 = -findpeaks(-sici_m1_tep(1091:1151));
sici_P180 = findpeaks(sici_m1_tep(1151:1251));

sici_peaks(:,i) = {sici_N15; sici_P30; sici_N45; sici_P60; sici_N100; sici_P180};
sp_peaks(:,i) = {sp_N15; sp_P30; sp_N45; sp_P60; sp_N100; sp_P180};

end

for j = 1:length(sp_peaks)
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

%% Paired t-test

for k = 1:length(sp_m1_tep)

[h,p] = ttest(sp_m1_tep_array(:,k),sici_m1_tep_array(:,k));
p_value_t_test(k) = p;
end

for o = 1:length(p_value_t_test)

significant_points(o) = p_value_t_test(o)<0.05;
end

x = p_value_t_test(1000:1200);
y = fdr_bh(x,0.05,'pdep','yes');

% %% Mann-Whitney test
% 
% for k = 1:length(sp_m1_tep)
% 
% [p,h] = signrank(sp_m1_tep_array(:,k),sici_m1_tep_array(:,k));
% p_value_t_test(k) = p;
% end
% 
% for o = 1:length(p_value_t_test)
% 
% significant_points(o) = p_value_t_test(o)<0.05;
% end
% 
% x = p_value_t_test(1000:1200);
% y = fdr_bh(x,0.05,'pdep','yes');

significant_indices = y==1;
significant_indices = find(significant_indices);
significant_indices = significant_indices;

time = [-999:1000];

subplot(1,3,1)

shadedErrorBar(time,mean(sp_m1_tep_array,1),std(sp_m1_tep_array)/sqrt(15),'lineprops',{'r','LineWidth',2});
% plot(time,sp_m1_tep);
hold on
shadedErrorBar(time,mean(sici_m1_tep_array,1),std(sici_m1_tep_array)/sqrt(15),'lineprops',{'b','LineWidth',2});

% draw the bars for significance 
for p = 1:length(significant_indices)
line([(significant_indices(p));(significant_indices(p))],[-7;-6.5],'linestyle','-','Color','black','LineWidth',2);
end

xlim([-100 500])
ylim([-8 7])
set(gca,'linewidth',2)
title('spTMS vs SICI 70')
ylabel('\bf Amplitude (\muV)')
xlabel('\bf Time (ms)')
axis('square');

L(1) = plot(nan, nan, 'r-','LineWidth',5);
L(2) = plot(nan, nan, 'b-','LineWidth',5);
legend(L, {'spTMS', 'SICI'})

ans(1,:) = mean(sici_m1_tep_array);
ans(2,:) = std(sici_m1_tep_array)/sqrt(15);

for i = 1:15
    sp_m1_tep_data = [STUDY.changrp(8).erpdata{1, 1}(:,i) STUDY.changrp(12).erpdata{1, 1}(:,i) STUDY.changrp(40).erpdata{1, 1}(:,i) STUDY.changrp(43).erpdata{1, 1}(:,i) STUDY.changrp(6).erpdata{1, 1}(:,i) STUDY.changrp(7).erpdata{1, 1}(:,i) STUDY.changrp(11).erpdata{1, 1}(:,i) STUDY.changrp(39).erpdata{1, 1}(:,i) STUDY.changrp(41).erpdata{1, 1}(:,i)];
    sp_m1_tep = mean((sp_m1_tep_data)');
    subplot (3,5,i)
    plot(sp_m1_tep)
    xlim([900 1300])
end


% csvwrite('sp_peaks.csv',sp_peaks)
% csvwrite('sici_70_peaks.csv',sici_peaks)

% writetable(cell2table(sp_peaks),'sp_peaks.csv')
% writetable(cell2table(sici_peaks),'sici_Low_peaks.csv')