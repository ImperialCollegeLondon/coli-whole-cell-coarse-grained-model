

addpath('../model-code');
addpath('../model-code/steady-state');

%% vector of a_sat and q to explore
a_sat_vec = linspace(0,10,100);
q_vec = linspace(0,1,100);


%% get grid data on theoric and numerical max growth rate
alpha_max_theory_mat = zeros(100,100);
alpha_max_numerical_mat = zeros(100,100);
a_sat_mat = zeros(100,100);
q_mat = zeros(100,100);
cell_pars.biophysical.sigma = 1;
cell_pars.allocation.fU = 0;
env_pars.k = 10^10; % numerical way of limit to infinity...
env_pars.ri = 0;
for i_a=1:length(a_sat_vec)
    for i_q=1:length(q_vec)
        cell_pars.biophysical.a_sat = a_sat_vec(i_a);
        cell_pars.constraint.q = q_vec(i_q);
        a_sat_mat(i_a, i_q) = a_sat_vec(i_a);
        q_mat(i_a, i_q) = q_vec(i_q);
        alpha_max_theory_mat(i_a, i_q) = give_alpha_max(cell_pars);
        ss = give_optimal_steady_state_from_Q_constraint(cell_pars, env_pars);
        alpha_max_numerical_mat(i_a, i_q) = ss.alpha;
    end
end


%% output the data as csv
q = q_mat(:);
a_sat = a_sat_mat(:);
sigma = ones(size(q));
alpha_max_analytical = alpha_max_theory_mat(:);
alpha_max_numerical = alpha_max_numerical_mat(:);
output_data = table(sigma, q, a_sat, alpha_max_analytical, alpha_max_numerical);
mkdir('../results-data/resXX_-study-max-growth-rate/');
writetable(output_data, '../results-data/resXX_-study-max-growth-rate/alpha_max_analytical_vs_numerical.csv');







