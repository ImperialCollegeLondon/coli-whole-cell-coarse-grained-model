

%%%%
%  two model variants
%  1) reference model, nutrient mod so that growth rate 1 per hour, no cm, no
%  useless
%  2) same, but with non-zero X degradation rate
%%%%


addpath('../model-code/steady-state');
addpath('../model-code/stochastic-dynamics');

% load fitted pars on scott data
fitted_scott_pars = readtable('../results-data/res1_scott-2010-fit/fitted-parameters_proteome-allocation.csv');
fitted_size_pars = readtable('../results-data/res4_basan-2015-si-2017-taheri-2015-fit/ref/two-sectors-size-predictions/e_and_ra_over_r_data_fX-true/exponents.csv');      
fitted_Xdiv_fX_scale = readtable('../results-data/res8_fX-scale-and-Xdiv/Xdiv_fX_scale_fit.csv'); 

% assemble the parameters structure for solving the det model
det_pars.biophysical.sigma = fitted_scott_pars.sigma;
det_pars.biophysical.a_sat = fitted_scott_pars.a_sat;
det_pars.constraint.q = fitted_scott_pars.q;
det_pars.allocation.fU = 0;

% solve the deterministic model for nutrient quality such that growth rate
% is 1 per hour
env_pars.ri = 0;
env_pars.k = fit_k_from_alpha(det_pars, env_pars, 1.0);
det_ss = give_optimal_steady_state_from_Q_constraint(det_pars, env_pars);

% build parameters structure for the stochastic model
stoch_pars_ref.sigma = det_pars.biophysical.sigma;
stoch_pars_ref.a_sat = det_pars.biophysical.a_sat;
stoch_pars_ref.k_media = env_pars.k;
stoch_pars_ref.f_U = 0;
stoch_pars_ref.f_E = det_ss.fE;
stoch_pars_ref.f_R = det_ss.fR;
stoch_pars_ref.X_div = fitted_Xdiv_fX_scale.X_div;
stoch_pars_ref.f_X = fitted_Xdiv_fX_scale.fX_scale * det_ss.e^(fitted_size_pars.exponents(1)) * (det_ss.ra/det_ss.r)^(fitted_size_pars.exponents(2));
stoch_pars_ref.f_Q = det_ss.fQ - stoch_pars_ref.f_X;
stoch_pars_ref.destroy_X_after_div = 0;
stoch_pars_ref.X_degrad_rate = 0;
stoch_pars_ref.ri_r_rate = 100; % does not matter since no cm
stoch_pars_ref.r_ri_rate = 0;

% simulation parameters
stoch_pars_ref.random_seed = 0;
stoch_pars_ref.partitioning_type = 'normal';
stoch_pars_ref.num_lineages = 1;
stoch_pars_ref.sim_duration = 100000;
stoch_pars_ref.update_period = 0.005;
stoch_pars_ref.num_updates_per_output = 1;

% model X degrad
stoch_pars_X_degrad = stoch_pars_ref;
stoch_pars_X_degrad.X_degrad_rate = 0.5;

% simulate the two models
path2cpp = '../model-code/stochastic-dynamics/cpp-simulator-cm-rates/build/simulator';
path2output = '../model-code/stochastic-dynamics/cpp-sim-data';
sim_ref = do_single_sim_cm_rates(stoch_pars_ref, path2cpp, path2output);
sim_X_degrad = do_single_sim_cm_rates(stoch_pars_X_degrad, path2cpp, path2output);

% compute the size homeostasis statistics (added size by bin of birth size)
stats_data = cell(2,1); data = {sim_ref, sim_X_degrad};
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


% output the results
names = {'ref_model', 'with_X_degrad_rate'};
for i=1:2
    scaled_birth_size_bin_avg = stats_data{i}.scaled_birth_size_bin_avg;
    scaled_delta_size_bin_avg = stats_data{i}.scaled_delta_size_bin_avg;
    output_table = table(scaled_birth_size_bin_avg, scaled_delta_size_bin_avg);
    writetable(output_table,['../results-data/res11_adder-sizer/' names{i} '.csv']);
end



