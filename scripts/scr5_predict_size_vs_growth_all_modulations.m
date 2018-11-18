
addpath('../model-code/steady-state');

% load fitted pars
fitted_scott_pars = readtable('../results-data/res1_scott-2010-fit/fitted-parameters_proteome-allocation.csv');
fitted_size_pars = readtable('../results-data/res4_basan-2015-si-2017-taheri-2015-fit/ref/two-sectors-size-predictions/e_and_ra_over_r_data_fX-true/exponents.csv');      
fitted_Xdiv_fX_scale = readtable('../results-data/res8_fX-scale-and-Xdiv/Xdiv_fX_scale_fit.csv'); 

% fitted  model parameters
cell_pars.biophysical.sigma = fitted_scott_pars.sigma;
cell_pars.biophysical.a_sat = fitted_scott_pars.a_sat;
cell_pars.constraint.q = fitted_scott_pars.q;

% nutrietn modulation
nut_alpha_vec = linspace(0.3,2.0,50);
env_pars.ri = 0;
cell_pars.allocation.fU = 0;
nut_v_birth_vec = zeros(size(nut_alpha_vec));
for i_nut=1:length(nut_alpha_vec)
    % optimal parameterization for this nutrient growth rate
    env_pars.k = fit_k_from_alpha(cell_pars,env_pars,nut_alpha_vec(i_nut));
    [ss,cell_pars] = give_optimal_steady_state_from_Q_constraint(cell_pars,env_pars);
    f_X = fitted_Xdiv_fX_scale.fX_scale * ss.e^fitted_size_pars.exponents(1) *(ss.ra/ss.r)^fitted_size_pars.exponents(2);
    nut_v_birth_vec(i_nut) = fitted_Xdiv_fX_scale.X_div / f_X / (1-ss.a) / 2;
end
growth_rate_per_hr = nut_alpha_vec';
birth_size = nut_v_birth_vec';
writetable( table(growth_rate_per_hr, birth_size), '../results-data/res5_size-vs-growth-det-model/nutrient.csv');
% cm
env_pars.k = fit_k_from_alpha(cell_pars,env_pars,1.0);
[~,cell_pars] = give_optimal_steady_state_from_Q_constraint(cell_pars,env_pars);
cm_alpha_vec = linspace(0.3,1.0,50);
cm_v_birth_vec = zeros(size(cm_alpha_vec));
for i_cm=1:length(cm_alpha_vec)
    env_pars.ri = fit_ri_from_alpha(cell_pars,env_pars,cm_alpha_vec(i_cm));
    [ss,cell_pars] = give_optimal_steady_state_from_Q_constraint(cell_pars,env_pars);
    f_X = fitted_Xdiv_fX_scale.fX_scale * ss.e^fitted_size_pars.exponents(1) *(ss.ra/ss.r)^fitted_size_pars.exponents(2);
    cm_v_birth_vec(i_cm) = fitted_Xdiv_fX_scale.X_div / f_X / (1-ss.a) / 2;
end
growth_rate_per_hr = cm_alpha_vec';
birth_size = cm_v_birth_vec';
writetable( table(growth_rate_per_hr, birth_size), '../results-data/res5_size-vs-growth-det-model/cm.csv');
% useless
env_pars.ri = 0;
env_pars.k = fit_k_from_alpha(cell_pars,env_pars,1.0);
[~,cell_pars] = give_optimal_steady_state_from_Q_constraint(cell_pars,env_pars);
useless_alpha_vec = linspace(0.3,1.0,50);
useless_v_birth_vec = zeros(size(useless_alpha_vec));
for i_useless=1:length(useless_alpha_vec)
    cell_pars.allocation.fU = fit_fU_from_alpha(cell_pars,env_pars,useless_alpha_vec(i_useless));
    [ss,cell_pars] = give_optimal_steady_state_from_Q_constraint(cell_pars,env_pars);
    f_X = fitted_Xdiv_fX_scale.fX_scale * ss.e^fitted_size_pars.exponents(1) *(ss.ra/ss.r)^fitted_size_pars.exponents(2);
    useless_v_birth_vec(i_useless) = fitted_Xdiv_fX_scale.X_div / f_X / (1-ss.a) / 2;
end
growth_rate_per_hr = useless_alpha_vec';
birth_size = useless_v_birth_vec';
writetable( table(growth_rate_per_hr, birth_size), '../results-data/res5_size-vs-growth-det-model/useless.csv');

