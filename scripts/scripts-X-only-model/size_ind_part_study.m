
%%
clear ; addpath ( '../simu-code' ) ;

%%
pars = giveParams ( 'basic' ) ;
pars.kp_0 = 8 ;
pars.mu_media = 0.5 ;
pars.P_div_threshold = 70 ;
pars.P_after_div = pars.P_div_threshold ;
pars.sim_duration = 20000 ;
pars.num_updates_per_output = 100 ;


%%
sim_data = do_single_sim ( pars ) ;
lineage = sim_data.lineage_data ;

%%
n_bins_Vb = 10 ;
[~,I_sort] = sort ( lineage.V_birth ) ;
n_per_bins = floor ( length(I_sort) / n_bins_Vb ) ;
% compute average in each bins
avg_Vbs = zeros ( n_bins_Vb , 1 ) ;
avg_deltaVs = zeros ( n_bins_Vb , 1 ) ;
for i_b = 1:n_bins_Vb
    avg_Vbs(i_b) = mean ( lineage.V_birth(I_sort((i_b-1)*n_per_bins+1:i_b*n_per_bins)) ) ;
    avg_deltaVs(i_b) = mean ( lineage.delta_V(I_sort((i_b-1)*n_per_bins+1:i_b*n_per_bins)) ) ;
end

