
%% load data
traj = readtable('../results-data/res7_stoch-model-basics/trajectory.csv');

%% output folder
output_folder = '../figure-assembly/components/';
if ~exist(output_folder, 'dir')
    mkdir(output_folder);
end

%% styling parameters
lw = 1.5;
ax_font_size = 12;
leg_font_size = 12;
leg_lw = 1.5;
ax_lw = 1.5;
fig_size = [0 0 600 300];


%%
figure(1);
plot(traj.t, traj.size,'k','LineWidth', 2);
ylabel('Cell volume or mass');
figure(2);
plot(traj.t, traj.e,'g','LineWidth', lw); hold on;
plot(traj.t, traj.r,'b','LineWidth', lw); hold on;
plot(traj.t, traj.q, 'Color', [0.6 0 0],'LineWidth', lw); hold on;
plot(traj.t, traj.x, 'r','LineWidth', lw); hold on;
plot(traj.t, traj.a,'m','LineWidth', lw); hold on;
ylabel('Concentration or mass fraction');
legend({'e','r','q','x','a'}, 'FontSize', leg_font_size, 'LineWidth', leg_lw);
for i=[1,2]
    figure(i);
    xlabel('Time (hrs)');
    set(gca,'FontSize',ax_font_size,'LineWidth',ax_lw);
    xlim([0 10]);
end

%%
figure(1);
set(gcf,'Position',fig_size,'Color','w');
saveas(gcf,[output_folder 'res7_stoch_traj_panel_size.pdf']);

figure(2);
set(gcf,'Position',fig_size,'Color','w');
saveas(gcf,[output_folder 'res7_stoch_traj_panel_conc.pdf']);

close all;



