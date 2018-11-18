

addpath('../model-code/steady-state');
addpath('../model-code/deterministic-dynamics');


% load fitted pars
fitted_scott_pars = readtable('../results-data/res1_scott-2010-fit/fitted-parameters_proteome-allocation.csv');
fitted_size_pars = readtable('../results-data/res4_basan-2015-si-2017-taheri-2015-fit/ref/two-sectors-size-predictions/e_and_ra_over_r_data_fX-true/exponents.csv');      
fitted_Xdiv_fX_scale = readtable('../results-data/res8_fX-scale-and-Xdiv/Xdiv_fX_scale_fit.csv'); 

% fitted  model parameters
cell_pars.biophysical.sigma = fitted_scott_pars.sigma;
cell_pars.biophysical.a_sat = fitted_scott_pars.a_sat;
cell_pars.constraint.q = fitted_scott_pars.q;

% find k and compute steady state
env_pars.ri = 0;
cell_pars.allocation.fU = 0;
env_pars.k = fit_k_from_alpha(cell_pars,env_pars,1.0);
[ss,cell_pars] = give_optimal_steady_state_from_Q_constraint(cell_pars,env_pars);

% compute fX from (and remove from true fQ for sum = 1)
cell_pars.allocation.fX =fitted_Xdiv_fX_scale.fX_scale * ss.e^fitted_size_pars.exponents(1) *(ss.ra/ss.r)^fitted_size_pars.exponents(2);
cell_pars.allocation.fQ = cell_pars.allocation.fQ - cell_pars.allocation.fX;
% division
cell_pars.division.X_div = fitted_Xdiv_fX_scale.X_div;

% initial state
init_cell_state.A = 1;
init_cell_state.E = 1;
init_cell_state.R = 1;
init_cell_state.Q = 1;
init_cell_state.U = 0;
init_cell_state.X = 1;

% duration
duration = 10;

% solve ODEs to get traj
traj = solve_amount(init_cell_state, cell_pars, env_pars, duration);

% save as csv
traj.a = traj.A ./ traj.M_or_V;
traj.e = traj.E ./ traj.M_or_V;
traj.r = traj.R ./ traj.M_or_V;
traj.q = traj.Q ./ traj.M_or_V;
traj.x = traj.X ./ traj.M_or_V;
traj_table = struct2table(traj);
writetable(traj_table,'../results-data/res6_dynamic-det-model/trajectory.csv');


