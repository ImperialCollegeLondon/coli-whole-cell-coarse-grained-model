
function fRI = fit_fRI_from_alpha_coreg_high_delta(cell_pars,env_pars,alpha_to_fit)
% returns empty if not possible
env_pars.fRI = fminbnd(@(fRI)cost_fit_ri_from_alpha(fRI,cell_pars,env_pars,alpha_to_fit),0,1-cell_pars.fQ);
ss = give_steady_state_coreg_high_delta(cell_pars,env_pars);
if abs(ss.alpha-alpha_to_fit)/alpha_to_fit > 0.01
    fRI = [];
else
    fRI = env_pars.fRI;
end
end

function C = cost_fit_ri_from_alpha(fRI,cell_pars,env_pars,alpha_to_fit)
env_pars.fRI = fRI;
ss = give_steady_state_coreg_high_delta(cell_pars,env_pars);
if isempty(ss)
    C = 1e300;
    return;
end
C = (alpha_to_fit-ss.alpha)^2;
end