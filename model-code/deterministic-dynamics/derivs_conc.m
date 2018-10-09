function dy_dt = derivs_conc( ~ , cell_state_vec , cell_pars , env_pars )

% to store derivatives
dy_dt = zeros(5,1);

% vector to names
cell_state.a = cell_state_vec(1);
cell_state.e = cell_state_vec(2);
cell_state.r = cell_state_vec(3);
cell_state.q = cell_state_vec(4);
cell_state.u = cell_state_vec(5);

% total synthesis rate
total_synthesis = cell_pars.biophysical.sigma * (cell_state.r - env_pars.ri) * cell_state.a / (cell_state.a + cell_pars.biophysical.a_sat);

% size growth rate (instantaneous)
alpha = env_pars.k * cell_state.e;

% a concentration
dy_dt(1) = alpha - total_synthesis - alpha * cell_state.a;

% e concentration
dy_dt(2) = cell_pars.allocation.fE * total_synthesis - alpha * cell_state.e;

% r concentration
dy_dt(3) = cell_pars.allocation.fR * total_synthesis - alpha * cell_state.r;

% q concentration
dy_dt(4) = cell_pars.allocation.fQ * total_synthesis - alpha * cell_state.q;

% u concentration
dy_dt(5) = cell_pars.allocation.fU * total_synthesis - alpha * cell_state.u;


end

