function k = fit_k_from_alpha_coreg(cell_pars,env_pars,alpha_to_fit)

% returns [] when not possible
% suppressed lack of convergence warnings
options = optimset('Display','off');
env_pars.k = exp(fminsearch(@(k_log)cost_fit_k_from_alpha(k_log,cell_pars,env_pars,alpha_to_fit),log(cell_pars.biophysical.sigma),options));
% test the result of the search, should give the good growth rate (with 1% tolerance)
ss = give_steady_state_coreg(cell_pars,env_pars);
if abs(ss.alpha-alpha_to_fit)/alpha_to_fit > 0.01
    ss
    k = [];
else
    k = env_pars.k;
end
end


function C = cost_fit_k_from_alpha(k_log,cell_pars,env_pars,alpha_to_fit)
% if k <= 0
%     C = 1e300;
%     return;
% end
env_pars.k = exp(k_log);
ss = give_steady_state_coreg(cell_pars,env_pars);
if env_pars.k < 1e-10
    env_pars.k
    ss
    alpha_to_fit
end
if isempty(ss)
    C = 1e300;
    return;
end
if ss.alpha == 0
    C = 1e300;
    return;
end
C = (alpha_to_fit-ss.alpha)^2;
end