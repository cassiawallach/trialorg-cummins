@IsTest(SeeAllData=false)
public class CSS_ServiceJobTriggerHelper_Test {
    
    static testMethod void testAddShares() {
        Test.startTest();
        UserRole empRole = [Select Id From UserRole Where Name = 'Factory' Limit 1];
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User objUser1 = new User(Alias = 'cmi-u1', Email='css-cmi1@cummins.com',
                                 EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                 LocaleSidKey='en_US', ProfileId = p.Id,UserRoleId = empRole.id,isActive=true, 
                                 TimeZoneSidKey='America/Los_Angeles', UserName='css-cmi7@cummins.com', User_Location__c='03520-04892');
        UserRole empRole1 = [Select Id From UserRole Where Name = 'DFSE-CUMMINS CENTRAL' Limit 1];
        User objUser3 = new User(Alias = 'cmi-u1', Email='css-cmi1@cummins.com',
                                 EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                 LocaleSidKey='en_US', ProfileId = p.Id,UserRoleId = empRole1.id,isActive=true,
                                 TimeZoneSidKey='America/Los_Angeles', UserName='css-cmi122@cummins.com', User_Location__c='03520-04892');
        insert objUser3;
       
        contact c;
        Account b;
        Account a;
       // Database.insert(objUser1);
        system.runAs(objUser1){
            b = new Account();
            b.Name ='ABC-Parent';
            b.OwnerId = objUser1.id;
            insert b;
            a = new Account();
           
            a.Name ='ABC-Child';
            a.ParentId = b.id;
            a.OwnerId = objUser1.id;
            a.Region__c = 'US and Canada';
            a.CMI_Account_Status__c = 'Active';
          a.IAM_Service_Provider_Code__c='45609';
            insert a;
            c = new Contact();
            c.FirstName = 'AB';
            c.AccountId = a.id;
            c.LastName = 'CD';
            c.CMI_Contact_Type__c = 'Secondary';
            c.IAM_Cummins_login_ID__c='CDAB@truck.com';
            c.IAM_Contact_Status__c = 'Active';
            c.Email = 'akanksha.p@gmail.com';
            c.Phone='000-000-0000';
          //  c.OwnerId = objUser1.id;
            insert c;
            
            account u1=[select id,ownerid from account where id=:a.id];
            accountteammember atm= new accountteammember();
            atm.AccountId=a.id;
            atm.userid=objUser3.id;
            atm.teammemberrole='HQ Oversight';
            insert atm;
        }
        
        UserRole portalRole1 = [Select Id From UserRole Where PortalType = 'CustomerPortal' Limit 1];
        Profile p1 = [SELECT Id FROM Profile WHERE Name='CSS_Dealer_Advanced' limit 1]; 
        User objUser2 = new User(Alias = 'cmi-u2', Email='testuser@cummins.com',
                                 EmailEncodingKey='UTF-8', LastName='Test', LanguageLocaleKey='en_US', 
                                 LocaleSidKey='en_US', ProfileId = p1.Id,contactId = c.id,PortalRole='Executive ',isActive=true,
                                 TimeZoneSidKey='America/Los_Angeles', UserName='test@cummins.com', User_Location__c='03520-04892');
        //insert objUser2;
        System.debug('The account id is'+objUser2.AccountId);
        system.runAs(objUser1){
            Group Que = new Group();
            Que.Type = 'Queue';
            //Que.OwnerId=objUser1.id;
            Que.Name = 'JQ'+'-'+'03520-04892';
                insert Que;
            QueueSObject q = new QueueSObject(SobjectType='CSS_Job_Order__c', QueueId=Que.Id);
insert q;
            system.debug('Que**'+Que);
            CSS_Job_Order__c obj = new CSS_Job_Order__c();
            // obj.ESN__c = '79586617';
            //obj.Mileage__c = 12345;
            //obj.Mileage_measure__c = 'Miles'; 
            obj.OwnerId = objUser1.id;
            //obj.Creator_Location__c = '123456';
            obj.CSS_Job_Location_Code__c = '03520-04892';
            insert obj;
            system.debug('obj**'+obj);
                
            //To increase code coverage
            List<CSS_Job_Order__c> cjo = new List<CSS_Job_Order__c>();
            cjo.add(obj);
            Map<Id,Id> mapAcntusrForParIds = new Map<Id,Id>();
            mapAcntusrForParIds.put(objUser2.id,objUser2.AccountId);
            Map<Id,Id> mapAcntusrForParIds1 = new Map<Id,Id>();
            mapAcntusrForParIds1.put(a.id,a.Id);
            Map<Id,List<Id>> mapAccountUsers = new Map<Id,List<Id>>();
            
            CSS_ServiceJobTriggerHelper csj = new CSS_ServiceJobTriggerHelper();
            csj.grantShareServJobs(mapAcntusrForParIds.values(),obj,'test');
           // csj.shareParentAccountUsers(mapAcntusrForParIds1,cjo);
            //Test.stopTest();
        }
       /*  system.runAs(objUser2){
            CSS_Job_Order__c obj = new CSS_Job_Order__c();
            // obj.ESN__c = '79586617';
            //obj.Mileage__c = 12345;
            //obj.Mileage_measure__c = 'Miles'; 
            obj.OwnerId = objUser2.id;
            //obj.Creator_Location__c = '123456';
             obj.CSS_Job_Location_Code__c = '03520-04892';
            insert obj;
            //To increase code coverage
            List<CSS_Job_Order__c> cjo = new List<CSS_Job_Order__c>();
            cjo.add(obj);
            Map<Id,Id> mapAcntusrForParIds = new Map<Id,Id>();
            mapAcntusrForParIds.put(objUser2.id,objUser2.AccountId);
            CSS_ServiceJobTriggerHelper csj = new CSS_ServiceJobTriggerHelper();
           // csj.shareParentAccountUsers(mapAcntusrForParIds,cjo);
            Test.stopTest();
        }*/
        Test.stopTest();
        
    }
     static testMethod void createJobhistoryRecordTest() {
                 Profile p = [SELECT Id 
                     FROM Profile 
                     WHERE Name='CSS_Service_Advanced' LIMIT 1];
        UserRole ur = [SELECT id 
                       from UserRole 
                       WHERE PortalType = 'None' LIMIT 1];
        User newUser = new User( Alias = 'standt', Email='test1@gmail.com', UserRoleId = ur.Id ,
                                EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                LocaleSidKey='en_US', ProfileId = p.Id,User_Location__c='bangalore',
                                TimeZoneSidKey='America/Los_Angeles', UserName='test11newUser@gmail.com');
        
        
        //insert newUser;
         id UserId = newUser.id;
             CSS_Job_Order__c SerRec1 = new  CSS_Job_Order__c();
             SerRec1 = CSS_TestData.createJobOrder(false);
               SerRec1.CreatedDate = date.today()-1;
              insert SerRec1;
         system.debug('SerRec1.Creator_Location__c'+SerRec1.Creator_Location__c);
                CSS_JobHistory__c hist = new CSS_JobHistory__c();
                hist.CSS_Object_Name__c = 'objName';
                hist.CSS_Job_Id__c = SerRec1.id;        
                hist.CSS_Field_Name__c = 'Status__c';
                hist.CSS_Old_Value__c = 'oldVal';
                hist.CSS_New_Value__c = 'newVal';
               insert hist;
         //CSS_ServiceJobTriggerHelper helper = new CSS_ServiceJobTriggerHelper();
        CSS_ServiceJobTriggerHelper.createJobhistoryRecord('objName', SerRec1.id, 'Status__c', 'oldVal', 'newVal');
         }
    static testMethod void updateFourCsTest() {
        list<CSS_Job_Order__c> lstNewServiceJob = new list<CSS_Job_Order__c>();
        map<id,CSS_Job_Order__c> mapOldServiceJob = new map<id,CSS_Job_Order__c>();
       list<CSS_JobHistory__c> lstjobhistory = new list<CSS_JobHistory__c>();
        CSS_Job_Order__c SerRec1 = new  CSS_Job_Order__c();
        SerRec1 = CSS_TestData.createJobOrder(false);
               SerRec1.CreatedDate = date.today()-1;
               SerRec1.EditComplaint__c = 'text';
         SerRec1.EditCause__c = 'text';
         SerRec1.EditCorrection__c = 'text';
         SerRec1.EditCoverage__c = 'text';
        SerRec1.DSID_Owner__c='abcf';
         SerRec1.Sub_Status__c='Claim in Progress';
         SerRec1.JobLocation__c='Claim ';
              insert SerRec1;
        CSS_Job_Order__c SerRec11 = new  CSS_Job_Order__c();
        SerRec11 = CSS_TestData.createJobOrder(false);
               SerRec11.CreatedDate = date.today()-1;
               SerRec11.EditComplaint__c = 'ascs';
         SerRec11.EditCause__c = 'aasd';
         SerRec11.EditCorrection__c = 'asdas';
         SerRec11.EditCoverage__c = 'asdsa';
        SerRec11.DSID_Owner__c='test';
        SerRec11.Sub_Status__c='Escalated';
        SerRec11.JobLocation__c='Clasfdim ';
              insert SerRec11;
        lstNewServiceJob.add(SerRec11);
        //lstNewServiceJob.add(SerRec1);
        mapOldServiceJob.put(SerRec11.id,SerRec1);
         CSS_JobHistory__c hist1 = new CSS_JobHistory__c();
                hist1.CSS_Object_Name__c = 'objName1';
                //hist1.CSS_Job_Id__c = SerRec1.id;        
                hist1.CSS_Field_Name__c = 'Status__c';
                hist1.CSS_Old_Value__c = 'oldVal';
                hist1.CSS_New_Value__c = 'newVal';
               insert hist1;
        lstjobhistory.add(hist1);
         CSS_JobHistory__c hist11 = new CSS_JobHistory__c();
                hist11.CSS_Object_Name__c = 'objName1';
                hist11.CSS_Job_Id__c = SerRec1.id;        
                hist11.CSS_Field_Name__c = 'Status__c';
                hist11.CSS_Old_Value__c = 'oldVal';
                hist11.CSS_New_Value__c = 'newVal';
               insert hist11;
        lstjobhistory.add(hist11);
        CSS_ServiceJobTriggerHelper.updateFourCs(lstNewServiceJob,mapOldServiceJob);
        CSS_ServiceJobTriggerHelper.trackDSIDOwner(lstNewServiceJob,mapOldServiceJob);
        CSS_ServiceJobTriggerHelper.trackVIN(lstNewServiceJob,mapOldServiceJob);
        CSS_ServiceJobTriggerHelper.updateSubStatus(lstNewServiceJob,mapOldServiceJob);
        CSS_ServiceJobTriggerHelper.insertLocation(lstNewServiceJob,mapOldServiceJob);
        
    }
    static testMethod void insertAssigneTest() {
        List<User> lstUser = new List<User>();
                UserRole empRole = [Select Id From UserRole Where Name = 'Factory' Limit 1];
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User objUser1 = new User(Alias = 'cmi-u1', Email='css-cmi8@cummins.com',
                                 EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', FirstName ='test',
                                 LocaleSidKey='en_US', ProfileId = p.Id,UserRoleId = empRole.id,isActive=true, 
                                 TimeZoneSidKey='America/Los_Angeles', UserName='css-cmi8@cummins.com', User_Location__c='123456');
        insert objUser1;
                User objUser12 = new User(Alias = 'cmi-u1', Email='css-cmi8@cummins.com',
                                 EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', FirstName ='test',
                                 LocaleSidKey='en_US', ProfileId = p.Id,UserRoleId = empRole.id,isActive=true, 
                                 TimeZoneSidKey='America/Los_Angeles', UserName='css-sddcmi8@cummins.com', User_Location__c='123456');
        insert objUser12;
        lstUser.add(objUser1);
        system.runAs(objUser1){
        list<CSS_Job_Order__c> lstNewServiceJob = new list<CSS_Job_Order__c>();
        map<id,CSS_Job_Order__c> mapOldServiceJob = new map<id,CSS_Job_Order__c>();
             Group Q = new Group();
            Q.Type = 'Queue';
            //Q.OwnerId=objUser1.id;
            Q.Name = 'JQ'+'-'+'03520-04892';
                insert Q;
            QueueSObject q1 = new QueueSObject(SobjectType='CSS_Job_Order__c', QueueId=Q.Id);
insert q1;
            system.debug('Q**'+Q);
        CSS_Job_Order__c firstJob = new  CSS_Job_Order__c();
               firstJob.CreatedDate = date.today()-1;
               firstJob.EditComplaint__c = 'text';
               firstJob.Additional_Tech3__c = objUser1.id;
             firstJob.OwnerId = objUser1.id;
            //obj.Creator_Location__c = '123456';
            firstJob.CSS_Job_Location_Code__c = '03520-04892';
              insert firstJob;
            //  lstNewServiceJob.add(firstjob);
              CSS_Job_Order__c secondjob = new  CSS_Job_Order__c();
               secondjob.CreatedDate = date.today()-1;
               secondjob.EditComplaint__c = 'text';
               secondjob.Additional_Tech3__c = objUser1.id;
            secondjob.OwnerId = objUser1.id;
            //obj.Creator_Location__c = '123456';
            secondjob.CSS_Job_Location_Code__c = '03520-04892';
            //secondjob.Additional_Tech3__c = 'text';
            secondjob.Additional_Tech4__c = objUser1.id;
            secondjob.Additional_Tech5__c = objUser1.id;
            secondjob.Additional_Tech6__c = objUser1.id;
            secondjob.Additional_Tech7__c = objUser1.id;
            secondjob.Additional_Tech8__c = objUser1.id;
            secondjob.Additional_Tech9__c = objUser1.id;
            secondjob.CSS_Job_Location_Code__c = '03520-04892';
              insert secondjob;
            CSS_Job_Order__c secondjob1 = new  CSS_Job_Order__c();
               secondjob1.CreatedDate = date.today()-1;
               secondjob1.EditComplaint__c = 'text';
               //secondjob1.Additional_Tech3__c = objUser1.id;
            secondjob1.OwnerId = objUser1.id;
            //obj.Creator_Location__c = '123456';
            secondjob1.CSS_Job_Location_Code__c = '03520-04892';
            secondjob1.Additional_Tech3__c = objUser12.id;
            secondjob1.Additional_Tech4__c = objUser12.Id;
            secondjob1.Additional_Tech5__c = objUser12.Id;
            secondjob1.Additional_Tech6__c = objUser12.Id;
            secondjob1.Additional_Tech7__c = objUser12.Id;
            secondjob1.Additional_Tech8__c = objUser12.Id;
            secondjob1.Additional_Tech9__c = objUser12.Id;
             secondjob1.CSS_Job_Location_Code__c = '03520-04892';
              insert secondjob1;
                          lstNewServiceJob.add(secondjob);
                CSS_Job_Order__c thirdjob = new  CSS_Job_Order__c();
               thirdjob.CreatedDate = date.today()-1;
               thirdjob.EditComplaint__c = 'text';
               thirdjob.Additional_Tech3__c = objUser1.id;
            thirdjob.OwnerId = objUser1.id;
            //obj.Creator_Location__c = '123456';
            thirdjob.CSS_Job_Location_Code__c = '03520-04892';
              insert thirdjob;
              CSS_Job_Order__c fourthjob = new  CSS_Job_Order__c();
               fourthjob.CreatedDate = date.today()-1;
               fourthjob.EditComplaint__c = 'text';
               fourthjob.Additional_Tech3__c = objUser1.id;
            fourthjob.OwnerId = objUser1.id;
            //obj.Creator_Location__c = '123456';
            fourthjob.CSS_Job_Location_Code__c = '03520-04892';
              insert fourthjob;
            List<CSS_Job_Order__c> fList =[select id,name,Creator_Location__c,EditComplaint__c,OwnerId,CSS_Job_Location_Code__c,Additional_Tech3__c,Additional_Tech4__c,Additional_Tech5__c,Additional_Tech6__c,Additional_Tech7__c,Additional_Tech8__c,Additional_Tech9__c,Add_Tech9__c,Add_Tech8__c,Add_Tech7__c,Add_Tech6__c,Add_Tech5__c,Add_Tech4__c,Add_Tech3__c from CSS_Job_Order__c where id =:secondjob.Id];
            List<CSS_Job_Order__c> fList1 =[select id,name,Creator_Location__c,EditComplaint__c,OwnerId,CSS_Job_Location_Code__c,Additional_Tech3__c,Additional_Tech4__c,Additional_Tech5__c,Additional_Tech6__c,Additional_Tech7__c,Additional_Tech8__c,Additional_Tech9__c,Add_Tech9__c,Add_Tech8__c,Add_Tech7__c,Add_Tech6__c,Add_Tech5__c,Add_Tech4__c,Add_Tech3__c from CSS_Job_Order__c where id =:secondjob1.Id];
            mapOldServiceJob.put(secondjob.id,fList1[0]);
              //mapOldServiceJob.put(secondJob.id,fourthjob);
            CSS_ServiceJobTriggerHelper.insertAssigne(fList,mapOldServiceJob);
            CSS_ServiceJobTriggerHelper sertrigger = new CSS_ServiceJobTriggerHelper();
        sertrigger.grantShareServJobs(lstUser,fourthjob,'test');
             CSS_ServiceJobTriggerHelper.changeOwnerInfo(fList);
            CSS_JobEventTemporary__c JETsys = new CSS_JobEventTemporary__c();
        JETsys.Attribute1__c = 'TH';
        JETsys.Attribute2__c = 'test';
        JETsys.Attribute3__c = 'TURBO';
        JETsys.Attribute4__c ='test12';
        JETsys.Attribute5__c = 'Y';
        JETsys.key__c = 'getFailureCodesSRT';
        JETsys.Reason__c = '{\r\n\t\"Header\": {\r\n\t\t\"ReturnCodeDescription\": \"Normal, Successful completion.\",\r\n\t\t\"ReturnCode\": \"ORA-00000\",\r\n\t\t\"MessageIdentifier\": \"S\"\r\n\t},\r\n\t\"DataArea\": [{\r\n\t\t\"SystemCode\": \"WF\",\r\n\t\t\"FailureName\": \"ATC 1795\",\r\n\t\t\"FailureMode\": \"SP\",\r\n\t\t\"FailureID\": \"F30003750\",\r\n\t\t\"ComponentCode\": \"HA\"\r\n\t}]\r\n}';
        insert JETsys;
            List<String> smn_engcode = new List<String>();
            smn_engcode.add('TUR;;BO');
             CSS_ServiceJobTriggerHelper.failureCodeToJobEventTemp(smn_engcode);
        }
        
    }
    static testMethod void afterUpdateShareJobsToUserTest() {
        UserRole empRole = [Select Id From UserRole Where Name = 'Factory' Limit 1];
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        List<User> lstUser = new List<User>();
        User objUser1 = new User(Alias = 'cmi-u1', Email='css-cmi1@cummins.com',
                                 EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                 LocaleSidKey='en_US', ProfileId = p.Id,UserRoleId = empRole.id,isActive=true, 
                                 TimeZoneSidKey='America/Los_Angeles', UserName='css-cmi1@cummins.com', User_Location__c='03520-04892');
        insert objUser1;
        lstUser.add(objUser1);
        User objUser2 = new User(Alias = 'cmi-u1', Email='css-cmi2@cummins.com',
                                 EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                 LocaleSidKey='en_US', ProfileId = p.Id,UserRoleId = empRole.id,isActive=true, 
                                 TimeZoneSidKey='America/Los_Angeles', UserName='css-cmi2@cummins.com', User_Location__c='03520-04892');
        insert objUser2;
        system.runAs(objUser1){
         CSS_Job_Order__c secondjob1 = new  CSS_Job_Order__c();
               secondjob1.CreatedDate = date.today()-1;
               secondjob1.EditComplaint__c = 'text';
               //secondjob1.Additional_Tech3__c = objUser1.id;
            secondjob1.OwnerId = objUser2.id;
            //obj.Creator_Location__c = '123456';
            secondjob1.CSS_Job_Location_Code__c = '03520-04892';
            secondjob1.Additional_Tech3__c = objUser2.id;
            secondjob1.Additional_Tech4__c = objUser2.Id;
            secondjob1.Additional_Tech5__c = objUser2.Id;
            secondjob1.Additional_Tech6__c = objUser2.Id;
            secondjob1.Additional_Tech7__c = objUser2.Id;
            secondjob1.Additional_Tech8__c = objUser2.Id;
            secondjob1.Additional_Tech9__c = objUser2.Id;
             secondjob1.CSS_Job_Location_Code__c = '03520-04892';
              insert secondjob1;
        lstUser.add(objUser2);
       // CSS_Job_Order__c jo = CSS_TestData.createJobOrder(true);
        CSS_ServiceJobTriggerHelper.afterUpdateShareJobsToUser(lstUser);
        }
    }
}