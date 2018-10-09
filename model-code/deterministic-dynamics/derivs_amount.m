function dy_dt = derivs_amount( ~ , cell_state_vec , cell_pars , env_pars )

% to store derivatives
dy_dt = zeros(6,1);

% vector to names
cell_state.A = cell_state_vec(1);
cell_state.E = cell_state_vec(2);
cell_state.R = cell_state_vec(3);
cell_state.Q = cell_state_vec(4);
cell_state.U = cell_state_vec(5);
cell_state.X = cell_state_vec(6);

% volume
cell_vol = sum(cell_state_vec);

% inactive ribosome amount
inactive_rib = env_pars.ri * cell_vol;

% total synthesis rate
total_synthesis = cell_pars.biophysical.sigma * (cell_state.R - inactive_rib) * cell_state.A / (cell_state.A + cell_pars.biophysical.a_sat * cell_vol);

% A
dy_dt(1) = env_pars.k * cell_state.E - total_synthesis;

% E
dy_dt(2) = cell_pars.allocation.fE * total_synthesis;

% R
dy_dt(3) = cell_pars.allocation.fR * total_synthesis;

% Q
dy_dt(4) = cell_pars.allocation.fQ * total_synthesis;

% U
dy_dt(5) = cell_pars.allocation.fU * total_synthesis;

% X
dy_dt(6) = cell_pars.allocation.fX * total_synthesis;

end

