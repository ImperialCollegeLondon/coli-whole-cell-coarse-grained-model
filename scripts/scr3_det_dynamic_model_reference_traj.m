
addpath('../model-code/deterministic-dynamics/');

output_folder = '../results-data/res3_det-dynamics-ref-traj/';
if ~exist(output_folder, 'dir')
    mkdir(output_folder);
end

constants = give_constants();

cell_pars.delta = constants.reference_delta;
cell_pars.a_sat = constants.K / cell_pars.delta; 
cell_pars.sigma = constants.sigma;
cell_pars.cm_koff = constants.cm_koff;
cell_pars.fQ = constants.reference_fQ;
cell_pars.fX = constants.reference_fX;
cell_pars.fQ = cell_pars.fQ - cell_pars.fX; % guarantee fX + fQ det = 'fQ' ss
cell_pars.X_div = constants.reference_Xdiv;

env_pars.cm_kon = 5;
cell_pars.fU = 0;
env_pars.k = 3.53; % chosen for alpha ~ 1 hr-1

% initial state
init_cell_state.A = 0;
init_cell_state.E = 1;
init_cell_state.RA = 1;
init_cell_state.RI = 0;
init_cell_state.Q = 1;
init_cell_state.U = 0;
init_cell_state.X = 0;

% duration
duration = 12;

% solve ODEs to get traj
traj = solve_amount(init_cell_state, cell_pars, env_pars, duration);

% save as csv
traj.a = traj.A ./ traj.M_or_V;
traj.e = traj.E ./ traj.M_or_V;
traj.r = traj.R ./ traj.M_or_V;
traj.q = traj.Q ./ traj.M_or_V;
traj.x = traj.X ./ traj.M_or_V;
traj_table = struct2table(traj);
writetable(traj_table,[output_folder, 'trajectory.csv']);


