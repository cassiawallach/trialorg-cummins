/**********************************************************************
Name: FSLSMNDTCRespIterator
Copyright Â© 2019  Cummins
======================================================
======================================================
Purpose:                                                            
-------  
This is used for the Response Iterator for the SMNDTC Service.
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0 - Vinod Yelala      12/20/2018      INITIAL DEVELOPMENT                    
***********************************************************************/
global  class FSLSMNDTCRespIterator implements Iterator<FSLSMNDTCRespWrapper> {
    Integer i;
    List<FSLSMNDTCRespWrapper> fssCdsRecs{get;set;}
    global FSLSMNDTCRespIterator ()
    {
        FSLSMNDTCCDSService fsCds = new FSLSMNDTCCDSService();
        fssCdsRecs = new List<FSLSMNDTCRespWrapper>();
        fssCdsRecs = fsCds.getSMNDTC();
        i = 0;
    }
    global boolean hasNext() {
        if(fssCdsRecs != null)
            return i < fssCdsRecs.size();
        else return false;
    }
    
    global FSLSMNDTCRespWrapper next() {
        if(i <= fssCdsRecs.size())
        {
            system.debug('before return i value:::'+i);
            return fssCdsRecs[i++];
        }        
        else return null;
    }
}