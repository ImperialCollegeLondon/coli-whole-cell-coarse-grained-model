
addpath('../model-code');
addpath('../model-code/steady-state_coreg-high-delta/');

%%% load the data with size to predict and cell composition
data_file = 'basan_2015_si_2017_taheri_2015_modulations.csv';
data = readtable(['../results-data/res2_compositions_coreg-high-delta-model/' data_file]);
data.model_fRA = data.model_fR .* data.model_active_rib_frac;
data_nut_only = data(data.cm_type == 0 & data.useless_type == 0, :);
data_nut_cm = data(data.useless_type == 0, :);
data_nut_useless = data(data.cm_type == 0, :);

%%%
output_folder = '../results-data/res6_size-predictions-from-comp/';
if ~exist(output_folder, 'dir')
    mkdir(output_folder);
end

%%% compute goodness of prediction for all single cell composition variables (for the different
%%% data groups, first fX, then size directly)
%
single_sectors = {'fE', 'fR', 'fRA', 'active_rib_frac'};
% for automatic table creation...
table_str = 'results = table(';
table_row_str = '''RowNames'',{';
% iterate on sectors x data group x via fX or direct size prediction
for sector=single_sectors
    eval([sector{1} ' = [];']); % for automatic table creation...
    for data_str={'data_nut_cm','data_nut_useless','data_nut_only','data'}
        for fX_str={'false'}
            % compute the size regression for this sector / data group / fX
            % or direct volume
            eval(['[R2, scale_factor, exponents, prediction] = explain_size_from_composition(' data_str{1} ', ''cell_size'', {''' sector{1} '''}, ' fX_str{1} ');']);
            eval([sector{1} '(end+1,1) = R2;']);
            % for automatic table creation...
            if strcmp(sector{1},single_sectors{1})
                table_row_str = [table_row_str '''' data_str{1} '_fX-' fX_str{1} ''','];
            end
            % make and write tables with the regression parameters and the
            % predictions
            out_dir = [output_folder '/' sector{1} '_' data_str{1} '_fX-' fX_str{1}];
            mkdir(out_dir);
            writetable(table(scale_factor),[out_dir '/scale_factor.csv']);
            writetable(table(exponents),[out_dir '/exponents.csv']);
            eval(['real = ' data_str{1} '.cell_size;']);
            eval(['growth_rate_per_hr = ' data_str{1} '.growth_rate_per_hr;']);
            eval(['nutrient_type = ' data_str{1} '.nutrient_type;']);
            eval(['cm_type = ' data_str{1} '.cm_type;']);
            eval(['useless_type = ' data_str{1} '.useless_type;']);
            eval(['source = ' data_str{1} '.source;']);
            writetable(table(growth_rate_per_hr,real,prediction,nutrient_type,cm_type,useless_type,source),[out_dir '/predictions.csv']);
            if strcmp(fX_str,'true')
                formula_str = ['f_X \\propto ' sector{1} '^{' num2str(round(100*exponents(1))/100) '}'];
            else
                formula_str = ['V_{div} \\propto ' sector{1} '^{' num2str(round(100*exponents(1))/100) '}'];
            end
            formula_str = strrep(formula_str,'ra_over_r','(r_a/r)');
            formula_str = strrep(formula_str,'e_over_ra','(e/r_a)');
            formula_str = strrep(formula_str,'e_over_r','(e/r)');
            formula_str = strrep(formula_str,'active_rib_frac','(fRA/fR)');
            fileID = fopen([out_dir '/formula.txt'],'w');
            fprintf(fileID,formula_str);
            fclose(fileID);
        end
    end
    table_str = [table_str sector{1} ',']; % for automatic table creation
end
% create and write the table
table_row_str = [table_row_str(1:end-1) '});'];
table_creation_str = [table_str table_row_str];
eval(table_creation_str);
writetable(results,[output_folder '/single-sector-size-predictions-R2-values.csv'],'WriteRowNames',true);


%%% do two sectors prediction
table_str = 'results = table(';
table_row_str = '''RowNames'',{';
for i_sector_1=1:length(single_sectors)
    for i_sector_2=i_sector_1+1:length(single_sectors)
        sector_1 = {single_sectors{i_sector_1}};
        sector_2 = {single_sectors{i_sector_2}};
        eval([sector_1{1} '_and_' sector_2{1} ' = [];']);
        for data_str={'data_nut_cm','data_nut_useless','data_nut_only','data'}
            for fX_str={'false'}
                eval(['[R2, scale_factor, exponents, prediction] = explain_size_from_composition(' data_str{1} ', ''cell_size'', {''' sector_1{1} ''',''' sector_2{1} '''}, ' fX_str{1} ');']);
                eval([sector_1{1} '_and_' sector_2{1} '(end+1,1) = R2;']);
                if strcmp([sector_1{1} '_and_' sector_2{1}],[single_sectors{1} '_and_' single_sectors{2}])
                    table_row_str = [table_row_str '''' data_str{1} '_fX-' fX_str{1} ''','];
                end
                % make and write tables with the regression parameters and the
                % predictions
                out_dir = [output_folder '/' sector_1{1} '_and_' sector_2{1} '_' data_str{1} '_fX-' fX_str{1}];
                mkdir(out_dir);
                writetable(table(scale_factor),[out_dir '/scale_factor.csv']);
                writetable(table(exponents),[out_dir '/exponents.csv']);
                eval(['real = ' data_str{1} '.cell_size;']);
                eval(['growth_rate_per_hr = ' data_str{1} '.growth_rate_per_hr;']);
                eval(['nutrient_type = ' data_str{1} '.nutrient_type;']);
                eval(['cm_type = ' data_str{1} '.cm_type;']);
                eval(['useless_type = ' data_str{1} '.useless_type;']);
                eval(['source = ' data_str{1} '.source;']);
                writetable(table(growth_rate_per_hr,real,prediction,nutrient_type,cm_type,useless_type,source),[out_dir '/predictions.csv']);
                if strcmp(fX_str,'true')
                    formula_str = ['f_X \\propto ' sector_1{1} '^{' num2str(round(100*exponents(1))/100) '} \\times ' sector_2{1} '^{' num2str(round(100*exponents(2))/100) '}'];
                else
                    formula_str = ['V_{div} \\propto ' sector_1{1} '^{' num2str(round(100*exponents(1))/100) '} \\times ' sector_2{1} '^{' num2str(round(100*exponents(2))/100) '}'];
                end
                formula_str = strrep(formula_str,'ra_over_r','(r_a/r)');
                formula_str = strrep(formula_str,'e_over_ra','(e/r_a)');
                formula_str = strrep(formula_str,'e_over_r','(e/r)');
                formula_str = strrep(formula_str,'active_rib_frac','(fRA/fR)');
                fileID = fopen([out_dir '/formula.txt'],'w');
                fprintf(fileID,formula_str);
                fclose(fileID);
            end
        end
        table_str = [table_str sector_1{1} '_and_' sector_2{1} ','];
    end
end
table_row_str = [table_row_str(1:end-1) '});'];
table_creation_str = [table_str table_row_str];
eval(table_creation_str);
writetable(results,[output_folder '/two-sectors-size-predictions-R2-values.csv'],'WriteRowNames',true);

%%% do three sectors prediction
table_str = 'results = table(';
table_row_str = '''RowNames'',{';
for i_sector_1=1:length(single_sectors)
    for i_sector_2=i_sector_1+1:length(single_sectors)
        for i_sector_3=i_sector_2+1:length(single_sectors)
            sector_1 = {single_sectors{i_sector_1}};
            sector_2 = {single_sectors{i_sector_2}};
            sector_3 = {single_sectors{i_sector_3}};
            eval([sector_1{1} '_and_' sector_2{1} '_and_' sector_3{1} ' = [];']);
            for data_str={'data'}
                for fX_str={'false'}
                    eval(['[R2, scale_factor, exponents, prediction] = explain_size_from_composition(' data_str{1} ', ''cell_size'', {''' sector_1{1} ''',''' sector_2{1} ''',''' sector_3{1} '''}, ' fX_str{1} ');']);
                    eval([sector_1{1} '_and_' sector_2{1} '_and_' sector_3{1} '(end+1,1) = R2;']);
                    if strcmp([sector_1{1} '_and_' sector_2{1} '_and_' sector_3{1}],[single_sectors{1} '_and_' single_sectors{2} '_and_' single_sectors{3}])
                        table_row_str = [table_row_str '''' data_str{1} '_fX-' fX_str{1} ''','];
                    end
                    % make and write tables with the regression parameters and the
                    % predictions
                    out_dir = [output_folder '/' sector_1{1} '_and_' sector_2{1} '_and_' sector_3{1} '_' data_str{1} '_fX-' fX_str{1}];
                    mkdir(out_dir);
                    writetable(table(scale_factor),[out_dir '/scale_factor.csv']);
                    writetable(table(exponents),[out_dir '/exponents.csv']);
                    eval(['real = ' data_str{1} '.cell_size;']);
                    eval(['growth_rate_per_hr = ' data_str{1} '.growth_rate_per_hr;']);
                    eval(['nutrient_type = ' data_str{1} '.nutrient_type;']);
                    eval(['cm_type = ' data_str{1} '.cm_type;']);
                    eval(['useless_type = ' data_str{1} '.useless_type;']);
                    eval(['source = ' data_str{1} '.source;']);
                    writetable(table(growth_rate_per_hr,real,prediction,nutrient_type,cm_type,useless_type,source),[out_dir '/predictions.csv']);
                    if strcmp(fX_str,'true')
                        formula_str = ['f_X \\propto ' sector_1{1} '^{' num2str(round(100*exponents(1))/100) '} \\times ' sector_2{1} '^{' num2str(round(100*exponents(2))/100) '}' '\\times ' sector_3{1} '^{' num2str(round(100*exponents(3))/100) '}'];
                    else
                        formula_str = ['V_{div} \\propto ' sector_1{1} '^{' num2str(round(100*exponents(1))/100) '} \\times ' sector_2{1} '^{' num2str(round(100*exponents(2))/100) '}' '\\times ' sector_3{1} '^{' num2str(round(100*exponents(3))/100) '}'];
                    end
                    formula_str = strrep(formula_str,'ra_over_r','(r_a/r)');
                    formula_str = strrep(formula_str,'e_over_ra','(e/r_a)');
                    formula_str = strrep(formula_str,'e_over_r','(e/r)');
                    formula_str = strrep(formula_str,'active_rib_frac','(fRA/fR)');
                    fileID = fopen([out_dir '/formula.txt'],'w');
                    fprintf(fileID,formula_str);
                    fclose(fileID);
                end
            end
            table_str = [table_str sector_1{1} '_and_' sector_2{1} '_and_' sector_3{1} ','];
        end
    end
end
table_row_str = [table_row_str(1:end-1) '});'];
table_creation_str = [table_str table_row_str];
eval(table_creation_str);
writetable(results,[output_folder '/three-sectors-size-predictions-R2-values.csv'],'WriteRowNames',true);

