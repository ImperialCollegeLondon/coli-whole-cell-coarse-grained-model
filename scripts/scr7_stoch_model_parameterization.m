
addpath('../model-code/stochastic-dynamics/');

output_folder = '../results-data/res7_stoch-model-basics/';
if ~exist(output_folder, 'dir')
    mkdir(output_folder);
end

path2bin = '..\model-code\stochastic-dynamics\cpp-simulator-cm-rates\bin\Debug\cpp-simulator-cm-rates.exe';
path2output = '..\model-code\stochastic-dynamics\cpp-simulator-cm-rates\sim-data';

constants = give_constants();

params.ri_r_rate = constants.cm_koff;
params.sigma = constants.sigma;
params.delta = constants.reference_delta;
params.a_sat = constants.K / params.delta; 
params.f_X_scale = constants.reference_fX_scale;
params.f_X_e_exponent = constants.reference_fX_e_exponent;
params.f_X_active_rib_frac_exponent = constants.reference_fX_active_rib_frac_exponent;
params.f_Q = constants.reference_fQ;
params.X_div = constants.reference_Xdiv;
params.destroy_X_after_div = 0;
params.X_degrad_rate = 0;

params.k_media = constants.reference_k;
params.f_U = 0;
params.r_ri_rate = 0;

params.random_seed = 0;
params.partitioning_type = 'normal';
params.num_lineages = 1;
params.sim_duration = 200 * constants.stoch_sample_scale;
params.update_period = 0.005;
params.num_updates_per_output = 1;

sim_data = do_single_sim_cm_rates(params, path2bin, path2output);

lineage_data_steady = sim_data.lineage_data(100:end,:);
mean_birth_size = mean(lineage_data_steady.V_birth);
CV_birth_size = std(lineage_data_steady.V_birth) / mean(lineage_data_steady.V_birth);
mean_div_size = mean(lineage_data_steady.V_div);
CV_div_size = std(lineage_data_steady.V_div) / mean(lineage_data_steady.V_div);
growth_rates = log(lineage_data_steady.V_div./lineage_data_steady.V_birth)./ lineage_data_steady.T_div;
mean_growth_rate = mean(growth_rates);
CV_growth_rate = std(growth_rates) / mean(growth_rates);
writetable(table(mean_birth_size, CV_birth_size, mean_div_size, CV_div_size, mean_growth_rate, CV_growth_rate),[output_folder, 'statistics.csv']);

% save trajectory as csv
n_tps = 5000;
traj.t = sim_data.traj_time(1:n_tps);
traj.size = sim_data.traj_size(1:n_tps);
traj.X = sim_data.traj_X(1:n_tps);
traj.a = sim_data.traj_A(1:n_tps) ./ sim_data.traj_size(1:n_tps);
traj.e = sim_data.traj_E(1:n_tps) ./ sim_data.traj_size(1:n_tps);
traj.r = sim_data.traj_R(1:n_tps) ./ sim_data.traj_size(1:n_tps);
traj.q = sim_data.traj_Q(1:n_tps) ./ sim_data.traj_size(1:n_tps);
traj.x = sim_data.traj_X(1:n_tps) ./ sim_data.traj_size(1:n_tps);
traj_table = struct2table(traj);
writetable(traj_table,[output_folder, 'trajectory.csv']);
