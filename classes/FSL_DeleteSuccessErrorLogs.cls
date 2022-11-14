/**********************************************************************
Name:FSL_DeleteSuccessErrorLogs 
Copyright Â© 2019  Cummins
======================================================
======================================================
Purpose: 
--------
This batch class is used to delete success records from
FSL integration error object
======================================================
======================================================
History
-------
VERSION  AUTHOR                     DATE
1.0     Ravikanth Macherla         02/27/2020
***********************************************************************/    
global class FSL_DeleteSuccessErrorLogs implements Database.Batchable<sObject>{

    global Database.querylocator start(Database.BatchableContext BC)
    {
        String Status = 'Success';
        string query  = 'Select Id from FSL_Integration_Error_Log__c where  Status__c =:Status';
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<FSL_Integration_Error_Log__c> scope){
       system.debug('check before'+scope);
        delete scope;
    }

    global void finish(Database.BatchableContext BC){
    }
}