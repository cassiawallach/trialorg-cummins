//Adding Comment to deploy changes --- Sriprada S
@isTest
public class FSL_CL_FieldServiceJSA_Test {
    @isTest static void testFieldServiceJSA()
    {
        
        test.startTest(); 
        CSS_Job_Order__c servicejob = new CSS_Job_Order__c();
        servicejob.Customer_Name__c = 'test'; 
        insert (servicejob);
        
        WorkOrder wo = FSL_TestDataUtility.createWorkOrder(null, null);
        
        CSS_JobForms__c  jobform= new CSS_JobForms__c();
        jobform.Service_Job__c=servicejob.id;
        jobform.ServiceJob__c = wo.Id;
        jobform.name='test';
        jobform.Co_Worker_Name__c ='test1 test2 test3';
        jobform.Job_Location__c='cummins East-Bristol';
        jobform.PowerGenPPELevel__c ='test';
        
        insert (jobform); 
        
        CSS_JobHistory__c JH = new CSS_JobHistory__c();
        JH.CSS_JobFormId__c = jobform.id;
        //JH.CSS_Job_Id__c = servicejob.id;
        JH.CSS_Job_Id__c = wo.id;
        insert (JH); 
        
        Test.stopTest();
        
        PageReference pageRef = Page.FSL_MarineJSA;
        pageRef.getParameters().put('id', wo.id);
        pageRef.getParameters().put('jformId', jobform.id);
        Test.setCurrentPage(pageRef);
        
        FSL_CL_FieldServiceJSA c = new FSL_CL_FieldServiceJSA();
        //c.pgId = wo.Id;
        c.getItemsPrepare();
        c.getPPE();
        c.getPPE1();
        c.getTaskCategory();
        c.FieldServicePgSave();
        c.FormCancelPopup();
    }
}