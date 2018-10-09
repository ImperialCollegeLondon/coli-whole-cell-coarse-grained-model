// From Numerical Recipes, C++ Edition //

#ifndef DEF_LUDCMP
#define DEF_LUDCMP
#include "nr3.h"

struct LUdcmp
{
	Int n;
	MatDoub lu;
    MatDoub_I &aref;
	VecInt indx;
	Doub d;
	LUdcmp(MatDoub_I &a);
	void solve(VecDoub_I &b, VecDoub_O &x);
	void solve(MatDoub_I &b, MatDoub_O &x);
	void inverse(MatDoub_O &ainv);
	Doub det();
	void mprove(VecDoub_I &b, VecDoub_IO &x);
};

#endif

