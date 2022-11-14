/**********************************************************************
Name: FSLSPTechInfoBatch
Copyright © 2020  Cummins
=======================================================================
=======================================================================
Purpose:    Fetching staging Object of FSL_SPTechnicians_Stage__c and convert into CSS_AccredUser__c object.
=======================================================================
=======================================================================
History                                                            
-------                                                            
VERSION  AUTHOR                 DATE                DETAIL                                 
1.0     Krishnamoorthi         03/25/2020           INITIAL DEVELOPMENT                    
***********************************************************************/
global class FSLSPTechInfoBatch implements Database.Batchable <sObject>, Database.allowscallouts{

    global Database.QueryLocator start(Database.BatchableContext BC){
        //string query = 'SELECT Id, Name, FirstName__c, LastName__c, PromotionId__c, SPCode__c, SPRowId__c, TechRowId__c, FailureReason__c FROM FSL_SPTechnicians_Stage__c WHERE FailureReason__c = null ORDER BY lastmodifieddate LIMIT 50';
        string query = 'SELECT Id, Name, FirstName__c, LastName__c, PromotionId__c, SPCode__c, SPRowId__c, TechRowId__c, FailureReason__c FROM FSL_SPTechnicians_Stage__c WHERE FailureReason__c = null ORDER BY lastmodifieddate';
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<FSL_SPTechnicians_Stage__c> Scope){   
        try {
            if(Scope != null && Scope.size() > 0) {
				System.debug('<----- inside CG_GetSPInfoScheduler ------>');
        		FSLSPInfo.getSPTechnicianData(Scope);
            }
        } catch(Exception e)  {
            system.debug('EXCEPTION of FSLSPTechInfoBatch execute >>> '+e.getMessage() + ' ' + e.getLineNumber() + ' ' +e.getCause());
            css_utility.LogOutIntError('FSLSPTechInfoBatch', e.getLineNumber() + ' ' + e.getLineNumber(), 'BATCH Execution failed', 'FSLSPTechInfoBatch');
        }
    } 

    global void finish(Database.BatchableContext BC){
        /*List<FSL_SPTechnicians_Stage__c> CSSCSC = [SELECT Id FROM FSL_SPTechnicians_Stage__c WHERE FailureReason__c = null];   //40
        if(CSSCSC != null && CSSCSC.size() > 0) {
            try {
                FSLSPTechInfoBatch SchdBatch = new FSLSPTechInfoBatch();
            	System.scheduleBatch (SchdBatch,'FSLSPTechInfoBatch01', 5 ); 
            } catch(exception e) {
                 system.debug('message and line number>>'+e.getMessage()+'and '+e.getLineNumber());
            }
        }*/
    }
}