
addpath('../model-code/deterministic-dynamics/');
addpath('../model-code/steady-state_optim/');
addpath('../model-code/steady-state/');


output_folder = '../results-data/res5_study-optimality/';
if ~exist(output_folder, 'dir')
    mkdir(output_folder);
end

%
ss_preds = readtable('../results-data/res2_compositions_coreg-high-delta-model/basan_2015_si_2017_taheri_2015_modulations.csv');

%
constants = give_constants();

% coreg exact det dynamic
cell_pars.delta = constants.reference_delta;
cell_pars.a_sat = constants.K / cell_pars.delta; 
cell_pars.sigma = constants.sigma;
cell_pars.cm_koff = constants.cm_koff;
cell_pars.fQ = constants.reference_fQ;
cell_pars.fX = constants.reference_fX;
cell_pars.fQ = cell_pars.fQ - cell_pars.fX; % guarantee fX + fQ det = 'fQ' ss
cell_pars.X_div = constants.reference_Xdiv;

% initial state for coreg exact det dynamic
init_cell_state.A = 1;
init_cell_state.E = 1;
init_cell_state.RA = 100;
init_cell_state.RI = 0;
init_cell_state.Q = 0;
init_cell_state.U = 0;
init_cell_state.X = 0;

% param structure for the optimality ss model
optim.cell_pars.a_sat = cell_pars.a_sat;
optim.cell_pars.sigma = cell_pars.sigma;
optim.cell_pars.fQ = cell_pars.fQ + cell_pars.fX;
optim.cell_pars.cm_koff = cell_pars.cm_koff;

%%%
optimality_ratio = zeros(size(ss_preds.model_growth_rate));
growth_rate = zeros(size(ss_preds.model_growth_rate));
optimal_growth_rate = zeros(size(ss_preds.model_growth_rate));

for i=1:size(ss_preds,1)
    % 
    duration = 50 / ss_preds.model_growth_rate(i);
    env_pars.k = ss_preds.model_k(i);
    env_pars.cm_kon = ss_preds.model_cm_kon(i);
    cell_pars.fU = ss_preds.model_fU(i);
    traj = solve_amount(init_cell_state, cell_pars, env_pars, duration);
    alpha = env_pars.k * traj.E(end) / traj.M_or_V(end);
    %
    optim.env_pars.k = env_pars.k;
    optim.env_pars.cm_kon = env_pars.cm_kon;
    optim.cell_pars.fU = cell_pars.fU;
    ss_optim = give_optim_steady_state(optim.cell_pars, optim.env_pars);
    optimality_ratio(i) = alpha / ss_optim.alpha;
    growth_rate(i) = alpha;
    optimal_growth_rate(i) = ss_optim.alpha;
end

both_preds = ss_preds;
both_preds.optimality_ratio = optimality_ratio;
both_preds.det_growth_rate = growth_rate;
both_preds.optimal_growth_rate = optimal_growth_rate;

%
writetable(both_preds, [output_folder, 'optimality_vs_coreg.csv']);
