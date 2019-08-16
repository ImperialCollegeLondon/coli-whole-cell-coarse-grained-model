function ss = give_steady_state_scott_2010_model(cell_pars, env_pars)

ss.alpha = (cell_pars.fR_max - cell_pars.fR_0 - cell_pars.fU) / cell_pars.rho * env_pars.kt * env_pars.kn / (env_pars.kt + env_pars.kn);

ss.fR = (cell_pars.fR_max - cell_pars.fR_0 - cell_pars.fU) * env_pars.kn / (env_pars.kt + env_pars.kn) + cell_pars.fR_0;

ss.fE = (cell_pars.fR_max - cell_pars.fR_0 - cell_pars.fU) * env_pars.kt / (env_pars.kt + env_pars.kn);

ss.fRA = ss.alpha * cell_pars.rho / env_pars.kt;
ss.active_R_frac = ss.fRA / ss.fR;

end

