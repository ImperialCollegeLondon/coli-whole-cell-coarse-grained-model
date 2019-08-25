
%%%%%
% Data to fit is scott data where ribosomal fraction is measured (nutrient
% and chloramphenicol 2D
%
% TWO parameters are fitted: q, delta = a/fR
% sigma is taken to be 6.47 per hr according to kelong of Dai et al. (22 aa per s)
% and the number of aas in extended ribosomes (7336 aas * 1.67)
%
% For each point, we simulate the scott nutrient x chloramphenicol and
% similar data from dai and compute the mean square error between model and data
% ribosomal fraction
%
% we don't explore points for which the maximum growth rate (k->infinity)
% is less that 15 minutes doubling time
%
%%%%%

function pars = scrXX_fit_coreg_low_delta_model_to_scott_and_dai_data()

%%% various paths needed
addpath('../model-code');
addpath('../model-code/steady-state_coreg-low-delta');


% pars = readtable('sigma-fixed-delta-varied-q-fitted.csv');
% for i=1:size(pars,1)
%     this_pars = pars(i,:);
%     [~,pars.cost_fR(i),pars.cost_useless(i),pars.cost_elong(i),pars.cost_active_rib_frac(i), pars.cost_max_growth_rate(i)] = ...
%         simulate_scott_dai_and_compute_cost_coreg(this_pars.param_q_best,this_pars.param_sigma,this_pars.param_delta);
%     pars(i,:)
% end


sigma = 6.47; % because 22 aa / s and 7336 aas per ribosomes (Dai et al) / 1.67 (extended ribosome)
K = 0.11 * 0.76; % because 0.11 from Dai elong rate vs R/P Km and 0.76 because conversion from R/P to fR (extended rib Scott)
%delta = 0.1;

fQ = fminsearch(@(fQ)(simulate_scott_dai_and_compute_cost_coreg_low_delta(fQ,sigma,K)), 0.4);

end


function composition_data = simulate_scott_dai_coreg_low_delta(fQ,sigma,K)
pars.sigma = sigma; 
pars.fQ = fQ;
pars.K = K;
mod_data = readtable('../external-data/scott_2010_data.csv');
composition_data = compute_cell_composition_from_growth_modulation_coreg_low_delta(pars, mod_data);
mod_data = readtable('../external-data/dai_2016_data.csv');
composition_data = [composition_data ; compute_cell_composition_from_growth_modulation_coreg_low_delta(pars, mod_data)];
end


function [cost,cost_fR,cost_useless,cost_elong,cost_active_rib_frac, cost_max_growth_rate] = simulate_scott_dai_and_compute_cost_coreg_low_delta(fQ,sigma,K)
fQ
comp_data = simulate_scott_dai_coreg_low_delta(fQ,sigma,K);
if isempty(comp_data)
    cost = 1e300;
    return;
end
% fR agreement
comp_data_nut_cm = comp_data(comp_data.useless_type==0 & ~isnan(comp_data.measured_R_P_ratio),:);
delta_fR_vec = comp_data_nut_cm.estim_ribosomal_fraction_scott - comp_data_nut_cm.model_fR;
cost_fR = mean(delta_fR_vec.^2);
% useless agreement
comp_data_useless = comp_data(comp_data.useless_type>0,:);
delta_fU_vec = comp_data_useless.estim_useless_fraction - comp_data_useless.model_fU;
cost_useless = mean(delta_fU_vec.^2);
% cost translation elongation
comp_data_elong_rate = comp_data(~isnan(comp_data.translation_elong_rate_aa_s),:);
delta_elong_rate = comp_data_elong_rate.translation_elong_rate_aa_s./22 - (comp_data_elong_rate.model_fR ./ (comp_data_elong_rate.model_fR + K));
cost_elong = mean(delta_elong_rate.^2);
% cost active rib
delta_active_rib_frac = comp_data_elong_rate.fraction_active_rib_equivalent - comp_data_elong_rate.model_active_rib_frac;
cost_active_rib_frac = mean(delta_active_rib_frac.^2);
% penalize too low max growth rate
cell_pars.sigma = sigma;
cell_pars.K = K;
cell_pars.fQ = fQ;
cell_pars.fU = 0;
env_pars.fRI = 0;
env_pars.k = 1e12;
ss_k_inf = give_steady_state_coreg_low_delta(cell_pars,env_pars);
cost_max_growth_rate = 0;
if ss_k_inf.alpha < 2.4
    disp('max growth rate too low...')
    cost_max_growth_rate = 100 * (2.4 - ss_k_inf.alpha)^2;
end
cost = cost_fR + cost_useless + cost_elong + cost_active_rib_frac + cost_max_growth_rate;
log(cost)
end