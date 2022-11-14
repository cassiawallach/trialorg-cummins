global class FSL_NightlyComm_Active_MOVEXUK implements Database.Batchable<sObject>, Database.Stateful{

       global Database.QueryLocator start(Database.BatchableContext BC){        
        
          return Database.getQueryLocator([SELECT id,Active__c from FSL_Nightly_Communications__c where Active__c= true AND CreatedDate = YESTERDAY AND Contact__r.Account.FSL_Source_ERP__c='MOVEX-UK']); 
                                          
        }
   
       global void execute(Database.BatchableContext BC, List<FSL_Nightly_Communications__c> scope){
            for(FSL_Nightly_Communications__c con : scope) {                     
                con.Active__c= false;
            }
            try {
                
                update scope;
             
            } catch(Exception e) {
                System.debug(e);
            }
             
        
        }
        
        global void finish(Database.BatchableContext BC){
        
        }
 }