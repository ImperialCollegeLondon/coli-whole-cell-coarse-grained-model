
addpath('../model-code');

% do it for the three parameter sets (best, low asat, high asat)
model_names = {'ref','low-asat','high-asat'}; 
model_paths = {'', '_low_asat', '_high_asat'};
for i_m=1:length(model_names)
    
    %%% load the data with size to predict and cell composition
    data_file = ['basan_2015_si_2017_taheri_2015_modulations' model_paths{i_m} '.csv'];
    data = readtable(['../results-data/res3_cell-compositions/' data_file]);
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
                eval(strjoin(["[R2, scale_factor, exponents, prediction] = explain_size_from_composition(" data_str{1} ", 'cell_size', {'" sector{1} "'}, " fX_str{1} ");"],''));
                eval(strjoin([sector{1} "(end+1,1) = R2;"],''));
                % for automatic table creation...
                if strcmp(sector{1},'e')
                    table_row_str = strjoin([table_row_str "'" data_str{1} "_fX-" fX_str{1} "',"],'');
                end
                % make and write tables with the regression parameters and the
                % predictions
                out_dir = ['../results-data/res4_basan-2015-si-2017-taheri-2015-fit/' model_names{i_m} '/single-sector-size-predictions/' sector{1} '_' data_str{1} '_fX-' fX_str{1}];
                mkdir(out_dir);
                writetable(table(scale_factor),[out_dir '/scale_factor.csv']);
                writetable(table(exponents),[out_dir '/exponents.csv']);
                eval(strjoin(["real = " data_str{1} ".cell_size;"],''));
                eval(strjoin(["growth_rate_per_hr = " data_str{1} ".growth_rate_per_hr;"],''));
                eval(strjoin(["nutrient_type = " data_str{1} ".nutrient_type;"],''));
                eval(strjoin(["cm_type = " data_str{1} ".cm_type;"],''));
                eval(strjoin(["useless_type = " data_str{1} ".useless_type;"],''));
                writetable(table(growth_rate_per_hr,real,prediction,nutrient_type,cm_type,useless_type),[out_dir '/predictions.csv']);
                if strcmp(fX_str,'true')
                    formula_str = strjoin(["f_X \\propto " sector{1} "^{" num2str(round(100*exponents(1))/100) '}'],'');
                else
                    formula_str = strjoin(["V_{div} \\propto " sector{1} "^{" num2str(round(100*exponents(1))/100) '}'],'');
                end
                formula_str = strrep(formula_str,'ra_over_r','(r_a/r)');
                fileID = fopen([out_dir '/formula.txt'],'w');
                fprintf(fileID,formula_str);
                fclose(fileID);
            end
        end
        table_str = strjoin([table_str sector{1} ','],''); % for automatic table creation
    end
    % create and write the table
    table_row_str = strjoin([table_row_str{1}(1:end-1) "});"],'');
    table_creation_str = strjoin([table_str table_row_str],'');
    eval(table_creation_str);
    writetable(results,['../results-data/res4_basan-2015-si-2017-taheri-2015-fit/single-sector-size-predictions-R2-values_' model_names{i_m}  '.csv'],'WriteRowNames',true);
    
    
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
                    eval(strjoin(["[R2, scale_factor, exponents, prediction] = explain_size_from_composition(" data_str{1} ", 'cell_size', {'" sector_1{1} "','" sector_2{1} "'}, " fX_str{1} ");"],''));
                    eval(strjoin([sector_1{1} "_and_" sector_2{1} "(end+1,1) = R2;"],''));
                    if strcmp(strjoin([sector_1{1} "_and_" sector_2{1}],''),'e_and_r')
                        table_row_str = strjoin([table_row_str "'" data_str{1} "_fX-" fX_str{1} "',"],'');
                    end
                    % make and write tables with the regression parameters and the
                    % predictions
                    out_dir = ['../results-data/res4_basan-2015-si-2017-taheri-2015-fit/' model_names{i_m} '/two-sectors-size-predictions/' sector_1{1} '_and_' sector_2{1} '_' data_str{1} '_fX-' fX_str{1}];
                    mkdir(out_dir);
                    writetable(table(scale_factor),[out_dir '/scale_factor.csv']);
                    writetable(table(exponents),[out_dir '/exponents.csv']);
                    eval(strjoin(["real = " data_str{1} ".cell_size;"],''));
                    eval(strjoin(["growth_rate_per_hr = " data_str{1} ".growth_rate_per_hr;"],''));
                    eval(strjoin(["nutrient_type = " data_str{1} ".nutrient_type;"],''));
                    eval(strjoin(["cm_type = " data_str{1} ".cm_type;"],''));
                    eval(strjoin(["useless_type = " data_str{1} ".useless_type;"],''));
                    writetable(table(growth_rate_per_hr,real,prediction,nutrient_type,cm_type,useless_type),[out_dir '/predictions.csv']);
                    if strcmp(fX_str,'true')
                        formula_str = strjoin(["f_X \\propto " sector_1{1} "^{" num2str(round(100*exponents(1))/100) "} \\times " sector_2{1} "^{" num2str(round(100*exponents(2))/100) '}'],'');
                    else
                        formula_str = strjoin(["V_{div} \\propto " sector{1} "^{" num2str(round(100*exponents(1))/100) "} \\times " sector_2{1} "^{" num2str(round(100*exponents(2))/100) '}'],'');
                    end
                    formula_str = strrep(formula_str,'ra_over_r','(r_a/r)');
                    fileID = fopen([out_dir '/formula.txt'],'w');
                    fprintf(fileID,formula_str);
                    fclose(fileID);
                end
            end
            table_str = strjoin([table_str sector_1{1} "_and_" sector_2{1} ','],'');
        end
    end
    table_row_str = strjoin([table_row_str{1}(1:end-1) "});"],'');
    table_creation_str = strjoin([table_str table_row_str],'');
    eval(table_creation_str);
    writetable(results,['../results-data/res4_basan-2015-si-2017-taheri-2015-fit/two-sectors-size-predictions-R2-values_' model_names{i_m} '.csv'],'WriteRowNames',true);
    
end
