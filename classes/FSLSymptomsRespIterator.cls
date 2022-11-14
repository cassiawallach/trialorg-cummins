/**********************************************************************
Name: FSLSymptomsRespIterator
Copyright Â© 2019  Cummins
======================================================
======================================================
Purpose:                                                            
-------  
This is used for the Symptom Response Iterator for the symptoms Batch.
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0 - Vinod Yelala      12/20/2018      INITIAL DEVELOPMENT                    
***********************************************************************/
global  class FSLSymptomsRespIterator implements Iterator<FSLSymptomRespWrapper> {
    Integer i;
    List<FSLSymptomRespWrapper> fssCdsRecs{get;set;}
    global FSLSymptomsRespIterator()
    {
        FSLSymptomsCDSService fsCds = new FSLSymptomsCDSService();
        fssCdsRecs = new List<FSLSymptomRespWrapper>();
        fssCdsRecs = fsCds.getSymptoms();
        i = 0;
    }
    global boolean hasNext() {
        if(fssCdsRecs != null)
            return i < fssCdsRecs.size();
        else return false;
    }
    
    global FSLSymptomRespWrapper next() {
        if(i <= fssCdsRecs.size())
        {
            system.debug('before return i value:::'+i);
            return fssCdsRecs[i++];
        }        
        else return null;
    }
}