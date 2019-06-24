

%%
cell_pars.biophysical.sigma = 4;
cell_pars.constraint.q = 0.45;
cell_pars.constraint.delta = 0.01;
cell_pars.allocation.fU = 0;

%%
env_pars.k = 12;
env_pars.ri = 0;

ss = give_steady_state_coreg(cell_pars, env_pars)
ss.a / ss.fR

%%
k_vec = logspace(-6,4,100);
alpha_vec = zeros(size(k_vec));
a_fR_ratio_vec = zeros(size(k_vec));
for i=1:length(k_vec)
    env_pars.k = k_vec(i)
    ss = give_steady_state_coreg(cell_pars, env_pars);
    alpha_vec(i) = ss.alpha;
    if isfield(ss,'a')
        a_fR_ratio_vec(i) = ss.a / ss.fR;
    end
end
subplot(1,2,1); 
semilogx(k_vec, alpha_vec, 'g');
subplot(1,2,2);
loglog(k_vec, a_fR_ratio_vec, 'k');
ylim([0,2*max(a_fR_ratio_vec)]);

