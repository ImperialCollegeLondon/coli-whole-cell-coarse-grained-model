
%% 
clear ; addpath ( '../simu-code' ) ;

%% 
pars = giveParams ( 'basic' ) ;
pars.sim_duration = 30 ;
pars.kp_per_size = 0 ;
pars.kp_0 = 1 ;
pars_step = pars ;
pars_step.GE_model = 'only_prot_step_change_size_trigger' ;
pars_step.step_size_threshold = 5 ;
pars_step.random_seed = 2 ;

pars_step.P_div_threshold = 100 ; pars_step.P_after_div = pars_step.P_div_threshold ;

%%
sim_data = do_single_sim ( pars ) ;
sim_data_step = do_single_sim ( pars_step ) ;

%%
axfontsize = 25 ; axlw = 2 ;
fig_w = 1000 ; fig_h = 800 ;
subplot ( 2 , 1 , 1 ) ;
% semilogy ( sim_data.traj_time , sim_data.traj_size , 'b' ) ; hold on ;
plot ( sim_data_step.traj_time , sim_data_step.traj_size , 'Color' , 'r' ) ; hold on ;
% plot ( minmax_fb(sim_data.traj_time) , [1 1] .* pars_step.step_size_threshold , '--k' ) ;
ylabel ( 'Cell size' ) ;
% legend ( { '\sigma = \sigma_0' , 'step change' } ) ;
set ( gca , 'FontSize' , axfontsize , 'LineWidth' , axlw ) ;
subplot ( 2 , 1 , 2 ) ;
% plot ( sim_data.traj_time , sim_data.traj_prot , '-b' ) ; hold on ;
plot ( sim_data_step.traj_time , sim_data_step.traj_prot , '-' , 'Color' , 'r' ) ; hold on ;
plot ( minmax_fb(sim_data.traj_time) , [1 1] .* pars_step.P_div_threshold , '--k' ) ;
ylim ( [0 1.1*pars_step.P_div_threshold] ) ; ylabel ( 'Division factor #' ) ; xlabel ( 'Time' ) ;
set ( gca , 'FontSize' , axfontsize , 'LineWidth' , axlw ) ;
set ( gcf , 'Position' , [1 1 fig_w fig_h] ) ;

% set ( gcf , 'Color' , 'None' ) ;
% export_fig ( gcf , 'plots/step_change_analysis.pdf' ) ; close ;

