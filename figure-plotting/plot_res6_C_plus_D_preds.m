
%%
output_folder = '../figure-assembly/components/';
if ~exist(output_folder, 'dir')
    mkdir(output_folder);
end

%%
mk_size = 10;
data = readtable('../results-data/res12_C-plus-D/C_plus_D_predictions.csv');
figure;
I_cm = find(data.cm_type > 0);
I_useless = find(data.useless_type > 0);
I_nut = find( data.cm_type == 0 & data.useless_type == 0);
plot(log(data.C_plus_D_measured(I_nut)), log(data.C_plus_D_pred(I_nut)), 'gs', 'MarkerSize', mk_size, 'MarkerFaceColor', 'g'); hold on;
plot(log(data.C_plus_D_measured(I_useless)), log(data.C_plus_D_pred(I_useless)), 'rs', 'MarkerSize', mk_size, 'MarkerFaceColor', 'r'); hold on;
plot(log(data.C_plus_D_measured(I_cm)), log(data.C_plus_D_pred(I_cm)), 'bs', 'MarkerSize', mk_size, 'MarkerFaceColor', 'b'); hold on;
plot([-2 3], [-2 3], 'Color', [1 1 1].*0.6, 'LineWidth', 1.5);
set(gca,'FontSize',15,'LineWidth',1.5);
xlabel('log measured C+D duration');
ylabel('log predicted C+D duration');
ylim([-0.1 3]); xlim([-0.1 3]);
axis square;
set(gca,'XTick',0:0.5:2.5,'YTick',0:0.5:2.5);
set(gcf,'Position',[0 0 400 400],'Color','w');
saveas(gcf,[output_folder '/res6_C_plus_D_pred.pdf']);
