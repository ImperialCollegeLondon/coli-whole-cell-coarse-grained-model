
%
both_preds = readtable('../results-data/res5_study-optimality/optimality_vs_coreg.csv');

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
plot(both_preds.det_growth_rate(I_nut), both_preds.optimality_ratio(I_nut), 'g+', 'MarkerSize', mk_size, 'LineWidth', lw); hold on;
plot(both_preds.det_growth_rate(I_useless), both_preds.optimality_ratio(I_useless), 'r+', 'MarkerSize', mk_size, 'LineWidth', lw); hold on;
plot(both_preds.det_growth_rate(I_cm), both_preds.optimality_ratio(I_cm), 'b+', 'MarkerSize', mk_size, 'LineWidth', lw); hold on;
plot([0 2.5],[1 1], 'k', 'LineWidth', lw);
xlabel('growth rate of exact regulation model (hr^{-1})');
ylabel('ratio to optimal growth rate');
ylim([0 1.2]);

set(gca,'FontSize',ax_font_size,'LineWidth',ax_lw);
set(gcf,'Color','w','Position',fig_size);

saveas(gcf,[output_folder 'res5_optimality_study.pdf']);
close;