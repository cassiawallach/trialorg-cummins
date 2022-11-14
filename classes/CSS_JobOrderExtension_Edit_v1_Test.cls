@isTest
public class CSS_JobOrderExtension_Edit_v1_Test {
/*
----------------------------------------------------------
Author: Varun
Created Date:1/1/2016  
Updated by: Roopa G
Updated on: 1/5/2016
Description: Test Class for  Home/Job Page Controller
Change Description:
-----------------------------------------------------------
*/
    static testMethod void test(){
        CSS_JobOrderExtension_Edit_v1 obj = new CSS_JobOrderExtension_Edit_v1();
        obj.ServiceJobList = 'Sample';
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator' LIMIT 1];
        Profile p1 = [SELECT Id FROM Profile WHERE Name='CSS_Service_Supervisor' LIMIT 1];
        Profile p2 = [SELECT Id FROM Profile WHERE Name='CSS_Service_Technician' LIMIT 1];
        UserRole ur = [SELECT id from UserRole WHERE PortalType = 'None' LIMIT 1];
        
        User newUser = new User(Alias = 'standt', Email='test1@gmail.com', UserRoleId = ur.Id ,
                                EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                LocaleSidKey='en_US', ProfileId = p.Id, User_Location__c = '03742-02991',
                                TimeZoneSidKey='America/Los_Angeles', UserName='test11newUser@gmail.com');
        User newUserA = new User(Alias = 'standtA', Email='test1A@gmail.com', UserRoleId = ur.Id ,
                                 EmailEncodingKey='UTF-8', LastName='TestingA', LanguageLocaleKey='en_US', 
                                 LocaleSidKey='en_US', ProfileId = p1.Id, User_Location__c = '03742-02991',
                                 TimeZoneSidKey='America/Los_Angeles', UserName='test11AQnewUser@gmail.com');
                                 
         User newUser2A = new User(Alias = 'standt2A', Email='test2A@gmail.com', UserRoleId = ur.Id ,
                                 EmailEncodingKey='UTF-8', LastName='Testing2A', LanguageLocaleKey='en_US', 
                                 LocaleSidKey='en_US', ProfileId = p2.Id, User_Location__c = '03742-02991',
                                 TimeZoneSidKey='America/Los_Angeles', UserName='test12AQnewUser@gmail.com');
           User newUser3A = new User(Alias = 'standt3A', Email='test3A@gmail.com', UserRoleId = ur.Id ,
                                  EmailEncodingKey='UTF-8', LastName='Testing3A', LanguageLocaleKey='en_US', 
                                  LocaleSidKey='en_US', ProfileId = p.Id,User_Location__c = '03742-02991', 
                                  TimeZoneSidKey='America/Los_Angeles', UserName='test13AQnewUser@gmail.com');
                                  
          User newUser4A = new User(Alias = 'standt4A', Email='test4A@gmail.com', UserRoleId = ur.Id ,
                                  EmailEncodingKey='UTF-8', LastName='Testing4A', LanguageLocaleKey='en_US', 
                                  LocaleSidKey='en_US', ProfileId = p.Id,User_Location__c = '03742-02991', 
                                  TimeZoneSidKey='America/Los_Angeles', UserName='test14AQnewUser@gmail.com');
         
         User newUser5A = new User(Alias = 'standt5A', Email='test5A@gmail.com', UserRoleId = ur.Id ,
                                  EmailEncodingKey='UTF-8', LastName='Testing5A', LanguageLocaleKey='en_US', 
                                  LocaleSidKey='en_US', ProfileId = p.Id,User_Location__c = '03742-02991', 
                                  TimeZoneSidKey='America/Los_Angeles', UserName='test15AQnewUser@gmail.com');
         
        User newUser6A = new User(Alias = 'standt6A', Email='test6A@gmail.com', UserRoleId = ur.Id ,
                                  EmailEncodingKey='UTF-8', LastName='Testing6A', LanguageLocaleKey='en_US', 
                                  LocaleSidKey='en_US', ProfileId = p.Id,User_Location__c = '03742-02991', 
                                  TimeZoneSidKey='America/Los_Angeles', UserName='test16AQnewUser@gmail.com');
        
         User newUser7A = new User(Alias = 'standt7A', Email='test7A@gmail.com', UserRoleId = ur.Id ,
                                 EmailEncodingKey='UTF-8', LastName='Testing7A', LanguageLocaleKey='en_US', 
                                 LocaleSidKey='en_US', ProfileId = p2.Id, 
                                 TimeZoneSidKey='America/Los_Angeles', UserName='test17AQnewUser@gmail.com');
         User newUser8A = new User(Alias = 'standt8A', Email='test8A@gmail.com', UserRoleId = ur.Id ,
                                 EmailEncodingKey='UTF-8', LastName='Testing8A', LanguageLocaleKey='en_US', 
                                 LocaleSidKey='en_US', ProfileId = p2.Id, 
                                 TimeZoneSidKey='America/Los_Angeles', UserName='test18AQnewUser@gmail.com');
         User newUser9A = new User(Alias = 'standt9A', Email='test9A@gmail.com', UserRoleId = ur.Id ,
                                 EmailEncodingKey='UTF-8', LastName='Testing9A', LanguageLocaleKey='en_US', 
                                 LocaleSidKey='en_US', ProfileId = p2.Id, 
                                 TimeZoneSidKey='America/Los_Angeles', UserName='test19AQnewUser@gmail.com');
        insert newUser;                       
        insert newUser2A;
        insert newUserA; //kalpana
         insert newUser3A;       
        insert newUser4A;       
        insert newUser5A;       
        insert newUser6A;       
        insert newUser7A;       
        insert newUser8A;       
        insert newUser9A;
        
        CSS_Job_Order__c cjo = new CSS_Job_Order__c();
        CSS_Job_Order__c cj = new CSS_Job_Order__c();
        CSS_Job_Order__c cj1 = new CSS_Job_Order__c();//kalpana
        
        System.runAs(newUser){
            
            cjo.Customer_Name__c = 'varun';
            CJO.Assigned_To__c=newUser.id;
            CJO.Additional_Tech1__c=newUser.id;
            CJO.Additional_Tech2__c=newUser.id;    
            cjo.Status__c='Closed';
            cjo.DSID__c='DSBDT2274';
            cjo.unit_number__c='12345';
        //    cjo.Service_Model_N__c=12345;
            cjo.Shop_Work_Order__c='abcd';
           // cjo.dField='Visible';
            cjo.DSID_UpdateTimestamp__c=System.now();
            cjo.INSITE_UpdateTimeStamp__c=System.now();
            
            //====Created Another Job Order with newUserA======Kalpana//
            cj1.Customer_Name__c = 'varun';
            CJ1.Assigned_To__c=newUserA.id;
            CJ1.Additional_Tech1__c=newUser.id;
            CJ1.Additional_Tech2__c=newUser.id;    
            cj1.Status__c='Closed';
            //cj1.DSID__c='DSBDT2274';
            cj1.unit_number__c='12345';
        //    cjo.Service_Model_N__c=12345;
            cj1.Shop_Work_Order__c='abcd';
           // cjo.dField='Visible';
            cj1.DSID_UpdateTimestamp__c=System.now();
            cj1.INSITE_UpdateTimeStamp__c=System.now();            
            insert cjo;  
             insert cj1;
             Note x = new Note();
            x.Title = 'CAMPCOMMENTS';
            x.ParentId = cj1.Id;  
            x.Body = 'c';
            insert x;
            
            
            //CSS_Job_Order__share jobOrderShare = new CSS_Job_Order__share(parentid=cjo.Id,UserOrGroupId=newUser2A.Id,AccessLevel='Edit',RowCause='CSS_Apex_AssignedTo_Sharing__c');===Commented Kalpana//
            CSS_Job_Order__share jobOrderShare = new CSS_Job_Order__share(parentid=cj1.Id,UserOrGroupId=newUser2A.Id,AccessLevel='Edit',RowCause='CSS_Apex_AssignedTo_Sharing__c');
         //   insert  jobOrderShare;
            
            
            CSS_JobOrderExtension_Edit_v1 joe = new CSS_JobOrderExtension_Edit_v1();
            string csj = CSS_JobOrderExtension_Edit_v1.getlstServiceJob();
            string getlst = CSS_JobOrderExtension_Edit_v1.getlstUserbyRole();
     
            CSS_JobOrderExtension_Edit_v1.updateAccount(cjo.id, CJO.NAME,cjo.Customer_Name__c, String.ValueOf(newUser.Id), String.ValueOf(newUserA.Id), String.ValueOf(newUser2A.Id), String.ValueOf(newUser3A.Id), String.ValueOf(newUser4A.Id), String.ValueOf(newUser5A.Id), String.ValueOf(newUser6A.Id), String.ValueOf(newUser7A.Id), String.ValueOf(newUser8A.Id), String.ValueOf(newUser9A.Id));
        }
        
        System.runAs(newUser2A){
            cj.Customer_Name__c = 'varun';
            CJ.Assigned_To__c=newUser2A.id;
            CJ.Additional_Tech1__c=newUser.id;
            CJ.Additional_Tech2__c=newUser.id;
            cj.Additional_Tech3__c=newUser3A.id;
            cj.Additional_Tech4__c=newUser4A.id;
            cj.Additional_Tech5__c=newUser5A.id;
            cj.Additional_Tech6__c=newUser6A.id;
            cj.Additional_Tech7__c=newUser7A.id;
            cj.Additional_Tech8__c=newUser8A.id;
            cj.Additional_Tech9__c=newUser9A.id;
            cj.DSID_UpdateTimestamp__c=System.now();
            cj.INSITE_UpdateTimeStamp__c=System.now();
            cj.Status__c = 'Review';
            //cj.Notes='testing';
            insert cj; 
            
            CSS_JobOrderExtension_Edit_v1 joe1 = new CSS_JobOrderExtension_Edit_v1();
            string csj1 = CSS_JobOrderExtension_Edit_v1.getlstServiceJob();
            string getlst1 = CSS_JobOrderExtension_Edit_v1.getlstUserbyRole();
     
            //CSS_JobOrderExtension_Edit_v1.updateAccount(cjo.id, CJO.NAME,cjo.Customer_Name__c, 'Varun');
            CSS_JobOrderExtension_Edit_v1.updateAccount(cj.id, CJ.NAME,cj.Customer_Name__c,String.ValueOf(newUser.Id), String.ValueOf(newUserA.Id), String.ValueOf(newUser2A.Id), String.ValueOf(newUser3A.Id), String.ValueOf(newUser4A.Id), String.ValueOf(newUser5A.Id), String.ValueOf(newUser6A.Id), String.ValueOf(newUser7A.Id), String.ValueOf(newUser8A.Id), String.ValueOf(newUser9A.Id));
          List<CSS_JobOrderExtension_Edit_v1.UserbyRoleWrap> urw=CSS_JobOrderExtension_Edit_v1.certUserLIst('testing');
        }
       
        
        
    }
    
}