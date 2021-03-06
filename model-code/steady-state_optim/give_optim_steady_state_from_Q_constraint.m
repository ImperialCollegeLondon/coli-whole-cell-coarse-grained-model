function [steady_state,cell_pars] = give_optim_steady_state_from_Q_constraint(cell_pars, env_pars)

% find the maximum a allowing constraints to be respected
a_max = 1 - (cell_pars.constraint.q + env_pars.ri) / (1 - cell_pars.allocation.fU);
if a_max < 0
    steady_state.alpha = 0;
    return;
end

% find the best a in terms of growth rate by scalar optimization
if cell_pars.biophysical.a_sat == 0 % trivial case
    a_best = 0;
else % general case
    a_best = fminbnd(@(a)(costfun_growth_rate_maximization_from_a_Q_constraint(a, cell_pars, env_pars)), 0, a_max);
end

[steady_state,cell_pars] = give_steady_state_from_a_and_Q_constraint(a_best, cell_pars, env_pars);

end

function C = costfun_growth_rate_maximization_from_a_Q_constraint(a, cell_pars, env_pars)
steady_state = give_steady_state_from_a_and_Q_constraint(a, cell_pars, env_pars);
C = -steady_state.alpha;
end