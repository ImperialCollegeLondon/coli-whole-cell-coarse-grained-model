

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
stoch_pars.sigma = det_pars.biophysical.sigma;
stoch_pars.a_sat = det_pars.biophysical.a_sat;
stoch_pars.k_media = env_pars.k;
stoch_pars.f_U = 0;
stoch_pars.f_E = det_ss.fE;
stoch_pars.f_R = det_ss.fR;
stoch_pars.X_div = fitted_Xdiv_fX_scale.X_div;
stoch_pars.f_X = fitted_Xdiv_fX_scale.fX_scale * det_ss.e^(fitted_size_pars.exponents(1)) * (det_ss.ra/det_ss.r)^(fitted_size_pars.exponents(2));
stoch_pars.f_Q = det_ss.fQ - stoch_pars.f_X;
stoch_pars.destroy_X_after_div = 0;
stoch_pars.X_degrad_rate = 0;
stoch_pars.ri_r_rate = 100; % does not matter since no cm
stoch_pars.r_ri_rate = 0;

% sim params, do the sim
stoch_pars.random_seed = 0;
stoch_pars.partitioning_type = 'normal';
stoch_pars.num_lineages = 1;
stoch_pars.sim_duration = 7.8;
stoch_pars.update_period = 0.005;
stoch_pars.num_updates_per_output = 1;
path2cpp = '../model-code/stochastic-dynamics/cpp-simulator-cm-rates/build/simulator';
path2output = '../model-code/stochastic-dynamics/cpp-sim-data';
traj_data = do_single_sim_cm_rates(stoch_pars, path2cpp, path2output);

% clean and transform to table
traj_data = rmfield(traj_data,'lineage_data');
traj_data = rmfield(traj_data,'params');
traj_data = renameStructField(traj_data,'traj_A','A');
traj_data = renameStructField(traj_data,'traj_E','E');
traj_data = renameStructField(traj_data,'traj_R','RA');
traj_data = renameStructField(traj_data,'traj_RI','RI');
traj_data = renameStructField(traj_data,'traj_Q','Q');
traj_data = renameStructField(traj_data,'traj_X','X');
traj_data = renameStructField(traj_data,'traj_U','U');
traj_data = renameStructField(traj_data,'traj_size','size');
traj_data = renameStructField(traj_data,'traj_time','t');
traj_table = struct2table(traj_data);

% output
writetable(traj_table,'../results-data/res9_dynamic-stoch-model/trajectory.csv');

