
addpath('../model-code');
addpath('../model-code/other-models/scott-2010-model');

%%% first, the scott data
% load data
data_scott = readtable('../external-data/scott_2010_data.csv');
% compute composition
composition_scott = compute_cell_composition_from_growth_mod_scott_2010_model(data_scott);
% output 
writetable(composition_scott, '../results-data/resXX_scott-2010-model_cell-compositions/scott_2010_modulations.csv');

%%% second, the basan data
data_basan = readtable('../external-data/basan_2015_data.csv');
% compute composition
composition_basan = compute_cell_composition_from_growth_mod_scott_2010_model(data_basan);
% output
writetable(composition_basan, '../results-data/resXX_scott-2010-model_cell-compositions/basan_2015_modulations.csv');

%%% third, the si data
data_si = readtable('../external-data/si_2017_data.csv');
% compute composition
composition_si = compute_cell_composition_from_growth_mod_scott_2010_model(data_si);
% output
writetable(composition_si, '../results-data/resXX_scott-2010-model_cell-compositions/si_2017_modulations.csv');

%%% fourth, the taheri data
data_taheri = readtable('../external-data/taheri-araghi_2015_data.csv');
% compute composition
composition_taheri = compute_cell_composition_from_growth_mod_scott_2010_model(data_taheri);
% output
writetable(composition_taheri, '../results-data/resXX_scott-2010-model_cell-compositions/taheri_2015_modulations.csv');


%%% fifth, the merged basan and si and taheri with same-scale size data
data_basan_si_taheri = readtable('../results-data/res2_basan-2015-si-2017-taheri-2015-scale-normalized/basan-2015-si-2017-taheri-2015_normalized_data.csv');
% compute composition
composition_basan_si_taheri = compute_cell_composition_from_growth_mod_scott_2010_model(data_basan_si_taheri);
% output
writetable(composition_basan_si_taheri, '../results-data/resXX_scott-2010-model_cell-compositions/basan_2015_si_2017_taheri_2015_modulations.csv');