

% empirical active proteome fraction vs growth rate + fit
dai_data = readtable('../external-data/dai_2016_data_fig3c.csv');
dai_fit_fun = @(x) 0.9408422 + (0.1557039 - 0.9408422)./(1 + (x./0.1949719).^1.957422);
gr_vec = linspace(0,2,100);
dai_fit_vec = dai_fit_fun(gr_vec);
subplot(1,2,1);
plot(dai_data.growth_rate_per_hr, dai_data.active_ribosome_fraction, 'ko'); hold on;
plot(gr_vec, dai_fit_vec, 'r');
ylabel('Active ribosome fraction');
xlabel('Growth rate (hr^{-1})');
title('Dai et al. Fig 3c and empirical fit');

% 
fitted_size_pars = readtable('../results-data/res6_size-predictions-from-comp/fE_and_active_rib_frac_data_fX-false/exponents.csv');
predictions_best_fit = readtable('../results-data/res6_size-predictions-from-comp/fE_and_active_rib_frac_data_fX-false/predictions.csv');
predictions_best_fit(predictions_best_fit.useless_type > 0,:) = [];
predictions_best_fit(predictions_best_fit.cm_type > 0,:) = [];
empirical_ra_over_r = dai_fit_fun(predictions_best_fit.growth_rate_per_hr);
predictions_size_ratio_non_one = predictions_best_fit.prediction .* empirical_ra_over_r.^(fitted_size_pars.exponent(2));

%
subplot(1,2,2);
plot( log(predictions_best_fit.real) , log(predictions_best_fit.prediction) , 'go'); hold on;
plot( log(predictions_best_fit.real) , log(predictions_size_ratio_non_one) , 'go', 'MarkerFaceColor', 'g'); hold on;
plot( [0 3], [0 3],'k');
title('Effect on size law predictions');
ylabel('log measured size'); xlabel('log predicted size');
legend({'Active ribosome fraction = 1', 'From Dai et al.'}, 'Location', 'NorthWest', 'FontSize', 8);

for i=1:2
    subplot(1,2,i);
    set(gca, 'LineWidth', 1.2, 'FontSize', 10);
end
set(gcf,'Color','w','Position', [0 0 800 350]);

%%
saveas(gcf,['../figure-assembly/components/' 'res13_size_law_dai_inact_rib_nut.pdf']);
close;