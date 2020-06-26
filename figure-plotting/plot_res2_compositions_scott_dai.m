

%% load data
all_comp_folder = '../results-data/res2_compositions_coreg-high-delta-model/';
scott_data = readtable([all_comp_folder 'scott_2010_modulations.csv']);
dai_data = readtable([all_comp_folder 'dai_2016_modulations.csv']);
data = [scott_data; dai_data];

%% output folder
output_folder = '../figure-assembly/components/';
if ~exist(output_folder, 'dir')
    mkdir(output_folder);
end

%% style parameters
lw = 2;
mk_size = 15;
fig_size = [0 0 800 800];
ax_font_size = 25;
ax_lw = 2;

%% plotting per se
data_nut_only = data(data.useless_type==0 & data.cm_type==0,:);
data_nut_only = sortrows(data_nut_only, 'growth_rate_per_hr');
nutrients = data_nut_only.nutrient_type;
colors = hsv(length(nutrients)+1);

%%% iterate on nutrients
for i_nut=1:length(nutrients)
   
    % nut x cm panel
    figure(1);
    data_this = data(data.nutrient_type==nutrients(i_nut) & data.useless_type==0, :);
    symb = 'o';
    if strcmp(data_this.source,'Dai 2016')
        symb = 's';
    end
    plot(data_this.growth_rate_per_hr, data_this.estim_ribosomal_fraction_scott, symb, 'MarkerFaceColor', colors(i_nut,:), 'Color', colors(i_nut,:), 'MarkerSize', mk_size); hold on;
    plot(data_this.model_growth_rate, data_this.model_fR, 'Color', colors(i_nut,:), 'LineWidth', lw); hold on;
    
    % nut x useless panel
    figure(2);
    data_this = data(data.nutrient_type==nutrients(i_nut) & data.useless_type>0, :);
    if ~isempty(data_this)
        plot(data_this.growth_rate_per_hr, data_this.estim_useless_fraction, 'o', 'MarkerFaceColor', colors(i_nut,:), 'Color', colors(i_nut,:), 'MarkerSize', mk_size); hold on;
        plot(data_this.model_growth_rate, data_this.model_fU, 'Color', colors(i_nut,:), 'LineWidth', lw); hold on;
    end

    % nut x cm : elongation rate
    figure(3);
    data_this = data(data.nutrient_type==nutrients(i_nut) & data.useless_type==0 & strcmp(data.source,'Dai 2016'), :);
    plot(data_this.growth_rate_per_hr, data_this.translation_elong_rate_aa_s ./ 22, 's', 'MarkerFaceColor', colors(i_nut,:), 'Color', colors(i_nut,:), 'MarkerSize', mk_size); hold on;
    plot(data_this.model_growth_rate, data_this.model_fR ./ (data_this.model_fR + 0.11*0.76), 'Color', colors(i_nut,:), 'LineWidth', lw); hold on;
    
    % nut x cm : active ribosome fraction
    figure(4);
    data_this = data(data.nutrient_type==nutrients(i_nut) & data.useless_type==0 & strcmp(data.source,'Dai 2016'), :);
    plot(data_this.growth_rate_per_hr, data_this.fraction_active_rib_equivalent, 's', 'MarkerFaceColor', colors(i_nut,:), 'Color', colors(i_nut,:), 'MarkerSize', mk_size); hold on;
    plot(data_this.model_growth_rate, data_this.model_active_rib_frac, 'Color', colors(i_nut,:), 'LineWidth', lw); hold on;
    
end

% styling axes
figure(1);
ylim([0 0.6]); xlim([0 2]);
ylabel('ribosomal proteome fraction'); xlabel('growth rate (hr^{-1})');
figure(2);
ylim([0 0.5]); xlim([0 2]);
ylabel('useless proteome fraction'); xlabel('growth rate (hr^{-1})');
figure(3);
ylim([0.4 1.2]); xlim([0 2]);
ylabel('ribosome efficiency'); xlabel('growth rate (hr^{-1})');
figure(4);
ylim([0 1.2]); xlim([0 2]);
ylabel('active ribosome fraction'); xlabel('growth rate (hr^{-1})');
for i=1:4
    figure(i);
    set(gca,'FontSize',ax_font_size,'LineWidth',ax_lw);
    set(gcf,'Color','w','Position',fig_size);
end

figure(1);
saveas(gcf,[output_folder 'res2_comp_preds_panel_nut_cm.pdf']);
figure(2);
saveas(gcf,[output_folder 'res2_comp_preds_panel_useless.pdf']);
figure(3);
saveas(gcf,[output_folder 'res2_comp_preds_panel_elong_rate.pdf']);
figure(4);
saveas(gcf,[output_folder 'res2_comp_preds_panel_active_rib_frac.pdf']);
close all;
