/*
 * Test Class for Apex Controller - FSL_CL_MarineJSA
 * Author - Piyush Rani
 */ 
//Added for code coverge
@isTest
public class FSL_CL_MarineJSA_Test {
	@isTest static void testMarineJSA()
    {
        
        test.startTest(); 
        WorkOrder workOrd = new WorkORder();
        CSS_Job_Order__c servicejob = new CSS_Job_Order__c();
        servicejob.Customer_Name__c = 'test';
        insert (servicejob);
        
        workOrd = FSL_TestDataUtility.createWorkOrder(null, null);

        CSS_JobForms__c  jobform= new CSS_JobForms__c();
        jobform.Service_Job__c=servicejob.id;
        jobform.ServiceJob__c=workOrd.id;
        jobform.name='test';
        jobform.Co_Worker_Name__c ='test1 test2 test3';
        jobform.Job_Location__c='cummins East-Bristol';

        insert (jobform); 
         
        CSS_JobHistory__c JH = new CSS_JobHistory__c();
        JH.CSS_JobFormId__c = jobform.id;
        JH.CSS_Job_Id__c = workOrd.id;
        insert (JH); 

        Test.stopTest();

        PageReference pageRef = Page.FSL_MarineJSA;
        pageRef.getParameters().put('id', workOrd.id);
        pageRef.getParameters().put('jformId', jobform.id);
        Test.setCurrentPage(pageRef);
        
        FSL_CL_MarineJSA c = new FSL_CL_MarineJSA();
        //c.pgId = workOrd.Id;
        c.getPowerGenPrepare1();
        c.getPPE1();
        c.getTaskCategory();
        c.MarinePgSave();
        c.FormCancelPopup();
        
    }
}