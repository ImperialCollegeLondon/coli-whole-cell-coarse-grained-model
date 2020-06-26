


function [asat, delta] = mod1_1sup3_find_asat_based_on_best_delta()

addpath('../model-code/deterministic-dynamics/');

cell_pars.sigma = 1 / (7336 * 1.67 / 22) * 3600; % in hr-1. set from Dai et al max elong rate (22 aa/s), and extended ribosome AA number (7336 * 1.67)
cell_pars.fQ = 0.5;

env_pars.ri = 0;
cell_pars.fU = 0;
cell_pars.fX = 0.1;
cell_pars.fQ = cell_pars.fQ - cell_pars.fX; % guarantee fX + fQ det = 'fQ' ss
cell_pars.X_div = 70;

env_pars.k = 3.53;

asat = fminsearch(@(x)cost_find_asat(x, cell_pars, env_pars), 0.01)
cell_pars.a_sat = asat;
delta = find_best_delta_from_asat_k_fixed(cell_pars, env_pars)

% with k = 3.53 -> delta = 1.21 and asat = 0.0688
% with k = 100 -> delta = 1.22 and asat = 0.0684
% with k = 0.1 -> delta = 0.65 and asat = 0.12

end

function C = cost_find_asat(asat, cell_pars, env_pars)
cell_pars.a_sat = asat;
best_delta = find_best_delta_from_asat_k_fixed(cell_pars, env_pars);
K = best_delta * cell_pars.a_sat
K_to_match = 0.11 * 0.76; % in units of extended ribosome mass fraction. from Dai et al. Km in R/P unit converted to Scott extended ribosome unit
C = (K-K_to_match)^2;
end
