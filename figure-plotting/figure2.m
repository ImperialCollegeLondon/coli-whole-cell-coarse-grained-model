
%% load data
traj = readtable('../results-data/mod1_1_det-dynamics/trajectory.csv');

%% output folder
output_folder = '../figure-assembly/figure-2-components/';
if ~exist(output_folder, 'dir')
    mkdir(output_folder);
end

%% styling parameters
lw = 1.5;
ax_font_size = 12;
leg_font_size = 10;
ax_lw = 1.5;
fig_size = [0 0 650 500];


%% plot the size
subplot(3,1,1);
plot(traj.t, traj.M_or_V, 'k', 'LineWidth', lw);
ylabel('Total cell size');
ylim([0 1000]);

%% plot X
subplot(3,1,2);
plot(traj.t, traj.X, 'r', 'LineWidth', lw);
ylabel('X amount');
ylim([0 130]);

%% plot concentrations
subplot(3,1,3);

plot( traj.t , traj.e , 'g', 'LineWidth', lw); hold on;
plot( traj.t , traj.r , 'b', 'LineWidth', lw); hold on;
plot( traj.t , traj.q , 'Color', [0.6 0 0], 'LineWidth', lw); hold on;
plot( traj.t , traj.x , 'r', 'LineWidth', lw); hold on;
plot( traj.t , traj.a , 'm', 'LineWidth', lw); hold on;
legend({'e','r','q','x','a'},'FontSize',leg_font_size);
ylabel('Concentration');
xlabel('Time (hrs)');
ylim([0 0.6]);

%% styling
for i=[1,2,3]
    subplot(3,1,i);
    set(gca,'FontSize',ax_font_size,'LineWidth',ax_lw);
    xlim([0 10]);
end
set(gcf,'Position',fig_size,'Color','w');


%% save figures
saveas(gcf,[output_folder 'figure_2_panel_size_X_conc.pdf']);
close;