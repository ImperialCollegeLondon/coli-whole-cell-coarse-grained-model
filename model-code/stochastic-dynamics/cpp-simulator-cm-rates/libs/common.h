// François Bertaux, Inria Paris-Rocquencourt, 2015 //

#include "nr3.h"

#ifndef COMMON_H
#define COMMON_H

using namespace std;


static double CUBIC_ROOT_2 = pow(2.,1./3.);

string toFullString(int a, int digitNumber);

void writeMatrixInTextFile ( string folder , string filename , MatDoub data ) ;
void writeVectorInTextFile ( string folder , string filename , VecDoub data ) ;
void writeVectorInTextFile ( string folder , string filename , double* data , int datasize ) ;

double computeMeanFromMatrix ( int dim , int ind , MatDoub data ) ;
double computeVarFromMatrix ( int dim , int ind , MatDoub data ) ;

MatDoub readMatrixInTextFile ( string folder , string filename , int numRows , int numCols ) ;
VecDoub readVectorInTextFile ( string folder , string filename , int numRows ) ;

int* createAndInitIntTable ( int sizeTable , int value ) ;
bool* createAndInitBoolTable ( int sizeTable , bool value ) ;


double absoluteDistanceSquaredBetweenMatrix ( MatDoub A , MatDoub B ) ;

void displayDouble (double val , string label) ;
void displayDoubleTriplet ( double x , string xlab , double y , string ylab , double z , string zlab ) ;


#endif
