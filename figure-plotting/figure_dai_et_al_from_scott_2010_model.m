

%% scott parameters
kt_no_cm = 4.5;
rho = 0.76;
r0 = 0.087;
phi_0 = r0 * rho;
phi_R_max = 0.55;

%% load the corresponding model data (our model), remove data with useless
model_data = readtable('../results-data/res3_cell-compositions/scott_2010_modulations.csv');
model_data(model_data.useless_type > 0, :) = [];

%% 
nutrients = sort(unique(model_data.nutrient_type));
colors = hsv(length(nutrients)+1);

%% from scott model, kn for each nutrient (see table S4 scott 2010)
kns = [4.44, 3.45, 2.54, 1.86, 1.32, 0.85];


%% compute phi_r for each nut x cm point
scott_model = model_data(:,{'growth_rate_per_hr','nutrient_type','cm_type'});
scott_model.phi_R = zeros(height(scott_model),1);
scott_model.ra_over_r = zeros(height(scott_model),1);
for i=1:height(scott_model)
    model_point = scott_model(i,:);
    i_nut = find(nutrients==model_point.nutrient_type);
    kn = kns(i_nut);
    lambda = model_point.growth_rate_per_hr;
    phi_P = lambda * rho / kn;
    phi_R = phi_R_max - phi_P;
    scott_model.phi_R(i) = phi_R;
    scott_model.ra_over_r(i) = (phi_R-phi_0)/phi_R;
end
%     model_this_nut_zero_cm = model_data(model_data.nutrient_type==nutrients(i_nut) & model_data.useless_type==0 & model_data.cm_type==0, :);
%     disp(model_this_nut_zero_cm.growth_rate_per_hr)
% end




%% style parameters
lw = 3;
mk_size = 20;

%%% iterate on nutrients
for i_nut=1:length(nutrients)
    % nut x cm panel
    model = model_data(model_data.nutrient_type==nutrients(i_nut), :);
    scott = scott_model(scott_model.nutrient_type==nutrients(i_nut), :);
%     plot(model.growth_rate_per_hr, model.model_fR, '-o', 'Color', colors(i_nut,:), 'LineWidth', lw); hold on;
%     plot(scott.growth_rate_per_hr, scott.phi_R, '--s', 'Color', colors(i_nut,:), 'LineWidth', lw); hold on;

    plot(model.growth_rate_per_hr, model.model_ra_over_r, '-o', 'Color', colors(i_nut,:), 'LineWidth', lw); hold on;
    plot(scott.growth_rate_per_hr, scott.ra_over_r, '--s', 'Color', colors(i_nut,:), 'LineWidth', lw); hold on;
end

% styling axes
ylim([0 1]); xlim([0 2]);
ylabel('Active ribosome fraction'); 
xlabel('growth rate (hr^{-1})');
for i=1:1
    figure(i);
    set(gca,'FontSize',35,'LineWidth',2.5);
    set(gcf,'Color','w','Position',[0 0 1200 800]);
end




% addpath('../utils-code/export_fig');
% export_fig(gcf,'../figure-assembly/figure-dai-components/figure_dai_acitve_ribosome_fraction.pdf');
