/********************************************
HISTORY

VERSION  AUTHOR            DATE                DETAILS                                 
1.0 - Anirudh Reddy      02/07/2020      This class is used to Edit Knowledge Article as it has to be done in chunks.
********************************************/

global class EVL_PublishKnwArticleBatch implements Database.Batchable <sObject>{
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        string query = 'SELECT Id,IsVisibleInPrm,KnowledgeArticleId,UrlName,IsLatestVersion,PublishStatus FROM Knowledge__kav where UrlName LIKE \'S%\' and IsLatestVersion = true';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Knowledge__kav> Scope){   
        try {           
             for(Knowledge__kav knwRec:Scope){
                KbManagement.PublishingService.publishArticle(knwRec.KnowledgeArticleId, true);    //publish articlemapOldNewKnwIds
            }
        } catch(Exception e)  {
            system.debug('EXCEPTION of EVL_PublishKnwArticleBatch execute >>> '+e.getMessage() + ' ' + e.getLineNumber() + ' ' +e.getCause());
        }
    } 
    
    global void finish(Database.BatchableContext BC){
        system.debug('Finished population of EVL_PublishKnwArticleBatch');
    }
    
}