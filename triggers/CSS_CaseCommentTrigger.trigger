/**********************************************************************
Name:CSS_CaseCommentTrigger
Copyright Â© 2011  Cummins
======================================================
======================================================
Purpose:                                                            
-------                                                             
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0 -    Shanthi     22/05/2017      INITIAL DEVELOPMENT                    
***********************************************************************/
trigger CSS_CaseCommentTrigger on CaseComment (before Insert,before Update,After Insert) {
     if (trigger.isBefore && (trigger.isInsert || trigger.isUpdate)) {
           CSS_CaseCommentsTriggerHandler.caseErrorMessage(trigger.new);
       }
        if (trigger.isAfter && trigger.isInsert) {
           CSS_CaseCommentsTriggerHandler.updateCase(trigger.new);
       }
}