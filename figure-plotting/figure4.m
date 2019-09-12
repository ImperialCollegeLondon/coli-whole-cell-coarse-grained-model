
%% output folder
output_folder = '../figure-assembly/figure-4-components/';
if ~exist(output_folder, 'dir')
    mkdir(output_folder);
end

%% load the simulation data
traj_example = readtable('../results-data/mod1_3_stoch_sim/trajectory.csv');


%% make the trajectory panels
figure(1);
plot(traj_example.t, traj_example.size,'k','LineWidth', 2);
ylabel('Cell volume or mass');
figure(2);
plot(traj_example.t, traj_example.E./traj_example.size,'g','LineWidth', 2); hold on;
plot(traj_example.t, traj_example.RA./traj_example.size,'b','LineWidth', 2); hold on;
plot(traj_example.t, traj_example.Q./traj_example.size, 'Color', [0.6 0 0],'LineWidth', 2); hold on;
plot(traj_example.t, traj_example.X./traj_example.size, 'r','LineWidth', 2); hold on;
plot(traj_example.t, traj_example.A./traj_example.size,'m','LineWidth', 2); hold on;
ylabel('Concentration or mass fraction');
legend({'e','r','q','x','a'}, 'FontSize', 15, 'LineWidth', 1.5);
for i=[1,2]
    figure(i);
    xlabel('Time (hrs)');
    set(gca,'FontSize',20,'LineWidth',2);
end

figure(1);
saveas(gcf,[output_folder 'figure_4_panel_size.pdf']);

figure(2);
saveas(gcf,[output_folder 'figure_4_panel_conc.pdf']);

close all;
