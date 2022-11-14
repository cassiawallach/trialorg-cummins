/**********************************************************************
Name: FSLSPProductRangeBatch
Copyright © 2020  Cummins
=======================================================================
=======================================================================
Purpose:    Fetching staging Object of FSL_SPCertDetails_Stage__c and convert into CSS_Accreditation__c object.
=======================================================================
=======================================================================
History                                                            
-------                                                            
VERSION  AUTHOR                 DATE                DETAIL                                 
1.0     Krishnamoorthi         03/25/2020           INITIAL DEVELOPMENT                    
***********************************************************************/
global class FSLSPProductRangeBatch implements Database.Batchable <sObject>, Database.allowscallouts{

    global Database.QueryLocator start(Database.BatchableContext BC){
        //string query = 'SELECT Id, Name, FailureReason__c, MarketApplication__c, ProductRange__c, ProductType__c, SPCertDetailRowId__c, SPCertRowId__c, SPCode__c, SPRowId__c FROM FSL_SPCertDetails_Stage__c WHERE FailureReason__c = null ORDER BY lastmodifieddate LIMIT 50';
        string query = 'SELECT Id, Name, FailureReason__c, MarketApplication__c, ProductRange__c, ProductType__c, SPCertDetailRowId__c, SPCertRowId__c, SPCode__c, SPRowId__c FROM FSL_SPCertDetails_Stage__c WHERE FailureReason__c = null ORDER BY lastmodifieddate';
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<FSL_SPCertDetails_Stage__c> Scope){   
        try {
            if(Scope != null && Scope.size() > 0) {
				FSLSPInfo.getSPProductRangeData(Scope);
            }
        } catch(Exception e)  {
            system.debug('EXCEPTION of FSLSPProductRangeBatch execute >>> '+e.getMessage() + ' ' + e.getLineNumber() + ' ' +e.getCause());
            css_utility.LogOutIntError('FSLSPProductRangeBatch', e.getLineNumber() + ' ' + e.getLineNumber(), 'BATCH Execution failed', 'FSLSPProductRangeBatch');
        }
    } 

    global void finish(Database.BatchableContext BC){
        /*List<FSL_SPCertDetails_Stage__c> CSSCSC = [SELECT Id FROM FSL_SPCertDetails_Stage__c WHERE FailureReason__c = null];   //40
        if(CSSCSC != null && CSSCSC.size() > 0) {
            try {
                FSLSPProductRangeBatch SchdBatch = new FSLSPProductRangeBatch();
            	System.scheduleBatch (SchdBatch,'FSLSPProductRangeBatch01', 5 ); 
            } catch(exception e) {
                 system.debug('message and line number>>'+e.getMessage()+'and '+e.getLineNumber());
            }
        }*/
    }
}