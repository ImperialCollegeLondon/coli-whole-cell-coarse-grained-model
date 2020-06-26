
addpath('../model-code/deterministic-dynamics/');

output_folder = '../results-data/res4_compare-ss-high-delta-approx-with-dyn-model/';
if ~exist(output_folder, 'dir')
    mkdir(output_folder);
end

%
ss_preds = readtable('../results-data/res2_compositions_coreg-high-delta-model/basan_2015_si_2017_taheri_2015_modulations.csv');

%
constants = give_constants();
cell_pars.delta = constants.reference_delta;
cell_pars.a_sat = constants.K / cell_pars.delta; 
cell_pars.sigma = constants.sigma;
cell_pars.cm_koff = constants.cm_koff;
cell_pars.fQ = constants.reference_fQ;
cell_pars.fX = constants.reference_fX;
cell_pars.fQ = cell_pars.fQ - cell_pars.fX; % guarantee fX + fQ det = 'fQ' ss
cell_pars.X_div = constants.reference_Xdiv;

% initial state
init_cell_state.A = 1;
init_cell_state.E = 1;
init_cell_state.RA = 100;
init_cell_state.RI = 0;
init_cell_state.Q = 0;
init_cell_state.U = 0;
init_cell_state.X = 0;

%
growth_rate = zeros(size(ss_preds.model_growth_rate));
fR = zeros(size(ss_preds.model_growth_rate));

%
for i=1:size(ss_preds,1)
    duration = 50 / ss_preds.model_growth_rate(i);
    env_pars.k = ss_preds.model_k(i);
    env_pars.cm_kon = ss_preds.model_cm_kon(i);
    cell_pars.fU = ss_preds.model_fU(i);
    traj = solve_amount(init_cell_state, cell_pars, env_pars, duration);
    growth_rate(i) = env_pars.k * traj.E(end) / traj.M_or_V(end);
    %disp([num2str(ss_preds.model_growth_rate(i)) ' --- ' num2str(growth_rate(i))]);
    fR(i) = traj.R(end) / traj.total_prot(end);
end

%
both_preds = ss_preds;
both_preds.det_fR = fR;
both_preds.det_growth_rate = growth_rate;

%
writetable(both_preds, [output_folder, 'comparison_ss_high_delta_approx_vs_det_model.csv']);


