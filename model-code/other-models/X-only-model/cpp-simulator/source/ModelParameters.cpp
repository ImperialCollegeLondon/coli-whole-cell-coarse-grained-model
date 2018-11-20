/*
__ Francois Bertaux, Imperial College
__ f.bertaux@imperial.ac.uk
__ December 2015
*/


#include "ModelParameters.hpp"

ModelParameters::ModelParameters ()
{
    // init parameter values
	mf_NumSpecies = 2 ;
	mf_NumReacs = 4 ;

	mf_ReacRates = VecDoub ( mf_NumReacs , 0. ) ;

    mf_ReacRates[0] = 0.0 ; //mrna_prod
    mf_ReacRates[1] = 0.0 ; //mrna_degrad
    mf_ReacRates[2] = 0.0 ; //protein_prod
    mf_ReacRates[3] = 0.0 ; //protein_degrad
}
