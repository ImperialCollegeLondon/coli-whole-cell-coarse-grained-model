
#include "StochSimulator.hpp"
#include "common.h"
#include "simparams.h"

#include "gemodelfunctions.hpp"
#include "partitioningfunctions.hpp"

int main ( int argc, char *argv[] )
{

    // struct for parsing parameters
    SimParams sim_params ( argc , argv ) ;

    // init model param and sim structs
    ModelParameters* modelParameters = new ModelParameters () ;
    Int seed = sim_params.get_int_param ("random_seed") ;
    StochSimulator* stochSimulator = new StochSimulator ( modelParameters , seed ) ;

    // parsing model variants
    string partitioning_type = sim_params.get_string_param ( "partitioning_type" ) ;
    string GE_model = sim_params.get_string_param ( "GE_model" ) ;

    // parsing alpha parameters
    modelParameters->mu_media = sim_params.get_double_param ( "mu_media" ) ;
    modelParameters->alpha_media = modelParameters->mu_media * log(2.) ;
    modelParameters->linear_growth = sim_params.get_int_param("linear_growth");

    // parsing division parameters
    modelParameters->P_div_threshold = sim_params.get_double_param ( "P_div_threshold" ) ;
    modelParameters->P_after_div = sim_params.get_double_param ( "P_after_div" ) ;
    modelParameters->size_splitting_error = sim_params.get_double_param ( "size_splitting_error" ) ;

    //  parsing GE model parameters
    if ( GE_model == "only_protein" )
    {
        modelParameters->set_km ( 0. ) ;
        modelParameters->set_rm ( 0. ) ;
        modelParameters->km_0 = 0. ;
        modelParameters->km_per_size = 0. ;
        modelParameters->kp_0 = sim_params.get_double_param ( "kp_0" ) ;
        modelParameters->kp_per_size = sim_params.get_double_param ( "kp_per_size" ) ;
        modelParameters->set_rp ( sim_params.get_double_param ( "rp" ) ) ;
    }
    if ( GE_model == "only_protein_step_change" )
    {
        modelParameters->set_km ( 0. ) ;
        modelParameters->set_rm ( 0. ) ;
        modelParameters->km_0 = 0. ;
        modelParameters->km_per_size = 0. ;
        modelParameters->kp_0 = sim_params.get_double_param ( "kp_0" ) ;
        modelParameters->kp_per_size = sim_params.get_double_param ( "kp_per_size" ) ;
        modelParameters->set_rp ( sim_params.get_double_param ( "rp" ) ) ;
        modelParameters->P_step_threshold = sim_params.get_double_param ( "P_step_threshold" ) ;
    }
    if ( GE_model == "only_prot_step_change_size_trigger" )
    {
        modelParameters->set_km ( 0. ) ;
        modelParameters->set_rm ( 0. ) ;
        modelParameters->km_0 = 0. ;
        modelParameters->km_per_size = 0. ;
        modelParameters->kp_0 = sim_params.get_double_param ( "kp_0" ) ;
        modelParameters->kp_per_size = 0 ;
        modelParameters->set_kp ( modelParameters->kp_0 ) ;
        modelParameters->set_rp ( sim_params.get_double_param ( "rp" ) ) ;
        modelParameters->step_size_threshold = sim_params.get_double_param ( "step_size_threshold" ) ;
    }
    if ( GE_model == "mrna_prot" )
    {
        modelParameters->km_0 = sim_params.get_double_param ( ("km_0") ) ;
        modelParameters->km_per_size = sim_params.get_double_param ( ("km_per_size") ) ;
        modelParameters->set_rm ( sim_params.get_double_param ( "rm" ) ) ;
        modelParameters->kp_0 = sim_params.get_double_param ( "kp_0" ) ;
        modelParameters->kp_per_size = sim_params.get_double_param ( "kp_per_size" ) ;
        modelParameters->set_rp ( sim_params.get_double_param ( "rp" ) ) ;
    }

    // simulation parameters (always the same, do not depend on model variant)
    Int num_lineages = sim_params.get_int_param ( "num_lineages" ) ;
    Doub sim_duration = sim_params.get_double_param ( "sim_duration" ) ;
    Doub update_period = sim_params.get_double_param ("update_period" ) ;
    Int num_updates_per_output = sim_params.get_double_param ("num_updates_per_output" ) ;
    Int num_timepoints = (Int) ( sim_duration / update_period / (Doub) num_updates_per_output ) + 1 ;
    string out_folder = sim_params.get_string_param ( "out_folder" ) ;
    sim_params.display_params () ;
    sim_params.write_params () ;

    // for debugging
    Bool verbose = false ;

    // Matrice storing timepoints data
    MatDoub lineage_traj_mRNA_data ( num_timepoints , num_lineages , 0. ) ;
    MatDoub lineage_traj_prot_data ( num_timepoints , num_lineages , 0. ) ;
    MatDoub lineage_traj_size_data ( num_timepoints , num_lineages , 0. ) ;
    MatDoub lineage_traj_alpha_data ( num_timepoints , num_lineages , 0. ) ;
    MatDoub lineage_traj_time_data ( num_timepoints , num_lineages , 0. ) ;
    MatDoub lineage_traj_sigma_data ( num_timepoints , num_lineages , 0. ) ;
    Int num_timepoints_done = 0 ;

    // file for lineage only data
    ostringstream outFileName;
    outFileName << out_folder << "/lineage_data.dat" ;
    ofstream output ( ( outFileName.str() ).c_str(), ios::out) ;
    if (!output.is_open()) { cout << " not open! " << endl; exit(1); }
    output << "V_birth,V_div,delta_V,T_div,sigma" << "\n" ;

    // iterate on cells
    for (Int c=0;c<num_lineages;c++)
    {
        // construction of a cell (look constructor for init state)
        CellState *cell = new CellState (modelParameters) ;

        // update gene expression rates
        update_gene_expression_rates ( cell , modelParameters , GE_model ) ;

        // verbose
        if (verbose)
        {
            cout << endl << "Lineage start." << endl ;
            cout << "L_birth = " << cell->Lb << " , L_div = " << cell->Ld << endl << endl ;
        }

        // timers (all in absolute time)
        Doub t_birth = 0 ;
        Doub t = 0 ;
        Doub next_update_t = update_period ;
        num_timepoints_done = 0 ;
        Int num_updates_since_last_output = 0 ;

        while ( t < sim_duration )
        {
            if (verbose) cout << endl << "__ t = " << t << ", t_birth = " << t_birth << " __" << endl ;

            // if division should occur
            if ( cell->get_prot_Level() >= modelParameters->P_div_threshold )
            {
                if (cell->get_prot_Level() > modelParameters->P_div_threshold) {cout<<"overshoot,reduce update"<<endl; exit(1);}

                //verbose
                if (verbose) cout << "Division reached." << endl ;

                // store div size, choose birth size
                cell->previous_Ld = cell->Ld ;
                cell->Ld = cell->L ;
                cell->previous_Lb = cell->Lb ;

                // do imperfect cell splitting
                Doub split = 0 ; while (split <= 0 || split >= 1.0) split = stochSimulator->ran.norm ( 0.5 , modelParameters->size_splitting_error * 0.5 );

                cell->Lb = cell->Ld * split ;
                cell->L = cell->Lb ;

                // write the data
                output << cell->previous_Lb << "," << cell->Ld << "," << cell->Ld - cell->previous_Lb << "," << t - t_birth << "," << modelParameters->get_kp() * cell->get_mRNA_Level() << "\n" ;

                // 'destruction' of some P_div
                cell->set_prot_Level ( modelParameters->P_after_div ) ;

                // binomial partitioning of mRNA and prot
                do_partitioning ( partitioning_type , cell->Lb/cell->Ld , cell , stochSimulator ) ;

                // update gene expression rates
                update_gene_expression_rates ( cell , modelParameters , GE_model ) ;
                if (GE_model == "only_prot_step_change_size_trigger") modelParameters->set_kp ( modelParameters->get_kp() / 2. ) ;

                // update timers
                t_birth = t ;
            }

            // if output needed, do output
            if ( (num_updates_since_last_output == num_updates_per_output) || (t == 0)  )
            {
                if (num_timepoints_done < num_timepoints)
                {
                    lineage_traj_mRNA_data[num_timepoints_done][c] = cell->get_mRNA_Level() ;
                    lineage_traj_prot_data[num_timepoints_done][c] = cell->get_prot_Level() ;
                    lineage_traj_size_data[num_timepoints_done][c] = cell->L ;
                    lineage_traj_alpha_data[num_timepoints_done][c] = cell->alpha ;
                    lineage_traj_time_data[num_timepoints_done][c] = t ;
                    lineage_traj_sigma_data[num_timepoints_done][c] = modelParameters->get_kp() * cell->get_mRNA_Level() ;
                    num_timepoints_done++ ;
                    num_updates_since_last_output = 0 ;
                    if (verbose) cout << "outputs done = " << num_timepoints_done << endl ;
                }
            }

            // simulate until next update (but will stop before if reach threshold)
            Doub duration = stochSimulator->simulate ( cell , next_update_t - t ) ; // remaining time before update

            // update gene expression rates (if needed by GE_model)
            update_gene_expression_rates (cell , modelParameters , GE_model ) ;

            // update time
            t += duration ;

            // update timers
            next_update_t = t + update_period ;
            num_updates_since_last_output++ ;
        }

        // free memory used by the cell if not needed
        delete cell ;
    }

    // verify all points in the tables have been filled, if needed, remove last point
    if (num_timepoints_done < num_timepoints)
    {
        //        cout << "timepoints not filled" << endl ;
        if ( num_timepoints_done < num_timepoints - 1 )
        {
            cout << "error: more than one timepoint missing ?!" << endl ; exit(4) ;
        }
        lineage_traj_time_data[num_timepoints-1][0] = -1 ; // flag that will be detected by matlab
    }

    // close lineage output
    output.close () ;

    // write data on file
    ostringstream suffix ; suffix << ".dat" ;
    if (verbose) cout << endl << endl << "writing tables" << endl ;
    writeMatrixInTextFile ( out_folder , "lineage_traj_mRNA_data"+suffix.str ()  , lineage_traj_mRNA_data ) ;
    writeMatrixInTextFile ( out_folder , "lineage_traj_prot_data"+suffix.str ()  , lineage_traj_prot_data ) ;
    writeMatrixInTextFile ( out_folder , "lineage_traj_size_data"+suffix.str ()  , lineage_traj_size_data ) ;
    writeMatrixInTextFile ( out_folder , "lineage_traj_alpha_data"+suffix.str ()  , lineage_traj_alpha_data ) ;
    writeMatrixInTextFile ( out_folder , "lineage_traj_time_data"+suffix.str () , lineage_traj_time_data ) ;
    writeMatrixInTextFile ( out_folder , "lineage_traj_sigma_data"+suffix.str () , lineage_traj_sigma_data ) ;
    return 0 ;
}
