
% reference composition for data points
data = readtable('../results-data/res3_cell-compositions/basan_2015_si_2017_taheri_2015_modulations.csv'); 
data_no_cm = data(data.cm_type==0,:);

% prediction fX = e, just find the scale factor
scale_factor = fminsearch( @(x)( norm( log(data_no_cm.cell_size) - log(x ./ data_no_cm.model_e ./ (1-data_no_cm.model_a)) ) ), 1);
data.predicted_cell_size_fX_is_e = scale_factor ./ data.model_e ./ (1-data.model_a);

% prediction fX = e / (ra/r)^2/3, just find the scale factor
scale_factor = fminsearch( @(x)( norm( log(data.cell_size) - log(x .* (data.model_ra_over_r).^(2/3) ./ data.model_e ./ (1-data.model_a)) ) ), 1);
data.predicted_cell_size_fX_is_e_over_ra_r_2_3 = scale_factor .* (data.model_ra_over_r).^(2/3) ./ data.model_e ./ (1-data.model_a);

% prediction V = (ra/r)^2/3 / e, just find the scale factor
scale_factor = fminsearch( @(x)( norm( log(data.cell_size) - log(x .* (data.model_ra_over_r).^(2/3) ./ data.model_e) ) ), 1);
data.predicted_cell_size_V_is_ra_r_2_3_over_e = scale_factor .* (data.model_ra_over_r).^(2/3) ./ data.model_e;

% prediction best fX e and ra/r
preds = readtable('../results-data/res4_basan-2015-si-2017-taheri-2015-fit/ref/two-sectors-size-predictions/e_and_ra_over_r_data_fX-true/predictions.csv');
data.predicted_cell_size_fX_e_ra_r_free_exponents = preds.prediction;

% prediction best V e and ra/r
preds = readtable('../results-data/res4_basan-2015-si-2017-taheri-2015-fit/ref/two-sectors-size-predictions/e_and_ra_over_r_data_fX-false/predictions.csv');
data.predicted_cell_size_V_e_ra_r_free_exponents = preds.prediction;

% output
mkdir('../results-data/res16_variants-size-pred/');
writetable(data,'../results-data/res16_variants-size-pred/variants-size-pred.csv');