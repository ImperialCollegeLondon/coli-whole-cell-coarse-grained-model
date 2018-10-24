
addpath('../model-code');

%%% load the data with size to predict and cell composition
data = readtable('../results-data/res3_cell-compositions/basan_2015_si_2017_modulations.csv');
data_nut_only = data(data.cm_type == 0 & data.useless_type == 0, :);
data_nut_cm = data(data.useless_type == 0, :);
data_nut_useless = data(data.cm_type == 0, :);

%%% compute goodness of prediction for all single cell composition variables (for the different
%%% data groups, first fX, then size directly)
%
single_sectors = {'e', 'r', 'ra', 'ra_over_r', 'fE', 'fR', 'fQ', 'a'};
% for automatic table creation...
table_str = "results = table(";
table_row_str = "'RowNames',{";
% iterate on sectors x data group x via fX or direct size prediction
for sector=single_sectors
    eval(strjoin([sector{1} " = [];"],'')); % for automatic table creation...
    for data_str={'data_nut_cm','data_nut_useless','data_nut_only','data'}
        for fX_str={'true','false'}
            % compute the size regression for this sector / data group / fX
            % or direct volume
            eval(strjoin(["[R2, scale_factor, exponents, predictions] = explain_size_from_composition(" data_str{1} ", 'cell_size', {'" sector{1} "'}, " fX_str{1} ");"],''));
            eval(strjoin([sector{1} "(end+1,1) = R2;"],''));
            % for automatic table creation...
            if strcmp(sector{1},'e')
                table_row_str = strjoin([table_row_str "'" data_str{1} "_fX-" fX_str{1} "',"],'');
            end
            % make and write tables with the regression parameters and the
            % predictions
            out_dir = ['../results-data/res4_basan-2015-si-2017-fit/single-sector-size-predictions/' sector{1} '_' data_str{1} '_fX-' fX_str{1}];
            mkdir(out_dir);
            writetable(table(scale_factor),[out_dir '/scale_factor.csv']);
            writetable(table(exponents),[out_dir '/exponents.csv']);
            eval(strjoin(["real = " data_str{1} ".cell_size;"],''));
            eval(strjoin(["nutrient_type = " data_str{1} ".nutrient_type;"],''));
            eval(strjoin(["cm_type = " data_str{1} ".cm_type;"],''));
            eval(strjoin(["useless_type = " data_str{1} ".useless_type;"],''));
            writetable(table(predictions,real,nutrient_type,cm_type,useless_type),[out_dir '/predictions.csv']);
        end
    end
    table_str = strjoin([table_str sector{1} ','],''); % for automatic table creation
end
% create and write the table
table_row_str = strjoin([table_row_str{1}(1:end-1) "});"],'');
table_creation_str = strjoin([table_str table_row_str],'');
eval(table_creation_str);
writetable(results,'../results-data/res4_basan-2015-si-2017-fit/single-sector-size-predictions-R2-values.csv','WriteRowNames',true);


%%% do two sectors prediction
table_str = "results = table(";
table_row_str = "'RowNames',{";
for i_sector_1=1:length(single_sectors)
    for i_sector_2=i_sector_1+1:length(single_sectors)
        sector_1 = {single_sectors{i_sector_1}};
        sector_2 = {single_sectors{i_sector_2}};
        eval(strjoin([sector_1{1} "_and_" sector_2{1} " = [];"],''));
        for data_str={'data_nut_cm','data_nut_useless','data_nut_only','data'}
            for fX_str={'true','false'}
                eval(strjoin(["[R2, scale_factor, exponents, predictions] = explain_size_from_composition(" data_str{1} ", 'cell_size', {'" sector_1{1} "','" sector_2{1} "'}, " fX_str{1} ");"],''));
                eval(strjoin([sector_1{1} "_and_" sector_2{1} "(end+1,1) = R2;"],''));
                if strcmp(strjoin([sector_1{1} "_and_" sector_2{1}],''),'e_and_r')
                    table_row_str = strjoin([table_row_str "'" data_str{1} "_fX-" fX_str{1} "',"],'');
                end
                % make and write tables with the regression parameters and the
                % predictions
                out_dir = ['../results-data/res4_basan-2015-si-2017-fit/two-sectors-size-predictions/' sector_1{1} '_and_' sector_2{1} '_' data_str{1} '_fX-' fX_str{1}];
                mkdir(out_dir);
                writetable(table(scale_factor),[out_dir '/scale_factor.csv']);
                writetable(table(exponents),[out_dir '/exponents.csv']);
                eval(strjoin(["real = " data_str{1} ".cell_size;"],''));
                eval(strjoin(["nutrient_type = " data_str{1} ".nutrient_type;"],''));
                eval(strjoin(["cm_type = " data_str{1} ".cm_type;"],''));
                eval(strjoin(["useless_type = " data_str{1} ".useless_type;"],''));
                writetable(table(predictions,real,nutrient_type,cm_type,useless_type),[out_dir '/predictions.csv']);
            end
        end
        table_str = strjoin([table_str sector_1{1} "_and_" sector_2{1} ','],'');
    end
end
table_row_str = strjoin([table_row_str{1}(1:end-1) "});"],'');
table_creation_str = strjoin([table_str table_row_str],'');
eval(table_creation_str);
writetable(results,'../results-data/res4_basan-2015-si-2017-fit/two-sectors-size-predictions-R2-values.csv','WriteRowNames',true);




% 
% 
% for i_sector_1=1:length(single_sectors)
%     for i_sector_2=i_sector_1+1:length(single_sectors)
%         sector_1 = {single_sectors{i_sector_1}};
%         sector_2 = {single_sectors{i_sector_2}};
%         eval(strjoin([sector_1{1} "_and_" sector_2{1} " = [];"],''));
%         eval(strjoin([sector_1{1} "_and_" sector_2{1} "(end+1,1) = explain_size_from_composition(data_nut_only, 'cell_size', {'" sector_1{1} "','" sector_2{1} "'}, true);"],''));
%         eval(strjoin([sector_1{1} "_and_" sector_2{1} "(end+1,1) = explain_size_from_composition(data_nut_cm, 'cell_size', {'" sector_1{1} "','" sector_2{1} "'}, true);"],''));
%         eval(strjoin([sector_1{1} "_and_" sector_2{1} "(end+1,1) = explain_size_from_composition(data_nut_useless, 'cell_size', {'" sector_1{1} "','" sector_2{1} "'}, true);"],''));
%         eval(strjoin([sector_1{1} "_and_" sector_2{1} "(end+1,1) = explain_size_from_composition(data, 'cell_size', {'" sector_1{1} "','" sector_2{1} "'}, true);"],''));
%         eval(strjoin([sector_1{1} "_and_" sector_2{1} "(end+1,1) = explain_size_from_composition(data_nut_only, 'cell_size', {'" sector_1{1} "','" sector_2{1} "'}, false);"],''));
%         eval(strjoin([sector_1{1} "_and_" sector_2{1} "(end+1,1) = explain_size_from_composition(data_nut_cm, 'cell_size', {'" sector_1{1} "','" sector_2{1} "'}, false);"],''));
%         eval(strjoin([sector_1{1} "_and_" sector_2{1} "(end+1,1) = explain_size_from_composition(data_nut_useless, 'cell_size', {'" sector_1{1} "','" sector_2{1} "'}, false);"],''));
%         eval(strjoin([sector_1{1} "_and_" sector_2{1} "(end+1,1) = explain_size_from_composition(data, 'cell_size', {'" sector_1{1} "','" sector_2{1} "'}, false);"],''));
%     end
% end
% results = table(e_and_r,e_and_ra,e_and_ra_over_r,e_and_fE,e_and_fR,e_and_fQ,e_and_a,...
%     r_and_ra,r_and_ra_over_r,r_and_fE,r_and_fR,r_and_fQ,r_and_a,...
%     ra_and_ra_over_r,ra_and_fE,ra_and_fR,ra_and_fQ,ra_and_a,...
%     ra_over_r_and_fE,ra_over_r_and_fR,ra_over_r_and_fQ,ra_over_r_and_a,...
%     fE_and_fR,fE_and_fQ,fE_and_a,...
%     fR_and_fQ,fR_and_a,...
%     fQ_and_a,...
%     'RowNames',...
%     {'only_nut_vol_via_fX','nut_cm_vol_via_fX','nut_useless_vol_via_fX','all_vol_via_fX', ...
%     'only_nut_vol_direct','nut_cm_vol_direct','nut_useless_vol_direct','all_vol_direct'});







%%% select interesting
% [nut_only_e_vol_direct.R2, nut_only_e_vol_direct.scale, nut_only_e_vol_direct.exponents, nut_only_e_vol_direct.predictions] = explain_size_from_composition(data_nut_only, 'cell_size', {'e'}, false);
% [nut_only_e_vol_via_fX.R2, nut_only_e_vol_via_fX.scale, nut_only_e_vol_via_fX.exponents, nut_only_e_vol_via_fX.predictions] = explain_size_from_composition(data_nut_only, 'cell_size', {'e'}, true);
%
% [all_e_ra_over_r_vol_direct.R2, all_e_ra_over_r_vol_direct.scale, all_e_ra_over_r_vol_direct.exponents, all_e_ra_over_r_vol_direct.predictions] = explain_size_from_composition(data, 'cell_size', {'e', 'ra_over_r'}, false);
% [all_e_ra_over_r_vol_via_fX.R2, all_e_ra_over_r_vol_via_fX.scale, all_e_ra_over_r_vol_via_fX.exponents, all_e_ra_over_r_vol_via_fX.predictions] = explain_size_from_composition(data, 'cell_size', {'e', 'ra_over_r'}, true);


