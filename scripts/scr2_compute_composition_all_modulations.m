
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
writetable(composition_scott, '../results-data/res2_cell-compositions/scott_2010_modulations.csv');

%%% second, the basan data
data_basan = readtable('../external-data/basan_2015_data.csv');
% compute composition
composition_basan = compute_cell_composition_from_growth_modulation(fitted_pars, data_basan);
% output
writetable(composition_basan, '../results-data/res2_cell-compositions/basan_2015_modulations.csv');

%%% third, the si data
data_si = readtable('../external-data/si_2017.csv');
% compute composition
composition_si = compute_cell_composition_from_growth_modulation(fitted_pars, data_si);
% output
writetable(composition_si, '../results-data/res2_cell-compositions/si_2017_modulations.csv');
