global class CSS_InsiteImagesDelBatch implements Database.Batchable<sObject>{
    global final String query;
    global CSS_InsiteImagesDelBatch(String q){
        if(q != null){
        	query=q;
        }
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }
 
    global void execute(Database.BatchableContext BC,List<Attachment> scope){
        delete scope;
    }
 
   global void finish(Database.BatchableContext BC){}

}