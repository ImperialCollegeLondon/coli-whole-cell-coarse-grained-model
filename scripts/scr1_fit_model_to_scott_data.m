
%%% WARNING: IS MOCK NOW %%%
%%% TO-DO: UN-MOCK by cleaning OLD CODE %%%

%%%%%
% Data to fit is scott data where ribosomal fraction is measured (nutrient
% and chloramphenicol 2D 
%
% Three parameters are fitted: sigma, a_sat and q.
%
% Parameter space is explored using a grid-like approach (Sobol sequence).
% The 
%
% The cost function is 
%
%%%%%

function scr1_fit_model_to_scott_data()

%%% parameters of the sobol exploration

%%% perform sobol exploration

%%% find best parameter set and output in table
sigma = 6.1538;
a_sat = 0.0214;
q = 0.466;
fit_pars_table = table(sigma, a_sat, q);
writetable(fit_pars_table, '../results-data/scott-2010-fit/fitted-parameters_proteome-allocation.csv');

end


function cost_fun_scott_fit()
end