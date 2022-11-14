/*
 * Test Class for Apex Controller - FSL_FormsClass
 * Author - Piyush Rani
 */ 
@isTest
public class FSL_FormsClass_Test {
    @isTest static void getSortvalues_test(){
        CSS_Job_Order__c jo = CSS_TestData.createJobOrder(true);
        WorkOrder wo = FSL_TestDataUtility.createWorkOrder(null, null);
        
        CSS_JobForms__c jobform = new CSS_JobForms__c();
        jobform.CreatedDate = system.now();
        jobform.JSA__c = 'JSATEST';
        jobform.Name = 'TEST_NAME';
        jobform.Service_Job__c = jo.id;
        jobform.ServiceJob__c = wo.Id;
        jobform.LastModifiedDate = system.now(); 
        insert jobform;
        
        test.startTest();
        FSL_FormsClass form = new FSL_FormsClass();
        form.formdesc = '1';
        form.getSortvalues();
        
        form.jobId = jo.id;
        form.formId = jo.id;
        
        form.Wid = wo.Id;
		form.sortform();   
        
        jobform.RecordTypeId = Schema.SObjectType.CSS_JobForms__c.getRecordTypeInfosByName().get('InShopJSA').getRecordTypeId();
        update jobform;
        form.sortform();
        
        jobform.RecordTypeId = Schema.SObjectType.CSS_JobForms__c.getRecordTypeInfosByName().get('FieldServiceJSA').getRecordTypeId();
        update jobform;
        form.sortform();
        
        jobform.RecordTypeId = Schema.SObjectType.CSS_JobForms__c.getRecordTypeInfosByName().get('MarineJSA').getRecordTypeId();
        update jobform;
        form.sortform();
        
        jobform.RecordTypeId = Schema.SObjectType.CSS_JobForms__c.getRecordTypeInfosByName().get('PowerGenJSA').getRecordTypeId();
        update jobform;
        form.sortform();
        
        test.stopTest();
    }
    
    @isTest
    static void formWrapper_test(){
        
        CSS_Job_Order__c jo = CSS_TestData.createJobOrder(true);
        WorkOrder wo = FSL_TestDataUtility.createWorkOrder(null, null);
        CSS_JobForms__c jobform = new CSS_JobForms__c();
        jobform.CreatedDate = system.now();
        jobform.JSA__c = 'JSATEST';
        jobform.Name = 'TEST_NAME';
        jobform.Service_Job__c = jo.id;
        jobform.ServiceJob__c = wo.Id;
        jobform.LastModifiedDate = system.now(); 
        insert jobform;
        
        FSL_FormsClass formCls = new FSL_FormsClass();
        formCls.Wid = wo.Id;
        formCls.formdesc = '2';
        formCls.sortform();
        
        jobform.RecordTypeId = Schema.SObjectType.CSS_JobForms__c.getRecordTypeInfosByName().get('InShopJSA').getRecordTypeId();
        update jobform;
        formCls.sortform();
        
        jobform.RecordTypeId = Schema.SObjectType.CSS_JobForms__c.getRecordTypeInfosByName().get('FieldServiceJSA').getRecordTypeId();
        update jobform;
        formCls.sortform();
        
        jobform.RecordTypeId = Schema.SObjectType.CSS_JobForms__c.getRecordTypeInfosByName().get('MarineJSA').getRecordTypeId();
        update jobform;
        formCls.sortform();
        
        jobform.RecordTypeId = Schema.SObjectType.CSS_JobForms__c.getRecordTypeInfosByName().get('PowerGenJSA').getRecordTypeId();
        update jobform;
        formCls.sortform();
        
        
        /* Class.FSL_TestDataUtility.createServiceTerritory: line 42, column 1
        Class.FSL_TestDataUtility.createWorkOrder: line 63, column 1
        Class.FSL_TestDataUtility.createCSSJobForm: line 99, column 1
        Class.FSL_Formsclass_Test.formWrapper_test: line 23, column 1
        */
        FSL_FormsClass.formWrapper fw = new FSL_FormsClass.formWrapper(jobform, '30-08-2020', jobform.id, jo.id, null, null); 
        
    }
}