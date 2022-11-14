@isTest
public class dbu_UpdateExternalIdBatch_Test {
     @isTest public static void updateexternalid(){
         List<dbu_partsresponse__c> partsToUpdate = new List<dbu_partsresponse__c>(); 
         
         for(integer i=0;i<200;i++)
         {
         dbu_partsresponse__c partsvar=new dbu_partsresponse__c();
         partsvar.Name='Test'+i;
         partsvar.dbu_ESNNumber__c='12345'+i;
         partsvar.Number_Z__c='54321'+i;
          partsToUpdate.add(partsvar) ;  
         }
         insert partsToUpdate;
         
         Test.startTest();
         dbu_UpdateExternalIdBatch batchjob=new  dbu_UpdateExternalIdBatch();
         Database.executeBatch(batchjob);
         
         dbu_DeletionBatch batchjob1=new dbu_DeletionBatch();
         Database.executeBatch(batchjob1);
         Test.stopTest();
         

}
}