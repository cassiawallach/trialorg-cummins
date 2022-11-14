/********************************************
HISTORY

VERSION  AUTHOR            DATE                DETAILS                                 
1.0 - Anirudh Reddy      02/07/2020      This class is used to populate no warranty flag in all 
                                         open jobs where this flag was not present before our implementation.
********************************************/

global class CG_populateNoWarrantyFlagClass implements Database.Batchable <sObject>{

    global Database.QueryLocator start(Database.BatchableContext BC){
        string query = 'SELECT Id, name, ESN__c from CSS_Job_Order__c where status__c NOT IN(\'Closed\',\'Canceled	\',\'Not Supported\') and warrantyIndicatorFlag__c = \'\' and ESN__c != null and ESN__c != \'\'';
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<CSS_Job_Order__c> Scope){   
        try {
            List<String> PSNsString = new List<String>();
            List<Asset> AssRecs = new List<Asset>();
            List<CSS_Job_Order__c> SJobLst = new List<CSS_Job_Order__c>();
            Map<String,Boolean> AssRecsMap = new Map<String,Boolean>();
              for(CSS_Job_Order__c JRec: Scope){                  
                  PSNsString.add(JRec.ESN__c); 
              } 
              AssRecs = [select id, name,No_Warranty__c from Asset where Name IN: PSNsString];
              
              if(AssRecs != null && AssRecs.size()>0){
                 for(Asset ARec:AssRecs){
                  AssRecsMap.put(ARec.Name,Arec.No_Warranty__c);
                } 
              }
              
              for(CSS_Job_Order__c JRec2: Scope){
                  CSS_Job_Order__c SJob = new CSS_Job_Order__c();
                  if(AssRecsMap != null){
                      if(AssRecsMap.containsKey(JRec2.ESN__c)){
                          SJob.Id = JRec2.Id;
                          SJob.warrantyIndicatorFlag__c = (AssRecsMap.get(JRec2.ESN__c) == true ? 'N' : 'Y');
                          SJobLst.add(SJob);
                      }else{
                          SJob.Id = JRec2.Id;
                          SJob.warrantyIndicatorFlag__c = 'N';
                          SJobLst.add(SJob);
                      }
                  }
              }
              update SJobLst;
        } catch(Exception e)  {
            system.debug('EXCEPTION of CG_populateNoWarrantyFlagClass execute >>> '+e.getMessage() + ' ' + e.getLineNumber() + ' ' +e.getCause());
              }
    } 

    global void finish(Database.BatchableContext BC){
     system.debug('Finished population of CG_populateNoWarrantyFlag');
    }

}