
%%%%%
% using the steady-state of deterministic model (assuming fX << 1)
% 
% using fitted parameters on scott 2010 ribosomal fraction data
%
%
%%%%%

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

