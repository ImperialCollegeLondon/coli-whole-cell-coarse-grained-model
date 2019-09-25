
addpath('../model-code/deterministic-dynamics/');

constants = give_constants();

cell_pars.delta = 2; %constants.reference_delta;
cell_pars.a_sat = constants.K / cell_pars.delta; 
cell_pars.sigma = constants.sigma;
cell_pars.cm_koff = constants.cm_koff;
cell_pars.fQ = constants.reference_fQ;
cell_pars.fX = constants.reference_fX;
cell_pars.fQ = cell_pars.fQ - cell_pars.fX; % guarantee fX + fQ det = 'fQ' ss
cell_pars.X_div = constants.reference_Xdiv;

env_pars.cm_kon = 7.4 / 2;
cell_pars.fU = 0;
env_pars.k = 4; % chosen for alpha ~ 1 hr-1

% initial state
init_cell_state.A = 0;
init_cell_state.E = 1;
init_cell_state.RA = 1;
init_cell_state.RI = 0;
init_cell_state.Q = 1;
init_cell_state.U = 0;
init_cell_state.X = 0;

% duration
duration = 100;

% solve ODEs to get traj
traj = solve_amount(init_cell_state, cell_pars, env_pars, duration);
alpha = env_pars.k * traj.E(end) / traj.M_or_V(end)