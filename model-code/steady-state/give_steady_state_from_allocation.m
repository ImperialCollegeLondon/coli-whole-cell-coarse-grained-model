function steady_state = give_steady_state_from_allocation(cell_pars, env_pars)

if abs(sum(cell_pars.fE + cell_pars.fR + cell_pars.fQ + cell_pars.fU)-1) > 1e-5
    sum(cell_pars.fE + cell_pars.fR + cell_pars.fQ + cell_pars.fU)
    error('incorrect allocation ?');
end

a = fminsearch(@(x)cost_fun(x, cell_pars.fE, cell_pars.fR, env_pars.k, cell_pars.sigma, cell_pars.a_sat, env_pars.cm_kon, cell_pars.cm_koff), cell_pars.a_sat);
C = cost_fun(a, cell_pars.fE, cell_pars.fR, env_pars.k, cell_pars.sigma, cell_pars.a_sat, env_pars.cm_kon, cell_pars.cm_koff);
if C > 1e-5
    C
    error('ss not found');
end

steady_state.a = a;
steady_state.e = cell_pars.fE * (1-a);
steady_state.r = cell_pars.fR * (1-a);
steady_state.q = cell_pars.fQ * (1-a);
steady_state.u = cell_pars.fU * (1-a);
steady_state.alpha = steady_state.e * env_pars.k;
steady_state.ra = steady_state.r / (1 + env_pars.cm_kon / (cell_pars.cm_koff + steady_state.alpha));
steady_state.ri = steady_state.r - steady_state.ra;

end



function C = cost_fun(a, fE, fR, k, sigma, asat, cm_kon, cm_koff)

left_term = fR * sigma * a / (a + asat);
right_term = k * fE * (1-a) + cm_kon - cm_kon * cm_koff / (cm_koff + k * fE * (1-a));
C = (left_term - right_term)^2;

end
