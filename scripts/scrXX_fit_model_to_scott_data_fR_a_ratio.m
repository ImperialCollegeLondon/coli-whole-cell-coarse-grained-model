
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

function comp_data = scrXX_fit_model_to_scott_data_fR_a_ratio()

%%% various paths needed
addpath('../utils-code'); % for sobol
addpath('../model-code');
addpath('../model-code/steady-state'); % to compute optimal allocation for each condition

%%% parameters of the sobol exploration
log_sigma_min = -1;
q_min = 0.3; q_max = 0.7;
deltas = [0.001, 0.01, ...
    0.1, 0.2, ...
    0.5, 1.0];
log_sigma_max = log(200) .* ones(size(deltas));
minimum_max_alpha = log(2)/0.25; % 15 minutes doubling time

%%% perform sobol exploration
for i_delta = 1:length(deltas)
    file_path = ['../results-data/resXX_scott-2010-fit_fR_a_ratio/sobol-exploration_delta-' num2str(deltas(i_delta)) '.mat'];
    do_sobol_explo(file_path, 50, 2000, @(x)(simulate_scott_fR_a_ratio(x, minimum_max_alpha)), [log_sigma_min, deltas(i_delta), q_min], [log_sigma_max(i_delta), deltas(i_delta), q_max]);
end

%%% compute cost and save as csv file
for i_delta = 1:length(deltas)
    file_path = ['../results-data/resXX_scott-2010-fit_fR_a_ratio/sobol-exploration_delta-' num2str(deltas(i_delta)) '.mat'];
    explo = load(file_path);
    explo_csv_with_cost = sobol_to_csv_with_cost(explo.explo.data);
    explo_csv_with_cost(isnan(explo_csv_with_cost.goodness_fit),:) = [];
    writetable(explo_csv_with_cost, ['../results-data/resXX_scott-2010-fit_fR_a_ratio/sobol-exploration-with-cost_delta-' num2str(deltas(i_delta)) '.csv']);
end

%%% load back, extract
cost_best_sobol = zeros(length(deltas),1); sigma_best_sobol = zeros(length(deltas),1); q_best_sobol = zeros(length(deltas),1);
cost_best_local = zeros(length(deltas),1); sigma_best_local = zeros(length(deltas),1); q_best_local = zeros(length(deltas),1);
for i_delta = 1:length(deltas)
    data = readtable(['../results-data/resXX_scott-2010-fit_fR_a_ratio/sobol-exploration-with-cost_delta-' num2str(deltas(i_delta)) '.csv']);
    [cost_best_sobol(i_delta), I] = min(data.log_goodness_fit);
    sigma_best_sobol(i_delta) = data.sigma(I);
    q_best_sobol(i_delta) = data.q(I);
    % start local search from this best (a_sat still fixed) except if done
    % already
    if ~exist('../results-data/resXX_scott-2010-fit_fR_a_ratio/summary-best-pars.csv','file')
        x_local_best = fminsearch(@(x)(simulate_scott_and_compute_cost_delta_fixed(x,deltas(i_delta),minimum_max_alpha)),[sigma_best_sobol(i_delta), q_best_sobol(i_delta)]);
        cost_best_local(i_delta) = log(simulate_scott_and_compute_cost_delta_fixed(x_local_best, deltas(i_delta), minimum_max_alpha));
        sigma_best_local(i_delta) = x_local_best(1);
        q_best_local(i_delta) = x_local_best(2);
    else
        scott_fit_best_pars = readtable('../results-data/resXX_scott-2010-fit_fR_a_ratio/summary-best-pars.csv');
        cost_best_local = scott_fit_best_pars.cost_best_local;
        sigma_best_local = scott_fit_best_pars.sigma_best_local;
        q_best_local = scott_fit_best_pars.q_best_local;
    end
end

%%% write in table if not done
if ~exist('../results-data/resXX_scott-2010-fit_fR_a_ratio/summary-best-pars.csv','file')
    delta = deltas';
    scott_fit_best_pars = table(delta, sigma_best_sobol, q_best_sobol, cost_best_sobol, sigma_best_local, q_best_local, cost_best_local);
    writetable(scott_fit_best_pars, '../results-data/resXX_scott-2010-fit_fR_a_ratio/summary-best-pars.csv');
end

%%% also compute the composition for scott data of all local best and write
%%% it
for i_delta = 1:length(deltas)
    pars.sigma = sigma_best_local(i_delta);
    pars.delta = deltas(i_delta);
    pars.q = q_best_local(i_delta);
    mod_data = readtable('../external-data/scott_2010_data.csv');
    mod_data = mod_data(mod_data.useless_type==0, :);
    composition_data = compute_cell_composition_from_growth_modulation_fR_a_ratio(pars, mod_data);
    writetable(composition_data,['../results-data/resXX_scott-2010-fit_fR_a_ratio/scott-predictions_local-fixed-asat-fit_asat-' num2str(deltas(i_delta)) '.csv']);
end


end


function composition_data = simulate_scott_fR_a_ratio(x, minimum_max_alpha)
% order: sigma(!log!), delta, q
pars.sigma = exp(x(1));
pars.delta = x(2);
pars.q = x(3);
% check if max growth rate high enough, otherwise don't do sim and return
% empty array
cell_pars.biophysical.sigma = pars.sigma;
cell_pars.constraint.q = pars.q;
cell_pars.constraint.delta = pars.delta;
max_alpha = give_alpha_max_imposed_fR_a_ratio(cell_pars);
if max_alpha < minimum_max_alpha
    composition_data = [];
    return;
end
% scott nut x cm data
mod_data = readtable('../external-data/scott_2010_data.csv');
mod_data = mod_data( mod_data.useless_type==0, :);
composition_data = compute_cell_composition_from_growth_modulation_fR_a_ratio(pars, mod_data);
end

function sobol_csv = sobol_to_csv_with_cost(d)
sigma = zeros(length(d),1);
delta = zeros(length(d),1);
q = zeros(length(d),1);
goodness_fit = nan(length(d),1);
log_goodness_fit = nan(length(d),1);
a_max = nan(length(d),1);
for i=1:length(d)
    sigma(i) = exp(d(i).x(1)); % ! log !
    delta(i) = d(i).x(2);
    q(i) = d(i).x(3);
    sim_scott = d(i).fx;
    if ~isempty(sim_scott)
        delta_fR_vec = sim_scott.estim_ribosomal_fraction - sim_scott.model_fR;
        goodness_fit(i) = mean(delta_fR_vec.^2);
        log_goodness_fit(i) = log(goodness_fit(i));
        a_max(i) = max(sim_scott.model_a);
    end
end
sobol_csv = table(sigma,delta,q,goodness_fit,log_goodness_fit,a_max);
end

function cost = simulate_scott_and_compute_cost_delta_fixed(x, delta, minimum_max_alpha)
xx = [x(1), delta, x(2)]
xx(1) = log(xx(1)); % because now sigma in log
comp_data = simulate_scott_fR_a_ratio(xx, minimum_max_alpha);
if isempty(comp_data)
    cost = 1e300;
    return;
end
delta_fR_vec = comp_data.estim_ribosomal_fraction - comp_data.model_fR;
cost = mean(delta_fR_vec.^2);
log(cost)
end