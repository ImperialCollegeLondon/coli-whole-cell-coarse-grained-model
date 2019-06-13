
% empirical active proteome fraction vs growth rate + fit
dai_data = readtable('../external-data/dai_2016_data.csv');
dai_fit_fun = @(x) 0.9408422 + (0.1557039 - 0.9408422)./(1 + (x./0.1949719).^1.957422);
gr_vec = linspace(0,2,100);
dai_fit_vec = dai_fit_fun(gr_vec);
subplot(2,2,1);
plot(dai_data.growth_rate_per_hr, dai_data.active_ribosome_fraction, 'ko'); hold on;
plot(gr_vec, dai_fit_vec, 'r');
ylabel('Active ribosome fraction');
xlabel('Growth rate (hr^{-1})');
title('Dai et al. Fig 3c and empirical fit');

% formula best fit
fitted_size_pars = readtable('../results-data/res4_basan-2015-si-2017-taheri-2015-fit/ref/e_and_ra_over_r_data_fX-true/exponents.csv');
predictions_best_fit = readtable('../results-data/res4_basan-2015-si-2017-taheri-2015-fit/ref/e_and_ra_over_r_data_fX-true/predictions.csv');
predictions_best_fit(predictions_best_fit.useless_type > 0,:) = [];
predictions_best_fit(predictions_best_fit.cm_type > 0,:) = [];

%
empirical_ra_over_r = dai_fit_fun(predictions_best_fit.growth_rate_per_hr);
predictions_size_ratio_non_one = predictions_best_fit.prediction .* empirical_ra_over_r.^(-fitted_size_pars.exponents(2));


subplot(2,2,2);
plot( log(predictions_best_fit.real) , log(predictions_best_fit.prediction) , 'go'); hold on;
plot( [0 3], [0 3],'k');
title('Size prediction with active ribosome ratio equal 1');
ylabel('log measured size'); xlabel('log predicted size');


subplot(2,2,4);
plot( log(predictions_best_fit.real) , log(predictions_size_ratio_non_one) , 'gs'); hold on;
plot( [0 3], [0 3],'k');
title('Size prediction with active ribosome ratio empirical from Dai');
ylabel('log measured size'); xlabel('log predicted size');

