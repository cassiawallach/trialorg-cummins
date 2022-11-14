/*
 * Test Class for Apex Controller - FSL_CL_FormsController_Test
 * Author - Piyush Rani
 */ 
@isTest
public class FSL_CL_FormsController_Test {
    @isTest private static void fetchFormsDetailsTest() {
        Test.startTest();
        WorkOrder wo = FSL_TestDataUtility.createWorkOrder(null, null);
        CSS_JobForms__c jobform = new CSS_JobForms__c(); 
        jobform.CreatedDate = system.now();
        jobform.JSA__c = 'FormShopJSA';
        jobform.Name = 'FormShopJSA';
        jobform.servicejob__c = wo.Id;
        jobform.Form_Start_Time__c = System.now().format('dd MMM YYYY hh:mm a z');
        jobform.Form_Initiate_Time__c = System.now();
        jobform.RecordTypeId = Schema.SObjectType.CSS_JobForms__c.getRecordTypeInfosByName().get('InShopJSA').getRecordTypeId();
        insert jobform;
        
        List<FSL_CL_FormsController.formWrapper>  formWrapperList = new List<FSL_CL_FormsController.formWrapper>();
        formWrapperList = FSL_CL_FormsController.fetchFormsDetails(wo.Id);
        Boolean formStatus = FSL_CL_FormsController.getFormStatus(jobform.Id);
        
        //JSAForms Record Type
        jobform.RecordTypeId = Schema.SObjectType.CSS_JobForms__c.getRecordTypeInfosByName().get('JSAForms').getRecordTypeId();
        update jobform;
        formWrapperList = FSL_CL_FormsController.fetchFormsDetails(wo.Id);
        
        //FieldServiceJSA Record Type
        jobform.RecordTypeId = Schema.SObjectType.CSS_JobForms__c.getRecordTypeInfosByName().get('FieldServiceJSA').getRecordTypeId();
        update jobform;
        formWrapperList = FSL_CL_FormsController.fetchFormsDetails(wo.Id);
        
        //MarineJSA Record Type
        jobform.RecordTypeId = Schema.SObjectType.CSS_JobForms__c.getRecordTypeInfosByName().get('MarineJSA').getRecordTypeId();
        update jobform;
        formWrapperList = FSL_CL_FormsController.fetchFormsDetails(wo.Id);
        
        //PowerGenJSA Record Type
        jobform.RecordTypeId = Schema.SObjectType.CSS_JobForms__c.getRecordTypeInfosByName().get('PowerGenJSA').getRecordTypeId();
        update jobform;
        formWrapperList = FSL_CL_FormsController.fetchFormsDetails(wo.Id);
        
        Test.stopTest();
    }
}