
%% load data
traj = readtable('../results-data/res6_dynamic-det-model/trajectory.csv');

%% plot the size
subplot(3,1,1);
plot(traj.t, traj.M_or_V, 'k', 'LineWidth', 3);
ylabel('Total cell size');
ylim([0 1000]);

%% plot X
subplot(3,1,2);
plot(traj.t, traj.X, 'r', 'LineWidth', 3);
ylabel('X amount');
ylim([0 130]);

%% plot concentrations
subplot(3,1,3);
plot( traj.t , traj.a , 'm', 'LineWidth', 3); hold on;
plot( traj.t , traj.e , 'g', 'LineWidth', 3); hold on;
plot( traj.t , traj.r , 'b', 'LineWidth', 3); hold on;
plot( traj.t , traj.q , 'Color', [0.6 0 0], 'LineWidth', 3); hold on;
plot( traj.t , traj.x , 'r', 'LineWidth', 3); hold on;
legend({'a','e','r','q','x'},'FontSize',30);
ylabel('Concentration');
xlabel('Time (hrs)');
ylim([0 0.4]);

%% styling
for i=[1,2,3]
    subplot(3,1,i);
    set(gca,'FontSize',35,'LineWidth',3);
    xlim([0 10.5]);
end
set(gcf,'Position',[0 0 1300 1000],'Color','w');


%% save figures
addpath('../utils-code/export_fig');
export_fig(gcf,'../figure-assembly/figure-2-components/figure_2_panel_size_X_conc.pdf');
close all;



