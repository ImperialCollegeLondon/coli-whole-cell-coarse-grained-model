addpath('../model-code/stochastic-dynamics/');

output_folder = '../results-data/mod1_3_stoch_sim/';
if ~exist(output_folder, 'dir')
    mkdir(output_folder);
end

path2bin = '..\model-code\stochastic-dynamics\cpp-simulator-cm-rates\bin\Debug\cpp-simulator-cm-rates.exe';
path2output = '..\model-code\stochastic-dynamics\cpp-simulator-cm-rates\sim-data';

params.ri_r_rate = 0; % does not matter since no cm
params.r_ri_rate = 0;
params.f_RI = 0;
params.sigma = 1 / (7336 * 1.67 / 22) * 3600; % in hr-1. set from Dai et al max elong rate (22 aa/s), and extended ribosome AA number (7336 * 1.67)
params.k_media = 3.53;
params.delta = 10;
K = 0.11 * 0.76; % in units of extended ribosome mass fraction. from Dai et al. Km in R/P unit converted to Scott extended ribosome unit
params.a_sat = K / params.delta; 
params.f_U = 0;
params.f_X = 0.1;
params.f_Q = 0.5 - params.f_X;
params.X_div = 70;
params.destroy_X_after_div = 0;
params.X_degrad_rate = 0;


params.random_seed = 0;
params.partitioning_type = 'normal';
params.num_lineages = 1;
params.sim_duration = 10000;
params.update_period = 0.005;
params.num_updates_per_output = 1;

sim_ref = do_single_sim_cm_rates(params, path2bin, path2output);

% compute the size homeostasis statistics (added size by bin of birth size)
stats_data = cell(1,1); data = {sim_ref};
for i=1:1
    lineage_data = data{i}.lineage_data(101:end,:);
    lineage_data.alpha = log(lineage_data.V_div ./ lineage_data.V_birth) ./ lineage_data.T_div;
    stats_data{i}.mean_birth_size = mean(lineage_data.V_birth);
    stats_data{i}.CV_birth_size = std(lineage_data.V_birth)/mean(lineage_data.V_birth);
    stats_data{i}.mean_div_size = mean(lineage_data.V_div);
    stats_data{i}.CV_div_size = std(lineage_data.V_div)/mean(lineage_data.V_div);
    stats_data{i}.avg_T_div = mean(lineage_data.T_div);
    stats_data{i}.CV_T_div = std(lineage_data.T_div)/mean(lineage_data.T_div);
    stats_data{i}.avg_alpha = mean(lineage_data.alpha);
    stats_data{i}.CV_alpha = std(lineage_data.alpha)/mean(lineage_data.alpha);
    % added size per birth size
    n_bins_Vb = 15;
    [~,I_sort] = sort(lineage_data.V_birth);
    n_per_bins = floor(length(I_sort) / n_bins_Vb);
    % compute average in each bins
    stats_data{i}.avg_Vbs = zeros(n_bins_Vb, 1);
    stats_data{i}.avg_deltaVs = zeros(n_bins_Vb, 1);
    stats_data{i}.std_deltaVs = zeros(n_bins_Vb, 1);
    for i_b = 1:n_bins_Vb
        stats_data{i}.avg_Vbs(i_b) = mean(lineage_data.V_birth(I_sort((i_b-1)*n_per_bins+1:i_b*n_per_bins)));
        stats_data{i}.avg_deltaVs(i_b) = mean(lineage_data.delta_V(I_sort((i_b-1)*n_per_bins+1:i_b*n_per_bins)));
        stats_data{i}.std_deltaVs(i_b) = std(lineage_data.delta_V(I_sort((i_b-1)*n_per_bins+1:i_b*n_per_bins)));
    end
    stats_data{i}.scaled_birth_size_bin_avg = stats_data{i}.avg_Vbs ./ stats_data{i}.mean_birth_size;
    stats_data{i}.scaled_delta_size_bin_avg = stats_data{i}.avg_deltaVs ./ stats_data{i}.mean_birth_size;
end

adder_data_ref = stats_data{1};
mk_size = 12; lw = 2;
h1 = plot([0 2], [1 1], 'k', 'LineWidth', lw); hold on;
h2 = plot([2 0], [0 2], '--k', 'LineWidth', lw); hold on;
h3 = plot(adder_data_ref.scaled_birth_size_bin_avg, adder_data_ref.scaled_delta_size_bin_avg, '-o', 'MarkerFaceColor', 'w', 'Color', 'r', 'MarkerSize', mk_size, 'LineWidth', lw); hold on;
%h4 = plot(adder_data_X_degrad.scaled_birth_size_bin_avg, adder_data_X_degrad.scaled_delta_size_bin_avg, '-s', 'MarkerFaceColor', 'w', 'Color', 'b', 'MarkerSize', mk_size, 'LineWidth', lw); hold on;
% plot(adder_data_X_degrad_slow_growth.scaled_birth_size_bin_avg, adder_data_X_degrad_slow_growth.scaled_delta_size_bin_avg, '-s', 'MarkerFaceColor', 'b', 'Color', 'b', 'MarkerSize', mk_size, 'LineWidth', lw); hold on;
%legend([h1 h2 h3 h4], {'adder', 'sizer', 'model', 'with X degradation'}, 'FontSize', 15, 'LineWidth', 1.5);
ylim([0.6 1.4]); xlim([0.6 1.4]); ylabel('Scaled added size'); xlabel('Scaled birth size');
set(gca, 'LineWidth', 2, 'FontSize', 20);