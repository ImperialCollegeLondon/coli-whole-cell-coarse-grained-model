
addpath('../model-code/steady-state');
addpath('../model-code/stochastic-dynamics');

% variation of X_div and fX to explore
X_div_vec = linspace(30,170,12);
fX_vec = linspace(0.01,0.15,12);

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
det_ss = give_optimal_steady_state_from_Q_constraint(det_pars,env_pars);

% start building parameters structure for the stochastic model
stoch_pars.sigma = det_pars.biophysical.sigma;
stoch_pars.a_sat = det_pars.biophysical.a_sat;
stoch_pars.k_media = env_pars.k;
stoch_pars.f_U = 0;
stoch_pars.f_E = det_ss.fE;
stoch_pars.f_R = det_ss.fR;

% load and set the ribosome inactivation / re-activation rates (does not
% really matter here as we simulate no chloramphenicol condition)
cm_rates = readtable('../results-data/res7_stoch-model-finding-rib-reactivation-rate/summary-cm-rates-stoch-model.csv');
stoch_pars.r_ri_rate = 0; % cm = 0
stoch_pars.ri_r_rate = cm_rates.condition_independent_ri_r_rate;

% choice of additional stochastic parameters
stoch_pars.destroy_X_after_div = 0;
stoch_pars.X_degrad_rate = 0;

% simulation parameters
stoch_pars.random_seed = 0;
stoch_pars.partitioning_type = 'normal';
stoch_pars.sim_duration = 30000;
stoch_pars.num_lineages = 1;
stoch_pars.update_period = 0.005;
stoch_pars.num_updates_per_output = 100;
path2cpp = '../model-code/stochastic-dynamics/cpp-simulator-cm-rates/build/simulator';
path2output = '../model-code/stochastic-dynamics/cpp-sim-data';
if ~exist(path2output,'dir')
    mkdir(path2output);
end

% main loop
CV_birth_size_mat = zeros(length(X_div_vec), length(fX_vec));
CV_growth_rate_mat = zeros(length(X_div_vec), length(fX_vec));
for i=1:length(X_div_vec)
    for j=1:length(fX_vec)
        stoch_pars.X_div = X_div_vec(i);
        stoch_pars.f_X = fX_vec(j);
        stoch_pars.f_Q = det_ss.fQ - stoch_pars.f_X;
        sim_data = do_single_sim_cm_rates(stoch_pars, path2cpp, path2output);
        % remove 1000 first cell cycles for steady-state
        lineage_data = sim_data.lineage_data(1001:end,:);
        % compute alpha of cell cycles
        lineage_data.alpha = log(lineage_data.V_div ./ lineage_data.V_birth) ./ lineage_data.T_div;
        % compute the CVs
        CV_birth_size_mat(i,j) = std(lineage_data.V_birth)/mean(lineage_data.V_birth);
        CV_growth_rate_mat(i,j) = std(lineage_data.alpha)/mean(lineage_data.alpha);
    end
end

% format data as table
X_div = []; fX = []; CV_birth_size = []; CV_growth_rate = [];
for i=1:length(X_div_vec)
    for j=1:length(fX_vec)
        X_div(end+1,1) = X_div_vec(i);
        fX(end+1,1) = fX_vec(j);
        CV_birth_size(end+1,1) = CV_birth_size_mat(i,j);
        CV_growth_rate(end+1,1) = CV_growth_rate_mat(i,j);
    end
end
data = table(X_div, fX, CV_birth_size, CV_growth_rate);
writetable(data, '../results-data/res8_fX-scale-and-Xdiv/Xdiv_fX_impact_on_noise.csv');

% data from taheri araghi : for ~ intermediate growth rate, CV growth rate
% ~ 0.07, and CV birth at size is ~ 0.11
[sq_diff_cv_alpha,I_sorted_diff_cv_alpha] = sort((data.CV_growth_rate-0.07).^2);
[sq_diff_cv_birth_size,I_sorted_diff_cv_birth_size] = sort((data.CV_birth_size-0.11).^2);
n = 1;
while isempty(intersect(I_sorted_diff_cv_alpha(1:n),I_sorted_diff_cv_birth_size(1:n)))
    n = n+1;
end
I_good = intersect(I_sorted_diff_cv_alpha(1:n),I_sorted_diff_cv_birth_size(1:n));
assert(length(I_good)==1);
best_set = data(I_good,:)
    



