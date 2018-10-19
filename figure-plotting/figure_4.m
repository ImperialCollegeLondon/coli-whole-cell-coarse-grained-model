
%%
addpath('../utils-code/export_fig');


%% load the simulation data
traj_example = readtable('../results-data/dynamic-stoch-model/trajectory.csv');
delta_size_data = readtable('../results-data/dynamic-stoch-model/adder-sizer/delta_size_vs_birth_size.csv');
degrad_X_delta_size_data = readtable('../results-data/dynamic-stoch-model/adder-sizer/degrad_X_delta_size_vs_birth_size.csv');
nutrient_mod = cell(5,1);
cm_mod = cell(2,1);
useless_mod = cell(3,1);
for i=1:5
    nutrient_mod{i} = readtable(['../results-data/dynamic-stoch-model/individuality/nutrients-' num2str(i) '.csv']);
end
for i=1:2
    cm_mod{i} = readtable(['../results-data/dynamic-stoch-model/individuality/cm-' num2str(i) '.csv']);
end
for i=1:3
    useless_mod{i} = readtable(['../results-data/dynamic-stoch-model/individuality/useless-' num2str(i) '.csv']);
end
det_nutrient_mod = readtable('../results-data/steady-state-det-model/nutrient.csv');
det_cm_mod = readtable('../results-data/steady-state-det-model/cm.csv');
det_useless_mod = readtable('../results-data/steady-state-det-model/useless.csv');


%% make the trajectory panels
subplot(2,2,1);
plot(traj_example.t, traj_example.size,'k','LineWidth', 2);
ylabel('Cell volume or mass');
subplot(2,2,3);
plot(traj_example.t, traj_example.E./traj_example.size,'g','LineWidth', 2); hold on;
plot(traj_example.t, traj_example.RA./traj_example.size,'b','LineWidth', 2); hold on;
plot(traj_example.t, traj_example.Q./traj_example.size, 'Color', [0.6 0 0],'LineWidth', 2); hold on;
plot(traj_example.t, traj_example.X./traj_example.size, 'r','LineWidth', 2); hold on;
plot(traj_example.t, traj_example.A./traj_example.size,'m','LineWidth', 2); hold on;
ylabel('Concentration or mass fraction');
legend({'e','r','q','x','a'}, 'FontSize', 15, 'LineWidth', 1.5);
for i=[1,3]
    subplot(2,2,i);
    xlabel('Time (hrs)');
    set(gca,'FontSize',20,'LineWidth',2);
end

%% make the adder panel
subplot(2,2,2);
mk_size = 8; lw = 1.5; 
h2 = plot([0 2], [1 1], 'k', 'LineWidth', lw); hold on;
h3 = plot([2 0], [0 2], '--k', 'LineWidth', lw); hold on;
plot(delta_size_data.birth_size_bin_avg, delta_size_data.delta_size_bin_avg, '-o', 'MarkerFaceColor', 'r', 'Color', 'r', 'MarkerSize', mk_size, 'LineWidth', lw); hold on;
plot(degrad_X_delta_size_data.birth_size_bin_avg, degrad_X_delta_size_data.delta_size_bin_avg, '-s', 'MarkerFaceColor', 'w', 'Color', 'r', 'MarkerSize', mk_size, 'LineWidth', lw); hold on;
legend([h2 h3], {'adder', 'sizer'}, 'FontSize', 15, 'LineWidth', 1.5);
ylim([0.6 1.4]); xlim([0.7 1.3]); ylabel('Scaled added size'); xlabel('Scaled birth size');
set(gca, 'LineWidth', 2, 'FontSize', 20);


%% make the individuality panel
subplot(2,2,4);
% the deterministic curves
h1 = plot(det_nutrient_mod.growth_rate_per_hr,det_nutrient_mod.birth_size,'g','LineWidth',1.5); hold on;
h2 = plot(det_cm_mod.growth_rate_per_hr,det_cm_mod.birth_size,'b','LineWidth',1.5); hold on;
h3 = plot(det_useless_mod.growth_rate_per_hr,det_useless_mod.birth_size,'r','LineWidth',1.5); hold on;
% the stochastic data 
mk_size = 8; lw = 1.5;
for i_nut=1:length(nutrient_mod)
    plot(nutrient_mod{i_nut}.growth_rate_bin_avg  , ...
        nutrient_mod{i_nut}.birth_size_bin_avg, ...
        'o', 'MarkerFaceColor', 'None', 'Color', 'g', ...
        'MarkerSize', mk_size, 'LineWidth', lw); hold on;
%     plot(nutrient_mod{i_nut}.growth_rate_avg, nutrient_mod{i_nut}.birth_size_avg, 'go', 'MarkerFaceColor', 'w', 'MarkerSize', mk_size*1.5); hold on;
end
% cm
for i_cm=1:length(cm_mod)
    plot(cm_mod{i_cm}.growth_rate_bin_avg, ...
        cm_mod{i_cm}.birth_size_bin_avg, ...
        'o', 'MarkerFaceColor', 'None', 'Color', 'b', ...
        'MarkerSize', mk_size, 'LineWidth', lw); hold on;
%     plot(cm_mod{i_cm}.growth_rate_avg, cm_mod{i_cm}.birth_size_avg, 'bo', 'MarkerFaceColor', 'w', 'MarkerSize', mk_size*1.5); hold on;
end
% useless
for i_useless=1:length(useless_mod)
    plot(useless_mod{i_useless}.growth_rate_bin_avg, ...
        useless_mod{i_useless}.birth_size_bin_avg, ...
        'o', 'MarkerFaceColor', 'None', 'Color', 'r', ...
        'MarkerSize', mk_size, 'LineWidth', lw); hold on;
%     plot(useless_mod{i_useless}.growth_rate_avg, useless_mod{i_useless}.birth_size_avg, 'ro', 'MarkerFaceColor', 'w', 'MarkerSize', mk_size*1.5); hold on;
end
% styling
xlabel('growth rate (hr^{-1})');
ylabel('birth size');
legend([h1, h2, h3], {'nutrient modulation', 'chloramphenicol modulation', 'useless expression modulation'}, 'FontSize', 15, 'LineWidth', 1.5);
set(gca,'FontSize',20,'LineWidth',2);




%%
set(gcf,'Color','w','Position',[0 0 1450 860]);
export_fig(gcf,'../figure-assembly/figure-4-components/figure_4_all.pdf');
close;

