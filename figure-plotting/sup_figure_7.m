

%%
model_names = {'basic', 'size_split_noise', 'size_split_noise_destroy_X', 'partial_size_independent_X_synthesis', 'X_degradation'};
model_stats = cell(size(model_names));
for i=1:length(model_stats)
    model_stats{i} = readtable(['../results-data/res13_X-only-models-size-homeostasis/' model_names{i} '.csv']);
end


%%
mk_size = 13; lw = 3;
colors = jet(20);
colors = colors([3 6 9 12 15],:);
symbols = {'-o','-s','-v','-^','-d'};
hs(1) = plot([0 2], [1 1], 'k', 'LineWidth', lw); hold on;
hs(2) = plot([2 0], [0 2], '--k', 'LineWidth', lw); hold on;
for i=1:length(model_stats)
    hs(i+2) = plot(model_stats{i}.scaled_birth_size_bin_avg, model_stats{i}.scaled_delta_size_bin_avg, symbols{i}, 'Color', colors(i,:), 'MarkerFaceColor', 'w', 'MarkerSize', mk_size, 'LineWidth', lw); hold on;
end

%%
legend(hs,{'perfect adder','perfect sizer','basic model','with size splitting noise', 'with size splitting noise and X destruction', 'partial size independent X synthesis', 'X degradation'});
ylim([0.6 1.4]); xlim([0.6 1.4]); ylabel('Scaled added size'); xlabel('Scaled birth size');
set(gca, 'LineWidth', 2.5, 'FontSize', 20);
set(gcf,'Position',[369 337 1006 641],'Color','w');


%%
addpath('../utils-code/export_fig');
export_fig(gcf,'../figure-assembly/sup-figure-7-components/sup_figure_7_all.pdf');
close;
