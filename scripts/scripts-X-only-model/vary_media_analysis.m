
%%
clear ; addpath ( '../simu-code' ) ;

%%
pars = giveParams ( 'basic' ) ;
pars.P_div_threshold = 70 ; pars.P_after_div = pars.P_div_threshold ;
pars.sim_duration = 20000 ;
pars.num_updates_per_output = 100 ;

%%
mu_media_vec =  linspace ( 0.5 , 3.5 , 4 ) ;

%%
pars.rp = 0 ; pars.kp_0 = 0 ;
sim_datas = varySingleParam ( pars , 'mu_media' , mu_media_vec ) ;
pars.rp = 0.5 ; pars.kp_0 = 0 ;
sim_datas_with_deg = varySingleParam ( pars , 'mu_media' , mu_media_vec ) ;
pars.rp = 0 ; pars.kp_0 = 8 ;
sim_datas_with_kp0 = varySingleParam ( pars , 'mu_media' , mu_media_vec ) ;


%%
mk_size = 6 ; lw = 2 ;
colors = hsv ( length(mu_media_vec) ) ;
%
for i=1:length(mu_media_vec)
    subplot ( 2 , 3 , 4 ) ;
    h1 = plot ( sim_datas{i}.avg_Vbs ./ sim_datas{i}.mean_birth_size , sim_datas{i}.avg_deltaVs ./ sim_datas{i}.mean_birth_size , '-o' , 'MarkerFaceColor' , colors(i,:) , 'Color' , colors(i,:) , 'MarkerSize' , mk_size , 'LineWidth' , lw ) ; hold on ;
    subplot ( 2 , 3 , 5 ) ;
    h2 = plot ( sim_datas_with_deg{i}.avg_Vbs ./ sim_datas_with_deg{i}.mean_birth_size , sim_datas_with_deg{i}.avg_deltaVs ./ sim_datas_with_deg{i}.mean_birth_size , '-o' , 'MarkerFaceColor' , colors(i,:) , 'Color' , colors(i,:) , 'MarkerSize' , mk_size , 'LineWidth' , lw ) ; hold on ;
    subplot ( 2 , 3 , 6 )
    h3 = plot ( sim_datas_with_kp0{i}.avg_Vbs ./ sim_datas_with_kp0{i}.mean_birth_size , sim_datas_with_kp0{i}.avg_deltaVs ./ sim_datas_with_kp0{i}.mean_birth_size , '-o' , 'MarkerFaceColor' , colors(i,:) , 'Color' , colors(i,:) , 'MarkerSize' , mk_size , 'LineWidth' , lw ) ; hold on ;
end
% delta vs birth
% for i=1:length(mu_media_vec)
%     subplot ( 2 , 3 , 4 ) ;
%     h1 = plot ( sim_datas{i}.avg_Vbs , sim_datas{i}.avg_deltaVs , '-o' , 'MarkerFaceColor' , colors(i,:) , 'Color' , colors(i,:) , 'MarkerSize' , mk_size , 'LineWidth' , lw ) ; hold on ;
%     subplot ( 2 , 3 , 5 ) ;
%     h2 = plot ( sim_datas_with_deg{i}.avg_Vbs , sim_datas_with_deg{i}.avg_deltaVs , '-o' , 'MarkerFaceColor' , colors(i,:) , 'Color' , colors(i,:) , 'MarkerSize' , mk_size , 'LineWidth' , lw ) ; hold on ;
%     subplot ( 2 , 3 , 6 )
%     h3 = plot ( sim_datas_with_kp0{i}.avg_Vbs , sim_datas_with_kp0{i}.avg_deltaVs , '-o' , 'MarkerFaceColor' , colors(i,:) , 'Color' , colors(i,:) , 'MarkerSize' , mk_size , 'LineWidth' , lw ) ; hold on ;
% end


% size avg vs mu
vb_4 = 1.98 ;
subplot ( 2 , 3 , 1 ) ;
plot ( mu_media_vec , cellfun ( @(x)(x.mean_birth_size) , sim_datas ) , '-ko' , 'MarkerFaceColor' , 'k' , 'LineWidth' , lw ) ; hold on ;
plot ( [0 4] , [0 vb_4] , '--' , 'Color' , [1 1 1].* 0.5 ) ;
subplot ( 2 , 3 , 2 ) ;
plot ( mu_media_vec , cellfun ( @(x)(x.mean_birth_size) , sim_datas_with_deg ) , '-ko' , 'MarkerFaceColor' , 'k' , 'LineWidth' , lw ) ; hold on ;
plot ( [0 4] , [0 vb_4] , '--' , 'Color' , [1 1 1].* 0.5 ) ;
subplot ( 2 , 3 , 3 )
plot ( mu_media_vec , cellfun ( @(x)(x.mean_birth_size) , sim_datas_with_kp0 ) , '-ko' , 'MarkerFaceColor' , 'k' , 'LineWidth' , lw ) ; hold on ;
plot ( [0 4] , [0 vb_4] , '--' , 'Color' , [1 1 1].* 0.5 ) ;

for i=1:3
    subplot ( 2 , 3 , 3 + i ) ;
%     xlabel ( '<birth size>_{bin}' ) ; ylabel ( '<added size>_{bin}' ) ;
%     xlabel ( '<birth size>_{bin} / <birth size>' ) ; ylabel ( '<added size>_{bin} / <birth size>' ) ;
    xlabel ( '<V_{birth}>_{bin} / <V_{birth}>' ) ; ylabel ( '<\Delta V>_{bin} / <V_{birth}>' ) ;
    ylim ( [0.7 1.3] ) ; xlim ( [0.6 1.4] ) ;
    set ( gca , 'LineWidth' , 2 ) ;
    subplot ( 2 , 3 , i ) ;
    xlabel ( 'Growth rate (doublings per hr)' ) ; ylabel ( '<V_{birth}>' ) ;
    ylim ( [0 2.5] ) ;
    set ( gca , 'LineWidth' , 2 ) ;
end

subplot ( 2 , 3 , 4 ) ;
leg = {} ; for i=1:length(mu_media_vec) ; leg = { leg{:} , [num2str(mu_media_vec(i)) ' dblgs/hr' ] } ; end ;
legend ( leg , 'Location' , 'NorthWest' , 'FontSize' , 16 ) ;

set ( gcf , 'Position' , [200         273        1611         727] ) ;
set ( gcf , 'Color' , 'None' ) ; export_fig ( gcf , 'plots/added_vol_study_vary_media.pdf' ) ; close ;


% legend ( [h1 h2 h3] , { 'basic' , 'with degradation' , 'with partly size-independent synthesis' } , 'Location' , 'NorthWest' , 'FontSize' , 20 ) ;


%%
% col = 'r' ; mksize = 10 ;
% %
% subplot ( 2 , 2 , 1 ) ;
% semilogy ( 1 ./ cellfun(@(x)(x.avg_T_div),sim_datas) , cellfun(@(x)(x.mean_birth_size),sim_datas) , ...
%     '-o' , 'Color' , col , 'MarkerFaceColor' , col , 'MarkerSize' , mksize ) ; hold on ;
% ylabel ( ' <birth size>' ) ; xlim ( [0 4] ) ;
% %
% subplot ( 2 , 2 , 2 ) ; plot ( 1 ./ cellfun(@(x)(x.avg_T_div),sim_datas) , cellfun(@(x)(x.CV_birth_size),sim_datas) , ...
%     '-o' , 'Color' , col , 'MarkerFaceColor' , col , 'MarkerSize' , mksize ) ; hold on ;
% ylabel ( 'CV birth size' ) ; ylim ( [0 0.3] ) ;  xlim ( [0 4] ) ;
% %
% subplot ( 2 , 2 , 3 ) ; plot ( 1 ./ cellfun(@(x)(x.avg_T_div),sim_datas) , cellfun(@(x)(x.corr_V_birth_delta_V),sim_datas) , ...
%     '-o' , 'Color' , col , 'MarkerFaceColor' , col , 'MarkerSize' , mksize ) ; hold on ;
% xlabel ( '\mu' ) ; ylabel ( '\Delta size / birth size corr' ) ; ylim ( [-0.8 0.8] ) ; xlim ( [0 4] ) ;
% %
% subplot ( 2 , 2 , 4 ) ; plot ( 1 ./ cellfun(@(x)(x.avg_T_div),sim_datas) , cellfun(@(x)(x.CV_T_div),sim_datas) , ...
%     '-o' , 'Color' , col , 'MarkerFaceColor' , col , 'MarkerSize' , mksize ) ; hold on ;
% xlabel ( '\mu' ) ; ylabel ( 'CV div time' ) ; ylim ( [0 0.3] ) ; xlim ( [0 4] ) ;
