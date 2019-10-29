
%%
output_folder = '../figure-assembly/components/';
if ~exist(output_folder, 'dir')
    mkdir(output_folder);
end

%% load prediction data
%
best_pred_data = readtable('../results-data/res6_size-predictions-from-comp/fE_and_active_rib_frac_data_fX-false/predictions.csv');


%% make the size vs growth rate plot data
mk_size = 9.5;
lw = 2;

I_cm_basan = find(best_pred_data.cm_type > 0 & strcmp(best_pred_data.source, 'Basan 2015'));
I_cm_si = find(best_pred_data.cm_type > 0 & strcmp(best_pred_data.source, 'Si 2017'));

I_useless_basan = find(best_pred_data.useless_type > 0 & strcmp(best_pred_data.source, 'Basan 2015'));

I_nut_basan = find(best_pred_data.cm_type == 0 & best_pred_data.useless_type == 0 & strcmp(best_pred_data.source, 'Basan 2015'));
I_nut_si = find(best_pred_data.cm_type == 0 & best_pred_data.useless_type == 0 & strcmp(best_pred_data.source, 'Si 2017'));
I_nut_taheri = find(best_pred_data.cm_type == 0 & best_pred_data.useless_type == 0 & strcmp(best_pred_data.source, 'Taheri-Araghi 2015'));

% color code: green nutrients / red useless / blue cm
% study symbole code: basan o / si s / taheri-araghi ^

figure;

plot(best_pred_data.growth_rate_per_hr(I_nut_basan), best_pred_data.real(I_nut_basan), 'go', 'MarkerSize', mk_size, 'MarkerFaceColor', 'g'); hold on;
plot(best_pred_data.growth_rate_per_hr(I_nut_si), best_pred_data.real(I_nut_si), 'gs', 'MarkerSize', mk_size, 'MarkerFaceColor', 'g'); hold on;
plot(best_pred_data.growth_rate_per_hr(I_nut_taheri), best_pred_data.real(I_nut_taheri), 'g^', 'MarkerSize', mk_size, 'MarkerFaceColor', 'g'); hold on;


plot(best_pred_data.growth_rate_per_hr(I_cm_si), best_pred_data.real(I_cm_si), 'bs', 'MarkerSize', mk_size, 'MarkerFaceColor', 'b'); hold on;
cm_si_nutrient_types = unique(best_pred_data.nutrient_type(I_cm_si));
for i_cm_si_nut_type=1:length(cm_si_nutrient_types)
    cm_si_nut_type = cm_si_nutrient_types(i_cm_si_nut_type);
    I_si_all_nut = best_pred_data.nutrient_type == cm_si_nut_type;
    plot(best_pred_data.growth_rate_per_hr(I_si_all_nut), best_pred_data.real(I_si_all_nut), 'b', 'LineWidth', lw); hold on;
end

plot(best_pred_data.growth_rate_per_hr(I_cm_basan), best_pred_data.real(I_cm_basan), 'bo', 'MarkerSize', mk_size, 'MarkerFaceColor', 'b'); hold on;
cm_basan_nutrient_types = unique(best_pred_data.nutrient_type(I_cm_basan));
for i_cm_basan_nut_type=1:length(cm_basan_nutrient_types)
    cm_basan_nut_type = cm_basan_nutrient_types(i_cm_basan_nut_type);
    I_basan_all_nut_no_useless = best_pred_data.nutrient_type == cm_basan_nut_type & best_pred_data.useless_type == 0;
    plot(best_pred_data.growth_rate_per_hr(I_basan_all_nut_no_useless), best_pred_data.real(I_basan_all_nut_no_useless), 'b', 'LineWidth', lw); hold on;
end

plot(best_pred_data.growth_rate_per_hr(I_useless_basan), best_pred_data.real(I_useless_basan), 'ro', 'MarkerSize', mk_size, 'MarkerFaceColor', 'r'); hold on;
useless_basan_nutrient_types = unique(best_pred_data.nutrient_type(I_useless_basan));
for i_useless_basan_nut_type=1:length(useless_basan_nutrient_types)
    useless_basan_nut_type = useless_basan_nutrient_types(i_useless_basan_nut_type);
    I_basan_all_nut_no_cm = best_pred_data.nutrient_type == useless_basan_nut_type & best_pred_data.cm_type == 0;
    plot(best_pred_data.growth_rate_per_hr(I_basan_all_nut_no_cm), best_pred_data.real(I_basan_all_nut_no_cm), 'r', 'LineWidth', lw); hold on;
end

title('Data');
xlabel('Growth rate (hr^{-1})');
ylabel('Size');
ylim([0 15]); xlim([0 3]);
set(gca,'FontSize',30,'LineWidth',2.5);


txt_fsize = 17;
plot(0.1,14,'go', 'MarkerSize', mk_size, 'MarkerFaceColor', 'g');
plot(0.22,14,'gs', 'MarkerSize', mk_size, 'MarkerFaceColor', 'g');
plot(0.34,14,'g^', 'MarkerSize', mk_size, 'MarkerFaceColor', 'g');
text(0.46,14,'nutrient','FontSize',txt_fsize);

plot(0.1,13.2,'bo', 'MarkerSize', mk_size, 'MarkerFaceColor', 'b');
plot(0.22,13.2,'bs', 'MarkerSize', mk_size, 'MarkerFaceColor', 'b');
text(0.34,13.2,'chloramphenicol','FontSize',txt_fsize);

plot(0.1,12.4,'ro', 'MarkerSize', mk_size, 'MarkerFaceColor', 'r');
text(0.2,12.4,'useless expression','FontSize',txt_fsize);

grey = [1 1 1].* 0.5;
plot(1.5+0.4-0.4,2.4,'o', 'MarkerSize', mk_size, 'Color', grey, 'MarkerFaceColor', grey);
text(1.6+0.4-0.4,2.4,'Basan et al. (2015)','FontSize',txt_fsize);
plot(1.5+0.4-0.4,1.6,'s', 'MarkerSize', mk_size, 'Color', grey, 'MarkerFaceColor', grey);
text(1.6+0.4-0.4,1.6,'Si et al. (2017)','FontSize',txt_fsize);
plot(1.5+0.4-0.4,0.8,'^', 'MarkerSize', mk_size, 'Color', grey, 'MarkerFaceColor', grey);
text(1.6+0.4-0.4,0.8,'Taheri-Araghi et al. (2015)','FontSize',txt_fsize);

set(gcf,'Color','w','Position',[0 0 600 500].*1.3);
saveas(gcf,[output_folder '/res6_data_size_vs_growth_rate.pdf']);
close;

%% make the prediction size vs growth plot with solid line
figure; lw = 3.5;
nutrients = readtable('../results-data/res11_ss-high-delta-model-across-conds/nutrient.csv');
plot(nutrients.growth_rate_per_hr, nutrients.cell_size, 'g', 'LineWidth', lw); hold on;
for i_cm=1:6
    cms = readtable(['../results-data/res11_ss-high-delta-model-across-conds/cm_' num2str(i_cm) '.csv']);
    plot(cms.growth_rate_per_hr, cms.cell_size, 'b', 'LineWidth', lw); hold on;
end
for i_useless=1:2
    uselesss = readtable(['../results-data/res11_ss-high-delta-model-across-conds/useless_' num2str(i_useless) '.csv']);
    plot(uselesss.growth_rate_per_hr, uselesss.cell_size, 'r', 'LineWidth', lw); hold on;
end

plot([0.1 0.5],[14 14]+0.4,'g', 'MarkerSize', mk_size, 'MarkerFaceColor', 'g', 'LineWidth', lw);
text(0.55,14+0.4,'nutrient','FontSize',txt_fsize);

plot([0.1 0.5],[13.2 13.2]+0.4,'b', 'MarkerSize', mk_size, 'MarkerFaceColor', 'b', 'LineWidth', lw);
text(0.55,13.2+0.4,'chloramphenicol','FontSize',txt_fsize);

plot([0.1 0.5],[12.4 12.4]+0.4,'r', 'MarkerSize', mk_size, 'MarkerFaceColor', 'r', 'LineWidth', lw);
text(0.55,12.4+0.4,'useless expression','FontSize',txt_fsize);

% plot(0.1,13.2,'bo', 'MarkerSize', mk_size, 'MarkerFaceColor', 'b');
% plot(0.22,13.2,'bs', 'MarkerSize', mk_size, 'MarkerFaceColor', 'b');
% text(0.34,13.2,'chloramphenicol','FontSize',txt_fsize);
% plot(0.1,12.4,'ro', 'MarkerSize', mk_size, 'MarkerFaceColor', 'r');
% text(0.2,12.4,'useless expression','FontSize',txt_fsize);

xlabel('Growth rate (hr^{-1})');
ylabel('Size');
ylim([0 15]); xlim([0 3]);
set(gca,'FontSize',30,'LineWidth',2.5);
set(gcf,'Color','w','Position',[0 0 600 500].*1.3);
title('Prediction');
saveas(gcf,[output_folder '/res6_model_size_vs_growth_rate.pdf']);
close;