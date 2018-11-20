
%%
clear ; addpath ( '../simu-code' ) ;

%%
pars.num_lineages = 1 ;
pars.update_period = 0.001 ;
pars.random_seed = 1 ;

pars.GE_model = 'only_protein' ;
pars.partitioning_type = 'normal' ;
pars.P_div_threshold = 35 ;
pars.P_after_div = pars.P_div_threshold ;
pars.size_splitting_error = 0;
pars.kp_0 = 0 ;

pars.mu_media = 1 ;
pars.linear_growth = 0;

pars.kp_per_size = 25 ;
pars.rp = 0 ;

pars.sim_duration = 30000;
pars.num_updates_per_output = 100;

%%
vary_vec_vec = linspace(0,0.08,4);
sim_datas = varySingleParam( pars , 'size_splitting_error' , vary_vec_vec );

%%
colors = hsv(length(sim_datas)); leg = {};
% subplot(1,2,1);
for i=1:length(sim_datas)
    sim_data = sim_datas{i};
    plot ( sim_data.avg_Vbs ./ sim_data.mean_birth_size , sim_data.avg_deltaVs ./ sim_data.mean_birth_size , ...
        '-o' , 'Color' , colors(i,:) , 'MarkerFaceColor' , colors(i,:)); hold on;
    leg = { leg{:} , ['splitting error = ' num2str(vary_vec_vec(i))] };
end
xlabel ( '<V_{birth}>_{bin} / <V_{birth}>' ) ; ylabel ( '<\Delta V>_{bin} / <V_{birth}>' ) ;
ylim ( [0.9 1.1] ) ; xlim ( [0.75 1.25] ) ;
legend (leg);

% subplot(1,2,2);
% div_rates = cellfun(@(x)(1/x.avg_T_div),sim_datas);
% birth_sizes = cellfun(@(x)(x.mean_birth_size),sim_datas);
% plot ( div_rates , birth_sizes , '-ro' ); hold on;
% plot ([0 div_rates(end)] , [0 birth_sizes(end)] , '--k');
% xlabel ( 'Division rate (1/<T_{div}>)' ) ; ylabel ( 'Mean birth size' ) ;
% xlim([0 1.2*max(div_rates)]); ylim([0 1.2*max(birth_sizes)]);
% 
% set(gcf,'Color','None','Position',[200         479        1258         521]);
export_fig(gcf,'plots/cv_split_analysis_higher_X_noise.pdf');
close;
