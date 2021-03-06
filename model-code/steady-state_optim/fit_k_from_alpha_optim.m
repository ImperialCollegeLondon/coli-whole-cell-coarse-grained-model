function k = fit_k_from_alpha_optim(cell_pars,env_pars,alpha_to_fit)

% returns [] when not possible
% suppressed lack of convergence warnings
options = optimset('Display','on','MaxFunEvals',10^9);
env_pars.k = fminsearch(@(k)cost_fit_k_from_alpha(k,cell_pars,env_pars,alpha_to_fit),cell_pars.biophysical.sigma/cell_pars.biophysical.a_sat,options);
% test the result of the search, should give the good growth rate (with 1% tolerance)
ss = give_optim_steady_state_from_Q_constraint(cell_pars,env_pars);
if abs(ss.alpha-alpha_to_fit)/alpha_to_fit > 0.01
    disp('could not find k giving desired growth rate ?');
    disp(['desired: ' num2str(alpha_to_fit) ' / obtained: ' num2str(ss.alpha)]);
    k = [];
else
    k = env_pars.k;
end
end


function C = cost_fit_k_from_alpha(k,cell_pars,env_pars,alpha_to_fit)
if k < 0
    C = 1e300; 
    return;
end
env_pars.k = k;
ss = give_optim_steady_state_from_Q_constraint(cell_pars,env_pars);
C = (alpha_to_fit-ss.alpha)^2;
end