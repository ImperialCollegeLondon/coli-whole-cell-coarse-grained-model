

% load the corresponding model data
model_data = readtable('../results-data/res3_cell-compositions/scott_2010_modulations.csv');

% 
nutrients = sort(unique(model_data.nutrient_type));
colors = hsv(length(nutrients)+1);

% style parameters
lw = 3;
mk_size = 20;

%%%
subplot(1,2,1);
%%% iterate on nutrients
for i_nut=1:length(nutrients)
    % nut x cm panel
    model = model_data(model_data.nutrient_type==nutrients(i_nut) & model_data.useless_type==0, :);
    plot(model.model_growth_rate, model.model_ra_over_r, '-o', 'Color', colors(i_nut,:), 'LineWidth', lw); hold on;
end
% arrange
ylim([0 1]); xlim([0 2]);
ylabel('Active ribosome fraction'); xlabel('growth rate (hr^{-1})');

%%%
subplot(1,2,2);
%%% iterate on nutrients
for i_nut=1:length(nutrients)
    % nut x cm panel
    model = model_data(model_data.nutrient_type==nutrients(i_nut) & model_data.useless_type==0, :);
    plot(model.model_growth_rate, model.model_ri ./ (1-model.model_a), '-o', 'Color', colors(i_nut,:), 'LineWidth', lw); hold on;
end
% arrange
ylim([0 0.7]); xlim([0 2]);
ylabel('Proteome fraction of inactive ribosomes'); xlabel('growth rate (hr^{-1})');



% for both panels
for i=1:2
    subplot(1,2,i);
    set(gca,'FontSize',20,'LineWidth',2);
end
set(gcf,'Color','w','Position',[0 0 1000 500]);

addpath('../utils-code/export_fig');
% 
export_fig(gcf,'../figure-assembly/figure-dai-components/figure_dai_their_3a_and_3b.pdf');
