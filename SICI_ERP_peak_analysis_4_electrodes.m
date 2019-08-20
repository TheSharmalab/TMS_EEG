%% ERP Peak Analysis - Uses STUDY structure formed from the output of eeglab ERPs 

% 4 electrode
addpath '/Applications/MATLAB_R2017a.app/toolbox/fdr_bh'
addpath '/Applications/MATLAB_R2017a.app/toolbox/raacampbell-shadedErrorBar-0dc4de5'


sp_peaks ={};
sici_peaks = {};
p_value_t_test = [];

for i = 1:15;

sp_m1_tep_data = [STUDY.changrp(8).erpdata{1, 1}(:,i) STUDY.changrp(12).erpdata{1, 1}(:,i) STUDY.changrp(40).erpdata{1, 1}(:,i) STUDY.changrp(43).erpdata{1, 1}(:,i)];
sp_m1_tep = mean((sp_m1_tep_data)');
sp_m1_tep_array(i,:) = sp_m1_tep;

sp_N15 = -findpeaks(-sp_m1_tep(1001:1021));
sp_P30 = findpeaks(sp_m1_tep(1016:1036));
sp_N45 = -findpeaks(-sp_m1_tep(1032:1056));
sp_P60 = findpeaks(sp_m1_tep(1049:1071));
sp_N100 = -findpeaks(-sp_m1_tep(1091:1151));
sp_P180 = findpeaks(sp_m1_tep(1151:1251));

sici_m1_tep_data = [STUDY.changrp(8).erpdata{2, 1}(:,i) STUDY.changrp(12).erpdata{2, 1}(:,i) STUDY.changrp(40).erpdata{2, 1}(:,i) STUDY.changrp(43).erpdata{2, 1}(:,i)];
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

% %% Paired t-test
% 
% for k = 1:length(sp_m1_tep)
% 
% [h,p] = ttest(sp_m1_tep_array(:,k),sici_m1_tep_array(:,k));
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

%% Wilcoxon signed-rank test

for k = 1:length(sp_m1_tep)

[p,h] = signrank(sp_m1_tep_array(:,k),sici_m1_tep_array(:,k));
p_value_t_test(k) = p;
end

for o = 1:length(p_value_t_test)

significant_points(o) = p_value_t_test(o)<0.05;
end

x = p_value_t_test(1000:1200);
y = fdr_bh(x,0.05,'pdep','yes');

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

figure
for i = 1:15
    sp_m1_tep_data = [STUDY.changrp(8).erpdata{1, 1}(:,i) STUDY.changrp(12).erpdata{1, 1}(:,i) STUDY.changrp(40).erpdata{1, 1}(:,i) STUDY.changrp(43).erpdata{1, 1}(:,i)];
    sp_m1_tep = mean((sp_m1_tep_data)');
    subplot (3,5,i)
    plot(sp_m1_tep)
    xlim([900 1300])
end

n15 = [sp_peaks(1,:);sici_peaks(1,:);num2cell(mep')];
keep = all(~cellfun('isempty',n15), 1);
n15 = n15(:,keep);

p30 = [sp_peaks(2,:);sici_peaks(2,:);num2cell(mep')];
keep = all(~cellfun('isempty',p30), 1);
p30 = p30(:,keep);

n45 = [sp_peaks(3,:);sici_peaks(3,:);num2cell(mep')];
keep = all(~cellfun('isempty',n45), 1);
n45 = n45(:,keep);

p60 = [sp_peaks(4,:);sici_peaks(4,:);num2cell(mep')];
keep = all(~cellfun('isempty',p60), 1);
p60 = p60(:,keep);

n100 = [sp_peaks(5,:);sici_peaks(5,:);num2cell(mep')];
keep = all(~cellfun('isempty',n100), 1);
n100 = n100(:,keep);

p180 = [sp_peaks(6,:);sici_peaks(6,:);num2cell(mep')];
keep = all(~cellfun('isempty',p180), 1);
p180 = p180(:,keep);

[p,h,stats] = signrank(cell2mat(n15(1,:)),cell2mat(n15(2,:)));
wilcoxon_stats(1,:) = [p,h,stats.signedrank];

[p,h,stats] = signrank(cell2mat(p30(1,:)),cell2mat(p30(2,:)));
wilcoxon_stats(2,:) = [p,h,stats.signedrank];

[p,h,stats] = signrank(cell2mat(n45(1,:)),cell2mat(n45(2,:)));
wilcoxon_stats(3,:) = [p,h,stats.signedrank];

[p,h,stats] = signrank(cell2mat(p60(1,:)),cell2mat(p60(2,:)));
wilcoxon_stats(4,:) = [p,h,stats.signedrank];

[p,h,stats] = signrank(cell2mat(n100(1,:)),cell2mat(n100(2,:)));
wilcoxon_stats(5,:) = [p,h,stats.signedrank];

[p,h,stats] = signrank(cell2mat(p180(1,:)),cell2mat(p180(2,:)));
wilcoxon_stats(6,:) = [p,h,stats.signedrank];

% for i = 1:6
%     sw_test(i,1) = swtest(cell2mat(sp_peaks(i,:)));
%     sw_test(i,2) = swtest(cell2mat(sici_peaks(i,:)));
% end

low_stats = wilcoxon_stats;

corr_n15 = [sici_peaks(1,:);num2cell(mep')];
keep = all(~cellfun('isempty',corr_n15), 1);
corr_n15 = corr_n15(:,keep);

corr_p30 = [sici_peaks(2,:);num2cell(mep')];
keep = all(~cellfun('isempty',corr_p30), 1);
corr_p30 = corr_p30(:,keep);

corr_n45 = [sici_peaks(3,:);num2cell(mep')];
keep = all(~cellfun('isempty',corr_n45), 1);
corr_n45 = corr_n45(:,keep);

corr_p60 = [sici_peaks(4,:);num2cell(mep')];
keep = all(~cellfun('isempty',corr_p60), 1);
corr_p60 = corr_p60(:,keep);

corr_n100 = [sici_peaks(5,:);num2cell(mep')];
keep = all(~cellfun('isempty',corr_n100), 1);
corr_n100 = corr_n100(:,keep);

corr_p180 = [sici_peaks(6,:);num2cell(mep')];
keep = all(~cellfun('isempty',corr_p180), 1);
corr_p180 = corr_p180(:,keep);

prompt={'SICI condition?'}; 
dlg_title='Input';
default = {'70'}; 
answer=inputdlg(prompt,dlg_title,1,default);   

sici_condition = answer{1,1};

if sici_condition == '70'
    i = 3;
elseif sici_condition == '80'
    i = 4;
elseif sici_condition == '90'
    i = 5;
end


[rho,pval] = corr(cell2mat(corr_n15(1,:)'),cell2mat(corr_n15(i,:)'),'type','spearman');
sici_spearman(1,:) = [rho,pval];
[rho,pval] = corr(cell2mat(corr_p30(1,:)'),cell2mat(corr_p30(i,:)'),'type','spearman');
sici_spearman(2,:) = [rho,pval];
[rho,pval] = corr(cell2mat(corr_n45(1,:)'),cell2mat(corr_n45(i,:)'),'type','spearman');
sici_spearman(3,:) = [rho,pval];
[rho,pval] = corr(cell2mat(corr_p60(1,:)'),cell2mat(corr_p60(i,:)'),'type','spearman');
sici_spearman(4,:) = [rho,pval];
[rho,pval] = corr(cell2mat(corr_n100(1,:)'),cell2mat(corr_n100(i,:)'),'type','spearman');
sici_spearman(5,:) = [rho,pval];
[rho,pval] = corr(cell2mat(corr_p180(1,:)'),cell2mat(corr_p180(i,:)'),'type','spearman');
sici_spearman(6,:) = [rho,pval];

% csvwrite('sp_peaks.csv',sp_peaks)
% csvwrite('sici_70_peaks.csv',sici_peaks)

csvwrite('sici_90_n15.csv',[cell2mat(corr_n15(1,:)'),cell2mat(corr_n15(i,:)')])
csvwrite('sici_90_p30.csv',[cell2mat(corr_p30(1,:)'),cell2mat(corr_p30(i,:)')])
csvwrite('sici_90_n45.csv',[cell2mat(corr_n45(1,:)'),cell2mat(corr_n45(i,:)')])
csvwrite('sici_90_p60.csv',[cell2mat(corr_p60(1,:)'),cell2mat(corr_p60(i,:)')])
csvwrite('sici_90_n100.csv',[cell2mat(corr_n100(1,:)'),cell2mat(corr_n100(i,:)')])
csvwrite('sici_90_p180.csv',[cell2mat(corr_p180(1,:)'),cell2mat(corr_p180(i,:)')])


% writetable(cell2table(sp_peaks),'sp_peaks.csv')
% writetable(cell2table(sici_peaks),'sici_Low_peaks.csv')