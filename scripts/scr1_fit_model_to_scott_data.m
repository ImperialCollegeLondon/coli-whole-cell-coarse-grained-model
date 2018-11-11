
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

%%% various paths needed
addpath('../utils-code'); % for sobol
addpath('../model-code');
addpath('../model-code/steady-state'); % to compute optimal allocation for each condition

%%% parameters of the sobol exploration
log_sigma_min = -1;
q_min = 0.3; q_max = 0.7;
a_sats = [0.001, 0.002, 0.005, 0.01, ...
    0.02, 0.05, 0.1, 0.2, ...
    0.5, 1.0, 2.0, 5.0];
log_sigma_max = log(200) .* ones(size(a_sats));
minimum_max_alpha = log(2)/0.25; % 15 minutes doubling time

%%% perform sobol exploration
for i_a = 1:length(a_sats)
    file_path = ['../results-data/res1_scott-2010-fit/sobol-exploration_asat-' num2str(a_sats(i_a)) '.mat'];
    do_sobol_explo(file_path, 50, 2000, @(x)(simulate_scott(x, minimum_max_alpha)), [log_sigma_min, a_sats(i_a), q_min], [log_sigma_max(i_a), a_sats(i_a), q_max]);
end

%%% compute cost and save as csv file
for i_a = 1:length(a_sats)
    file_path = ['../results-data/res1_scott-2010-fit/sobol-exploration_asat-' num2str(a_sats(i_a)) '.mat'];
    explo = load(file_path);
    explo_csv_with_cost = sobol_to_csv_with_cost(explo.explo.data);
    explo_csv_with_cost(isnan(explo_csv_with_cost.goodness_fit),:) = [];
    writetable(explo_csv_with_cost, ['../results-data/res1_scott-2010-fit/sobol-exploration-with-cost_asat-' num2str(a_sats(i_a)) '.csv']);
end

%%% load back, extract
cost_best_sobol = zeros(length(a_sats),1); sigma_best_sobol = zeros(length(a_sats),1); q_best_sobol = zeros(length(a_sats),1);
cost_best_local = zeros(length(a_sats),1); sigma_best_local = zeros(length(a_sats),1); q_best_local = zeros(length(a_sats),1);
for i_a = 1:length(a_sats)
    data = readtable(['../results-data/res1_scott-2010-fit/sobol-exploration-with-cost_asat-' num2str(a_sats(i_a)) '.csv']);
    [cost_best_sobol(i_a), I] = min(data.log_goodness_fit);
    sigma_best_sobol(i_a) = data.sigma(I);
    q_best_sobol(i_a) = data.q(I);
    % start local search from this best (a_sat still fixed) except if done
    % already
    if ~exist('../results-data/res1_scott-2010-fit/summary-best-pars.csv','file')
        x_local_best = fminsearch(@(x)(simulate_scott_and_compute_cost_asat_fixed(x,a_sats(i_a),minimum_max_alpha)),[sigma_best_sobol(i_a), q_best_sobol(i_a)]);
        cost_best_local(i_a) = log(simulate_scott_and_compute_cost_asat_fixed(x_local_best, a_sats(i_a), minimum_max_alpha));
        sigma_best_local(i_a) = x_local_best(1);
        q_best_local(i_a) = x_local_best(2);
    else
        scott_fit_best_pars = readtable('../results-data/res1_scott-2010-fit/summary-best-pars.csv');
        cost_best_local = scott_fit_best_pars.cost_best_local;
        sigma_best_local = scott_fit_best_pars.sigma_best_local;
        q_best_local = scott_fit_best_pars.q_best_local;
    end
end

%%% write in table if not done
if ~exist('../results-data/res1_scott-2010-fit/summary-best-pars.csv','file')
    a_sat = a_sats';
    scott_fit_best_pars = table(a_sat, sigma_best_sobol, q_best_sobol, cost_best_sobol, sigma_best_local, q_best_local, cost_best_local);
    writetable(scott_fit_best_pars, '../results-data/res1_scott-2010-fit/summary-best-pars.csv');
end

%%% also compute the composition for scott data of all local best and write
%%% it
for i_a = 1:length(a_sats)
    pars.sigma = sigma_best_local(i_a);
    pars.a_sat = a_sats(i_a);
    pars.q = q_best_local(i_a);
    mod_data = readtable('../external-data/scott_2010_data.csv');
    mod_data = mod_data(mod_data.useless_type==0, :);
    composition_data = compute_cell_composition_from_growth_modulation(pars, mod_data);
    writetable(composition_data,['../results-data/res1_scott-2010-fit/scott-predictions_local-fixed-asat-fit_asat-' num2str(a_sats(i_a)) '.csv']);
end

% %%%
%
% %%%
% figure(2);
% for i_a=1:length(a_sats)
%     data = readtable(['../results-data/res1_scott-2010-fit/sobol-exploration-with-cost_asat-' num2str(a_sats(i_a)) '.csv']);
%     subplot(3,4,i_a);
%     scatter(data.sigma, data.q, [], data.log_goodness_fit);
%     title(['a_{sat} = ' num2str(a_sats(i_a))]);
%     colorbar;
% end



%%% find best parameter set and output in table
% sigma = 6.1538;
% a_sat = 0.0214;
% q = 0.466;
% fit_pars_table = table(sigma, a_sat, q);
% writetable(fit_pars_table, '../results-data/scott-2010-fit/fitted-parameters_proteome-allocation.csv');

end


function composition_data = simulate_scott(x, minimum_max_alpha)
% order: sigma(!log!), a_sat, q
pars.sigma = exp(x(1));
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
    sigma(i) = exp(d(i).x(1)); % ! log !
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

function cost = simulate_scott_and_compute_cost_asat_fixed(x, a_sat, minimum_max_alpha)
xx = [x(1), a_sat, x(2)]
xx(1) = log(xx(1)); % because now sigma in log
comp_data = simulate_scott(xx, minimum_max_alpha);
if isempty(comp_data)
    cost = 1e300;
    return;
end
delta_fR_vec = comp_data.estim_ribosomal_fraction - comp_data.model_fR;
cost = mean(delta_fR_vec.^2);
log(cost)
end