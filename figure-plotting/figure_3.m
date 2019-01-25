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

%% make the two size vs growth rate plots (data and best prediction)
mk_size = 12;
titles = {'Data', 'Prediction'};
fields = {'real', 'prediction'};
I_cm = find(best_pred_data.cm_type > 0);
I_useless = find(best_pred_data.useless_type > 0);
I_nut = find(best_pred_data.cm_type == 0 & best_pred_data.useless_type == 0);
for i_data=1:2
    figure;
    hs(1) = plot(best_pred_data.growth_rate_per_hr(I_nut), best_pred_data.(fields{i_data})(I_nut), 'go', 'MarkerSize', mk_size, 'MarkerFaceColor', 'g'); hold on;
    hs(2) = plot(best_pred_data.growth_rate_per_hr(I_cm), best_pred_data.(fields{i_data})(I_cm), 'bs', 'MarkerSize', mk_size, 'MarkerFaceColor', 'b'); hold on;
    hs(3) = plot(best_pred_data.growth_rate_per_hr(I_useless), best_pred_data.(fields{i_data})(I_useless), 'r^', 'MarkerSize', mk_size, 'MarkerFaceColor', 'r'); hold on;
    title(titles{i_data});
    xlabel('Growth rate (hr^{-1})');
    ylabel('Size');
    ylim([0 15]); xlim([0 3]);
    set(gca,'FontSize',30,'LineWidth',2.5);
%     grid();
    legend(hs, ...
           {'nutrient (Basan, Si and Taheri-Araghi studies)', 'chloramphenicol (Basan and Si studies)', 'useless expression (Basan study)'}, ...
           'FontSize',15,'LineWidth',1.5,'Location','NorthWest');
    set(gcf,'Color','w','Position',[0 0 600 500]);
end
export_fig(figure(1),'../figure-assembly/figure-3-components/figure_3_panel_data.pdf');
export_fig(figure(2),'../figure-assembly/figure-3-components/figure_3_panel_prediction.pdf');


%% make the prediction size vs growth plot with solid line 
figure; lw = 3.5;
nutrients = readtable('../results-data/res15_size-vs-growth-det-model/nutrient.csv');
hs(1) = plot(nutrients.growth_rate_per_hr, nutrients.cell_size, 'g', 'LineWidth', lw); hold on;
for i_cm=1:6
    cms = readtable(['../results-data/res15_size-vs-growth-det-model/cm_' num2str(i_cm) '.csv']);
    hs(2) = plot(cms.growth_rate_per_hr, cms.cell_size, 'b', 'LineWidth', lw); hold on;
end
for i_useless=1:2
    uselesss = readtable(['../results-data/res15_size-vs-growth-det-model/useless_' num2str(i_useless) '.csv']);
    hs(3) = plot(uselesss.growth_rate_per_hr, uselesss.cell_size, 'r', 'LineWidth', lw); hold on;
end
xlabel('Growth rate (hr^{-1})');
ylabel('Size');
ylim([0 15]); xlim([0 3]);
set(gca,'FontSize',30,'LineWidth',2.5);
    legend(hs, ...
           {'nutrient', 'chloramphenicol', 'useless expression'}, ...
           'FontSize',15,'LineWidth',1.5,'Location','NorthWest');
    set(gcf,'Color','w','Position',[0 0 600 500]);
title('Prediction');
export_fig(gcf,'../figure-assembly/figure-3-components/figure_3_panel_prediction_solid.pdf');


% %% display the first row (single sectors)
% datas = {r_nut_useless_pred_data, e_nut_useless_pred_data, e_pred_data};
% formulas = {r_nut_useless_pred_formula, e_nut_useless_pred_formula, e_pred_formula};
% figure;
% mk_size = 10;
% for i=1:3
%     data = datas{i};
%     subplot(1,3,i);
%     I_cm = find(data.cm_type > 0);
%     I_useless = find(data.useless_type > 0);
%     I_nut = find( data.cm_type == 0 & data.useless_type == 0);
%     plot(log(data.real(I_nut)), log(data.prediction(I_nut)), 'go', 'MarkerSize', mk_size, 'MarkerFaceColor', 'g'); hold on;
%     plot(log(data.real(I_useless)), log(data.prediction(I_useless)), 'r^', 'MarkerSize', mk_size, 'MarkerFaceColor', 'r'); hold on;
%     plot(log(data.real(I_cm)), log(data.prediction(I_cm)), 'bs', 'MarkerSize', mk_size, 'MarkerFaceColor', 'b'); hold on;
%     plot([0 2.5], [0 2.5], 'Color', [1 1 1].*0.6, 'LineWidth', 1.5);
%     set(gca,'FontSize',15,'LineWidth',1.5);
%     xlabel('log real size');
%     if i==1; ylabel('log predicted size'); end
%     ylim([0 3]); xlim([0 3]);
%     title(formulas{i},'FontSize',15);
%     axis square;
% %     grid();
%     set(gca,'XTick',0:0.5:2.5,'YTick',0:0.5:2.5);
% end
% set(gcf,'Position',[0 0 1200 400],'Color','w');
% export_fig(gcf,'../figure-assembly/figure-3-components/figure_3_panel_single_sector.pdf');
%     
% 
% 
% %% display the second row (two sectors)
% datas = {e_and_r_pred_data, e_and_ra_pred_data, best_pred_data};
% formulas = {e_and_r_pred_formula, e_and_ra_pred_formula, best_pred_formula};
% figure;
% mk_size = 10;
% for i=1:3
%     data = datas{i};
%     subplot(1,3,i);
%     I_cm = find(data.cm_type > 0);
%     I_useless = find(data.useless_type > 0);
%     I_nut = find( data.cm_type == 0 & data.useless_type == 0);
%     plot(log(data.real(I_nut)), log(data.prediction(I_nut)), 'go', 'MarkerSize', mk_size, 'MarkerFaceColor', 'g'); hold on;
%     plot(log(data.real(I_useless)), log(data.prediction(I_useless)), 'r^', 'MarkerSize', mk_size, 'MarkerFaceColor', 'r'); hold on;
%     plot(log(data.real(I_cm)), log(data.prediction(I_cm)), 'bs', 'MarkerSize', mk_size, 'MarkerFaceColor', 'b'); hold on;
%     plot([0 2.5], [0 2.5], 'Color', [1 1 1].*0.6, 'LineWidth', 1.5);
%     set(gca,'FontSize',15,'LineWidth',1.5);
%     xlabel('log real size');
%     if i==1; ylabel('log predicted size'); end
%     ylim([0 3]); xlim([0 3]);
%     title(formulas{i},'FontSize',15);
%     axis square;
% %     grid();
%     set(gca,'XTick',0:0.5:2.5,'YTick',0:0.5:2.5);
% end
% set(gcf,'Position',[0 0 1200 400],'Color','w');
% export_fig(gcf,'../figure-assembly/figure-3-components/figure_3_panel_two_sectors.pdf');


%% 
datas = {e_nut_useless_pred_data, best_pred_data};
formulas = {e_nut_useless_pred_formula, best_pred_formula};
fig_labels = {'e_alone_nut_useless', 'e_ra_over_r_all'};
mk_size = 10;
for i=1:2
    figure;
    data = datas{i};
    I_cm = find(data.cm_type > 0);
    I_useless = find(data.useless_type > 0);
    I_nut = find( data.cm_type == 0 & data.useless_type == 0);
    plot(log(data.real(I_nut)), log(data.prediction(I_nut)), 'go', 'MarkerSize', mk_size, 'MarkerFaceColor', 'g'); hold on;
    plot(log(data.real(I_useless)), log(data.prediction(I_useless)), 'r^', 'MarkerSize', mk_size, 'MarkerFaceColor', 'r'); hold on;
    plot(log(data.real(I_cm)), log(data.prediction(I_cm)), 'bs', 'MarkerSize', mk_size, 'MarkerFaceColor', 'b'); hold on;
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
plot(log(data.C_plus_D_measured(I_nut)), log(data.C_plus_D_pred(I_nut)), 'go', 'MarkerSize', mk_size, 'MarkerFaceColor', 'g'); hold on;
plot(log(data.C_plus_D_measured(I_useless)), log(data.C_plus_D_pred(I_useless)), 'r^', 'MarkerSize', mk_size, 'MarkerFaceColor', 'r'); hold on;
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
plot(data.C_plus_D_measured(I_nut), data.C_plus_D_pred(I_nut), 'go', 'MarkerSize', mk_size, 'MarkerFaceColor', 'g'); hold on;
plot(data.C_plus_D_measured(I_useless), data.C_plus_D_pred(I_useless), 'r^', 'MarkerSize', mk_size, 'MarkerFaceColor', 'r'); hold on;
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
