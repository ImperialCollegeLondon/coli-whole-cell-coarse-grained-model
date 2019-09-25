function dy_dt = derivs_amount( ~ , cell_state_vec , cell_pars , env_pars )

EPS = 1e-5;

% to store derivatives
dy_dt = zeros(7,1);

% vector to names
cell_state.A = cell_state_vec(1);
cell_state.E = cell_state_vec(2);
cell_state.RA = cell_state_vec(3);
cell_state.RI = cell_state_vec(4);
cell_state.Q = cell_state_vec(5);
cell_state.U = cell_state_vec(6);
cell_state.X = cell_state_vec(7);

% cell volume, total protein amount
cell_vol_mass = sum(cell_state_vec);

% allocation of fR based on a
a = cell_state.A / cell_vol_mass;
fR = cell_pars.delta * a;
if (fR > 1 - cell_pars.fQ - cell_pars.fU - cell_pars.fX)
    fR = 1 - cell_pars.fQ - cell_pars.fU - cell_pars.fX;
    fE = 0;
else
    % fE is the remainder after Q,U,X
    fE = 1 - fR - cell_pars.fQ - cell_pars.fU - cell_pars.fX;
end

% total synthesis rate
total_synthesis = cell_pars.sigma * cell_state.RA * a / (a + cell_pars.a_sat);

% A
dy_dt(1) = env_pars.k * cell_state.E - total_synthesis;

% E
dy_dt(2) = fE * total_synthesis;

% RA
dy_dt(3) = fR * total_synthesis - env_pars.cm_kon * cell_state.RA + cell_pars.cm_koff * cell_state.RI;

% RI
dy_dt(4) = env_pars.cm_kon * cell_state.RA - cell_pars.cm_koff * cell_state.RI;

% Q
dy_dt(5) = cell_pars.fQ * total_synthesis;

% U
dy_dt(6) = cell_pars.fU * total_synthesis;

% X
dy_dt(7) = cell_pars.fX * total_synthesis;

if abs(sum(dy_dt) - env_pars.k * cell_state.E) > EPS
    sum(dy_dt)
    env_pars.k * cell_state.E
    error('issue mass conservation in derivs');
end

end

