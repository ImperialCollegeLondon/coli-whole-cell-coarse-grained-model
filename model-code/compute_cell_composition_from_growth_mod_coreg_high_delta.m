



function composition_data = compute_cell_composition_from_growth_mod_coreg_high_delta(modulation_data, constants)

addpath('../model-code/steady-state_coreg-high-delta');

cell_pars.sigma = constants.sigma;
cell_pars.fQ = constants.reference_fQ;
cell_pars.K = constants.K;
cell_pars.cm_koff = constants.cm_koff;

% prepare table columns
model_k = []; model_cm_kon = []; model_fU = [];
model_fE = []; model_fR = []; model_fQ = [];
model_active_rib_frac = [];
model_growth_rate = [];

% iterate on modulations (rows of table)
for i_cond=1:size(modulation_data)
    this_cond = modulation_data(i_cond,:);   
    % to compute k, we need growth rate in that media without cm or useless
    % perturbation
    media_only_cond = modulation_data(modulation_data.cm_type == 0 & ...
                                        modulation_data.useless_type == 0 & ...
                                        modulation_data.nutrient_type == this_cond.nutrient_type, :);
    env_pars.cm_kon = 0; cell_pars.fU = 0;
    env_pars.k = fit_k_from_alpha_coreg_high_delta(cell_pars, env_pars, media_only_cond.growth_rate_per_hr);
    if isempty(env_pars.k)
        disp('could not fit k ?');
        composition_data = [];
        return;
        %error('r');
    end
    % if also cm but not useless, compute the ri
    if (this_cond.cm_type > 0 && this_cond.useless_type == 0)
        env_pars.cm_kon = fit_cm_kon_from_alpha_coreg_high_delta(cell_pars, env_pars, this_cond.growth_rate_per_hr);
    end
    % if also useless but not cm, compute the fU
    if (this_cond.cm_type == 0 && this_cond.useless_type > 0)
        cell_pars.fU = fit_fU_from_alpha_coreg_high_delta(cell_pars, env_pars, this_cond.growth_rate_per_hr);
        % if empty value, means incompatibility of growth rate (faster with
        % fU that without)
        % in that case, we say that it is zero
        if isempty(cell_pars.fU)
            warning('inconsistency useless modulation, setting fU to zero');
            cell_pars.fU = 0;
        end
    end
    % compute the steady-state
    ss = give_steady_state_coreg_high_delta(cell_pars, env_pars);
    % form the table
    model_k(end+1,:) = env_pars.k;
    model_cm_kon(end+1,:) = env_pars.cm_kon;
    model_fU(end+1,:) = cell_pars.fU;
    model_fE(end+1,:) = ss.fE;
    model_fR(end+1,:) = ss.fR;
    model_fQ(end+1,:) = cell_pars.fQ;
    model_active_rib_frac(end+1,:) = ss.active_rib_frac;
    model_growth_rate(end+1,:) = ss.alpha;
end

% make the table
composition_data = table(model_k, model_cm_kon, model_fU, model_fE, model_fR, model_fQ, model_active_rib_frac, model_growth_rate);
composition_data = [modulation_data, composition_data];

end
