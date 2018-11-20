function sim_datas = varySingleParam ( ref_pars , par_to_vary , value_vec )

pars = ref_pars ;
sim_datas = cell (length(value_vec),1) ;

for i=1:length(value_vec)
    eval ( [ 'pars.' par_to_vary ' = ' num2str(value_vec(i)) ' ;' ] ) ;
    sim_datas{i} = do_single_sim ( pars ) ;
end

% do basic analysis on data
for i=1:length(value_vec)
    lineage_data = sim_datas{i}.lineage_data ;
    % burn the 100 first cell_cycle
    lineage_data = lineage_data(101:end,:) ;
    % compute the needed statistics
    sim_datas{i}.mean_birth_size = mean(lineage_data.V_birth) ;
    sim_datas{i}.CV_birth_size = compute_CV(lineage_data.V_birth) ;
    sim_datas{i}.avg_T_div = mean(lineage_data.T_div) ;
    sim_datas{i}.CV_T_div = compute_CV(lineage_data.T_div) ;
    sim_datas{i}.corr_V_birth_delta_V = corr_fb ( lineage_data.V_birth , lineage_data.delta_V ) ;

    % added size per birth size
    n_bins_Vb = 10 ;
    [~,I_sort] = sort ( lineage_data.V_birth ) ;
    n_per_bins = floor ( length(I_sort) / n_bins_Vb ) ;
    % compute average in each bins
    sim_datas{i}.avg_Vbs = zeros ( n_bins_Vb , 1 ) ;
    sim_datas{i}.avg_deltaVs = zeros ( n_bins_Vb , 1 ) ;
    for i_b = 1:n_bins_Vb
        sim_datas{i}.avg_Vbs(i_b) = mean(lineage_data.V_birth(I_sort((i_b-1)*n_per_bins+1:i_b*n_per_bins))) ;
        sim_datas{i}.avg_deltaVs(i_b) = mean(lineage_data.delta_V(I_sort((i_b-1)*n_per_bins+1:i_b*n_per_bins))) ;
    end

end


end

