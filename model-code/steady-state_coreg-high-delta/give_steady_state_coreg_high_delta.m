
function [steady_state,cell_pars] = give_steady_state_coreg_high_delta(cell_pars, env_pars)

fR_min = env_pars.fRI;
fR_max = 1 - cell_pars.fQ - cell_pars.fU;
sigma_k_ratio = cell_pars.sigma / env_pars.k;

steady_state.fR = fminbnd(@(fR)(cost_find_fR(fR,sigma_k_ratio, env_pars.fRI, cell_pars.K, cell_pars.fQ, cell_pars.fU)), fR_min, fR_max);
steady_state.fE = 1-cell_pars.fQ-steady_state.fR-cell_pars.fU;

if (steady_state.fE > steady_state.fR)
    steady_state.alpha = env_pars.k * steady_state.fE;
else
    steady_state.alpha = cell_pars.sigma * (steady_state.fR - env_pars.fRI) * steady_state.fR / (steady_state.fR + cell_pars.K);
end

C = cost_find_fR(steady_state.fR,sigma_k_ratio, env_pars.fRI, cell_pars.K, cell_pars.fQ, cell_pars.fU);

if (C>1e-4)
    C
    error('could not find fR coreg low delta model ?!!');
end

end

function C = cost_find_fR(fR, sigma_k_ratio, fRI, K, fQ, fU)
fE_prot = 1 - fQ - fU - fR;
fE_bal = sigma_k_ratio * (fR - fRI) * fR / (fR + K);
C = (fE_prot-fE_bal)^2;
end