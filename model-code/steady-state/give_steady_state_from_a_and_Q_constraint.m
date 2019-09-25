function [steady_state,cell_pars] = give_steady_state_from_a_and_Q_constraint(a, cell_pars, env_pars)

% compute fQ, check
% two cases, q or allocation fixed fQ
if isfield(cell_pars.constraint,'q')
    fQ = cell_pars.constraint.q / (1-a);
else
    fQ = cell_pars.allocation.fQ;
end
if fQ > 1
    steady_state.alpha = 0;
    return;
end

% compute fRE = fR + fE
fER = 1 - fQ - cell_pars.allocation.fU;
% check possible with ri
if fER < env_pars.ri / (1-a)
    steady_state.alpha = 0;
    return;
end

% compute fE (general case first)
if cell_pars.biophysical.a_sat > 0
    fE_top = (fER - env_pars.ri / (1-a) ) * (cell_pars.biophysical.sigma/env_pars.k) * 1 / (1-a) * a / (a+cell_pars.biophysical.a_sat) ;
    fE_bottom = 1 + (cell_pars.biophysical.sigma/env_pars.k) * 1 / (1-a) * a / (a+cell_pars.biophysical.a_sat) ;
    fE = fE_top / fE_bottom;
else % special case a_sat = 0
    fE_top = (fER - env_pars.ri / (1-a) ) * (cell_pars.biophysical.sigma/env_pars.k) * 1 / (1-a);
    fE_bottom = 1 + (cell_pars.biophysical.sigma/env_pars.k) * 1 / (1-a);
    fE = fE_top / fE_bottom;
end
% compute fR (not needed just for growth rate)
fR = fER - fE;
% compute all concentrations and then growth rate
steady_state.a = a;
steady_state.e = fE * (1-a);
steady_state.r = fR * (1-a);
steady_state.ra = steady_state.r - env_pars.ri;
steady_state.q = fQ * (1-a);
steady_state.u = cell_pars.allocation.fU * (1-a);
steady_state.alpha = env_pars.k * steady_state.e;
% for convenience, also put allocations in the steady-state..
steady_state.fQ = fQ;
steady_state.fE = fE;
steady_state.fR = fR;
steady_state.fRA = fR * steady_state.ra / steady_state.r;
steady_state.fU = cell_pars.allocation.fU;
% store allocation results in the returned cell pars as well
cell_pars.allocation.fQ = fQ;
cell_pars.allocation.fE = fE;
cell_pars.allocation.fR = fR;
cell_pars.allocation.fRA = fR * steady_state.ra / steady_state.r;

end