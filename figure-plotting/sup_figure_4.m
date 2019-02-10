
%%%


%
% two_sec_preds = readtable('../results-data/res4_basan-2015-si-2017-taheri-2015-fit/two-sectors-size-predictions-R2-values_ref.csv','ReadRowNames',true);
% two_sec_preds = two_sec_preds('data_fX-false',:);
% [~,i_best_pred] = max(two_sec_preds{:,:});
% best_pred = two_sec_preds(:,i_best_pred);
% best_pred_name = best_pred.Properties.VariableNames{1};


%
% pred_data = readtable(['../results-data/res4_basan-2015-si-2017-taheri-2015-fit/ref/two-sectors-size-predictions/' best_pred_name '_data_fX-false/predictions.csv']);
% formula = fileread(['../results-data/res4_basan-2015-si-2017-taheri-2015-fit/ref/two-sectors-size-predictions/' best_pred_name '_data_fX-false/formula.txt']);

% 
pred_data = readtable('../results-data/res16_variants-size-pred/variants-size-pred.csv');


%
mk_size = 10;
I_cm = find(pred_data.cm_type > 0);
I_useless = find(pred_data.useless_type > 0);
I_nut = find( pred_data.cm_type == 0 & pred_data.useless_type == 0);


pred_fields = {'predicted_cell_size_fX_is_e', 'predicted_cell_size_V_e_ra_r_free_exponents', 'predicted_cell_size_fX_is_e_over_ra_r_2_3', 'predicted_cell_size_V_is_ra_r_2_3_over_e'};
formulas = {'f_X \propto e', 'V_{div} \propto e^{-1.02} \times (r_a/r)^{0.66}', 'f_X \propto e \times (r_a/r)^{-2/3}', 'V_{div} \propto e^{-1} \times (r_a/r)^{2/3}'};


for i=1:4
    subplot(2,2,i);
    plot(log(pred_data.cell_size(I_nut)), log(pred_data.(pred_fields{i})(I_nut)), 'go', 'MarkerSize', mk_size, 'MarkerFaceColor', 'g'); hold on;
    plot(log(pred_data.cell_size(I_useless)), log(pred_data.(pred_fields{i})(I_useless)), 'r^', 'MarkerSize', mk_size, 'MarkerFaceColor', 'r'); hold on;
    plot(log(pred_data.cell_size(I_cm)), log(pred_data.(pred_fields{i})(I_cm)), 'bs', 'MarkerSize', mk_size, 'MarkerFaceColor', 'b'); hold on;
    plot([0 3], [0 3], 'Color', [1 1 1].*0.6, 'LineWidth', 1.5);
end


for i=1:4
    subplot(2,2,i);
    set(gca,'FontSize',15,'LineWidth',1.5);
    xlabel('log real size');
    ylabel('log predicted size');
    ylim([0 3]); xlim([0 3]);
    title(formulas{i},'FontSize',21);
    axis square;
    set(gca,'XTick',0:0.5:2.5,'YTick',0:0.5:2.5);
end

%
addpath('../utils-code/export_fig');
set(gcf,'Position',[0 0 1000 1000],'Color','w');
export_fig(gcf,'../figure-assembly/sup-figure-4-components/sup_figure_4_all.pdf');
close;
