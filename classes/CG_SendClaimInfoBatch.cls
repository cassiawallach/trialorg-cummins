/**********************************************************************
Name: CG_SendClaimInfoBatch
Copyright © 2018  Cummins
=======================================================================
=======================================================================
Purpose:    This class is for fetching all the submitted claims and send it to Seibel’s Submit Claim for adjudication and payment.
=======================================================================
=======================================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0     Shanthi      29/05/2018     INITIAL DEVELOPMENT                    
***********************************************************************/
global class CG_SendClaimInfoBatch implements Database.Batchable <sObject>, Database.allowscallouts{

    global Database.QueryLocator start(Database.BatchableContext BC){
        String status = 'Submitted';
        Datetime BatchRuntime =system.now();
        string query = 'SELECT id,CSS_Claims__c,CSS_Claims__r.name,CSS_Claims__r.Information_Only_Claim__c, Siebel_Claim_JSON__c,Individual_Claim_Id__c, BMS_Claim_ReqJSON__c,Account_Code__c FROM CSS_Claim_Submission__c WHERE Status__c =:status and Batch_Picked_Date__c <: BatchRuntime and Account_Code__c != \'\' limit 5';
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<CSS_Claim_Submission__c> scope){
        //call siebel
        system.debug('call siebel'+scope);
        CSS_FN_SIEBEL.submitClaims(scope);
        system.debug('call siebel');

    }

    global void finish(Database.BatchableContext BC){

        /*List<CronJobDetail> detailId = [SELECT Id FROM CronJobDetail WHERE Name='submissionBatchSchedule' limit 1];
        system.debug('apexJob'+detailId);
        if (detailId!=null && detailId.size()>0) {
            Id jobId = [SELECT Id from CronTrigger WHERE CronJobDetailId = :detailId][0].Id;
            System.abortJob(jobId);
        }
        
        try{
            
        CG_SendClaimInfoBatch  SchdBatch = new CG_SendClaimInfoBatch();
        System.scheduleBatch (SchdBatch,'submissionBatchSchedule', 10 ); 
        }
        catch(exception e)
        {
             system.debug('message and line number>>'+e.getMessage()+'and '+e.getLineNumber());
        }
        */
        
        String status = 'Submitted';
        Datetime BatchRuntime =system.now();
        List<CSS_Claim_Submission__c> CSSCSC = [SELECT id,CSS_Claims__r.name,CSS_Claims__r.Information_Only_Claim__c, Siebel_Claim_JSON__c,Individual_Claim_Id__c, BMS_Claim_ReqJSON__c,Account_Code__c FROM CSS_Claim_Submission__c WHERE Status__c =:status and Batch_Picked_Date__c <: BatchRuntime and Account_Code__c != ''];   //40
        system.debug('CSSCSC'+CSSCSC);
        if(CSSCSC != null && CSSCSC.size() > 0) {
            try {
                //CG_SendClaimInfo_Schedule schSendClaim = new CG_SendClaimInfo_Schedule();
                //System.schedule('submissionBatchSchedule_Additional ' + String.valueOf(Datetime.now()), nextFireTime, s);
                CG_SendClaimInfoBatch  SchdBatch = new CG_SendClaimInfoBatch();
                System.scheduleBatch(SchdBatch,'submissionBatchSchedule_Additional', 1); 
            } catch(exception e) {
                 system.debug('message and line number>>'+e.getMessage()+'and '+e.getLineNumber());
            }
        }
        

    }

}