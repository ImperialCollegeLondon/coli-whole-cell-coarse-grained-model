
addpath('../model-code/steady-state_coreg-high-delta');

output_folder = '../results-data/res10_det-model-size-across-conds/';
if ~exist(output_folder, 'dir')
    mkdir(output_folder);
end

constants = give_constants();
cell_pars.sigma = constants.sigma;
cell_pars.fQ = constants.reference_fQ;
cell_pars.K = constants.K;
cell_pars.cm_koff = constants.cm_koff;

k_ref = 3.58;

k_vec = linspace(0.5,20,100);
nut_size_vec = zeros(size(k_vec));
nut_growth_rate_vec = zeros(size(k_vec));
env_pars.cm_kon = 0;
cell_pars.fU = 0;
for i_nut=1:length(k_vec)
    env_pars.k = k_vec(i_nut);
    ss = give_steady_state_coreg_high_delta(cell_pars, env_pars);
    fX = constants.reference_fX_scale * ss.fE^(constants.reference_fX_e_exponent) * ss.active_rib_frac^(constants.reference_fX_active_rib_frac_exponent);
    nut_size_vec(i_nut) = constants.reference_Xdiv / fX / 2;
    nut_growth_rate_vec(i_nut) = ss.alpha;
end
growth_rate = nut_growth_rate_vec';
birth_size = nut_size_vec';
writetable(table(growth_rate, birth_size), [output_folder 'nut_mod.csv']);

cm_kon_vec = linspace(0,4,100);
cm_size_vec = zeros(size(cm_kon_vec));
cm_growth_rate_vec = zeros(size(cm_kon_vec));
env_pars.k = k_ref;
cell_pars.fU = 0;
for i_cm=1:length(cm_kon_vec)
    env_pars.cm_kon = cm_kon_vec(i_cm);
    ss = give_steady_state_coreg_high_delta(cell_pars, env_pars);
    fX = constants.reference_fX_scale * ss.fE^(constants.reference_fX_e_exponent) * ss.active_rib_frac^(constants.reference_fX_active_rib_frac_exponent);
    cm_size_vec(i_cm) = constants.reference_Xdiv / fX / 2;
    cm_growth_rate_vec(i_cm) = ss.alpha;
end
growth_rate = cm_growth_rate_vec';
birth_size = cm_size_vec';
writetable(table(growth_rate, birth_size), [output_folder 'cm_mod.csv']);


fU_vec = linspace(0,0.25,100);
fU_size_vec = zeros(size(fU_vec));
fU_growth_rate_vec = zeros(size(fU_vec));
env_pars.k = k_ref;
env_pars.cm_kon = 0;
for i_useless=1:length(cm_kon_vec)
    cell_pars.fU = fU_vec(i_useless);
    ss = give_steady_state_coreg_high_delta(cell_pars, env_pars);
    fX = constants.reference_fX_scale * ss.fE^(constants.reference_fX_e_exponent) * ss.active_rib_frac^(constants.reference_fX_active_rib_frac_exponent);
    fU_size_vec(i_useless) = constants.reference_Xdiv / fX / 2;
    fU_growth_rate_vec(i_useless) = ss.alpha;
end
growth_rate = fU_growth_rate_vec';
birth_size = fU_size_vec';
writetable(table(growth_rate, birth_size), [output_folder 'useless_mod.csv']);


% plot(nut_growth_rate_vec, nut_size_vec, 'g'); hold on;
% plot(cm_growth_rate_vec, cm_size_vec, 'b'); hold on;
% plot(fU_growth_rate_vec, fU_size_vec, 'r'); hold on;