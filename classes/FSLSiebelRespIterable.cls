/**********************************************************************
Name: FSL_siebelRespIterable
Copyright Â© 2019  Cummins
======================================================
======================================================
Purpose:                                                            
-------  
This process is used to populate the custom failure names, system code, component code and Fail mode from
 Siebel warranty system
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR                     DATE                                   
1.0     Ravikanth Macherla         5/03/2019                         
***********************************************************************/
global class FSLSiebelRespIterable implements iterable<CSS_SiebelFailCodeResponseJ2A>{
    global Iterator<CSS_SiebelFailCodeResponseJ2A> Iterator(){
        return new FSLsiebelIterator();
    }
}