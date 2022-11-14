@isTest
private class CSS_delUnitTypeSubTypebatch_Test {

    static testmethod void testDelJobEventTempbatch() { 
         //The query used by the batch job.
        //Date dtToday = system.today()-1;
        String query = 'select id from CSS_JobEventTemporary__c where (Attribute1__c =\'SubType\' OR Attribute1__c = \'UnitType\') and ExpireDateTime__c < Last_N_Days:1';

       // Create some test Job Events to be deleted by the batch job.
       
       CSS_JobEventTemporary__c[] ml = new List<CSS_JobEventTemporary__c>();
       Date dtToday = system.today()-3;
       for (Integer i=0;i<10;i++) {
           CSS_JobEventTemporary__c m = new CSS_JobEventTemporary__c(
               Name ='JobEvent'+i,
               Attribute1__c ='SubType',
               ExpireDateTime__c=dtToday);
           ml.add(m);
       }
       insert ml;

       Test.startTest();
       CSS_delUnitTypeSubTypebatch jobEventTemp = new CSS_delUnitTypeSubTypebatch(query);
       Database.executeBatch(jobEventTemp);
       Test.stopTest();

       // Verify Job Events Temporary items got deleted 
       Integer i = [SELECT COUNT() FROM CSS_JobEventTemporary__c];
       System.assertEquals(i, 0);
    }
}