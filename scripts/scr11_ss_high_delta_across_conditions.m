
addpath('../model-code/steady-state_coreg-high-delta');

size_exponents = readtable('../results-data/res6_size-predictions-from-comp/fE_and_active_rib_frac_data_fX-false/exponents.csv');
size_scale = readtable('../results-data/res6_size-predictions-from-comp/fE_and_active_rib_frac_data_fX-false/scale_factor.csv');

output_folder = '../results-data/res11_ss-high-delta-model-across-conds/';
if ~exist(output_folder, 'dir')
    mkdir(output_folder);
end
constants = give_constants();
cell_pars.K = constants.K;
cell_pars.sigma = constants.sigma;
cell_pars.cm_koff = constants.cm_koff;
cell_pars.fQ = constants.reference_fQ;
k_ref = constants.reference_k;

% nutrient modulation
nut_alpha_vec = linspace(0.3,2.5,50);
env_pars.cm_kon = 0;
cell_pars.fU = 0;
nut_size_vec = zeros(size(nut_alpha_vec));
for i_nut=1:length(nut_alpha_vec)
    % optimal parameterization for this nutrient growth rate
    env_pars.k = fit_k_from_alpha_coreg_high_delta(cell_pars,env_pars,nut_alpha_vec(i_nut));
    [ss,cell_pars] = give_steady_state_coreg_high_delta(cell_pars,env_pars);
    nut_size_vec(i_nut) = size_scale.scale_factor * ss.fE^(size_exponents.exponents(1)) * (ss.active_rib_frac)^(size_exponents.exponents(2));
end
growth_rate_per_hr = nut_alpha_vec';
cell_size = nut_size_vec';
writetable( table(growth_rate_per_hr, cell_size), [output_folder,  'nutrient.csv']);

% cm modulations
alpha_cm_refs = [0.36, 0.65, 0.98, 1.03, 1.51, 1.71];
for i_alpha_ref=1:length(alpha_cm_refs)
    env_pars.k = fit_k_from_alpha_coreg_high_delta(cell_pars,env_pars,alpha_cm_refs(i_alpha_ref));
    [~,cell_pars] = give_steady_state_coreg_high_delta(cell_pars,env_pars);
    cm_alpha_vec = linspace(0.2,alpha_cm_refs(i_alpha_ref),50);
    cm_size_vec = zeros(size(cm_alpha_vec));
    for i_cm=1:length(cm_alpha_vec)
        env_pars.cm_kon = fit_cm_kon_from_alpha_coreg_high_delta(cell_pars,env_pars,cm_alpha_vec(i_cm));
        [ss,cell_pars] = give_steady_state_coreg_high_delta(cell_pars,env_pars);
        cm_size_vec(i_cm) = size_scale.scale_factor * ss.fE^(size_exponents.exponents(1)) * (ss.active_rib_frac)^(size_exponents.exponents(2));
    end
    growth_rate_per_hr = cm_alpha_vec';
    cell_size = cm_size_vec';
    writetable( table(growth_rate_per_hr, cell_size), [output_folder 'cm_' num2str(i_alpha_ref) '.csv']);
end

% useless
env_pars.cm_kon = 0;
alpha_useless_refs = [0.98, 1.29];
for i_alpha_ref=1:length(alpha_useless_refs)
    env_pars.k = fit_k_from_alpha_coreg_high_delta(cell_pars,env_pars,alpha_useless_refs(i_alpha_ref));
    [~,cell_pars] = give_steady_state_coreg_high_delta(cell_pars,env_pars);
    useless_alpha_vec = linspace(0.3,alpha_useless_refs(i_alpha_ref),50);
    useless_size_vec = zeros(size(useless_alpha_vec));
    for i_useless=1:length(useless_alpha_vec)
        cell_pars.fU = fit_fU_from_alpha_coreg_high_delta(cell_pars,env_pars,useless_alpha_vec(i_useless));
        [ss,cell_pars] = give_steady_state_coreg_high_delta(cell_pars,env_pars);
        useless_size_vec(i_useless) = size_scale.scale_factor * ss.fE^(size_exponents.exponents(1)) * (ss.active_rib_frac)^(size_exponents.exponents(2));
    end
    growth_rate_per_hr = useless_alpha_vec';
    cell_size = useless_size_vec';
    writetable( table(growth_rate_per_hr, cell_size), [output_folder 'useless_' num2str(i_alpha_ref) '.csv']);
end
