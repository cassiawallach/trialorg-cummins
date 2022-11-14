@isTest
private class CSS_deleteCSSSolutions_Test {

    static testmethod void testDeleteCSSSolutions() { 
         //The query used by the batch job.
        //Date dtToday = system.today()-1;
        String query = 'select id from CSS_Solutions__c where CreatedDate <= Last_N_Days:1 and Name != null';

       // Create some test Solutions to be deleted by the batch job.
       
       CSS_Solutions__c[] ml = new List<CSS_Solutions__c>();
       for (Integer i=0;i<10;i++) {
           CSS_Solutions__c m = new CSS_Solutions__c(
               Name ='CSSSolution' + i,
               Case_Name__c = 'Case' + i);
           ml.add(m);
       }
       insert ml;

       Test.startTest();
       CSS_deleteCSSSolutions Solutions = new CSS_deleteCSSSolutions(query);
       Database.executeBatch(Solutions);
       Test.stopTest();

       // Verify Solutions items got deleted 
       Integer i = [SELECT COUNT() FROM CSS_Solutions__c];
       System.assertEquals(i, 0);
    }
}