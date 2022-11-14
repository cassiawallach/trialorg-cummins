/************************************************************************************************************************************
HISTROY

VERSION  AUTHOR                      DATE                DETAILS                                 
1.0 - Anvesh Reddy Sama          03/30/2020fetching staging Object of FSL_SPHeader_Stage__c and convert into Account object.
************************************************************************************************************************************/
global class FSL_SPCertificationInfoBatch implements Database.Batchable <sObject>, Database.allowscallouts{

    global Database.QueryLocator start(Database.BatchableContext BC){
        string query = 'select id, EndDate__c,OEM_Name__c,OEMCode__c,ServiceLevel__c,SMN__c,SPCertRowId__c,SPCode__c,SPRowId__c,StartDate__c FROM FSL_SPCertifications_Stage__c ORDER BY lastmodifieddate';
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<FSL_SPCertifications_Stage__c> Scope){   
        try {
            if(Scope != null && Scope.size() > 0) {
System.debug('<----- inside CG_GetSPHeaderInfoBatchExecute ------>');
        FSLSPInfo.getSPCertificationData(Scope);
            }
        } catch(Exception e)  {
            system.debug('EXCEPTION of FSL_SPHeaderInfoBatch execute >>> '+e.getMessage() + ' ' + e.getLineNumber() + ' ' +e.getCause());
            css_utility.LogOutIntError('FSL_SPCertificationInfoBatch', e.getLineNumber() + ' ' + e.getLineNumber(), 'BATCH Execution failed', 'FSL_SPCertificationInfoBatch');
        }
    } 

    global void finish(Database.BatchableContext BC){
        /*List<FSL_SPCertifications_Stage__c> SPHData = [SELECT Id FROM FSL_SPCertifications_Stage__c WHERE FailureReason__c = null];   //40
        if(SPHData != null && SPHData.size() > 0) {
            try {
                FSL_SPCertificationInfoBatch SchdBatch = new FSL_SPCertificationInfoBatch();
            System.scheduleBatch (SchdBatch,'FSL_SPCertificationInfoBatch1', 5 ); 
            } catch(exception e) {
                 system.debug('message and line number>>'+e.getMessage()+'and '+e.getLineNumber());
            }
        }*/
    }

}