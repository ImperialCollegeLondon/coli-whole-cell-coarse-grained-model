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
    Bool destroy_X;
    Doub X_degrad_rate;

    // for synthesis
    Doub sigma;
    Doub a_sat;
    Doub delta;
    Doub fQ;
    Doub fU;
    Doub fX_scale;
    Doub fX_e_exp;
    Doub fX_active_rib_frac_exp;

    // media
    Doub k_media;
    Doub r_ri_rate;
    Doub ri_r_rate;
};

#endif
