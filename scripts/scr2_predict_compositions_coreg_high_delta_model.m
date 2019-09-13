
addpath('../model-code/');

output_folder = '../results-data/res2_compositions_coreg-high-delta-model/';
if ~exist(output_folder, 'dir')
    mkdir(output_folder);
end

%%% the scott data alone
% load data
data_scott = readtable('../external-data/scott_2010_data.csv');
% compute composition
composition_scott = compute_cell_composition_from_growth_mod_coreg_high_delta(data_scott);
% output 
writetable(composition_scott, [output_folder, 'scott_2010_modulations.csv']);

%%% the dai data alone
% load data
data_dai = readtable('../external-data/dai_2016_data.csv');
% compute composition
composition_dai = compute_cell_composition_from_growth_mod_coreg_high_delta(data_dai);
% output 
writetable(composition_dai, [output_folder 'dai_2016_modulations.csv']);

%%% the merged basan and si and taheri with same-scale size data
data_basan_si_taheri = readtable('../results-data/res1_size-normalization/basan-2015-si-2017-taheri-2015_normalized_data.csv');
% compute composition
composition_basan_si_taheri = compute_cell_composition_from_growth_mod_coreg_high_delta(data_basan_si_taheri);
% output
writetable(composition_basan_si_taheri, [output_folder, 'basan_2015_si_2017_taheri_2015_modulations.csv']);