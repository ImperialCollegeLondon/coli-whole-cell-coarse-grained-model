
%%
addpath('../model-code');
addpath('../model-code/steady-state');
addpath('../model-code/steady-state_optim');
addpath('../model-code/steady-state_coreg');

%%
sigma = 6.2;
q = 0.43;
a_sat = 0.02;
delta = a_sat / 0.0836 * 1;


%%
cp_coreg.biophysical.sigma = sigma;
cp_coreg.constraint.q = q;
cp_coreg.allocation.fU = 0;

cp_opt = cp_coreg;
cp_opt.biophysical.a_sat = a_sat;

cp_coreg.constraint.delta = delta;


%%
env_pars.ri = 0;
k_vec = logspace(-2,4,100);
alpha_optim_vec = zeros(size(k_vec));
alpha_coreg_vec = zeros(size(k_vec));
ratio_alpha_vec = zeros(size(k_vec));
sss_coreg = cell(size(k_vec));
sss_optim = cell(size(k_vec));

for i_k=1:length(k_vec)
    env_pars.k = k_vec(i_k);
    ss_coreg = give_steady_state_coreg(cp_coreg,env_pars);
    ss_opt = give_optim_steady_state_from_Q_constraint(cp_opt,env_pars);
    ratio_alpha_vec(i_k) = ss_coreg.alpha / ss_opt.alpha;
    sss_coreg{i_k} = ss_coreg;
    sss_optim{i_k} = ss_opt;
    alpha_optim_vec(i_k) = ss_opt.alpha;
    alpha_coreg_vec(i_k) = ss_coreg.alpha;
end

%%
subplot(2,2,1);
plot(cellfun(@(x)(x.alpha),sss_optim),cellfun(@(x)(x.fR),sss_optim),'g'); hold on
plot(cellfun(@(x)(x.alpha),sss_coreg),cellfun(@(x)(x.fR),sss_coreg),'r'); hold on

subplot(2,2,2);
plot(cellfun(@(x)(x.alpha),sss_optim),cellfun(@(x)(x.a),sss_optim),'g'); hold on
plot(cellfun(@(x)(x.alpha),sss_coreg),cellfun(@(x)(x.a),sss_coreg),'r'); hold on

subplot(2,2,3);
plot(cellfun(@(x)(x.alpha),sss_coreg),cellfun(@(x)(x.a),sss_coreg)./(a_sat + cellfun(@(x)(x.a),sss_coreg)),'r'); hold on
plot(cellfun(@(x)(x.alpha),sss_optim),cellfun(@(x)(x.a),sss_optim)./(a_sat + cellfun(@(x)(x.a),sss_optim)),'g'); hold on


