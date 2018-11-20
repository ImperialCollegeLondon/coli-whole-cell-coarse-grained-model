#include "simparams.h"


SimParams::SimParams (int argc, char *argv[])
{
    params_argc = argc ;
    params_argv = argv ;
}

string SimParams::get_string_param (string param_name)
{
    if ( ! ( std::find ( param_names.begin(), param_names.end(), param_name ) != param_names.end() ) )
    {
        param_names.push_back ( param_name ) ;
        param_types.push_back ( "string" ) ;
        param_values.push_back ( ( get_param ( param_name ) ) ) ;
    }
    return ( get_param ( param_name ) ) ;
}

Doub SimParams::get_double_param (string param_name)
{
    if ( ! ( std::find ( param_names.begin(), param_names.end(), param_name ) != param_names.end() ) )
    {
        param_names.push_back ( param_name ) ;
        param_types.push_back ( "double" ) ;
        param_values.push_back ( ( get_param ( param_name ) ) ) ;
    }
    return atof ( get_param ( param_name ) ) ;
}

Int SimParams::get_int_param (string param_name)
{
    if ( ! ( std::find ( param_names.begin(), param_names.end(), param_name ) != param_names.end() ) )
    {
        param_names.push_back ( param_name ) ;
        param_types.push_back ( "string" ) ;
        param_values.push_back ( ( get_param ( param_name ) ) ) ;
    }
    return atoi ( get_param ( param_name ) ) ;
}

void SimParams::display_params ()
{
    cout << endl ;
    for ( unsigned int p=0 ; p<param_names.size() ; p++ )
    {
        cout << param_names[p] << " (" << param_types[p] << ") = " << param_values[p] << endl ;
    }
    cout << endl ;
}

char* SimParams::get_param ( string par_name )
{
    char* param = 0 ;
    for ( int i = 1 ; i < params_argc-1 ; i++ )
    {
        ostringstream par_name_os ;
        par_name_os << "-" << par_name ;
        if ( strncmp ( params_argv[i] , par_name_os.str ().c_str () , par_name.size () + 1) == 0 )
        {
            param = params_argv[i+1] ;
            return param ;
        }
    }
    cout << "param " << par_name << " not found in program call ?" << endl ; exit (10) ;
}

void SimParams::write_params ()
{
    ostringstream out_params_file ;
    out_params_file << get_string_param ("out_folder") << "/params.txt" ;
    ofstream out_params ;
    out_params.open ( out_params_file.str () ) ;
    if ( ! out_params.is_open() ) { cout << "not open" << endl ; exit(20) ; }
    for ( unsigned int p=0 ; p<param_names.size() ; p++ )
    {
        out_params << param_names[p] << "\t" << param_values[p] << endl ;
    }
    out_params.close () ;
}
