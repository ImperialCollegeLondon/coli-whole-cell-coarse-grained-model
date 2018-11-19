
%%
addpath('../utils-code/export_fig');


%%
ref.best_pred_data = readtable('../results-data/res4_basan-2015-si-2017-taheri-2015-fit/ref/two-sectors-size-predictions/e_and_ra_over_r_data_fX-true/predictions.csv');
ref.best_pred_formula = fileread('../results-data/res4_basan-2015-si-2017-taheri-2015-fit/ref/two-sectors-size-predictions/e_and_ra_over_r_data_fX-true/formula.txt');
low_sat.best_pred_data = readtable('../results-data/res4_basan-2015-si-2017-taheri-2015-fit/low-asat/two-sectors-size-predictions/e_and_ra_over_r_data_fX-true/predictions.csv');
low_sat.best_pred_formula = fileread('../results-data/res4_basan-2015-si-2017-taheri-2015-fit/low-asat/two-sectors-size-predictions/e_and_ra_over_r_data_fX-true/formula.txt');
high_sat.best_pred_data = readtable('../results-data/res4_basan-2015-si-2017-taheri-2015-fit/high-asat/two-sectors-size-predictions/e_and_ra_over_r_data_fX-true/predictions.csv');
high_sat.best_pred_formula = fileread('../results-data/res4_basan-2015-si-2017-taheri-2015-fit/high-asat/two-sectors-size-predictions/e_and_ra_over_r_data_fX-true/formula.txt');



%%
mk_size = 10; i = 1;
for par_set={ref,low_sat,high_sat}
    data = par_set{1}.best_pred_data;
    formula = par_set{1}.best_pred_formula;
    subplot(1,3,i);
    I_cm = find(data.cm_type > 0);
    I_useless = find(data.useless_type > 0);
    I_nut = find( data.cm_type == 0 & data.useless_type == 0);
    hs(1) = plot(log(data.real(I_nut)), log(data.prediction(I_nut)), 'go', 'MarkerSize', mk_size, 'MarkerFaceColor', 'g'); hold on;
    hs(2) = plot(log(data.real(I_useless)), log(data.prediction(I_useless)), 'r^', 'MarkerSize', mk_size, 'MarkerFaceColor', 'r'); hold on;
    hs(3) = plot(log(data.real(I_cm)), log(data.prediction(I_cm)), 'bs', 'MarkerSize', mk_size, 'MarkerFaceColor', 'b'); hold on;
    plot([0 2.5], [0 2.5], 'Color', [1 1 1].*0.6, 'LineWidth', 1.5);
    set(gca,'FontSize',15,'LineWidth',1.5);
    xlabel('log real size');
    if i==1
        ylabel('log predicted size'); 
        hl = legend(hs, ...
           {'nutrient (Basan, Si and Taheri-Araghi studies)', 'chloramphenicol (Basan and Si studies)', 'useless expression (Basan study)'}, ...
           'FontSize',10,'LineWidth',1.5,'Location','NorthWest');
        set(hl,'Color','None');
    end
    ylim([0 3]); xlim([0 3]);
    title(formula,'FontSize',15);
    axis square;
    set(gca,'XTick',0:0.5:2.5,'YTick',0:0.5:2.5);
    i = i+1;
end

%%
set(gcf,'Color','w','Position',[430 160 1226 736]);
export_fig(figure(1),'../figure-assembly/sup-figure-3-components/sup_figure_3_all.pdf');
close;
