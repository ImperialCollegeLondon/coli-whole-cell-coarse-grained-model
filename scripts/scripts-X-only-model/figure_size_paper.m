
%% 
clear ; addpath ( '../simu-code' ) ;


%% sim params
pars.num_lineages = 1 ;
pars.update_period = 0.005 ;
pars.random_seed = 1 ;
pars.sim_duration = 20 ;
pars.num_updates_per_output = 1 ;


%% common params params
pars.partitioning_type = 'normal' ;
pars.P_div_threshold = 100 ;
pars.P_after_div = pars.P_div_threshold ;
pars.mu_media = 2 ;
pars.rp = 0 ;

%% constant case
pars.GE_model = 'only_protein' ;
pars.kp_per_size = 0 ;
pars.kp_0 = 90 ;
sim_data = do_single_sim (pars) ;
semilogy ( sim_data.traj_time , sim_data.traj_size , 'r' ) ; hold on ;

%% scaling with size
pars.kp_per_size = 20 ;
pars.kp_0 = 0 ;
sim_data = do_single_sim (pars) ;
semilogy ( sim_data.traj_time , sim_data.traj_size , 'b' ) ; hold on ;

%% DNA replication at constant size per kp
pars.GE_model = 'only_prot_step_change_size_trigger' ;
pars.step_size_threshold = 0.2 ;
pars.kp_per_size = 0 ;
pars.kp_0 = 60 ;
sim_data = do_single_sim (pars) ;
semilogy ( sim_data.traj_time , sim_data.traj_size , 'g' ) ; hold on ;

%% plot aesthetics
axfontsize = 40 ; axlw = 3.5 ;
ylabel ( 'Cell size' ) ; xlabel ( 'Time' ) ;
set ( gca , 'FontSize' , axfontsize , 'LineWidth' , axlw ) ;
fig_w = 1700 ; fig_h = 800 ;
set ( gcf , 'Position' , [1 1 fig_w fig_h] ) ;
legend ( { ' \sigma = \sigma_0' , ' \sigma = \sigma_V \times V' , 'Doubling of \sigma when V / \sigma = V^{*}' } , ...
    'Location' , 'NorthWest' ) ;

% set ( gcf , 'Color' , 'None' ) ;
% export_fig ( gcf , 'for_size_paper.pdf' ) ; close ;

