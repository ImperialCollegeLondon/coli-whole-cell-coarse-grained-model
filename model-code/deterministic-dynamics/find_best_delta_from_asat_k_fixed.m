function delta_best = find_best_delta_from_asat_k_fixed(cell_pars, env_pars)

delta_best = fminsearch(@(x)cost_fun(x,cell_pars,env_pars), 1);

end

function C = cost_fun(delta, cell_pars, env_pars)
cell_pars.delta = delta;
% initial state
init_cell_state.A = 0;
init_cell_state.E = 3;
init_cell_state.R = 1;
init_cell_state.Q = 3;
init_cell_state.U = 0;
init_cell_state.X = 1;
% duration
duration = 50 / env_pars.k;
traj = solve_amount(init_cell_state, cell_pars, env_pars, duration);
traj.e = traj.E ./ traj.M_or_V;
C = - env_pars.k * traj.e(end);
end
