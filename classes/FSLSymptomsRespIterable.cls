/**********************************************************************
Name: FSLSymptomsRespIterable
Copyright Â© 2019  Cummins
======================================================
======================================================
Purpose:                                                            
-------  
This is used for the Symptom ResponseIterable, where am calling my wrapper class.
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0 - Vinod Yelala      12/20/2018      INITIAL DEVELOPMENT                    
***********************************************************************/
global class FSLSymptomsRespIterable implements iterable<FSLSymptomRespWrapper>{
    global Iterator<FSLSymptomRespWrapper> Iterator(){
        return new FSLSymptomsRespIterator();
    }

}