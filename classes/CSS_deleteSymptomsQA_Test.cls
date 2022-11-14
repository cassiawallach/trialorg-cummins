@isTest
private class CSS_deleteSymptomsQA_Test {

    static testmethod void testDeleteSymptomsQA() { 
         //The query used by the batch job.
        //Date dtToday = system.today()-1;
        String query = 'select id from CSS_SymptomQA__c where CreatedDate <= Last_N_Days:1 and Name != null';

       // Create some test Solutions to be deleted by the batch job.
       
       CSS_SymptomQA__c[] ml = new List<CSS_SymptomQA__c>();
       for (Integer i=0;i<10;i++) {
           CSS_SymptomQA__c m = new CSS_SymptomQA__c(
               Name ='SymptomsQA' + i,
               Answers__c = 'Case' + i);
           ml.add(m);
       }
       insert ml;

       Test.startTest();
       CSS_deleteSymptomsQA SymptomsQA = new CSS_deleteSymptomsQA(query);
       Database.executeBatch(SymptomsQA);
       Test.stopTest();

       // Verify Solutions items got deleted 
       Integer i = [SELECT COUNT() FROM CSS_SymptomQA__c];
       System.assertEquals(i, 0);
    }
}