

%%
scale_factors = readtable('../results-data/res1_size-normalization/fitted_scaling_si_taheri_to_basan.csv');
basan_data = readtable('../external-data/basan_2015_data.csv');
si_data = readtable('../external-data/si_2017_data.csv');
taheri_data = readtable('../external-data/taheri-araghi_2015_data.csv');

%% output folder
output_folder = '../figure-assembly/components/';
if ~exist(output_folder, 'dir')
    mkdir(output_folder);
end

%%
I_basan_nut_only = basan_data.cm_type==0 & basan_data.useless_type==0;
I_si_nut_only = si_data.cm_type==0 & si_data.useless_type==0;
I_taheri_nut_only = taheri_data.cm_type==0 & taheri_data.useless_type==0;

%%
lw = 1; mk_size = 10;
colors = jet(20);

%%
subplot(1,2,1);
plot(basan_data.growth_rate_per_hr(I_basan_nut_only), basan_data.source_cell_volume_um3(I_basan_nut_only), 'o', 'Color', 'k', 'MarkerFaceColor', colors(6,:), 'LineWidth', lw, 'MarkerSize', mk_size); hold on;
plot(si_data.growth_rate_per_hr(I_si_nut_only), si_data.source_cell_volume_um3(I_si_nut_only), 's', 'Color', 'k', 'MarkerFaceColor', colors(9,:), 'LineWidth', lw, 'MarkerSize', mk_size); hold on;
plot(taheri_data.growth_rate_per_hr(I_taheri_nut_only), taheri_data.avg_cell_volume_um3(I_taheri_nut_only), '^', 'Color', 'k', 'MarkerFaceColor', colors(12,:), 'LineWidth', lw, 'MarkerSize', mk_size); hold on;

%%
subplot(1,2,2);
plot(basan_data.growth_rate_per_hr(I_basan_nut_only), basan_data.source_cell_volume_um3(I_basan_nut_only), 'o', 'Color', 'k', 'MarkerFaceColor', colors(6,:), 'LineWidth', lw, 'MarkerSize', mk_size); hold on;
plot(si_data.growth_rate_per_hr(I_si_nut_only), si_data.source_cell_volume_um3(I_si_nut_only) .* scale_factors.best_scaling_si_to_basan, 's', 'Color', 'k', 'MarkerFaceColor', colors(9,:), 'LineWidth', lw, 'MarkerSize', mk_size); hold on;
plot(taheri_data.growth_rate_per_hr(I_taheri_nut_only), taheri_data.avg_cell_volume_um3(I_taheri_nut_only) .* scale_factors.best_scaling_taheri_to_basan, '^', 'Color', 'k', 'MarkerFaceColor', colors(12,:), 'LineWidth', lw, 'MarkerSize', mk_size); hold on;


%% styling
for i=1:2
    subplot(1,2,i);
    set(gca,'FontSize',15,'LineWidth',1);
    xlabel('Growth rate (hr^{-1})');
    ylabel('Average cell volume');
    legend({'Basan et al. 2015', 'Si et al. 2017', 'Taheri-Araghi et al. 2015'},'Location','NorthWest','FontSize', 8);
end
subplot(1,2,1); ylim([0 10]); title('Original data');
subplot(1,2,2); ylim([0 14]); title('After scale normalization');
set(gcf,'Position',[0 0 800 300].*1.5,'Color','w');


%% write figure
saveas(gcf,[output_folder '/res1_size_norm.pdf']);
close all;