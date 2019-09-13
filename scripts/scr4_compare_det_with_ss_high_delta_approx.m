
addpath('../model-code/deterministic-dynamics/');

output_folder = '../results-data/res4_compare-ss-high-delta-approx-with-dyn-model/';
if ~exist(output_folder, 'dir')
    mkdir(output_folder);
end

%
ss_preds = readtable('../results-data/res2_compositions_coreg-high-delta-model/basan_2015_si_2017_taheri_2015_modulations.csv');

%
cell_pars.delta = 10;
K = 0.11 * 0.76; % in units of extended ribosome mass fraction. from Dai et al. Km in R/P unit converted to Scott extended ribosome unit
cell_pars.a_sat = K / cell_pars.delta; 
cell_pars.sigma = 1 / (7336 * 1.67 / 22) * 3600; % in hr-1. set from Dai et al max elong rate (22 aa/s), and extended ribosome AA number (7336 * 1.67)
cell_pars.fQ = 0.5;
cell_pars.fX = 0.1;
cell_pars.fQ = cell_pars.fQ - cell_pars.fX; % guarantee fX + fQ det = 'fQ' ss
cell_pars.X_div = 70;

% initial state
init_cell_state.A = 0;
init_cell_state.E = 1;
init_cell_state.R = 100;
init_cell_state.Q = 0;
init_cell_state.U = 0;
init_cell_state.X = 0;

%
growth_rate = size(ss_preds.model_growth_rate);
fR = size(ss_preds.model_fR);

%
for i=1:size(ss_preds,1)
    duration = 100 / ss_preds.model_growth_rate(i);
    env_pars.k = ss_preds.model_k(i);
    env_pars.ri = ss_preds.model_fRI(i);
    cell_pars.fU = ss_preds.model_fU(i);
    traj = solve_amount(init_cell_state, cell_pars, env_pars, duration);
    growth_rate(i) = env_pars.k * traj.E(end) / traj.M_or_V(end);
    fR(i) = traj.R(end) / traj.total_prot(end);
end

%
both_preds = ss_preds;
both_preds.det_fR = fR';
both_preds.det_growth_rate = growth_rate';

%
writetable(both_preds, [output_folder, 'comparison_ss_high_delta_approx_vs_det_model.csv']);


