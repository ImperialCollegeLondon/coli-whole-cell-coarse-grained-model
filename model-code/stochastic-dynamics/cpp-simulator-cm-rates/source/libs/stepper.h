// From Numerical Recipes, C++ Edition //

#ifndef DEF_STEPPER
#define DEF_STEPPER

#include "nr3.h"

struct StepperBase
{
    // Base class for all ODE algorithms.
    Doub &x ;               // "time".
    Doub xold ;				// Used for dense output.
    VecDoub &y , &dydx ;    // State vector and derivative vector.
    Doub atol , rtol ;
    bool dense ;
    Doub hdid ;				// Actual stepsize accomplished by the step routine.
    Doub hnext ;			// Stepsize predicted by the controller for the next step.
    Doub EPS ;
    Int n , neqn ;			// neqn = n except for StepperStoerm.
    VecDoub yout , yerr ;	// New value of y and error estimate.

    // constructor
    StepperBase(VecDoub_IO &yy, VecDoub_IO &dydxx, Doub &xx, const Doub atoll,
                const Doub rtoll, bool dens) : x(xx),y(yy),dydx(dydxx),atol(atoll),
        rtol(rtoll),dense(dens),n(y.size()),neqn(n),yout(n),yerr(n) {}
};


#endif

