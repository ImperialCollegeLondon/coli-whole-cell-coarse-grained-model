
%%%%%
% using the steady-state of deterministic model (assuming fX << 1)
% 
% using fitted parameters on scott 2010 ribosomal fraction data
%
%
%%%%%

addpath('../model-code');
addpath('../model-code/steady-state');


%%% load fitted model parameters
fitted_pars = readtable('../results-data/res1_scott-2010-fit/fitted-parameters_proteome-allocation.csv');


%%% first, the scott data
% load data
data_scott = readtable('../external-data/scott_2010_data.csv');
% compute composition
composition_scott = compute_cell_composition_from_growth_modulation(fitted_pars, data_scott);
% output 
writetable(composition_scott, '../results-data/res3_cell-compositions/scott_2010_modulations.csv');

%%% second, the basan data
data_basan = readtable('../external-data/basan_2015_data.csv');
% compute composition
composition_basan = compute_cell_composition_from_growth_modulation(fitted_pars, data_basan);
% output
writetable(composition_basan, '../results-data/res3_cell-compositions/basan_2015_modulations.csv');

%%% third, the si data
data_si = readtable('../external-data/si_2017_data.csv');
% compute composition
composition_si = compute_cell_composition_from_growth_modulation(fitted_pars, data_si);
% output
writetable(composition_si, '../results-data/res3_cell-compositions/si_2017_modulations.csv');

%%% fourth, the merged basan and si with same-scale size data
data_basan_si = readtable('../results-data/res2_basan-2015-si-2017-scale-normalized/basan-2015-si-2017_normalized_data.csv');
% compute composition
composition_basan_si = compute_cell_composition_from_growth_modulation(fitted_pars, data_basan_si);
% output
writetable(composition_basan_si, '../results-data/res3_cell-compositions/basan_2015_si_2017_modulations.csv');
