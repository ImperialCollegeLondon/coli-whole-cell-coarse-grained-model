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

% cell volume, total protein amount
cell_vol_mass = sum(cell_state_vec);

% inactive ribosome amount
inactive_rib = env_pars.ri * cell_vol_mass;
active_rib = cell_state.R - inactive_rib;
if (active_rib < 0)
    active_rib = 0;
end

% allocation of fR based on a
a = cell_state.A / cell_vol_mass;
fR = a / cell_pars.delta;
if (fR > 1 - cell_pars.fQ - cell_pars.fU - cell_pars.fX)
    fR = 1 - cell_pars.fQ - cell_pars.fU - cell_pars.fX;
end
% fE is the remainder after Q,U,X
fE = 1 - fR - cell_pars.fQ - cell_pars.fU - cell_pars.fX; 

% total synthesis rate
total_synthesis = cell_pars.sigma * active_rib * a / (a + cell_pars.K * cell_pars.delta);

% A
dy_dt(1) = env_pars.k * cell_state.E - total_synthesis;

% E
dy_dt(2) = fE * total_synthesis;

% R
dy_dt(3) = fR * total_synthesis;

% Q
dy_dt(4) = cell_pars.fQ * total_synthesis;

% U
dy_dt(5) = cell_pars.fU * total_synthesis;

% X
dy_dt(6) = cell_pars.fX * total_synthesis;

end

