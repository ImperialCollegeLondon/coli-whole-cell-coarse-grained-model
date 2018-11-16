

%%% 

% load Xdiv x fX simulation data and the best 'fit'
data = readtable('../results-data/res8_fX-scale-and-Xdiv/Xdiv_fX_impact_on_noise.csv');
best_fit = readtable('../results-data/res8_fX-scale-and-Xdiv/Xdiv_fX_scale_fit.csv');

% format data
[fX_mat,Xdiv_mat] = meshgrid(sort(unique(data.fX)),sort(unique(data.X_div)));
noise.CV_birth_size = zeros(size(fX_mat));
noise.CV_growth_rate = zeros(size(fX_mat));
for i=1:size(fX_mat,1)
    for j=1:size(fX_mat,2)
        I = find(data.X_div==Xdiv_mat(i,j) & data.fX==fX_mat(i,j));
        noise.CV_birth_size(i,j) = data.CV_birth_size(I);
        noise.CV_growth_rate(i,j) = data.CV_growth_rate(I);
    end
end

% plot the two noise (size and growth rate) vs the div x fX
props = {'CV_birth_size', 'CV_growth_rate'};
ref_values = [0.11, 0.07];
for i=1:2
    subplot(1,2,i);
    imagesc('XData', [min(data.fX) max(data.fX)], 'YData', [min(data.X_div) max(data.X_div)], 'CData', noise.(props{i})); hold on;
    plot(best_fit.fX, best_fit.X_div, 'ro', 'MarkerSize', 20, 'MarkerFaceColor', 'r');
    xlabel('f_X'); ylabel('X_{div}');
    c = colorbar;
    title(strrep(props{i},'_',' '));
    set(gca,'YDir','normal','FontSize',20,'LineWidth',2);
end


% finish and export
addpath('../utils-code/export_fig');
set(gcf,'Position',[351 363 1663 599],'Color','w');
export_fig(gcf,'../figure-assembly/sup-figure-5-components/sup_figure_5_all.pdf');
close;
