@istest
public class EVL_PublisKnwArticleBatch_Test {
	public static testmethod void EVL_PublisKnwArticleBatch_TestMethod(){
        
      Knowledge__kav knwObj = new Knowledge__kav();
        knwObj.UrlName = 'S00001279';              			
        knwObj.Title = 'Test1';
        knwObj.Validations__c ='test';
        insert knwObj;
        List<Knowledge__kav> kav = new List<Knowledge__kav>();
        kav = [select id,KnowledgeArticleId  from Knowledge__kav where id =: knwObj.id];
        
        test.startTest();
            EVL_PublishKnwArticleBatch classRef = new EVL_PublishKnwArticleBatch();
            Database.QueryLocator ql = classRef.start(null);
            classRef.execute(null,kav);
            classRef.finish(null);
        test.stopTest();
    }
}