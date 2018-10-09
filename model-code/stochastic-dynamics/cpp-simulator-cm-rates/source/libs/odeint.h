// From Numerical Recipes, C++ Edition (slightly modified by François Bertaux) //

#ifndef ODE_INT
#define ODE_INT

#include "nr3.h"
#include "stepperdopr5.h"
// #include "stepperdopr853.h"
// #include "steppersie.h"


// structure for dense output
struct Output
{
    Int kmax ;
    Int nvar ;
    Int nsave ;
    bool dense ;
    Int count ;
    Doub x1,x2,xout,dxout;
    VecDoub xsave ;
    MatDoub ysave ;
    Output() : kmax(-1),dense(false),count(0) {}
    
    Output(const Int nsavee) : kmax(500),nsave(nsavee),count(0),xsave(kmax)
    {
        dense = nsave > 0 ? true : false;
    }
    
    void init(const Int neqn, const Doub xlo, const Doub xhi)
    {
        nvar=neqn;
        if (kmax == -1) return;
        ysave.resize(nvar,kmax);
        if (dense)
        {
            x1=xlo;
            x2=xhi;
            xout=x1;
            dxout=(x2-x1)/nsave;
        }
    }
    
    void resize()
    {
        Int kold=kmax;
        kmax *= 2;
        VecDoub tempvec(xsave);
        xsave.resize(kmax);
        for (Int k=0; k<kold; k++)
            xsave[k]=tempvec[k];
        MatDoub tempmat(ysave);
        ysave.resize(nvar,kmax);
        for (Int i=0; i<nvar; i++)
            for (Int k=0; k<kold; k++)
                ysave[i][k]=tempmat[i][k];
    }
    
    template <class Stepper>
    void save_dense(Stepper &s, const Doub xout, const Doub h)
    {
        if (count == kmax) resize();
        for (Int i=0;i<nvar;i++)
            ysave[i][count]=s.dense_out(i,xout,h);
        xsave[count++]=xout;
    }

    void save(const Doub x, VecDoub_I &y)
    {
        if (kmax <= 0) return;
        if (count == kmax) resize();
        for (Int i=0;i<nvar;i++)
            ysave[i][count]=y[i];
        xsave[count++]=x;
    }
    
    template <class Stepper>
    void out(const Int nstp,const Doub x,VecDoub_I &y,Stepper &s,const Doub h)
    {
        if (!dense)
            throw("dense output not set in Output!");
        if (nstp == -1)
        {
            save(x,y);
            xout += dxout;
        }
        else
        {
            while ((x-xout)*(x2-x1) > 0.0)
            {
                save_dense(s,xout,h);
                xout += dxout;
            }
        }
    }
    
    void printFile(string prefix)
    {
        if (!dense)
            throw("dense output not set in Output!");
        ostringstream filename;
        filename << prefix << ".txt";
        ofstream sortie( ( filename.str() ).c_str(), ios::out);
        for (Int i=0;i<count;i++)
        {
            sortie << xsave[i] << "\t";
            for (Int j=0;j<nvar;j++)
                sortie << ysave[j][i] << "\t";
            sortie << "\n";
        }
    }

};


// structure for controlling the integration
template<class Stepper>
struct Odeint
{
    static const Int MAXSTP=500000000;
    Doub EPS;
    Int nstp;
    Int nvar;
    VecDoub y,dydx;
    Doub x;
    Int nok;
    Int nbad;
    Doub x1,x2,hmin;
    bool dense;
    Output &out;
    typename Stepper::Dtype &derivs;
    Stepper s;
    Doub h;

    Odeint(int numVariables,const Doub xx1,const Doub xx2,
           const Doub atol,const Doub rtol,const Doub h1,
           const Doub hminn,Output &outt,typename Stepper::Dtype &derivss);
    void integrate(VecDoub &ystart,Doub xx1, Doub xx2);

    void displayStatus();
};

template<class Stepper>
Odeint<Stepper>::Odeint(int numVariables, const Doub xx1, const Doub xx2,
                        const Doub atol, const Doub rtol, const Doub h1, const Doub hminn,
                        Output &outt,typename Stepper::Dtype &derivss) : nvar(numVariables),
    y(nvar),dydx(nvar),x(xx1),nok(0),nbad(0),
    x1(xx1),x2(xx2),hmin(hminn),dense(outt.dense),out(outt),derivs(derivss),
    s(y,dydx,x,atol,rtol,dense)
{
    if (x2<x1) { cout << "I don't like your x2 & x1" << endl; exit(34); }
    EPS=numeric_limits<Doub>::epsilon();
    h=SIGN(h1,x2-x1);
    out.init(s.neqn,x1,x2);
}

template<class Stepper>
void Odeint<Stepper>::integrate(VecDoub &ystart, Doub xx1, Doub xx2)
{
    x=xx1;
    x1=xx1;
    x2 = xx2;
    if (x2<x1) { cout << "I don't like your x2 & x1. In integrate" << endl; exit(34); }
    //    cout << "\t\t\t\tbeginning of integrate..." << endl;
    for (Int i=0;i<nvar;i++) y[i]=ystart[i];
    //    cout << "\tdid copied ystart in y..." << endl;
    derivs(x,y,dydx); // to compute dydx
    //    cout << "\tderivs computed..." << endl;
    if (dense)
        out.out(-1,x,y,s,h);
    else
        out.save(x,y);
    for (nstp=0;nstp<MAXSTP;nstp++)
    {
        if ((x+h*1.0001-x2)*(x2-x1) > 0.0)
            h=x2-x;
        s.step(h,derivs);
        //cout << "\t\t\t step" << endl;
        if (s.hdid == h) ++nok; else ++nbad;
        if (dense)
            out.out(nstp,x,y,s,s.hdid);
        else
            out.save(x,y);
        if ((x-x2)*(x2-x1) >= 0.0)
        {
            for (Int i=0;i<nvar;i++) ystart[i]=y[i];
            //            cout << " R : " << y[1] << endl;
            if (out.kmax > 0 && abs(out.xsave[out.count-1]-x2) > 100.0*abs(x2)*EPS)
                out.save(x,y);
            //            cout << "\tfinished integrate." << endl;
            return;
        }
        if (abs(s.hnext) <= hmin) throw("Step size too small in Odeint");
        h=s.hnext;
    }
    throw("Too many steps in routine Odeint");
}

template<class Stepper>
void Odeint<Stepper>::displayStatus()
{
    cout << " x : " << x << endl;
    cout << " x1 : " << x1 << endl;
    cout << " x2 : " << x2 << endl;
    cout << " nstep : " << nstp << endl;
    cout << " nok : " << nok << endl;
    cout << " nbad : " << nbad << endl;
    cout << " h : " << h << endl;
    cout << " EPS : " << EPS << endl;
}



#endif



