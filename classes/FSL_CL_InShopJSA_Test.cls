/*
 * Test Class for Apex Controller - FSL_CL_InShopJSA
 * Author - Piyush Rani
 */ 
//Added for code coverage
@isTest
public class FSL_CL_InShopJSA_Test {

    static testMethod void FSL_CL_InShopJSA_Test() {
        WorkOrder workOrd = new WorkORder();
        CSS_Integration_Details__c customSettingCID = new CSS_Integration_Details__c();
        
        test.startTest(); 
        CSS_Job_Order__c servicejob = new CSS_Job_Order__c();
        servicejob.Customer_Name__c = 'test';
        insert (servicejob);
        
        customSettingCID = FSL_TestDataUtility.createCSSIntegrationDetails();//Custom Setting 
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

        PageReference pageRef = Page.FSL_InShopJSA;
        pageRef.getParameters().put('id', workOrd.id);
        pageRef.getParameters().put('jformId', jobform.id);
        Test.setCurrentPage(pageRef);
        FSL_CL_InShopJSA c = new FSL_CL_InShopJSA();
        c.getItemsPrepare1();
        c.getPPE1();
        c.getTaskCategory();
        c.InshopPgSave();
        c.FormCancelPopup();
    }
}