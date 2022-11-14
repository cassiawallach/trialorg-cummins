@isTest
private class CSS_SBL_GetCategoryComplaintBatch_Test {

    static testmethod void testDeleteCSSSolutions() { 
         //The query used by the batch job.
        //Date dtToday = system.today()-1;
        String query;

       // Create some test Data Exchange to be deleted by the batch job.
       
       CSS_DataExchange_Parent__c[] ml = new List<CSS_DataExchange_Parent__c>();
       for (Integer i=0;i<10;i++) {
           CSS_DataExchange_Parent__c m = new CSS_DataExchange_Parent__c(
               City__c ='DEAdmin' + i);
           ml.add(m);
       }
       insert ml;

       Test.startTest();
       CSS_SBL_GetCategoryComplaintBatch deAdmin = new CSS_SBL_GetCategoryComplaintBatch();
       Database.executeBatch(deAdmin);
       Test.stopTest();

    }
}