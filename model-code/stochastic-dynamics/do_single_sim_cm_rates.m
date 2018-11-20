function sim_data = do_single_sim_cm_rates(pars, path2cpp, path2output)

addpath('../utils-code');

% path to simulator binary and output folder
pars.out_folder = path2output;

% call the cpp code
call_cpp_program(path2cpp, pars);

% read results
sim_data = read_sim_data(pars.out_folder);

end

function sim_data = read_sim_data(folder)
% load the data
sim_data.params = parse_metadata([ folder '/params.txt' ]);
traj_R_data = load([folder '/lineage_traj_R_data.dat']);
traj_E_data = load([folder '/lineage_traj_E_data.dat']);
traj_Q_data = load([folder '/lineage_traj_Q_data.dat']);
traj_U_data = load([folder '/lineage_traj_U_data.dat']);
traj_X_data = load([folder '/lineage_traj_X_data.dat']);
traj_A_data = load([folder '/lineage_traj_A_data.dat']);
traj_RI_data = load([folder '/lineage_traj_RI_data.dat']);
traj_size_data = load([folder '/lineage_traj_size_data.dat']);
traj_time_data = load([folder '/lineage_traj_time_data.dat']);
if(traj_time_data(end,1) == -1) % remove empty timepoint if needed
    traj_R_data = traj_R_data(1:end-1,:);
    traj_E_data = traj_E_data(1:end-1,:);
    traj_Q_data = traj_Q_data(1:end-1,:);
    traj_U_data = traj_U_data(1:end-1,:);
    traj_X_data = traj_X_data(1:end-1,:);
    traj_A_data = traj_A_data(1:end-1,:);
    traj_RI_data = traj_RI_data(1:end-1,:);
    traj_size_data = traj_size_data(1:end-1,:);
    traj_time_data = traj_time_data(1:end-1,:);
end
sim_data.traj_R = traj_R_data;
sim_data.traj_E = traj_E_data;
sim_data.traj_Q = traj_Q_data;
sim_data.traj_U = traj_U_data;
sim_data.traj_X = traj_X_data;
sim_data.traj_A = traj_A_data;
sim_data.traj_RI = traj_RI_data;
sim_data.traj_size = traj_size_data;
sim_data.traj_time = traj_time_data;
% load the lineage data
sim_data.lineage_data = readtable([folder '/lineage_data.dat']);
% delete it to avoid problems with next calls
system(['rm ' folder '/*' ]);
end
