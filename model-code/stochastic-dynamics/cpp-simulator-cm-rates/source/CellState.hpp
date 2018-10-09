/*
__ Francois Bertaux, Imperial College
__ f.bertaux@imperial.ac.uk
__ December 2015
*/

#ifndef CELL_STATE
#define CELL_STATE

#include "libs/nr3.h"

#include "ModelParameters.hpp"

struct CellState
{
	ModelParameters* mf_ModelParameters;
	VecDoub mf_SpecieCounts;

	CellState(ModelParameters* modelParameters);

	// methods for name access to species
	inline Doub get_P_E_Level(){ return mf_SpecieCounts[0]; }
	inline Doub get_A_Level(){ return mf_SpecieCounts[1]; }
	inline Doub get_P_R_Level(){ return mf_SpecieCounts[2]; }
	inline Doub get_P_Q_Level(){ return mf_SpecieCounts[3]; }
	inline Doub get_P_U_Level(){ return mf_SpecieCounts[4]; }
	inline Doub get_P_X_Level(){ return mf_SpecieCounts[5]; }
	inline Doub get_P_RI_Level(){ return mf_SpecieCounts[6]; }

	inline void set_P_E_Level(Doub value){ mf_SpecieCounts[0] = value; }
	inline void set_A_Level(Doub value){ mf_SpecieCounts[1] = value; }
	inline void set_P_R_Level(Doub value){ mf_SpecieCounts[2] = value; }
	inline void set_P_Q_Level(Doub value){ mf_SpecieCounts[3] = value; }
	inline void set_P_U_Level(Doub value){ mf_SpecieCounts[4] = value; }
	inline void set_P_X_Level(Doub value){ mf_SpecieCounts[5] = value; }
	inline void set_P_RI_Level(Doub value){ mf_SpecieCounts[6] = value; }

  // method getting size
  inline Doub get_size() { return mf_SpecieCounts[0]+mf_SpecieCounts[1]+mf_SpecieCounts[2]+mf_SpecieCounts[3]+mf_SpecieCounts[4]+mf_SpecieCounts[5]+mf_SpecieCounts[6]; }

	// store size at birth and div
  Doub Lb;
  Doub Ld;
  Doub previous_Lb;
  Doub previous_Ld;
};


#endif
