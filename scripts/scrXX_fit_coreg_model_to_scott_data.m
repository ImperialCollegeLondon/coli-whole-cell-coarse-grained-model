
%%%%%
% Data to fit is scott data where ribosomal fraction is measured (nutrient
% and chloramphenicol 2D
%
% TWO parameters are fitted: q, delta = a/fR
% sigma is taken to be 10.8 per hr according to kelong of Dai et al. (22 aa per s)
% and the number of aas in ribosomes (7336 aas)
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

sigma = 10.8; % because 22 aa / s and 7336 aas per ribosomes (Dai et al)
x_best = fminsearch(@(x)simulate_scott_and_compute_cost_coreg(x,sigma), [0.01, 0.6]);
cost_best = simulate_scott_and_compute_cost_coreg(x_best, sigma);
comp_data = simulate_scott_coreg(x_best, sigma);

%%% write in table if not done
if ~exist('../results-data/resXX_scott-2010-fit_coreg/summary-best-pars.csv','file')
    delta = x_best(1);
    q = x_best(2);
    scott_fit_best_pars = table(delta, q, cost_best);
    writetable(scott_fit_best_pars, '../results-data/resXX_scott-2010-fit_coreg/summary-best-pars.csv');
else
    scott_fit_best_pars = readtable('../results-data/resXX_scott-2010-fit_coreg/summary-best-pars.csv');
    scott_fit_best_pars.delta(end+1,1) = x_best(1);
    scott_fit_best_pars.q(end,1) = x_best(2);
    scott_fit_best_pars.cost_best(end,1) = cost_best;
    writetable(scott_fit_best_pars, '../results-data/resXX_scott-2010-fit_coreg/summary-best-pars.csv');
end


end


function composition_data = simulate_scott_coreg(x,sigma)
% order: delta, q
pars.sigma = sigma; 
pars.delta = x(1);
pars.q = x(2);
% scott nut x cm and nut x useless data 
mod_data = readtable('../external-data/scott_2010_data.csv');
composition_data = compute_cell_composition_from_growth_modulation_coreg(pars, mod_data);
end


function cost = simulate_scott_and_compute_cost_coreg(x,sigma)
x
comp_data = simulate_scott_coreg(x,sigma);
if isempty(comp_data)
    cost = 1e300;
    return;
end
comp_data_nut_cm = comp_data(comp_data.useless_type==0 & ~isnan(comp_data.measured_R_P_ratio),:);
delta_fR_vec = comp_data_nut_cm.estim_ribosomal_fraction_dai - comp_data_nut_cm.model_fR;
cost = mean(delta_fR_vec.^2);
comp_data_useless = comp_data(comp_data.useless_type>0,:);
delta_fU_vec = comp_data_useless.estim_useless_fraction - comp_data_useless.model_fU;
cost = cost + mean(delta_fU_vec.^2);
% penalize too low max growth rate
cell_pars.biophysical.sigma = sigma;
cell_pars.constraint.delta = x(1);
cell_pars.constraint.q = x(2);
cell_pars.allocation.fU = 0;
env_pars.ri = 0;
env_pars.k = 1e12;
ss_k_inf = give_steady_state_coreg(cell_pars,env_pars);
if ss_k_inf.alpha < 2.4
    disp('max growth rate too low...')
    cost = cost + 10*(2.4 - ss_k_inf.alpha)^2;
end
log(cost)
end