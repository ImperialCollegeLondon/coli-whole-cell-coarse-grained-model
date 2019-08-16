function fU = fit_fU_from_alpha_scott_2010_model(cell_pars, env_pars, alpha_to_fit)

cell_pars.fU = exp(fminsearch(@(fU_log)cost_fit_fU_from_alpha(fU_log,cell_pars,env_pars,alpha_to_fit),log((1-cell_pars.fR_max)/2)));
% test the result of the search, should give the good growth rate (with 1% tolerance)
ss = give_steady_state_scott_2010_model(cell_pars,env_pars);
if abs(ss.alpha-alpha_to_fit)/alpha_to_fit > 0.01
    ss
    fU = [];
else
    fU = cell_pars.fU;
end


end

function C = cost_fit_fU_from_alpha(fU_log,cell_pars,env_pars,alpha_to_fit)
cell_pars.fU = exp(fU_log);
ss = give_steady_state_scott_2010_model(cell_pars,env_pars);
if ss.alpha == 0
    C = 1e300;
    return;
end
C = (alpha_to_fit-ss.alpha)^2;
end