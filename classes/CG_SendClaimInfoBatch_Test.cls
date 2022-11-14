/*
 * Written by Siva Ganesh on 07/25/2019
 */
@isTest
public class CG_SendClaimInfoBatch_Test
{
    static testMethod void CG_SendClaimInfoBatch_method()
    {
        CSS_Claims__c claim = new CSS_Claims__c();
        claim.Contact_First_Name__c='tetstttt';
        insert claim;
        List<CSS_Claim_Submission__c> lst = new List<CSS_Claim_Submission__c>();
        CSS_Claim_Submission__c claimsub = new CSS_Claim_Submission__c();
        claimsub.CSS_Claims__c = claim.id;
		claimsub.Status__c='Submitted';
        claimsub.Account_Code__c = 'Test';
		claimsub.Batch_Picked_Date__c=system.now()-4;
        insert claimsub;
        lst.add(claimsub);
        Test.startTest();
        CG_SendClaimInfoBatch obj = new CG_SendClaimInfoBatch();
        Database.executeBatch(obj);
        Test.stopTest();
    }
}