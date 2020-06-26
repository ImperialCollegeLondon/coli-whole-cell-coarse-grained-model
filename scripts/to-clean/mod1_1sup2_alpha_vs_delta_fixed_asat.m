
addpath('../model-code/deterministic-dynamics/');

output_folder = '../results-data/mod1_1sup2_alpha-vs-delta-fixed-asat/';
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
duration = 18;

% to vary
delta = ref_delta .* logspace(-2,2,100)';

%%%
alpha = zeros(size(delta));
for i_delta=1:length(delta)
    cell_pars.delta = delta(i_delta);
    traj = solve_amount(init_cell_state, cell_pars, env_pars, duration);
    traj.e = traj.E ./ traj.M_or_V;
    alpha(i_delta) = env_pars.k * traj.e(end);
end
writetable(table(delta,alpha),[output_folder 'alpha_vs_delta.csv']);