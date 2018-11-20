#ifndef MODELFUNCTIONS_HPP
#define MODELFUNCTIONS_HPP


Doub do_normal_partitioning_single ( Doub level , Doub proba , StochSimulator* stoch_simulator )
{
    Doub new_level = 0. ;
    for (Int m=0;m<level;m++)
    {
        if ( stoch_simulator->ran.doub () < proba ) new_level ++ ;
    }
    return new_level ;
}

void do_normal_partitioning ( Doub proba , CellState* cell , StochSimulator* stoch_simulator )
{
    cell->set_mRNA_Level ( do_normal_partitioning_single ( cell->get_mRNA_Level() , proba , stoch_simulator ) ) ;
    cell->set_prot_Level ( do_normal_partitioning_single ( cell->get_prot_Level() , proba , stoch_simulator ) ) ;
}

Doub do_equal_partitioning_single ( Doub before_level , Doub proba , StochSimulator* stoch_simulator )
{
    Doub after_level = (Doub) ( (Int) ( before_level * proba ) ) ;
    if ( after_level - before_level * proba != 0. )
    {
        if ( stoch_simulator->ran.doub() < proba ) after_level += 1.0 ;
    }
    //    cout << "before level = " << before_level << " , after level = " << after_level << endl ;
    return after_level ;
}

void do_equal_partitioning ( Doub proba , CellState* cell , StochSimulator* stoch_simulator )
{
    cell->set_mRNA_Level ( do_equal_partitioning_single ( cell->get_mRNA_Level() , proba , stoch_simulator ) ) ;
    cell->set_prot_Level ( do_equal_partitioning_single ( cell->get_prot_Level() , proba , stoch_simulator ) ) ;
}

void do_partitioning ( string partitioning_type , Doub proba , CellState* cell , StochSimulator* stoch_simulator )
{
//    cout << "proba = " << proba << endl;
    if ( partitioning_type == "normal" )
    {
        do_normal_partitioning (proba,cell,stoch_simulator) ;
    }
    else if ( partitioning_type == "equal" )
    {
        do_equal_partitioning (proba,cell,stoch_simulator) ;
    }
}

#endif // MODELFUNCTIONS_HPP

