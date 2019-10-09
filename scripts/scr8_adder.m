addpath('../model-code/stochastic-dynamics/');

output_folder = '../results-data/res8_adder-or-sizer/';
if ~exist(output_folder, 'dir')
    mkdir(output_folder);
end

path2bin = '..\model-code\stochastic-dynamics\cpp-simulator-cm-rates\bin\Debug\cpp-simulator-cm-rates.exe';
path2output = '..\model-code\stochastic-dynamics\cpp-simulator-cm-rates\sim-data';

constants = give_constants();

params.ri_r_rate = constants.cm_koff;
params.sigma = constants.sigma;
params.delta = constants.reference_delta;
params.a_sat = constants.K / params.delta; 
params.f_X = constants.reference_fX;
params.f_Q = constants.reference_fQ - params.f_X;
params.X_div = constants.reference_Xdiv;
params.destroy_X_after_div = 0;
params.X_degrad_rate = 0;

params.k_media = 3.58;
params.f_U = 0;
params.r_ri_rate = 0;

params.random_seed = 0;
params.partitioning_type = 'normal';
params.num_lineages = 1;
params.sim_duration = 50000;
params.update_period = 0.005;
params.num_updates_per_output = 1;

sim_data = do_single_sim_cm_rates(params, path2bin, path2output);
params.X_degrad_rate = 0.5;
sim_data_degrad_X = do_single_sim_cm_rates(params, path2bin, path2output);

% compute the size homeostasis statistics (added size by bin of birth size)
stats_data = cell(2,1); data = {sim_data, sim_data_degrad_X};
for i=1:2
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
    n_bins_Vb = 12;
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

%adder_data_ref = stats_data{1};
%adder_data_X_degrad = stats_data{2};


% output the results
names = {'ref_model', 'with_X_degrad_rate'};
for i=1:2
    scaled_birth_size_bin_avg = stats_data{i}.scaled_birth_size_bin_avg;
    scaled_delta_size_bin_avg = stats_data{i}.scaled_delta_size_bin_avg;
    output_table = table(scaled_birth_size_bin_avg, scaled_delta_size_bin_avg);
    writetable(output_table,[output_folder names{i} '.csv']);
end
