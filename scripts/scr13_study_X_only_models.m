
addpath('../model-code/other-models/X-only-model');


path2cpp = '../model-code/other-models/X-only-model/cpp-simulator/build/simulator';
path2output = '../model-code/other-models/X-only-model/cpp-sim-data';


%%%% what to study ?

%%% basic model: X prod scale with size, size grow exponentially
% no growth rate noise, no size splitting noise
% same with different growth rate
% growth rate noise, no size splitting noise
% no growth rate noise, size splitting noise
% both noise

%%% other variants
% linear growth 
% size independent production term
% X degradation






% common pars
pars.partitioning_type = 'normal';
pars.GE_model = 'only_protein';
pars.linear_growth = 0;
pars.mu_media = 1.0;
pars.P_div_threshold = 90;
pars.P_after_div = 90;
pars.size_splitting_error = 0;
pars.kp_0 = 0;
pars.kp_per_size = 2;
pars.rp = 0;

% simulation pars
pars.random_seed = 1;
pars.num_lineages = 1;
pars.sim_duration = 10;
pars.update_period = 0.005;
pars.num_updates_per_output = 1;




sim_data = do_single_sim_X_only(pars, path2cpp, path2output);