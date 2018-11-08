function [alpha_max,a_max] = give_alpha_max(cell_pars)

a_sat = cell_pars.biophysical.a_sat;
q = cell_pars.constraint.q;

a_max = (a_sat - sqrt(a_sat*q*(a_sat+1-q))) / (a_sat - q);
alpha_max = cell_pars.biophysical.sigma * a_max * (1-q-a_max) / (1-a_max) / (a_max+a_sat);


end

