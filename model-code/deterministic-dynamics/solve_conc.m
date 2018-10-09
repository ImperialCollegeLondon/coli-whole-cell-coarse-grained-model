function traj = solve_conc( init_cell_state , cell_pars , env_pars , duration )

% create state vector
y_0 = zeros(1,5);
y_0(1) = init_cell_state.a;
y_0(2) = init_cell_state.e;
y_0(3) = init_cell_state.r;
y_0(4) = init_cell_state.q;
y_0(5) = init_cell_state.u;

% check validity of initial state
if sum(y_0) ~= 1
    error('sum of concentrations have to be one');
end
if min(y_0) < 0
    error('all concentrations must be positive');
end

% check validity of parameters
if sum(cell_pars.allocation.fE+cell_pars.allocation.fR+cell_pars.allocation.fQ+cell_pars.allocation.fU) ~= 1
    error('sum of allocation fractions must be one');
end
if cell_pars.allocation.fE < 0 || cell_pars.allocation.fR < 0 || cell_pars.allocation.fQ < 0 || cell_pars.allocation.fU < 0
    error('allocation fractions must be positive');
end

% call solver routine
[t,y]= ode23s(@(t,y) derivs_conc(t, y, cell_pars, env_pars), [0 duration], y_0);

% extract trajectory from matrix
traj.t = t;
traj.a = y(:,1);
traj.e = y(:,2);
traj.r = y(:,3);
traj.q = y(:,4);
traj.u = y(:,5);

end

