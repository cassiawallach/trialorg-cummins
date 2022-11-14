/**********************************************************************
Name: CSS_SBL_GetAccountCodesBatch
Copyright © 2017  Cummins
=======================================================================
=======================================================================
Purpose:    This class is for fetching Account codes from Siebel system
on a weekly basis
=======================================================================
=======================================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0      Rajkumar BT       05/09/2017     INITIAL DEVELOPMENT                    
***********************************************************************/
global class CSS_SBL_GetAccountCodesBatch implements Database.Batchable<sObject>,Database.allowscallouts{

    global Database.QueryLocator start(Database.BatchableContext BC){
        string query = 'SELECT id FROM CSS_DataExchange_Parent__c limit 1';
        return Database.getQueryLocator(query);
    }
 
    global void execute(Database.BatchableContext BC,List<CSS_DataExchange_Parent__c> scope){
        //Call FN class here
        CSS_FN_SIEBEL.getAccountCodes();
    }
 
   global void finish(Database.BatchableContext BC){}

}