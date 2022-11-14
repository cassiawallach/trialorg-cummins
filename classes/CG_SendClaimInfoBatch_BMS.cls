/**********************************************************************
Name: CG_SendClaimInfoBatch_BMS
Copyright © 2018  Cummins
=======================================================================
=======================================================================
Purpose:    This class is for fetching all the submitted claims and send it to bms.
=======================================================================
=======================================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0     Rajkumar BT      06/13/2018     INITIAL DEVELOPMENT                    
***********************************************************************/
global class CG_SendClaimInfoBatch_BMS implements Database.Batchable <sObject>, Database.allowscallouts{

    global Database.QueryLocator start(Database.BatchableContext BC){
        String status = 'In Review';
        String erpStatus = 'Error';
        //Datetime BatchRuntime =system.now();
        string query = 'SELECT id,CSS_Claims__r.name,BMS_Claim_ReqJSON__c FROM CSS_Claim_Submission__c WHERE Status__c =:status and (ERP_Status__c =: erpStatus or ERP_Status__c = \'\') limit 40';
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<CSS_Claim_Submission__c> scope){
        //call bms
        system.debug('call BMS'+scope);
        CSS_WS_BMS.claimsInbound(scope);
        system.debug('call BMS');
    }

    global void finish(Database.BatchableContext BC){
        /*List<CronJobDetail> detailId = [SELECT Id FROM CronJobDetail WHERE Name='submissionBatchSchedule' limit 1];
        system.debug('apexJob'+detailId);
        if (detailId!=null && detailId.size()>0) {
            Id jobId = [SELECT Id from CronTrigger WHERE CronJobDetailId = :detailId][0].Id;
            System.abortJob(jobId);
        }*/
        try{
        CG_SendClaimInfoBatch_BMS  SchdBatch = new CG_SendClaimInfoBatch_BMS();
        System.scheduleBatch (SchdBatch,'submissionBatchScheduleBMS', 5 ); 
        }
        catch(exception e)
        {
             system.debug('message and line number>>'+e.getMessage()+'and '+e.getLineNumber());
        }

    }

}