/*
__ Francois Bertaux, Imperial College
__ f.bertaux@imperial.ac.uk
__ December 2015
*/


#include "CellState.hpp"

CellState::CellState ( ModelParameters* modelParameters ) : mf_ModelParameters (modelParameters)
{
	mf_SpecieCounts = VecDoub ( mf_ModelParameters->mf_NumSpecies , 0. ) ;
    Lb = 1 ;
    L = Lb ;
    alpha = mf_ModelParameters->alpha_media ;
}
