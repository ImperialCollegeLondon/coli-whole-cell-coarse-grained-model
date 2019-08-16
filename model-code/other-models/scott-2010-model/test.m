

cell_pars.rho = 0.76;
r0 = 0.087;
cell_pars.fR_0 = r0 * cell_pars.rho;
cell_pars.fR_max = 0.55;
cell_pars.fU = 0;
cell_pars.kt_max = 4.5;

env_pars.kt = 1.0 * cell_pars.kt_max;
env_pars.kn = 3;

ss = give_steady_state_scott_2010_model(cell_pars, env_pars);

kn = fit_kn_from_alpha_scott_2010_model(cell_pars, env_pars, ss.alpha)
kt = fit_kt_from_alpha_scott_2010_model(cell_pars, env_pars, ss.alpha/2)
fU = fit_fU_from_alpha_scott_2010_model(cell_pars, env_pars, ss.alpha/2)
