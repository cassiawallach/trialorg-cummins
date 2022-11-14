/**********************************************************************
Name:CSS_Form_Test 
Copyright © 2011  Cummins
======================================================
======================================================
Purpose:Test Class for CSS_Form                                                            
-------                                                             
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                  
1.0 -    Venkat         06/03/2017      INITIAL DEVELOPMENT         
*************************************************************************/
@istest
public class CSS_Form_Test {
    public static testmethod void getSortvalues_test(){
     //   ApexPages.currentPage().getParameters().put('id',cjh[0].ParentId);
        CSS_Job_Order__c jo = CSS_TestData.createJobOrder(true);
        ApexPages.CurrentPage().getParameters().put('id',jo.Id);
        test.startTest();
        CSS_Form form = new CSS_Form();
        form.getSortvalues1();
        form.sortform();
       form.jobId = jo.id;
        form.formId = jo.id;
        test.stopTest();
    }
    
  /*  static testmethod void getform1_test(){
        PageReference pageRef = new PageReference('/apex/CSS_JSAForm?id=');
        test.setCurrentPage(pageRef);
         CSS_Job_Order__c jo = CSS_TestData.createJobOrder(true);
        ApexPages.CurrentPage().getParameters().put('id',jo.Id);
         CSS_Form form1 = new CSS_Form();
        form1.getform1();
    }*/
    static testmethod void formWrapper_test(){
       
        CSS_Job_Order__c jo = CSS_TestData.createJobOrder(true);
        CSS_Form form = new CSS_Form();
        CSS_JobForms__c jobform = new CSS_JobForms__c();
        jobform.CreatedDate = system.now();
        jobform.JSA__c = 'wyeeeewidweje';
        jobform.Name = 'testing';
        jobform.Service_Job__c = jo.id;
        jobform.LastModifiedDate = system.now();
        insert jobform;
      
        CSS_Form.formWrapper fw = new CSS_Form.formWrapper(jobform,'13-03-2017',jobform.id,jo.id,'type','page');
       // fw.lastdate = '2-02-2017';
        
    }
    static testmethod void form_test(){
        CSS_Job_Order__c jo = CSS_TestData.createJobOrder(true);
        CSS_JobForms__c jobform = new CSS_JobForms__c();
        jobform.Name = 'testname';
        jobform.Service_Job__c= jo.id;
        jobform.RecordTypeId = Schema.SObjectType.CSS_JobForms__c.getRecordTypeInfosByName().get('InShopJSA').getRecordTypeId();
        insert jobform;
        ApexPages.currentPage().getParameters().put('id',jo.id);
        CSS_Form form2 = new CSS_Form();
        test.startTest();
        form2.formdesc='2';
        form2.sortform();
        
         jobform.RecordTypeId = Schema.SObjectType.CSS_JobForms__c.getRecordTypeInfosByName().get('FieldServiceJSA').getRecordTypeId();
        update jobform;
        form2.formdesc='2';
        form2.sortform();
        
        jobform.RecordTypeId = Schema.SObjectType.CSS_JobForms__c.getRecordTypeInfosByName().get('MarineJSA').getRecordTypeId();
        update jobform;
        form2.formdesc='2';
        form2.sortform();
        
        jobform.RecordTypeId = Schema.SObjectType.CSS_JobForms__c.getRecordTypeInfosByName().get('PowerGenJSA').getRecordTypeId();
        update jobform;
        form2.formdesc='2';
        form2.sortform();
        
        test.stopTest();
    }
    
     static testmethod void form_testDesc11(){
        
        CSS_Job_Order__c jo = CSS_TestData.createJobOrder(true);
        CSS_JobForms__c jobform = new CSS_JobForms__c();
        jobform.Name = 'testname';
        jobform.Service_Job__c= jo.id;
        jobform.RecordTypeId = Schema.SObjectType.CSS_JobForms__c.getRecordTypeInfosByName().get('InShopJSA').getRecordTypeId();
        insert jobform;
        ApexPages.currentPage().getParameters().put('id',jo.id);
        CSS_Form form2 = new CSS_Form();
        
        test.startTest();
        form2.formdesc='1';
        form2.sortform();
        test.stopTest();
        
        jobform.RecordTypeId = Schema.SObjectType.CSS_JobForms__c.getRecordTypeInfosByName().get('FieldServiceJSA').getRecordTypeId();
        update jobform;
        form2.formdesc='1';
        form2.sortform();
        
        jobform.RecordTypeId = Schema.SObjectType.CSS_JobForms__c.getRecordTypeInfosByName().get('MarineJSA').getRecordTypeId();
        update jobform;
        form2.formdesc='1';
        form2.sortform();
        
        jobform.RecordTypeId = Schema.SObjectType.CSS_JobForms__c.getRecordTypeInfosByName().get('PowerGenJSA').getRecordTypeId();
        update jobform;
        form2.formdesc='1';
        form2.sortform();
     
    }
}