%%
output_folder = '../figure-assembly/components/';
if ~exist(output_folder, 'dir')
    mkdir(output_folder);
end

%%
pred_scale = readtable('../results-data/res6_size-predictions-from-comp/fE_data_nut_useless_fX-false/scale_factor.csv');
pred_expo = readtable('../results-data/res6_size-predictions-from-comp/fE_data_nut_useless_fX-false/exponents.csv');
formula = fileread('../results-data/res6_size-predictions-from-comp/fE_data_nut_useless_fX-false/formula.txt');
data = readtable('../results-data/res2_compositions_coreg-high-delta-model/basan_2015_si_2017_taheri_2015_modulations.csv');
data.pred_cell_size = pred_scale.scale_factor .* data.model_fE.^pred_expo.exponent;

mk_size = 10;

I_cm_basan = find(data.cm_type > 0 & strcmp(data.source, 'Basan 2015'));
I_cm_si = find(data.cm_type > 0 & data.nutrient_type > 6 & strcmp(data.source, 'Si 2017'));
I_useless_basan = find(data.useless_type > 0 & strcmp(data.source, 'Basan 2015'));
I_nut_basan = find(data.cm_type == 0 & data.useless_type == 0 & strcmp(data.source, 'Basan 2015'));
I_nut_si = find(data.cm_type == 0 & data.useless_type == 0 & strcmp(data.source, 'Si 2017'));
I_nut_taheri = find(data.cm_type == 0 & data.useless_type == 0 & strcmp(data.source, 'Taheri-Araghi 2015'));

plot(log(data.cell_size(I_nut_basan)), log(data.pred_cell_size(I_nut_basan)), 'go', 'MarkerSize', mk_size, 'MarkerFaceColor', 'g'); hold on;
plot(log(data.cell_size(I_nut_si)), log(data.pred_cell_size(I_nut_si)), 'gs', 'MarkerSize', mk_size, 'MarkerFaceColor', 'g'); hold on;
plot(log(data.cell_size(I_nut_taheri)), log(data.pred_cell_size(I_nut_taheri)), 'g^', 'MarkerSize', mk_size, 'MarkerFaceColor', 'g'); hold on;

plot(log(data.cell_size(I_useless_basan)), log(data.pred_cell_size(I_useless_basan)), 'ro', 'MarkerSize', mk_size, 'MarkerFaceColor', 'r'); hold on;

plot(log(data.cell_size(I_cm_basan)), log(data.pred_cell_size(I_cm_basan)), 'bo', 'MarkerSize', mk_size, 'MarkerFaceColor', 'b'); hold on;
plot(log(data.cell_size(I_cm_si)), log(data.pred_cell_size(I_cm_si)), 'bs', 'MarkerSize', mk_size, 'MarkerFaceColor', 'b'); hold on;

plot([-1 3], [-1 3], 'Color', [1 1 1].*0.6, 'LineWidth', 1.5);
set(gca,'FontSize',15,'LineWidth',1.5);
xlabel('log measured size');
ylabel('log predicted size');
ylim([-0.1 3]); xlim([-0.1 3]);
title(['$' formula '$'],'FontSize',17, 'FontWeight', 'bold', 'Interpreter', 'latex');
axis square;
set(gca,'XTick',0:0.5:2.5,'YTick',0:0.5:2.5);
set(gcf,'Position',[0 0 400 400],'Color','w');
saveas(gcf,[output_folder 'res6_E_size_law_failure.pdf']);

