
function cm_kon = fit_cm_kon_from_alpha_coreg_high_delta(cell_pars,env_pars,alpha_to_fit)
% returns empty if not possible
env_pars.cm_kon = fminsearch(@(cm_kon)cost_fit_cm_kon_from_alpha(cm_kon,cell_pars,env_pars,alpha_to_fit), cell_pars.cm_koff);
ss = give_steady_state_coreg_high_delta(cell_pars,env_pars);
if abs(ss.alpha-alpha_to_fit)/alpha_to_fit > 0.01
    error('cannot fit cm kon');
else
    cm_kon = env_pars.cm_kon;
end
end

function C = cost_fit_cm_kon_from_alpha(cm_kon,cell_pars,env_pars,alpha_to_fit)
env_pars.cm_kon = cm_kon;
ss = give_steady_state_coreg_high_delta(cell_pars,env_pars);
if isempty(ss)
    C = 1e300;
    return;
end
C = (alpha_to_fit-ss.alpha)^2;
end