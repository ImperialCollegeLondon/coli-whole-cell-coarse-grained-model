
addpath('../model-code/deterministic-dynamics/');

constants = give_constants();

cell_pars.delta = constants.reference_delta;
cell_pars.a_sat = constants.K / cell_pars.delta;
cell_pars.delta = 1;
cell_pars.sigma = constants.sigma;
cell_pars.cm_koff = constants.cm_koff;
cell_pars.fQ = constants.reference_fQ;
cell_pars.fX = constants.reference_fX;
cell_pars.fQ = cell_pars.fQ - cell_pars.fX; % guarantee fX + fQ det = 'fQ' ss
cell_pars.X_div = constants.reference_Xdiv;

env_pars.cm_kon = 0;
cell_pars.fU = 0;
env_pars.k = 1;

% initial state
init_cell_state.A = 0;
init_cell_state.E = 1;
init_cell_state.RA = 1;
init_cell_state.RI = 0;
init_cell_state.Q = 1;
init_cell_state.U = 0;
init_cell_state.X = 0;

% duration
pre_duration = 20;

% solve ODEs to get traj
traj = solve_amount(init_cell_state, cell_pars, env_pars, pre_duration);

% save as csv
traj.a = traj.A ./ traj.M_or_V;
traj.e = traj.E ./ traj.M_or_V;
traj.r = traj.R ./ traj.M_or_V;
traj.q = traj.Q ./ traj.M_or_V;
traj.x = traj.X ./ traj.M_or_V;
traj_table = struct2table(traj);

%
init_cell_state.A = traj.A(end);
init_cell_state.E = traj.A(end);
init_cell_state.RA = traj.RA(end);
init_cell_state.RI = traj.RI(end);
init_cell_state.Q = traj.Q(end);
init_cell_state.U = traj.U(end);
init_cell_state.X = traj.X(end);

%
env_pars.k = env_pars.k * 5;

% duration
duration = 12;

% solve ODEs to get traj
traj = solve_amount(init_cell_state, cell_pars, env_pars, duration);
traj.t = traj.t + pre_duration;
traj.a = traj.A ./ traj.M_or_V;
traj.e = traj.E ./ traj.M_or_V;
traj.r = traj.R ./ traj.M_or_V;
traj.q = traj.Q ./ traj.M_or_V;
traj.x = traj.X ./ traj.M_or_V;
traj_table_2 = struct2table(traj);

%
traj_table = [traj_table; traj_table_2];


%%
plot(traj_table.t, traj_table.e, 'm');