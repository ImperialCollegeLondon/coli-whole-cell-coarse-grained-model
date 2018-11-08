
%% load result of sobol explo scott R frac data fit
data_1 = readtable('../results-data/res1_scott-2010-fit/sobol-explo-1-R-scott-data-fit.csv');
data_2 = readtable('../results-data/res1_scott-2010-fit/sobol-explo-2-R-scott-data-fit.csv');
data = data_1;

%% show cost vs each parameter
% subplot(1,3,1); 
% plot(data_1.sigma,data_1.log_goodness_fit,'o','Color',[1 1 1].*0.5,'MarkerFaceColor','None'); hold on; 
% plot(data_2.sigma,data_2.log_goodness_fit,'o','Color',[1 0.5 1].*0.5,'MarkerFaceColor','None');
% subplot(1,3,2); 
% plot(data_1.a_sat,data_1.log_goodness_fit,'o','Color',[1 1 1].*0.5,'MarkerFaceColor','None'); hold on;
% plot(data_2.a_sat,data_2.log_goodness_fit,'o','Color',[1 0.5 1].*0.5,'MarkerFaceColor','None');
% subplot(1,3,3); 
% plot(data_1.q,data_1.log_goodness_fit,'o','Color',[1 1 1].*0.5,'MarkerFaceColor','None'); hold on;
% plot(data_2.q,data_2.log_goodness_fit,'o','Color',[1 0.5 1].*0.5,'MarkerFaceColor','None'); hold on;
% 







%%
subplot(1,2,1); scatter(data.sigma.*data.a_sat,data.a_sat,[],data.log_goodness_fit,'LineWidth',2); xlabel('\sigma'); ylabel('a_{sat}');
subplot(1,2,2); scatter(data.sigma.*data.a_sat,data.q,[],data.log_goodness_fit,'LineWidth',2); xlabel('\sigma'); ylabel('q');


%%
data_good = data(data.log_goodness_fit < -6.65, :);
subplot(3,2,5);
scatter(data_good.sigma,data_good.a_sat,[],data_good.log_goodness_fit,'LineWidth',2); xlabel('\sigma'); ylabel('a_{sat}');

%%
subplot(2,2,6);
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

