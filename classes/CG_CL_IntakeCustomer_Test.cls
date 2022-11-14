@isTest(seealldata = false)
public class CG_CL_IntakeCustomer_Test {
    
    static testMethod void CG_CL_IntakeCustomer_Test_TestMethod2() {
        CG_CL_IntakeVH VH = new CG_CL_IntakeVH();
        CG_CL_IntakeRJ RJ = new CG_CL_IntakeRJ();
        CG_CL_IntakeWarranty WR = new CG_CL_IntakeWarranty();
        //userERPSystem = 'BMS Legacy';
        CSS_Job_Order__c JO = new CSS_Job_Order__c();
        JO.Customer_Name__c = 'Roopa';
        JO.Application__c = 'Recreational Vehicle';
        JO.Model__c = 'RoopaTest';
        JO.Make__c = 'CSSTest';
        JO.Notes__c = 'CAMPCOMMENTS';
        JO.Failure_Point__c = 122;
        JO.Failure_Point_Measure__c = 'Miles';
        JO.VIN__c = '12345677890';
        JO.Failure_Date__c = date.today() - 20;
        JO.Warranty_Start_Date__c = date.today() - 365;
        JO.Location_Certification__c = 'abc';
        JO.jobLocation__c = 'abc';
        JO.Before_In_Service__c = True;
        //JO.lo = 10;
        //JO.Shop_s_Work_Order__c = 120;
        JO.Status__c = 'Repair Complete';
        JO.Unit_Number__c = 'test123';
        Jo.Assigned_To__c = UserInfo.getUserId();
        Jo.esn__c = '79464646';
        JO.Unit_Type__c = 'type';
        Jo.Country__c = 'United States';
        Jo.CSS_State__c = 'Indiana';
        Jo.City__c = 'Columbus';
        Jo.Customer_Code__c = '23456';
        Jo.Email_Address__c = 'Test@test.com';
        insert(JO);
        //ApexPages.CurrentPage().getParameters().put('id', jo.id);
        system.debug('------Testing---' +JO);
        
        Profile p = [SELECT Id FROM Profile WHERE Name='CSS_Service_Advanced']; 
        User u = new User(Alias = 'standt', Email='standarduser4@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US',  ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTestUser4@testorg.com',User_Location__c = 'location');
        insert u;
        list<account> lstAcc = new list<Account>();
        list<CSS_UserLocation__c> lstUsrLoc =new list<CSS_UserLocation__c>();
        Account a= new Account();
        a.name='Rtest';
        a.CSS_DistributorCode__c='56270';
        a.IAM_Service_Provider_Code__c='56270';
        a.BMS_Enabled__c = true;
        a.Type='Dealer Account';
        a.Region__c = 'US and Canada';
        a.CMI_Account_Status__c = 'Active';
        a.IAM_Service_Provider_Code__c = '562551';
        a.IAM_Service_Provider_Code__c = '33333';
        lstAcc.add(a);
        Account a1= new Account();
        a1.name='Rtest';
        a1.CSS_DistributorCode__c='56271';
        a1.IAM_Service_Provider_Code__c='56271';
        a1.BMS_Enabled__c = true;
        a1.Type='Dealer Account';
        a1.Region__c = 'US and Canada';
        a1.CMI_Account_Status__c = 'Active';
        a1.IAM_Service_Provider_Code__c = '562551';
        //a1.IAM_Service_Provider_Code__c = '33333';
        lstAcc.add(a1);
        Account a2= new Account();
        a2.name='Rtest';
        a2.CSS_DistributorCode__c='56272';
        a2.IAM_Service_Provider_Code__c='56272';
        a2.BMS_Enabled__c = false;
        a2.Type='Dealer Account';
        a2.Region__c = 'US and Canada';
        a2.CMI_Account_Status__c = 'Active';
        a2.IAM_Service_Provider_Code__c = '562556';
        //a2.IAM_Service_Provider_Code__c = '33333';
        lstAcc.add(a2);
        insert lstAcc;
        CSS_UserLocation__c userLocation = new CSS_UserLocation__c(AccountId__c=lstAcc[0].id,isActive__c=true,isPrimary__c=true,UserId__c=u.Id,Location_code__c='56270-56270');
        CSS_UserLocation__c userLocation1 = new CSS_UserLocation__c(AccountId__c=lstAcc[1].id,isActive__c=true,isPrimary__c=false,UserId__c=u.Id,Location_code__c='56271-56271');
        CSS_UserLocation__c userLocation2 = new CSS_UserLocation__c(AccountId__c=lstAcc[2].id,isActive__c=true,isPrimary__c=false,UserId__c=u.Id,Location_code__c='56272-56272');
        lstUsrLoc.add(userLocation);
        lstUsrLoc.add(userLocation1);
        lstUsrLoc.add(userLocation2);
        insert lstUsrLoc;
        system.runAs(u){
            id UserId = u.Id;
            system.debug('UserId:' +UserId);
            css_utility.getUserAttributes(UserId);
            
            css_job_order__c worecord= new css_job_order__c();
            //worecord.bmsCreateAccount__c = true;
            worecord.Customer_Code__c = null;
            worecord.Customer_Name__c = 'bms user';
            worecord.Phone_Number__c = '1234567897';
            worecord.First_Name__c = 'BMS';
            worecord.BMS_Last_Name__c = 'user';
            worecord.Cstmr_Contacts_Phone__c = '124567895';
            worecord.Address__c = 'Bangalore';
            worecord.City__c = 'bangalore';
            worecord.CSS_State__c = 'karnatka';
            worecord.ZipCode__c = '1234';
            worecord.Country__c = 'India';
            worecord.Primary_Segment__c = 'AG - AGRICULTURE';
            worecord.CSS_Charge_Account_Status__c = 'charge';
            worecord.Shop_Work_Order__c = 'shop';
            worecord.Application__c = 'Fire Truck';
            worecord.Date_in_Shop__c = date.today();
            worecord.Status__c = 'Intake';
            worecord.Category2__c = 'Leak';
            worecord.Category3__c = 'Fuel - Oil - Coolant';
            worecord.Category4__c = 'Symptom / Performance';
            worecord.Category5__c = 'Other';
            //worecord.Creator_Location__c = 'location';
            insert worecord;
        }         
        list<selectOption> option = new list<selectOption>();
        //option.add();
        CG_CL_IntakeCustomer obj = new CG_CL_IntakeCustomer();
        obj.AppointmentName = 'Yes';
        obj.PageName = 'test1';
        obj.selectedLocationName = 'test2';
        obj.EmailAddress = 'test3';
        obj.EmailAddress1 = 'test4';
        obj.filterCountry = 'test5';
        obj.filterState = 'test6';
        obj.strCntry = 'test7';
        obj.strCntryState = 'test8';
        //obj.userERPSystem = 'BMS Legacy';
        //system.debug('-------UserSystemmm---' +obj.userERPSystem);
        obj.pageAction();
        string location=[select id,Location_Name__c from CSS_UserLocation__c where Location_code__c !=null limit 1].Location_Name__c;
        system.debug('*****location***'+location);
        obj.selectedLocation=location;
        system.debug('*****location***'+obj.selectedLocation);
        Cache.Session.put('UserERPSystem', 'BMS Legacy');
        obj.mainContrVH = VH;
        obj.mainContrRJ = RJ;
        obj.mainContrWR = WR;
        //obj.options=option;
        obj.saveIntakeCustomer();
        //obj.saveCustomer(id inpJobId);
        
        obj.pgSave();
        
        obj.ChkFieldBlank();
        obj.closeSession();
        obj.Cancel();
        obj.redirectPopup();
        obj.nvIntakeUE();
        obj.nvIntakeCC();
        obj.nvIntakeVH();
        obj.nvIntakeWarranty();
        obj.nvIntakeRJ();
        obj.nvIntakeCustomer();
        list<selectOption> option1 = new list<selectOption>();
        //option.add();   
        Cache.Session.put('UserERPSystem', 'BMS Legacy');
        CG_CL_IntakeCustomer obj1 = new CG_CL_IntakeCustomer();
        obj.filterApplication = 'Test';
        obj.Wid = JO.id;
        obj.PageName = 'test1';
        obj.selectedLocationName = 'test2';
        obj.EmailAddress = 'test3';
        obj.EmailAddress1 = 'test4';
        obj.filterCountry = 'test5';
        obj.filterState = 'test6';
        obj.strCntry = 'test7';
        obj.strCntryState = 'test8';
        obj.userERPSystem = 'BMS Legacy';
        //system.debug('-------UserSystemmm---' +obj.userERPSystem);
        obj.pageAction();
        obj.saveIntakeCustomer();
        //obj.saveCustomer(id inpJobId);
        obj.pgSave();
        obj.ChkFieldBlank();
        obj.closeSession();
        obj.Cancel();
        obj.redirectPopup();
        obj.nvIntakeUE();
        obj.nvIntakeCC();
        obj.nvIntakeVH();
        obj.nvIntakeWarranty();
        obj.nvIntakeRJ();
        obj.nvIntakeCustomer();
        
        
        
        
        
    }
    
    
    static testMethod void CG_CL_IntakeCustomer_Test_TestMethod1() {
        CG_CL_IntakeVH VH = new CG_CL_IntakeVH();
        CG_CL_IntakeRJ RJ = new CG_CL_IntakeRJ();
        CG_CL_IntakeWarranty WR = new CG_CL_IntakeWarranty();
        //userERPSystem = 'BMS Legacy';
        CSS_Job_Order__c JO = new CSS_Job_Order__c();
        JO.Customer_Name__c = 'Roopa';
        JO.Application__c = 'Recreational Vehicle';
        JO.Model__c = 'RoopaTest';
        JO.Make__c = 'CSSTest';
        JO.Notes__c = 'CAMPCOMMENTS';
        JO.Failure_Point__c = 122;
        JO.Failure_Point_Measure__c = 'Miles';
        JO.VIN__c = '12345677890';
        JO.Failure_Date__c = date.today() - 20;
        JO.Warranty_Start_Date__c = date.today() - 365;
        JO.Location_Certification__c = 'abc';
        JO.jobLocation__c = 'abc';
        JO.Before_In_Service__c = True;
        //JO.lo = 10;
        //JO.Shop_s_Work_Order__c = 120;
        JO.Status__c = 'Repair Complete';
        JO.Unit_Number__c = 'test123';
        Jo.Assigned_To__c = UserInfo.getUserId();
        Jo.esn__c = '79464646';
        JO.Unit_Type__c = 'type';
        Jo.Country__c = 'United States';
        Jo.CSS_State__c = 'Indiana';
        Jo.City__c = 'Columbus';
        Jo.Customer_Code__c = '23456';
        Jo.Email_Address__c = 'Test@test.com';
        insert(JO);
        ApexPages.CurrentPage().getParameters().put('id', jo.id);
        system.debug('------Testing---' +JO);
        
        Profile p = [SELECT Id FROM Profile WHERE Name='CSS_Service_Advanced']; 
        User u = new User(Alias = 'standt', Email='standarduser4@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US',  ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTestUser4@testorg.com',User_Location__c = 'location');
        insert u;
        list<account> lstAcc = new list<Account>();
        list<CSS_UserLocation__c> lstUsrLoc =new list<CSS_UserLocation__c>();
        Account a= new Account();
        a.name='Rtest';
        a.CSS_DistributorCode__c='56270';
        a.IAM_Service_Provider_Code__c='56270';
        a.BMS_Enabled__c = true;
        a.Type='Dealer Account';
        a.Region__c = 'US and Canada';
        a.CMI_Account_Status__c = 'Active';
        a.IAM_Service_Provider_Code__c = '562551';
        a.IAM_Service_Provider_Code__c = '33333';
        
        lstAcc.add(a);
        Account a1= new Account();
        a1.name='Rtest';
        a1.CSS_DistributorCode__c='56271';
        a1.IAM_Service_Provider_Code__c='56271';
        a1.BMS_Enabled__c = true;
        a1.Region__c = 'US and Canada';
        a1.CMI_Account_Status__c = 'Active';
        a1.IAM_Service_Provider_Code__c = '562559';
        //a1.IAM_Service_Provider_Code__c = '33333';
        
        lstAcc.add(a1);
        Account a2= new Account();
        a2.name='Rtest';
        a2.CSS_DistributorCode__c='56272';
        a2.IAM_Service_Provider_Code__c='56270';
        a2.BMS_Enabled__c = false;
        a2.Region__c = 'US and Canada';
        a2.CMI_Account_Status__c = 'Active';
        //a2.IAM_Service_Provider_Code__c = '562551';
        //a2.IAM_Service_Provider_Code__c = '33333';
        
        lstAcc.add(a2);
        insert lstAcc;
        CSS_UserLocation__c userLocation = new CSS_UserLocation__c(AccountId__c=lstAcc[0].id,isActive__c=true,isPrimary__c=true,UserId__c=u.Id,Location_code__c='56270-56270');
        CSS_UserLocation__c userLocation1 = new CSS_UserLocation__c(AccountId__c=lstAcc[1].id,isActive__c=true,isPrimary__c=false,UserId__c=u.Id,Location_code__c='56271-56271');
        CSS_UserLocation__c userLocation2 = new CSS_UserLocation__c(AccountId__c=lstAcc[2].id,isActive__c=true,isPrimary__c=false,UserId__c=u.Id,Location_code__c='56272-56272');
        lstUsrLoc.add(userLocation);
        lstUsrLoc.add(userLocation1);
        lstUsrLoc.add(userLocation2);
        insert lstUsrLoc;
        system.runAs(u){
            id UserId = u.Id;
            system.debug('UserId:' +UserId);
            css_utility.getUserAttributes(UserId);
            
            css_job_order__c worecord= new css_job_order__c();
            //worecord.bmsCreateAccount__c = true;
            worecord.Customer_Code__c = null;
            worecord.Customer_Name__c = 'bms user';
            worecord.Phone_Number__c = '1234567897';
            worecord.First_Name__c = 'BMS';
            worecord.BMS_Last_Name__c = 'user';
            worecord.Cstmr_Contacts_Phone__c = '124567895';
            worecord.Address__c = 'Bangalore';
            worecord.City__c = 'bangalore';
            worecord.CSS_State__c = 'karnatka';
            worecord.ZipCode__c = '1234';
            worecord.Country__c = 'India';
            worecord.Primary_Segment__c = 'AG - AGRICULTURE';
            worecord.CSS_Charge_Account_Status__c = 'charge';
            worecord.Shop_Work_Order__c = 'shop';
            worecord.Application__c = 'Fire Truck';
            worecord.Date_in_Shop__c = date.today();
            worecord.Status__c = 'Intake';
            worecord.Category2__c = 'Leak';
            worecord.Category3__c = 'Fuel - Oil - Coolant';
            worecord.Category4__c = 'Symptom / Performance';
            worecord.Category5__c = 'Other';
            //worecord.Creator_Location__c = 'location';
            insert worecord;
        }         
        CG_CL_IntakeCustomer obj = new CG_CL_IntakeCustomer();
        obj.PageName = 'test1';
        obj.selectedLocationName = 'test2';
        obj.EmailAddress = 'test3';
        obj.EmailAddress1 = 'test4';
        obj.filterCountry = 'test5';
        obj.filterState = 'test6';
        obj.strCntry = 'test7';
        obj.strCntryState = 'test8';
        obj.userERPSystem = 'BMS Legacy';
        //system.debug('-------UserSystemmm---' +obj.userERPSystem);
        obj.pageAction();
        obj.saveIntakeCustomer();
        //obj.saveCustomer(id inpJobId);
        
        obj.pgSave();
        
        obj.ChkFieldBlank();
        obj.closeSession();
        obj.Cancel();
        obj.redirectPopup();
        obj.nvIntakeUE();
        obj.nvIntakeCC();
        obj.nvIntakeVH();
        obj.nvIntakeWarranty();
        obj.nvIntakeRJ();
        obj.nvIntakeCustomer();
        
        
        
    }
    
   
    static testMethod void CG_CL_IntakeCustomer_Test_TestMethod3() {
        CG_CL_IntakeVH VH = new CG_CL_IntakeVH();
        CG_CL_IntakeRJ RJ = new CG_CL_IntakeRJ();
        CG_CL_IntakeWarranty WR = new CG_CL_IntakeWarranty();
        //userERPSystem = 'BMS Legacy';
        CSS_Job_Order__c JO = new CSS_Job_Order__c();
        JO.Customer_Name__c = 'Roopa';
        JO.Application__c = 'Recreational Vehicle';
        JO.Model__c = 'RoopaTest';
        JO.Make__c = 'CSSTest';
        JO.Notes__c = 'CAMPCOMMENTS';
        JO.Failure_Point__c = 122;
        JO.Failure_Point_Measure__c = 'Miles';
        JO.VIN__c = '12345677890';
        JO.Failure_Date__c = date.today() - 20;
        JO.Warranty_Start_Date__c = date.today() - 365;
        JO.Location_Certification__c = 'abc';
        JO.jobLocation__c = 'abc';
        JO.Before_In_Service__c = True;
        //JO.lo = 10;
        //JO.Shop_s_Work_Order__c = 120;
        JO.Status__c = 'Repair Complete';
        JO.Unit_Number__c = 'test123';
        Jo.Assigned_To__c = UserInfo.getUserId();
        Jo.esn__c = '79464646';
        JO.Unit_Type__c = 'type';
        Jo.Country__c = 'United States';
        Jo.CSS_State__c = 'Indiana';
        Jo.City__c = 'Columbus';
        Jo.Customer_Code__c = '23456';
        Jo.Email_Address__c = 'Test@test.com';
        insert(JO);
        //ApexPages.CurrentPage().getParameters().put('id', jo.id);
        system.debug('------Testing---' +JO);
        
        Profile p = [SELECT Id FROM Profile WHERE Name='CSS_Service_Advanced']; 
        User u = new User(Alias = 'standt', Email='standarduser4@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US',  ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTestUser4@testorg.com',User_Location__c = 'location');
        insert u;
        list<account> lstAcc = new list<Account>();
        list<CSS_UserLocation__c> lstUsrLoc =new list<CSS_UserLocation__c>();
        Account a= new Account();
        a.name='Rtest';
        a.CSS_DistributorCode__c='56270';
        a.IAM_Service_Provider_Code__c='56270';
        a.BMS_Enabled__c = true;
        lstAcc.add(a);
        Account a1= new Account();
        a1.name='Rtest';
        a1.CSS_DistributorCode__c='56271';
        a1.IAM_Service_Provider_Code__c='56271';
        a1.BMS_Enabled__c = true;
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
        system.runAs(u){
            id UserId = u.Id;
            system.debug('UserId:' +UserId);
            css_utility.getUserAttributes(UserId);
            
            css_job_order__c worecord= new css_job_order__c();
            //worecord.bmsCreateAccount__c = true;
            worecord.Customer_Code__c = null;
            worecord.Customer_Name__c = 'bms user';
            worecord.Phone_Number__c = '1234567897';
            worecord.First_Name__c = 'BMS';
            worecord.BMS_Last_Name__c = 'user';
            worecord.Cstmr_Contacts_Phone__c = '124567895';
            worecord.Address__c = 'Bangalore';
            worecord.City__c = 'bangalore';
            worecord.CSS_State__c = 'karnatka';
            worecord.ZipCode__c = '1234';
            worecord.Country__c = 'India';
            worecord.Primary_Segment__c = 'AG - AGRICULTURE';
            worecord.CSS_Charge_Account_Status__c = 'charge';
            worecord.Shop_Work_Order__c = 'shop';
            worecord.Application__c = 'Fire Truck';
            worecord.Date_in_Shop__c = date.today();
            worecord.Status__c = 'Intake';
            worecord.Category2__c = 'Leak';
            worecord.Category3__c = 'Fuel - Oil - Coolant';
            worecord.Category4__c = 'Symptom / Performance';
            worecord.Category5__c = 'Other';
            //worecord.Creator_Location__c = 'location';
            insert worecord;
        }         
        list<selectOption> option = new list<selectOption>();
        //option.add();
        CG_CL_IntakeCustomer obj = new CG_CL_IntakeCustomer();
        obj.AppointmentName = 'Yes';
        obj.PageName = 'test1';
        obj.selectedLocationName = 'test2';
        obj.EmailAddress = 'test3';
        obj.EmailAddress1 = 'test4';
        obj.filterCountry = 'test5';
        obj.filterState = 'test6';
        obj.strCntry = 'test7';
        obj.strCntryState = 'test8';
        //obj.userERPSystem = 'BMS Legacy';
        //system.debug('-------UserSystemmm---' +obj.userERPSystem);
        obj.pageAction();
        string location=[select id,Location_Name__c from CSS_UserLocation__c where Location_code__c !=null limit 1].Location_Name__c;
        system.debug('*****location***'+location);
        obj.selectedLocation='56270-56270';
        system.debug('*****location***'+obj.selectedLocation);
        Cache.Session.put('UserERPSystem', 'BMS Legacy');
        Cache.Session.put('selectedLocation', '56270-56270');
        obj.mainContrVH = VH;
        obj.mainContrRJ = RJ;
        obj.mainContrWR = WR;
        obj.options=option;
        obj.saveIntakeCustomer();
        //obj.saveCustomer(id inpJobId);
        
        obj.pgSave();
        
        obj.ChkFieldBlank();
        obj.closeSession();
        obj.Cancel();
        obj.redirectPopup();
        obj.nvIntakeUE();
        obj.nvIntakeCC();
        obj.nvIntakeVH();
        obj.nvIntakeWarranty();
        obj.nvIntakeRJ();
        obj.nvIntakeCustomer();
        
        
        
    }
    
    
}