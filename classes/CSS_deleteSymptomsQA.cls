global class CSS_deleteSymptomsQA implements Database.Batchable<sObject>{
    global final String Query;
    global CSS_deleteSymptomsQA(String q){
        Query=q;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }
 
    global void execute(Database.BatchableContext BC,List<CSS_SymptomQA__c> scope){
        delete scope;
    }
 
   global void finish(Database.BatchableContext BC){}

}