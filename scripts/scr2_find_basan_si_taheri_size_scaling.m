
%%%%%
% basan and si data are not directly comparable (different labs)
%
% so we search for a simple scaling normalization that render them
% consistent
%
% the well-studied size vs growth rate relationship for nutrient modulation is used
%
%%%%%

function scr2_find_basan_si_taheri_size_scaling()

%%% load data
data_basan = readtable('../external-data/basan_2015_data.csv');
data_si = readtable('../external-data/si_2017_data.csv');
data_taheri = readtable('../external-data/taheri-araghi_2015_data.csv');

%%% filter: nutrient modulation only
data_basan_nutrients = data_basan(data_basan.cm_type==0 & data_basan.useless_type==0, :);
data_si_nutrients = data_si(data_si.cm_type==0 & data_si.useless_type==0, :);
data_taheri_nutrients = data_taheri(data_taheri.cm_type==0 & data_taheri.useless_type==0, :);

%%% find the best scaling (make si data comparable to basan data)
best_scalings = fminsearch(@(x)cost_fun_good_scale(x, data_si_nutrients, data_basan_nutrients, data_taheri_nutrients), [2.0, 2.0]);
best_scaling_si_to_basan = best_scalings(1);
best_scaling_taheri_to_basan = best_scalings(2);
mkdir('../results-data/res2_basan-2015-si-2017-taheri-2015-scale-normalized/');
writetable(table(best_scaling_si_to_basan, best_scaling_taheri_to_basan), '../results-data/res2_basan-2015-si-2017-taheri-2015-scale-normalized/fitted_scaling_si_taheri_to_basan.csv');   

%%% assemble both datasets with normalized in a single table
growth_rate_per_hr = [data_basan.growth_rate_per_hr; data_si.growth_rate_per_hr; data_taheri.growth_rate_per_hr];
cell_size = [data_basan.estim_avg_cell_volume_um3; data_si.estim_vol_um3 .* best_scaling_si_to_basan; data_taheri.avg_cell_volume_um3 .* best_scaling_taheri_to_basan];
nutrient_type = [data_basan.nutrient_type; data_si.nutrient_type; data_taheri.nutrient_type];
cm_type = [data_basan.cm_type; data_si.cm_type; data_taheri.cm_type];
useless_type = [data_basan.useless_type; data_si.useless_type; data_taheri.useless_type];
writetable(table(growth_rate_per_hr, cell_size, nutrient_type, cm_type, useless_type), ...
 '../results-data/res2_basan-2015-si-2017-taheri-2015-scale-normalized/basan-2015-si-2017-taheri-2015_normalized_data.csv');

end


function C = cost_fun_good_scale(scaling, data_si, data_basan, data_taheri)

data_si_basan_taheri_merged.growth_rate = [ data_basan.growth_rate_per_hr ; data_si.growth_rate_per_hr; data_taheri.growth_rate_per_hr ];
data_si_basan_taheri_merged.size = [ data_basan.estim_avg_cell_volume_um3 ; scaling(1) .* data_si.estim_vol_um3 ; scaling(2) .* data_taheri.avg_cell_volume_um3 ];
[~,S] = polyfit(data_si_basan_taheri_merged.growth_rate,log(data_si_basan_taheri_merged.size),1);
C = S.normr;

end

