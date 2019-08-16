
%%%%%
% using the steady-state of deterministic model (assuming fX << 1)
% 
% using fitted parameters on scott 2010 ribosomal fraction data
%
%
%%%%%

addpath('../model-code');
addpath('../model-code/steady-state_optim/');


%%% load fitted model parameters
fitted_pars = readtable('../results-data/res1_scott-2010-fit/fitted-parameters_proteome-allocation.csv');
fitted_pars_low_asat = readtable('../results-data/res1_scott-2010-fit/fitted-parameters_proteome-allocation_good-low-asat.csv');
fitted_pars_high_asat = readtable('../results-data/res1_scott-2010-fit/fitted-parameters_proteome-allocation_good-high-asat.csv');


%%% first, the scott data
% load data
data_scott = readtable('../external-data/scott_2010_data.csv');
% compute composition
composition_scott = compute_cell_composition_from_growth_modulation_optim(fitted_pars, data_scott);
composition_scott_low_sat = compute_cell_composition_from_growth_modulation_optim(fitted_pars_low_asat, data_scott);
composition_scott_high_sat = compute_cell_composition_from_growth_modulation_optim(fitted_pars_high_asat, data_scott);
% output 
writetable(composition_scott, '../results-data/res3_cell-compositions/scott_2010_modulations.csv');
writetable(composition_scott_low_sat, '../results-data/res3_cell-compositions/scott_2010_modulations_low_asat.csv');
writetable(composition_scott_high_sat, '../results-data/res3_cell-compositions/scott_2010_modulations_high_asat.csv');

%%% second, the basan data
data_basan = readtable('../external-data/basan_2015_data.csv');
% compute composition
composition_basan = compute_cell_composition_from_growth_modulation_optim(fitted_pars, data_basan);
composition_basan_low_asat = compute_cell_composition_from_growth_modulation_optim(fitted_pars_low_asat, data_basan);
composition_basan_high_asat = compute_cell_composition_from_growth_modulation_optim(fitted_pars_high_asat, data_basan);
% output
writetable(composition_basan, '../results-data/res3_cell-compositions/basan_2015_modulations.csv');
writetable(composition_basan_low_asat, '../results-data/res3_cell-compositions/basan_2015_modulations_low_asat.csv');
writetable(composition_basan_high_asat, '../results-data/res3_cell-compositions/basan_2015_modulations_high_asat.csv');

%%% third, the si data
data_si = readtable('../external-data/si_2017_data.csv');
% compute composition
composition_si = compute_cell_composition_from_growth_modulation_optim(fitted_pars, data_si);
composition_si_low_asat = compute_cell_composition_from_growth_modulation_optim(fitted_pars_low_asat, data_si);
composition_si_high_asat = compute_cell_composition_from_growth_modulation_optim(fitted_pars_high_asat, data_si);
% output
writetable(composition_si, '../results-data/res3_cell-compositions/si_2017_modulations.csv');
writetable(composition_si_low_asat, '../results-data/res3_cell-compositions/si_2017_modulations_low_asat.csv');
writetable(composition_si_high_asat, '../results-data/res3_cell-compositions/si_2017_modulations_high_asat.csv');


%%% fourth, the taheri data
data_taheri = readtable('../external-data/taheri-araghi_2015_data.csv');
% compute composition
composition_taheri = compute_cell_composition_from_growth_modulation_optim(fitted_pars, data_taheri);
composition_taheri_low_asat = compute_cell_composition_from_growth_modulation_optim(fitted_pars_low_asat, data_taheri);
composition_taheri_high_asat = compute_cell_composition_from_growth_modulation_optim(fitted_pars_high_asat, data_taheri);
% output
writetable(composition_taheri, '../results-data/res3_cell-compositions/taheri_2015_modulations.csv');
writetable(composition_taheri_low_asat, '../results-data/res3_cell-compositions/taheri_2015_modulations_low_asat.csv');
writetable(composition_taheri_high_asat, '../results-data/res3_cell-compositions/taheri_2015_modulations_high_asat.csv');


%%% fifth, the merged basan and si and taheri with same-scale size data
data_basan_si_taheri = readtable('../results-data/res2_basan-2015-si-2017-taheri-2015-scale-normalized/basan-2015-si-2017-taheri-2015_normalized_data.csv');
% compute composition
composition_basan_si_taheri = compute_cell_composition_from_growth_modulation_optim(fitted_pars, data_basan_si_taheri);
composition_basan_si_taheri_low_asat = compute_cell_composition_from_growth_modulation_optim(fitted_pars_low_asat, data_basan_si_taheri);
composition_basan_si_taheri_high_asat = compute_cell_composition_from_growth_modulation_optim(fitted_pars_high_asat, data_basan_si_taheri);
% output
writetable(composition_basan_si_taheri, '../results-data/res3_cell-compositions/basan_2015_si_2017_taheri_2015_modulations.csv');
writetable(composition_basan_si_taheri_low_asat, '../results-data/res3_cell-compositions/basan_2015_si_2017_taheri_2015_modulations_low_asat.csv');
writetable(composition_basan_si_taheri_high_asat, '../results-data/res3_cell-compositions/basan_2015_si_2017_taheri_2015_modulations_high_asat.csv');

