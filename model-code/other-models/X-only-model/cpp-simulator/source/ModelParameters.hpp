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

    // for stochastic gene expression
    inline void set_km(Doub km) {mf_ReacRates[0] = km;}
    inline void set_rm(Doub rm) {mf_ReacRates[1] = rm;}
    inline void set_kp(Doub kp) {mf_ReacRates[2] = kp;}
    inline void set_rp(Doub rp) {mf_ReacRates[3] = rp;}
    inline Doub get_kp() {return mf_ReacRates[2];}

    // for growth
    Doub mu_media;
    Doub alpha_media;
    Bool linear_growth;

    // for dependent GE
    Doub km_0;
    Doub km_per_size;
    Doub kp_0;
    Doub kp_per_size;
//    Doub km_per_alpha;

    // for division control
    Doub P_div_threshold;
    Doub P_after_div;
    Doub size_splitting_error;

    // for step change
    Doub P_step_threshold;
    Doub step_size_threshold;

};

#endif
