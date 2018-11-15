
addpath('../model-code/steady-state');
addpath('../model-code/stochastic-dynamics');

% load fitted pars on scott data
fitted_scott_pars = readtable('../results-data/res1_scott-2010-fit/fitted-parameters_proteome-allocation.csv'); 

% assemble the parameters structure for solving the det model
det_pars.biophysical.sigma = fitted_scott_pars.sigma;
det_pars.biophysical.a_sat = fitted_scott_pars.a_sat;
det_pars.constraint.q = fitted_scott_pars.q;
det_pars.allocation.fU = 0;

% solve the deterministic model for nutrient quality such that growth rate
% is 1 per hour
env_pars.ri = 0;
env_pars.k = fit_k_from_alpha(det_pars,env_pars,1.0);
det_ss_no_cm = give_optimal_steady_state_from_Q_constraint(det_pars,env_pars);

% find the ri so that growth rate reduced to 0.5 in that nutrient
env_pars.ri = fit_ri_from_alpha(det_pars,env_pars,0.5);
det_ss_cm = give_optimal_steady_state_from_Q_constraint(det_pars,env_pars);

% start building parameters structure for the stochastic model
stoch_pars.sigma = det_pars.biophysical.sigma;
stoch_pars.a_sat = det_pars.biophysical.a_sat;
stoch_pars.k_media = env_pars.k;
stoch_pars.f_U = 0;
stoch_pars.f_E = det_ss_cm.fE;
stoch_pars.f_R = det_ss_cm.fR;

% choice of additional stochastic parameters (manually chosen so that noise
% in size and growth rate are realistic given Taheri-Araghi et al. data)
stoch_pars.X_div = 70;
stoch_pars.f_X = 0.05;
stoch_pars.f_Q = det_ss_cm.fQ - stoch_pars.f_X;
stoch_pars.destroy_X_after_div = 0;
stoch_pars.X_degrad_rate = 0;

% simulation parameters
stoch_pars.random_seed = 0;
stoch_pars.partitioning_type = 'normal';
stoch_pars.num_lineages = 1;
stoch_pars.sim_duration = 10000;
stoch_pars.update_period = 0.005;
stoch_pars.num_updates_per_output = 1;
path2cpp = '../model-code/stochastic-dynamics/cpp-simulator-cm-rates/simulator.app/Contents/MacOS/simulator';
path2output = '../model-code/stochastic-dynamics/cpp-sim-data';

%%% arbitrary set the ribosome re-activation rate to 100, and search for the
%%% ratio that leads to the expected growth rate (0.5) in the simulation
%%% by varing the inactivation rate
ri_r_rate_base = 100;
ratio_rib_inactiv_over_reactiv_rate_vec = linspace(0.5,3,20);
% store results
real_growth_rate_vec = zeros(size(ratio_rib_inactiv_over_reactiv_rate_vec));
real_ri_vec = zeros(size(ratio_rib_inactiv_over_reactiv_rate_vec));
% iterate on the ratio
for i=1:length(ratio_rib_inactiv_over_reactiv_rate_vec)
    stoch_pars.ri_r_rate = ri_r_rate_base;
    stoch_pars.r_ri_rate = stoch_pars.ri_r_rate * ratio_rib_inactiv_over_reactiv_rate_vec(i);
    sim = do_single_sim_cm_rates(stoch_pars, path2cpp, path2output);
    real_ri_vec(i) = mean(sim.lineage_data.RI(31:end)./sim.lineage_data.V_birth(31:end)); % 'real' ri from the stochastic simulations
    real_growth_rate_vec(i) = log(2) / mean(sim.lineage_data.T_div(31:end));
end
%
[~,i_best] = min(abs(real_growth_rate_vec-0.5));
real_growth_rate_best = real_growth_rate_vec(i_best);
real_ri_best = real_ri_vec(i_best); % 'validation of consistency with deterministic model: the ri is very close the det model ri !'
r_ri_rate_base = ratio_rib_inactiv_over_reactiv_rate_vec(i_best) * ri_r_rate_base; 
% format and output the data
ri_r_rate = ri_r_rate_base .* ones(length(ratio_rib_inactiv_over_reactiv_rate_vec), 1);
r_ri_rate = ri_r_rate_base .* ratio_rib_inactiv_over_reactiv_rate_vec';
real_growth_rate_per_hr = real_growth_rate_vec';
real_ri = real_ri_vec';
det_ss_ri = env_pars.ri .* ones(length(ratio_rib_inactiv_over_reactiv_rate_vec), 1);
det_ss_growth_rate_per_hr = 0.5 .* ones(length(ratio_rib_inactiv_over_reactiv_rate_vec), 1);
writetable(table(ri_r_rate, r_ri_rate, real_growth_rate_per_hr, real_ri, det_ss_growth_rate_per_hr, det_ss_ri), '../results-data/res7_stoch-model-finding-rib-reactivation-rate/fixed-ri-r-rate_r-ri-rate-variation.csv');


%%% now check that increasing the ri <-> r rate scale (ratio conserved)
%%% does not change things above the base ri_r_rate
scale_vec = logspace(-3,0.5,10);
% obtain results
real_growth_rate_vec = zeros(size(scale_vec));
real_ri_vec = zeros(size(scale_vec));
for i=1:length(scale_vec)
    stoch_pars.ri_r_rate = ri_r_rate_base * scale_vec(i);
    stoch_pars.r_ri_rate = r_ri_rate_base * scale_vec(i);
    sim = do_single_sim_cm_rates(stoch_pars, path2cpp, path2output);
    real_ri_vec(i) = mean(sim.lineage_data.RI(31:end)./sim.lineage_data.V_birth(31:end)); % 'real' ri from the stochastic simulations
    real_growth_rate_vec(i) = log(2) / mean(sim.lineage_data.T_div(31:end));    
end
% format and output data
ri_r_rate = ri_r_rate_base .* scale_vec';
r_ri_rate = r_ri_rate_base .* scale_vec';
scale_factor = scale_vec';
real_growth_rate_per_hr = real_growth_rate_vec';
real_ri = real_ri_vec';
writetable(table(scale_factor, ri_r_rate, r_ri_rate, real_growth_rate_per_hr, real_ri), '../results-data/res7_stoch-model-finding-rib-reactivation-rate/scale-ri-r-and-r-ri-rates-variation.csv');

%%% output the found rates 
condition_independent_ri_r_rate = ri_r_rate_base;
cm_2X_alpha_decrease_from_1_per_hr_nut_r_ri_rate = r_ri_rate_base;
writetable(table(condition_independent_ri_r_rate, cm_2X_alpha_decrease_from_1_per_hr_nut_r_ri_rate),...
    '../results-data/res7_stoch-model-finding-rib-reactivation-rate/summary-cm-rates-stoch-model.csv');



