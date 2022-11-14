/**********************************************************************
Name: FSLsiebelIterator
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

public class FSLsiebelIterator implements Iterator<CSS_SiebelFailCodeResponseJ2A> {
    Integer i;
    public List<CSS_SiebelFailCodeResponseJ2A> fssCdsRecs{get;set;}
    public FSLsiebelIterator()
    {
        FSL_siebelService fsCds = new FSL_siebelService();
        fssCdsRecs = new List<CSS_SiebelFailCodeResponseJ2A>();
        fssCdsRecs=FSL_siebelService.storeApplicationOrCategoryComplaintList();
        i=0;
    }
    public boolean hasNext() {
        if(fssCdsRecs != null)
            return i < fssCdsRecs.size();
        else return false;
    }
    public CSS_SiebelFailCodeResponseJ2A next() {
        if(i <= fssCdsRecs.size())
        {
            system.debug('before return i value:::'+i);
            return fssCdsRecs[i++];//new Account(Name='Test '+Counter--);
        }        
        else return null;
    }
}