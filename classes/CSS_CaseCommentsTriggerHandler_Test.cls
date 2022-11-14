@isTest
public class CSS_CaseCommentsTriggerHandler_Test {
   
    static testMethod void myTest() {
    
    //Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
    Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
    Profile p1 = [SELECT Id FROM Profile WHERE Name='CSS_CPS_Advanced']; 
        User u = new User(Alias = 'standt1', Email='standarduser1@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing111', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='GDNZFSLUser1@cmiuser.com',User_Location__c='test-');
          insert u;
          
          User u1 = new User(Alias = 'standt2', Email='standarduser12@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing1234', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p1.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='GDNZFSLUser2@cmiuser.com',User_Location__c='test-');
          insert u1;
          
            System.runAs(u){
            
            Account a=new Account();
        a.name='name';
        a.CSS_DistributorCode__c='test';
        insert a;
        
        contact c=new contact();
        c.firstname='fname';
        c.lastname='lname';
        c.accountid=a.id;
        c.phone='1234567890';
        c.email='testtrigger@gmail.com';
        insert c;
    
        Case cse = new Case();
        cse.Accountid = a.Id;
        cse.Contactid = c.Id;
        cse.CreatedById = u.Id;
        cse.Description = 'TestDescription';
        cse.Status = 'New';
        cse.Subject = 'TestSubject';
        cse.RecordTypeId  = Schema.SObjectType.Case.getRecordTypeInfosByName().get('CCM').getRecordTypeId();       
        insert cse;
    
        CaseComment cc = new CaseComment(ParentId = cse.Id,CommentBody = 'test');
        insert cc;
      }
      
     System.runAs(u1){
           Test.startTest();
           try{
    Case c = [select id,status from case where subject='TestSubject'];   
             
CaseComment cc = new CaseComment(ParentId = c.Id,CommentBody = 'test1');
insert cc;
                 
}

catch(Exception e)
{
Boolean expectedExceptionThrown =  e.getMessage().contains('Case Owner to modify') ? true : false;
//System.AssertEquals(expectedExceptionThrown, true);
} 
        Test.stopTest();
         }
        }
}