function [steady_state, cell_pars] = give_optim_steady_state(cell_pars, env_pars)

cell_pars.fR = fminbnd(@(fR)cost_fun(fR, cell_pars, env_pars), 0, 1 - cell_pars.fQ - cell_pars.fU);
cell_pars.fE = 1 - cell_pars.fR - cell_pars.fQ - cell_pars.fU;
steady_state = give_steady_state_from_allocation(cell_pars, env_pars);


end

function C = cost_fun(fR, cell_pars, env_pars)

cell_pars.fR = fR;
cell_pars.fE = 1 - cell_pars.fR - cell_pars.fQ - cell_pars.fU;
ss = give_steady_state_from_allocation(cell_pars, env_pars);
C = - ss.alpha;

end