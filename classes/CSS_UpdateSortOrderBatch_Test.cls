/*
 * Description : Test class for  CSS_UpdateSortOrderBatch Class
 * Author      : Prabhakar Ragula
 */

@isTest
public class CSS_UpdateSortOrderBatch_Test {

    static testmethod void testUpdateSortOrderBatch() { 
       String query = 'Select id from CSS_Job_Order__c';
       CSS_Job_Order__c jobOrder =  CSS_TestData.createJobOrder(true);
       CSS_Solutions__c sol = CSS_TestData.createSolutions(true,jobOrder.id);
       // CSS_SRT__c SRT = CSS_TestData.createSRT(true,'Diagnosis',sol.id,jobOrder.id);
        CSS_SRT__c srt1 = new CSS_SRT__c();
        srt1.Job_Order__c = jobOrder.id;
        srt1.Solution_Number__c = null;
        srt1.Type__c = 'Diag Access';
        srt1.SRT_Order__c = 3;
        insert srt1;
        
       Test.startTest();
       CSS_UpdateSortOrderBatch updateSortOrder = new CSS_UpdateSortOrderBatch(query);
       Database.executeBatch(updateSortOrder);
       Test.stopTest();
    }
    static testmethod void testupdatesortorderbatch2(){
         String query = 'Select id from CSS_Job_Order__c';
         CSS_Job_Order__c jobOrder =  CSS_TestData.createJobOrder(true);
         CSS_Solutions__c sol = CSS_TestData.createSolutions(true,jobOrder.id);
         CSS_SRT__c SRT = CSS_TestData.createSRT(true,'Diagnosis',sol.id,jobOrder.id);
         Test.startTest();
         CSS_UpdateSortOrderBatch updateSortOrder = new CSS_UpdateSortOrderBatch(query);
         Database.executeBatch(updateSortOrder);
         Test.stopTest();
        
    }
}