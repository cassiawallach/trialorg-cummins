/**********************************************************************
Name: CSS_GetApplicationListBatch
Copyright © 2017  Cummins
=======================================================================
=======================================================================
Purpose:    This is used for fetching Application list from SIEBEL
on a weekly basis
=======================================================================
=======================================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0     Surender M        04/10/2017     INITIAL DEVELOPMENT                    
***********************************************************************/
global class CSS_SBL_GetApplicationListBatch implements Database.Batchable<sObject>{
    
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        string query = 'SELECT id FROM CSS_DataExchange_Parent__c';
        return Database.getQueryLocator(query);
    }
 
    global void execute(Database.BatchableContext BC,List<CSS_DataExchange_Parent__c> scope){
        //Call FN class here
        CSS_FN_SIEBEL.storeApplicationOrCategoryComplaintList('GetApplicationList');
    }
 
   global void finish(Database.BatchableContext BC){}

}