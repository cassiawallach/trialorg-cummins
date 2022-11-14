@isTest
public class CG_CL_DeleteClaimRecordBatch_Test {
     static testMethod void CG_CL_DeleteClaimRecordBatchMethod(){
        //List<CSS_Claims__c> clmLst = new List<CSS_Claims__c>();
        
        CSS_Claims__c claim = new CSS_Claims__c();
        claim.Status__c = 'Draft';
        claim.CreatedDate = system.today()-130;
        claim.LastModifiedDate = system.today()-120;
        claim.LastSavedDate__c = system.today()-120;
        claim.SiebelClaimNumber__c = null;
        insert claim;
        
        CSS_Claims__c claim1 = new CSS_Claims__c();
        claim1.Status__c = 'Draft';
        claim1.CreatedDate = system.today()-130;
        claim1.LastModifiedDate = system.today()-120;
        claim1.LastSavedDate__c = system.today()-120;
        claim1.SiebelClaimNumber__c = null;
        insert claim1;

        //clmLst.add(claim);
        //clmLst.add(claim1);
         
        //Test.startTest();
        CG_CL_DeleteClaimRecordBatch obj = new CG_CL_DeleteClaimRecordBatch();
        database.executeBatch(obj);
        //Test.stopTest();
    }
}