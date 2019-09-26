
%% load data
all_comp_folder = '../results-data/res2_compositions_coreg-high-delta-model/';
scott_data = readtable([all_comp_folder 'scott_2010_modulations.csv']);
dai_data = readtable([all_comp_folder 'dai_2016_modulations.csv']);
basan_si_taheri_data = readtable([all_comp_folder 'basan_2015_si_2017_taheri_2015_modulations.csv']);

cm_uM = [scott_data.cm_uM; dai_data.cm_uM; basan_si_taheri_data.cm_uM];
source = [scott_data.source; dai_data.source; basan_si_taheri_data.source]; 
model_cm_kon = [scott_data.model_cm_kon; dai_data.model_cm_kon; basan_si_taheri_data.model_cm_kon];
nutrient_type = [scott_data.nutrient_type; dai_data.nutrient_type; basan_si_taheri_data.nutrient_type];
useless_type = [scott_data.useless_type; dai_data.useless_type; basan_si_taheri_data.useless_type];
growth_rate_per_hr = [scott_data.growth_rate_per_hr; dai_data.growth_rate_per_hr; basan_si_taheri_data.growth_rate_per_hr];

data = table(cm_uM, source, growth_rate_per_hr, model_cm_kon, nutrient_type, useless_type);
data_cm_only = data(data.cm_uM > 0, :);
data_cm_only.growth_rate_no_cm = zeros(size(data_cm_only.growth_rate_per_hr));

for i=1:size(data_cm_only,1)
    nut_type = data_cm_only.nutrient_type(i);
    no_cm_this_nut_type = data(data.nutrient_type == nut_type & data.cm_uM == 0 & data.useless_type == 0 & strcmp(data.source, data_cm_only.source(i)), :);
    if size(no_cm_this_nut_type,1) > 1
        error('?');
    end
    data_cm_only.growth_rate_no_cm(i) = no_cm_this_nut_type.growth_rate_per_hr;
end

%% output folder
output_folder = '../figure-assembly/components/';
if ~exist(output_folder, 'dir')
    mkdir(output_folder);
end

%% style parameters
lw = 2;
mk_size = 10;
fig_size = [0 0 800 400];
ax_font_size = 15;
ax_lw = 2;

%%
subplot(1,2,1);
colors = hsv(20);
for i=1:size(data_cm_only,1)
    point = data_cm_only(i,:);
    if strcmp(point.source, 'Scott 2010')
        symbol = 'o';
    elseif strcmp(point.source, 'Dai 2016')
        symbol = 's';
    elseif strcmp(point.source, 'Basan 2015')
        symbol = '^';
    elseif strcmp(point.source, 'Si 2017')
        symbol = 'v';
    else
        error('??');
    end
    i_color = ceil(point.growth_rate_no_cm/2*20);
    plot(point.growth_rate_per_hr / point.growth_rate_no_cm, point.cm_uM,  'Marker', symbol, 'Color', colors(i_color,:), 'MarkerFaceColor', colors(i_color,:), 'MarkerSize', mk_size); hold on; 
end
xlabel('Growth rate reduction');
ylabel('chloramphenicol concentration (\muM)');

subplot(1,2,2);
for i=1:size(data_cm_only,1)
    point = data_cm_only(i,:);
    if strcmp(point.source, 'Scott 2010')
        symbol = 'o';
    elseif strcmp(point.source, 'Dai 2016')
        symbol = 's';
    elseif strcmp(point.source, 'Basan 2015')
        symbol = '^';
    elseif strcmp(point.source, 'Si 2017')
        symbol = 'v';
    else
        error('??');
    end
    i_color = ceil(point.growth_rate_no_cm/2*20);
    plot(point.growth_rate_per_hr / point.growth_rate_no_cm, point.model_cm_kon, 'Marker', symbol, 'Color', colors(i_color,:), 'MarkerFaceColor', colors(i_color,:), 'MarkerSize', mk_size); hold on; 
end
xlabel('Growth rate reduction');
ylabel('Total chloramphenicol binding rate');

for i=1:2
    subplot(1,2,i);
    set(gca,'FontSize',ax_font_size,'LineWidth',ax_lw);
end

set(gcf,'Color','w','Position',fig_size);

saveas(gcf,[output_folder 'res2_cm_uM_vs_cm_kon.pdf']);
close;
