
%% 
clear ; addpath ( '../simu-code' ) ;



%% fixed model params
pars.GE_model = 'only_protein' ;
pars.partitioning_type = 'normal' ;
pars.P_div_threshold = 60 ;
pars.P_after_div = pars.P_div_threshold ;
pars.kp_0 = 0 ;
pars.rp = 0 ;

%% simulation parameters
pars.num_lineages = 1 ;
pars.update_period = 0.005 ;
pars.random_seed = 100 ;

%% to vary: growth media
mu_media_vec = transpose ( linspace ( 1 , 3.7 , 11 ) ) ;
pars_var.kp_per_size_mu_ref = 120 ;


%% create vectors getting data
mean_birth_size = zeros ( size(mu_media_vec) ) ;
CV_birth_size = zeros ( size(mu_media_vec) ) ;
CV_T_div = zeros ( size(mu_media_vec) ) ;
corr_V_birth_delta_V = zeros ( size(mu_media_vec) ) ;

%% redo-sims longer to get lineages
pars.sim_duration = 5000 ;
pars.num_updates_per_output = 100 ;
for i_m = 1:length(mu_media_vec)
    % set the value
    pars.mu_media = mu_media_vec(i_m) ;
    pars.kp_per_size = pars_var.kp_per_size_mu_ref * exp ( - 0.8 * pars.mu_media ) * pars.mu_media ;
    % do the simulation
    sim_data = do_single_sim ( pars ) ;
    lineage_data = sim_data.lineage_data ;
    % burn the 100 first cell_cycle
    lineage_data = lineage_data(101:end,:) ;
    % compute the needed statistics
    mean_birth_size(i_m) = mean(lineage_data.V_birth) ;
    CV_birth_size(i_m) = compute_CV(lineage_data.V_birth) ;
    CV_T_div(i_m) = compute_CV(lineage_data.T_div) ;
    corr_V_birth_delta_V(i_m) = corr_fb ( lineage_data.V_birth , lineage_data.delta_V ) ;
end

%% data SJ

SJ_volume = [1.164	0.427 ;
1.176	0.468 ;
1.579	0.592 ;
1.980	0.800 ;
2.241	1.040 ;
2.652	1.655 ;
3.491	2.721] ;

SJ_CV_birth_size =  [ 0.18 0.15 0.1137 0.1166 0.1152 0.1548 0.1412 ] ;
SJ_CV_birth_size = SJ_CV_birth_size([7 6 5 4 3 2 1] ) ;

%% plotting
colors = hsv(1) ; col = colors(1,:) ; mksize = 5 ; ax_lw = 2 ;
subplot ( 1 , 2 , 1 ) ; semilogy ( mu_media_vec , mean_birth_size , ...
    '-o' , 'Color' , col , 'MarkerFaceColor' , col , 'MarkerSize' , mksize ) ; hold on ;
plot ( SJ_volume(:,1) , SJ_volume(:,2) , 'ko' ) ;
ylabel ( ' <birth size> (\mum^3)' ) ; ylim ( [0.3 4] ) ; xlim ( [0 4] ) ;
xlabel ( '\mu (doublings/hr)' ) ;
set ( gca , 'YTick' , [0.1 0.5 1 2 3] , 'LineWidth' , ax_lw ) ;
legend ( { 'model' , 'Taheri-Araghi et al. data' } , 'Location' , 'NorthWest' , 'FontSize' , 20 ) ; 
subplot ( 1 , 2 , 2 ) ; plot ( mu_media_vec , CV_birth_size , ...
    '-o' , 'Color' , col , 'MarkerFaceColor' , col , 'MarkerSize' , mksize ) ; hold on ;
plot ( SJ_volume(:,1) , SJ_CV_birth_size , 'ko' ) ;
ylabel ( 'CV birth size' ) ; ylim ( [0 0.3] ) ;  xlim ( [0 4] ) ;
xlabel ( '\mu (doublings/hr)' ) ;
set ( gca , 'LineWidth' , ax_lw ) ;

set ( gcf , 'Position' , [ 200         576        1400         424] ) ;
set ( gcf , 'Color' , 'None' ) ; export_fig ( gcf , 'plots/reprod_SJ.pdf' ) ; close ;


%  , 'Position' , [200   390   1000   610] ) ;

% subplot ( 2 , 2 , 3 ) ; plot ( mu_media_vec , corr_V_birth_delta_V , ...
%     '-o' , 'Color' , col , 'MarkerFaceColor' , col , 'MarkerSize' , mksize ) ; hold on ;
% xlabel ( '\mu' ) ; ylabel ( '\Delta size / birth size corr' ) ; ylim ( [-0.8 0.8] ) ; xlim ( [0 4] ) ;
% subplot ( 2 , 2 , 4 ) ; plot ( mu_media_vec , CV_T_div , ...
%     '-o' , 'Color' , col , 'MarkerFaceColor' , col , 'MarkerSize' , mksize ) ; hold on ;
% xlabel ( '\mu' ) ; ylabel ( 'CV div time' ) ; ylim ( [0 0.3] ) ; xlim ( [0 4] ) ;

