#ifndef SIMPARAMS_H
#define SIMPARAMS_H

#include "libs/nr3.h"

struct SimParams
{
    SimParams ( int argc , char *argv[] ) ;

    Int params_argc ;
    char **params_argv ;

    vector <string> param_names ;
    vector <string> param_types ;
    vector <string> param_values ;

    char* get_param ( string param_name ) ;
    Doub get_double_param ( string param_name ) ;
    Int get_int_param ( string param_name ) ;
    string get_string_param ( string param_name ) ;

    void write_params () ;

    void display_params () ;
} ;

#endif // SIMPARAMS_H
