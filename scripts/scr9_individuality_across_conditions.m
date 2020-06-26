
function scr9_individuality_across_conditions()

output_folder = '../results-data/res9_individuality/';
if ~exist(output_folder, 'dir')
    mkdir(output_folder);
end
if ~exist([output_folder '/single-cell-stats/'], 'dir')
    mkdir([output_folder '/single-cell-stats/']);
end

if ~exist([output_folder 'sims-data.mat'],'file')
    % compute parameters for all stochastic simulations
    compute_pars(output_folder); % output written as .mat

    % simulate all conditions
    simulate_all_conditions(output_folder); % read pars from .mat file, output .mat file
end
    
% compute statistics of all conditions
compute_statistics(output_folder); % read sims from mat file, output statistics as csv file

end



function pars = compute_pars(output_folder)
% paths
addpath('../model-code/steady-state');
addpath('../model-code/stochastic-dynamics');

%
constants = give_constants();
params.ri_r_rate = constants.cm_koff;
params.sigma = constants.sigma;
params.delta = constants.reference_delta;
params.a_sat = constants.K / params.delta; 
params.f_X_scale = constants.reference_fX_scale;
params.f_X_e_exponent = constants.reference_fX_e_exponent;
params.f_X_active_rib_frac_exponent = constants.reference_fX_active_rib_frac_exponent;
params.f_Q = constants.reference_fQ;
params.X_div = constants.reference_Xdiv;
params.destroy_X_after_div = 0;
params.X_degrad_rate = 0;

% first, nutrient modulation
%ref_alpha = 1; % per hour, ~glucose
%k_media_vec = [0.8, 2, constants.reference_k, 7, 12];
k_media_vec = [0.8, 2, constants.reference_k, 7, 12, 20, 45];
params.f_U = 0;
params.r_ri_rate = 0;
pars.nut_pars = cell(size(k_media_vec));
for i_nut=1:length(k_media_vec)
    params.k_media = k_media_vec(i_nut);
    pars.nut_pars{i_nut} = params;
end
% then, chloramphenicol modulation
cm_kon_vec = [1.7];
pars.cm_pars = cell(size(cm_kon_vec));
for i_cm=1:length(cm_kon_vec)
    params.k_media = k_media_vec(3);
    params.r_ri_rate = cm_kon_vec(i_cm);
    pars.cm_pars{i_cm} = params;
end
% finally, useless modulation
params.r_ri_rate = 0;
fU_vec = [0.2 0.35];
pars.useless_pars = cell(size(fU_vec));
for i_useless=1:length(fU_vec)
    params.f_U = fU_vec(i_useless);
    pars.useless_pars{i_useless} = params;
end
% write to file
save([output_folder '/param-sets.mat'],'pars');
end

function simulate_all_conditions(output_folder)
constants = give_constants();
pars = load([output_folder '/param-sets.mat']);
pars = pars.pars;
path2bin = '..\model-code\stochastic-dynamics\cpp-simulator-cm-rates\bin\Debug\cpp-simulator-cm-rates.exe';
path2output = '..\model-code\stochastic-dynamics\cpp-simulator-cm-rates\sim-data';
% nut
sims.nut_sims = cell(size(pars.nut_pars));
for i_nut=1:length(pars.nut_pars)
    this_pars = pars.nut_pars{i_nut};
    this_pars.random_seed = 0;
    this_pars.partitioning_type = 'normal';
    this_pars.num_lineages = 1;
    this_pars.sim_duration = 500 * constants.stoch_sample_scale;
    this_pars.update_period = 0.005;
    this_pars.num_updates_per_output = 100;
    sims.nut_sims{i_nut} = do_single_sim_cm_rates(this_pars, path2bin, path2output);
end
% cm
sims.cm_sims = cell(size(pars.cm_pars));
for i_cm=1:length(pars.cm_pars)
    this_pars = pars.cm_pars{i_cm};
    this_pars.random_seed = 0;
    this_pars.partitioning_type = 'normal';
    this_pars.num_lineages = 1;
    this_pars.sim_duration = 500 * constants.stoch_sample_scale;
    this_pars.update_period = 0.005;
    this_pars.num_updates_per_output = 100;
    sims.cm_sims{i_cm} = do_single_sim_cm_rates(this_pars, path2bin, path2output);
end
% useless
sims.useless_sims = cell(size(pars.useless_pars));
for i_useless=1:length(pars.useless_pars)
    this_pars = pars.useless_pars{i_useless};
    this_pars.random_seed = 0;
    this_pars.partitioning_type = 'normal';
    this_pars.num_lineages = 1;
    this_pars.sim_duration = 500 * constants.stoch_sample_scale;
    this_pars.update_period = 0.005;
    this_pars.num_updates_per_output = 100;
    sims.useless_sims{i_useless} = do_single_sim_cm_rates(this_pars, path2bin, path2output);
end
% write to file
save([output_folder '/sims-data.mat'],'sims');
end


%%%%%
function stats = compute_statistics(output_folder)
sims = load([output_folder '/sims-data.mat']);
sims = sims.sims;
stats.nut_stats = cell(size(sims.nut_sims));
stats.cm_stats = cell(size(sims.cm_sims));
stats.useless_stats = cell(size(sims.useless_sims));
% nut
for i_nut=1:length(sims.nut_sims)
    lineages = sims.nut_sims{i_nut}.lineage_data(101:end,:); % cut first 100 cell cycles
    lineages.growth_rate = log(lineages.V_div./lineages.V_birth) ./ lineages.T_div;
    % added size per birth size
    n_bins_growth_rate = 5;
    [~,I_sort] = sort(lineages.growth_rate);
    n_per_bins = floor(length(I_sort) / n_bins_growth_rate);
    % compute average in each bins
    binning_avg_growth_rates = zeros(n_bins_growth_rate, 1);
    binning_avg_Vbs = zeros(n_bins_growth_rate, 1);
    for i_b = 1:n_bins_growth_rate
        binning_avg_Vbs(i_b) = mean(lineages.V_birth(I_sort((i_b-1)*n_per_bins+1:i_b*n_per_bins)));
        binning_avg_growth_rates(i_b) = mean(lineages.growth_rate(I_sort((i_b-1)*n_per_bins+1:i_b*n_per_bins)));
    end
    stats.nut_stats{i_nut}.binning_avg_Vbs = binning_avg_Vbs;
    stats.nut_stats{i_nut}.binning_avg_growth_rates = binning_avg_growth_rates;
    stats.nut_stats{i_nut}.avg_growth_rate = mean(lineages.growth_rate);
    stats.nut_stats{i_nut}.avg_V_birth = mean(lineages.V_birth);
    birth_size_bin_avg = binning_avg_Vbs;
    growth_rate_bin_avg = binning_avg_growth_rates;
    growth_rate_avg = mean(lineages.growth_rate).*ones(size(birth_size_bin_avg));
    stats_table = table(birth_size_bin_avg, growth_rate_bin_avg,growth_rate_avg);
    writetable(stats_table,[output_folder '/single-cell-stats/nutrients-' num2str(i_nut) '.csv']);
end
% cm
for i_cm=1:length(sims.cm_sims)
    lineages = sims.cm_sims{i_cm}.lineage_data(101:end,:); % cut first 100 cell cycles
    lineages.growth_rate = log(lineages.V_div./lineages.V_birth) ./ lineages.T_div;
    % added size per birth size
    n_bins_growth_rate = 5;
    [~,I_sort] = sort(lineages.growth_rate);
    n_per_bins = floor(length(I_sort) / n_bins_growth_rate);
    % compute average in each bins
    binning_avg_growth_rates = zeros(n_bins_growth_rate, 1);
    binning_avg_Vbs = zeros(n_bins_growth_rate, 1);
    for i_b = 1:n_bins_growth_rate
        binning_avg_Vbs(i_b) = mean(lineages.V_birth(I_sort((i_b-1)*n_per_bins+1:i_b*n_per_bins)));
        binning_avg_growth_rates(i_b) = mean(lineages.growth_rate(I_sort((i_b-1)*n_per_bins+1:i_b*n_per_bins)));
    end
    stats.cm_stats{i_cm}.binning_avg_Vbs = binning_avg_Vbs;
    stats.cm_stats{i_cm}.binning_avg_growth_rates = binning_avg_growth_rates;
    stats.cm_stats{i_cm}.avg_growth_rate = mean(lineages.growth_rate);
    stats.cm_stats{i_cm}.avg_V_birth = mean(lineages.V_birth);
    birth_size_bin_avg = binning_avg_Vbs;
    growth_rate_bin_avg = binning_avg_growth_rates;
    growth_rate_avg = mean(lineages.growth_rate).*ones(size(birth_size_bin_avg));
    stats_table = table(birth_size_bin_avg, growth_rate_bin_avg,growth_rate_avg);
    writetable(stats_table,[output_folder '/single-cell-stats/cm-' num2str(i_cm) '.csv']);
end
% useless
for i_useless=1:length(sims.useless_sims)
    lineages = sims.useless_sims{i_useless}.lineage_data(101:end,:); % cut first 100 cell cycles
    lineages.growth_rate = log(lineages.V_div./lineages.V_birth) ./ lineages.T_div;
    % added size per birth size
    n_bins_growth_rate = 5;
    [~,I_sort] = sort(lineages.growth_rate);
    n_per_bins = floor(length(I_sort) / n_bins_growth_rate);
    % compute average in each bins
    binning_avg_growth_rates = zeros(n_bins_growth_rate, 1);
    binning_avg_Vbs = zeros(n_bins_growth_rate, 1);
    for i_b = 1:n_bins_growth_rate
        binning_avg_Vbs(i_b) = mean(lineages.V_birth(I_sort((i_b-1)*n_per_bins+1:i_b*n_per_bins)));
        binning_avg_growth_rates(i_b) = mean(lineages.growth_rate(I_sort((i_b-1)*n_per_bins+1:i_b*n_per_bins)));
    end
    stats.useless_stats{i_useless}.binning_avg_Vbs = binning_avg_Vbs;
    stats.useless_stats{i_useless}.binning_avg_growth_rates = binning_avg_growth_rates;
    stats.useless_stats{i_useless}.avg_growth_rate = mean(lineages.growth_rate);
    stats.useless_stats{i_useless}.avg_V_birth = mean(lineages.V_birth);
    birth_size_bin_avg = binning_avg_Vbs;
    growth_rate_bin_avg = binning_avg_growth_rates;
    growth_rate_avg = mean(lineages.growth_rate).*ones(size(birth_size_bin_avg));
    stats_table = table(birth_size_bin_avg, growth_rate_bin_avg,growth_rate_avg);
    writetable(stats_table,[output_folder '/single-cell-stats/useless-' num2str(i_useless) '.csv']);
end
end