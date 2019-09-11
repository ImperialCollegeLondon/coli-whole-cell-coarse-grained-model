
addpath('../model-code/deterministic-dynamics/');
addpath('../model-code/steady-state_coreg-low-delta/');

cell_pars.delta = 10;
cell_pars.K = 0.11 * 0.76;
cell_pars.a_sat = cell_pars.K / cell_pars.delta;

%%%% TO DO

% load the figure 1 comp data
% for each cond, do the det dyn sim (but with what fx ??!?!!!)

