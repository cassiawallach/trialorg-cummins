@isTest
public class CG_CL_IntakeCustNoERP_Test {
    
    Public String test;
    
    static testMethod void CG_CL_IntakeCustNoERP_TestMethod() 
    {
        String test = 'testing';
        CG_CL_IntakeVH VH = new CG_CL_IntakeVH();
        CG_CL_IntakeRJ RJ = new CG_CL_IntakeRJ();
        CG_CL_IntakeWarranty WR = new CG_CL_IntakeWarranty();
        CG_CL_IntakeCustomer obj1 = new CG_CL_IntakeCustomer();
        
        list<account> lstAcc = new list<Account>();
        
        Profile p = [SELECT Id FROM Profile WHERE Name='CSS_Service_Advanced']; 
        User u = new User(Alias = 'standt', Email='standarduser4@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US',  ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTestUser4@testorg.com',User_Location__c = 'location');
        insert u;
        
        list<CSS_UserLocation__c> lstUsrLoc =new list<CSS_UserLocation__c>();
        
        Account a= new Account();
        a.name='Rtest';
        a.CSS_DistributorCode__c='56270';
        a.BMS_Enabled__c = true;
        a.IAM_Service_Provider_Code__c = '56270';
        a.Type = 'Customer';
        a.CMI_Account_Status__c = 'Active';
        lstAcc.add(a);
        
        Account a1= new Account();
        a1.name='Rtest';
        a1.CSS_DistributorCode__c='56271';
        a1.IAM_Service_Provider_Code__c='56271';
        a1.BMS_Enabled__c = true;
        a1.Type = 'Customer';
        a1.CMI_Account_Status__c = 'Active';
        lstAcc.add(a1);
        
        Account a2= new Account();
        a2.name='Rtest';
        a2.CSS_DistributorCode__c='56272';
        a2.IAM_Service_Provider_Code__c='56272';
        a2.BMS_Enabled__c = false;
        lstAcc.add(a2);
        insert lstAcc;
        
        CSS_UserLocation__c userLocation = new CSS_UserLocation__c(AccountId__c=lstAcc[0].id,isActive__c=true,isPrimary__c=true,UserId__c=u.Id,Location_code__c='56270-56270');
        CSS_UserLocation__c userLocation1 = new CSS_UserLocation__c(AccountId__c=lstAcc[1].id,isActive__c=true,isPrimary__c=false,UserId__c=u.Id,Location_code__c='56271-56271');
        CSS_UserLocation__c userLocation2 = new CSS_UserLocation__c(AccountId__c=lstAcc[2].id,isActive__c=true,isPrimary__c=false,UserId__c=u.Id,Location_code__c='56272-56272');
        lstUsrLoc.add(userLocation);
        lstUsrLoc.add(userLocation1);
        lstUsrLoc.add(userLocation2);
        insert lstUsrLoc;
        
        Cache.Session.put('UserERPSystem', 'No ERP System');
        system.debug('----ERPTst' +Cache.Session.get('UserERPSystem'));
        CG_CL_IntakeCustNoERP obj = new CG_CL_IntakeCustNoERP();
        obj.mainContrVH = VH;
        obj.mainContrRJ = RJ;
        obj.mainContrWR = WR;
        obj.mainContr = obj1;
        obj.getLocationsName();
        obj.changeLocation();
        
        obj.getLocationLabel(test);
        obj.AppointmentName = 'test1';
        obj.datebyLocaleValue = 'test2';
        obj.cacheSL = 'test3';
        obj.PageName = 'test4';
        obj.getRepairLocation();
        
        
    }
}