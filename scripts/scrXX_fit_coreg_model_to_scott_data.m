
%%%%%
% Data to fit is scott data where ribosomal fraction is measured (nutrient
% and chloramphenicol 2D
%
% Three parameters are fitted: sigma, q, delta = a/fR
%
% Parameter space is explored using a grid-like approach (Sobol sequence).
%
% For each point, we simulate the scott nutrient x chloramphenicol
% modulation and compute the mean square error between model and data
% ribosomal fraction
%
% we don't explore points for which the maximum growth rate (k->infinity)
% is less that 15 minutes doubling time
%
%%%%%

function comp_data = scrXX_fit_coreg_model_to_scott_data()

%%% various paths needed
addpath('../model-code');
addpath('../model-code/steady-state');
addpath('../model-code/steady-state_coreg');

% x_best = [6.2880, 0.0104, 0.4743] starting from [6,0.01,0.45]
% x_best = [6.3381    0.1522    0.4347] starting from [6,0.15,0.45] but stopped because numerical issue
% x_best = [6.1338    0.2573    0.4076]; % starting from [6.5,0.2,0.3] but stopped because numerical issue 
% x_best = [6.2297    0.4296    0.3591]; % starting from [6.1338    0.2573    0.4076] but stopped because numerical issue 
x_best = [6.1950    0.3915    0.3654];
%x_best = [6.3227    0.0009    0.5166];
% x_best = fminsearch(@(x)simulate_scott_and_compute_cost_coreg(x), [6.    0.2    0.4]);
cost_best = simulate_scott_and_compute_cost_coreg(x_best);
comp_data = simulate_scott_coreg(x_best);

%%% write in table if not done
if ~exist('../results-data/resXX_scott-2010-fit_coreg/summary-best-pars.csv','file')
    sigma = x_best(1);
    delta = x_best(2);
    q = x_best(3);
    scott_fit_best_pars = table(sigma, delta, q, cost_best);
    writetable(scott_fit_best_pars, '../results-data/resXX_scott-2010-fit_coreg/summary-best-pars.csv');
else
    scott_fit_best_pars = readtable('../results-data/resXX_scott-2010-fit_coreg/summary-best-pars.csv');
    scott_fit_best_pars.sigma(end+1,1) = x_best(1);
    scott_fit_best_pars.delta(end,1) = x_best(2);
    scott_fit_best_pars.q(end,1) = x_best(3);
    scott_fit_best_pars.cost_best(end,1) = cost_best;
    writetable(scott_fit_best_pars, '../results-data/resXX_scott-2010-fit_coreg/summary-best-pars.csv');
end


end


function composition_data = simulate_scott_coreg(x)
% order: sigma, delta, q
pars.sigma = x(1);
pars.delta = x(2);
pars.q = x(3);
% scott nut x cm data
mod_data = readtable('../external-data/scott_2010_data.csv');
%mod_data = mod_data(mod_data.useless_type==0, :);
composition_data = compute_cell_composition_from_growth_modulation_coreg(pars, mod_data);
end



function cost = simulate_scott_and_compute_cost_coreg(x)
x
comp_data = simulate_scott_coreg(x);
if isempty(comp_data)
    cost = 1e300;
    return;
end
comp_data_nut_cm = comp_data(comp_data.useless_type==0,:);
delta_fR_vec = comp_data_nut_cm.estim_ribosomal_fraction - comp_data_nut_cm.model_fR;
cost = mean(delta_fR_vec.^2);
% comp_data_useless = comp_data(comp_data.useless_type>0,:);
% delta_fU_vec = comp_data_useless.estim_useless_fraction - comp_data_useless.model_fU;
% cost = cost + 0.2 * mean(delta_fU_vec.^2);
% % penalize too low max growth rate
% cell_pars.biophysical.sigma = x(1);
% cell_pars.constraint.delta = x(2);
% cell_pars.constraint.q = x(3);
% cell_pars.allocation.fU = 0;
% env_pars.ri = 0;
% env_pars.k = 1e12;
% ss_k_inf = give_steady_state_coreg(cell_pars,env_pars);
% if ss_k_inf.alpha < 2.4
%     disp('max growth rate too low...')
%     cost = cost + 10*(2.4 - ss_k_inf.alpha)^2;
% end
log(cost)
end