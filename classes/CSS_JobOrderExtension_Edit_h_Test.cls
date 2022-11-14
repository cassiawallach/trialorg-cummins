/*
----------------------------------------------------------
Author: Roopa G
Created Date:2/1/2016  
Updated by: Roopa G
Updated on: 2/1/2016
Description: Test Class for  Home/Job Page Controller
Change Description:
-----------------------------------------------------------
*/
@isTest
public class CSS_JobOrderExtension_Edit_h_Test {
    
    static testMethod void test1() {
        
        // CSS_JobOrderExtension_Edit_h obj = new CSS_JobOrderExtension_Edit_h();
        // obj.ServiceJobList = 'Sample';
        // obj.SelectedSubStatus='Escalated';
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator' LIMIT 1];
        Profile p1 = [SELECT Id FROM Profile WHERE Name='CSS_Service_Advanced' LIMIT 1];
        Profile p2 = [SELECT Id FROM Profile WHERE Name='CSS_Service_Technician' LIMIT 1];
        
        UserRole ur = [SELECT id from UserRole WHERE PortalType = 'None' LIMIT 1];
        
        User newUser = new User(Alias = 'standt', Email='test1@gmail.com', UserRoleId = ur.Id ,
                                EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                LocaleSidKey='en_US', ProfileId = p.Id,User_Location__c = '03742-02991', 
                                TimeZoneSidKey='America/Los_Angeles', UserName='test11newUser@gmail.com');
        User newUserA = new User(Alias = 'standtA', Email='test1A@gmail.com', UserRoleId = ur.Id ,
                                 EmailEncodingKey='UTF-8', LastName='TestingA', LanguageLocaleKey='en_US', 
                                 LocaleSidKey='en_US', ProfileId = p1.Id,User_Location__c = '03742-02991', 
                                 TimeZoneSidKey='America/Los_Angeles', UserName='test11AQnewUser@gmail.com');
        
        User newUser2A = new User(Alias = 'standt2A', Email='test2A@gmail.com', UserRoleId = ur.Id ,
                                  EmailEncodingKey='UTF-8', LastName='Testing2A', LanguageLocaleKey='en_US', 
                                  LocaleSidKey='en_US', ProfileId = p2.Id,User_Location__c = '03742-02991', 
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
                                  LocaleSidKey='en_US', ProfileId = p2.Id,User_Location__c = '03742-02991', 
                                  TimeZoneSidKey='America/Los_Angeles', UserName='test17AQnewUser@gmail.com');
        User newUser8A = new User(Alias = 'standt8A', Email='test8A@gmail.com', UserRoleId = ur.Id ,
                                  EmailEncodingKey='UTF-8', LastName='Testing8A', LanguageLocaleKey='en_US', 
                                  LocaleSidKey='en_US', ProfileId = p2.Id,User_Location__c = '03742-02991', 
                                  TimeZoneSidKey='America/Los_Angeles', UserName='test18AQnewUser@gmail.com');
        
        User newUser9A = new User(Alias = 'standt9A', Email='test9A@gmail.com', UserRoleId = ur.Id ,
                                  EmailEncodingKey='UTF-8', LastName='Testing9A', LanguageLocaleKey='en_US', 
                                  LocaleSidKey='en_US', ProfileId = p2.Id,User_Location__c = '03742-02991',
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
        
        system.runAs(newUser) {
            
            CSS_Job_Order__c cj = new CSS_Job_Order__c();
            List<CSS_Job_Order__c> jobList = new List<CSS_Job_Order__c >();
            CSS_Job_Order__c cjo = new CSS_Job_Order__c();
            cjo = css_testdata.createJobOrder(false);
            
            cjo.Customer_Name__c = 'varun';
            CJO.Assigned_To__c=newUser.id;
            CJO.Additional_Tech1__c=newUser.id;
            CJO.Additional_Tech2__c=newUser.id;   
            CJO.Additional_Tech3__c=newUser3A.id;
            cjO.Additional_Tech4__c=newUser4A.id;
            CJO.Additional_Tech5__c=newUser5A.id;
            CJO.Additional_Tech6__c=newUser6A.id;
            CJO.Additional_Tech7__c=newUser7A.id;
            CJO.Additional_Tech8__c=newUser8A.id;
            CJO.Additional_Tech9__c=newUser9A.id;   
            // CJO.JobLocation__c='54699-54699';  
            CJO.Date_In__c=System.now();
            CJO.LastUpdateSubStatus__c=System.now();
            cjo.Status__c='Review';
            cjo.DSID__c='DSBDT2274';
            cjo.unit_number__c='12345';
            // cjo.Service_Model_N__c=12345;
            cjo.Shop_Work_Order__c='abcd';
            // cjo.dField='Visible';
            cjo.DSID_UpdateTimestamp__c=System.now();
            cjo.INSITE_UpdateTimeStamp__c=System.now();
            cjo.Sub_Status__c='Escalated';
            cjo.Service_Model__c='test';
            cjo.RecentVisit__c=true;
            cjo.Repeat_Visit__c=true;
            cjo.Notes__c= 'my notes';
            
            //====Created Another Job Order with newUserA======Kalpana//
            
            CSS_Job_Order__c cj1 = new CSS_Job_Order__c();//kalpana
            cj1 = css_testdata.createJobOrder(false); 
            
            cj1.Customer_Name__c = 'varun';
            
            CJ1.Assigned_To__c=newUser9A.id;
            CJ1.Additional_Tech1__c=newUser.id;
            CJ1.Additional_Tech2__c=newUser.id; 
            CJ1.Additional_Tech1__c=newUser.id;
            CJ1.Additional_Tech2__c=newUser.id;   
            CJ1.Additional_Tech3__c=newUser3A.id;
            cj1.Additional_Tech4__c=newUser4A.id;
            CJ1.Additional_Tech5__c=newUser5A.id;
            CJ1.Additional_Tech6__c=newUser6A.id;
            CJ1.Additional_Tech7__c=newUser7A.id;
            CJ1.Additional_Tech8__c=newUser8A.id;
            CJ1.Additional_Tech9__c=newUser9A.id;  
            CJ1.Date_In__c=System.now();
            CJ1.LastUpdateSubStatus__c=System.now();
            cj1.DSID__c='DSBDT2274';    
            cj1.Status__c='Intake Complete';
            //cj1.DSID__c='DSBDT2274';
            cj1.unit_number__c='12345';
            //    cjo.Service_Model_N__c=12345;
            cj1.Shop_Work_Order__c='abcd';
            CJ1.JobLocation__c='Factory';  
            // cjo.dField='Visible';
            cj1.DSID_UpdateTimestamp__c=System.now();
            cj1.INSITE_UpdateTimeStamp__c=System.now();   
            cj1.Sub_Status__c='Escalated';
            cj1.Service_Model__c='test';
            cj1.RecentVisit__c=true;
            cj1.Repeat_Visit__c=true;         
            
            cj1.Status__c = 'Closed';
            cj1.Notes__c='my notes2';
            
            CSS_Job_Order__c cjo1 = new CSS_Job_Order__c();
            cjo1  = css_testdata.createJobOrder(false); 
            cjo1.Customer_Name__c = 'varun';
            CJO1.Assigned_To__c=newUser.id;
            CJO1.Additional_Tech1__c=newUser.id;
            CJO1.Additional_Tech2__c=newUser.id;   
            CJO1.Additional_Tech3__c=newUser3A.id;
            cjO1.Additional_Tech4__c=newUser4A.id;
            CJO1.Additional_Tech5__c=newUser5A.id;
            CJO1.Additional_Tech6__c=newUser6A.id;
            CJO1.Additional_Tech7__c=newUser7A.id;
            CJO1.Additional_Tech8__c=newUser8A.id;
            CJO1.Additional_Tech9__c=newUser9A.id;   
            CJO1.JobLocation__c='Cummins Western Canada-Edmonton';  
            CJO1.Date_In__c=System.now();
            CJO1.LastUpdateSubStatus__c=System.now();
            cjo1.Status__c='Intake Complete';
            cjo1.DSID__c='DSBDT2274';
            cjo1.unit_number__c='12345';
            // cjo.Service_Model_N__c=12345;
            cjo1.Shop_Work_Order__c='abcd';
            // cjo.dField='Visible';
            cjo1.DSID_UpdateTimestamp__c=System.now();
            cjo1.INSITE_UpdateTimeStamp__c=System.now();
            cjo1.Sub_Status__c='Escalated';
            cjo1.Service_Model__c='test';
            cjo1.RecentVisit__c=true;
            cjo1.Repeat_Visit__c=true;
            
            //====Created Another Job Order with newUserA======Kalpana//
            
            CSS_Job_Order__c cj12 = new CSS_Job_Order__c();//kalpana
            cj12  = css_testdata.createJobOrder(false); 
            cj12.Customer_Name__c = 'varun';
            
            CJ12.Assigned_To__c=newUser9A.id;
            CJ12.Additional_Tech1__c=newUser.id;
            CJ12.Additional_Tech2__c=newUser.id; 
            CJ12.Additional_Tech1__c=newUser.id;
            CJ12.Additional_Tech2__c=newUser.id;   
            CJ12.Additional_Tech3__c=newUser3A.id;
            cj12.Additional_Tech4__c=newUser4A.id;
            CJ12.Additional_Tech5__c=newUser5A.id;
            CJ12.Additional_Tech6__c=newUser6A.id;
            CJ12.Additional_Tech7__c=newUser7A.id;
            CJ12.Additional_Tech8__c=newUser8A.id;
            CJ12.Additional_Tech9__c=newUser9A.id;  
            CJ12.Date_In__c=System.now();
            CJ12.LastUpdateSubStatus__c=System.now();
            cj12.DSID__c='DSBDT2274';    
            cj12.Status__c='Intake Complete';
            // cj1.DSID__c='DSBDT2274';
            cj12.unit_number__c='12345';
            // cjo.Service_Model_N__c=12345;
            cj12.Shop_Work_Order__c='abcd';
            CJ12.JobLocation__c='Cummins Western Canada-Edmonton';  
            // cjo.dField='Visible';
            cj12.DSID_UpdateTimestamp__c=System.now();
            cj12.INSITE_UpdateTimeStamp__c=System.now();   
            cj12.Sub_Status__c='Escalated';
            cj12.Service_Model__c='test';
            cj12.RecentVisit__c=true;
            cj12.Repeat_Visit__c=true;         
            cj12.Status__c = 'Closed';
            
            jobList.add(cjo);  
            jobList.add(cj1);
            jobList.add(cjo1);
            jobList.add(cj12);
            
            insert jobList;
            
            //CSS_Job_Order__share jobOrderShare = new CSS_Job_Order__share(parentid=cjo.Id,UserOrGroupId=newUser2A.Id,AccessLevel='Edit',RowCause='CSS_Apex_AssignedTo_Sharing__c');===Commented Kalpana//
            CSS_Job_Order__share jobOrderShare = new CSS_Job_Order__share(parentid=cj1.Id,UserOrGroupId=newUser2A.Id,AccessLevel='Edit',RowCause='CSS_Apex_AssignedTo_Sharing__c');
            //insert  jobOrderShare;
            
            list<CSS_UserLocation__c> cssuserloc = new list<CSS_UserLocation__c>();
            CSS_UserLocation__c CSSLOC = new CSS_UserLocation__c(Location_code__c=CJO.JobLocation__c,IsActive__c=true);
            CSS_UserLocation__c CSSLOC1 = new CSS_UserLocation__c(Location_code__c=CJ12.JobLocation__c,IsActive__c=true);
            CSS_UserLocation__c CSSLOC2 = new CSS_UserLocation__c(Location_code__c=CJO1.JobLocation__c,IsActive__c=true);
            CSS_UserLocation__c CSSLOC3 = new CSS_UserLocation__c(Location_code__c=CJ1.JobLocation__c,IsActive__c=true);
            
            cssuserloc.add(CSSLOC);
            cssuserloc.add(CSSLOC1);
            cssuserloc.add(CSSLOC2);
            cssuserloc.add(CSSLOC3);
            insert cssuserloc;
            System.runAs(newUser) {
                
                CSS_JobOrderExtension_Edit_h.UserbyRoleWrap uwrap = new CSS_JobOrderExtension_Edit_h.UserbyRoleWrap();
                
                CSS_JobOrderExtension_Edit_h joe = new CSS_JobOrderExtension_Edit_h();
                string csj = CSS_JobOrderExtension_Edit_h.getlstServiceJob();
                string getlst = CSS_JobOrderExtension_Edit_h.getlstUserbyRole();
                
                //CSS_JobOrderExtension_Edit_h.certUserLIst(cjO.Service_Model__c, CJO.JobLocation__c);
                joe.getSubStatus();
                joe.setSelectedSubStatus('Triage & Diagnosis');
                joe.ServiceJobList = 'ServiceJobList';
                
                CSS_JobOrderExtension_Edit_h.updateAccount(cjo.id, CJO.NAME,cjo.Customer_Name__c,  String.ValueOf(newUser.Id), String.ValueOf(newUserA.Id), String.ValueOf(newUser2A.Id), String.ValueOf(newUser3A.Id), String.ValueOf(newUser4A.Id), String.ValueOf(newUser5A.Id), String.ValueOf(newUser6A.Id), String.ValueOf(newUser7A.Id), String.ValueOf(newUser8A.Id), String.ValueOf(newUser9A.Id));
                //CSS_JobOrderExtension_Edit_v1.updateAccount(cj.id, CJ.NAME,cj.Customer_Name__c, 'Varun Sinha');
            }
            
            /* cj.Customer_Name__c = 'Test2';
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
            cj.Sub_Status__c='Escalated';
            cj.Service_Model__c='test';
            cj.RecentVisit__c=true;
            cj.Repeat_Visit__c=true;
            insert cj; 
            System.runAs(newUser2A){
            String cjsids = cj.id;
            CSS_JobOrderExtension_Edit_h joe1 = new CSS_JobOrderExtension_Edit_h();
            string csj1 = CSS_JobOrderExtension_Edit_h.getlstServiceJob();
            string getlst1 = CSS_JobOrderExtension_Edit_h.getlstUserbyRole();
            CSS_JobOrderExtension_Edit_h.updateAccountSS(cjsids, CJ.Sub_Status__c);
            CSS_JobOrderExtension_Edit_h.updateAccount(cj.id, CJ.NAME,cj.Customer_Name__c, String.ValueOf(newUser.Id), String.ValueOf(newUserA.Id), String.ValueOf(newUser2A.Id), String.ValueOf(newUser3A.Id), String.ValueOf(newUser4A.Id), String.ValueOf(newUser5A.Id), String.ValueOf(newUser6A.Id), String.ValueOf(newUser7A.Id), String.ValueOf(newUser8A.Id), String.ValueOf(newUser9A.Id));
            } */
        }
        /* static  testMethod void Method2()
        {
        Profile p2 = [SELECT Id FROM Profile WHERE Name='CSS_Service_Technician' LIMIT 1];
        UserRole ur = [SELECT id from UserRole WHERE PortalType = 'None' LIMIT 1];
        User newUser9A = new User(Alias = 'standt9A', Email='test9A@gmail.com', UserRoleId = ur.Id ,
        EmailEncodingKey='UTF-8', LastName='Testing9A', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p2.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='test19AQnewUser@gmail.com');
        System.runAs(newUser9A){
        {
        
        CSS_Job_Order__c CJO = new CSS_Job_Order__c();
        //cjo.Customer_Name__c = 'varun';
        //CJO.Assigned_To__c=newUser.id;
        CJO.Additional_Tech1__c=newUser.id;
        CJO.Additional_Tech2__c=newUser.id;   
        CJO.Additional_Tech3__c=newUser3A.id;
        cjO.Additional_Tech4__c=newUser4A.id;
        CJO.Additional_Tech5__c=newUser5A.id;
        CJO.Additional_Tech6__c=newUser6A.id;
        CJO.Additional_Tech7__c=newUser7A.id;
        CJO.Additional_Tech8__c=newUser8A.id;
        CJO.Additional_Tech9__c=newUser9A.id;   
        CJO.JobLocation__c='7986';  
        CJO.Date_In__c=System.now();
        CJO.LastUpdateSubStatus__c=System.now();
        cjo.Status__c='Review';
        cjo.DSID__c='DSBDT2274';
        cjo.unit_number__c='12345';
        //    cjo.Service_Model_N__c=12345;
        cjo.Shop_Work_Order__c='abcd';
        // cjo.dField='Visible';
        cjo.DSID_UpdateTimestamp__c=System.now();
        cjo.INSITE_UpdateTimeStamp__c=System.now();
        cjo.Sub_Status__c='Escalated';
        cjo.Service_Model__c='test';
        cjo.RecentVisit__c=true;
        cjo.Repeat_Visit__c=true;
        
        //====Created Another Job Order with newUserA======Kalpana//
        
        CSS_Job_Order__c cj1 = new CSS_Job_Order__c();//kalpana
        cj1.Customer_Name__c = 'varun';
        
        CJ1.Assigned_To__c=newUserA.id;
        CJ1.Additional_Tech1__c=newUser.id;
        CJ1.Additional_Tech2__c=newUser.id; 
        CJ1.Additional_Tech1__c=newUser.id;
        CJ1.Additional_Tech2__c=newUser.id;   
        CJ1.Additional_Tech3__c=newUser3A.id;
        cj1.Additional_Tech4__c=newUser4A.id;
        CJ1.Additional_Tech5__c=newUser5A.id;
        CJ1.Additional_Tech6__c=newUser6A.id;
        CJ1.Additional_Tech7__c=newUser7A.id;
        CJ1.Additional_Tech8__c=newUser8A.id;
        CJ1.Additional_Tech9__c=newUser9A.id;  
        CJ1.Date_In__c=System.now();
        CJ1.LastUpdateSubStatus__c=System.now();
        cj1.DSID__c='DSBDT2274';    
        cj1.Status__c='Intake Complete';
        //cj1.DSID__c='DSBDT2274';
        cj1.unit_number__c='12345';
        //    cjo.Service_Model_N__c=12345;
        cj1.Shop_Work_Order__c='abcd';
        CJ1.JobLocation__c='7986';  
        // cjo.dField='Visible';
        cj1.DSID_UpdateTimestamp__c=System.now();
        cj1.INSITE_UpdateTimeStamp__c=System.now();   
        cj1.Sub_Status__c='Escalated';
        cj1.Service_Model__c='test';
        cj1.RecentVisit__c=true;
        cj1.Repeat_Visit__c=true;         
        insert cjo;  
        insert cj1;
        
        cj1.Status__c = 'Closed';
        update cj1;
        
        
        
        //CSS_Job_Order__share jobOrderShare = new CSS_Job_Order__share(parentid=cjo.Id,UserOrGroupId=newUser2A.Id,AccessLevel='Edit',RowCause='CSS_Apex_AssignedTo_Sharing__c');===Commented Kalpana//
        //CSS_Job_Order__share jobOrderShare = new CSS_Job_Order__share(parentid=cj1.Id,UserOrGroupId=newUser2A.Id,AccessLevel='Edit',RowCause='CSS_Apex_AssignedTo_Sharing__c');
        //insert  jobOrderShare;
        
        list<CSS_UserLocation__c> cssuserloc = new list<CSS_UserLocation__c>();
        CSS_UserLocation__c CSSLOC = new CSS_UserLocation__c(Location_code__c=CJO.JobLocation__c,IsActive__c=true);
        
        cssuserloc.add(CSSLOC);
        insert cssuserloc;
        
        //UserbyRoleWrap uwrap = new UserbyRoleWrap();
        
        CSS_JobOrderExtension_Edit_h joe = new CSS_JobOrderExtension_Edit_h();
        string csj = CSS_JobOrderExtension_Edit_h.getlstServiceJob();
        string getlst = CSS_JobOrderExtension_Edit_h.getlstUserbyRole();
        CSS_JobOrderExtension_Edit_h.certUserLIst(cjO.Service_Model__c, CJO.JobLocation__c);
        joe.getSubStatus();
        joe.setSelectedSubStatus('Triage & Diagnosis');
        //CSS_JobOrderExtension_Edit_h.updateAccount(cjo.id, CJO.NAME,cjo.Customer_Name__c, String.ValueOf(newUser9A.Id));
        //CSS_JobOrderExtension_Edit_v1.updateAccount(cj.id, CJ.NAME,cj.Customer_Name__c, 'Varun Sinha');
        } */
    }
    
    static testmethod void updateAccountSSMethod() {
        
        CSS_Job_Order__c cj = new CSS_Job_Order__c();
        cj.Sub_Status__c='Escalated';
        cj.LastUpdateSubStatus__c=System.now();
        insert cj;
        test.startTest();
        CSS_JobOrderExtension_Edit_h.updateAccountSS(cj.id,cj.Sub_Status__c);
        test.stopTest();
    }
    
    static testmethod void getlstServiceJobmethod() {
        
        Profile p = [SELECT Id,Name FROM Profile WHERE Name='CSS_Service_TECHNICIAN' LIMIT 1];
        String profileName = p.Name;
        system.debug('p>>>>>'+p.Name);
        UserRole ur = [SELECT id from UserRole WHERE PortalType = 'None' LIMIT 1];
        User newUser = new User(Alias = 'standt', Email='test1@gmail.com', UserRoleId = ur.Id ,
                                EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                LocaleSidKey='en_US', ProfileId = p.Id,User_Location__c = '03742-02991', 
                                TimeZoneSidKey='America/Los_Angeles', UserName='test11newUser@gmail.com');
        //insert newUser;
        
        CSS_Job_Order__c cj = new CSS_Job_Order__c();
        cj.Customer_Name__c = 'Test2';
        CJ.Assigned_To__c=newUser.id;
        CJ.Additional_Tech1__c=newUser.id;
        CJ.Additional_Tech2__c=newUser.id;
        cj.Additional_Tech3__c=newUser.id;
        cj.Additional_Tech4__c=newUser.id;
        cj.Additional_Tech5__c=newUser.id;
        cj.Additional_Tech6__c=newUser.id;
        cj.Additional_Tech7__c=newUser.id;
        cj.Additional_Tech8__c=newUser.id;
        cj.Additional_Tech9__c=newUser.id;
        cj.DSID_UpdateTimestamp__c=System.now();
        cj.INSITE_UpdateTimeStamp__c=System.now();
        cj.Sub_Status__c='Escalated';
        cj.Service_Model__c='test';
        cj.RecentVisit__c=true;
        cj.Repeat_Visit__c=true;
        cj.status__c = 'Repair';
        insert cj;
        
        CSS_Job_Order__share cjs = new CSS_Job_Order__share();
        cjs.ParentId = cj.Id;
        cjs.RowCause = 'CSS_Apex_AssignedTo_Sharing__c';
        cjs.UserOrGroupId = userInfo.getUserId();
        cjs.AccessLevel = 'Edit';
        insert cjs;
        test.startTest();
        String data = CSS_JobOrderExtension_Edit_h.getlstServiceJob();
        test.stopTest();
    }
    
    static testmethod void certUserLIstmethod() {
        
        CSS_Job_Order__c cj = new CSS_Job_Order__c();
        cj.Service_Model__c = 'Test';
        cj.JobLocation__c = '7986';
        insert cj;
        Account acc = new Account();
        acc.name='Rtest';
        acc.CSS_DistributorCode__c='562701';
        acc.IAM_Service_Provider_Code__c='562551';
        acc.Type='Dealer Account';
        acc.Region__c = 'US and Canada';
        acc.CMI_Account_Status__c = 'Active';
        acc.IAM_Service_Provider_Code__c = '562551';
        //acc.IAM_Service_Provider_Code__c = '33333';
        
        insert acc;
        CSS_UserLocation__c obj = new CSS_UserLocation__c();
        obj.Location_code__c = '7986';
        obj.IsActive__c = true;
        //obj.Location_Name__c = 'Bangalore';
        obj.AccountId__c = acc.id;
        insert obj;
        test.startTest();
        CSS_JobOrderExtension_Edit_h.certUserLIst(cj.Service_Model__c,cj.Service_Model__c);
        test.stopTest(); 
    }
}