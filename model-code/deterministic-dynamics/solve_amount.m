function traj = solve_amount( init_cell_state , cell_pars , env_pars , duration )

% create state vector
y_0 = zeros(1,6);
y_0(1) = init_cell_state.A;
y_0(2) = init_cell_state.E;
y_0(3) = init_cell_state.R;
y_0(4) = init_cell_state.Q;
y_0(5) = init_cell_state.U;
y_0(6) = init_cell_state.X;

% check validity of initial state
if min(y_0) < 0
    error('all amounts must be positive');
end

% check validity of parameters
if (sum(cell_pars.allocation.fE+cell_pars.allocation.fR+cell_pars.allocation.fQ+cell_pars.allocation.fU+cell_pars.allocation.fX) - 1) > 1e-12
    error('sum of allocation fractions must be one');
end
if cell_pars.allocation.fE < 0 || cell_pars.allocation.fR < 0 || cell_pars.allocation.fQ < 0 || cell_pars.allocation.fU || cell_pars.allocation.fX < 0
    error('allocation fractions must be positive');
end

% solver options: set division event
options = odeset('Events',@(t,y)division_event(t,y,cell_pars.division.X_div));

% trajectory data
t_tot = 0;
y_tot = y_0;

% call solver routine until total duration reached
while t_tot(end) < duration
    % integrate until next div
    [t,y,te,ye,~]= ode23s(@(t,y) derivs_amount(t, y, cell_pars, env_pars), [0 1e5], y_0 , options);
    % store data
    t_tot = [t_tot ; [t;te] + t_tot(end)];
    y_tot = [ y_tot ; [y;ye] ];
    
    % divide cell content in two
    y_0 = y(end,:) ./ 2;
end

% extract trajectory from matrix
traj.t = t_tot;
traj.A = y_tot(:,1);
traj.E = y_tot(:,2);
traj.R = y_tot(:,3);
traj.Q = y_tot(:,4);
traj.U = y_tot(:,5);
traj.X = y_tot(:,6);
traj.M_or_V = sum(y_tot,2);

end

