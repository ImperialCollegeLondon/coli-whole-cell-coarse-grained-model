
%
both_preds = readtable('../results-data/res4_compare-ss-high-delta-approx-with-dyn-model/comparison_ss_high_delta_approx_vs_det_model.csv');

%
output_folder = '../figure-assembly/components/';
if ~exist(output_folder, 'dir')
    mkdir(output_folder);
end

%
lw = 2; mk_size = 10;
fig_size = [0 0 800 400];
ax_font_size = 10;
ax_lw = 1.5;

%
I_nut = both_preds.cm_type == 0 & both_preds.useless_type == 0;
I_useless = both_preds.cm_type == 0 & both_preds.useless_type > 0;
I_cm = both_preds.cm_type > 0 & both_preds.useless_type == 0;



%
subplot(1,2,1);
plot(both_preds.model_growth_rate(I_nut), both_preds.det_growth_rate(I_nut), 'g+', 'MarkerSize', mk_size, 'LineWidth', lw); hold on;
plot(both_preds.model_growth_rate(I_useless), both_preds.det_growth_rate(I_useless), 'r+', 'MarkerSize', mk_size, 'LineWidth', lw); hold on;
plot(both_preds.model_growth_rate(I_cm), both_preds.det_growth_rate(I_cm), 'b+', 'MarkerSize', mk_size, 'LineWidth', lw); hold on;
plot([0 2.5],[0 2.5], 'k', 'LineWidth', lw);
xlabel('growth rate - low {\ita} steady-state approx.');
ylabel('growth rate - no approximation (\delta = 10)');

subplot(1,2,2);
plot(both_preds.model_fR(I_nut), both_preds.det_fR(I_nut), 'g+', 'MarkerSize', mk_size, 'LineWidth', lw); hold on;
plot(both_preds.model_fR(I_useless), both_preds.det_fR(I_useless), 'r+', 'MarkerSize', mk_size, 'LineWidth', lw); hold on;
plot(both_preds.model_fR(I_cm), both_preds.det_fR(I_cm), 'b+', 'MarkerSize', mk_size, 'LineWidth', lw); hold on;
plot([0 0.5],[0 0.5], 'k', 'LineWidth', lw);
xlabel('ribosomal proteome fraction - low {\ita} steady-state approx.');
ylabel('ribosomal proteome fraction - no approximation (\delta = 10)');

%
for i=1:2
    subplot(1,2,i);
    set(gca,'FontSize',ax_font_size,'LineWidth',ax_lw);
end
set(gcf,'Color','w','Position',fig_size);

saveas(gcf,[output_folder 'res4_det_vs_ss_low_a_approx.pdf']);
close;