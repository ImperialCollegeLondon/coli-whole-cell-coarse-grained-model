
addpath('../model-code/steady-state_coreg-high-delta');
addpath('../model-code/deterministic-dynamics/');


output_folder = '../results-data/res10_det-model-size-across-conds/';
if ~exist(output_folder, 'dir')
    mkdir(output_folder);
end

constants = give_constants();
cell_pars.sigma = constants.sigma;
cell_pars.fQ = constants.reference_fQ;
cell_pars.K = constants.K;
cell_pars.delta = constants.reference_delta;
cell_pars.a_sat = constants.K / cell_pars.delta;
cell_pars.cm_koff = constants.cm_koff;
cell_pars.fX = 0.1;  % does not matter here, we just need division and same fX + fQ as the stoch sims
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


k_ref = 3.6;

k_vec = linspace(0.5,20,100);
nut_size_vec = zeros(size(k_vec));
nut_growth_rate_vec = zeros(size(k_vec));
env_pars.cm_kon = 0;
cell_pars.fU = 0;
for i_nut=1:length(k_vec)
    env_pars.k = k_vec(i_nut);
    ss = give_steady_state_coreg_high_delta(cell_pars, env_pars);
    duration = 50 / ss.alpha;
    traj = solve_amount(init_cell_state, cell_pars, env_pars, duration);
    e = traj.E(end) / traj.M_or_V(end);
    active_rib_frac = traj.RA(end) / traj.R(end);
    fX = constants.reference_fX_scale * e^(constants.reference_fX_e_exponent) * active_rib_frac^(constants.reference_fX_active_rib_frac_exponent);
    nut_size_vec(i_nut) = constants.reference_Xdiv / fX / 2;
    nut_growth_rate_vec(i_nut) = ss.alpha;
end
growth_rate = nut_growth_rate_vec';
birth_size = nut_size_vec';
writetable(table(growth_rate, birth_size), [output_folder 'nut_mod.csv']);


cm_kon_vec = linspace(0,4,100);
cm_size_vec = zeros(size(cm_kon_vec));
cm_growth_rate_vec = zeros(size(cm_kon_vec));
env_pars.k = k_ref;
cell_pars.fU = 0;
for i_cm=1:length(cm_kon_vec)
    env_pars.cm_kon = cm_kon_vec(i_cm);
    ss = give_steady_state_coreg_high_delta(cell_pars, env_pars);
    duration = 50 / ss.alpha;
    traj = solve_amount(init_cell_state, cell_pars, env_pars, duration);
    e = traj.E(end) / traj.M_or_V(end);
    X_and_Q = (traj.X(end) + traj.Q(end)) / traj.total_prot(end)
    active_rib_frac = traj.RA(end) / traj.R(end);
    fX = constants.reference_fX_scale * e^(constants.reference_fX_e_exponent) * active_rib_frac^(constants.reference_fX_active_rib_frac_exponent);
    cm_size_vec(i_cm) = constants.reference_Xdiv / fX / 2;
    cm_growth_rate_vec(i_cm) = ss.alpha;
end
growth_rate = cm_growth_rate_vec';
birth_size = cm_size_vec';
writetable(table(growth_rate, birth_size), [output_folder 'cm_mod.csv']);


fU_vec = linspace(0,0.25,100);
fU_size_vec = zeros(size(fU_vec));
fU_growth_rate_vec = zeros(size(fU_vec));
env_pars.k = k_ref;
env_pars.cm_kon = 0;
for i_useless=1:length(cm_kon_vec)
    cell_pars.fU = fU_vec(i_useless);
    ss = give_steady_state_coreg_high_delta(cell_pars, env_pars);
    duration = 50 / ss.alpha;
    traj = solve_amount(init_cell_state, cell_pars, env_pars, duration);
    e = traj.E(end) / traj.M_or_V(end);
    active_rib_frac = traj.RA(end) / traj.R(end);
    fX = constants.reference_fX_scale * e^(constants.reference_fX_e_exponent) * active_rib_frac^(constants.reference_fX_active_rib_frac_exponent);
    fU_size_vec(i_useless) = constants.reference_Xdiv / fX / 2;
    fU_growth_rate_vec(i_useless) = ss.alpha;
end
growth_rate = fU_growth_rate_vec';
birth_size = fU_size_vec';
writetable(table(growth_rate, birth_size), [output_folder 'useless_mod.csv']);

