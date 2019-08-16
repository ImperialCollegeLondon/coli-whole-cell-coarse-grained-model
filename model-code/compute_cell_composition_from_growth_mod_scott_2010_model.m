
%%%
% model_pars should have fields sigma, a_sat, q
%
% modulation_data should be a table with different growth rates for
% different modulation
%
% type of modulation indicated by nutrient_type (different number for each growth media), cm_type (0 or 1),
% useless_type (0 or 1)
%
%%%


function composition_data = compute_cell_composition_from_growth_mod_scott_2010_model(modulation_data)

addpath('../model-code/other-models/scott-2010-model');

cell_pars.rho = 0.76;
r0 = 0.087;
cell_pars.fR_0 = r0 * cell_pars.rho;
cell_pars.fR_max = 0.55;
cell_pars.fU = 0;
cell_pars.kt_max = 4.5;

% prepare table columns
model_kn = []; model_kt = []; model_fU = [];
model_fE = []; model_fR = []; model_active_R_frac = [];
model_growth_rate = [];

% iterate on modulations (rows of table)
for i_cond=1:size(modulation_data)
    this_cond = modulation_data(i_cond,:);   
    % to compute kn, we need growth rate in that media without cm or useless
    % perturbation
    media_only_cond = modulation_data(modulation_data.cm_type == 0 & ...
                                        modulation_data.useless_type == 0 & ...
                                        modulation_data.nutrient_type == this_cond.nutrient_type, :);
    env_pars.kt = cell_pars.kt_max; cell_pars.fU = 0;
    env_pars.kn = fit_kn_from_alpha_scott_2010_model(cell_pars, env_pars, media_only_cond.growth_rate_per_hr);
    if isempty(env_pars.kn)
        disp('could not fit kn ?');
        error('r');
    end
    % if also cm but not useless, compute the ri
    if (this_cond.cm_type > 0 && this_cond.useless_type == 0)
        env_pars.kt = fit_kt_from_alpha_scott_2010_model(cell_pars, env_pars, this_cond.growth_rate_per_hr);
    end
    % if also useless but not cm, compute the fU
    if (this_cond.cm_type == 0 && this_cond.useless_type > 0)
        cell_pars.fU = fit_fU_from_alpha_scott_2010_model(cell_pars, env_pars, this_cond.growth_rate_per_hr);
        % if empty value, means incompatibility of growth rate (faster with
        % fU that without)
        % in that case, we say that it is zero
        if isempty(cell_pars.fU)
            warning('inconsistency useless modulation, setting fU to zero');
            cell_pars.fU = 0;
        end
    end
    % compute the steady-state (optimality assumption)
    ss = give_steady_state_scott_2010_model(cell_pars, env_pars);
    % form the table
    model_kn(end+1,:) = env_pars.kn;
    model_kt(end+1,:) = env_pars.kt;
    model_fU(end+1,:) = cell_pars.fU;
    model_fE(end+1,:) = ss.fE;
    model_fR(end+1,:) = ss.fR;
    model_active_R_frac(end+1,:) = ss.active_R_frac;
    model_growth_rate(end+1,:) = ss.alpha;
end

% make the table
composition_data = table(model_kn, model_kt, model_fU, model_fE, model_fR, model_active_R_frac, model_growth_rate);
composition_data = [modulation_data, composition_data];

end
