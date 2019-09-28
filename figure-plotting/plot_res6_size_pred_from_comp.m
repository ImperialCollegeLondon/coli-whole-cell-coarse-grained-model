


%%
output_folder = '../figure-assembly/components/';
if ~exist(output_folder, 'dir')
    mkdir(output_folder);
end

%%
single_sector = readtable('../results-data/res6_size-predictions-from-comp/single-sector-size-predictions-R2-values.csv','ReadRowNames',true);
two_sectors = readtable('../results-data/res6_size-predictions-from-comp/two-sectors-size-predictions-R2-values.csv','ReadRowNames',true);
three_sectors = readtable('../results-data/res6_size-predictions-from-comp/three-sectors-size-predictions-R2-values.csv','ReadRowNames',true);

%%
conditions = { {'_nut_useless', single_sector}, {'', two_sectors} };


%% styling
mk_size = 4;
n_rows = 2;
n_cols = 3;
figsize = [0 0 800 600];
titlesize = 6.5;
labelsize = 7;
axsize = 7;
axlw = 0.8;
n_plots_per_fig = n_rows * n_cols;


%% main loop
pred_type = 'fX-false';
for cond=conditions
    data_type = cond{1}{1};
    ss = cond{1}{2};
    
    % sort by R2
    R2s = table(ss{['data' data_type '_fX-false'],:}.', 'RowNames', ss.Properties.VariableNames, 'VariableNames', {'R2'});
    R2s = sortrows(R2s,1,'descend');
    
    % plotting
    i_plot = 1; i_panel = 1;
    for i_pred=1:height(R2s)
        pred = R2s(i_pred,:);
        pred_name = pred.Properties.RowNames{1};
        pred_data = readtable(['../results-data/res6_size-predictions-from-comp/' pred_name '_data' data_type '_' pred_type '/predictions.csv']);
        pred_formula = fileread(['../results-data/res6_size-predictions-from-comp/' pred_name '_data' data_type '_' pred_type '/formula.txt']);
        I_cm_basan = find(pred_data.cm_type > 0 & strcmp(pred_data.source, 'Basan 2015'));
        I_cm_si = find(pred_data.cm_type > 0 & strcmp(pred_data.source, 'Si 2017'));
        I_useless_basan = find(pred_data.useless_type > 0 & strcmp(pred_data.source, 'Basan 2015'));
        I_nut_basan = find(pred_data.cm_type == 0 & pred_data.useless_type == 0 & strcmp(pred_data.source, 'Basan 2015'));
        I_nut_si = find(pred_data.cm_type == 0 & pred_data.useless_type == 0 & strcmp(pred_data.source, 'Si 2017'));
        I_nut_taheri = find(pred_data.cm_type == 0 & pred_data.useless_type == 0 & strcmp(pred_data.source, 'Taheri-Araghi 2015'));
        
        if i_plot > n_plots_per_fig
            set(gcf,'Position',figsize,'Color','w');
            saveas(gcf,[output_folder '/res6_all-size-pred_' data_type '-pred_' pred_type '_panel-' num2str(i_panel) '.pdf']);
            close;
            i_plot = 1;
            i_panel = i_panel + 1;
        end
        
        subplot(n_rows, n_cols, i_plot);
        
        
        plot(log(pred_data.real(I_nut_basan)), log(pred_data.prediction(I_nut_basan)), 'go', 'MarkerSize', mk_size, 'MarkerFaceColor', 'g'); hold on;
        plot(log(pred_data.real(I_nut_si)), log(pred_data.prediction(I_nut_si)), 'gs', 'MarkerSize', mk_size, 'MarkerFaceColor', 'g'); hold on;
        plot(log(pred_data.real(I_nut_taheri)), log(pred_data.prediction(I_nut_taheri)), 'g^', 'MarkerSize', mk_size, 'MarkerFaceColor', 'g'); hold on;
        
        plot(log(pred_data.real(I_useless_basan)), log(pred_data.prediction(I_useless_basan)), 'ro', 'MarkerSize', mk_size, 'MarkerFaceColor', 'r'); hold on;
        
        plot(log(pred_data.real(I_cm_basan)), log(pred_data.prediction(I_cm_basan)), 'bo', 'MarkerSize', mk_size, 'MarkerFaceColor', 'b'); hold on;
        plot(log(pred_data.real(I_cm_si)), log(pred_data.prediction(I_cm_si)), 'bs', 'MarkerSize', mk_size, 'MarkerFaceColor', 'b'); hold on;
        
        plot([-1 3], [-1 3], 'Color', [1 1 1].*0.6, 'LineWidth', 1.5);
        set(gca,'FontSize',axsize,'LineWidth',axlw);
        xlabel('log measured size', 'FontSize', labelsize);
        ylabel('log predicted size', 'FontSize', labelsize);
        ylim([-0.1 3]); xlim([-0.1 3]);
        title([pred_formula ' (R2 = ' num2str(pred{1,'R2'}) ')'],'FontSize',titlesize);
        axis square;
        set(gca,'XTick',0:0.5:3,'YTick',0:0.5:3);
        
        i_plot = i_plot + 1;
        
        if i_pred == height(R2s)
            set(gcf,'Position',figsize,'Color','w');
            saveas(gcf,[output_folder '/res6_size-pred_' data_type '_panel-' num2str(i_panel) '.pdf']);
            close;
        end
        
        
    end
    
end
