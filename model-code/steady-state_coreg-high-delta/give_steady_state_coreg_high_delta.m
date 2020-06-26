
function [steady_state,cell_pars] = give_steady_state_coreg_high_delta(cell_pars, env_pars)

fR_max = 1 - cell_pars.fQ - cell_pars.fU;

steady_state.fR = fminbnd(@(fR)cost_find_fR(fR, cell_pars.sigma, env_pars.k, cell_pars.K, cell_pars.fQ, cell_pars.fU, env_pars.cm_kon, cell_pars.cm_koff), 0, fR_max);
steady_state.fE = 1-cell_pars.fQ-steady_state.fR-cell_pars.fU;

steady_state.alpha = env_pars.k * steady_state.fE;

steady_state.active_rib_frac = (cell_pars.cm_koff + steady_state.alpha) / (cell_pars.cm_koff + steady_state.alpha + env_pars.cm_kon);

C = cost_find_fR(steady_state.fR, cell_pars.sigma, env_pars.k, cell_pars.K, cell_pars.fQ, cell_pars.fU, env_pars.cm_kon, cell_pars.cm_koff);

if (C>1e-4)
    C
    error('could not find fR coreg high   delta model ?!!');
end

end

function C = cost_find_fR(fR, sigma, k, K, fQ, fU, cm_kon, cm_koff)
left_term = fR * sigma * fR / (fR + K);
fE = 1 - fQ - fU - fR;
right_term = k * fE * (1 + cm_kon / (cm_koff + k*fE));
C = (left_term-right_term)^2;
end