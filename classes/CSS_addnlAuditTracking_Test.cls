@isTest
public class CSS_addnlAuditTracking_Test {
    static testmethod void auditTracking(){
   
map<Id,CSS_Job_Order__c> oldMap=new map<Id,CSS_Job_Order__c>();
    
        List<css_job_order__c> jolist = new List<css_job_order__c>();
        
        CSS_AddnlAudit__c test  = new  CSS_AddnlAudit__c(Name='Job Close Feedback',object_API_Name__c='CSS_Job_Order__c', Field_API_Name__c='CSS_Feedback_Comments__c', Audit__c=TRUE);
        insert test;
        
        css_job_order__c jobOrder = new css_job_order__c();
        jobOrder.CSS_Feedback_Comments__c='Testing';
        insert jobOrder;
        list<css_job_order__c> job1 = new list<css_job_order__c>();
        job1.add(jobOrder);
       css_job_order__c joborder1 =[select id,CSS_Feedback_Comments__c from css_job_order__c where id=:jobOrder.Id limit 1 ];
        jobOrder1.CSS_Feedback_Comments__c = 'sample response';
        update jobOrder;        
        oldMap.put(jobOrder1.Id,joborder1);
        CSS_addnlAuditTracking.css_jobHistoryAddnlAuditTracking(job1, oldMap);
                                                         
                                                  
    }   
    }