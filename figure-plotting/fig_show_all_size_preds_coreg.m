
%%
data_type = '_nut_cm';



%%
single_sector = readtable('../results-data/resXX_coreg-model_basan-2015-si-2017-taheri-2015-fit/single-sector-size-predictions-R2-values_ref.csv','ReadRowNames',true);
two_sectors = readtable('../results-data/resXX_coreg-model_basan-2015-si-2017-taheri-2015-fit/two-sectors-size-predictions-R2-values_ref.csv','ReadRowNames',true);
three_sectors = readtable('../results-data/resXX_coreg-model_basan-2015-si-2017-taheri-2015-fit/three-sectors-size-predictions-R2-values_ref.csv','ReadRowNames',true);

%%
all_fX = [];
all_V = [];
for s={two_sectors} %, two_sectors, three_sectors}
    ss = s{1};
    t_fX = table(ss{['data' data_type '_fX-true'],:}.', 'RowNames', ss.Properties.VariableNames, 'VariableNames', {'R2'});
    all_fX = [all_fX; t_fX];
    t_V = table(ss{['data' data_type '_fX-false'],:}.', 'RowNames', ss.Properties.VariableNames, 'VariableNames', {'R2'});
    all_V = [all_V; t_V];
end
all_V = sortrows(all_V,1,'descend');
all_fX = sortrows(all_fX,1,'descend');


%%
addpath('../utils-code/export_fig');


%%
mk_size = 4;
n_rows = 3;
n_cols = 4;
figsize = [0 0 800 600];
titlesize = 6.5;
labelsize = 7;
axsize = 7;
axlw = 0.8;
n_plots_per_fig = n_rows * n_cols;

for i_V_fX = 1:2
    
    if i_V_fX == 1
        data = all_fX;
        pred_type = 'fX-true';
    else
        data = all_V;
        pred_type = 'fX-false';
    end
    
    i_plot = 1; i_panel = 1;
    for i_pred=1:height(data)
        
        pred = data(i_pred,:);
        pred_name = pred.Properties.RowNames{1};
        pred_data = readtable(['../results-data/resXX_coreg-model_basan-2015-si-2017-taheri-2015-fit/ref/' pred_name '_data' data_type '_' pred_type '/predictions.csv']);
        pred_formula = fileread(['../results-data/resXX_coreg-model_basan-2015-si-2017-taheri-2015-fit/ref/' pred_name '_data' data_type '_' pred_type '/formula.txt']);
        I_cm_basan = find(pred_data.cm_type > 0 & pred_data.nutrient_type <= 6);
        I_cm_si = find(pred_data.cm_type > 0 & pred_data.nutrient_type > 6 & pred_data.nutrient_type <= 11);
        I_useless_basan = find(pred_data.useless_type > 0 & pred_data.nutrient_type <= 6);
        I_nut_basan = find(pred_data.cm_type == 0 & pred_data.useless_type == 0 & pred_data.nutrient_type <= 6);
        I_nut_si = find(pred_data.cm_type == 0 & pred_data.useless_type == 0 & pred_data.nutrient_type > 6 & pred_data.nutrient_type <= 11);
        I_nut_taheri = find(pred_data.cm_type == 0 & pred_data.useless_type == 0 & pred_data.nutrient_type > 11);
        
        
        if i_plot > n_plots_per_fig
            set(gcf,'Position',figsize,'Color','w');
            export_fig(gcf,['../figure-assembly/sup-figure-XX-coreg-components/all-size-pred_' pred_type '_panel-' num2str(i_panel) '.pdf']);
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
        ylim([-0.1 3.5]); xlim([-0.1 3.5]);
        title([pred_formula ' (R2 = ' num2str(pred{1,'R2'}) ')'],'FontSize',titlesize);
        axis square;
        set(gca,'XTick',0:0.5:3,'YTick',0:0.5:3);
        
        i_plot = i_plot + 1;
        
        if i_pred == height(data)
            set(gcf,'Position',figsize,'Color','w');
            export_fig(gcf,['../figure-assembly/sup-figure-XX-coreg-components/' data_type '-pred_' pred_type '_panel-' num2str(i_panel) '.pdf']);
            close;
        end
        
        
    end
    
    
end

