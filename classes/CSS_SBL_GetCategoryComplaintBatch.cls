/**********************************************************************
Name: CSS_SBL_GetCategoryComplaintBatch
Copyright © 2017  Cummins
=======================================================================
=======================================================================
Purpose:    This is used for fetching Category/Complaint list from SIEBEL
on a weekly basis
=======================================================================
=======================================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0     Surender M        04/11/2017     INITIAL DEVELOPMENT                    
***********************************************************************/
global class CSS_SBL_GetCategoryComplaintBatch implements Database.Batchable<sObject>{
    
    //global final String query;
    
    global CSS_SBL_GetCategoryComplaintBatch(){
        
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        string query = 'SELECT id FROM CSS_DataExchange_Parent__c';
        return Database.getQueryLocator(query);
    }
 
    global void execute(Database.BatchableContext BC, List<CSS_DataExchange_Parent__c> scope){
        //Call FN class here
        CSS_FN_SIEBEL.storeApplicationOrCategoryComplaintList('GetComplaintsList');
    }
 
   global void finish(Database.BatchableContext BC){}

}