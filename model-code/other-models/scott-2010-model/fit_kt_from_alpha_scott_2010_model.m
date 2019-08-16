function kt = fit_kt_from_alpha_scott_2010_model(cell_pars, env_pars, alpha_to_fit)

env_pars.kt = exp(fminsearch(@(kt_log)cost_fit_kt_from_alpha(kt_log,cell_pars,env_pars,alpha_to_fit),log(env_pars.kn)));
% test the result of the search, should give the good growth rate (with 1% tolerance)
ss = give_steady_state_scott_2010_model(cell_pars,env_pars);
if abs(ss.alpha-alpha_to_fit)/alpha_to_fit > 0.01
    ss
    kt = [];
else
    kt = env_pars.kt;
end


end

function C = cost_fit_kt_from_alpha(kt_log,cell_pars,env_pars,alpha_to_fit)
env_pars.kt = exp(kt_log);
ss = give_steady_state_scott_2010_model(cell_pars,env_pars);
if ss.alpha == 0
    C = 1e300;
    return;
end
C = (alpha_to_fit-ss.alpha)^2;
end