
%%%%%
% basan and si data are not directly comparable (different labs)
%
% so we search for a simple scaling normalization that render them
% consistent
%
% the well-studied size vs growth rate relationship for nutrient modulation is used
%
%%%%%

function scr3_find_basan_si_size_scaling()

%%% load data
data_basan = readtable('../external-data/basan_2015_data.csv');
data_si = readtable('../external-data/si_2017_data.csv');

%%% filter: nutrient modulation only
data_basan_nutrients = data_basan(data_basan.cm_type==0 & data_basan.useless_type==0, :);
data_si_nutrients = data_si(data_si.cm_type==0 & data_si.useless_type==0, :);

%%% find the best scaling (make si data comparable to basan data)
best_scaling_si_to_basan = fminsearch(@(x)cost_fun_good_scale(x, data_si_nutrients, data_basan_nutrients), 2.0);
writetable(table(best_scaling_si_to_basan), '../results-data/res2_basan-2015-si-2017-scale-normalized/fitted_scaling_si_to_basan.csv');   

%%% assemble both datasets with normalized in a single table
growth_rate_per_hr = [data_basan.growth_rate_per_hr; data_si.growth_rate_per_hr];
cell_size = [data_basan.estim_avg_cell_volume_um3; data_si.estim_vol_um3 .* best_scaling_si_to_basan];
nutrient_type = [data_basan.nutrient_type; data_si.nutrient_type];
cm_type = [data_basan.cm_type; data_si.cm_type];
useless_type = [data_basan.useless_type; data_si.useless_type];
writetable(table(growth_rate_per_hr, cell_size, nutrient_type, cm_type, useless_type), ...
 '../results-data/res2_basan-2015-si-2017-scale-normalized/basan-2015-si-2017_normalized_data.csv');

end


function C = cost_fun_good_scale(scaling, data_si, data_basan)

data_si_basan_merged.growth_rate = [ data_basan.growth_rate_per_hr ; data_si.growth_rate_per_hr ];
data_si_basan_merged.size = [ data_basan.estim_avg_cell_volume_um3 ; scaling .* data_si.estim_vol_um3];
[~,S] = polyfit(data_si_basan_merged.growth_rate,log(data_si_basan_merged.size),1);
C = S.normr;

end

