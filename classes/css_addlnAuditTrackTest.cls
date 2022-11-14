@isTest(seeallData=false)
public class css_addlnAuditTrackTest{
    public static testmethod void addlAudit(){
        List<css_job_order__c> jolist = new List<css_job_order__c>();
        
        CSS_AddnlAudit__c testAA  = new  CSS_AddnlAudit__c(Name='Job Close Feedback',object_API_Name__c='CSS_Job_Order__c', Field_API_Name__c='CSS_Feedback_Comments__c', Audit__c=TRUE);
        insert testAA;
        
        css_job_order__c jobOrderRec = new css_job_order__c();
        insert jobOrderRec;
        
        jobOrderRec.CSS_Feedback_Comments__c = 'sample response';
        update jobOrderRec;        
                                                  
    }                                                     

}