
function scr12_study_individuality_across_modulations()

if ~exist('../results-data/res12_individuality-across-modulations/sims-data.mat','file')
    % compute parameters for all stochastic simulations
    compute_pars(); % output written as .mat

    % simulate all conditions
    simulate_all_conditions(); % read pars from .mat file, output .mat file
end
    
% compute statistics of all conditions
compute_statistics(); % read sims from mat file, output statistics as csv file

end



function pars = compute_pars()
% paths
addpath('../model-code/steady-state');
addpath('../model-code/stochastic-dynamics');
% load fitted pars
fitted_scott_pars = readtable('../results-data/res1_scott-2010-fit/fitted-parameters_proteome-allocation.csv');
fitted_size_pars = readtable('../results-data/res4_basan-2015-si-2017-taheri-2015-fit/ref/two-sectors-size-predictions/e_and_ra_over_r_data_fX-true/exponents.csv');      
fitted_Xdiv_fX_scale = readtable('../results-data/res8_fX-scale-and-Xdiv/Xdiv_fX_scale_fit.csv'); 
cm_rate_pars = readtable('../results-data/res7_stoch-model-finding-rib-reactivation-rate/summary-cm-rates-stoch-model.csv');
% assemble the parameters structure for solving the det model
det_pars.biophysical.sigma = fitted_scott_pars.sigma;
det_pars.biophysical.a_sat = fitted_scott_pars.a_sat;
det_pars.constraint.q = fitted_scott_pars.q;
det_pars.allocation.fU = 0;
% first, nutrient modulation
ref_alpha = 1; % per hour, ~glucose
nut_alpha_vec = [0.4 0.75 1.0 1.4 1.8];
det_pars.allocation.fU = 0;
env_pars.ri = 0;
pars.nut_pars = cell(size(nut_alpha_vec));
for i_nut=1:length(nut_alpha_vec)
    % optimal parameterization for this nutrient growth rate
    env_pars.k = fit_k_from_alpha(det_pars,env_pars,nut_alpha_vec(i_nut));
    det_ss = give_optimal_steady_state_from_Q_constraint(det_pars,env_pars);
    % make 'equivalent' stoch model parameterization
    stoch_pars.a_sat = det_pars.biophysical.a_sat;
    stoch_pars.sigma = det_pars.biophysical.sigma;
    stoch_pars.k_media = env_pars.k;
    stoch_pars.f_R = det_ss.fR;
    stoch_pars.f_E = det_ss.fE;
    stoch_pars.X_div = fitted_Xdiv_fX_scale.X_div;
    stoch_pars.f_X = fitted_Xdiv_fX_scale.fX_scale * det_ss.e^(fitted_size_pars.exponents(1)) * (det_ss.ra/det_ss.r)^(fitted_size_pars.exponents(2));
    stoch_pars.f_Q = det_ss.fQ - stoch_pars.f_X;
    stoch_pars.f_U = 0;
    stoch_pars.destroy_X_after_div = 0;
    stoch_pars.X_degrad_rate = 0;
    stoch_pars.ri_r_rate = cm_rate_pars.condition_independent_ri_r_rate; % does not matter since no cm
    stoch_pars.r_ri_rate = 0;
    this_pars.det_pars = det_pars;
    this_pars.stoch_pars = stoch_pars;
    pars.nut_pars{i_nut} = this_pars;
end
% then, chloramphenicol modulation
env_pars.ri = 0;
det_pars.allocation.fU = 0;
env_pars.k = fit_k_from_alpha(det_pars,env_pars,ref_alpha); % to have the reference k
cm_alpha_vec = [0.5];
cm_r_ri_rate_vec = [cm_rate_pars.cm_2X_alpha_decrease_from_1_per_hr_nut_r_ri_rate]; % cf mapping ri with rates
pars.cm_pars = cell(size(cm_alpha_vec));
for i_cm=1:length(cm_alpha_vec)
    % compute the ri that leads to the desired growth rate reduction
    env_pars.ri = fit_ri_from_alpha(det_pars,env_pars,cm_alpha_vec(i_cm));
    det_ss_cm = give_optimal_steady_state_from_Q_constraint(det_pars,env_pars);
    % make 'equivalent' stoch model parameterization
    stoch_pars.a_sat = det_pars.biophysical.a_sat;
    stoch_pars.sigma = det_pars.biophysical.sigma;
    stoch_pars.k_media = env_pars.k;
    stoch_pars.f_R = det_ss_cm.fR;
    stoch_pars.f_E = det_ss_cm.fE;
    stoch_pars.X_div = fitted_Xdiv_fX_scale.X_div;
    stoch_pars.f_X = fitted_Xdiv_fX_scale.fX_scale * det_ss_cm.e^(fitted_size_pars.exponents(1)) * (det_ss_cm.ra/det_ss_cm.r)^(fitted_size_pars.exponents(2));
    stoch_pars.f_Q = det_ss_cm.fQ - stoch_pars.f_X;
    stoch_pars.f_U = 0;
    stoch_pars.destroy_X_after_div = 0;
    stoch_pars.X_degrad_rate = 0;
    stoch_pars.ri_r_rate = cm_rate_pars.condition_independent_ri_r_rate; % does not matter since no cm
    stoch_pars.r_ri_rate = cm_r_ri_rate_vec(i_cm);
    this_pars.det_pars = det_pars;
    this_pars.stoch_pars = stoch_pars;    
    pars.cm_pars{i_cm} = this_pars;
end
% finally, useless modulation
env_pars.ri = 0;
det_pars.allocation.fU = 0;
env_pars.k = fit_k_from_alpha(det_pars,env_pars,ref_alpha);
useless_alpha_vec = [0.4 0.6 0.8];
pars.useless_pars = cell(size(useless_alpha_vec));
for i_useless=1:length(useless_alpha_vec)
    det_pars.allocation.fU = fit_fU_from_alpha(det_pars,env_pars,useless_alpha_vec(i_useless));
    det_ss_useless = give_optimal_steady_state_from_Q_constraint(det_pars,env_pars);
    % make 'equivalent' stoch model parameterization
    stoch_pars.sigma = det_pars.biophysical.sigma;
    stoch_pars.a_sat = det_pars.biophysical.a_sat;
    stoch_pars.k_media = env_pars.k;
    stoch_pars.f_U = det_ss_useless.fU;
    stoch_pars.f_E = det_ss_useless.fE;
    stoch_pars.f_R = det_ss_useless.fR;
    stoch_pars.X_div = fitted_Xdiv_fX_scale.X_div;
    stoch_pars.f_X = fitted_Xdiv_fX_scale.fX_scale * det_ss_useless.e^(fitted_size_pars.exponents(1)) * (det_ss_useless.ra/det_ss_useless.r)^(fitted_size_pars.exponents(2));
    stoch_pars.f_Q = det_ss_useless.fQ - stoch_pars.f_X;
    stoch_pars.destroy_X_after_div = 0;
    stoch_pars.X_degrad_rate = 0;
    stoch_pars.ri_r_rate = cm_rate_pars.condition_independent_ri_r_rate; % does not matter since no cm
    stoch_pars.r_ri_rate = 0; % no cm    
    this_pars.cell_pars = det_pars;
    this_pars.stoch_pars = stoch_pars;
    pars.useless_pars{i_useless} = this_pars;
end
% write to file
save('../results-data/res12_individuality-across-modulations/param-sets.mat','pars');
end

function simulate_all_conditions()
pars = load('../results-data/res12_individuality-across-modulations/param-sets.mat');
pars = pars.pars;
path2cpp = '../model-code/stochastic-dynamics/cpp-simulator-cm-rates/build/simulator';
path2output = '../model-code/stochastic-dynamics/cpp-sim-data';
% nut
sims.nut_sims = cell(size(pars.nut_pars));
for i_nut=1:length(pars.nut_pars)
    this_pars = pars.nut_pars{i_nut}.stoch_pars;
    this_pars.random_seed = 0;
    this_pars.partitioning_type = 'normal';
    this_pars.num_lineages = 1;
    this_pars.sim_duration = 200000;
    this_pars.update_period = 0.005;
    this_pars.num_updates_per_output = 100;
    sims.nut_sims{i_nut} = do_single_sim_cm_rates(this_pars, path2cpp, path2output);
end
% cm
sims.cm_sims = cell(size(pars.cm_pars));
for i_cm=1:length(pars.cm_pars)
    this_pars = pars.cm_pars{i_cm}.stoch_pars;
    this_pars.random_seed = 0;
    this_pars.partitioning_type = 'normal';
    this_pars.num_lineages = 1;
    this_pars.sim_duration = 200000;
    this_pars.update_period = 0.005;
    this_pars.num_updates_per_output = 100;
    sims.cm_sims{i_cm} = do_single_sim_cm_rates(this_pars, path2cpp, path2output);
end
% useless
sims.useless_sims = cell(size(pars.useless_pars));
for i_useless=1:length(pars.useless_pars)
    this_pars = pars.useless_pars{i_useless}.stoch_pars;
    this_pars.random_seed = 0;
    this_pars.partitioning_type = 'normal';
    this_pars.num_lineages = 1;
    this_pars.sim_duration = 200000;
    this_pars.update_period = 0.005;
    this_pars.num_updates_per_output = 100;
    sims.useless_sims{i_useless} = do_single_sim_cm_rates(this_pars, path2cpp, path2output);
end
% write to file
save('../results-data/res12_individuality-across-modulations/sims-data.mat','sims');
end


%%%%%
function stats = compute_statistics()
sims = load('../results-data/res12_individuality-across-modulations/sims-data.mat');
sims = sims.sims;
stats.nut_stats = cell(size(sims.nut_sims));
stats.cm_stats = cell(size(sims.cm_sims));
% nut
for i_nut=1:length(sims.nut_sims)
    lineages = sims.nut_sims{i_nut}.lineage_data(101:end,:); % cut first 100 cell cycles
    lineages.growth_rate = log(lineages.V_div./lineages.V_birth) ./ lineages.T_div;
    % added size per birth size
    n_bins_growth_rate = 8;
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
    writetable(stats_table,['../results-data/res12_individuality-across-modulations/single-cell-stats/nutrients-' num2str(i_nut) '.csv']);
end
% cm
for i_cm=1:length(sims.cm_sims)
    lineages = sims.cm_sims{i_cm}.lineage_data(101:end,:); % cut first 100 cell cycles
    lineages.growth_rate = log(lineages.V_div./lineages.V_birth) ./ lineages.T_div;
    % added size per birth size
    n_bins_growth_rate = 8;
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
    writetable(stats_table,['../results-data/res12_individuality-across-modulations/single-cell-stats/cm-' num2str(i_cm) '.csv']);
end
% useless
for i_useless=1:length(sims.useless_sims)
    lineages = sims.useless_sims{i_useless}.lineage_data(101:end,:); % cut first 100 cell cycles
    lineages.growth_rate = log(lineages.V_div./lineages.V_birth) ./ lineages.T_div;
    % added size per birth size
    n_bins_growth_rate = 8;
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
    writetable(stats_table,['../results-data/res12_individuality-across-modulations/single-cell-stats/useless-' num2str(i_useless) '.csv']);
end
end