/**********************************************************************
Name: EVL_RestrictDelOnClSONoteTriggerHandle
======================================================
======================================================
Purpose:Built for CT1-93                                                         
Restriction Note from delete if service order is closed
======================================================a
======================================================a
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0 - Sai Pisupati      02/18/2021      INITIAL DEVELOPMENT
***********************************************************************/
public class EVL_RestrictDelOnClSONoteTriggerHandle {
    
    public static void restricNoteOnClosedSOBeforeDelete(list<Note> oldNote)
    {
        Schema.DescribeSObjectResult inv = WorkOrder.sObjectType.getDescribe();
        String invKeyPrefix = inv.getKeyPrefix();
        
        for(Note nt : oldNote){
          //  if(invKeyPrefix == String.valueOf(nt.ParentId).left(3) &&
            if([select EVL_Stage__c,status,Type__c from WorkOrder where id = :nt.ParentId].EVL_Stage__c =='Closed'
              && [select EVL_Stage__c,status,Type__c from WorkOrder where id = :nt.ParentId].Type__c =='Dealer'){
                   nt.adderror('Changes cannot be made after a job is closed.');
               }
            
        }
    }
}