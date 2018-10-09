/*
__ Francois Bertaux, Imperial College
__ f.bertaux@imperial.ac.uk
__ December 2015
*/


#include "ModelParameters.hpp"

ModelParameters::ModelParameters()
{
  // init parameter values
	mf_NumSpecies = 7; // R,E,Q,U,X,A = 6 species + RI = 7 species
	mf_NumReacs = 8; // metabolism + 5 synthesis + R <-> RI
	mf_ReacRates = VecDoub(mf_NumReacs, 0.);
}
