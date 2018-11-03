
%% load result of sobol explo scott R frac data fit
data = readtable('../results-data/res1_scott-2010-fit/sobol-explo-R-scott-data-fit.csv');


%%
subplot(2,2,1); scatter(data.sigma,data.a_sat,[],data.log_goodness_fit,'LineWidth',2); xlabel('\sigma'); ylabel('a_{sat}');
subplot(2,2,2); scatter(data.sigma,data.q,[],data.log_goodness_fit,'LineWidth',2); xlabel('\sigma'); ylabel('q');


%%
data_good = data(data.log_goodness_fit < -6.65, :);
subplot(2,2,3);
scatter(data_good.sigma,data_good.a_sat,[],data_good.log_goodness_fit,'LineWidth',2); xlabel('\sigma'); ylabel('a_{sat}');

%%
subplot(2,2,4);
plot(data_good.sigma, data_good.a_max, 'ro'); hold on;
xlabel('\sigma'); ylabel('Steady-state a');


%% styling
for i=1:4
    subplot(2,2,i);
    if i<4
        c = colorbar;
        c.Label.String = 'log mean square error';
    end
    set(gca,'FontSize',20,'LineWidth',1.5);
end
set(gcf,'Position',[0 0 1700 1000],'Color','w');

%% save figures
addpath('../utils-code/export_fig');
export_fig(gcf,'../figure-assembly/sup-figure-1-components/sup_figure_1_all.pdf');
close all;

