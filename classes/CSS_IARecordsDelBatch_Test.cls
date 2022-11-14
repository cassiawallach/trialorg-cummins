@isTest
private class CSS_IARecordsDelBatch_Test{

    static testmethod void testCSS_IARecordsDelBatch(){
      
 
     CSS_DataExchange_Parent__c DataXchange = NEW CSS_DataExchange_Parent__c();
       DataXchange.CSS_Job_Number__c = 'CSS-00066709';
       DataXchange.Customer_Company_Name__c = 'Test';
   
       insert (DataXchange);
       String  whereClause = ' Id = \'' + DataXchange.Id + '\' ';
       String query = 'SELECT Id,CSS_Job_Number__c FROM CSS_DataExchange_Parent__c WHERE' + whereClause;
 
       Test.startTest();
       CSS_IARecordsDelBatch data = new CSS_IARecordsDelBatch(query);
       Database.executeBatch(data); 
       Test.stopTest();

    }
}