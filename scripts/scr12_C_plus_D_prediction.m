
output_folder = '../results-data/res12_C-plus-D/';
if ~exist(output_folder, 'dir')
    mkdir(output_folder);
end

% prediction of prefered model
preds = readtable('../results-data/res6_size-predictions-from-comp/fE_and_active_rib_frac_data_fX-false/predictions.csv');

% keep only Si et al data
preds = preds(strcmp(preds.source,'Si 2017'),:);

% raw data Si et al
data = readtable('../external-data/si_2017_data.csv');
size_norm = readtable('../results-data/res1_size-normalization/fitted_scaling_si_taheri_to_basan.csv');
S0 = size_norm.best_scaling_si_to_basan * 0.28; % 0.28 from paper for S0, applying the size scaling factor found when normalizing size measurements across studies

% compute the predicted C+D according to our size estimate !
C_plus_D_pred = (log(preds.prediction)-log(S0)) ./ preds.growth_rate_per_hr;

% output in a table
C_plus_D_measured = data.estim_C_plus_D_hrs;
growth_rate_per_hr = preds.growth_rate_per_hr;
nutrient_type = preds.nutrient_type;
cm_type = preds.cm_type;
useless_type = preds.useless_type;
output_table = table(growth_rate_per_hr, C_plus_D_measured, C_plus_D_pred, nutrient_type, cm_type, useless_type);
writetable(output_table, [output_folder '/C_plus_D_predictions.csv']);


