
% load the data
scott_data = readtable('../external-data/scott_2010_data.csv');

% load the corresponding model data
model_data = readtable('../results-data/resXX_scott-2010-model_cell-compositions/scott_2010_modulations.csv');

% 
nutrients = sort(unique(scott_data.nutrient_type));
colors = hsv(length(nutrients)+1);

% style parameters
lw = 2;
mk_size = 15;

%%% iterate on nutrients
for i_nut=1:length(nutrients)
   
    % nut x cm panel
    figure(1);
    data = scott_data(scott_data.nutrient_type==nutrients(i_nut) & scott_data.useless_type==0, :);
    model = model_data(model_data.nutrient_type==nutrients(i_nut) & scott_data.useless_type==0, :);
    plot(data.growth_rate_per_hr, data.estim_ribosomal_fraction_scott, 'o', 'MarkerFaceColor', colors(i_nut,:), 'Color', colors(i_nut,:), 'MarkerSize', mk_size); hold on;
    plot(model.model_growth_rate, model.model_fR, 'Color', colors(i_nut,:), 'LineWidth', lw); hold on;
    
    % nut x useless panel
    figure(2);
    data = scott_data(scott_data.nutrient_type==nutrients(i_nut) & scott_data.useless_type>0, :);
    model = model_data(model_data.nutrient_type==nutrients(i_nut) & scott_data.useless_type>0, :);
    if ~isempty(data)
        plot(data.growth_rate_per_hr, data.estim_useless_fraction, 'o', 'MarkerFaceColor', colors(i_nut,:), 'Color', colors(i_nut,:), 'MarkerSize', mk_size); hold on;
        plot(model.model_growth_rate, model.model_fU, 'Color', colors(i_nut,:), 'LineWidth', lw); hold on;
    end

    
end

% styling axes
figure(1);
ylim([0 0.6]); xlim([0 2]);
ylabel('ribosomal proteome fraction'); xlabel('growth rate (hr^{-1})');
figure(2);
ylim([0 0.5]); xlim([0 2]);
ylabel('useless proteome fraction'); xlabel('growth rate (hr^{-1})');
for i=1:2
    figure(i);
    set(gca,'FontSize',25,'LineWidth',2);
    set(gcf,'Color','w','Position',[0 0 800 800]);
end

addpath('../utils-code/export_fig');

figure(1);
export_fig(gcf,'../figure-assembly/sup-figure-XX-scott-2010-model-components/panel_nut_cm.pdf');
figure(2);
export_fig(gcf,'../figure-assembly/sup-figure-XX-scott-2010-model-components/panel_useless.pdf');
close all;