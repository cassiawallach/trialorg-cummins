/**********************************************************************
Name: FSLFaultCodeIterator
Copyright Â© 2019  Cummins
======================================================
======================================================
Purpose:                                                            
-------  
This class is to get the values based on FSLFaultCodeWrapper
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR                     DATE                                   
1.0     Ravikanth Macherla         2/19/2019                         
***********************************************************************/
global class FSLFaultCodeIterator implements Iterator<FSLFaultCodeWrapper> {
    Integer i;
    global List<FSLFaultCodeWrapper> fssCdsRecs{get;set;}
    global FSLFaultCodeIterator()
    {
        FSLFaultCodeService fsCds = new FSLFaultCodeService();
        fssCdsRecs = new List<FSLFaultCodeWrapper>();
        fssCdsRecs = fsCds.getFaultCodes();
        i = 0;
    }
    
    global boolean hasNext() {
        if(fssCdsRecs != null)
            return i < fssCdsRecs.size();
        else return false;
    }
    
    global FSLFaultCodeWrapper next() {
        if(i <= fssCdsRecs.size())
        {
            return fssCdsRecs[i++];
        }        
        else return null;
    }
}