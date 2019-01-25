
addpath('../model-code/steady-state');

% load fitted pars
fitted_scott_pars = readtable('../results-data/res1_scott-2010-fit/fitted-parameters_proteome-allocation.csv');
fitted_size_pars = readtable('../results-data/res4_basan-2015-si-2017-taheri-2015-fit/ref/two-sectors-size-predictions/e_and_ra_over_r_data_fX-true/exponents.csv');
fitted_size_scale = readtable('../results-data/res4_basan-2015-si-2017-taheri-2015-fit/ref/two-sectors-size-predictions/e_and_ra_over_r_data_fX-true/scale_factor.csv');

% fitted  model parameters
cell_pars.biophysical.sigma = fitted_scott_pars.sigma;
cell_pars.biophysical.a_sat = fitted_scott_pars.a_sat;
cell_pars.constraint.q = fitted_scott_pars.q;

% nutrietn modulation
nut_alpha_vec = linspace(0.3,2.5,50);
env_pars.ri = 0;
cell_pars.allocation.fU = 0;
nut_size_vec = zeros(size(nut_alpha_vec));
for i_nut=1:length(nut_alpha_vec)
    % optimal parameterization for this nutrient growth rate
    env_pars.k = fit_k_from_alpha(cell_pars,env_pars,nut_alpha_vec(i_nut));
    [ss,cell_pars] = give_optimal_steady_state_from_Q_constraint(cell_pars,env_pars);
    nut_size_vec(i_nut) = fitted_size_scale.scale_factor^(-1) * ss.e^(-fitted_size_pars.exponents(1)) * (ss.ra/ss.r)^(-fitted_size_pars.exponents(2)) / (1-ss.a);
end
growth_rate_per_hr = nut_alpha_vec';
cell_size = nut_size_vec';
writetable( table(growth_rate_per_hr, cell_size), '../results-data/res15_size-vs-growth-det-model/nutrient.csv');


% cm
alpha_cm_refs = [0.36, 0.65, 0.98, 1.03, 1.51, 1.71];
for i_alpha_ref=1:length(alpha_cm_refs)
    env_pars.k = fit_k_from_alpha(cell_pars,env_pars,alpha_cm_refs(i_alpha_ref));
    [~,cell_pars] = give_optimal_steady_state_from_Q_constraint(cell_pars,env_pars);
    cm_alpha_vec = linspace(0.2,alpha_cm_refs(i_alpha_ref),50);
    cm_size_vec = zeros(size(cm_alpha_vec));
    for i_cm=1:length(cm_alpha_vec)
        env_pars.ri = fit_ri_from_alpha(cell_pars,env_pars,cm_alpha_vec(i_cm));
        [ss,cell_pars] = give_optimal_steady_state_from_Q_constraint(cell_pars,env_pars);
        cm_size_vec(i_cm) = fitted_size_scale.scale_factor^(-1) * ss.e^(-fitted_size_pars.exponents(1)) * (ss.ra/ss.r)^(-fitted_size_pars.exponents(2)) / (1-ss.a);
    end
    growth_rate_per_hr = cm_alpha_vec';
    cell_size = cm_size_vec';
    writetable( table(growth_rate_per_hr, cell_size), ['../results-data/res15_size-vs-growth-det-model/cm_' num2str(i_alpha_ref) '.csv']);
end

% useless
env_pars.ri = 0;
alpha_useless_refs = [0.98, 1.29];
for i_alpha_ref=1:length(alpha_useless_refs)
    env_pars.k = fit_k_from_alpha(cell_pars,env_pars,alpha_useless_refs(i_alpha_ref));
    [~,cell_pars] = give_optimal_steady_state_from_Q_constraint(cell_pars,env_pars);
    useless_alpha_vec = linspace(0.3,alpha_useless_refs(i_alpha_ref),50);
    useless_size_vec = zeros(size(useless_alpha_vec));
    for i_useless=1:length(useless_alpha_vec)
        cell_pars.allocation.fU = fit_fU_from_alpha(cell_pars,env_pars,useless_alpha_vec(i_useless));
        [ss,cell_pars] = give_optimal_steady_state_from_Q_constraint(cell_pars,env_pars);
        useless_size_vec(i_useless) = fitted_size_scale.scale_factor^(-1) * ss.e^(-fitted_size_pars.exponents(1)) * (ss.ra/ss.r)^(-fitted_size_pars.exponents(2)) / (1-ss.a);
    end
    growth_rate_per_hr = useless_alpha_vec';
    cell_size = useless_size_vec';
    writetable( table(growth_rate_per_hr, cell_size), ['../results-data/res15_size-vs-growth-det-model/useless_' num2str(i_alpha_ref) '.csv']);
end
