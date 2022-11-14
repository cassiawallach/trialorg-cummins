global class CSS_deleteCSSSolutions implements Database.Batchable<sObject>{
    global final String Query;
    global CSS_deleteCSSSolutions(String q){
        Query=q;
        
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        
        return Database.getQueryLocator(Query);
    }
 
    global void execute(Database.BatchableContext BC,List<CSS_Solutions__c> scope){
        delete scope;
    }
 
   global void finish(Database.BatchableContext BC){}

}