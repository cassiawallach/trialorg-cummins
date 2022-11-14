@isTest
public class CSS_ServiceJobController_Test {
    static testmethod void CSS_ServiceJobController_Test_Method(){
    /*    CSS_Job_Order__c jo = CSS_TestData.createJobOrder(True);
         Test.startTest(); 
        string uid = UserInfo.getUserId();
        system.debug('uid>>>'+uid);
        CSS_ServiceJobController sjob = new CSS_ServiceJobController();
        CSS_ServiceJobController.UserbyRoleWrap sjobwrap = new CSS_ServiceJobController.UserbyRoleWrap();
        CSS_ServiceJobController.certUserLIst('jobsmn','1234');
        CSS_ServiceJobController.getlstServiceJob();
       CSS_ServiceJobController.getlstUserbyRole();
       // String userRole = CSS_ServiceJobControllerTechnician.getlstUserbyRole();
        CSS_ServiceJobController.updateAccountSS(jo.id,'none');
        CSS_ServiceJobController.updateAccount(jo.id,'test','test1',uid, uid,uid,uid,uid,uid,uid,uid,uid,uid);
        CSS_ServiceJobController.CustomSearchJobs('Test');
       // CSS_ServiceJobController.certSMN('wr');
        sjob.ServiceJobList = 'krish';
        
        CSS_ServiceJobController.fetchLocationValues();
       Test.stopTest();  */    
           CSS_Job_Order__c jo = CSS_TestData.createJobOrder(True);
        Profile p = [SELECT Id FROM Profile WHERE Name='CSS_Dealer_Technician'];
        User objUser1 = new User(Alias = 'cmi-u1', Email='css-cmi1@cummins.com',
                                 EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                 LocaleSidKey='en_US', ProfileId = p.Id,isActive=true, 
                                 TimeZoneSidKey='America/Los_Angeles', UserName='css-cmi1@cummins.com', User_Location__c='123456');
        string uid = UserInfo.getUserId();
        Id profileId=userinfo.getProfileId();
            String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
              Test.startTest();     
                CSS_ServiceJobController sjobt = new CSS_ServiceJobController();
        sjobt.ServiceJobList = 'job2';
        CSS_ServiceJobController.UserbyRoleWrap sjobwrap = new CSS_ServiceJobController.UserbyRoleWrap();
        
      //  CSS_ServiceJobController.ServiceJobWrap sjobwrap2 = new CSS_ServiceJobController.ServiceJobWrap();
        String customSearch = CSS_ServiceJobController.CustomSearchJobs('Test');
          String userRole = CSS_ServiceJobController.getlstUserbyRole();
        CSS_ServiceJobController.certUserLIst('jobsmn','1234');
        CSS_ServiceJobController.updateAccount(jo.id,'test','test1',uid, uid,uid,uid,uid,uid,uid,uid,uid,uid);
        CSS_ServiceJobController.updateAccountSS(jo.id,'none');
        CSS_ServiceJobController.getlstServiceJob();


              Test.stopTest();
    }
     static testmethod void CSS_SJCTechnician_Test_Method1() {
        Test.startTest(); 
        CSS_ServiceJobController.fetchLocationValues();
        Test.stopTest();
    }
    static testMethod void testingmethod2(){
        CSS_ServiceJobController obj = new CSS_ServiceJobController();
        obj.ServiceJobList = 'Sample';
        CSS_ServiceJobController.whClause='where Status__c!=null';
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator' LIMIT 1];
        Profile p1 = [SELECT Id FROM Profile WHERE Name='CSS_Service_Technician' LIMIT 1];
        Profile p2 = [SELECT Id FROM Profile WHERE Name='CSS_Service_TECHNICIAN' LIMIT 1];
        UserRole ur = [SELECT id from UserRole WHERE PortalType = 'None' LIMIT 1];
       List < User> lstUser=new List < User>();
        
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
        insert newUserA;
         insert newUser3A;       
        insert newUser4A;       
        insert newUser5A;       
        insert newUser6A;       
        insert newUser7A;       
        insert newUser8A;       
        insert newUser9A;
       lstUser.add(newUser);
       lstUser.add(newUser2A);
       lstUser.add(newUserA);
       lstUser.add(newUser3A);
       lstUser.add(newUser4A);
       lstUser.add(newUser5A);
       lstUser.add(newUser6A);
       lstUser.add(newUser7A);
       lstUser.add(newUser8A);
       lstUser.add(newUser9A);
           
        
        CSS_Job_Order__c cjo = new CSS_Job_Order__c();
       cjo = CSS_TestData.createJobOrder(false); 
        CSS_Job_Order__c cj = new CSS_Job_Order__c();
        cj = CSS_TestData.createJobOrder(false); 
         CSS_Job_Order__c cj2 = new CSS_Job_Order__c();
          cj2 = CSS_TestData.createJobOrder(false); 
        CSS_Job_Order__c cj1 = new CSS_Job_Order__c();
        cj1 = CSS_TestData.createJobOrder(false);
        List<CSS_Job_Order__c> cjlst = new List<CSS_Job_Order__c>();
        System.runAs(newUser){
            
            cjo.Customer_Name__c = 'varun';
            CJO.Assigned_To__c=newUser.id;
            CJO.Additional_Tech1__c=newUser.id;
            CJO.Additional_Tech2__c=newUser.id;    
            cjo.Status__c='Closed';
            cjo.DSID__c='DSBDT2274';
            cjo.unit_number__c='12345';
            cjo.Shop_Work_Order__c='abcd';
            cjo.DSID_UpdateTimestamp__c=System.now();
            cjo.INSITE_UpdateTimeStamp__c=System.now();
            cjo.Sub_Status__c='Escalated';
            cjo.Service_Model__c='test';
            cjo.RecentVisit__c=true;
            cjo.Repeat_Visit__c=true;
            insert cjo;
            cj1.Customer_Name__c = 'varun';
            CJ1.Assigned_To__c=newUserA.id;
            CJ1.Additional_Tech1__c=newUser.id;
            CJ1.Additional_Tech2__c=newUser.id;    
            cj1.Status__c='Closed';
            cj1.Sub_Status__c='Escalated';
            cj1.Service_Model__c='test';
            cj1.RecentVisit__c=true;
            cj1.Repeat_Visit__c=true;
            cj1.unit_number__c='12345';
            cj1.Additional_Tech3__c=newUser3A.id;
            cj1.Additional_Tech4__c=newUser4A.id;
            cj1.Additional_Tech5__c=newUser5A.id;
            cj1.Additional_Tech6__c=newUser6A.id;
            cj1.Additional_Tech7__c=newUser.id;
            cj1.Additional_Tech8__c=newUserA.id;
            cj1.Additional_Tech9__c=newUser.id;
            cj1.Shop_Work_Order__c='abcd';
            cj1.DSID_UpdateTimestamp__c=System.now();
            cj1.INSITE_UpdateTimeStamp__c=System.now();            
              
             insert cj1;
            
            
            CSS_Job_Order__share jobOrderShare = new CSS_Job_Order__share(parentid=cj1.Id,UserOrGroupId=newUser2A.Id,AccessLevel='Edit',RowCause='CSS_Apex_AssignedTo_Sharing__c');
            insert  jobOrderShare;
            CSS_Job_Order__share jobOrderShare1 = new CSS_Job_Order__share(parentid=cj1.Id,UserOrGroupId=newUserA.Id,AccessLevel='Edit',RowCause='CSS_Apex_AssignedTo_Sharing__c');
           // insert  jobOrderShare1;
            
            
            CSS_ServiceJobController joe = new CSS_ServiceJobController();
            CSS_ServiceJobControllerTechnician.ServiceJobWrap sjobnew= new CSS_ServiceJobControllerTechnician.ServiceJobWrap(); 
           sjobnew.showBold=true;
                sjobnew.id='1234';
                sjobnew.name='anu';
            sjobnew.LastSaved='';
            sjobnew.LastSaved_sort='';
            sjobnew.Customer_Name='';
          
            // Location story start
            sjobnew.Job_Location='';
            // Location story start
            sjobnew.Assigned_To='';
            sjobnew.Assigned='';

            sjobnew.Assigned_To1='';
            sjobnew.AssignedTech1='';
            sjobnew.Assigned_To2='';
            sjobnew.AssignedTech2='';
            sjobnew.Assigned_To3='';
            sjobnew.AssignedTech3='';
            sjobnew.Assigned_To4='';
            sjobnew.AssignedTech4='';
            sjobnew.Assigned_To5='';
            sjobnew.AssignedTech5='';
            sjobnew.Assigned_To6='';
            sjobnew.AssignedTech6='';
            sjobnew.Assigned_To7='';
            sjobnew.AssignedTech7='';
            sjobnew.Assigned_To8='';
            sjobnew.AssignedTech8='';
            sjobnew.Assigned_To9='';
            sjobnew.AssignedTech9='';
            sjobnew.DSID='';
            sjobnew.Date_In='';
            sjobnew.Date_In_sort='';
            sjobnew.Status='';
            sjobnew.Sub_Status ='';
            sjobnew.LastUpdateSubStatus = '';            
            sjobnew.Unit_Number='';
            sjobnew.Service_Model='';
            sjobnew.Shop_s_Work_Order='';
            sjobnew.dField='';
            sjobnew.Created_Time_Zone='';
            sjobnew.Created_Time_sort='';
            sjobnew.jobLocation='';
            
            CSS_ServiceJobController.whClause='where Status__c!=null';
            string csj = CSS_ServiceJobController.getlstServiceJob();
            string getlst = CSS_ServiceJobController.getlstUserbyRole();
     
            CSS_ServiceJobController.updateAccount(cjo.id, CJO.NAME,cjo.Customer_Name__c, String.ValueOf(newUser.Id), String.ValueOf(newUserA.Id), String.ValueOf(newUser2A.Id), String.ValueOf(newUser3A.Id), String.ValueOf(newUser4A.Id), String.ValueOf(newUser5A.Id), String.ValueOf(newUser6A.Id), String.ValueOf(newUser7A.Id), String.ValueOf(newUser8A.Id), String.ValueOf(newUser9A.Id));
        }
        
       
         
            System.runAs(newUser2A){
            cj.Customer_Name__c = 'varun';
            cj.Status__c='Intake Complete';
            CJ.Assigned_To__c=newUser2A.id;
            CJ.Additional_Tech1__c=newUser.id;
            CJ.Additional_Tech2__c=newUser.id;
            cj.Additional_Tech3__c=newUser3A.id;
            cj.Additional_Tech4__c=newUser4A.id;
            cj.Additional_Tech5__c=newUser5A.id;
            cj.Additional_Tech6__c=newUser6A.id;
            cj.Sub_Status__c='Escalated';
            cj.Service_Model__c='test';
            cj.RecentVisit__c=true;
            cj.Repeat_Visit__c=true;
            cj.Additional_Tech7__c=newUser7A.id;
            cj.Additional_Tech8__c=newUser8A.id;
            cj.Additional_Tech9__c=newUser9A.id;
            cj.DSID_UpdateTimestamp__c=System.now();
            cj.INSITE_UpdateTimeStamp__c=System.now();
              insert cj;  
            cjlst.add(cj);
            cjlst.add(cj1);
            cjlst.add(cjo);
            System.debug('cjlst***'+cjlst);
                
                
            //insert cjlst; 
            
            
            CSS_ServiceJobController joe1 = new CSS_ServiceJobController();
            CSS_ServiceJobController.whClause='where Status__c!=null';
            string csj1 = CSS_ServiceJobController.getlstServiceJob();
            string getlst1 = CSS_ServiceJobController.getlstUserbyRole();
     
           // CSS_ServiceJobController.updateAccount(cj1.id, cj1.NAME,cj1.Customer_Name__c,String.ValueOf(newUser.Id), String.ValueOf(newUserA.Id), String.ValueOf(newUser2A.Id), String.ValueOf(newUser3A.Id), String.ValueOf(newUser4A.Id), String.ValueOf(newUser5A.Id), String.ValueOf(newUser6A.Id), String.ValueOf(newUser7A.Id), String.ValueOf(newUser8A.Id), String.ValueOf(newUser9A.Id));
        }
        
        System.runAs(newUserA){
            cj2.Customer_Name__c = 'varun';
            cj2.Status__c='Review';
            cj2.Assigned_To__c=newUserA.id;
            cj2.Additional_Tech1__c=newUser.id;
            cj2.Additional_Tech2__c=newUser.id;
            cj2.Additional_Tech3__c=newUser3A.id;
            cj2.Additional_Tech4__c=newUser4A.id;
            cj2.Additional_Tech5__c=newUser5A.id;
            cj2.Additional_Tech6__c=newUser6A.id;
            cj2.Additional_Tech7__c=newUser7A.id;
            cj2.Sub_Status__c='Escalated';
            cj2.Service_Model__c='test';
            cj2.RecentVisit__c=true;
            cj2.Repeat_Visit__c=true;
            cj2.Additional_Tech8__c=newUser8A.id;
            cj2.Additional_Tech9__c=newUser9A.id;
            cj2.DSID_UpdateTimestamp__c=System.now();
            cj2.INSITE_UpdateTimeStamp__c=System.now();
            insert cj2; 
            system.debug('cj2>>>'+cj2);
            CSS_ServiceJobController joe1 = new CSS_ServiceJobController();
            CSS_ServiceJobController.whClause='where Status__c!=null';
            string csj1 = CSS_ServiceJobController.getlstServiceJob();
            string getlst1 = CSS_ServiceJobController.getlstUserbyRole();
     
           // CSS_ServiceJobController.updateAccount(cj2.id, cj2.NAME,cj2.Customer_Name__c,String.ValueOf(newUser.Id), String.ValueOf(newUserA.Id), String.ValueOf(newUser2A.Id), String.ValueOf(newUser3A.Id), String.ValueOf(newUser4A.Id), String.ValueOf(newUser5A.Id), String.ValueOf(newUser6A.Id), String.ValueOf(newUser7A.Id), String.ValueOf(newUser8A.Id), String.ValueOf(newUser9A.Id));
        }
        
        
    }
    
    
    static testmethod void CSS_ServiceJobControllerTechnician_Test_Method(){
        CSS_Job_Order__c jo = CSS_TestData.createJobOrder(True);
         Test.startTest(); 
        string uid = UserInfo.getUserId();
        system.debug('uid>>>'+uid);
        CSS_ServiceJobController sjob = new CSS_ServiceJobController();
        CSS_ServiceJobController.UserbyRoleWrap sjobwrap = new CSS_ServiceJobController.UserbyRoleWrap();
        CSS_ServiceJobController.certUserLIst('jobsmn','1234');
        CSS_ServiceJobController.getlstServiceJob();
        CSS_ServiceJobController.getlstUserbyRole();
        CSS_ServiceJobController.updateAccountSS(jo.id,'none');
        CSS_ServiceJobController.updateAccount(jo.id,'test','test1',uid, uid,uid,uid,uid,uid,uid,uid,uid,uid);
        CSS_ServiceJobController.CustomSearchJobs('Test');
        sjob.ServiceJobList = 'krish';
        CSS_ServiceJobController.fetchLocationValues();
       Test.stopTest();       
    }
     static testmethod void CSS_ServiceJobControllerTechnician_Test_Method1() {
Test.startTest(); 
        CSS_ServiceJobController sjob = new CSS_ServiceJobController();
        sjob.ServiceJobList = 'krish';
        CSS_ServiceJobController.fetchLocationValues();
        Test.stopTest();
    }
    
    // CSS_ServiceJobController.whClause='where Status__c!=null';
            string csj = CSS_ServiceJobController.getlstServiceJob();
            string getlst = CSS_ServiceJobController.getlstUserbyRole();
    static testmethod void CSS_ServiceJobController_Test_Method1() {
      Test.startTest(); 
        CSS_ServiceJobController sjob = new CSS_ServiceJobController();
        sjob.ServiceJobList = 'krish';
       // sjob.certSMN = 'te';
        CSS_ServiceJobController.fetchLocationValues();
        Test.stopTest();
    }
}