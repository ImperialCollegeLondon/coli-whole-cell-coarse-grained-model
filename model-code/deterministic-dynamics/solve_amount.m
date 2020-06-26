function traj = solve_amount( init_cell_state , cell_pars , env_pars , duration )

% create state vector
y_0 = zeros(1,7);
y_0(1) = init_cell_state.A;
y_0(2) = init_cell_state.E;
y_0(3) = init_cell_state.RA;
y_0(4) = init_cell_state.RI;
y_0(5) = init_cell_state.Q;
y_0(6) = init_cell_state.U;
y_0(7) = init_cell_state.X;

% check validity of initial state
if min(y_0) < 0
    error('all amounts must be positive');
end

% check validity of parameters
if (sum(cell_pars.fQ+cell_pars.fU+cell_pars.fX) >= 1)
    error('sum of allocation fractions for Q/U/X must be less than one');
end
if (cell_pars.fQ < 0 || cell_pars.fU < 0 || cell_pars.fX < 0)
    error('allocation fractions must be positive');
end

% solver options: set division event
options = odeset('Events',@(t,y)division_event(t,y,cell_pars.X_div));

% trajectory data
t_tot = 0;
y_tot = y_0;

% call solver routine until total duration reached
while t_tot(end) < duration
    % integrate until next div
    [t,y,te,ye,~]= ode45(@(t,y) derivs_amount(t, y, cell_pars, env_pars), [0 1000], y_0 , options);
    % store data
    t_tot = [t_tot ; [t;te] + t_tot(end)];
    y_tot = [ y_tot ; [y;ye] ];
    
    % divide cell content in two
    %disp('div');
    y_0 = y(end,:) ./ 2;
end

if t_tot(end) > duration
    I = find(t_tot <= duration, 1, 'last');
    t_tot = t_tot(1:I);
    y_tot = y_tot(1:I,:);
end

% extract trajectory from matrix
traj.t = t_tot;
traj.A = y_tot(:,1);
traj.E = y_tot(:,2);
traj.RA = y_tot(:,3);
traj.RI = y_tot(:,4);
traj.R = traj.RA + traj.RI;
traj.Q = y_tot(:,5);
traj.U = y_tot(:,6);
traj.X = y_tot(:,7);
traj.M_or_V = sum(y_tot,2);
traj.total_prot = sum(y_tot(:,2:end),2);

end

