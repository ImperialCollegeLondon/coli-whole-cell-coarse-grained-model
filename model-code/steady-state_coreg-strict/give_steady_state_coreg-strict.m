
function [steady_state,cell_pars] = give_steady_state_from_Q_constraint_and_fR_a_ratio(cell_pars, env_pars)

% find the maximum a allowing constraints to be respected
a_max = 1 - (cell_pars.constraint.q + env_pars.ri) / (1 - cell_pars.allocation.fU);
if a_max < 0
    steady_state.alpha = 0;
    return;
end

% compute the equivalent a_sat
delta_to_asat = 0.0836; % from dai et al. MM elong vs R/P Km and the R/P vs fR ratio from Scott et al.
cell_pars.biophysical.a_sat = cell_pars.constraint.delta * delta_to_asat;

% first, find the minimal a/fR ratio over possible steady-state
a1 = fminbnd(@(a)(cost_a_fR_min(a, cell_pars, env_pars)), 0, a_max);
ss1 = give_steady_state_from_a_and_Q_constraint(a1, cell_pars, env_pars);
a_over_fR_min = ss1.a/ss1.fR;

% same for maximal a/fR ratio
a2 = fminbnd(@(a)(cost_a_fR_max(a, cell_pars, env_pars)), 0, a_max);
ss2 = give_steady_state_from_a_and_Q_constraint(a2, cell_pars, env_pars);
a_over_fR_max = ss2.a/ss2.fR;

% check if compatible with the desired a/fR ratio
if cell_pars.constraint.delta < a_over_fR_min
    disp('miminal a/fR ratio higher than delta...');
    steady_state.alpha = 0;
    return;
end
if cell_pars.constraint.delta > a_over_fR_max
    error('maximal a/fR ratio lower than delta ?');
end

% find the steady-state that respect the ratio
a = fminbnd(@(a)(cost_a_fR_good_ratio(a, cell_pars, env_pars)), 0, a_max);
C = cost_a_fR_good_ratio(a, cell_pars, env_pars);
if C > 1e-6
    error('could not find steady state matching a/fR ratio ?');
end

% return this steady state
[steady_state,cell_pars] = give_steady_state_from_a_and_Q_constraint(a,cell_pars,env_pars);

end


function C = cost_a_fR_min(a, cell_pars, env_pars)
ss = give_steady_state_from_a_and_Q_constraint(a, cell_pars, env_pars);
C = ss.a/ss.fR;
end

function C = cost_a_fR_max(a, cell_pars, env_pars)
ss = give_steady_state_from_a_and_Q_constraint(a, cell_pars, env_pars);
C = -ss.a/ss.fR;
end

function C = cost_a_fR_good_ratio(a, cell_pars, env_pars)
ss = give_steady_state_from_a_and_Q_constraint(a, cell_pars, env_pars);
C = (ss.a/ss.fR - cell_pars.constraint.delta)^2;
end

% C_dai = 0.0836; % such that fR/a = C_dai/a_sat MM dai et al.
% 
% 
% delta = cell_pars.constraint.delta;
% q = cell_pars.constraint.q;
% sigma = cell_pars.biophysical.sigma;
% 
% k = env_pars.k;
% ri = env_pars.ri;
% fU = cell_pars.allocation.fU;
% 
% % fR_vec = linspace(0,1,100000);
% % fE_q = compute_fE_q(fR_vec,q,delta,fU);
% % fE_b = compute_fE_b(fR_vec,sigma,k,ri,delta,C);
% % ccs = bwconncomp(fE_q > 0 & fE_q < 1 & fE_b > 0 & fE_b < 1);
% % if ccs.NumObjects > 1
% %     plot(fR_vec,fE_q,'r'); hold on;
% %     plot(fR_vec,fE_b,'g'); hold on;
% %     plot([0 1],[0 0],'k'); hold on;
% %     plot([0 1],[1 1],'k'); hold on;
% %     ylim([-0.5, 1.5]);
% %     error('More than one segment of fR valid, thought would never happen ?');
% % end
% % fR_min = fR_vec(min(ccs.PixelIdxList{1}));
% % fR_max = fR_vec(max(ccs.PixelIdxList{1}));
% 
% options = optimset('MaxFunEvals',1e4,'TolFun',1e-8,'TolX',1e-8);
% fR = fminbnd(@(fR)(cost_fR_fit(fR,sigma,k,ri,delta,C_dai,q,fU)), 0, 1, options);
% cost_fit = cost_fR_fit(fR,sigma,k,ri,delta,C_dai,q,fU);
% if cost_fit > 1e-4
%     steady_state.alpha = 0;
%     return;
% end
% 
% if fR < 0 || fR > 1
%     error('failed with fR search co-regulation model');
% end
% 
% % fR = fminsearch(@(fR)(cost_fR_fit(fR,sigma,k,ri,delta,C,q,fU)), 0.5);
% % fR_1 = fminsearch(@(fR)(cost_fR_fit(fR,sigma,k,ri,delta,C,q,fU)), fR_min);
% % fR_2 = fminsearch(@(fR)(cost_fR_fit(fR,sigma,k,ri,delta,C,q,fU)), fR_max);
% % C_best_1 = cost_fR_fit(fR_1,sigma,k,ri,delta,C,q,fU);
% % C_best_2 = cost_fR_fit(fR_2,sigma,k,ri,delta,C,q,fU);
% 
% 
% % C_best = cost_fR_fit(fR,sigma,k,ri,delta,C,q,fU);
% % if C_best_1 < C_best_2
% %     if C_best_1 > 1e-5
% %         steady_state.alpha = 0;
% %         return;
% %     else
% %         fR = fR_1;
% %     end
% % else
% %     if C_best_2 > 1e-5
% %         steady_state.alpha = 0;
% %         return;
% %     else
% %         fR = fR_2;
% %     end
% % end
% 
% % compute and shape the whole steady-state for output
% a = delta * fR;
% fQ = q / (1-a);
% fE = 1 - fU - fR - fQ;
% if fE < 0 || fE > 1
%     error('failed with fE co-regulation model');
% end
% %
% steady_state.a = a;
% steady_state.e = fE * (1-a);
% steady_state.r = fR * (1-a);
% steady_state.ra = steady_state.r - env_pars.ri;
% steady_state.q = fQ * (1-a);
% steady_state.u = cell_pars.allocation.fU * (1-a);
% steady_state.alpha = env_pars.k * steady_state.e;
% % for convenience, also put allocations in the steady-state..
% steady_state.fQ = fQ;
% steady_state.fE = fE;
% steady_state.fR = fR;
% steady_state.fRA = fR * steady_state.ra / steady_state.r;
% steady_state.fU = cell_pars.allocation.fU;
% % store allocation results in the returned cell pars as well
% cell_pars.allocation.fQ = fQ;
% cell_pars.allocation.fE = fE;
% cell_pars.allocation.fR = fR;
% cell_pars.allocation.fRA = fR * steady_state.ra / steady_state.r;
% 
% end
% 
% 
% function fE_q = compute_fE_q(fR,q,delta,fU)
% fE_q = 1 - fU - fR - q  ./ (1 - delta .* fR);
% end
% 
% function fE_b = compute_fE_b(fR,sigma,k,ri,delta,C_dai)
% fE_b = sigma ./ k .* (fR - ri ./(1-delta.*fR)) .* fR ./ (fR + C_dai) ./ (1 - delta .* fR);
% end
% 
% function cost_fit = cost_fR_fit(fR,sigma,k,ri,delta,C_dai,q,fU)
% fE_q = compute_fE_q(fR,q,delta,fU);
% fE_b = compute_fE_b(fR,sigma,k,ri,delta,C_dai);
% cost_fit = (fE_q - fE_b)^2 + ((fE_q - fE_b)/fE_q)^2;
% end
% 
% 
% 
% 
