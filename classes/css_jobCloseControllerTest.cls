@isTest(seeAlldata =false)
public class css_jobCloseControllerTest {

    public static testmethod void jobClose() {
        
       // css_solutions_c css = new CSS_Solutions__c();
           //
           
        Css_job_order__c joborder = new css_job_order__c();
        insert joborder;
        
        ApexPages.CurrentPage().getParameters().put('id',joborder.Id);
        
        CSS_jobClosure jobClose = new CSS_jobClosure();
        jobClose.JobID = joborder.Id;
        jobClose.showPopup();
        jobClose.pgSaveFinish();
        
        CSS_CampTsbTrp__c camTsbTrpRec = new CSS_CampTsbTrp__c(Name='Test Tsb Trp',Job_Order__c=joborder.Id);
        //insert camTsbTrpRec;
        
        CSS_Solutions__c solRec = new CSS_Solutions__c(Service_Job__c=joborder.Id,Solution__c='Solution2');
        insert solRec;
        
        CSS_jobClosure jobClose1 = new CSS_jobClosure();
        jobClose1.pgSaveFinish();
        
        solRec.Solution__c = 'Solution1';        
        update solRec;
        
        CSS_jobClosure jobClose2 = new CSS_jobClosure();
        jobClose2.pgSaveFinish();
        
        solRec.Solution__c = 'Solution1';
        solRec.Repair_Response__c = 'No Solution';
        update solRec;
        
        CSS_jobClosure jobClose3 = new CSS_jobClosure();
        jobClose3.pgSaveFinish();
        jobClose3.workJob.CSS_Resolution__c='Sample Resolution';
        jobClose3.pgSaveFinish();
        
        solRec.Solution__c = 'Solution1';
        solRec.Repair_Response__c = 'Successful';
        update solRec;
        
        CSS_jobClosure jobClose4 = new CSS_jobClosure();
        jobClose4.pgSaveFinish();
        
    }

}