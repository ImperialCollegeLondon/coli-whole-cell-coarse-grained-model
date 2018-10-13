
%% load data
traj = readtable('../results-data/dynamic-det-model/trajectory.csv');

%% figure layout
ax_size = subplot(2,2,1);
ax_X = subplot(2,2,2);
ax_conc = subplot(2,2,3);
f = gcf;

%% plot the size
subplot(2,2,1);
plot(traj.t, traj.M_or_V, 'k', 'LineWidth', 2);

%% plot X
subplot(2,2,2);
plot(traj.t, traj.X, 'r', 'LineWidth', 2);

%% plot concentrations
subplot(2,2,3);
plot( traj.t , traj.a , 'm', 'LineWidth', 2); hold on;
plot( traj.t , traj.e , 'g', 'LineWidth', 2); hold on;
plot( traj.t , traj.r , 'b', 'LineWidth', 2); hold on;
plot( traj.t , traj.q , 'Color', [0.6 0 0], 'LineWidth', 2); hold on;
plot( traj.t , traj.x , 'r', 'LineWidth', 2); hold on;
legend({'a','e','r','q','x'});

%% common fig styling
f.Position = [0 0 1200 800];

%% common ax styling
for i=[1, 2, 3]
    subplot(2,2,i);
    set(gca,'FontSize',20,'LineWidth',2);
    grid();
end