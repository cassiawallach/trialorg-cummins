global class CSS_delUnitTypeSubTypebatch implements Database.Batchable<sObject>{
    global final String Query;
    global CSS_delUnitTypeSubTypebatch(String q){
        if(q != null){
            Query=q;
        }
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }
 
    global void execute(Database.BatchableContext BC,List<CSS_JobEventTemporary__c> scope){
        delete scope;
    }
 
   global void finish(Database.BatchableContext BC){}
}