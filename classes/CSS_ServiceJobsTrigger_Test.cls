@isTest
public class CSS_ServiceJobsTrigger_Test {
    
    /*   @isTest static void createJobOrder(){    

Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator' LIMIT 1];
UserRole ur = [SELECT id from UserRole WHERE PortalType = 'None' LIMIT 1];
User newUser = new User(Alias = 'standt', Email='test1@gmail.com', UserRoleId = ur.Id ,
EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
LocaleSidKey='en_US', ProfileId = p.Id, 
TimeZoneSidKey='America/Los_Angeles', UserName='test11newUser@gmail.com');
insert newUser;
system.runAs(newUser){
CSS_Trigger_Controller__c triggerActive = new CSS_Trigger_Controller__c();
triggerActive.Name = 'Service Job Trigger';
triggerActive.Service_Job_Trigger_Active__c = true;
insert triggerActive;

Account acc = new Account();
acc.name='Kenworth Sales Co';
acc.CSS_DistributorCode__c='02466';
acc.Data_Exchange_Enabled__c = true;
acc.IAM_Service_Provider_Code__c='19134';
acc.Type='Dealer Account';
acc.CMI_Account_Status__c = 'Active';
insert acc;

css_job_order__c jo = new css_job_order__c();
jo.Customer_Name__c='Oliver Trucking';
jo.ESN__c='79963677';
insert jo;

jo.Status__c = 'Intake';
Update Jo;

jo.AccessCode__c = 'test';
Delete Jo;

list<CSS_JobEventTemporary__c>  campTsbList = new  list<CSS_JobEventTemporary__c> ();
CSS_JobEventTemporary__c jobEtemp = new CSS_JobEventTemporary__c();
jobEtemp.Key__c = '79963677';
jobEtemp.Name = 'QSOL';
//  insert jobEtemp;

campTsbList.add(jobEtemp);
insert campTsbList;
}
} */
    
    
    @isTest static void createJobOrder2(){
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator' LIMIT 1];
        UserRole ur = [SELECT id from UserRole WHERE PortalType = 'None' LIMIT 1];
        User newUser = new User(Alias = 'standt', Email='test1@gmail.com', UserRoleId = ur.Id ,
                                EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                LocaleSidKey='en_US', ProfileId = p.Id, 
                                TimeZoneSidKey='America/Los_Angeles', UserName='test11newUser@gmail.com');
        insert newUser;
        //     system.runAs(newUser){
        system.runas(new User(Id=UserInfo.getUserId())){
            
            CSS_Trigger_Controller__c triggerActive = new CSS_Trigger_Controller__c();
            triggerActive.Name = 'Service Job Trigger';
            triggerActive.Service_Job_Trigger_Active__c = true;
            insert triggerActive;
            
            Account acc = new Account();
            acc.name='Kenworth Sales Co';
            acc.CSS_DistributorCode__c='02466';
            acc.Data_Exchange_Enabled__c = true;
            acc.IAM_Service_Provider_Code__c='19134';
            acc.Type='Dealer Account';
            acc.CMI_Account_Status__c = 'Active';
            insert acc;
            
            List<CSS_UserLocation__c> usrLocLst = new List<CSS_UserLocation__c>();
            
            CSS_UserLocation__c usrLoc = new CSS_UserLocation__c(); 
            usrLoc.Name = 'TestLoc1';
            usrLoc.Location_code__c = '03520-04892';
            usrLoc.isActive__c = true;
            usrLoc.isPrimary__c = true;
            usrLocLst.add(usrLoc);
            
            CSS_UserLocation__c usrLoc1 = new CSS_UserLocation__c(); 
            usrLoc1.Name = 'TestLoc2';
            usrLoc1.Location_code__c = '56270-56255';
            usrLoc1.isActive__c = true;
            usrLoc1.isPrimary__c = true;
            usrLocLst.add(usrLoc1);
            
            insert usrLocLst;
            
            css_header_nav__c ch = new css_header_nav__c(SetupOwnerId = UserInfo.getUserId());
            ch.EnablePeersSharing__c = true;
            insert ch;        
            
            css_job_order__c jo = new css_job_order__c();
            jo.Customer_Name__c='Oliver Trucking';
            jo.ESN__c='79963677';
            insert jo;
            
            
            jo.Status__c = 'Intake';
            Update Jo;
            
            jo.AccessCode__c = 'test';
            Delete Jo;
            css_job_order__c jo1 = new css_job_order__c();
            jo1.Customer_Name__c='Oliver Trucking';
            jo1.ESN__c='79963677';
            insert jo1;
            list<CSS_JobEventTemporary__c>  campTsbList = new  list<CSS_JobEventTemporary__c> ();
            CSS_JobEventTemporary__c jobEtemp = new CSS_JobEventTemporary__c();
            jobEtemp.Key__c = '79963677';
            jobEtemp.Name = 'QSOL';
            //  insert jobEtemp;
            
            campTsbList.add(jobEtemp);
            insert campTsbList;
        }
    }
    
    @isTest static void createJobOrder21(){
        /*  Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator' LIMIT 1];
UserRole ur = [SELECT id from UserRole WHERE PortalType = 'None' LIMIT 1];
User newUser = new User(Alias = 'standt', Email='test1@gmail.com', UserRoleId = ur.Id ,
EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
LocaleSidKey='en_US', ProfileId = p.Id, 
TimeZoneSidKey='America/Los_Angeles', UserName='test11newUser@gmail.com');
insert newUser;*/
        system.runas(new User(Id=UserInfo.getUserId())){
            CSS_accountLanguage__c c = new CSS_accountLanguage__c();
            c.CSS_QsolLanguage__c = 'test';
            c.name = 'en_US';
            insert c;
            CSS_Trigger_Controller__c triggerActive = new CSS_Trigger_Controller__c();
            triggerActive.Name = 'Service Job Trigger';
            triggerActive.Service_Job_Trigger_Active__c = true;
            insert triggerActive;
            
            list<CSS_JobEventTemporary__c>  campTsbList = new  list<CSS_JobEventTemporary__c> ();
            CSS_JobEventTemporary__c jobEtemp = new CSS_JobEventTemporary__c();
            jobEtemp.Key__c = '79963677';
            jobEtemp.Name = 'QSOL';
            insert jobEtemp;
            CSS_JobEventTemporary__c jobEtemp1 = new CSS_JobEventTemporary__c();
            jobEtemp1.Key__c = '79963677';
            jobEtemp1.Name = 'QSOL';
            insert jobEtemp1;
            CSS_JobEventTemporary__c jobEtemp12 = new CSS_JobEventTemporary__c();
            jobEtemp12.Key__c = '7993677';
            jobEtemp12.Name = 'QSOL';
            insert jobEtemp12;
            css_header_nav__c du=new css_header_nav__c();
            du.RSWButtonEnable__c=true;
            du.EnablePeersSharing__c=true;
            insert du;
            list<CSS_JobEventTemporary__c>  campTsbList1 = [select id , name , key__c from CSS_JobEventTemporary__c]; 
            system.debug('campTsbList1 '+campTsbList1);
            test.startTest();
            
            css_job_order__c jo1 = new css_job_order__c();
            jo1.Customer_Name__c='Oliver Trucking';
            jo1.ESN__c='79963677';
            jo1.DSID_Owner__c = 'tes';
            jo1.VIN__c = 'tes';
            jo1.DSID__c = 'tes';
            jo1.Customer_Name__c = 'tes';
            insert jo1;
            jo1.VIN_Flag__c = true;
            jo1.DSID_Owner__c = 'tesaa';
            jo1.VIN__c = 'tessds';
            jo1.DSID__c = 'tes1';
            jo1.Customer_Name__c = 'tessdas';
            jo1.ESN__c='7993677';
            update jo1;
            test.stopTest();}
    }
    
    
}