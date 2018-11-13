
%%%

%% load data
matching_det_model = readtable('../results-data/res7_stoch-model-finding-rib-reactivation-rate/fixed-ri-r-rate_r-ri-rate-variation.csv');
scale_var = readtable('../results-data/res7_stoch-model-finding-rib-reactivation-rate/scale-ri-r-and-r-ri-rates-variation.csv');

%%
lw = 1.5;
mk_size = 10;

%%
subplot(2,2,1);
plot(matching_det_model.r_ri_rate, matching_det_model.real_growth_rate_per_hr, '-ro', 'MarkerSize', mk_size, 'LineWidth', lw); hold on;
plot([min(matching_det_model.r_ri_rate) max(matching_det_model.r_ri_rate)], [1 1].* matching_det_model.det_ss_growth_rate_per_hr, 'k', 'MarkerSize', mk_size, 'LineWidth', lw); hold on;
plot([1 1].* 207, [0.3 0.7], '--k', 'MarkerSize', mk_size, 'LineWidth', lw); hold on;
ylim([0.4 0.6]); xlabel('Rate of ribosome inactivation (hr^{-1})'); ylabel('Growth rate (hr^{-1})');


%%
subplot(2,2,2);
plot(matching_det_model.r_ri_rate, matching_det_model.real_ri, '-ro', 'MarkerSize', mk_size, 'LineWidth', lw); hold on;
plot([min(matching_det_model.r_ri_rate) max(matching_det_model.r_ri_rate)], [1 1].* matching_det_model.det_ss_ri, 'k', 'MarkerSize', mk_size, 'LineWidth', lw); hold on;
plot([1 1].* 207, [0 1], '--k', 'MarkerSize', mk_size, 'LineWidth', lw); hold on;
ylim([0.1 0.4]); xlabel('Rate of ribosome inactivation (hr^{-1})'); ylabel('Mean inactive ribosome conc.');



%%
subplot(2,2,3);
semilogx(scale_var.ri_r_rate, scale_var.real_growth_rate_per_hr,'-bo', 'MarkerSize', mk_size, 'LineWidth', lw); hold on;
semilogx([min(scale_var.r_ri_rate) max(scale_var.r_ri_rate)], [1 1].* matching_det_model.det_ss_growth_rate_per_hr, 'k', 'MarkerSize', mk_size, 'LineWidth', lw); hold on;
plot([1 1].* 207, [0 1], '--k', 'MarkerSize', mk_size, 'LineWidth', lw); hold on;
ylim([0.4 0.6]); xlim([min(scale_var.r_ri_rate) max(scale_var.r_ri_rate)]);
xlabel('Rate of ribosome inactivation (hr^{-1})'); ylabel('Growth rate (hr^{-1})');


%%
subplot(2,2,4);
semilogx(scale_var.ri_r_rate, scale_var.real_ri,'-bo', 'MarkerSize', mk_size, 'LineWidth', lw); hold on;
semilogx([min(scale_var.r_ri_rate) max(scale_var.r_ri_rate)], [1 1].* matching_det_model.det_ss_ri, 'k', 'MarkerSize', mk_size, 'LineWidth', lw);
ylim([0.1 0.4]); xlim([min(scale_var.r_ri_rate) max(scale_var.r_ri_rate)]); hold on;
plot([1 1].* 207, [0 1], '--k', 'MarkerSize', mk_size, 'LineWidth', lw); hold on;
xlabel('Rate of ribosome inactivation (hr^{-1})'); ylabel('Mean inactive ribosome conc.');


%%
for i=1:4
    subplot(2,2,i);
    set(gca,'FontSize',18,'LineWidth',2);
end

%%
addpath('../utils-code/export_fig');
set(gcf,'Color','w','Position', [291 213 1013 837]);
export_fig(gcf,'../figure-assembly/sup-figure-4-components/sup_figure_4_all.pdf');
close;