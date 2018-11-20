function pars = giveParams ( model_name )

% sim_pars
pars.num_lineages = 1 ;
pars.update_period = 0.001 ;
pars.random_seed = 1 ;
pars.sim_duration = 3 ;
pars.num_updates_per_output = 10 ;

% always true
pars.GE_model = 'only_protein' ;
pars.partitioning_type = 'normal' ;

% the basic model, which shows that
if ( strcmp ( model_name , 'basic' ) )
    pars.P_div_threshold = 100 ;
    pars.P_after_div = pars.P_div_threshold ;
    pars.kp_0 = 0 ;
    pars.mu_media = 2 ;
    pars.kp_per_size = 50 ;
    pars.rp = 0 ;
    return ;
end

%
error ( 'Unknown model name' ) ;



end

