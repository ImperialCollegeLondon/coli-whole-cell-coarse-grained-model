
addpath('../model-code/deterministic-dynamics/');

output_folder = '../results-data/mod1_1sup1_effect-of-delta/';
if ~exist(output_folder, 'dir')
    mkdir(output_folder);
end

%%% Pars of the in-silico exp

ref_delta = 20;
K = 0.11 * 0.76; % in units of extended ribosome mass fraction. from Dai et al. Km in R/P unit converted to Scott extended ribosome unit
cell_pars.a_sat = K / ref_delta; 
cell_pars.sigma = 1 / (7336 * 1.67 / 22) * 3600; % in hr-1. set from Dai et al max elong rate (22 aa/s), and extended ribosome AA number (7336 * 1.67)
cell_pars.fQ = 0.5;

env_pars.ri = 0;
cell_pars.fU = 0;
cell_pars.fX = 0.1;
cell_pars.fQ = cell_pars.fQ - cell_pars.fX; % guarantee fX + fQ det = 'fQ' ss
cell_pars.X_div = 70;

env_pars.k = 3.53;

% initial state
init_cell_state.A = 0;
init_cell_state.E = 3;
init_cell_state.R = 1;
init_cell_state.Q = 3;
init_cell_state.U = 0;
init_cell_state.X = 1;

% duration
duration = 9;

% to vary
delta_vec = ref_delta .* [0.01, 0.1, 1, 10];

%%%
for i_delta=1:length(delta_vec)
    cell_pars.delta = delta_vec(i_delta);
    traj = solve_amount(init_cell_state, cell_pars, env_pars, duration);
    traj.a = traj.A ./ traj.M_or_V;
    traj.e = traj.E ./ traj.M_or_V;
    traj.r = traj.R ./ traj.M_or_V;
    traj.q = traj.Q ./ traj.M_or_V;
    traj.x = traj.X ./ traj.M_or_V;
    traj_table = struct2table(traj);
    writetable(traj_table,[output_folder 'trajectory_delta-' num2str(cell_pars.delta) '.csv']);
end