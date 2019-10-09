%% load data
adder_data_ref = readtable('../results-data/res8_adder-or-sizer/ref_model.csv');
adder_data_X_degrad = readtable('../results-data/res8_adder-or-sizer/with_X_degrad_rate.csv');


%% output folder
output_folder = '../figure-assembly/components/';
if ~exist(output_folder, 'dir')
    mkdir(output_folder);
end


%%
mk_size = 12; lw = 2;
h1 = plot([0 2], [1 1], 'k', 'LineWidth', lw); hold on;
h2 = plot([2 0], [0 2], '--k', 'LineWidth', lw); hold on;
h3 = plot(adder_data_ref.scaled_birth_size_bin_avg, adder_data_ref.scaled_delta_size_bin_avg, '-o', 'MarkerFaceColor', 'w', 'Color', 'r', 'MarkerSize', mk_size, 'LineWidth', lw); hold on;
h4 = plot(adder_data_X_degrad.scaled_birth_size_bin_avg, adder_data_X_degrad.scaled_delta_size_bin_avg, '-s', 'MarkerFaceColor', 'w', 'Color', 'b', 'MarkerSize', mk_size, 'LineWidth', lw); hold on;
legend([h1 h2 h3 h4], {'adder', 'sizer', 'model', 'with X degradation'}, 'FontSize', 15, 'LineWidth', 1.5);
ylim([0.6 1.4]); xlim([0.6 1.4]); ylabel('Scaled added size'); xlabel('Scaled birth size');
set(gca, 'LineWidth', 2, 'FontSize', 20);
set(gcf,'Color','w'); %'Position',fig_size

%%
saveas(gcf,[output_folder 'res8_stoch_adder_sizer.pdf']);
close;