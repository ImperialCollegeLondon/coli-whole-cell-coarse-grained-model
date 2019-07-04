
%%%
% model_pars should have fields sigma, a_sat, q, a_fR_ratio == delta
%
% modulation_data should be a table with different growth rates for
% different modulation
%
% type of modulation indicated by nutrient_type (different number for each growth media), cm_type (0 or 1),
% useless_type (0 or 1)
%
%%%


function composition_data = compute_cell_composition_from_growth_modulation_coreg(model_pars, modulation_data)

addpath('../model-code/steady-state_coreg');

cell_pars.biophysical.sigma = model_pars.sigma;
cell_pars.constraint.q = model_pars.q;
cell_pars.constraint.delta = model_pars.delta;

% prepare table columns
model_k = []; model_ri = []; model_fU = [];
model_fE = []; model_fR = []; model_fQ = [];
model_a = []; model_e = []; model_r = []; model_ra = []; model_q = []; model_u = [];
model_ra_over_r = [];
model_growth_rate = [];

% iterate on modulations (rows of table)
for i_cond=1:size(modulation_data)
    this_cond = modulation_data(i_cond,:);   
    % to compute k, we need growth rate in that media without cm or useless
    % perturbation
    media_only_cond = modulation_data(modulation_data.cm_type == 0 & ...
                                        modulation_data.useless_type == 0 & ...
                                        modulation_data.nutrient_type == this_cond.nutrient_type, :);
    env_pars.ri = 0; cell_pars.allocation.fU = 0;
    env_pars.k = fit_k_from_alpha_coreg(cell_pars, env_pars, media_only_cond.growth_rate_per_hr);
    if isempty(env_pars.k)
        disp('could not fit k ?');
        disp(cell_pars.biophysical);
        disp(cell_pars.allocation);
        disp(cell_pars.constraint);
        disp(media_only_cond.growth_rate_per_hr);
        error('r');
    end
    % if also cm but not useless, compute the ri
    if (this_cond.cm_type > 0 && this_cond.useless_type == 0)
        env_pars.ri = fit_ri_from_alpha_coreg(cell_pars, env_pars, this_cond.growth_rate_per_hr);
    end
    % if also useless but not cm, compute the fU
    if (this_cond.cm_type == 0 && this_cond.useless_type > 0)
        cell_pars.allocation.fU = fit_fU_from_alpha_coreg(cell_pars, env_pars, this_cond.growth_rate_per_hr);
        % if empty value, means incompatibility of growth rate (faster with
        % fU that without)
        % in that case, we say that it is zero
        if isempty(cell_pars.allocation.fU)
            warning('inconsistency useless modulation, setting fU to zero');
            cell_pars.allocation.fU = 0;
        end
    end
    % compute the steady-state (optimality assumption)
    ss = give_steady_state_coreg(cell_pars, env_pars);
    % form the table
    model_k(end+1,:) = env_pars.k;
    model_ri(end+1,:) = env_pars.ri;
    model_fU(end+1,:) = cell_pars.allocation.fU;
    model_fE(end+1,:) = ss.fE;
    model_fR(end+1,:) = ss.fR;
    model_fQ(end+1,:) = ss.fQ;
    model_a(end+1,:) = ss.a;
    model_e(end+1,:) = ss.e;
    model_r(end+1,:) = ss.r;
    model_ra(end+1,:) = ss.ra;
    model_q(end+1,:) = ss.q;
    model_u(end+1,:) = ss.u;
    model_ra_over_r(end+1,:) = ss.ra / ss.r;
    model_growth_rate(end+1,:) = ss.alpha;
end

% make the table
composition_data = table(model_k, model_ri, model_fU, model_fE, model_fR, model_fQ, model_a, model_e, model_r, model_ra, model_q, model_u, model_ra_over_r, model_growth_rate);
composition_data = [modulation_data, composition_data];

end
