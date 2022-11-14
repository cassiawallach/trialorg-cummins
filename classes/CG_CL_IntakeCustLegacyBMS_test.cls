@isTest(seealldata = false)
public class CG_CL_IntakeCustLegacyBMS_test {
    Static String recordType_Id = Schema.SObjectType.Account.getRecordTypeInfosByName().get('WWSPS').getRecordTypeId();  
    Public String str;
    public List<CSS_customerOutboundJSON2Apex.DataArea> paginatedCustDetails1 ;
    //public CG_CL_IntakeCustomer mainContr ;
    @testsetup static void testdata(){
        Profile p = [SELECT Id FROM Profile WHERE Name='CSS_Service_Advanced']; 
        User u = new User(Alias = 'standt', Email='standarduser4@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US',  ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTestUser4@testorg.com',User_Location__c = 'location');
        insert u;
        system.runAs(u)
        {
            list<CSS_UserLocation__c> lstUsrLoc =new list<CSS_UserLocation__c>();
            Account a= new Account();
            a.name='Rtest';
            a.CSS_DistributorCode__c='56270';
            a.CSS_DealerCode__c='56270';
            a.BMS_Enabled__c = true;
            a.CSS_DBCode__c='33333';
            a.Type = 'Customer';
            a.RecordTypeId = recordType_Id;
            insert a;
            CSS_UserLocation__c userLocation = new CSS_UserLocation__c(AccountId__c=a.id,isActive__c=true,isPrimary__c=true,UserId__c=u.Id,Location_code__c='56270-56270',Name='Rtest');
            
            lstUsrLoc.add(userLocation);
            insert lstUsrLoc;
            cache.Session.put('selectedLocation','56270-56270');
            CG_CL_IntakeCustomer mainContr  = new CG_CL_IntakeCustomer();  
            CSS_Job_Order__c JO = new CSS_Job_Order__c();
            maincontr.workJob = jo;
        }
        
    }
    
    static testmethod void CG_CL_IntakeCustLegacyBMS_TestPositive()
    {
        user u = [select id from user limit 1];
        system.runAs(u)
        {
            
            cache.Session.put('UserERPSystem','BMS Legacy');
        }  
        CG_CL_IntakeCustLegacyBMS op = new CG_CL_IntakeCustLegacyBMS();
        op.getLocationsName();
        op.getLocationLabel('56270-56270');
        
    }
    static testmethod void CG_CL_IntakeCustLegacyBMS_TestNegative()
    {
        user u = [select id from user limit 1];
        system.runAs(u)
        {
            cache.Session.put('UserERPSystem','');
            CG_CL_IntakeCustLegacyBMS op = new CG_CL_IntakeCustLegacyBMS();
            op.getLocationsName();
            op.getLocationLabel('56270-56270');
        }
    }
    Static testmethod void intakeCustLegacyBMStestMethod() {
        CG_CL_IntakeVH VH = new CG_CL_IntakeVH();
        CG_CL_IntakeRJ RJ = new CG_CL_IntakeRJ();
        CG_CL_IntakeWarranty WR = new CG_CL_IntakeWarranty();
        
        CG_CL_IntakeCustomer mainContr1 = new CG_CL_IntakeCustomer() ;   
        
        CSS_JobEventTemporary__c  jobEventTemp=  CSS_TestData.createJobEventTempObj(false);
        
        jobEventTemp.attribute1__c = 'ApplicationCodes';
        jobEventTemp.Reason__c = '{"DataArea": {"Details": [{"ComplaintCode": "123","Description": "abc","BusinessUnit": "EBU","ActiveFlag": "Y","Category": "aaa"},{"ComplaintCode": "345","Description": "tavdg","BusinessUnit": "PSBU","ActiveFlag": "N","Category": "bbb"}]},"Header": {"ReturnCodeDescription": "","Status": "Success"}}';
        try
        {
            insert jobEventTemp;
        }
        catch(exception e)
        {}
        
        CSS_Job_Order__c JO = new CSS_Job_Order__c();
        JO.Unit_Number__c = '123456';
        JO.Customer_Name__c = 'Rajasekhar';
        JO.First_Name__c = 'hindu';
        JO.Application__c = 'Recreational Vehicle';
        JO.Model__c = 'RajTest';
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
        JO.Status__c = 'Repair Complete';
        //JO.Unit_Number__c = '12345';
        Jo.Assigned_To__c = UserInfo.getUserId();
        Jo.esn__c = '79464646';
        JO.Service_Model__c = 'model';
        JO.Unit_Type__c = 'type';
        JO.Sub_Type__c = 'sub type';
        Jo.Country__c = 'United States';
        Jo.CSS_State__c = 'Indiana';
        JO.Address__c = 'Bangalore';
        JO.ZipCode__c = '12345';
        JO.Primary_Segment__c = 'AG - AGRICULTURE';
        JO.CSS_Charge_Account_Status__c = 'charge';
        Jo.City__c = 'Columbus';
        JO.BMS_Last_Name__c = 'user';
        Jo.Customer_Code__c = '23456';
        Jo.EditComplaint__c = 'complaint';
        Jo.EditCoverage__c = 'coverage';
        Jo.EditCause__c = 'cause';
        Jo.EditCorrection__c = 'correction';
        JO.chevron_page__c = 'prt';
        JO.CSS_Resolution__c = 'Test';
        JO.DSID__c = 'VFD23';
        JO.Email_Address__c = 'prabhu@gmail.com';
        //JO.Sub_Status__c = 'Escalated';
        JO.Phone_Number__c = '(876) 546-7899';
        JO.Cstmr_Contacts_Phone__c = '8888888888';
        //JO.Previous_Status__c = 'intake';
        JO.Status__c = 'intake complete';
        JO.PSN_Not_Available__c = false;
        JO.Complaint_Type_Desc__c = 'null';
        JO.Category_Desc__c = 'test';
        JO.Contact_ID__c = 'wee';
        JO.Repair_Location__c = 'Mobile';
        JO.General_Symptoms__c = 'symptoms';
        JO.Shop_Work_Order__c = 'WO';
        JO.Mileage__c = 10.2;
        JO.Application_Desc__c = 'descrption';
        Jo.Category_Desc__c='TEST';
        Jo.Category2_Desc__c='TEST';
        Jo.Category3_Desc__c='TEST';
        Jo.Category4_Desc__c='TEST';
        Jo.Category5_Desc__c='TEST';
        JO.Complaint_Type2_Desc__c = 'ggg';
        JO.Complaint_Type2_Desc__c = 'ttyy';
        JO.Complaint_Type3_Desc__c = 'bbb';
        JO.Complaint_Type4_Desc__c = 'fffh';
        JO.Complaint_Type5_Desc__c = 'coml';
        JO.CSS_Job_Location_Code__c = '90943-90942';
        JO.Mileage_Measure__c = 'mileage';
        JO.Failure_Point_Measure__c = 'failure';
        JO.ESN_Locked__c = true;
        JO.Failure_Date__c = date.today() - 20;
        JO.Warranty_Start_Date__c = date.today() - 365;
        JO.Location_Certification__c = 'abc';
        JO.jobLocation__c = 'abc';
        JO.bmsCreateAccount__c = true;
        JO.Application__c = 'Fire Truck';
        
        insert JO;
        
        system.debug('----Testjobbb--' +JO);
        mainContr1.workJob = JO ;
        mainContr1.AppointmentName = 'No';
        system.debug('---maincon--'+mainContr1.workJob);
        //mainContr1.workJob.ZipCode__c = 'testing';
        //system.debug('zipppppp' +mainContr1.workJob.ZipCode__c);
        list<account> lstAcc = new list<Account>();
        
        /* Profile p = [SELECT Id FROM Profile WHERE Name='CSS_Service_Advanced']; 
User u = new User(Alias = 'standt', Email='standarduser4@testorg.com', 
EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
LocaleSidKey='en_US',  ProfileId = p.Id, 
TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTestUser4@testorg.com',User_Location__c = 'location');
insert u;*/
        user u = [select id,name from user limit 1];
        list<CSS_UserLocation__c> lstUsrLoc =new list<CSS_UserLocation__c>();
        Account a= new Account();
        a.name='Rtest';
        a.CSS_DistributorCode__c='56270';
        a.CSS_DealerCode__c='56270';
        a.BMS_Enabled__c = true;
        a.CSS_DBCode__c='33333';
        a.Type = 'Customer';
        lstAcc.add(a);
        Account a1= new Account();
        a1.name='Rtest';
        a1.CSS_DistributorCode__c='56271';
        a1.CSS_DealerCode__c='56271';
        a1.BMS_Enabled__c = true;
        a1.CSS_DBCode__c='33333';
        a1.Type = 'Customer';
        lstAcc.add(a1);
        Account a2= new Account();
        a2.name='Rtest';
        a2.CSS_DistributorCode__c='56272';
        a2.CSS_DealerCode__c='56272';
        a2.BMS_Enabled__c = false;
        a2.CSS_DBCode__c='33333';
        a2.Type = 'Customer';
        lstAcc.add(a2);
        insert lstAcc;
        CSS_UserLocation__c userLocation = new CSS_UserLocation__c(AccountId__c=a.id,isActive__c=true,isPrimary__c=true,UserId__c=u.Id,Location_code__c='56270-56270');
        insert userLocation;
        lstUsrLoc.add(userLocation);
        CSS_CountryStateValues__c stvalue = new  CSS_CountryStateValues__c(Name='CA AB',CountryCode__c='CA',CountryName__c='Canada', StateCode__c='AB',StateName__c='Alberta, Canada')  ;
        insert stvalue;
        
        CSS_Integration_Details__c inte = new CSS_Integration_Details__c();
        Blob key = Blob.valueOf('12345678901234567890123456789012');
        string algo = 'AES256';
        inte.Name = 'BMS';
        inte.Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('test')));
        inte.Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('test')));
        inte.Key__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('1234')));
        inte.ApplicationName__c = 'BMS';
        inte.End_Point__c = 'abc.com';
        inte.IsActive__c = true;
        insert inte;
        
        Cache.Session.put('UserERPSystem' , 'BMS Legacy');
        CG_CL_IntakeCustLegacyBMS obj = new CG_CL_IntakeCustLegacyBMS();
        obj.AppointmentName = 'test1';
        obj.reqBoolean = true;
        obj.EmailAddress = 'test2';
        obj.EmailAddress1 = 'test3';
        obj.filterApplication = 'test4';
        obj.bmsContacterrorMessage = 'test5';
        obj.strBMSAccountMsg = 'test6';
        obj.showOutageError = true;        
        obj.selectedCustCode = '213897';
        obj.strCntry = 'test7';
        obj.strCntryState = 'test8';
        obj.errorMessage = 'test9';
        String str = 'testing';
        obj.selectedContactID = '213897';
        obj.mainContr=mainContr1 ;
        List<CSS_customerOutboundJSON2Apex.DataArea> paginatedCustDetails1 = new List<CSS_customerOutboundJSON2Apex.DataArea>() ;
        CSS_customerOutboundJSON2Apex.DataArea custbound = new CSS_customerOutboundJSON2Apex.DataArea();
        custbound.CustomerName = 't1';
        custbound.CustomerCode = '213897';
        custbound.LocationAddressline1 = 't3';
        custbound.LocationAddressline2 = 't4';
        custbound.LocationAddressline3 = 't5';
        custbound.PhoneNumber = 't6';
        custbound.AreaCode = 't7';
        custbound.City = 't8';
        custbound.PaymentType = 't9';
        custbound.State = 't10';
        custbound.Country = 't11';
        custbound.Postalcode1 = 't12';
        custbound.Postalcode2 = 't13' ;
        paginatedCustDetails1.add(custbound);
        system.debug('-----paginatedCustDetails1---' +paginatedCustDetails1);
        obj.paginatedCustDetails = paginatedCustDetails1;
        system.debug('-----paginatedCustDetails---' +obj.paginatedCustDetails);
        test.setMock(HttpCalloutMock.class, new CG_SL_BMSMock_Test(true));
        test.starttest();
        obj.getBMSCustDetails();
        
        
        
        test.setMock(HttpCalloutMock.class, new CSS_WS_OAGMock_Test());
        obj.ContactLookup();
        
        obj.createAccount();
        obj.selectedCustDetails();
        obj.mainContrVH = VH;
        obj.mainContrRJ = RJ;
        obj.mainContrWR = WR;
        obj.getfilterState();
        obj.setfilterState(str);
        obj.getfilterCountry();
        obj.setfilterCountry(str);
        obj.getLocationLabel(str);
        //obj.CG_CL_IntakeCustLegacyBMS(str);
        obj.getLocationsName();
        obj.changeLocation();
        obj.getCountry();
        obj.getRepairLocation();
        obj.getStates();
        obj.getApplication();
        
        //obj.selectedCustDetails();
        String json = '{'+
            '                \"DataArea\": ['+
            '                {'+
            '                                \"CustomerNumber\": \"5723046\",'+
            '                                \"FirstName\": \"\",'+
            '                                \"MI\": \"5723046\",'+
            '                                \"LastName\": \"CA\",'+
            '                                \"Salutation\": \"BRITESTONE COLONY\",'+
            '                                \"Position\": \"CARBON\",'+
            '                                \"LocationAddressline1\": \"BOX 129\",'+
            '                                \"LocationAddressline2\": \"CARBON COLONY\",'+
            '                                \"LocationAddressline3\": \"CARBON COLONY\",'+
            '                                \"City\": \"403\",'+
            '                                \"State\": \"CASH\",'+
            '                                \"PostalCode\": \"AB\",'+
            '                                \"PostalCodeSuffix\": \"\",'+
            '                                \"Country\": \"US\",'+
            '                                \"PhoneAreaCode\": \"667\",'+
            '                                \"PhoneNumber\": \"278-6789\",'+
            '                                \"Ext\": \"11\",'+
            '                                \"FaxAreacode\": \"813\",'+
            '                                \"FaxNumber\": \"213-0897\",'+
            '                                \"Email\": \"Example@gmail.com\",'+
            '                                \"Comments\": \"Testing\",'+
            '                                \"ContactID\": \"213897\"'+
            '                }],'+
            ''+
            '                \"Header\": {'+
            '                                \"ReturnCodeDescription\":\"retTest\",'+
            '                                \"Status\": \"SUCCESS\",'+
            '                                \"Sender\": {'+
            '                                                \"ServiceName\": \"GetCustomer\",'+
            '                                                \"MessageID\":\"1234\", '+
            '                                                \"SenderID\": \"BMS\"'+
            '                                },'+
            '                                \"Target\": {'+
            '                                                \"TargetID\": \"CSS\"'+
            '                                },'+
            '                                \"Location\": {'+
            '                                                \"LocationID\": \"56270-56255\"'+
            '                                }'+
            '                }'+
            '}';
        CSS_BMSContactLookupResponseJ2A obj3 = CSS_BMSContactLookupResponseJ2A.parse(json);
        obj.CustomerContactDetails = obj3;
        obj.selectedContactDetails();
        
        
        CSS_Integration_Details__C itgDetails = new CSS_Integration_Details__c(Name='BMS',ApplicationName__c='BMS',AuthEnv__c='OAGDev',End_Point__c='https://services-dev.cummins.com/css/bms',IsActive__c=true,Key__c='b0QfgPgFJRwt0xwYgr97QE2cfWVuIa1UR96ot+uKp4M=',Method_Type__c='POST',Passcode__c='K6FYOp/RdbTZ1NixD44NYHuX0m9cpk/VCucdeUVPNEY=',Timeout__c=120);
        insert itgDetails;
        test.setMock(HttpCalloutMock.class, new CG_SL_BMSMock_Test(true));
        obj.bmsCustInbound();
        obj.closeBMSContDetails();
        obj.closeBMSCustDetails();
        obj.selectedBMSCustCode();
        obj.resetBMSFields();
        test.stoptest();
        //obj.nvIntakeCustomer();
    }
    Static testmethod void intakeCustLegacyBMStestMethod1() {
        
        CG_CL_IntakeVH VH = new CG_CL_IntakeVH();
        CG_CL_IntakeRJ RJ = new CG_CL_IntakeRJ();
        CG_CL_IntakeWarranty WR = new CG_CL_IntakeWarranty();
        
        CG_CL_IntakeCustomer mainContr1 = new CG_CL_IntakeCustomer() ;
        CSS_JobEventTemporary__c  jobEventTemp=  CSS_TestData.createJobEventTempObj(false);
        jobEventTemp.attribute1__c = 'ApplicationCodes';
        jobEventTemp.Reason__c = '{"DataArea": {"Details": [{"ComplaintCode": "123","Description": "abc","BusinessUnit": "EBU","ActiveFlag": "Y","Category": "aaa"},{"ComplaintCode": "345","Description": "tavdg","BusinessUnit": "PSBU","ActiveFlag": "N","Category": "bbb"}]},"Header": {"ReturnCodeDescription": "","Status": "Success"}}';
        insert jobEventTemp;
        CSS_Job_Order__c JO = new CSS_Job_Order__c();
        JO.Unit_Number__c = '123456';
        JO.Customer_Name__c = 'Testing';
        JO.First_Name__c = 'hindu';
        JO.Application__c = 'Recreational Vehicle';
        JO.Model__c = 'Test';
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
        JO.Status__c = 'Repair Complete';
        //JO.Unit_Number__c = '12345';
        Jo.Assigned_To__c = UserInfo.getUserId();
        Jo.esn__c = '79464646';
        JO.Service_Model__c = 'model';
        JO.Unit_Type__c = 'type';
        JO.Sub_Type__c = 'sub type';
        Jo.Country__c = 'United States';
        Jo.CSS_State__c = 'Indiana';
        JO.Address__c = 'Bangalore';
        JO.ZipCode__c = '12345';
        JO.Primary_Segment__c = 'AG - AGRICULTURE';
        JO.CSS_Charge_Account_Status__c = 'charge';
        Jo.City__c = 'Columbus';
        JO.BMS_Last_Name__c = 'user';
        Jo.Customer_Code__c = '23456';
        Jo.EditComplaint__c = 'complaint';
        Jo.EditCoverage__c = 'coverage';
        Jo.EditCause__c = 'cause';
        Jo.EditCorrection__c = 'correction';
        JO.chevron_page__c = 'prt';
        JO.CSS_Resolution__c = 'Test';
        JO.DSID__c = 'VFD23';
        JO.Email_Address__c = 'prabhu@gmail.com';
        //JO.Sub_Status__c = 'Escalated';
        JO.Phone_Number__c = '(876) 546-7899';
        JO.Cstmr_Contacts_Phone__c = '8888888888';
        //JO.Previous_Status__c = 'intake';
        JO.Status__c = 'intake complete';
        JO.PSN_Not_Available__c = false;
        JO.Complaint_Type_Desc__c = 'null';
        JO.Category_Desc__c = 'test';
        JO.Contact_ID__c = 'wee';
        JO.Repair_Location__c = 'Mobile';
        JO.General_Symptoms__c = 'symptoms';
        JO.Shop_Work_Order__c = 'WO';
        JO.Mileage__c = 10.2;
        JO.Application_Desc__c = 'descrption';
        Jo.Category_Desc__c='TEST';
        Jo.Category2_Desc__c='TEST';
        Jo.Category3_Desc__c='TEST';
        Jo.Category4_Desc__c='TEST';
        Jo.Category5_Desc__c='TEST';
        JO.Complaint_Type2_Desc__c = 'ggg';
        JO.Complaint_Type2_Desc__c = 'ttyy';
        JO.Complaint_Type3_Desc__c = 'bbb';
        JO.Complaint_Type4_Desc__c = 'fffh';
        JO.Complaint_Type5_Desc__c = 'coml';
        JO.CSS_Job_Location_Code__c = '90943-90942';
        JO.Mileage_Measure__c = 'mileage';
        JO.Failure_Point_Measure__c = 'failure';
        JO.ESN_Locked__c = true;
        JO.Failure_Date__c = date.today() - 20;
        JO.Warranty_Start_Date__c = date.today() - 365;
        JO.Location_Certification__c = 'abc';
        JO.jobLocation__c = 'abc';
        JO.bmsCreateAccount__c = true;
        JO.Application__c = 'Fire Truck';
        
        insert JO;
        mainContr1.workJob = JO ;
        mainContr1.AppointmentName = 'No';
        list<account> lstAcc = new list<Account>();
        user u = [select id,name from user limit 1];
        list<CSS_UserLocation__c> lstUsrLoc =new list<CSS_UserLocation__c>();
        Account a= new Account();
        a.name='Rtest1';
        a.CSS_DistributorCode__c='56270';
        a.CSS_DealerCode__c='56270';
        a.BMS_Enabled__c = true;
        a.CSS_DBCode__c='33333';
        a.Type = 'Customer';
        lstAcc.add(a);
        Account a1= new Account();
        a1.name='Rtest12';
        a1.CSS_DistributorCode__c='56271';
        a1.CSS_DealerCode__c='56271';
        a1.BMS_Enabled__c = true;
        a1.CSS_DBCode__c='33333';
        a1.Type = 'Customer';
        lstAcc.add(a1);
        Account a2= new Account();
        a2.name='Rtest123';
        a2.CSS_DistributorCode__c='56272';
        a2.CSS_DealerCode__c='56272';
        a2.BMS_Enabled__c = false;
        a2.CSS_DBCode__c='33333';
        a2.Type = 'Customer';
        lstAcc.add(a2);
        insert lstAcc;
        CSS_CountryStateValues__c stvalue = new  CSS_CountryStateValues__c(Name='CA AB',CountryCode__c='CA',CountryName__c='Canada', StateCode__c='AB',StateName__c='Alberta, Canada')  ;
        insert stvalue;
        CSS_Integration_Details__c inte = new CSS_Integration_Details__c();
        Blob key = Blob.valueOf('12345678901234567890123456789012');
        string algo = 'AES256';
        inte.Name = 'BMS';
        inte.Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('test')));
        inte.Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('test')));
        inte.Key__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('1234')));
        inte.ApplicationName__c = 'BMS';
        inte.End_Point__c = 'abc.com';
        inte.IsActive__c = true;
        insert inte;
        // Cache.Session.put('UserERPSystem' , 'BMS Legacy');
        CG_CL_IntakeCustLegacyBMS obj = new CG_CL_IntakeCustLegacyBMS();
        String Sh =  obj.getfilterState();
        obj.mainContr=mainContr1 ;
        obj.getfilterCountry();
        string sh1 = 'testing';
        obj.setfilterCountry(sh1);
        obj.setfilterState(sh1);
        obj.getLocationsName();
        
    }
    static testmethod void TestcreateAccountmethod()
    {
        CG_CL_IntakeCustomer mainContr12= new CG_CL_IntakeCustomer();
        CSS_Job_Order__c JO = new CSS_Job_Order__c();
        JO.Unit_Number__c = '123456';
        JO.Customer_Name__c = 'Gopal';
        JO.First_Name__c = 'hindu';
        JO.Application__c = 'Recreational Vehicle';
        JO.Model__c = 'RajTest';
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
        JO.Status__c = 'Repair Complete';
        //JO.Unit_Number__c = '12345';
        Jo.Assigned_To__c = UserInfo.getUserId();
        Jo.esn__c = '79464646';
        JO.Service_Model__c = 'model';
        JO.Unit_Type__c = 'type';
        JO.Sub_Type__c = 'sub type';
        Jo.Country__c = 'United States';
        Jo.CSS_State__c = 'Indiana';
        JO.Address__c = 'Bangalore';
        JO.ZipCode__c = '12345';
        JO.Primary_Segment__c = 'AG - AGRICULTURE';
        JO.CSS_Charge_Account_Status__c = 'charge';
        Jo.City__c = 'Columbus';
        JO.BMS_Last_Name__c = 'user';
        Jo.Customer_Code__c = '23456';
        Jo.EditComplaint__c = 'complaint';
        Jo.EditCoverage__c = 'coverage';
        Jo.EditCause__c = 'cause';
        Jo.EditCorrection__c = 'correction';
        JO.chevron_page__c = 'prt';
        JO.CSS_Resolution__c = 'Test';
        JO.DSID__c = 'VFD23';
        JO.Email_Address__c = 'gopalraj@gmail.com';
        //JO.Sub_Status__c = 'Escalated';
        JO.Phone_Number__c = '(876) 546-7899';
        JO.Cstmr_Contacts_Phone__c = '8888888888';
        //JO.Previous_Status__c = 'intake';
        JO.Status__c = 'intake complete';
        JO.PSN_Not_Available__c = false;
        JO.Complaint_Type_Desc__c = 'null';
        JO.Category_Desc__c = 'test';
        JO.Contact_ID__c = 'wee';
        JO.Repair_Location__c = 'Mobile';
        JO.General_Symptoms__c = 'symptoms';
        JO.Shop_Work_Order__c = 'WO';
        JO.Mileage__c = 10.2;
        JO.Application_Desc__c = 'descrption';
        Jo.Category_Desc__c='TEST';
        Jo.Category2_Desc__c='TEST';
        Jo.Category3_Desc__c='TEST';
        Jo.Category4_Desc__c='TEST';
        Jo.Category5_Desc__c='TEST';
        JO.Complaint_Type2_Desc__c = 'ggg';
        JO.Complaint_Type2_Desc__c = 'ttyy';
        JO.Complaint_Type3_Desc__c = 'bbb';
        JO.Complaint_Type4_Desc__c = 'fffh';
        JO.Complaint_Type5_Desc__c = 'coml';
        JO.CSS_Job_Location_Code__c = '56270-56270';
        JO.Mileage_Measure__c = 'mileage';
        JO.Failure_Point_Measure__c = 'failure';
        JO.ESN_Locked__c = true;
        JO.Failure_Date__c = date.today() - 20;
        JO.Warranty_Start_Date__c = date.today() - 365;
        JO.Location_Certification__c = 'abc';
        JO.jobLocation__c = 'abc';
        JO.bmsCreateAccount__c = true;
        JO.Application__c = 'Fire Truck';
        
        insert JO;
        mainContr12.workJob=jo;
        maincontr12.AppointmentName='NO';
        maincontr12.filterApplication='Automotive';
        maincontr12.filterCountry='CA';
        maincontr12.filterState='AB';
        list<account> lstAcc1 = new list<Account>();
        user u = [select id,name from user limit 1];
        list<CSS_UserLocation__c> lstUsrLoc1 =new list<CSS_UserLocation__c>();
        Account a= new Account();
        a.name='Rtest11';
        a.CSS_DistributorCode__c='56270';
        a.CSS_DealerCode__c='56270';
        a.BMS_Enabled__c = true;
        a.CSS_DBCode__c='33333';
        a.Type = 'Customer';
        lstAcc1.add(a);
        Account a1= new Account();
        a1.name='Rtest12';
        a1.CSS_DistributorCode__c='56271';
        a1.CSS_DealerCode__c='56271';
        a1.BMS_Enabled__c = true;
        a1.CSS_DBCode__c='33333';
        a1.Type = 'Customer';
        lstAcc1.add(a1);
        Account a2= new Account();
        a2.name='Rtest123';
        a2.CSS_DistributorCode__c='56272';
        a2.CSS_DealerCode__c='56272';
        a2.BMS_Enabled__c = false;
        a2.CSS_DBCode__c='33333';
        a2.Type = 'Customer';
        lstAcc1.add(a2);
        insert lstAcc1;
        CSS_UserLocation__c userLocation = new CSS_UserLocation__c(AccountId__c=a.id,isActive__c=true,isPrimary__c=true,UserId__c=u.Id,Location_code__c='56270-56270');
        insert userLocation;
        lstUsrLoc1.add(userLocation);
        CSS_CountryStateValues__c stvalue1 = new  CSS_CountryStateValues__c(Name='CA AB',CountryCode__c='CA',CountryName__c='Canada', StateCode__c='AB',StateName__c='Alberta, Canada')  ;
        insert stvalue1;
        //To get codes we need a list_ofvalues
        list<CSS_List_Of_Values__c> lov1 = new list<CSS_List_Of_Values__c>();
        lov1.add( new CSS_List_Of_Values__c(Name ='130AUTO', Type__c='Application Code', Picklist_Values_1__c='Automotive', Code__c='AUTO' ));
        lov1.add( new CSS_List_Of_Values__c(Name ='140AUTO', Type__c='Primary Segment', Picklist_Values_1__c='Automotive', Code__c='AUTO' ));
        insert lov1;
        
        CSS_Integration_Details__c inte = new CSS_Integration_Details__c();
        Blob key = Blob.valueOf('12345678901234567890123456789012');
        string algo = 'AES256';
        inte.Name = 'BMS';
        inte.Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('test')));
        inte.Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('test')));
        inte.Key__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('1234')));
        inte.ApplicationName__c = 'BMS';
        inte.End_Point__c = 'abc.com';
        inte.IsActive__c = true;
        insert inte;
        
        Cache.Session.put('UserERPSystem' , 'BMS Legacy');
        CG_CL_IntakeCustLegacyBMS obj11 = new CG_CL_IntakeCustLegacyBMS();
        obj11.AppointmentName = 'test1';
        obj11.reqBoolean = true;
        obj11.EmailAddress = 'test2';
        obj11.EmailAddress1 = 'test3';
        obj11.filterApplication = 'Automotive';
        obj11.bmsContacterrorMessage = 'test5';
        obj11.strBMSAccountMsg = 'test6';
        obj11.showOutageError = true;        
        obj11.selectedCustCode = '213897';
        obj11.strCntry = 'test7';
        obj11.strCntryState = 'test8';
        obj11.errorMessage = 'test9';
        String str = 'testing';
        obj11.selectedContactID = '213897';
        obj11.mainContr=mainContr12 ;
        test.startTest();
        system.assert(obj11.mainContr.filterApplication!=null);
        
        test.setMock(HttpCalloutMock.class, new CG_SL_BMSMock_Test(true));
        system.debug('CreateAccount Starts>>>');
        obj11.createAccount();
        system.debug('CreateAccount Ends>>>');
        test.stopTest();
    }
    static testmethod void TestcreateAccountmethod1()
    {
        CG_CL_IntakeCustomer mainContr12= new CG_CL_IntakeCustomer();
        CSS_Job_Order__c JO = new CSS_Job_Order__c();
        JO.Unit_Number__c = '123456';
        JO.Customer_Name__c = 'Gopal1';
        JO.First_Name__c = 'hindu';
        JO.Application__c = 'Recreational Vehicle';
        JO.Model__c = 'RajTest';
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
        JO.Status__c = 'Repair Complete';
        //JO.Unit_Number__c = '12345';
        Jo.Assigned_To__c = UserInfo.getUserId();
        Jo.esn__c = '79464646';
        JO.Service_Model__c = 'model';
        JO.Unit_Type__c = 'type';
        JO.Sub_Type__c = 'sub type';
        Jo.Country__c = 'United States';
        Jo.CSS_State__c = 'Indiana';
        JO.Address__c = 'Bangalore';
        JO.ZipCode__c = '12345';
        JO.Primary_Segment__c = 'AG - AGRICULTURE';
        JO.CSS_Charge_Account_Status__c = 'charge';
        Jo.City__c = 'Columbus';
        JO.BMS_Last_Name__c = 'user';
        Jo.Customer_Code__c = '23456';
        Jo.EditComplaint__c = 'complaint';
        Jo.EditCoverage__c = 'coverage';
        Jo.EditCause__c = 'cause';
        Jo.EditCorrection__c = 'correction';
        JO.chevron_page__c = 'prt';
        JO.CSS_Resolution__c = 'Test';
        JO.DSID__c = 'VFD23';
        JO.Email_Address__c = 'gopalraj1@gmail.com';
        //JO.Sub_Status__c = 'Escalated';
        JO.Phone_Number__c = '(876) 546-7899';
        JO.Cstmr_Contacts_Phone__c = '8888888888';
        //JO.Previous_Status__c = 'intake';
        JO.Status__c = 'intake complete';
        JO.PSN_Not_Available__c = false;
        JO.Complaint_Type_Desc__c = 'null';
        JO.Category_Desc__c = 'test';
        JO.Contact_ID__c = 'wee';
        JO.Repair_Location__c = 'Mobile';
        JO.General_Symptoms__c = 'symptoms';
        JO.Shop_Work_Order__c = 'WO';
        JO.Mileage__c = 10.2;
        JO.Application_Desc__c = 'descrption';
        Jo.Category_Desc__c='TEST';
        Jo.Category2_Desc__c='TEST';
        Jo.Category3_Desc__c='TEST';
        Jo.Category4_Desc__c='TEST';
        Jo.Category5_Desc__c='TEST';
        JO.Complaint_Type2_Desc__c = 'ggg';
        JO.Complaint_Type2_Desc__c = 'ttyy';
        JO.Complaint_Type3_Desc__c = 'bbb';
        JO.Complaint_Type4_Desc__c = 'fffh';
        JO.Complaint_Type5_Desc__c = 'coml';
        JO.CSS_Job_Location_Code__c = '56270-56270';
        JO.Mileage_Measure__c = 'mileage';
        JO.Failure_Point_Measure__c = 'failure';
        JO.ESN_Locked__c = true;
        JO.Failure_Date__c = date.today() - 20;
        JO.Warranty_Start_Date__c = date.today() - 365;
        JO.Location_Certification__c = 'abc';
        JO.jobLocation__c = 'abc';
        JO.bmsCreateAccount__c = true;
        JO.Application__c = 'Fire Truck';
        
        insert JO;
        mainContr12.workJob=jo;
        maincontr12.Wid = jo.Id;
        maincontr12.AppointmentName='yes';
        maincontr12.filterApplication='Automotive';
        maincontr12.filterCountry='CA';
        maincontr12.filterState='AB';
        list<account> lstAcc1 = new list<Account>();
        user u = [select id,name from user limit 1];
        list<CSS_UserLocation__c> lstUsrLoc1 =new list<CSS_UserLocation__c>();
        Account a= new Account();
        a.name='Rtest11';
        a.CSS_DistributorCode__c='56270';
        a.CSS_DealerCode__c='56270';
        a.BMS_Enabled__c = true;
        a.CSS_DBCode__c='33333';
        a.Type = 'Customer';
        lstAcc1.add(a);
        Account a1= new Account();
        a1.name='Rtest12';
        a1.CSS_DistributorCode__c='56271';
        a1.CSS_DealerCode__c='56271';
        a1.BMS_Enabled__c = true;
        a1.CSS_DBCode__c='33333';
        a1.Type = 'Customer';
        lstAcc1.add(a1);
        Account a2= new Account();
        a2.name='Rtest123';
        a2.CSS_DistributorCode__c='56272';
        a2.CSS_DealerCode__c='56272';
        a2.BMS_Enabled__c = false;
        a2.CSS_DBCode__c='33333';
        a2.Type = 'Customer';
        lstAcc1.add(a2);
        insert lstAcc1;
        CSS_UserLocation__c userLocation = new CSS_UserLocation__c(AccountId__c=a.id,isActive__c=true,isPrimary__c=true,UserId__c=u.Id,Location_code__c='56270-56270');
        insert userLocation;
        lstUsrLoc1.add(userLocation);
        CSS_CountryStateValues__c stvalue1 = new  CSS_CountryStateValues__c(Name='CA AB',CountryCode__c='CA',CountryName__c='Canada', StateCode__c='AB',StateName__c='Alberta, Canada')  ;
        insert stvalue1;
        //To get codes we need a list_ofvalues
        list<CSS_List_Of_Values__c> lov1 = new list<CSS_List_Of_Values__c>();
        lov1.add( new CSS_List_Of_Values__c(Name ='130AUTO', Type__c='Application Code', Picklist_Values_1__c='Automotive', Code__c='AUTO' ));
        lov1.add( new CSS_List_Of_Values__c(Name ='140AUTO', Type__c='Primary Segment', Picklist_Values_1__c='Automotive', Code__c='AUTO' ));
        insert lov1;
        
        CSS_Integration_Details__c inte = new CSS_Integration_Details__c();
        Blob key = Blob.valueOf('12345678901234567890123456789012');
        string algo = 'AES256';
        inte.Name = 'BMS';
        inte.Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('test')));
        inte.Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('test')));
        inte.Key__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('1234')));
        inte.ApplicationName__c = 'BMS';
        inte.End_Point__c = 'abc.com';
        inte.IsActive__c = true;
        insert inte;
        
        Cache.Session.put('UserERPSystem' , 'BMS Legacy');
        CG_CL_IntakeCustLegacyBMS obj11 = new CG_CL_IntakeCustLegacyBMS();
        obj11.AppointmentName = 'test1';
        obj11.reqBoolean = true;
        obj11.EmailAddress = 'test2';
        obj11.EmailAddress1 = 'test3';
        obj11.filterApplication = 'Automotive';
        obj11.bmsContacterrorMessage = 'test5';
        obj11.strBMSAccountMsg = 'test6';
        obj11.showOutageError = true;        
        obj11.selectedCustCode = '213897';
        obj11.strCntry = 'test7';
        obj11.strCntryState = 'test8';
        obj11.errorMessage = 'test9';
        String str = 'testing';
        obj11.selectedContactID = '213897';
        obj11.mainContr=mainContr12 ;
        test.startTest();
        system.assert(obj11.mainContr.filterApplication!=null);
        
        test.setMock(HttpCalloutMock.class, new CG_SL_BMSMock_Test(true));
        system.debug('CreateAccount Starts>>>');
        obj11.createAccount();
        system.debug('CreateAccount Ends>>>');
        test.stopTest();
    }
    
}