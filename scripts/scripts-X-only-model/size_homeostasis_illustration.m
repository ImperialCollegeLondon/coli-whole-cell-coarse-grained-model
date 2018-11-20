
%% 
clear ; addpath ( '../simu-code' ) ;

%% 
pars = giveParams ( 'basic' ) ;
pars.sim_duration = 8 ;

%%
sim_data = do_single_sim ( pars ) ;

%%
axfontsize = 25 ; axlw = 2 ;
fig_w = 1000 ; fig_h = 800 ;
subplot ( 2 , 1 , 1 ) ;
plot ( sim_data.traj_time , sim_data.traj_size , 'k' ) ;
ylabel ( 'Cell size' ) ;
set ( gca , 'FontSize' , axfontsize , 'LineWidth' , axlw ) ;
subplot ( 2 , 1 , 2 ) ;
plot ( sim_data.traj_time , sim_data.traj_prot , '-r' ) ; hold on ;
plot ( minmax_fb(sim_data.traj_time) , [1 1] .* pars.P_div_threshold , '--k' ) ;
ylim ( [0 1.1*pars.P_div_threshold] ) ; ylabel ( 'Division factor #' ) ; xlabel ( 'Time' ) ;
set ( gca , 'FontSize' , axfontsize , 'LineWidth' , axlw ) ;
set ( gcf , 'Position' , [1 1 fig_w fig_h] ) ;