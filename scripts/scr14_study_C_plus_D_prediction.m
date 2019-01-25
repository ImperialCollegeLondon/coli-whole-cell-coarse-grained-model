
% prediction of prefered model
preds = readtable('../results-data/res4_basan-2015-si-2017-taheri-2015-fit/ref/two-sectors-size-predictions/e_and_ra_over_r_data_fX-true/predictions.csv');

% keep only Si et al data
preds = preds(preds.nutrient_type>=7,:);
preds = preds(preds.nutrient_type<12,:);

% raw data Si et al
data = readtable('../external-data/si_2017_data.csv');
S0 = 2.56 * 0.28; % 0.28 from paper for S0, applying the size scaling factor found in Figure S2

% compute the predicted C+D according to our size estimate !
C_plus_D_pred = (log(preds.prediction)-log(S0)) ./ preds.growth_rate_per_hr;

% output in a table
mkdir('../results-data/res14_study-C-plus-D/');
C_plus_D_measured = data.estim_C_plus_D_hrs;
growth_rate_per_hr = preds.growth_rate_per_hr;
nutrient_type = preds.nutrient_type;
cm_type = preds.cm_type;
useless_type = preds.useless_type;
output_table = table(growth_rate_per_hr, C_plus_D_measured, C_plus_D_pred, nutrient_type, cm_type, useless_type);
writetable(output_table, '../results-data/res14_study-C-plus-D/C_plus_D_predictions.csv');


