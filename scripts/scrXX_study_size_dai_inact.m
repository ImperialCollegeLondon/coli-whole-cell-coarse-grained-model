
% empirical inactive proteome fraction vs growth rate + fit
dai_data = readtable('../external-data/dai_2016_data.csv');
dai_fit_fun = @(x) 0.9408422 + (0.1557039 - 0.9408422)./(1 + (x./0.1949719).^1.957422);
gr_vec = linspace(0,2,100);
dai_fit_vec = dai_fit_fun(gr_vec);
subplot(2,2,1);
plot(dai_data.growth_rate_per_hr, dai_data.active_ribosome_fraction, 'ko'); hold on;
plot(gr_vec, dai_fit_vec, 'r');

% formula best fit
fitted_size_pars = readtable('../results-data/res4_basan-2015-si-2017-taheri-2015-fit/ref/two-sectors-size-predictions/e_and_ra_over_r_data_fX-true/exponents.csv');      

% compute compo
compos = readtable('../results-data/res3_cell-compositions/basan_2015_si_2017_taheri_2015_modulations.csv');
compos(compos.useless_type > 0,:) = [];
compos(compos.cm_type > 0,:) = [];

%
compos.model_ra_over_r = dai_fit_fun(compos.growth_rate_per_hr);
pred_size_ratio_one = 1 ./ compos.model_e.^1 ./ (1-compos.model_a);
pred_size = 1 ./ (compos.model_e.^1 .* compos.model_ra_over_r.^(-2/3)) ./ (1-compos.model_a);


subplot(2,2,2);
plot( log(compos.cell_size) , log(pred_size_ratio_one) , 'go'); hold on;
pfit_1 = polyfit(log(compos.cell_size), log(pred_size_ratio_one), 1);
plot( [log(0.8) log(10)], polyval(pfit_1,[log(0.8) log(10)]),'k');

subplot(2,2,4);
plot( log(compos.cell_size) , log(pred_size) , 'gs'); hold on;
pfit_2 = polyfit(log(compos.cell_size), log(pred_size), 1);
plot( [log(0.8) log(10)], polyval(pfit_2,[log(0.8) log(10)]),'k');
