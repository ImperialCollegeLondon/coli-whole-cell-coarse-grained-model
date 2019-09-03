
% reference composition for data points
data = readtable('../results-data/resXX_coreg-low-delta-model_cell-compositions/basan_2015_si_2017_taheri_2015_modulations.csv'); 
% prediction V = (ra/r)^2/3 / e, just find the scale factor
scale_factor = fminsearch( @(x)( norm( log(data.cell_size) - log(x .* (data.model_active_rib_frac).^(2/3) ./ data.model_fE) ) ), 1);
data.predicted_cell_size_V_is_fRA_fR_2_3_over_fE = scale_factor .* (data.model_active_rib_frac).^(2/3) ./ data.model_fE;

% output
mkdir('../results-data/resXX_coreg-low-delta_variants-size-pred/');
writetable(data,'../results-data/resXX_coreg-low-delta_variants-size-pred/variants-size-pred.csv');