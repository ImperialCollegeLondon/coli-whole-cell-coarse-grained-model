// François Bertaux, Inria Paris-Rocquencourt, 2015 //


#include "common.h"


string
toFullString(int a, int digitNumber)
{
    ostringstream out;
    for(int i = digitNumber; i > 0; --i ) { if(a < pow(10., i) )	{out << "0";} }
    out << a;
    return out.str();
}


void
writeMatrixInTextFile ( string folder , string filename , MatDoub data )
{
    ostringstream outFileName;
    outFileName << folder << "/" << filename ;
    ofstream output( ( outFileName.str() ).c_str(), ios::out);
    if (!output.is_open()) { cout << " not open! " << endl; exit(1); }


    for (int r = 0 ; r<data.nrows() ; r++ )
    {
        for (int c = 0 ; c < data.ncols() ; c++ )
        {
            output << data[r][c] << "\t" ;
        }
        output << "\n" ;
    }
}

void
writeVectorInTextFile ( string folder , string filename , VecDoub data )
{
    ostringstream outFileName;
    outFileName << folder << "/" << filename ;
    ofstream output( ( outFileName.str() ).c_str(), ios::out);
    if (!output.is_open()) { cout << " not open! " << endl; exit(1); }

    for (int r = 0 ; r<data.size() ; r++ )
    {
        output << data[r] << "\n" ;
    }
}

void
writeVectorInTextFile (string folder, string filename, double *data, int datasize)
{
    ostringstream outFileName;
    outFileName << folder << "/" << filename ;
    ofstream output( ( outFileName.str() ).c_str(), ios::out);
    if (!output.is_open()) { cout << " not open! " << endl; exit(1); }

    for (int r = 0 ; r<datasize ; r++ )
    {
        output << data[r] << "\n" ;
    }
}


MatDoub
readMatrixInTextFile(string folder, string filename, int numRows, int numCols)
{
    string inFileName = folder + "/" + filename ;
    ifstream input ( inFileName.c_str() ) ;
    if (!input.is_open()) { cout << " cannot open file! " << endl; exit(1); }

    MatDoub data ( numRows , numCols , 0. ) ;

    for (int r = 0 ; r < numRows ; r++ )
    {
        for (int c = 0 ; c < numCols ; c++ )
        {
            input >> data[r][c] ;
        }
    }

    return data ;
}

VecDoub
readVectorInTextFile(string folder, string filename, int numRows)
{
    string inFileName = folder + "/" + filename ;
    ifstream input ( inFileName.c_str() ) ;
    if (!input.is_open()) { cout << " cannot open file! " << endl; exit(1); }

    VecDoub data ( numRows , 0. ) ;

    for (int r = 0 ; r < numRows ; r++ )
    {
        input >> data[r] ;
    }

    return data ;
}

int*
createAndInitIntTable ( int sizeTable , int value )
{
    int* table = new int[sizeTable] ;
    for (int i = 0 ; i<sizeTable ; i++ ) { table[i] = value ; }
    return table ;
}

bool*
createAndInitBoolTable ( int sizeTable , bool value )
{
    bool* table = new bool[sizeTable] ;
    for (int i = 0 ; i<sizeTable ; i++ ) { table[i] = value ; }
    return table ;
}

double
absoluteDistanceSquaredBetweenMatrix(MatDoub A, MatDoub B)
{
    double dist2 = 0 ;
    for (int r = 0 ; r<A.nrows() ; r++ )
    {
        for (int c = 0 ; c < B.ncols() ; c++ )
        {
            dist2 += ( A[r][c] - B[r][c] ) * ( A[r][c] - B[r][c] ) ;
        }
    }

    return dist2 ;
}

double
computeMeanFromMatrix (int dim, int ind, MatDoub data)
{
    double sum = 0 ;
    if (dim==1) // against column
    {
        for (int i=0;i<data.nrows ();i++)
        {
            sum += data[i][ind] ;
        }
        return sum / data.nrows () ;
    }
    else
    {
        for (int i=0;i<data.ncols ();i++)
        {
            sum += data[ind][i] ;
        }
        return sum / data.ncols () ;
    }
}

void
displayDouble (double val, string label)
{
    cout << label << " = " << val << endl ;
}

void
displayDoubleTriplet (double x, string xlab, double y, string ylab, double z, string zlab)
{
    cout << xlab << " = " << x << " __ " << ylab << " = " << y << " __ " << zlab << " = " << z << endl ;
}
