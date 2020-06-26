
function ri = fit_ri_from_alpha_optim(cell_pars,env_pars,alpha_to_fit)
% returns empty if not possible
env_pars.ri = fminbnd(@(ri)cost_fit_ri_from_alpha(ri,cell_pars,env_pars,alpha_to_fit),0,1-cell_pars.constraint.q);
ss = give_optim_steady_state_from_Q_constraint(cell_pars,env_pars);
if abs(ss.alpha-alpha_to_fit)/alpha_to_fit > 0.01
    ri = [];
else
    ri = env_pars.ri;
end
end

function C = cost_fit_ri_from_alpha(ri,cell_pars,env_pars,alpha_to_fit)
env_pars.ri = ri;
ss = give_optim_steady_state_from_Q_constraint(cell_pars,env_pars);
C = (alpha_to_fit-ss.alpha)^2;
end