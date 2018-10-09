// From Numerical Recipes, C++ Edition //

#ifndef DEF_SPARSE
#define DEF_SPARSE

#include "sort.h"
#include "nr3.h"

struct NRsparseCol
{
    Int nrows;
    Int nvals;
    VecInt row_ind;
    VecDoub val;

    NRsparseCol(Int m,Int nnvals) : nrows(m), nvals(nnvals),
    row_ind(nnvals,0),val(nnvals,0.0) {}

    NRsparseCol() : nrows(0),nvals(0),row_ind(),val() {}

    void resize(Int m, Int nnvals) {
        nrows = m;
        nvals = nnvals;
        row_ind.assign(nnvals,0);
        val.assign(nnvals,0.0);
    }

};

struct NRsparseMat
{
    Int nrows;
    Int ncols;
    Int nvals;
    VecInt col_ptr;
    VecInt row_ind;
    VecDoub val;

    NRsparseMat();
    NRsparseMat(Int m,Int n,Int nnvals);
    VecDoub ax(const VecDoub &x) const;
    VecDoub atx(const VecDoub &x) const;
    NRsparseMat transpose() const;
};

struct ADAT {
    const NRsparseMat &a,&at;
    NRsparseMat *adat;

    ADAT(const NRsparseMat &A,const NRsparseMat &AT);
    void updateD(const VecDoub &D);
    NRsparseMat &ref();
    ~ADAT();
};

#endif
