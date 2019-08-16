

%%% load the data with size to predict and cell composition
data_file = 'basan_2015_si_2017_taheri_2015_modulations.csv';
data = readtable(['../results-data/resXX_scott-2010-model_cell-compositions/' data_file]);
data_nut_only = data(data.cm_type == 0 & data.useless_type == 0, :);
data_nut_cm = data(data.useless_type == 0, :);
data_nut_useless = data(data.cm_type == 0, :);


%%% compute goodness of prediction for all single cell composition variables (for the different
%%% data groups, first fX, then size directly)
%
single_sectors = {'fE', 'fR', 'active_R_frac', 'kn', 'kt'};
% for automatic table creation...
table_str = 'results = table(';
table_row_str = '''RowNames'',{';
% iterate on sectors x data group x via fX or direct size prediction
for sector=single_sectors
    eval([sector{1} ' = [];']); % for automatic table creation...
    for data_str={'data_nut_cm','data_nut_useless','data_nut_only','data'}
        % compute the size regression for this sector / data group / fX
        % or direct volume
        eval(['R2 = explain_size_rank_from_composition(' data_str{1} ', ''cell_size'', ''' sector{1} ''');']);
        eval([sector{1} '(end+1,1) = R2;']);
        % for automatic table creation...
        if strcmp(sector{1},single_sectors{1})
            table_row_str = [table_row_str '''' data_str{1} ''','];
        end
    end
    table_str = [table_str sector{1} ',']; % for automatic table creation
end
% create and write the table
table_row_str = [table_row_str(1:end-1) '});'];
table_creation_str = [table_str table_row_str];
eval(table_creation_str);
writetable(results,['../results-data/resXX_scott-2010-model_basan-2015-si-2017-taheri-2015-rank-fit/single-sector-size-rank-predictions-R2-values_'    '.csv'],'WriteRowNames',true);



