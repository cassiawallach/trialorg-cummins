@isTest
public class CG_CL_FieldServiceJSA_Test{

    static testMethod void CG_CL_FieldServiceJSA_Test(){
        test.startTest(); 
        CSS_Job_Order__c servicejob = new CSS_Job_Order__c();
        servicejob.Customer_Name__c = 'test';
        insert (servicejob);

        CSS_JobForms__c  jobform= new CSS_JobForms__c();
        jobform.Service_Job__c=servicejob.id;
        jobform.name='test';
        jobform.Co_Worker_Name__c ='test1 test2 test3';
        jobform.Job_Location__c='cummins East-Bristol';

        insert (jobform); 
        
        CSS_JobHistory__c JH = new CSS_JobHistory__c();
        JH.CSS_JobFormId__c = jobform.id;
        JH.CSS_Job_Id__c = servicejob.id;
        insert (JH); 

        Test.stopTest();

        PageReference pageRef = Page.CG_FieldServiceJSA;
        pageRef.getParameters().put('id', servicejob.id);
        pageRef.getParameters().put('jformId', jobform.id);
        Test.setCurrentPage(pageRef);
        CG_CL_FieldServiceJSA c = new CG_CL_FieldServiceJSA();
        c.getItemsPrepare();
        c.getPPE();
        //c.getTaskCategory();
        c.FieldServicePgSave();
        c.FormCancelPopup();

    }

}