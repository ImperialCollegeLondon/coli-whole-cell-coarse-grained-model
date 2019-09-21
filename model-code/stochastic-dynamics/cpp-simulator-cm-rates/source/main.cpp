/*
__ Francois Bertaux, Imperial College
__ f.bertaux@imperial.ac.uk
__ December 2015 - September 2018
*/


#include "StochSimulator.hpp"
#include "libs/common.h"
#include "simparams.h"
#include "partitioningfunctions.hpp"


int main(int argc, char *argv[])
{
    cout << "starting simulator c++ code..." << endl;

    // struct for parsing parameters
    SimParams sim_params(argc, argv);

    // init model param and sim structs
    ModelParameters* modelParameters = new ModelParameters();
    Int seed = sim_params.get_int_param("random_seed");
    StochSimulator* stochSimulator = new StochSimulator(modelParameters, seed);

    // parsing model variants
    string partitioning_type = sim_params.get_string_param("partitioning_type");
    modelParameters->destroy_X = sim_params.get_int_param("destroy_X_after_div");

    // parsing media parameters
    modelParameters->k_media = sim_params.get_double_param("k_media");
    modelParameters->r_ri_rate = sim_params.get_double_param("r_ri_rate");
    modelParameters->ri_r_rate = sim_params.get_double_param("ri_r_rate");

    // parsing synthesis parameters
    modelParameters->sigma = sim_params.get_double_param("sigma");
    modelParameters->a_sat = sim_params.get_double_param("a_sat");
    modelParameters->delta = sim_params.get_double_param("delta");
    modelParameters->fQ = sim_params.get_double_param("f_Q");
    modelParameters->fU = sim_params.get_double_param("f_U");
    modelParameters->fX = sim_params.get_double_param("f_X");

    // parsing X degradation rate
    modelParameters->X_degrad_rate = sim_params.get_double_param("X_degrad_rate");

    // check allocation sums to less 1
    Doub sum_allocation = modelParameters->fQ + modelParameters->fU + modelParameters->fX;
    if (sum_allocation > 1) {
      cout << "allocation parameters are wrong (" << sum_allocation <<  ")" << endl;
      sim_params.display_params();
      exit(1);
    }

    // parsing division parameters
    modelParameters->X_div = sim_params.get_double_param("X_div");

    // simulation parameters(always the same, do not depend on model variant)
    Int num_lineages = sim_params.get_int_param("num_lineages");
    Doub sim_duration = sim_params.get_double_param("sim_duration");
    Doub update_period = sim_params.get_double_param("update_period");
    Int num_updates_per_output = sim_params.get_double_param("num_updates_per_output");
    Int num_timepoints =(Int)(sim_duration / update_period /(Doub) num_updates_per_output ) + 1;
    cout << "computed timepoints number = " << num_timepoints << endl;
    string out_folder = sim_params.get_string_param("out_folder");
    sim_params.display_params();
    sim_params.write_params();

    // for debugging
    Bool verbose = false;

    // Matrice storing timepoints data
    MatDoub lineage_traj_R_data(num_timepoints, num_lineages, 0.);
    MatDoub lineage_traj_E_data(num_timepoints, num_lineages, 0.);
    MatDoub lineage_traj_Q_data(num_timepoints, num_lineages, 0.);
    MatDoub lineage_traj_U_data(num_timepoints, num_lineages, 0.);
    MatDoub lineage_traj_X_data(num_timepoints, num_lineages, 0.);
    MatDoub lineage_traj_A_data(num_timepoints, num_lineages, 0.);
    MatDoub lineage_traj_RI_data(num_timepoints, num_lineages, 0.);
    MatDoub lineage_traj_size_data(num_timepoints, num_lineages, 0.);
    MatDoub lineage_traj_time_data(num_timepoints, num_lineages, 0.);
    Int num_timepoints_done = 0;

    // file for lineage only data
    ostringstream outFileName;
    outFileName << out_folder << "/lineage_data.dat";
    ofstream output(( outFileName.str() ).c_str(), ios::out);
    if(!output.is_open()) { cout << " not open! " << endl; exit(1); }
    output << "V_birth,V_div,delta_V,T_div,R,E,Q,U,X,A,RI" << "\n";

    // iterate on cells
    for(Int c=0;c<num_lineages;c++)
    {
        // construction of a cell(look constructor for init state)
        CellState *cell = new CellState(modelParameters);
        cell->set_P_R_Level(100);
        cell->set_P_E_Level(100);
        cell->set_A_Level(10);

        // timers(all in absolute time)
        Doub t_birth = 0;
        Doub t = 0;
        Doub next_update_t = update_period;
        num_timepoints_done = 0;
        Int num_updates_since_last_output = 0;

        while (t < sim_duration)
        {
            if(verbose) cout << endl << "__ t = " << t << ", t_birth = " << t_birth << ", X = " << cell->get_P_X_Level() << " __" << endl;

            // if division should occur
            if(cell->get_P_X_Level() >= modelParameters->X_div)
            {

                //verbose
                if(verbose) cout << "Division reached." << endl;

                // store div size, choose birth size
                cell->previous_Ld = cell->Ld;
                cell->Ld = cell->get_size();
                cell->previous_Lb = cell->Lb;

                // binomial partitioning of mRNA and prot
                if (modelParameters->destroy_X) {cell->set_P_X_Level(0.);}
                do_partitioning(partitioning_type, 0.5, cell, stochSimulator);
                cell->Lb = cell->get_size();

                // write the data (second part)
                output << cell->previous_Lb << "," << cell->Ld << "," << cell->Ld - cell->previous_Lb;
                output << "," << t - t_birth << ",";
                output << cell->get_P_R_Level() << "," << cell->get_P_E_Level() << ",";
                output << cell->get_P_Q_Level() << "," << cell->get_P_U_Level() << ",";
                output << cell->get_P_X_Level() << "," << cell->get_A_Level() << ",";
                output << cell->get_P_RI_Level() << "\n";

                // update timers
                t_birth = t;
            }

            // if output needed, do output
            if((num_updates_since_last_output == num_updates_per_output) || (t == 0))
            {
                if(num_timepoints_done == num_timepoints) {
                    cout << "error output table: too many timepoints done ? (" << num_timepoints_done;
                    cout << " when t = " << t << " / " << sim_duration << ")" << endl;
                    //cout << (bool) (t < sim_duration) << endl;
                    //exit(5);
                }
                else {
                    lineage_traj_R_data[num_timepoints_done][c] = cell->get_P_R_Level();
                    lineage_traj_E_data[num_timepoints_done][c] = cell->get_P_E_Level();
                    lineage_traj_Q_data[num_timepoints_done][c] = cell->get_P_Q_Level();
                    lineage_traj_U_data[num_timepoints_done][c] = cell->get_P_U_Level();
                    lineage_traj_X_data[num_timepoints_done][c] = cell->get_P_X_Level();
                    lineage_traj_A_data[num_timepoints_done][c] = cell->get_A_Level();
                    lineage_traj_RI_data[num_timepoints_done][c] = cell->get_P_RI_Level();
                    lineage_traj_size_data[num_timepoints_done][c] = cell->get_size();
                    lineage_traj_time_data[num_timepoints_done][c] = t;
                    num_timepoints_done++;
                    num_updates_since_last_output = 0;
                    if(verbose) cout << "outputs done = " << num_timepoints_done << endl;
                }
            }

            // simulate until next update
            stochSimulator->simulate(cell, next_update_t - t); // remaining time before update

            // update time
            t = next_update_t;

            // update timers
            next_update_t = t + update_period;
            num_updates_since_last_output++;
        }

        // free memory used by the cell if not needed
        delete cell;
    }

    // verify all points in the tables have been filled, if needed, remove last point
    if(num_timepoints_done < num_timepoints)
    {
        //        cout << "timepoints not filled" << endl;
        if(num_timepoints_done < num_timepoints - 1 )
        {
            cout << "error: more than one timepoint missing ?!" << endl; exit(4);
        }
        lineage_traj_time_data[num_timepoints-1][0] = -1; // flag that will be detected by matlab
    }

    // close lineage output
    output.close();

    // write data on file
    ostringstream suffix; suffix << ".dat";
    if(verbose) cout << endl << endl << "writing tables" << endl;
    writeMatrixInTextFile(out_folder, "lineage_traj_R_data"+suffix.str() , lineage_traj_R_data);
    writeMatrixInTextFile(out_folder, "lineage_traj_E_data"+suffix.str() , lineage_traj_E_data);
    writeMatrixInTextFile(out_folder, "lineage_traj_Q_data"+suffix.str() , lineage_traj_Q_data);
    writeMatrixInTextFile(out_folder, "lineage_traj_U_data"+suffix.str() , lineage_traj_U_data);
    writeMatrixInTextFile(out_folder, "lineage_traj_X_data"+suffix.str() , lineage_traj_X_data);
    writeMatrixInTextFile(out_folder, "lineage_traj_A_data"+suffix.str() , lineage_traj_A_data);
    writeMatrixInTextFile(out_folder, "lineage_traj_RI_data"+suffix.str() , lineage_traj_RI_data);
    writeMatrixInTextFile(out_folder, "lineage_traj_size_data"+suffix.str() , lineage_traj_size_data);
    writeMatrixInTextFile(out_folder, "lineage_traj_time_data"+suffix.str(), lineage_traj_time_data);
    return 0;
}
