/*
* Test Class for Apex Controller - FSL_CL_Forms
* Author - Piyush Rani
*/ 
@isTest
public class FSL_CL_Forms_Test {
    private static void testSortForm() {
        CSS_JobForms__c jobForm = FSL_TestDataUtility.createCSSJobForm();
        PageReference pageRef = Page.FSL_FormPage;
        Test.setCurrentPage(pageRef);
        FSL_CL_Forms controller = new FSL_CL_Forms();
        ApexPages.currentPage().getParameters().put('Id', jobForm.Id);
    } 
    
    @isTest  
    static void getform1_test(){
        CSS_JobForms__c jobForm = FSL_TestDataUtility.createCSSJobForm();
        PageReference pageRef = Page.FSL_FormPage;
        Test.setCurrentPage(pageRef);
        FSL_CL_Forms controller = new FSL_CL_Forms();
        ApexPages.currentPage().getParameters().put('Id', jobForm.Id);
    }
    
    @isTest    
    static void formWrapper_test(){
        //WorkOrder jo = FSL_TestDataUtility.createWorkOrder(null, null);
        
        CSS_Job_Order__c jo = FSL_TestDataUtility.createJobOrder(true);
        
        FSL_CL_Forms form = new FSL_CL_Forms();
        CSS_JobForms__c jobform = new CSS_JobForms__c(); 
        jobform.CreatedDate = system.now();
        jobform.JSA__c = 'wyeeeewidweje';
        jobform.Name = 'testing';
        jobform.Service_Job__c = jo.id;
        jobform.LastModifiedDate = system.now();
        insert jobform;
        
        form.getSortvalues1();
        
        FSL_CL_Forms.formWrapper fw = new FSL_CL_Forms.formWrapper(jobform,'13-03-2017',jobform.id,jo.id, null, null);
        // fw.lastdate = '2-02-2017';
    }
    
    @isTest 
    static void form_test(){
        test.startTest();
        FSL_CL_Forms form2 = new FSL_CL_Forms();
        
        CSS_Job_Order__c jo = FSL_TestDataUtility.createJobOrder(true);
        FSL_CL_Forms form = new FSL_CL_Forms();
        CSS_JobForms__c jobform = new CSS_JobForms__c();
        jobform.CreatedDate = system.now();
        jobform.JSA__c = 'wyeeeewidweje';
        jobform.Name = 'testing';
        jobform.Service_Job__c = jo.id;
        jobform.LastModifiedDate = system.now();
        insert jobform;
        
        form2.JobId = jo.Id;
        form2.formId = jobForm.Id; 
        form2.formdesc ='1';
        form2.sortform();
        
        //InShopJSA
        Id InShopJSAId = Schema.SObjectType.CSS_JobForms__c.getRecordTypeInfosByName().get('InShopJSA').getRecordTypeId();
        jobform.RecordTypeId = InShopJSAId;
        update jobform;
        form2.sortform();
        
        //FieldServiceJSA
        Id FieldServiceJSAId = Schema.SObjectType.CSS_JobForms__c.getRecordTypeInfosByName().get('FieldServiceJSA').getRecordTypeId();
        jobform.RecordTypeId = FieldServiceJSAId;
        update jobform;
        form2.sortform();
        
        //MarineJSA
        Id MarineJSAId = Schema.SObjectType.CSS_JobForms__c.getRecordTypeInfosByName().get('MarineJSA').getRecordTypeId();
        jobform.RecordTypeId = MarineJSAId;
        update jobform;
        form2.sortform();
        
        //PowerGenJSA
        Id PowerGenJSAId = Schema.SObjectType.CSS_JobForms__c.getRecordTypeInfosByName().get('PowerGenJSA').getRecordTypeId();
        jobform.RecordTypeId = PowerGenJSAId;
        update jobform;
        form2.sortform();
        test.stopTest();
    } 
    
    @isTest 
    static void form_test2(){
        test.startTest();
        FSL_CL_Forms form2 = new FSL_CL_Forms();
        
        CSS_Job_Order__c jo = FSL_TestDataUtility.createJobOrder(true);
        FSL_CL_Forms form = new FSL_CL_Forms();
        CSS_JobForms__c jobform = new CSS_JobForms__c();
        jobform.CreatedDate = system.now();
        jobform.JSA__c = 'wyeeeewidweje';
        jobform.Name = 'testing';
        jobform.Service_Job__c = jo.id;
        jobform.LastModifiedDate = system.now();
        insert jobform;
        
        form2.JobId = jo.Id;
        form2.formId = jobForm.Id; 
        form2.formdesc ='2';
        form2.sortform();
        //InShopJSA
        Id InShopJSAId = Schema.SObjectType.CSS_JobForms__c.getRecordTypeInfosByName().get('InShopJSA').getRecordTypeId();
        jobform.RecordTypeId = InShopJSAId;
        update jobform;
        form2.sortform();
        
        //FieldServiceJSA
        Id FieldServiceJSAId = Schema.SObjectType.CSS_JobForms__c.getRecordTypeInfosByName().get('FieldServiceJSA').getRecordTypeId();
        jobform.RecordTypeId = FieldServiceJSAId;
        update jobform;
        form2.sortform();
        
        //MarineJSA
        Id MarineJSAId = Schema.SObjectType.CSS_JobForms__c.getRecordTypeInfosByName().get('MarineJSA').getRecordTypeId();
        jobform.RecordTypeId = MarineJSAId;
        update jobform;
        form2.sortform();
        
        //PowerGenJSA
        Id PowerGenJSAId = Schema.SObjectType.CSS_JobForms__c.getRecordTypeInfosByName().get('PowerGenJSA').getRecordTypeId();
        jobform.RecordTypeId = PowerGenJSAId;
        update jobform;
        form2.sortform();
        test.stopTest();
    } 
}