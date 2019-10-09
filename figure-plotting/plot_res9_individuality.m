%% load data
nutrient_mod = cell(5,1);
cm_mod = cell(1,1);
useless_mod = cell(3,1);
for i=1:5
    nutrient_mod{i} = readtable(['../results-data/res9_individuality/single-cell-stats/nutrients-' num2str(i) '.csv']);
end
for i=1:1
    cm_mod{i} = readtable(['../results-data/res9_individuality/single-cell-stats/cm-' num2str(i) '.csv']);
end
for i=1:3
    useless_mod{i} = readtable(['../results-data/res9_individuality/single-cell-stats/useless-' num2str(i) '.csv']);
end
det_nutrient_mod = readtable('../results-data/res10_det-model-size-across-conds/nut_mod.csv');
det_cm_mod = readtable('../results-data/res10_det-model-size-across-conds/cm_mod.csv');
det_useless_mod = readtable('../results-data/res10_det-model-size-across-conds/useless_mod.csv');


%% output folder
output_folder = '../figure-assembly/components/';
if ~exist(output_folder, 'dir')
    mkdir(output_folder);
end


%% plotting
% the deterministic curves
h1 = plot(det_nutrient_mod.growth_rate,det_nutrient_mod.birth_size,'g','LineWidth',1.5); hold on;
h2 = plot(det_cm_mod.growth_rate,det_cm_mod.birth_size,'b','LineWidth',1.5); hold on;
h3 = plot(det_useless_mod.growth_rate,det_useless_mod.birth_size,'r','LineWidth',1.5); hold on;
% the stochastic data
mk_size = 5; lw = 1;
for i_nut=1:length(nutrient_mod)
    plot(nutrient_mod{i_nut}.growth_rate_bin_avg  , ...
        nutrient_mod{i_nut}.birth_size_bin_avg, ...
        'v', 'MarkerFaceColor', 'None', 'Color', 'g', ...
        'MarkerSize', mk_size, 'LineWidth', lw); hold on;
end
% cm
for i_cm=1:length(cm_mod)
    plot(cm_mod{i_cm}.growth_rate_bin_avg, ...
        cm_mod{i_cm}.birth_size_bin_avg, ...
        'v', 'MarkerFaceColor', 'None', 'Color', 'b', ...
        'MarkerSize', mk_size, 'LineWidth', lw); hold on;
end
% useless
for i_useless=1:length(useless_mod)
    plot(useless_mod{i_useless}.growth_rate_bin_avg, ...
        useless_mod{i_useless}.birth_size_bin_avg, ...
        'v', 'MarkerFaceColor', 'None', 'Color', 'r', ...
        'MarkerSize', mk_size, 'LineWidth', lw); hold on;
end
% styling
xlabel('Growth rate (hr^{-1})');
ylabel('Birth size');
legend([h1, h2, h3], {'nutrient modulation', 'chloramphenicol modulation', 'useless expression modulation'}, 'FontSize', 10, 'LineWidth', 1.2, 'Location', 'NorthWest');
set(gca,'FontSize',17,'LineWidth',1.5);

%%
saveas(gcf,[output_folder 'res9_individuality.pdf']);
close;