
%%
scale_factors = readtable('../results-data/res2_basan-2015-si-2017-taheri-2015-scale-normalized/fitted_scaling_si_taheri_to_basan.csv');
basan_data = readtable('../external-data/basan_2015_data.csv');
si_data = readtable('../external-data/si_2017_data.csv');
taheri_data = readtable('../external-data/taheri-araghi_2015_data.csv');

%%
I_basan_nut_only = basan_data.cm_type==0 & basan_data.useless_type==0;
I_si_nut_only = si_data.cm_type==0 & si_data.useless_type==0;
I_taheri_nut_only = taheri_data.cm_type==0 & taheri_data.useless_type==0;

%%
lw = 3; mk_size = 20;


%%
subplot(1,2,1);
plot(basan_data.growth_rate_per_hr(I_basan_nut_only), basan_data.estim_avg_cell_volume_um3(I_basan_nut_only), 'go', 'LineWidth', lw, 'MarkerSize', mk_size); hold on;
plot(si_data.growth_rate_per_hr(I_si_nut_only), si_data.estim_vol_um3(I_si_nut_only), 'gs', 'LineWidth', lw, 'MarkerSize', mk_size); hold on;
plot(taheri_data.growth_rate_per_hr(I_taheri_nut_only), taheri_data.avg_cell_volume_um3(I_taheri_nut_only), 'g^', 'LineWidth', lw, 'MarkerSize', mk_size); hold on;

%%
subplot(1,2,2);
plot(basan_data.growth_rate_per_hr(I_basan_nut_only), basan_data.estim_avg_cell_volume_um3(I_basan_nut_only), 'go', 'LineWidth', lw, 'MarkerSize', mk_size); hold on;
plot(si_data.growth_rate_per_hr(I_si_nut_only), si_data.estim_vol_um3(I_si_nut_only) .* scale_factors.best_scaling_si_to_basan, 'gs', 'LineWidth', lw, 'MarkerSize', mk_size); hold on;
plot(taheri_data.growth_rate_per_hr(I_taheri_nut_only), taheri_data.avg_cell_volume_um3(I_taheri_nut_only) .* scale_factors.best_scaling_taheri_to_basan, 'g^', 'LineWidth', lw, 'MarkerSize', mk_size); hold on;


%% styling
for i=1:2
    subplot(1,2,i);
    set(gca,'FontSize',25,'LineWidth',2);
    ylim([0 10]);
    xlabel('Growth rate (hr^{-1})');
    ylabel('Cell size');
end
set(gcf,'Position',[0 0 1800 700],'Color','w');
