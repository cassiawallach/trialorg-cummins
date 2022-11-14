/********************************************
HISTORY

VERSION  AUTHOR            DATE                DETAILS                                 
1.0 - Anirudh Reddy      02/07/2020      This class is used to Edit Knowledge Article as it has to be done in chunks.
********************************************/

global class EVL_EditKnwArticleBatch implements Database.Batchable <sObject>{
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        string query = 'SELECT Id,IsVisibleInPrm,KnowledgeArticleId,UrlName,IsLatestVersion,PublishStatus FROM Knowledge__kav where UrlName LIKE \'S%\' and IsLatestVersion = true';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Knowledge__kav> Scope){   
        try {
            for(Knowledge__kav knwRec:Scope){
               if(!Test.isRunningTest()){
                if(knwRec.PublishStatus != 'Draft')
                    KbManagement.PublishingService.editOnlineArticle(knwRec.KnowledgeArticleId, true);
                }
            }
            
            List<Knowledge__kav> updknwLst = new list<Knowledge__kav>();    
            
            for(Knowledge__kav knwRec:Scope){
                Knowledge__kav krec = new Knowledge__kav();
                krec.Id = knwRec.Id;
                krec.IsVisibleInPrm = true;
                updknwLst.add(krec);
            }
            system.debug('updknwLst>>>>>'+updknwLst);
            update updknwLst;
            
             
        } catch(Exception e)  {
            system.debug('EXCEPTION of EVL_EditKnwArticleBatch execute >>> '+e.getMessage() + ' ' + e.getLineNumber() + ' ' +e.getCause());
        }
    } 
    
    global void finish(Database.BatchableContext BC){
        system.debug('Finished population of EVL_EditKnwArticleBatch');
    }
    
}