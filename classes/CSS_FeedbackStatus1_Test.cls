@IsTest(seealldata = true)
public class CSS_FeedbackStatus1_Test{
/*
----------------------------------------------------------
Author: Roopa G
Created Date:09/2/2016  
Updated by: Roopa G
Updated on: 09/2/2016
Description: Test Class Customer support feedback count when status is received in process
Change Description: 
-----------------------------------------------------------
*/
    static testMethod void CSS_FeedbackStatus1_Test_Method1()
    {
    
       
    
    
    // Add test data for creating service job record
        Test.startTest();             
           CSS_Feedback_Form__c FF = new CSS_Feedback_Form__c();
              //  FF.CSS_FeedbackFormName_c = 'My Feedback';
                FF.FeedbackStatus__c = 'ReceivedInProcess';
                FF.Type_Of_Feedback__c = 'Feedback2';   
                FF.Product__c = 'Product1';         
                
            insert(FF);
        
          
            
        Profile p = [SELECT Id FROM Profile WHERE Name='CSS_Service_Advanced']; 
        User u =  new User(Alias = 'standt', Email='standarduser4@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTestUser4@testorg.com');
        insert u;
        
        
        
        id UserId = u.id;
        system.runas(u){
        
        css_utility.setUserLang(UserId,'en_US');
        
       
        } 
              CSS_Job_Order__c JO = new CSS_Job_Order__c();
        JO = CSS_TestData.createJobOrder(false);
      
        insert jo;
            ApexPages.currentPage().getParameters().put('id',jo.Id);            
            
            PageReference p1=Page.CSS_JobPlan; 
            Test.setCurrentPage(p1);  
            ApexPages.currentPage().getParameters().put('id',jo.Id); 

        CSS_FeedbackStatus1  feedback= new CSS_FeedbackStatus1 ();
        feedback.changeEnglish();
        feedback.changeSpanish();
        feedback.changeFrench();
        feedback.changeChinese();
        feedback.redirectHomePage();
        feedback.changeAfrikaans();
        feedback.changeGerman();
        feedback.changeCanadianFrench();
        feedback.changeTurkish();
        feedback.changeDutch();
        feedback.changeBrasil();   
        feedback.getReports();     
        feedback.displayForms();   
        feedback.changeRussian();
        feedback.getWrtySysPermission();
        CSS_Job_Order__c cssJob = CSS_TestData.createJobOrder(True); 
        cssJob.Status__c = 'Closed';
        update cssJob; 
        Id recTypeId = css_utility.getRecordTypeId(case.sObjectType, 'Feedback');
        string recordtypename = Schema.SObjectType.Case.getRecordTypeInfosById().get(recTypeId).getname();
        Case cs = CSS_TestData.createCase(true, recordtypename);
        
        //boolean displayFormsRemote = CSS_FeedbackStatus1.displayFormsRemote(cssJob.Id);
        //List<String> lstCaseCount = CSS_FeedbackStatus1.getCaseCount(cssJob.Id);
          
        Test.stopTest();
    }
    
    static testMethod void CSS_FeedbackStatus1_Test_Method2(){
        CSS_Job_Order__c JO = new CSS_Job_Order__c();
        JO = CSS_TestData.createJobOrder(false);
        insert JO;
        Id recTypeId = css_utility.getRecordTypeId(case.sObjectType, 'Reported Problem');
        string recordtypename = Schema.SObjectType.Case.getRecordTypeInfosById().get(recTypeId).getname();
        Case cs = CSS_TestData.createCase(true, recordtypename);
        
        //boolean displayFormsRemote = CSS_FeedbackStatus1.displayFormsRemote(cssJob.Id);
        //List<String> lstCaseCount = CSS_FeedbackStatus1.getCaseCount(JO.Id);
    }
    static testmethod void getWrtyExtSysPermissionmethod(){
                  test.startTest();
    CSS_FeedbackStatus1  feedback= new CSS_FeedbackStatus1 ();
        feedback.getWrtyExtSysPermission();
                  test.stopTest();
    }  
}