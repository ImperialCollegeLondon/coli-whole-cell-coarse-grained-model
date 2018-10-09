// From Numerical Recipes, C++ Edition //

#ifndef STEPPERDOPR835_H
#define STEPPERDOPR835_H

#include "stepper.h"


struct Dopr853_constants
{
    static const Doub c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c14,c15,c16,
    b1,b6,b7,b8,b9,b10,b11,b12,bhh1,bhh2,bhh3,
    er1,er6,er7,er8,er9,er10,er11,er12,
    a21,a31,a32,a41,a43,a51,a53,a54,a61,a64,a65,a71,a74,a75,a76,
    a81,a84,a85,a86,a87,a91,a94,a95,a96,a97,a98,a101,a104,a105,
    a106,a107,a108,a109,a111,a114,a115,a116,a117,a118,a119,a1110,
    a121,a124,a125,a126,a127,a128,a129,a1210,a1211,a141,a147,a148,
    a149,a1410,a1411,a1412,a1413,a151,a156,a157,a158,a1511,a1512,
    a1513,a1514,a161,a166,a167,a168,a169,a1613,a1614,a1615,
    d41,d46,d47,d48,d49,d410,d411,d412,d413,d414,d415,d416,d51,d56,
    d57,d58,d59,d510,d511,d512,d513,d514,d515,d516,d61,d66,d67,d68,
    d69,d610,d611,d612,d613,d614,d615,d616,d71,d76,d77,d78,d79,
    d710,d711,d712,d713,d714,d715,d716;
};



template <class D>
struct StepperDopr853 : StepperBase, Dopr853_constants
{
    typedef D Dtype;
    VecDoub yerr2;
    VecDoub k2,k3,k4,k5,k6,k7,k8,k9,k10;
    VecDoub rcont1,rcont2,rcont3,rcont4,rcont5,rcont6,rcont7,rcont8;

    StepperDopr853(VecDoub_IO &yy, VecDoub_IO &dydxx, Doub &xx,
                   const Doub atoll, const Doub rtoll, bool dens);
    void step(const Doub htry,D &derivs);
    void dy(const Doub h,D &derivs);
    void prepare_dense(const Doub h,VecDoub_I &dydxnew,D &derivs);
    Doub dense_out(const Int i, const Doub x, const Doub h);
    Doub error(const Doub h);
    struct Controller
    {
        bool reject;
        Doub hnext,errold;
        Controller();
        bool success(const Doub err, Doub &h);
    };
    Controller con;
};

template <class D>
StepperDopr853<D>::StepperDopr853(VecDoub_IO &yy,VecDoub_IO &dydxx,Doub &xx,
                                  const Doub atoll,const Doub rtoll,bool dens) :
    StepperBase(yy,dydxx,xx,atoll,rtoll,dens),yerr2(n),k2(n),k3(n),k4(n),
    k5(n),k6(n),k7(n),k8(n),k9(n),k10(n),rcont1(n),rcont2(n),rcont3(n),
    rcont4(n),rcont5(n),rcont6(n),rcont7(n),rcont8(n) {
    EPS=numeric_limits<Doub>::epsilon();
}
template <class D>
void StepperDopr853<D>::step(const Doub htry,D &derivs) {
    VecDoub dydxnew(n);
    Doub h=htry;
    for (;;) {
        dy(h,derivs);
        Doub err=error(h);
        if (con.success(err,h)) break;
        if (abs(h) <= abs(x)*EPS)
            throw("stepsize underflow in StepperDopr853");
    }
    derivs(x+h,yout,dydxnew);
    if (dense)
        prepare_dense(h,dydxnew,derivs);
    dydx=dydxnew;
    y=yout;
    xold=x;
    x += (hdid=h);
    hnext=con.hnext;
}
template <class D>
void StepperDopr853<D>::dy(const Doub h,D &derivs) {
    VecDoub ytemp(n);
    Int i;
    for (i=0;i<n;i++)
        ytemp[i]=y[i]+h*a21*dydx[i];
    derivs(x+c2*h,ytemp,k2);
    for (i=0;i<n;i++)
        ytemp[i]=y[i]+h*(a31*dydx[i]+a32*k2[i]);
    derivs(x+c3*h,ytemp,k3);
    for (i=0;i<n;i++)
        ytemp[i]=y[i]+h*(a41*dydx[i]+a43*k3[i]);
    derivs(x+c4*h,ytemp,k4);
    for (i=0;i<n;i++)
        ytemp[i]=y[i]+h*(a51*dydx[i]+a53*k3[i]+a54*k4[i]);
    derivs(x+c5*h,ytemp,k5);
    for (i=0;i<n;i++)
        ytemp[i]=y[i]+h*(a61*dydx[i]+a64*k4[i]+a65*k5[i]);
    derivs(x+c6*h,ytemp,k6);
    for (i=0;i<n;i++)
        ytemp[i]=y[i]+h*(a71*dydx[i]+a74*k4[i]+a75*k5[i]+a76*k6[i]);
    derivs(x+c7*h,ytemp,k7);
    for (i=0;i<n;i++)
        ytemp[i]=y[i]+h*(a81*dydx[i]+a84*k4[i]+a85*k5[i]+a86*k6[i]+a87*k7[i]);
    derivs(x+c8*h,ytemp,k8);
    for (i=0;i<n;i++)
        ytemp[i]=y[i]+h*(a91*dydx[i]+a94*k4[i]+a95*k5[i]+a96*k6[i]+a97*k7[i]+
                         a98*k8[i]);
    derivs(x+c9*h,ytemp,k9);
    for (i=0;i<n;i++)
        ytemp[i]=y[i]+h*(a101*dydx[i]+a104*k4[i]+a105*k5[i]+a106*k6[i]+
                         a107*k7[i]+a108*k8[i]+a109*k9[i]);
    derivs(x+c10*h,ytemp,k10);
    for (i=0;i<n;i++)
        ytemp[i]=y[i]+h*(a111*dydx[i]+a114*k4[i]+a115*k5[i]+a116*k6[i]+
                         a117*k7[i]+a118*k8[i]+a119*k9[i]+a1110*k10[i]);
    derivs(x+c11*h,ytemp,k2);
    Doub xph=x+h;
    for (i=0;i<n;i++)
        ytemp[i]=y[i]+h*(a121*dydx[i]+a124*k4[i]+a125*k5[i]+a126*k6[i]+
                         a127*k7[i]+a128*k8[i]+a129*k9[i]+a1210*k10[i]+a1211*k2[i]);
    derivs(xph,ytemp,k3);
    for (i=0;i<n;i++) {
        k4[i]=b1*dydx[i]+b6*k6[i]+b7*k7[i]+b8*k8[i]+b9*k9[i]+b10*k10[i]+
                b11*k2[i]+b12*k3[i];
        yout[i]=y[i]+h*k4[i];
    }
    for (i=0;i<n;i++) {
        yerr[i]=k4[i]-bhh1*dydx[i]-bhh2*k9[i]-bhh3*k3[i];
        yerr2[i]=er1*dydx[i]+er6*k6[i]+er7*k7[i]+er8*k8[i]+er9*k9[i]+
                er10*k10[i]+er11*k2[i]+er12*k3[i];
    }
}
template <class D>
void StepperDopr853<D>::prepare_dense(const Doub h,VecDoub_I &dydxnew,
                                      D &derivs) {
    Int i;
    Doub ydiff,bspl;
    VecDoub ytemp(n);
    for (i=0;i<n;i++) {
        rcont1[i]=y[i];
        ydiff=yout[i]-y[i];
        rcont2[i]=ydiff;
        bspl=h*dydx[i]-ydiff;
        rcont3[i]=bspl;
        rcont4[i]=ydiff-h*dydxnew[i]-bspl;
        rcont5[i]=d41*dydx[i]+d46*k6[i]+d47*k7[i]+d48*k8[i]+
                d49*k9[i]+d410*k10[i]+d411*k2[i]+d412*k3[i];
        rcont6[i]=d51*dydx[i]+d56*k6[i]+d57*k7[i]+d58*k8[i]+
                d59*k9[i]+d510*k10[i]+d511*k2[i]+d512*k3[i];
        rcont7[i]=d61*dydx[i]+d66*k6[i]+d67*k7[i]+d68*k8[i]+
                d69*k9[i]+d610*k10[i]+d611*k2[i]+d612*k3[i];
        rcont8[i]=d71*dydx[i]+d76*k6[i]+d77*k7[i]+d78*k8[i]+
                d79*k9[i]+d710*k10[i]+d711*k2[i]+d712*k3[i];
    }
    for (i=0;i<n;i++)
        ytemp[i]=y[i]+h*(a141*dydx[i]+a147*k7[i]+a148*k8[i]+a149*k9[i]+
                         a1410*k10[i]+a1411*k2[i]+a1412*k3[i]+a1413*dydxnew[i]);
    derivs(x+c14*h,ytemp,k10);
    for (i=0;i<n;i++)
        ytemp[i]=y[i]+h*(a151*dydx[i]+a156*k6[i]+a157*k7[i]+a158*k8[i]+
                         a1511*k2[i]+a1512*k3[i]+a1513*dydxnew[i]+a1514*k10[i]);
    derivs(x+c15*h,ytemp,k2);
    for (i=0;i<n;i++)
        ytemp[i]=y[i]+h*(a161*dydx[i]+a166*k6[i]+a167*k7[i]+a168*k8[i]+
                         a169*k9[i]+a1613*dydxnew[i]+a1614*k10[i]+a1615*k2[i]);
    derivs(x+c16*h,ytemp,k3);
    for (i=0;i<n;i++)
    {
        rcont5[i]=h*(rcont5[i]+d413*dydxnew[i]+d414*k10[i]+d415*k2[i]+d416*k3[i]);
        rcont6[i]=h*(rcont6[i]+d513*dydxnew[i]+d514*k10[i]+d515*k2[i]+d516*k3[i]);
        rcont7[i]=h*(rcont7[i]+d613*dydxnew[i]+d614*k10[i]+d615*k2[i]+d616*k3[i]);
        rcont8[i]=h*(rcont8[i]+d713*dydxnew[i]+d714*k10[i]+d715*k2[i]+d716*k3[i]);
    }
}
template <class D>
Doub StepperDopr853<D>::dense_out(const Int i,const Doub x,const Doub h) {
    Doub s=(x-xold)/h;
    Doub s1=1.0-s;
    return rcont1[i]+s*(rcont2[i]+s1*(rcont3[i]+s*(rcont4[i]+s1*(rcont5[i]+
                                                                 s*(rcont6[i]+s1*(rcont7[i]+s*rcont8[i]))))));
}
template <class D>
Doub StepperDopr853<D>::error(const Doub h) {
    Doub err=0.0,err2=0.0,sk,deno;
    for (Int i=0;i<n;i++) {
        sk=atol+rtol*MAX(abs(y[i]),abs(yout[i]));
        err2 += SQR(yerr[i]/sk);
        err += SQR(yerr2[i]/sk);
    }
    deno=err+0.01*err2;
    if (deno <= 0.0)
        deno=1.0;
    return abs(h)*err*sqrt(1.0/(n*deno));
}
template <class D>
StepperDopr853<D>::Controller::Controller() : reject(false), errold(1.0e-4) {}
template <class D>
bool StepperDopr853<D>::Controller::success(const Doub err, Doub &h) {
    static const Doub beta=0.0,alpha=1.0/8.0-beta*0.2,safe=0.9,minscale=0.333,
            maxscale=6.0;
    Doub scale;
    if (err <= 1.0) {
        if (err == 0.0)
            scale=maxscale;
        else {
            scale=safe*pow(err,-alpha)*pow(errold,beta);
            if (scale<minscale) scale=minscale;
            if (scale>maxscale) scale=maxscale;
        }
        if (reject)
            hnext=h*MIN(scale,1.0);
        else
            hnext=h*scale;
        errold=MAX(err,1.0e-4);
        reject=false;
        return true;
    } else {
        scale=MAX(safe*pow(err,-alpha),minscale);
        h *= scale;
        reject=true;
        return false;
    }
}


#endif // STEPPERDOPR835_H
