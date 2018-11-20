
%%
clear ; addpath ( '../simu-code' ) ;

%% sim params
pars.num_lineages = 1 ;
pars.update_period = 0.005 ;
pars.random_seed = 1 ;
pars.sim_duration = 1000000 ;
pars.num_updates_per_output = 100 ;

%% common params params
pars.partitioning_type = 'normal' ;
pars.P_div_threshold = 100 ;
pars.P_after_div = pars.P_div_threshold ;
pars.rp = 0 ;

%% DNA replication at constant size per kp
pars.GE_model = 'only_prot_step_change_size_trigger' ;
pars.step_size_threshold = 0.2 ;
pars.kp_per_size = 0 ;
pars.kp_0 = 60 ;

%% do sims
mu_media_vec = [0.1 0.5 2] ;
sim_datas = varySingleParam ( pars , 'mu_media' , mu_media_vec ) ;

%%
colors = hsv(length(sim_datas)) ;
mk_size = 6 ; lw = 2 ;
for i=1:length(sim_datas)
    plot ( sim_datas{i}.avg_Vbs ./ sim_datas{i}.mean_birth_size , sim_datas{i}.avg_deltaVs ./ sim_datas{i}.mean_birth_size , ...
        '-o' , 'MarkerFaceColor' , colors(i,:) , 'Color' , colors(i,:) , 'MarkerSize' , mk_size , 'LineWidth' , lw ) ; hold on ;
end
xlabel ( '<V_{birth}>_{bin} / <V_{birth}>' ) ; ylabel ( '<\Delta V>_{bin} / <V_{birth}>' ) ;
ylim ( [0.9 1.1] ) ; xlim ( [0.6 1.4] ) ;
set ( gca , 'LineWidth' , 2 ) ;
leg = {} ; for i=1:length(mu_media_vec) ; leg = { leg{:} , [num2str(mu_media_vec(i)) ' dblgs/hr' ] } ; end ;
legend ( leg , 'Location' , 'NorthWest' , 'FontSize' , 16 ) ;