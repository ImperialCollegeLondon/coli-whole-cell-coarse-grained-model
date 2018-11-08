
%%%%%
% Data to fit is scott data where ribosomal fraction is measured (nutrient
% and chloramphenicol 2D 
%
% Three parameters are fitted: sigma, a_sat and q.
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

function scr1_fit_model_to_scott_data()

%%% parameters of the sobol exploration
sigma_min = 0; sigma_max = 20;
a_sat_min = 0; a_sat_max = 10;
q_min = 0.3; q_max = 0.7;
minimum_max_alpha = log(2)/0.25;

%%% various paths needed
addpath('../utils-code'); % for sobol
addpath('../model-code/steady-state'); % to compute optimal allocation for each condition


%%% perform sobol exploration
sobol_file_path = '../results-data/res1_scott-2010-fit/sobol-exploration.mat';
do_sobol_explo(sobol_file_path, 1000, 145000, @(x)(simulate_scott(x, minimum_max_alpha)), [sigma_min, a_sat_min, q_min], [sigma_max, a_sat_max, q_max]);

%%% compute cost and format in csv
explo = load(sobol_file_path);
explo_csv_with_cost = sobol_to_csv_with_cost(explo.explo.data);
explo_csv_with_cost(isnan(explo_csv_with_cost.goodness_fit),:) = [];
writetable(explo_csv_with_cost, '../results-data/res1_scott-2010-fit/sobol-exploration-with-cost.csv');

%%% find best parameter set and output in table
% sigma = 6.1538;
% a_sat = 0.0214;
% q = 0.466;
% fit_pars_table = table(sigma, a_sat, q);
% writetable(fit_pars_table, '../results-data/scott-2010-fit/fitted-parameters_proteome-allocation.csv');

end


function composition_data = simulate_scott(x, minimum_max_alpha)
% order: sigma, a_sat, q
pars.sigma = x(1);
pars.a_sat = x(2);
pars.q = x(3);
% check if max growth rate high enough, otherwise don't do sim and return
% empty array
cell_pars.biophysical.sigma = pars.sigma; cell_pars.biophysical.a_sat = pars.a_sat; cell_pars.constraint.q = pars.q;
max_alpha = give_alpha_max(cell_pars);
if max_alpha < minimum_max_alpha
    composition_data = [];
    return;
end
% scott nut x cm data
mod_data = readtable('../external-data/scott_2010_data.csv');
mod_data = mod_data( mod_data.useless_type==0, :);
composition_data = compute_cell_composition_from_growth_modulation(pars, mod_data);
end

function sobol_csv = sobol_to_csv_with_cost(d)
sigma = zeros(length(d),1);
a_sat = zeros(length(d),1);
q = zeros(length(d),1);
goodness_fit = nan(length(d),1);
log_goodness_fit = nan(length(d),1);
a_max = nan(length(d),1);
for i=1:length(d)
    sigma(i) = d(i).x(1);
    a_sat(i) = d(i).x(2);
    q(i) = d(i).x(3);
    sim_scott = d(i).fx;
    if ~isempty(sim_scott)
        delta_fR_vec = sim_scott.estim_ribosomal_fraction - sim_scott.model_fR;
        goodness_fit(i) = mean(delta_fR_vec.^2);
        log_goodness_fit(i) = log(goodness_fit(i));
        a_max(i) = max(sim_scott.model_a);
    end
end
sobol_csv = table(sigma,a_sat,q,goodness_fit,log_goodness_fit,a_max);
end