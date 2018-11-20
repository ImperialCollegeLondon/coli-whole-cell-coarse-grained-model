
%% 
clear ; addpath ( '../simu-code' ) ;

%% 
pars = giveParams ( 'basic' ) ;
pars.sim_duration = 100 ;
pars.kp_per_size = 0 ;
pars.kp_0 = 50 ;
pars_step = pars ;
pars_step.GE_model = 'only_protein_step_change' ;
pars_step.P_step_threshold = round ( 0.75 * pars.P_div_threshold ) ;
pars_step.random_seed = 2 ;

%%
sim_data = do_single_sim ( pars ) ;
sim_data_step = do_single_sim ( pars_step ) ;

%%
axfontsize = 25 ; axlw = 2 ;
fig_w = 1000 ; fig_h = 800 ;
subplot ( 2 , 1 , 1 ) ;
semilogy ( sim_data.traj_time , sim_data.traj_size , 'b' ) ; hold on ;
semilogy ( sim_data_step.traj_time , sim_data_step.traj_size , 'Color' , 'r' ) ; hold on ;
ylabel ( 'Cell size' ) ;
legend ( { '\sigma = \sigma_0' , 'step change' } ) ;
set ( gca , 'FontSize' , axfontsize , 'LineWidth' , axlw ) ;
subplot ( 2 , 1 , 2 ) ;
plot ( sim_data.traj_time , sim_data.traj_prot , '-b' ) ; hold on ;
plot ( sim_data_step.traj_time , sim_data_step.traj_prot , '-' , 'Color' , 'r' ) ; hold on ;
plot ( minmax_fb(sim_data.traj_time) , [1 1] .* pars.P_div_threshold , '--k' ) ;
ylim ( [0 1.1*pars.P_div_threshold] ) ; ylabel ( 'Division factor #' ) ; xlabel ( 'Time' ) ;
set ( gca , 'FontSize' , axfontsize , 'LineWidth' , axlw ) ;
set ( gcf , 'Position' , [1 1 fig_w fig_h] ) ;

% set ( gcf , 'Color' , 'None' ) ;
% export_fig ( gcf , 'plots/step_change_analysis.pdf' ) ; close ;

