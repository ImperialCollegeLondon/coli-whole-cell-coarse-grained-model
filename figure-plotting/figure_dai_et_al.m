

% load the corresponding model data
model_data = readtable('../results-data/res3_cell-compositions/scott_2010_modulations.csv');

% 
nutrients = sort(unique(model_data.nutrient_type));
colors = hsv(length(nutrients)+1);

% style parameters
lw = 3;
mk_size = 20;

%%% iterate on nutrients
for i_nut=1:length(nutrients)
    % nut x cm panel
    model = model_data(model_data.nutrient_type==nutrients(i_nut) & model_data.useless_type==0, :);
    plot(model.model_growth_rate, model.model_ra_over_r, 'Color', colors(i_nut,:), 'LineWidth', lw); hold on;
end

% styling axes
ylim([0 1]); xlim([0 2]);
ylabel('Active ribosome fraction'); xlabel('growth rate (hr^{-1})');
for i=1:1
    figure(i);
    set(gca,'FontSize',35,'LineWidth',2.5);
    set(gcf,'Color','w','Position',[0 0 1200 800]);
end

addpath('../utils-code/export_fig');

export_fig(gcf,'../figure-assembly/figure-dai-components/figure_dai_acitve_ribosome_fraction.pdf');
