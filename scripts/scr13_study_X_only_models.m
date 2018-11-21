
addpath('../model-code/other-models/X-only-model');


path2cpp = '../model-code/other-models/X-only-model/cpp-simulator/build/simulator';
path2output = '../model-code/other-models/X-only-model/cpp-sim-data';


%%%% what to study ?

%%% basic model: X prod scale with size, size grow exponentially
% no growth rate noise, no size splitting noise
% same with different growth rate
% growth rate noise, no size splitting noise
% no growth rate noise, size splitting noise
% both noise

%%% other variants
% linear growth 
% size independent production term
% X degradation

model_names = {'basic', 'size_split_noise', 'size_split_noise_destroy_X', 'partial_size_independent_X_synthesis', 'X_degradation'};
model_pars = cell(size(model_names));

% simulation pars
pars.random_seed = 1;
pars.num_lineages = 1;
pars.sim_duration = 2000;
pars.update_period = 0.005;
pars.num_updates_per_output = 1;

% common / default pars
pars.GE_model = 'only_protein';
pars.P_div_threshold = 90;
pars.P_after_div = 90;
pars.partitioning_type = 'normal';
pars.mu_media = 1.0;
pars.rp = 0;

% basic model
basic_pars = pars;
basic_pars.kp_0 = 0;
basic_pars.kp_per_size = 30;
basic_pars.size_splitting_error = 0;
basic_pars.linear_growth = 0;
model_pars{1} = basic_pars;

% basic model with size splitting error
size_split_pars = basic_pars;
size_split_pars.size_splitting_error = 0.1;
model_pars{2} = size_split_pars;

% basic model with size splitting error and destroying X after div
size_split_destroy_X_pars = size_split_pars;
size_split_destroy_X_pars.P_after_div = 0;
size_split_destroy_X_pars.kp_per_size = 2 * basic_pars.kp_per_size; % so that same size
model_pars{3} = size_split_destroy_X_pars;

% basic model with size independent X production
size_ind_X_prod_pars = basic_pars;
size_ind_X_prod_pars.kp_0 = 5;
model_pars{4} = size_ind_X_prod_pars;

% basic model with X degradation 
X_degrad_pars = basic_pars;
X_degrad_pars.rp = 0.5;
model_pars{5} = X_degrad_pars;


% iterate on model variants, simulate, compute stats
sim_data_models = cell(size(model_pars));
stats_models = cell(size(model_pars));
for i=1:length(model_pars)
    % get pars, do sim
    pars = model_pars{i};
    sim_data_models{i} = do_single_sim_X_only(pars, path2cpp, path2output);
    % compute size homeostasis statistics
    lineage_data = sim_data_models{i}.lineage_data(101:end,:);
    lineage_data.alpha = log(lineage_data.V_div ./ lineage_data.V_birth) ./ lineage_data.T_div;
    stats_models{i}.mean_birth_size = mean(lineage_data.V_birth);
    stats_models{i}.mean_birth_size
    stats_models{i}.CV_birth_size = std(lineage_data.V_birth)/mean(lineage_data.V_birth);
    stats_models{i}.mean_div_size = mean(lineage_data.V_div);
    stats_models{i}.CV_div_size = std(lineage_data.V_div)/mean(lineage_data.V_div);
    stats_models{i}.avg_T_div = mean(lineage_data.T_div);
    stats_models{i}.CV_T_div = std(lineage_data.T_div)/mean(lineage_data.T_div);
    stats_models{i}.avg_alpha = mean(lineage_data.alpha);
    stats_models{i}.CV_alpha = std(lineage_data.alpha)/mean(lineage_data.alpha);
    % added size per birth size
    n_bins_Vb = 15;
    [~,I_sort] = sort(lineage_data.V_birth);
    n_per_bins = floor(length(I_sort) / n_bins_Vb);
    % compute average in each bins
    stats_models{i}.avg_Vbs = zeros(n_bins_Vb, 1);
    stats_models{i}.avg_deltaVs = zeros(n_bins_Vb, 1);
    stats_models{i}.std_deltaVs = zeros(n_bins_Vb, 1);
    for i_b = 1:n_bins_Vb
        stats_models{i}.avg_Vbs(i_b) = mean(lineage_data.V_birth(I_sort((i_b-1)*n_per_bins+1:i_b*n_per_bins)));
        stats_models{i}.avg_deltaVs(i_b) = mean(lineage_data.delta_V(I_sort((i_b-1)*n_per_bins+1:i_b*n_per_bins)));
        stats_models{i}.std_deltaVs(i_b) = std(lineage_data.delta_V(I_sort((i_b-1)*n_per_bins+1:i_b*n_per_bins)));
    end
    stats_models{i}.scaled_birth_size_bin_avg = stats_models{i}.avg_Vbs ./ stats_models{i}.mean_birth_size;
    stats_models{i}.scaled_delta_size_bin_avg = stats_models{i}.avg_deltaVs ./ stats_models{i}.mean_birth_size;
end

% output the results
for i=1:length(model_pars)
    scaled_birth_size_bin_avg = stats_models{i}.scaled_birth_size_bin_avg;
    scaled_delta_size_bin_avg = stats_models{i}.scaled_delta_size_bin_avg;
    output_table = table(scaled_birth_size_bin_avg, scaled_delta_size_bin_avg);
    writetable(output_table,['../results-data/res13_X-only-models-size-homeostasis/' model_names{i} '.csv']);
end




