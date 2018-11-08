function [alpha_max,a_max] = give_alpha_max(cell_pars)

a_sat = cell_pars.biophysical.a_sat;
q = cell_pars.constraint.q;

if q == 0
    a_max = 1;
    alpha_max = cell_pars.biophysical.sigma / (1+a_sat);
    return;
end

if a_sat == 0
    a_max = 0;
    alpha_max = cell_pars.biophysical.sigma * (1-q);
    return;
end

if q == a_sat
    a_max = (1-q)/2;
    alpha_max = cell_pars.biophysical.sigma * a_max * (1-q-a_max) / (1-a_max) / (a_max+a_sat);
    return;
end

% general case
a_max = (a_sat - sqrt(a_sat*q*(a_sat+1-q))) / (a_sat - q);
alpha_max = cell_pars.biophysical.sigma * a_max * (1-q-a_max) / (1-a_max) / (a_max+a_sat);


end

