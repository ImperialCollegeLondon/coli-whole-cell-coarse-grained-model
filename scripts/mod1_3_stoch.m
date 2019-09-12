
addpath('../model-code/stochastic-dynamics/');

output_folder = '../results-data/mod1_3_stoch_sim/';
if ~exist(output_folder, 'dir')
    mkdir(output_folder);
end

path2bin = '..\model-code\stochastic-dynamics\cpp-simulator-cm-rates\bin\Debug\cpp-simulator-cm-rates.exe';
path2output = '..\model-code\stochastic-dynamics\cpp-simulator-cm-rates\sim-data';

params.ri_r_rate = 0; % does not matter since no cm
params.r_ri_rate = 0;
params.f_RI = 0;
params.sigma = 1 / (7336 * 1.67 / 22) * 3600; % in hr-1. set from Dai et al max elong rate (22 aa/s), and extended ribosome AA number (7336 * 1.67)
params.k_media = 3.53;
params.delta = 10;
K = 0.11 * 0.76; % in units of extended ribosome mass fraction. from Dai et al. Km in R/P unit converted to Scott extended ribosome unit
params.a_sat = K / params.delta; 
params.f_U = 0;
params.f_X = 0.1;
params.f_Q = 0.5 - params.f_X;
params.X_div = 70;
params.destroy_X_after_div = 0;
params.X_degrad_rate = 0;


params.random_seed = 0;
params.partitioning_type = 'normal';
params.num_lineages = 1;
params.sim_duration = 15;
params.update_period = 0.005;
params.num_updates_per_output = 1;

traj_data = do_single_sim_cm_rates(params, path2bin, path2output);


% clean and transform to table
traj_data = rmfield(traj_data,'lineage_data');
traj_data = rmfield(traj_data,'params');
traj_data = renameStructField(traj_data,'traj_A','A');
traj_data = renameStructField(traj_data,'traj_E','E');
traj_data = renameStructField(traj_data,'traj_R','RA');
traj_data = renameStructField(traj_data,'traj_RI','RI');
traj_data = renameStructField(traj_data,'traj_Q','Q');
traj_data = renameStructField(traj_data,'traj_X','X');
traj_data = renameStructField(traj_data,'traj_U','U');
traj_data = renameStructField(traj_data,'traj_size','size');
traj_data = renameStructField(traj_data,'traj_time','t');
traj_table = struct2table(traj_data);

% output
writetable(traj_table,[output_folder, 'trajectory.csv']);