/**********************************************************************
Name: FSLSPAffilationsInfoBatch
Copyright © 2020  Cummins
=======================================================================
=======================================================================
Purpose:    Fetching staging Object of FSL_SPAffilations_Stage__c and convert into CSS_OEM_AFFILIATIONS__c object.
=======================================================================
=======================================================================
History                                                            
-------                                                            
VERSION  AUTHOR                 DATE                DETAIL                                 
1.0     Krishnamoorthi         03/25/2020           INITIAL DEVELOPMENT                    
***********************************************************************/
global class FSLSPAffilationsInfoBatch implements Database.Batchable <sObject>, Database.allowscallouts{

    global Database.QueryLocator start(Database.BatchableContext BC){
        //string query = 'SELECT Id, Name, Affiliation__c, AffiliationRowId__c, LastUpdated_By__c, LastUpdatedDate__c, Primary__c, SPCode__c, SPRowId__c FROM FSL_SPAffilations_Stage__c ORDER BY lastmodifieddate LIMIT 50';
        string query = 'SELECT Id, Name, Affiliation__c, AffiliationRowId__c, LastUpdated_By__c, LastUpdatedDate__c, Primary__c, SPCode__c, SPRowId__c FROM FSL_SPAffilations_Stage__c ORDER BY lastmodifieddate';
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<FSL_SPAffilations_Stage__c> Scope){   
        try {
            if(Scope != null && Scope.size() > 0) {
				FSLSPInfo.getSPAffilationsData(Scope);
            }
        } catch(Exception e)  {
            system.debug('EXCEPTION of FSLSPTechInfoBatch execute >>> '+e.getMessage() + ' ' + e.getLineNumber() + ' ' +e.getCause());
            css_utility.LogOutIntError('FSLSPTechInfoBatch', e.getLineNumber() + ' ' + e.getLineNumber(), 'BATCH Execution failed', 'FSLSPTechInfoBatch');
        }
    } 

    global void finish(Database.BatchableContext BC){
        /*List<FSL_SPAffilations_Stage__c> CSSCSC = [SELECT Id FROM FSL_SPAffilations_Stage__c];   //40
        if(CSSCSC != null && CSSCSC.size() > 0) {
            try {
                FSLSPAffilationsInfoBatch SchdBatch = new FSLSPAffilationsInfoBatch();
            	System.scheduleBatch (SchdBatch,'FSLSPAffilationsInfoBatch01', 5 ); 
            } catch(exception e) {
                 system.debug('message and line number>>'+e.getMessage()+'and '+e.getLineNumber());
            }
        }*/
    }
}