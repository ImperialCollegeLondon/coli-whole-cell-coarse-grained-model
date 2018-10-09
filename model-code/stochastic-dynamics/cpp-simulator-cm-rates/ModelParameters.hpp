/*
__ Francois Bertaux, Imperial College
__ f.bertaux@imperial.ac.uk
__ December 2015
*/


#ifndef MODEL_PARAMETERS
#define MODEL_PARAMETERS

#include "libs/nr3.h"

struct ModelParameters
{
    Int mf_NumSpecies;
    Int mf_NumReacs;
    VecDoub mf_ReacRates;

    ModelParameters();

    // for division control
    Doub X_div;

    // for synthesis
    Doub sigma;
    Doub a_sat;
    Doub fR;
    Doub fE;
    Doub fQ;
    Doub fU;
    Doub fX;

    // media
    Doub k_media;
    Doub r_ri_rate;
    Doub ri_r_rate;
};

#endif
