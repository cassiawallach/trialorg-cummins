/********************************************
HISTROY

VERSION  AUTHOR            			DATE               				 DETAILS                                 
1.0 -   Anvesh Reddy Sama 		 04/04/2020			fetching staging Object of FSL_SPTechCert_Stage__c and convert into CSS_AccredUser__c object.
********************************************/
global class FSL_SPTechCertificationBatch implements Database.Batchable <sObject>, Database.allowscallouts{

    global Database.QueryLocator start(Database.BatchableContext BC){
        //Updating Query based on Story #190067.
        string query = 'SELECT Id, SPCode__c, SPRowId__c,SMNRowId__c, TechRowId__c, Certification__c,ServiceModelName__c FROM FSL_SPTechCert_Stage__c  ORDER BY lastmodifieddate';
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<FSL_SPTechCert_Stage__c> Scope){   
        try {
            if(Scope != null && Scope.size() > 0) {
				System.debug('<----- inside FSL_SPTechCertificationBatch ------>');
        		FSLSPInfo.getSPTechCertificationData(Scope);
            }
        } catch(Exception e)  {
            system.debug('EXCEPTION of FSL_SPTechCertificationBatch execute >>> '+e.getMessage() + ' ' + e.getLineNumber() + ' ' +e.getCause());
            css_utility.LogOutIntError('FSL_SPTechCertificationBatch', e.getLineNumber() + ' ' + e.getLineNumber(), 'BATCH Execution failed', 'FSL_SPTechCertificationBatch');
        }
    } 

    global void finish(Database.BatchableContext BC){
        //Removing unwanted Query fields. Story : #190067.
     /*   List<FSL_SPTechCert_Stage__c> SPTechCert = [SELECT Id FROM FSL_SPTechCert_Stage__c];
        if(SPTechCert != null && SPTechCert.size() > 0) {
            try {
                FSL_SPTechCertificationBatch SchdBatch = new FSL_SPTechCertificationBatch();
            	System.scheduleBatch (SchdBatch,'FSL_SPTechCertificationBatch1', 5 ); 
            } catch(exception e) {
                 system.debug('message and line number>>'+e.getMessage()+'and '+e.getLineNumber());
            }
        }*/
    }

}