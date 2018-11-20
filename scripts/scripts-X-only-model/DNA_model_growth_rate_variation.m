clear ; addpath ( '../simu-code' ) ;


%% sim params
pars.num_lineages = 1 ;
pars.update_period = 0.005 ;
pars.random_seed = 1 ;
pars.sim_duration = 10000 ;
pars.num_updates_per_output = 100 ;


%%  params
pars.partitioning_type = 'normal' ;
pars.P_div_threshold = 100 ;
pars.P_after_div = pars.P_div_threshold ;
pars.rp = 0 ;
pars.GE_model = 'only_prot_step_change_size_trigger' ;
pars.step_size_threshold = 0.2 ;
pars.kp_per_size = 0 ;
pars.kp_0 = 60 ;


%% mu_media variation
mu_media_vec = [0.5 1 2 4 8] ;
sim_datas = varySingleParam ( pars , 'mu_media' , mu_media_vec ) ;

%% plotting average vs growth rate
subplot ( 2 , 2 , 1 ) ;
plot ( mu_media_vec , cellfun(@(x)(mean(x.lineage_data.V_birth(101:end))),sim_datas) , '-ko' ) ;
subplot ( 2 , 2 , 2 ) ;
plot ( mu_media_vec , cellfun(@(x)(mean(x.lineage_data.sigma(101:end))),sim_datas) ./ pars.kp_0 , '-ko' ) ;
subplot ( 2 , 2 , 3 ) ;
plot ( mu_media_vec , cellfun(@(x)(compute_CV(x.lineage_data.V_birth(101:end))),sim_datas) , '-ko' ) ;
ylim ([0 0.4] ) ;
subplot ( 2 , 2 , 4 ) ;
plot ( mu_media_vec , cellfun(@(x)(compute_CV(x.lineage_data.sigma(101:end))),sim_datas) , '-ko' ) ;
ylim ([0 0.4] ) ;


