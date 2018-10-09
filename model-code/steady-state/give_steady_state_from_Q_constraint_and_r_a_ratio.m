function [steady_state,cell_pars] = give_steady_state_from_Q_constraint_and_r_a_ratio( cell_pars , env_pars )

% find the maximum a allowing constraints to be respected
a_max = 1 - ( cell_pars.constraint.q + env_pars.ri ) / ( 1 - cell_pars.allocation.fU );
if a_max < 0
    steady_state.alpha = 0;
    return;
end

% find the a giving the desired ratio r/a (and respecting Q constraint)
a_best = fminbnd( @(a)(costfun_Q_constraint_and_r_a_ratio(a,cell_pars,env_pars)) , 0 , a_max);
[steady_state,cell_pars] = give_steady_state_from_a_and_Q_constraint( a_best , cell_pars , env_pars );

% check the ratio
if abs( steady_state.r / steady_state.a - cell_pars.constraint.r_a_ratio ) / cell_pars.constraint.r_a_ratio > 0.01
    error('did not reach the desired r / a ratio');
end

end

function C = costfun_Q_constraint_and_r_a_ratio(a,cell_pars,env_pars)
steady_state = give_steady_state_from_a_and_Q_constraint( a , cell_pars , env_pars );
C = (steady_state.r/steady_state.a - cell_pars.constraint.r_a_ratio )^2;
end