

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
ref_delta = 10;
K = 0.11 * 0.76; % in units of extended ribosome mass fraction. from Dai et al. Km in R/P unit converted to Scott extended ribosome unit
params.a_sat = K / ref_delta; 
params.f_U = 0;
params.f_X = 0.1;
params.f_Q = 0.5 - params.f_X;
params.X_div = 80;
params.destroy_X_after_div = 0;
params.X_degrad_rate = 0;

params.random_seed = 0;
params.partitioning_type = 'normal';
params.num_lineages = 1;
params.sim_duration = 1000;
params.update_period = 0.005;
params.num_updates_per_output = 1;

delta = [10];%linspace(5,5,1)';

CV_birth_size = zeros(size(delta));
CV_alpha = zeros(size(delta));
avg_birth_size = zeros(size(delta));
avg_alpha = zeros(size(delta));
a_trajs = cell(size(delta));

%
for i=1:length(delta)
    params.delta = delta(i);
    params.a_sat = K / params.delta;
    sim_data = do_single_sim_cm_rates(params, path2bin, path2output);
    lineage_data = sim_data.lineage_data(101:end,:);
    lineage_data.alpha = log(lineage_data.V_div ./ lineage_data.V_birth) ./ lineage_data.T_div;
    CV_birth_size(i) = std(lineage_data.V_birth)/mean(lineage_data.V_birth);
    CV_alpha(i) = std(lineage_data.alpha)/mean(lineage_data.alpha);
    avg_birth_size(i) = mean(lineage_data.V_birth);
   avg_alpha(i) = mean(lineage_data.alpha);
end

%%
subplot(1,2,1);
%plot(delta, avg_birth_size ./ mean(avg_birth_size), '-ro'); hold on;
plot(delta, avg_alpha, '-bo');
subplot(1,2,2);
plot(delta, CV_birth_size, '-ro'); hold on;
plot(delta, CV_alpha, '-bo');