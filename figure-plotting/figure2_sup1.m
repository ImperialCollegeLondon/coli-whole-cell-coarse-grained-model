
%% load data
traj_0_2 = readtable('../results-data/mod1_1sup1_effect-of-delta/trajectory_delta-0.2.csv');
traj_2 = readtable('../results-data/mod1_1sup1_effect-of-delta/trajectory_delta-2.csv');
traj_20 = readtable('../results-data/mod1_1sup1_effect-of-delta/trajectory_delta-20.csv');
traj_200 = readtable('../results-data/mod1_1sup1_effect-of-delta/trajectory_delta-200.csv');

%
env_pars.k = 3.53;
growth_rates = env_pars.k .* [traj_2.e(end), traj_20.e(end), traj_200.e(end)];

close all;

%
%figure(1);
%bar(growth_rates);

%
figure(2);
subplot(2,2,1);
plot(traj_20.t, traj_20.e, 'g'); hold on;
plot(traj_2.t, traj_2.e, '--g'); hold on;
plot(traj_200.t, traj_200.e, 'g+'); hold on;
plot(traj_0_2.t, traj_0_2.e, 'gx'); hold on;

subplot(2,2,2);
plot(traj_20.t, traj_20.r, 'b'); hold on;
plot(traj_2.t, traj_2.r, '--b'); hold on;
plot(traj_200.t, traj_200.r, 'b+'); hold on;
subplot(2,2,3);
plot(traj_20.t, traj_20.a, 'm'); hold on;
plot(traj_2.t, traj_2.a, '--m'); hold on;
plot(traj_200.t, traj_200.a, 'm+'); hold on;
subplot(2,2,4);
plot(traj_20.t, traj_20.R ./ traj_20.total_prot ./ traj_20.a, 'k'); hold on;
plot(traj_2.t, traj_2.R ./ traj_2.total_prot ./ traj_2.a, '--k'); hold on;
plot(traj_200.t, traj_200.R ./ traj_200.total_prot ./ traj_200.a, 'k+'); hold on;

ylim([0,250]);
