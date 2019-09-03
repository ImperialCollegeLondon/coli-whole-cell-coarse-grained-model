
%%%



%
pred_data = readtable('../results-data/resXX_coreg-low-delta_variants-size-pred/variants-size-pred.csv');


%
mk_size = 10;
I_cm = find(pred_data.cm_type > 0);
I_useless = find(pred_data.useless_type > 0);
I_nut = find( pred_data.cm_type == 0 & pred_data.useless_type == 0);


pred_fields = {'predicted_cell_size_V_is_fRA_fR_2_3_over_fE'};
formulas = {'V_{div} \propto fE^{-1} \times (fRA/fR)^{2/3}'};


plot(log(pred_data.cell_size(I_nut)), log(pred_data.(pred_fields{1})(I_nut)), 'go', 'MarkerSize', mk_size, 'MarkerFaceColor', 'g'); hold on;
plot(log(pred_data.cell_size(I_useless)), log(pred_data.(pred_fields{1})(I_useless)), 'r^', 'MarkerSize', mk_size, 'MarkerFaceColor', 'r'); hold on;
plot(log(pred_data.cell_size(I_cm)), log(pred_data.(pred_fields{1})(I_cm)), 'bs', 'MarkerSize', mk_size, 'MarkerFaceColor', 'b'); hold on;
plot([0 3], [0 3], 'Color', [1 1 1].*0.6, 'LineWidth', 1.5);



set(gca,'FontSize',15,'LineWidth',1.5);
xlabel('log real size');
ylabel('log predicted size');
ylim([0 3]); xlim([0 3]);
title(formulas{1},'FontSize',21);
axis square;
set(gca,'XTick',0:0.5:2.5,'YTick',0:0.5:2.5);

%
addpath('../utils-code/export_fig');
set(gcf,'Position',[0 0 1000 1000],'Color','w');
export_fig(gcf,'../figure-assembly/sup-figure-XX-coreg-low-delta-components/round-exponents.pdf');
close;
