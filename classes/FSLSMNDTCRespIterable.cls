/**********************************************************************
Name: FSLSMNDTCRespIterable
Copyright Â© 2019  Cummins
======================================================
======================================================
Purpose:                                                            
-------  
This is used for the Response Iterator, were we setting all the records.
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0 - Vinod Yelala      12/20/2018      INITIAL DEVELOPMENT                    
***********************************************************************/
global class FSLSMNDTCRespIterable implements iterable<FSLSMNDTCRespWrapper>{
    global Iterator<FSLSMNDTCRespWrapper> Iterator(){
        return new FSLSMNDTCRespIterator();
    }
}