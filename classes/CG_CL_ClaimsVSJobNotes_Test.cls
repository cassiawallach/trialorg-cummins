@isTest
public class CG_CL_ClaimsVSJobNotes_Test {
    public static testmethod void CG_CL_ClaimsVSJobNotes_method(){
        css_job_order__c Job = new css_job_order__c();
        job.Customer_Name__c='Gopal';
        job.Customer_Code__c='123';
        job.CSS_Job_Location_Code__c='56487-56487';
        insert job;
        CSS_Claims__c claim = new CSS_Claims__c();
       claim.Email_Address__c = 'qwerty@cummins.com';
        claim.CSS_Job__c=job.Id;
        claim.Country__c='CA';
        claim.State__c='US';
        insert claim;
        css_srt__c srt1 = new css_srt__c();
        srt1.CSS_Claims__c= claim.Id;
        srt1.Name='Srt';
        srt1.Type__c='99Time';
        srt1.isPerformed__c=true;
        srt1.Assignment__c='Primary';
        srt1.SRT_Notes__c = 'test';
        srt1.Account_Code_Description__c='test';
        srt1.Fail_Code_Description__c='testing';
        insert srt1;
        PageReference pg = new PageReference('page.CG_ClaimsJobNotes');
        Test.setCurrentPage(pg);    
        apexpages.currentPage().getparameters().put('id',Claim.id); 
        id cid=apexpages.currentPage().getparameters().get('id');
        CG_CL_ClaimsVSJobNotes claimsJN = new CG_CL_ClaimsVSJobNotes();
        claimsJN.redirectToJobNotes();
    }
}