/*
__ Francois Bertaux, Imperial College
__ f.bertaux@imperial.ac.uk
__ December 2015
*/

#ifndef STOCH_SIMULATOR
#define STOCH_SIMULATOR


#include "CellState.hpp"

#include "libs/ran.h"
#include "libs/sparse.h"

struct StochSimulator
{

    // main fields and methods
    ModelParameters* mf_ModelParameters;
    StochSimulator(ModelParameters* modelParameters , Int seed = 1);
    void simulate(CellState* state , Doub duration);
    void prepareForSteps(CellState* cellState);
    Doub doStep(CellState* cellState , Doub targetTime);

    // other fields and methods
    Ran ran; // random generator
    Int mm, nn;
    VecDoub a;  // reaction rates
    MatDoub instate, outstate; // reactants matrix, change state matrix
    NRvector<NRsparseCol> outchg, depend; // change state sparse matrix, reaction dependancy sparse matrix
    VecInt pr;  // priority list for reaction
    Doub t; // time
    Doub asum; // sum of all reactions rates
    typedef Doub(StochSimulator::*rateptr)(VecDoub &s);
    rateptr *dispatch;
    void describereactions();
    ~StochSimulator() {delete [] dispatch;}


    // rate functions
    inline Doub get_size(VecDoub &s) {return s[0]+s[1]+s[2]+s[3]+s[4]+s[5]+s[6];}
    inline Doub get_tot_synth(VecDoub &s) {return mf_ModelParameters->sigma * s[2] * s[1] / (s[1] + mf_ModelParameters->a_sat*get_size(s));}
    inline Doub get_fR(VecDoub &s) {return mf_ModelParameters->delta * s[1] / get_size(s) < 1. - (mf_ModelParameters->fQ + mf_ModelParameters->fX + mf_ModelParameters->fU) ? mf_ModelParameters->delta * s[1] / get_size(s) : 1 - (mf_ModelParameters->fQ + mf_ModelParameters->fX + mf_ModelParameters->fU);}
    inline Doub get_fE(VecDoub &s) {return 1. - (mf_ModelParameters->fQ + mf_ModelParameters->fX + mf_ModelParameters->fU) - get_fR(s);}
    Doub rate0(VecDoub &s){return mf_ModelParameters->k_media * s[0]; } // metabolism
  	Doub rate1(VecDoub &s){return get_fR(s) * get_tot_synth(s);} // R_synth
  	Doub rate2(VecDoub &s){return get_fE(s) * get_tot_synth(s);} // E_synth
  	Doub rate3(VecDoub &s){return mf_ModelParameters->fQ * get_tot_synth(s);} // Q_synth
  	Doub rate4(VecDoub &s){return mf_ModelParameters->fU * get_tot_synth(s);} // U_synth
  	Doub rate5(VecDoub &s){return mf_ModelParameters->fX * get_tot_synth(s);} // X_synth
    Doub rate6(VecDoub &s){return mf_ModelParameters->r_ri_rate * s[2];} // R gets inactivated
    Doub rate7(VecDoub &s){return mf_ModelParameters->ri_r_rate * s[6];} // RI gets activated back
    Doub rate8(VecDoub &s){return mf_ModelParameters->X_degrad_rate * s[5];}
};


#endif
