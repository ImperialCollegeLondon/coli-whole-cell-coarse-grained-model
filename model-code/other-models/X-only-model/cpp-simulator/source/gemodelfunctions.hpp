#ifndef GEMODELFUNCTIONS
#define GEMODELFUNCTIONS

#include "CellState.hpp"
#include "ModelParameters.hpp"

void update_gene_expression_rates ( CellState* cell , ModelParameters* modelParameters , string GE_model )
{
    if ( GE_model == "only_protein" )
    {
        cell->set_mRNA_Level (1) ; // will stay like (in btw div !) this because no deg no transcr.
        Doub kp = modelParameters->kp_0 + modelParameters->kp_per_size * cell->L ;
        modelParameters->set_kp ( max (kp,0.) ) ;
    }
    else if ( GE_model == "mrna_prot" )
    {
        Doub km = modelParameters->km_0 + modelParameters->km_per_size * cell->L ;
        modelParameters->set_km ( max (km,0.) ) ;
        Doub kp = modelParameters->kp_0 + modelParameters->kp_per_size * cell->L ;
        modelParameters->set_kp ( max (kp,0.) ) ;
    }
    else if ( GE_model == "only_protein_step_change" )
    {
        cell->set_mRNA_Level (1) ; // will stay like (in btw div !) this because no deg no transcr.
        if ( cell->get_prot_Level() < modelParameters->P_step_threshold )
        {
            modelParameters->set_kp ( modelParameters->kp_0 ) ;
        }
        else
        {
            modelParameters->set_kp ( 2.0 * modelParameters->kp_0 ) ;
        }
    }
    else if ( GE_model == "only_prot_step_change_size_trigger" )
    {
        cell->set_mRNA_Level (1) ; // will stay like (in btw div !) this because no deg no transcr.
        if ( (cell->L / modelParameters->get_kp()) > modelParameters->step_size_threshold )
        {
            modelParameters->set_kp ( 2.0 * modelParameters->get_kp() ) ;
        }
    }
    else { cout << "error: unknown GE_model (" << GE_model << ")" << endl ; exit(2) ; }
}


#endif // GEMODELFUNCTIONS
