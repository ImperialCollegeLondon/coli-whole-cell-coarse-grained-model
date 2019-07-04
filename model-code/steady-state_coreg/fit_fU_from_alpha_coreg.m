
function fU = fit_fU_from_alpha_coreg(cell_pars,env_pars,alpha_to_fit)
% return empty array if not possible
cell_pars.allocation.fU = fminbnd(@(fU)cost_fit_fU_from_alpha(fU,cell_pars,env_pars,alpha_to_fit),0,1);
ss = give_steady_state_coreg(cell_pars,env_pars);
if abs(ss.alpha-alpha_to_fit)/alpha_to_fit > 0.01
    fU = [];
else
    fU = cell_pars.allocation.fU;
end
end

function C = cost_fit_fU_from_alpha(fU,cell_pars,env_pars,alpha_to_fit)
cell_pars.allocation.fU = fU;
ss = give_steady_state_coreg(cell_pars,env_pars);
if isempty(ss)
    C = 1e300;
    return;
end
C = (alpha_to_fit-ss.alpha)^2;
end