for i = 1:13

a = STUDY.changrp(7).erspdata{1, 1}(:,:,i);
a = mean(a);
sp_FC1(i,:) = a;

a = STUDY.changrp(39).erspdata{1, 1}(:,:,i);
a = mean(a);
sp_FC3(i,:) = a;

a = STUDY.changrp(6).erspdata{1, 1}(:,:,i);
a = mean(a);
sp_FC5(i,:) = a;

a = STUDY.changrp(40).erspdata{1, 1}(:,:,i);
a = mean(a);
sp_C1(i,:) = a;

a = STUDY.changrp(8).erspdata{1, 1}(:,:,i);
a = mean(a);
sp_C3(i,:) = a;

a = STUDY.changrp(41).erspdata{1, 1}(:,:,i);
a = mean(a);
sp_C5(i,:) = a;

a = STUDY.changrp(12).erspdata{1, 1}(:,:,i);
a = mean(a);
sp_CP1(i,:) = a;

a = STUDY.changrp(43).erspdata{1, 1}(:,:,i);
a = mean(a);
sp_CP3(i,:) = a;

a = STUDY.changrp(11).erspdata{1, 1}(:,:,i);
a = mean(a);
sp_CP5(i,:) = a;

end

sp_mean_FC1 = mean(sp_FC1);
sp_mean_FC3 = mean(sp_FC3);
sp_mean_FC5 = mean(sp_FC5);
sp_mean_C1 = mean(sp_C1);
sp_mean_C3 = mean(sp_C3);
sp_mean_C5 = mean(sp_C5);
sp_mean_CP1 = mean(sp_CP1);
sp_mean_CP3 = mean(sp_CP3);
sp_mean_CP5 = mean(sp_CP5);

M1_ERSP = mean([sp_mean_C1; sp_mean_C3; sp_mean_C5; sp_mean_CP1; sp_mean_CP3; sp_mean_CP5; sp_mean_FC1; sp_mean_FC3; sp_mean_FC5]);

for i = 1:13

b = STUDY.changrp(7).erspdata{2, 1}(:,:,i);
b = mean(b);
sici_FC1(i,:) = b;

b = STUDY.changrp(39).erspdata{2, 1}(:,:,i);
b = mean(b);
sici_FC3(i,:) = b;

b = STUDY.changrp(6).erspdata{2, 1}(:,:,i);
b = mean(b);
sici_FC5(i,:) = b;

b = STUDY.changrp(40).erspdata{2, 1}(:,:,i);
b = mean(b);
sici_C1(i,:) = b;

b = STUDY.changrp(8).erspdata{2, 1}(:,:,i);
b = mean(b);
sici_C3(i,:) = b;

b = STUDY.changrp(41).erspdata{2, 1}(:,:,i);
b = mean(b);
sici_C5(i,:) = b;

b = STUDY.changrp(12).erspdata{2, 1}(:,:,i);
b = mean(b);
sici_CP1(i,:) = b;

b = STUDY.changrp(43).erspdata{2, 1}(:,:,i);
b = mean(b);
sici_CP3(i,:) = b;

b = STUDY.changrp(11).erspdata{2, 1}(:,:,i);
b = mean(b);
sici_CP5(i,:) = b;

end

sici_mean_FC1 = mean(sici_FC1);
sici_mean_FC3 = mean(sici_FC3);
sici_mean_FC5 = mean(sici_FC5);
sici_mean_C1 = mean(sici_C1);
sici_mean_C3 = mean(sici_C3);
sici_mean_C5 = mean(sici_C5);
sici_mean_CP1 = mean(sici_CP1);
sici_mean_CP3 = mean(sici_CP3);
sici_mean_CP5 = mean(sici_CP5);

sici_ERSP = mean([sici_mean_C1; sici_mean_C3; sici_mean_C5; sici_mean_CP1; sici_mean_CP3; sici_mean_CP5; sici_mean_FC1; sici_mean_FC3; sici_mean_FC5]);

%% ERSP Averaged in time windows

sp_mean_array(:,:,1) = sp_C1;
sp_mean_array(:,:,2) = sp_C3;
sp_mean_array(:,:,3) = sp_C5;
sp_mean_array(:,:,4) = sp_CP1;
sp_mean_array(:,:,5) = sp_CP3;
sp_mean_array(:,:,6) = sp_CP5;
sp_mean_array(:,:,7) = sp_FC1;
sp_mean_array(:,:,8) = sp_FC3;
sp_mean_array(:,:,9) = sp_FC5;

single_subject_sp_mean = mean(sp_mean_array,3);
sp_ersp_20_60 = mean(single_subject_sp_mean(:,[105:114])')';
mean_ersp_20_60 = mean(sp_ersp_20_60);
    

sp_ersp_80_120 = mean(single_subject_sp_mean(:,[118:128])')';
mean_ersp_80_120 = mean(sp_ersp_80_120);
    
sp_ersp_180_220 = mean(single_subject_sp_mean(:,[141:151])')';
mean_ersp_180_220 = mean(sp_ersp_180_220);

sp_summary = [sp_ersp_20_60 sp_ersp_80_120 sp_ersp_180_220];
    
sici_mean_array(:,:,1) = sici_C1;
sici_mean_array(:,:,2) = sici_C3;
sici_mean_array(:,:,3) = sici_C5;
sici_mean_array(:,:,4) = sici_CP1;
sici_mean_array(:,:,5) = sici_CP3;
sici_mean_array(:,:,6) = sici_CP5;
sici_mean_array(:,:,7) = sici_FC1;
sici_mean_array(:,:,8) = sici_FC3;
sici_mean_array(:,:,9) = sici_FC5;

single_subject_sici_mean = mean(sici_mean_array,3);
sici_ersp_20_60 = mean(single_subject_sici_mean(:,[105:114])')';
sici_mean_ersp_20_60 = mean(sici_ersp_20_60);
    

sici_ersp_80_120 = mean(single_subject_sici_mean(:,[118:128])')';
sici_mean_ersp_80_120 = mean(sici_ersp_80_120);
    
sici_ersp_180_220 = mean(single_subject_sici_mean(:,[141:151])')';
sici_mean_ersp_180_220 = mean(sici_ersp_180_220);

sici_summary = [sici_ersp_20_60 sici_ersp_80_120 sici_ersp_180_220];


shadedErrorBar(STUDY.changrp(8).ersptimes,mean(single_subject_sp_mean,1),std(single_subject_sp_mean)/sqrt(13),'lineprops','r');
hold on
shadedErrorBar(STUDY.changrp(8).ersptimes,mean(single_subject_sici_mean,1),std(single_subject_sici_mean)/sqrt(13),'lineprops','b');
xlim([-100 400])
title('Gamme, 30-45Hz')