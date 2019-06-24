
function [steady_state,cell_pars] = give_steady_state_coreg_strict(cell_pars, env_pars)

addpath('../steady-state/');

% find the maximum a allowing constraints to be respected
a_max = 1 - (cell_pars.constraint.q + env_pars.ri) / (1 - cell_pars.allocation.fU);
if a_max < 0
    steady_state.alpha = 0;
    return;
end

% compute the equivalent a_sat
delta_to_asat = 0.0836; % from dai et al. MM elong vs R/P Km and the R/P vs fR ratio from Scott et al.
cell_pars.biophysical.a_sat = cell_pars.constraint.delta * delta_to_asat;

% first, find the minimal a/fR ratio over possible steady-state
a1 = fminbnd(@(a)(cost_a_fR_min(a, cell_pars, env_pars)), 0, a_max);
ss1 = give_steady_state_from_a_and_Q_constraint(a1, cell_pars, env_pars);
a_over_fR_min = ss1.a/ss1.fR;

% same for maximal a/fR ratio
a2 = fminbnd(@(a)(cost_a_fR_max(a, cell_pars, env_pars)), 0, a_max);
ss2 = give_steady_state_from_a_and_Q_constraint(a2, cell_pars, env_pars);
a_over_fR_max = ss2.a/ss2.fR;

% check if compatible with the desired a/fR ratio
if cell_pars.constraint.delta < a_over_fR_min
    disp('miminal a/fR ratio higher than delta... increasing ri to do that...');
    
    steady_state.alpha = 0;
    return;
end
if cell_pars.constraint.delta > a_over_fR_max
    error('maximal a/fR ratio lower than delta ?');
end

% find the steady-state that respect the ratio
a_log = fminbnd(@(a_log)(cost_a_fR_good_ratio(a_log, cell_pars, env_pars)), log(a1), log(a2));
C = cost_a_fR_good_ratio(a_log, cell_pars, env_pars);
if C > 1e-6
    error('could not find steady state matching a/fR ratio ?');
end
a = exp(a_log);

% return this steady state
[steady_state,cell_pars] = give_steady_state_from_a_and_Q_constraint(a,cell_pars,env_pars);

end


function C = cost_a_fR_min(a, cell_pars, env_pars)
ss = give_steady_state_from_a_and_Q_constraint(a, cell_pars, env_pars);
C = ss.a/ss.fR;
end

function C = cost_a_fR_max(a, cell_pars, env_pars)
ss = give_steady_state_from_a_and_Q_constraint(a, cell_pars, env_pars);
C = -ss.a/ss.fR;
end

function C = cost_a_fR_good_ratio(a_log, cell_pars, env_pars)
a = exp(a_log);
ss = give_steady_state_from_a_and_Q_constraint(a, cell_pars, env_pars);
C = (ss.a/ss.fR - cell_pars.constraint.delta)^2;
end
