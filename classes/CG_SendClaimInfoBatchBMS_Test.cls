/*
 * Written by Venkat on 06/21/2017
 */
@isTest
public class CG_SendClaimInfoBatchBMS_Test
{
    static testMethod void CG_SendClaimInfoBatchBMS_method()
    {
        CSS_Claims__c claim = new CSS_Claims__c();
        claim.Contact_First_Name__c='tetstttt';
        insert claim;
        CSS_Claim_Submission__c claimsub = new CSS_Claim_Submission__c();
        claimsub.CSS_Claims__c = claim.id;
		claimsub.Status__c='Submitted';
		claimsub.Batch_Processed_Date__c=system.now()+4;
        insert claimsub;
        
        Test.startTest();
        CG_SendClaimInfoBatch_BMS obj = new CG_SendClaimInfoBatch_BMS();
        
        Database.executeBatch(obj);
        Test.stopTest();
    }
}