
% the nut condition cm mod
nut = 6;
data = readtable('../external-data/scott_2010_data.csv');
data = data(data.useless_type == 0, :);
data = data(data.nutrient_type == nut, :);
no_cm_data = data(data.cm_type == 0, :);

% cell params
constants = give_constants();
cell_pars.delta = constants.reference_delta * 0.2;
cell_pars.a_sat = constants.K / cell_pars.delta; 
cell_pars.sigma = constants.sigma;
cell_pars.cm_koff = constants.cm_koff;
cell_pars.fQ = constants.reference_fQ;
cell_pars.fX = constants.reference_fX;
cell_pars.fQ = cell_pars.fQ - cell_pars.fX; % guarantee fX + fQ det = 'fQ' ss
cell_pars.X_div = constants.reference_Xdiv;
cell_pars.cm_kon_per_uM = constants.cm_kon_per_uM;

% initial state and large enough duration to reach ss
init_cell_state.A = 0;
init_cell_state.E = 1;
init_cell_state.RA = 1;
init_cell_state.RI = 0;
init_cell_state.Q = 1;
init_cell_state.U = 0;
init_cell_state.X = 0;
duration = 100;

% find the k
env_pars.k = 1.05;
env_pars.cm_kon = 0;
cell_pars.fU = 0;
traj_no_cm = solve_amount(init_cell_state, cell_pars, env_pars, duration);
alpha_no_cm = env_pars.k * traj_no_cm.E(end) / traj_no_cm.M_or_V(end)
fR_no_cm = traj_no_cm.R(end) / traj_no_cm.total_prot(end)

% compute alphas and fRs for all cm of this nut
alphas = zeros(size(data.growth_rate_per_hr));
fRs = zeros(size(data.growth_rate_per_hr));
for i_cm=1:size(data,1)
    this_data = data(i_cm,:);
    env_pars.cm_kon = this_data.cm_uM * cell_pars.cm_kon_per_uM;
    traj = solve_amount(init_cell_state, cell_pars, env_pars, duration);
    alphas(i_cm) = env_pars.k * traj.E(end) / traj.M_or_V(end);
    fRs(i_cm) = traj.R(end) / traj.total_prot(end);
end

%
plot(alphas, fRs, '-ko'); hold on;
plot(data.growth_rate_per_hr, data.estim_ribosomal_fraction_scott, '-rs');