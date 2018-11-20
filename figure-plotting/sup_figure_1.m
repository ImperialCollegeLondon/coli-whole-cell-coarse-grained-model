

%% load the summary of scott fit
best_fit_pars = readtable('../results-data/res1_scott-2010-fit/summary-best-pars.csv');

%% selected a_sat values
a_sat_values_good = [0.001, 0.02, 0.1];
a_sat_values_bad = [2];


%% show the landscape for those selected values
figure(1);
i = 1; cscale_min = 1e300; cscale_max = -1e300;
for a_sat=[a_sat_values_good, a_sat_values_bad]
    subplot(1,4,i);
    data = readtable(['../results-data/res1_scott-2010-fit/sobol-exploration-with-cost_asat-' num2str(a_sat) '.csv']);
    % plot sobol points as scatter with color coded cost
    scatter(data.sigma, data.q, [], data.log_goodness_fit, 'filled'); hold on
    % add the local fit value
    color_style = 'g^'; color_marker = 'g';
    if ismember(a_sat_values_bad, a_sat)
        color_style = 'rd'; color_marker = 'r';
    end
    plot( best_fit_pars.sigma_best_local(best_fit_pars.a_sat==a_sat), best_fit_pars.q_best_local(best_fit_pars.a_sat==a_sat), color_style, 'MarkerFaceColor', color_marker, 'MarkerSize', 20);
    title(['a_{sat} = ' num2str(a_sat)]);
    c = colorbar;
    if i==4
        c.Label.String = 'log mean square error';
    end
    cscale = caxis;
    if cscale(1) < cscale_min; cscale_min = cscale(1); end
    if cscale(2) > cscale_max; cscale_max = cscale(2); end
    ylabel('q'); xlabel('\sigma');
    xlim([4 200]);
    i=i+1;
end
for i=1:4
    subplot(1,4,i);
    caxis([cscale_min, cscale_max]);
    %if i<4; colorbar off; end
    set(gca,'xscale','log','FontSize',20,'LineWidth',2,'XTick',[5 20 100]);    
end
set(gcf,'Position',[-207 276 2289 509],'Color','w');
addpath('../utils-code/export_fig');
export_fig(gcf,'../figure-assembly/sup-figure-1-components/sup_figure_1_scott_fit_goodness_different_asat.pdf');



%% show the best scott fit for those selected values
figure(2);
lw = 3;
mk_size = 15;
i = 1;
for a_sat=[a_sat_values_good, a_sat_values_bad]
    subplot(1,4,i);
    data = readtable(['../results-data/res1_scott-2010-fit/scott-predictions_local-fixed-asat-fit_asat-' num2str(a_sat) '.csv']);
    nutrients = sort(unique(data.nutrient_type));
    colors = hsv(length(nutrients)+1);
    for i_nut=1:length(nutrients)
        this_data = data(data.nutrient_type==nutrients(i_nut) & data.useless_type==0, :);
        plot(this_data.growth_rate_per_hr, this_data.estim_ribosomal_fraction, 'o', 'MarkerFaceColor', colors(i_nut,:), 'Color', colors(i_nut,:), 'MarkerSize', mk_size); hold on;
        plot(this_data.model_growth_rate, this_data.model_r ./ (1-this_data.model_a), 'Color', colors(i_nut,:), 'LineWidth', lw); hold on;
    end
    title(['a_{sat} = ' num2str(a_sat)]);
    ylim([0 0.6]); xlim([0 2]);
    ylabel('ribosomal proteome fraction'); xlabel('growth rate (hr^{-1})');
    set(gca,'FontSize',20,'LineWidth',2);
    i=i+1;
end
set(gcf,'Position',[0 0 2000 400],'Color','w');
addpath('../utils-code/export_fig');
export_fig(gcf,'../figure-assembly/sup-figure-1-components/sup_figure_1_scott_fit_plot_different_asat.pdf');




%% show the best fit vs a_sat
figure(3);
lw = 2; mk_size = 12;
subplot(1,3,1); 
semilogx(best_fit_pars.a_sat, best_fit_pars.cost_best_local, '-ko', 'MarkerFaceColor', 'k', 'MarkerSize', mk_size, 'LineWidth', lw); hold on;
semilogx(best_fit_pars.a_sat(ismember(best_fit_pars.a_sat,a_sat_values_good)), best_fit_pars.cost_best_local(ismember(best_fit_pars.a_sat,a_sat_values_good)), 'g^', 'MarkerFaceColor', 'g', 'MarkerSize', mk_size, 'LineWidth', lw); hold on;
semilogx(best_fit_pars.a_sat(ismember(best_fit_pars.a_sat,a_sat_values_bad)), best_fit_pars.cost_best_local(ismember(best_fit_pars.a_sat,a_sat_values_bad)), 'rd', 'MarkerFaceColor', 'r', 'MarkerSize', mk_size, 'LineWidth', lw); hold on;
ylim([-7 -6]);
ylabel('log mean square error');
subplot(1,3,2); 
semilogx(best_fit_pars.a_sat, best_fit_pars.sigma_best_local, '-ko', 'MarkerFaceColor', 'k', 'MarkerSize', mk_size, 'LineWidth', lw); hold on;
semilogx(best_fit_pars.a_sat(ismember(best_fit_pars.a_sat,a_sat_values_good)), best_fit_pars.sigma_best_local(ismember(best_fit_pars.a_sat,a_sat_values_good)), 'g^', 'MarkerFaceColor', 'g', 'MarkerSize', mk_size, 'LineWidth', lw); hold on;
semilogx(best_fit_pars.a_sat(ismember(best_fit_pars.a_sat,a_sat_values_bad)), best_fit_pars.sigma_best_local(ismember(best_fit_pars.a_sat,a_sat_values_bad)), 'rd', 'MarkerFaceColor', 'r', 'MarkerSize', mk_size, 'LineWidth', lw); hold on;
ylabel('\sigma');
subplot(1,3,3); 
semilogx(best_fit_pars.a_sat, best_fit_pars.q_best_local, '-ko', 'MarkerFaceColor', 'k', 'MarkerSize', mk_size, 'LineWidth', lw);  hold on;
semilogx(best_fit_pars.a_sat(ismember(best_fit_pars.a_sat,a_sat_values_good)), best_fit_pars.q_best_local(ismember(best_fit_pars.a_sat,a_sat_values_good)), 'g^', 'MarkerFaceColor', 'g', 'MarkerSize', mk_size, 'LineWidth', lw); hold on;
semilogx(best_fit_pars.a_sat(ismember(best_fit_pars.a_sat,a_sat_values_bad)), best_fit_pars.q_best_local(ismember(best_fit_pars.a_sat,a_sat_values_bad)), 'rd', 'MarkerFaceColor', 'r', 'MarkerSize', mk_size, 'LineWidth', lw); hold on;
ylabel('q');
for i=1:3
    subplot(1,3,i);
    xlabel('a_{sat}');
    set(gca,'FontSize',20,'LineWidth',2);    
end
set(gcf,'Position',[0 0 2000 400],'Color','w');
addpath('../utils-code/export_fig');
export_fig(gcf,'../figure-assembly/sup-figure-1-components/sup_figure_1_scott_fit_summary_different_asat.pdf');




%%
close all;












