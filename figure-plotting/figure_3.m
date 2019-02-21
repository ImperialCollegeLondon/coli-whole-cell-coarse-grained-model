%%
addpath('../utils-code/export_fig');


%% load prediction data
%
best_pred_data = readtable('../results-data/res4_basan-2015-si-2017-taheri-2015-fit/ref/two-sectors-size-predictions/e_and_ra_over_r_data_fX-true/predictions.csv');
best_pred_formula = fileread('../results-data/res4_basan-2015-si-2017-taheri-2015-fit/ref/two-sectors-size-predictions/e_and_ra_over_r_data_fX-true/formula.txt');
%
r_nut_useless_pred_data = readtable('../results-data/res4_basan-2015-si-2017-taheri-2015-fit/ref/single-sector-size-predictions/r_data_nut_useless_fX-true/predictions.csv');
r_nut_useless_pred_formula = fileread('../results-data/res4_basan-2015-si-2017-taheri-2015-fit/ref/single-sector-size-predictions/r_data_nut_useless_fX-true/formula.txt');
%
e_nut_useless_pred_data = readtable('../results-data/res4_basan-2015-si-2017-taheri-2015-fit/ref/single-sector-size-predictions/e_data_nut_useless_fX-true/predictions.csv');
e_nut_useless_pred_formula = fileread('../results-data/res4_basan-2015-si-2017-taheri-2015-fit/ref/single-sector-size-predictions/e_data_nut_useless_fX-true/formula.txt');
%
e_pred_data = readtable('../results-data/res4_basan-2015-si-2017-taheri-2015-fit/ref/single-sector-size-predictions/e_data_fX-true/predictions.csv');
e_pred_formula = fileread('../results-data/res4_basan-2015-si-2017-taheri-2015-fit/ref/single-sector-size-predictions/e_data_fX-true/formula.txt');
%
e_and_r_pred_data = readtable('../results-data/res4_basan-2015-si-2017-taheri-2015-fit/ref/two-sectors-size-predictions/e_and_r_data_fX-true/predictions.csv');
e_and_r_pred_formula = fileread('../results-data/res4_basan-2015-si-2017-taheri-2015-fit/ref/two-sectors-size-predictions/e_and_r_data_fX-true/formula.txt');
%
e_and_ra_pred_data = readtable('../results-data/res4_basan-2015-si-2017-taheri-2015-fit/ref/two-sectors-size-predictions/e_and_ra_data_fX-true/predictions.csv');
e_and_ra_pred_formula = fileread('../results-data/res4_basan-2015-si-2017-taheri-2015-fit/ref/two-sectors-size-predictions/e_and_ra_data_fX-true/formula.txt');

%% make the size vs growth rate plot data
mk_size = 12;

I_cm_basan = find(best_pred_data.cm_type > 0 & best_pred_data.nutrient_type <= 6);
I_cm_si = find(best_pred_data.cm_type > 0 & best_pred_data.nutrient_type > 6 & best_pred_data.nutrient_type <= 11);

I_useless_basan = find(best_pred_data.useless_type > 0 & best_pred_data.nutrient_type <= 6);

I_nut_basan = find(best_pred_data.cm_type == 0 & best_pred_data.useless_type == 0 & best_pred_data.nutrient_type <= 6);
I_nut_si = find(best_pred_data.cm_type == 0 & best_pred_data.useless_type == 0 & best_pred_data.nutrient_type > 6 & best_pred_data.nutrient_type <= 11);
I_nut_taheri = find(best_pred_data.cm_type == 0 & best_pred_data.useless_type == 0 & best_pred_data.nutrient_type > 11);

% color code: green nutrients / red useless / blue cm
% study symbole code: basan o / si s / taheri-araghi ^


figure;

plot(best_pred_data.growth_rate_per_hr(I_nut_basan), best_pred_data.real(I_nut_basan), 'go', 'MarkerSize', mk_size, 'MarkerFaceColor', 'g'); hold on;
plot(best_pred_data.growth_rate_per_hr(I_nut_si), best_pred_data.real(I_nut_si), 'gs', 'MarkerSize', mk_size, 'MarkerFaceColor', 'g'); hold on;
plot(best_pred_data.growth_rate_per_hr(I_nut_taheri), best_pred_data.real(I_nut_taheri), 'g^', 'MarkerSize', mk_size, 'MarkerFaceColor', 'g'); hold on;
plot(best_pred_data.growth_rate_per_hr(I_cm_basan), best_pred_data.real(I_cm_basan), 'bo', 'MarkerSize', mk_size, 'MarkerFaceColor', 'b'); hold on;
plot(best_pred_data.growth_rate_per_hr(I_cm_si), best_pred_data.real(I_cm_si), 'bs', 'MarkerSize', mk_size, 'MarkerFaceColor', 'b'); hold on;
plot(best_pred_data.growth_rate_per_hr(I_useless_basan), best_pred_data.real(I_useless_basan), 'ro', 'MarkerSize', mk_size, 'MarkerFaceColor', 'r'); hold on;

title('Data');
xlabel('Growth rate (hr^{-1})');
ylabel('Size');
ylim([0 15]); xlim([0 3]);
set(gca,'FontSize',30,'LineWidth',2.5);


txt_fsize = 18;
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

set(gcf,'Color','w','Position',[0 0 600 500]);
export_fig(gcf,'../figure-assembly/figure-3-components/figure_3_panel_data.pdf');


%% make the prediction size vs growth plot with solid line
figure; lw = 3.5;
nutrients = readtable('../results-data/res15_size-vs-growth-det-model/nutrient.csv');
plot(nutrients.growth_rate_per_hr, nutrients.cell_size, 'g', 'LineWidth', lw); hold on;
for i_cm=1:6
    cms = readtable(['../results-data/res15_size-vs-growth-det-model/cm_' num2str(i_cm) '.csv']);
    plot(cms.growth_rate_per_hr, cms.cell_size, 'b', 'LineWidth', lw); hold on;
end
for i_useless=1:2
    uselesss = readtable(['../results-data/res15_size-vs-growth-det-model/useless_' num2str(i_useless) '.csv']);
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
set(gcf,'Color','w','Position',[0 0 600 500]);
title('Prediction');
export_fig(gcf,'../figure-assembly/figure-3-components/figure_3_panel_prediction_solid.pdf');



%%
datas = {e_nut_useless_pred_data, best_pred_data};
formulas = {e_nut_useless_pred_formula, best_pred_formula};
fig_labels = {'e_alone_nut_useless', 'e_ra_over_r_all'};
mk_size = 10;
for i=1:2
    figure;
    data = datas{i};
    I_cm_basan = find(data.cm_type > 0 & data.nutrient_type <= 6);
    I_cm_si = find(data.cm_type > 0 & data.nutrient_type > 6 & data.nutrient_type <= 11);
    I_useless_basan = find(data.useless_type > 0 & data.nutrient_type <= 6);
    I_nut_basan = find(data.cm_type == 0 & data.useless_type == 0 & data.nutrient_type <= 6);
    I_nut_si = find(data.cm_type == 0 & data.useless_type == 0 & data.nutrient_type > 6 & data.nutrient_type <= 11);
    I_nut_taheri = find(data.cm_type == 0 & data.useless_type == 0 & data.nutrient_type > 11);
    
    
    plot(log(data.real(I_nut_basan)), log(data.prediction(I_nut_basan)), 'go', 'MarkerSize', mk_size, 'MarkerFaceColor', 'g'); hold on;
    plot(log(data.real(I_nut_si)), log(data.prediction(I_nut_si)), 'gs', 'MarkerSize', mk_size, 'MarkerFaceColor', 'g'); hold on;
    plot(log(data.real(I_nut_taheri)), log(data.prediction(I_nut_taheri)), 'g^', 'MarkerSize', mk_size, 'MarkerFaceColor', 'g'); hold on;
    
    plot(log(data.real(I_useless_basan)), log(data.prediction(I_useless_basan)), 'ro', 'MarkerSize', mk_size, 'MarkerFaceColor', 'r'); hold on;
    
    plot(log(data.real(I_cm_basan)), log(data.prediction(I_cm_basan)), 'bo', 'MarkerSize', mk_size, 'MarkerFaceColor', 'b'); hold on;
    plot(log(data.real(I_cm_si)), log(data.prediction(I_cm_si)), 'bs', 'MarkerSize', mk_size, 'MarkerFaceColor', 'b'); hold on;
    
    plot([-1 3], [-1 3], 'Color', [1 1 1].*0.6, 'LineWidth', 1.5);
    set(gca,'FontSize',15,'LineWidth',1.5);
    xlabel('log measured size');
    ylabel('log predicted size');
    ylim([-0.1 3]); xlim([-0.1 3]);
    title(formulas{i},'FontSize',15);
    axis square;
    set(gca,'XTick',0:0.5:2.5,'YTick',0:0.5:2.5);
    set(gcf,'Position',[0 0 400 400],'Color','w');
    export_fig(gcf,['../figure-assembly/figure-3-components/figure_3_' fig_labels{i} '.pdf']);
end

%%
data = readtable('../results-data/res14_study-C-plus-D/C_plus_D_predictions.csv');
figure;
I_cm = find(data.cm_type > 0);
I_useless = find(data.useless_type > 0);
I_nut = find( data.cm_type == 0 & data.useless_type == 0);
plot(log(data.C_plus_D_measured(I_nut)), log(data.C_plus_D_pred(I_nut)), 'gs', 'MarkerSize', mk_size, 'MarkerFaceColor', 'g'); hold on;
plot(log(data.C_plus_D_measured(I_useless)), log(data.C_plus_D_pred(I_useless)), 'rs', 'MarkerSize', mk_size, 'MarkerFaceColor', 'r'); hold on;
plot(log(data.C_plus_D_measured(I_cm)), log(data.C_plus_D_pred(I_cm)), 'bs', 'MarkerSize', mk_size, 'MarkerFaceColor', 'b'); hold on;
plot([-2 3], [-2 3], 'Color', [1 1 1].*0.6, 'LineWidth', 1.5);
set(gca,'FontSize',15,'LineWidth',1.5);
xlabel('log measured C+D duration');
ylabel('log predicted C+D duration');
ylim([-0.1 3]); xlim([-0.1 3]);
axis square;
set(gca,'XTick',0:0.5:2.5,'YTick',0:0.5:2.5);
set(gcf,'Position',[0 0 400 400],'Color','w');
export_fig(gcf,'../figure-assembly/figure-3-components/figure_3_C_plus_D_pred.pdf');

%%
data = readtable('../results-data/res14_study-C-plus-D/C_plus_D_predictions.csv');
figure;
I_cm = find(data.cm_type > 0);
I_useless = find(data.useless_type > 0);
I_nut = find( data.cm_type == 0 & data.useless_type == 0);
plot(data.C_plus_D_measured(I_nut), data.C_plus_D_pred(I_nut), 'gs', 'MarkerSize', mk_size, 'MarkerFaceColor', 'g'); hold on;
plot(data.C_plus_D_measured(I_useless), data.C_plus_D_pred(I_useless), 'rs', 'MarkerSize', mk_size, 'MarkerFaceColor', 'r'); hold on;
plot(data.C_plus_D_measured(I_cm), data.C_plus_D_pred(I_cm), 'bs', 'MarkerSize', mk_size, 'MarkerFaceColor', 'b'); hold on;
plot([-2 15], [-2 15], 'Color', [1 1 1].*0.6, 'LineWidth', 1.5);
set(gca,'FontSize',15,'LineWidth',1.5);
xlabel('measured C+D duration (hrs)');
ylabel('predicted C+D duration (hrs)');
ylim([0 15]); xlim([0 15]);
axis square;
set(gca,'XTick',0:2:15,'YTick',0:2:15);
set(gcf,'Position',[0 0 400 400],'Color','w');
export_fig(gcf,'../figure-assembly/figure-3-components/figure_3_C_plus_D_pred_nolog.pdf');

%%
close all; clear;
