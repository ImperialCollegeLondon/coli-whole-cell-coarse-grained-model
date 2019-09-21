
clear;

addpath('../model-code/deterministic-dynamics/');
addpath('../model-code/stochastic-dynamics/');
path2bin = '..\model-code\stochastic-dynamics\cpp-simulator-cm-rates\bin\Debug\cpp-simulator-cm-rates.exe';
path2output = '..\model-code\stochastic-dynamics\cpp-simulator-cm-rates\sim-data';

cell_pars.sigma = 1 / (7336 * 1.67 / 22) * 3600; % in hr-1. set from Dai et al max elong rate (22 aa/s), and extended ribosome AA number (7336 * 1.67)
cell_pars.fQ = 0.5;
K = 0.11 * 0.76; % in units of extended ribosome mass fraction. from Dai et al. Km in R/P unit converted to Scott extended ribosome unit
cell_pars.delta = 5; % some first try, in fact small impact
cell_pars.a_sat = K / cell_pars.delta;

env_pars.ri = 0;
cell_pars.fU = 0;
cell_pars.fX = 0.1;
cell_pars.fQ = cell_pars.fQ - cell_pars.fX; % guarantee fX + fQ det = 'fQ' ss
cell_pars.X_div = 70;

env_pars.k = 3.53;

% initial state
init_cell_state.A = 10;
init_cell_state.E = 100;
init_cell_state.R = 100;
init_cell_state.Q = 0;
init_cell_state.U = 0;
init_cell_state.X = 0;

% duration
duration = 10;

% solve ODEs to get traj
det_traj = solve_amount(init_cell_state, cell_pars, env_pars, duration);


stoch_pars.ri_r_rate = 0; % does not matter since no cm
stoch_pars.r_ri_rate = 0;
stoch_pars.f_RI = 0;
stoch_pars.sigma = cell_pars.sigma;
stoch_pars.k_media = env_pars.k;
stoch_pars.a_sat = cell_pars.a_sat; 
stoch_pars.delta = cell_pars.delta;
stoch_pars.f_U = cell_pars.fU;
stoch_pars.f_X = cell_pars.fX;
stoch_pars.f_Q = cell_pars.fQ;
stoch_pars.X_div = cell_pars.X_div;
stoch_pars.destroy_X_after_div = 0;
stoch_pars.X_degrad_rate = 0;

stoch_pars.random_seed = 0;
stoch_pars.partitioning_type = 'normal';
stoch_pars.num_lineages = 1;
stoch_pars.sim_duration = duration;
stoch_pars.update_period = 0.0005;
stoch_pars.num_updates_per_output = 1;

stoch_data = do_single_sim_cm_rates(stoch_pars, path2bin, path2output);


subplot(2,2,1);
plot(det_traj.t, det_traj.M_or_V, 'k'); hold on;
plot(stoch_data.traj_time, stoch_data.traj_size, '--k'); hold on;
xlim([0 duration]);

subplot(2,2,2);
plot(det_traj.t, det_traj.X, 'r'); hold on;
plot(stoch_data.traj_time, stoch_data.traj_X, '--r'); hold on;
xlim([0 duration]);

subplot(2,2,3);
plot(det_traj.t, det_traj.A ./ det_traj.M_or_V, 'm'); hold on;
plot(stoch_data.traj_time, stoch_data.traj_A ./ stoch_data.traj_size, '--m'); hold on;
xlim([0 duration]);

subplot(2,2,4);
plot(det_traj.t, det_traj.E ./ det_traj.M_or_V, 'g'); hold on;
plot(stoch_data.traj_time, stoch_data.traj_E ./ stoch_data.traj_size, '--g'); hold on;
plot(det_traj.t, det_traj.R ./ det_traj.M_or_V, 'b'); hold on;
plot(stoch_data.traj_time, stoch_data.traj_R ./ stoch_data.traj_size, '--b'); hold on;
plot(det_traj.t, det_traj.Q ./ det_traj.M_or_V, 'Color', [1 0.5 0.5]); hold on;
plot(stoch_data.traj_time, stoch_data.traj_Q ./ stoch_data.traj_size, '--', 'Color', [1 0.5 0.5]); hold on;
xlim([0 duration]);
