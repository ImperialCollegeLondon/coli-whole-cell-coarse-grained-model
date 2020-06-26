

%%
output_folder = '../figure-assembly/components/';
if ~exist(output_folder, 'dir')
    mkdir(output_folder);
end

%%
%
best_pred_data = readtable('../results-data/res6_size-predictions-from-comp/fE_and_active_rib_frac_data_fX-false/predictions.csv');
best_pred_formula = fileread('../results-data/res6_size-predictions-from-comp/fE_and_active_rib_frac_data_fX-false/formula.txt');

%
fE_nut_useless_pred_data = readtable('../results-data/res6_size-predictions-from-comp/fE_data_nut_useless_fX-false/predictions.csv');
fE_nut_useless_pred_formula = fileread('../results-data/res6_size-predictions-from-comp/fE_data_nut_useless_fX-false/formula.txt');


%%
datas = {fE_nut_useless_pred_data, best_pred_data};
formulas = {fE_nut_useless_pred_formula, best_pred_formula};
fig_labels = {'res6_fE_alone_nut_useless', 'res6_fE_active_rib_frac_all'};
mk_size = 10;
for i=1:2
    figure;
    data = datas{i};
    I_cm_basan = find(data.cm_type > 0 & strcmp(data.source, 'Basan 2015'));
    I_cm_si = find(data.cm_type > 0 & data.nutrient_type > 6 & strcmp(data.source, 'Si 2017'));
    I_useless_basan = find(data.useless_type > 0 & strcmp(data.source, 'Basan 2015'));
    I_nut_basan = find(data.cm_type == 0 & data.useless_type == 0 & strcmp(data.source, 'Basan 2015'));
    I_nut_si = find(data.cm_type == 0 & data.useless_type == 0 & strcmp(data.source, 'Si 2017'));
    I_nut_taheri = find(data.cm_type == 0 & data.useless_type == 0 & strcmp(data.source, 'Taheri-Araghi 2015'));
    
    plot(log(data.real(I_nut_basan)), log(data.prediction(I_nut_basan)), 'go', 'MarkerSize', mk_size, 'MarkerFaceColor', 'g'); hold on;
    plot(log(data.real(I_nut_si)), log(data.prediction(I_nut_si)), 'gs', 'MarkerSize', mk_size, 'MarkerFaceColor', 'g'); hold on;
    plot(log(data.real(I_nut_taheri)), log(data.prediction(I_nut_taheri)), 'g^', 'MarkerSize', mk_size, 'MarkerFaceColor', 'g'); hold on;
    
    plot(log(data.real(I_useless_basan)), log(data.prediction(I_useless_basan)), 'ro', 'MarkerSize', mk_size, 'MarkerFaceColor', 'r'); hold on;
    
    plot(log(data.real(I_cm_basan)), log(data.prediction(I_cm_basan)), 'bo', 'MarkerSize', mk_size, 'MarkerFaceColor', 'b'); hold on;
    plot(log(data.real(I_cm_si)), log(data.prediction(I_cm_si)), 'bs', 'MarkerSize', mk_size, 'MarkerFaceColor', 'b'); hold on;
    
    plot([-1 3], [-1 3], 'Color', [1 1 1].*0.6, 'LineWidth', 1.5);
    set(gca,'FontSize',15,'LineWidth',1.5);
    xlabel('log measured size');
    ylabel('log predicted size');
    ylim([-0.1 3]); xlim([-0.1 3]);
    title(['$' formulas{i} '$'],'FontSize',17, 'FontWeight', 'bold', 'Interpreter', 'latex');
    axis square;
    set(gca,'XTick',0:0.5:2.5,'YTick',0:0.5:2.5);
    set(gcf,'Position',[0 0 400 400],'Color','w');
    saveas(gcf,[output_folder fig_labels{i} '.pdf']);
end

