%% load data
n_nut = 7;
n_cm = 1;
n_useless = 2;
nutrient_mod = cell(n_nut,1);
cm_mod = cell(n_cm,1);
useless_mod = cell(n_useless,1);
for i=1:n_nut
    nutrient_mod{i} = readtable(['../results-data/res9_individuality/single-cell-stats/nutrients-' num2str(i) '.csv']);
end
for i=1:n_cm
    cm_mod{i} = readtable(['../results-data/res9_individuality/single-cell-stats/cm-' num2str(i) '.csv']);
end
for i=1:n_useless
    useless_mod{i} = readtable(['../results-data/res9_individuality/single-cell-stats/useless-' num2str(i) '.csv']);
end
det_nutrient_mod = readtable('../results-data/res10_det-model-size-across-conds/nut_mod.csv');
det_cm_mod = readtable('../results-data/res10_det-model-size-across-conds/cm_mod.csv');
det_useless_mod = readtable('../results-data/res10_det-model-size-across-conds/useless_mod.csv');

%
taheri_scaling = 950;
taheri_pop = readtable('../external-data/taheri-araghi-2015/population_across_nutrients.csv');
taheri_glycerol = readtable('../external-data/taheri-araghi-2015/single_cells_glycerol.csv');
taheri_gluc = readtable('../external-data/taheri-araghi-2015/single_cells_glucose.csv');
taheri_gluc_6aa = readtable('../external-data/taheri-araghi-2015/single_cells_glucose_6_aa.csv');
taheri_gluc_12aa = readtable('../external-data/taheri-araghi-2015/single_cells_glucose_12_aa.csv');
taheri_syn_rich = readtable('../external-data/taheri-araghi-2015/single_cells_synthetic_rich.csv');
taheri_TSB = readtable('../external-data/taheri-araghi-2015/single_cells_TSB.csv');

pfit_glycerol = polyfit(taheri_glycerol.growth_rate_per_hr, taheri_scaling * taheri_glycerol.newborn_size, 1);
pfit_gluc = polyfit(taheri_gluc.growth_rate_per_hr, taheri_scaling * taheri_gluc.newborn_size, 1);
pfit_gluc_6aa = polyfit(taheri_gluc_6aa.growth_rate_per_hr, taheri_scaling * taheri_gluc_6aa.newborn_size, 1);
pfit_gluc_12aa = polyfit(taheri_gluc_12aa.growth_rate_per_hr, taheri_scaling * taheri_gluc_12aa.newborn_size, 1);
pfit_syn_rich = polyfit(taheri_syn_rich.growth_rate_per_hr, taheri_scaling * taheri_syn_rich.newborn_size, 1);
pfit_TSB = polyfit(taheri_TSB.growth_rate_per_hr, taheri_scaling * taheri_TSB.newborn_size, 1);

slopes = [pfit_glycerol(1), pfit_gluc(1), pfit_gluc_6aa(1), pfit_gluc_12aa(1), pfit_syn_rich(1), pfit_TSB(1)];
mean_growth_rates = taheri_pop.growth_rate_per_hr([1 3 4 5 6 7]);
mean_birth_size = taheri_scaling .* taheri_pop.avg_newborn_size([1 3 4 5 6 7]);
CV_growth_rates = [0.095, 0.0605, 0.0666, 0.0561, 0.0741, 0.0795];

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

for i=1:6
    h4 = plot(mean_growth_rates(i).*(1 + CV_growth_rates(1) .* [-1, 1]), mean_birth_size(i) + slopes(i) .* mean_growth_rates(i) .* CV_growth_rates(i) .* [-1, 1], 'Color', 0.5 .* [1 1 1], 'LineWidth', lw); hold on;
end

% styling
xlim([0,2.8]);  
xlabel('Growth rate (hr^{-1})');
ylabel('Birth size');
legend([h1, h2, h3, h4], {'nutrient modulation', 'chloramphenicol modulation', 'useless expression modulation', 'Taheri-Araghi et al. (2015) nutrient modulation'}, 'FontSize', 10, 'LineWidth', 1.1, 'Location', 'NorthWest');
set(gca,'FontSize',17,'LineWidth',1.5);

%%
saveas(gcf,[output_folder 'res9_individuality.pdf']);
close;