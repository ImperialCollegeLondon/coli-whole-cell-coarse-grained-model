%%
addpath('../utils-code/export_fig');


%% load data and predictions
exp_data = readtable('../results-data/basan-2015-si-2017-scale-normalized/nutrient_vs_cm_or_useless_modulation.csv');
exp_data_no_cm = exp_data;
exp_data_no_cm(exp_data_no_cm.cm_type > 0,:) = [];
data_best_fit = readtable('../results-data/basan-2015-si-2017-fit/best_prediction.csv');
all_predictions = cell(8,1);
all_predictions_no_cm = cell(8,1);
for i=1:8
    all_predictions{i} = readtable(['../results-data/basan-2015-si-2017-fit/all-predictions/' num2str(i) '.csv']);
    all_predictions_no_cm{i} = readtable(['../results-data/basan-2015-si-2017-fit/all-predictions_no-cm/' num2str(i) '.csv']);
end


%% make the two size vs growth rate plots (data and best prediction)
mk_size = 12;
datas = {exp_data, data_best_fit};
titles = {'Data', 'Prediction'};
for i_data=1:2
    figure;
    data = datas{i_data};
    I_cm = find(data.cm_type > 0);
    I_useless = find(data.useless_type > 0);
    I_nut = find( data.cm_type == 0 & data.useless_type == 0);
    hs(1) = plot(data.growth_rate_per_hr(I_nut), data.estimated_volume(I_nut), 'go', 'MarkerSize', mk_size, 'MarkerFaceColor', 'g'); hold on;
    hs(2) = plot(data.growth_rate_per_hr(I_cm), data.estimated_volume(I_cm), 'bs', 'MarkerSize', mk_size, 'MarkerFaceColor', 'b'); hold on;
    hs(3) = plot(data.growth_rate_per_hr(I_useless), data.estimated_volume(I_useless), 'r^', 'MarkerSize', mk_size, 'MarkerFaceColor', 'r'); hold on;
    title(titles{i_data});
    xlabel('Growth rate (hr^{-1})');
    ylabel('Size');
    ylim([0 12]); xlim([0 2]);
    set(gca,'FontSize',25,'LineWidth',2);
    grid();
    legend(hs, ...
           {'nutrient (Basan 2015 and Si 2017)', 'chloramphenicol (Basan 2015 and Si 2017)', 'useless expression (Basan 2015)'}, ...
           'FontSize',15,'LineWidth',1.5);
    set(gcf,'Color','w');
end
export_fig(figure(1),'../figure-assembly/figure-3-components/figure_3_panel_data.pdf');
export_fig(figure(2),'../figure-assembly/figure-3-components/figure_3_panel_prediction.pdf');





%% make the single sector prediction plots
figure;
mk_size = 10;
for i=1:4
    data = all_predictions_no_cm{i};
    I_cm = find(data.cm_type > 0);
    I_useless = find(data.useless_type > 0);
    I_nut = find( data.cm_type == 0 & data.useless_type == 0);
    subplot(1,4,i);
    plot(log(exp_data_no_cm.estimated_volume(I_nut)), log(data.estimated_volume(I_nut)), 'go', 'MarkerSize', mk_size, 'MarkerFaceColor', 'g'); hold on;
%     plot(log(exp_data_no_cm.estimated_volume(I_cm)), log(data.estimated_volume(I_cm)), 'bs', 'MarkerSize', mk_size, 'MarkerFaceColor', 'b'); hold on;
    plot(log(exp_data_no_cm.estimated_volume(I_useless)), log(data.estimated_volume(I_useless)), 'r^', 'MarkerSize', mk_size, 'MarkerFaceColor', 'r'); hold on;
    plot([0 2.5], [0 2.5], 'Color', [1 1 1].*0.6, 'LineWidth', 1.5);
    set(gca,'FontSize',15,'LineWidth',1.5);
    xlabel('log real size');
    if i==1; ylabel('log predicted size'); end
    ylim([0 2.5]); xlim([0 2.5]);
    title(data.formula_prediction{1},'FontSize',15);
    axis square;
    grid();
    set(gca,'XTick',0:0.5:2.5,'YTick',0:0.5:2.5);
end
set(gcf,'Position',[0 0 1660 360],'Color','w');
export_fig(gcf,'../figure-assembly/figure-3-components/figure_3_panel_single_sector.pdf');


%% make the double sector prediction plots
figure;
mk_size = 10;
for i=5:8
    data = all_predictions{i};
    I_cm = find(data.cm_type > 0);
    I_useless = find(data.useless_type > 0);
    I_nut = find( data.cm_type == 0 & data.useless_type == 0);
    subplot(1,4,i-4);
    plot(log(exp_data.estimated_volume(I_nut)), log(data.estimated_volume(I_nut)), 'go', 'MarkerSize', mk_size, 'MarkerFaceColor', 'g'); hold on;
    plot(log(exp_data.estimated_volume(I_cm)), log(data.estimated_volume(I_cm)), 'bs', 'MarkerSize', mk_size, 'MarkerFaceColor', 'b'); hold on;
    plot(log(exp_data.estimated_volume(I_useless)), log(data.estimated_volume(I_useless)), 'r^', 'MarkerSize', mk_size, 'MarkerFaceColor', 'r'); hold on;
    plot([0 2.5], [0 2.5], 'Color', [1 1 1].*0.6, 'LineWidth', 1.5);
    set(gca,'FontSize',15,'LineWidth',1.5);
    xlabel('log real size');
    if i==5; ylabel('log predicted size'); end
    ylim([0 2.5]); xlim([0 2.5]);
    title(data.formula_prediction{1},'FontSize',15);
    axis square;
    grid();
    set(gca,'XTick',0:0.5:2.5,'YTick',0:0.5:2.5);
end
set(gcf,'Position',[0 0 1660 360],'Color','w');
export_fig(gcf,'../figure-assembly/figure-3-components/figure_3_panel_two_sectors.pdf');


%%
close all; clear;
