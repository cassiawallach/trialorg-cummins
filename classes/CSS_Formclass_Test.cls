@istest
public class CSS_Formclass_Test {
    public static testmethod void getSortvalues_test(){
        User u = CSS_TestData.createTestUser(false);
        u.Username = 'css-cmi4@cummins.com';
        insert u;
        
        system.runAs(u){
            test.startTest();
            Account acc = CSS_TestData.createAccountObj(true);
            Account a = CSS_TestData.createAccountObj(false);
            a.CSS_DistributorCode__c='56270';
            a.IAM_Service_Provider_Code__c='56270';
            a.Type='Dealer Account';
         a.Region__c = 'US and Canada';
        a.CMI_Account_Status__c = 'Active';
        a.IAM_Service_Provider_Code__c = '562551';
            insert a;
            system.debug('location acc >>>>>'+a.name);
             CSS_Job_Order__c jo = CSS_TestData.createJobOrder(true);
            //jo.Creator_Location__c = 'North America';
            system.debug('jo.Creator_Location__c>>>>>>>>***'+jo.Creator_Location__c);
            //insert jo;
            CSS_JobForms__c jobform = new CSS_JobForms__c();
            jobform.Name = 'testname';
            jobform.Service_Job__c= jo.id;
            insert jobform;
            ApexPages.CurrentPage().getParameters().put('id',jo.Id);
            
            CSS_Formsclass form = new CSS_Formsclass();
            form.getSortvalues();
            form.sortform();
           form.jobId = jo.id;
            form.formId = jo.id;
            test.stopTest();
        }
       
    }
    
   /* static testmethod void getform1_test(){
        PageReference pageRef = new PageReference('/apex/CSS_JSAForm?id=');
        test.setCurrentPage(pageRef);
         CSS_Job_Order__c jo = CSS_TestData.createJobOrder(true);
        ApexPages.CurrentPage().getParameters().put('id',jo.Id);
         CSS_Formsclass form1 = new CSS_Formsclass();
        form1.getform();
    }*/
    static testmethod void formWrapper_test(){
        CSS_Job_Order__c jo = CSS_TestData.createJobOrder(true);
        CSS_JobForms__c jobform = new CSS_JobForms__c();
        jobform.Name = 'testname';
        jobform.Service_Job__c= jo.id;
        insert jobform;
        
       CSS_Formsclass.formWrapper fw = new CSS_Formsclass.formWrapper(jobform,'01-12-2017',jobform.id,jo.id,'Type','Page'); 
       // fw.lastdate = '2-02-2017';
       
       CSS_Formsclass form = new CSS_Formsclass();
       form.formdesc ='1';
       test.startTest();
       form.sortform();
       test.stopTest();
        
    }
    
    static testmethod void form_testDesc1(){
        
        CSS_Job_Order__c jo = CSS_TestData.createJobOrder(true);
        CSS_JobForms__c jobform = new CSS_JobForms__c();
        jobform.Name = 'testname';
        jobform.Service_Job__c= jo.id;
        jobform.RecordTypeId = Schema.SObjectType.CSS_JobForms__c.getRecordTypeInfosByName().get('InShopJSA').getRecordTypeId();
        insert jobform;
        ApexPages.currentPage().getParameters().put('id',jo.id);
        CSS_Formsclass form2 = new CSS_Formsclass();
        
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
    
    static testmethod void form_test(){
        
        CSS_Job_Order__c jo = CSS_TestData.createJobOrder(true);
        CSS_JobForms__c jobform = new CSS_JobForms__c();
        jobform.Name = 'testname';
        jobform.Service_Job__c= jo.id;
        jobform.RecordTypeId = Schema.SObjectType.CSS_JobForms__c.getRecordTypeInfosByName().get('InShopJSA').getRecordTypeId();
        insert jobform;
        ApexPages.currentPage().getParameters().put('id',jo.id);
        CSS_Formsclass form2 = new CSS_Formsclass();
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
    
   
}