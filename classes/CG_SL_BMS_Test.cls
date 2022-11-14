@IsTest
public class CG_SL_BMS_Test {
	static testMethod void CG_SL_BMS_Test_Method1()
    {
        
         CSS_Integration_Details__c csInt = new CSS_Integration_Details__c();
        csInt.name = 'BMSCustomer';
        csInt.ApplicationName__c='BMSCustomer';
        csInt.AuthEnv__c='Test';
        //csInt.End_Point__c='https://Test-services-dev.cummins.com/css/';
        csInt.End_Point__c='https://api-ue-devnf2-aw-ex.cummins.com/cmi-customers/customer';
        csInt.IsActive__c=true;
        csInt.Key__c='/Q0w11SmTDJ11dPRgzYfGjycs+HZbtT8sezi/jkT7Ag=';
        csInt.Passcode__c='u9pf3rdOE0SCjXDCgmzRbUlwWQWen7B9993Eh61KI1E=';
        csInt.Username__c='6dpW6v5ekUR2HzkTePJXwgNaMDgo0t53tZgmixV4rfU=';
        csInt.Method_Type__c='GET';
        insert csInt;
        Test.startTest();  
        
        CG_OP_OAGWrapper OPWrap = new CG_OP_OAGWrapper();
        CG_SL_BMS slBMSObj = new CG_SL_BMS();
        OPWrap = CG_SL_BMS.fetchBMSCustomerDetails('Test','1234','56270-56255');
        Test.stopTest(); 
    }
    static testMethod void CG_SL_BMS_Test_Method2()
    {
        Test.startTest();  
        
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
        
        //CG_SL_BMS.callMiscLOVService(usrLocLst);
        
        Test.stopTest(); 
    }
    
    static testMethod void CG_SL_BMS_Test_Method3()
    {
        Test.startTest();  
        
        CG_OP_OAGWrapper OPWrap = new CG_OP_OAGWrapper();
        CG_SL_BMS slBMSObj = new CG_SL_BMS();
        OPWrap = CG_SL_BMS.createBMSAccount('Test','103F','PowersFerry Road','Atlanta','30067','6789886532','Atlanta','Georgia','30067','T','Test','123','Test','Test','56270-56255');
        Test.stopTest(); 
    }
    
    static testMethod void CG_SL_BMS_Test_Method3_1()
    {
        Test.startTest();  
        Test.setMock(HttpCalloutMock.class, new CG_SL_BMSMock_Test2());
        CG_OP_OAGWrapper OPWrap = new CG_OP_OAGWrapper();
        CG_SL_BMS slBMSObj = new CG_SL_BMS();
        OPWrap = CG_SL_BMS.createBMSAccount('Test','103F','PowersFerry Road','Atlanta','30067','6789886532','Atlanta','Georgia','30067','T','Test','123','Test','Test','56270-56255');
        Test.stopTest(); 
    }
    
    static testMethod void CG_SL_BMS_Test_Method4()
    {
        Test.startTest();
        CG_OP_OAGWrapper OPWrap = new CG_OP_OAGWrapper();
        CG_SL_BMS slBMSObj = new CG_SL_BMS();
        OPWrap = CG_SL_BMS.getBMSPrivateSRTs('56270','56255','0K','56270-56255');
        Test.stopTest(); 
    }
    
    static testMethod void CG_SL_BMS_Test_Method4_1()
    {
        CSS_Integration_Details__c csInt = new CSS_Integration_Details__c();
        csInt.name = 'BMSPrivateSRTs';
        csInt.ApplicationName__c='BMSPrivateSRTs';
        csInt.AuthEnv__c='Test';
        //csInt.End_Point__c='https://Test-services-dev.cummins.com/css/';
        csInt.End_Point__c='https://api-ue-devnf-aw-ex.cummins.com/cmi-engine/standardrepairstime/private';
        csInt.IsActive__c=true;
        csInt.Key__c='/Q0w11SmTDJ11dPRgzYfGjycs+HZbtT8sezi/jkT7Ag=';
        csInt.Passcode__c='u9pf3rdOE0SCjXDCgmzRbUlwWQWen7B9993Eh61KI1E=';
        csInt.Username__c='6dpW6v5ekUR2HzkTePJXwgNaMDgo0t53tZgmixV4rfU=';
        csInt.Method_Type__c='GET';
        insert csint;
        Test.startTest();   
        Test.setMock(HttpCalloutMock.class, new CG_SL_BMSMock_Test2()); 
        
        CG_OP_OAGWrapper OPWrap = new CG_OP_OAGWrapper();
        CG_SL_BMS slBMSObj = new CG_SL_BMS();
        OPWrap = CG_SL_BMS.getBMSPrivateSRTs('56270','56255','0K','56270-56255');
        Test.stopTest(); 
    }
    static testMethod void CG_SL_BMS_Test_Method5()
    {
        
        Test.startTest();  
        CSS_Integration_Details__c csInt = new CSS_Integration_Details__c();
        csInt.name = 'getBMSCustomerCreditMsgs';
        csInt.ApplicationName__c='getBMSCustomerCreditMsgs';
        csInt.AuthEnv__c='Test';
        //csInt.End_Point__c='https://Test-services-dev.cummins.com/css/';
        csInt.End_Point__c='https://api-ue-devnf-aw-ex.cummins.com/cmi/warranty/v1/credit';
        csInt.IsActive__c=true;
        csInt.Key__c='/Q0w11SmTDJ11dPRgzYfGjycs+HZbtT8sezi/jkT7Ag=';
        csInt.Passcode__c='u9pf3rdOE0SCjXDCgmzRbUlwWQWen7B9993Eh61KI1E=';
        csInt.Username__c='6dpW6v5ekUR2HzkTePJXwgNaMDgo0t53tZgmixV4rfU=';
        csInt.Method_Type__c='GET';
        insert csint;
        CG_OP_OAGWrapper OPWrap = new CG_OP_OAGWrapper();
        CG_SL_BMS slBMSObj = new CG_SL_BMS();
        OPWrap = CG_SL_BMS.getBMSCustomerCreditMsgs('123','56270-56255');
        CG_SL_BMS.getBMSCustomerCreditMsgs(null,null);
        CG_SL_BMS.getBMSPrivateSRTs(null,null,null,null);
        CG_SL_BMS.getBMSCustomerCreditMsgs(null,null);
        Test.stopTest(); 
    }
    static testMethod void CG_SL_BMS_Test_Method5_1()
    {
        Test.startTest();    
        Test.setMock(HttpCalloutMock.class, new CG_SL_BMSMock_Test2());
        
        CG_OP_OAGWrapper OPWrap = new CG_OP_OAGWrapper();
        CG_SL_BMS slBMSObj = new CG_SL_BMS();
        OPWrap = CG_SL_BMS.getBMSCustomerCreditMsgs('123','56270-56255');
        Test.stopTest(); 
    }
    static testMethod void CG_SL_BMS_Test_Method6()
    {
        Test.startTest(); 
        CG_IP_CustCreditMsgReqJSON custReqJSON = new CG_IP_CustCreditMsgReqJSON();
        CG_SL_BMS slBMSObj = new CG_SL_BMS();
        custReqJSON = CG_SL_BMS.prepareReqWprForCustCreditMsgs('123','56270-56255','GetCustomerCreditMessage','CSS','BMS');
        Test.stopTest(); 
    }
    static testMethod void CG_SL_BMS_Test_Method7()
    {
        CSS_Integration_Details__c csInt = new CSS_Integration_Details__c();
        csInt.name = 'getMISCChargeLOVs';
        csInt.ApplicationName__c='getMISCChargeLOVs';
        csInt.AuthEnv__c='Test';
        //csInt.End_Point__c='https://Test-services-dev.cummins.com/css/';
        csInt.End_Point__c='https://api-ue-devnf-aw-ex.cummins.com/jobs/misccharge';
        csInt.IsActive__c=true;
        csInt.Key__c='/Q0w11SmTDJ11dPRgzYfGjycs+HZbtT8sezi/jkT7Ag=';
        csInt.Passcode__c='u9pf3rdOE0SCjXDCgmzRbUlwWQWen7B9993Eh61KI1E=';
        csInt.Username__c='6dpW6v5ekUR2HzkTePJXwgNaMDgo0t53tZgmixV4rfU=';
        csInt.Method_Type__c='GET';
        insert csint;
        Test.startTest(); 
        CG_OP_OAGWrapper OPWrap = new CG_OP_OAGWrapper();
        CG_SL_BMS slBMSObj = new CG_SL_BMS();
        OPWrap = CG_SL_BMS.getMISCChargeLOVs('56270','56255','56270-56255');
        Test.stopTest(); 
    }
    static testMethod void CG_SL_BMS_Test_Method7_1()
    {
        Test.startTest(); 
        Test.setMock(HttpCalloutMock.class, new CG_SL_BMSMock_Test1());
        CG_OP_OAGWrapper OPWrap = new CG_OP_OAGWrapper();
        CG_SL_BMS slBMSObj = new CG_SL_BMS();
        OPWrap = CG_SL_BMS.getMISCChargeLOVs('56270','56255','56270-56255');
        Test.stopTest(); 
    }
    static testMethod void CG_SL_BMS_Test_Method8()
    {
       
        //Test.setMock(HttpCalloutMock.class, new CG_SL_BMSMock_Test());
        CSS_Integration_Details__c csInt = new CSS_Integration_Details__c();
        csInt.name = 'CG_BMSSendMiscCharges';
        csInt.ApplicationName__c='CG_BMSSendMiscCharges';
        csInt.AuthEnv__c='Test';
        //csInt.End_Point__c='https://Test-services-dev.cummins.com/css/';
        csInt.End_Point__c=' https://api-ue-devnf-aw-ex.cummins.com/jobs/misccharge';
        csInt.IsActive__c=true;
        csInt.Key__c='/Q0w11SmTDJ11dPRgzYfGjycs+HZbtT8sezi/jkT7Ag=';
        csInt.Passcode__c='u9pf3rdOE0SCjXDCgmzRbUlwWQWen7B9993Eh61KI1E=';
        csInt.Username__c='6dpW6v5ekUR2HzkTePJXwgNaMDgo0t53tZgmixV4rfU=';
        csInt.Method_Type__c='POST';
        insert csint;
        css_job_order__c jo = CSS_TestData.createJobOrder(false);
        jo.Customer_Name__c='Test';
        jo.Customer_Code__c='123';
        jo.ESN__c='87965437';
        jo.Non_SRT_Details__c='Testing';
        jo.Quote_ID__c = '3452671234';
        //insert jo;
		
        CSS_Solution_Component__c sol = new CSS_Solution_Component__c();
        sol.Claim_Type__c = 'test';
        //insert sol;
         Profile p = [SELECT Id FROM Profile WHERE Name='CSS_Service_Advanced']; 
        User usr = new User(Alias = 'standt', Email='standarduser4@testorg.com', 
                            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', FederationIdentifier = 'pk548',
                            LocaleSidKey='en_US',  ProfileId = p.Id, 
                            TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTestUser14@testorg.com',User_Location__c = '56270-56270');
        insert usr;
        list<CSS_Parts_Options__c> lstpart = new list<CSS_Parts_Options__c>();
        CSS_Parts_Options__c partobj = new CSS_Parts_Options__c();
        partobj.Account_Code__c='123';
        partobj.Address1__c = 'test';
        partobj.FailurepartId__c = sol.id;
        partobj.City__c = 'test';
         partobj.Item__c = 'BELT';
        partobj.Siebel_Value__c = 'BELT';
       partobj.CreatedById=usr.id;
        //partobj.Claim_Type__c='test';
       List<CSS_Parts_Options__c> plist= [select id, name, Account_Code__c,Address1__c, FailurepartId__c,City__c ,Item__c, Siebel_Value__c from CSS_Parts_Options__c ];
        lstpart.add(partobj);        
       
        CSS_Parts_Options__c partobj1 = new CSS_Parts_Options__c();
        partobj1.Account_Code__c='123';
        partobj1.Address1__c = 'test';
        partobj1.City__c = 'test';
        partobj1.Item__c = 'BELT';
        partobj1.Siebel_Value__c = 'BELT1';
        partobj1.CreatedById=usr.id;
        lstpart.add(partobj1);     
        //insert lstpart;
         system.debug('partobj '+partobj);
        User u =[select id, name,FederationIdentifier from user where id =: userinfo.getUserId()];
        system.debug('userobj '+u);
 		List<CSS_Parts_Options__c> plist1= [select id, name,Claim_Type__c,LastModifiedById,RecordType.Name,Sell_Price__c,Unit_Price__c,Quantity__c,CreatedById, Account_Code__c,Address1__c, FailurepartId__c,City__c ,Item__c, Siebel_Value__c from CSS_Parts_Options__c ];        
        system.debug('plist1 '+plist1);
       
		CSS_Integration_Details__C itgDetails = new CSS_Integration_Details__c(Name='CG_BMSSendMiscCharges',ApplicationName__c='CG_BMSSendMiscCharges',AuthEnv__c='OAGDev',End_Point__c='https://services-dev.cummins.com/css/technicianservicerequest',IsActive__c=true,Key__c='b0QfgPgFJRwt0xwYgr97QE2cfWVuIa1UR96ot+uKp4M=',Method_Type__c='POST',Passcode__c='K6FYOp/RdbTZ1NixD44NYHuX0m9cpk/VCucdeUVPNEY=',Timeout__c=120);
        //insert itgDetails;
		
 		Test.startTest(); 
        system.runAs(new user(id = userinfo.getUserId())){
             CG_OP_OAGWrapper OPWrap = new CG_OP_OAGWrapper();
        CG_SL_BMS slBMSObj = new CG_SL_BMS();
        OPWrap = CG_SL_BMS.sendMISCCharges('56270-56255',jo.Name,'56270','56255','123','WOQT',jo.Quote_ID__c,lstpart,'Y');
        }
        
       
        Test.stopTest(); 
    }
    static testMethod void CG_SL_BMS_Test_MethodSendMiscOC()
    {
       Id recTypeIdpart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'OtherClaimables');
        Id recTypeIdpart1 = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'TTML');
        CSS_Integration_Details__c csInt = new CSS_Integration_Details__c();
        csInt.name = 'CG_BMSSendMiscCharges';
        csInt.ApplicationName__c='CG_BMSSendMiscCharges';
        csInt.AuthEnv__c='Test';
        //csInt.End_Point__c='https://Test-services-dev.cummins.com/css/';
        csInt.End_Point__c=' https://api-ue-devnf-aw-ex.cummins.com/jobs/misccharge';
        csInt.IsActive__c=true;
        csInt.Key__c='/Q0w11SmTDJ11dPRgzYfGjycs+HZbtT8sezi/jkT7Ag=';
        csInt.Passcode__c='u9pf3rdOE0SCjXDCgmzRbUlwWQWen7B9993Eh61KI1E=';
        csInt.Username__c='6dpW6v5ekUR2HzkTePJXwgNaMDgo0t53tZgmixV4rfU=';
        csInt.Method_Type__c='POST';
        insert csint;
        //Test.setMock(HttpCalloutMock.class, new CG_SL_BMSMock_Test());
        css_job_order__c jo = CSS_TestData.createJobOrder(false);
        jo.Customer_Name__c='Test';
        jo.Customer_Code__c='123';
        jo.ESN__c='87965437';
        jo.Non_SRT_Details__c='Testing';
        jo.Quote_ID__c = '3452671234';
        //insert jo;
		
        CSS_Solution_Component__c sol = new CSS_Solution_Component__c();
        sol.Claim_Type__c = 'test';
        //insert sol;
         Profile p = [SELECT Id FROM Profile WHERE Name='CSS_Service_Advanced']; 
        User usr = new User(Alias = 'standt', Email='standarduser4@testorg.com', 
                            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', FederationIdentifier = 'pk548',
                            LocaleSidKey='en_US',  ProfileId = p.Id, 
                            TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTestUser14@testorg.com',User_Location__c = '56270-56270');
        insert usr;
        list<CSS_Parts_Options__c> lstpart = new list<CSS_Parts_Options__c>();
        CSS_Parts_Options__c partobj = new CSS_Parts_Options__c();
        partobj.Account_Code__c='123';
        partobj.Address1__c = 'test';
        partobj.FailurepartId__c = sol.id;
        partobj.City__c = 'test';
         partobj.Item__c = 'BELT';
        partobj.Siebel_Value__c = 'BELT';
       partobj.CreatedById=usr.id;
        partobj.RecordTypeId = recTypeIdpart;
        //partobj.Claim_Type__c='test';
       List<CSS_Parts_Options__c> plist= [select id, name, Account_Code__c,Address1__c, FailurepartId__c,City__c ,Item__c, Siebel_Value__c from CSS_Parts_Options__c ];
        lstpart.add(partobj);        
       
        CSS_Parts_Options__c partobj1 = new CSS_Parts_Options__c();
        partobj1.Account_Code__c='123';
        partobj1.Address1__c = 'test';
        partobj1.City__c = 'test';
        partobj1.Item__c = 'BELT';
        partobj1.Siebel_Value__c = 'BELT1';
        partobj1.CreatedById=usr.id;
        partobj1.RecordTypeId = recTypeIdpart1;
        lstpart.add(partobj1);     
        //insert lstpart;
         system.debug('partobj '+partobj);
        User u =[select id, name,FederationIdentifier from user where id =: userinfo.getUserId()];
        system.debug('userobj '+u);
 		List<CSS_Parts_Options__c> plist1= [select id, name,Claim_Type__c,LastModifiedById,RecordType.Name,Sell_Price__c,Unit_Price__c,Quantity__c,CreatedById, Account_Code__c,Address1__c, FailurepartId__c,City__c ,Item__c, Siebel_Value__c from CSS_Parts_Options__c ];        
        system.debug('plist1 '+plist1);
       
		CSS_Integration_Details__C itgDetails = new CSS_Integration_Details__c(Name='CG_BMSSendMiscCharges',ApplicationName__c='CG_BMSSendMiscCharges',AuthEnv__c='OAGDev',End_Point__c='https://services-dev.cummins.com/css/technicianservicerequest',IsActive__c=true,Key__c='b0QfgPgFJRwt0xwYgr97QE2cfWVuIa1UR96ot+uKp4M=',Method_Type__c='POST',Passcode__c='K6FYOp/RdbTZ1NixD44NYHuX0m9cpk/VCucdeUVPNEY=',Timeout__c=120);
        //insert itgDetails;
		
 		Test.startTest(); 
        system.runAs(new user(id = userinfo.getUserId())){
             CG_OP_OAGWrapper OPWrap = new CG_OP_OAGWrapper();
        CG_SL_BMS slBMSObj = new CG_SL_BMS();
        OPWrap = CG_SL_BMS.sendMISCCharges('56270-56255',jo.Name,'56270','56255','123','WOQT',jo.Quote_ID__c,lstpart,'Y');
        }
        
       
        Test.stopTest(); 
    }
    static testMethod void CG_SL_BMS_Test_Method9()
    {
        Test.startTest(); 
        
        css_job_order__c jo = CSS_TestData.createJobOrder(false);
        jo.Customer_Name__c='Test';
        jo.Customer_Code__c='123';
        jo.ESN__c='87965437';
        jo.Non_SRT_Details__c='Testing';
        jo.Quote_ID__c = '3452671234';
        jo.Shop_Work_Order__c = '334';
        //insert jo;
        
        CG_OP_OAGWrapper OPWrap = new CG_OP_OAGWrapper();
        CG_SL_BMS slBMSObj = new CG_SL_BMS();
        OPWrap = CG_SL_BMS.deleteBMSJob(jo.Name,'56270-56255','123','WO',jo.Shop_Work_Order__c,'Cancelled');
        Test.stopTest(); 
    }
    
    static testMethod void CG_SL_BMS_Test_Method10()
    {
        
        Profile p = [SELECT Id FROM Profile WHERE Name='CSS_Service_Advanced']; 
        User usr = new User(Alias = 'standt', Email='standarduser4@testorg.com', 
                            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', FederationIdentifier = 'pk548',
                            LocaleSidKey='en_US',  ProfileId = p.Id, 
                            TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTestUser14@testorg.com',User_Location__c = '56270-56270');
        insert usr;
        css_job_order__c jo = CSS_TestData.createJobOrder(false);
        CSS_Integration_Details__c csInt = new CSS_Integration_Details__c();
        csInt.name = 'CG_SendClaimHeadertoBMS';
        csInt.ApplicationName__c='CG_SendClaimHeadertoBMS';
        csInt.AuthEnv__c='Test';
        //csInt.End_Point__c='https://Test-services-dev.cummins.com/css/';
        csInt.End_Point__c='https://api-ue-devnf-aw-ex.cummins.com/cmi-claims/header';
        csInt.IsActive__c=true;
        csInt.Key__c='/Q0w11SmTDJ11dPRgzYfGjycs+HZbtT8sezi/jkT7Ag=';
        csInt.Passcode__c='u9pf3rdOE0SCjXDCgmzRbUlwWQWen7B9993Eh61KI1E=';
        csInt.Username__c='6dpW6v5ekUR2HzkTePJXwgNaMDgo0t53tZgmixV4rfU=';
        csInt.Method_Type__c='POST';
        insert csint;
        system.runAs(usr)
        {
            Test.startTest(); 
            
            jo.Customer_Name__c='Test';
            jo.Customer_Code__c='123';
            jo.ESN__c='87965437';
            jo.Non_SRT_Details__c='Testing';
            jo.Quote_ID__c = '3452671234';
            jo.Shop_Work_Order__c = '334';
            jo.Failure_Date__c = Date.today()-10;
            jo.ESN__c = '79464646';
            jo.Warranty_Start_Date__c = Date.today()-10;
            jo.Service_Model__c = 'Test';
            jo.Make__c = 'PETERBILT';
            jo.Model__c ='365';
            jo.Unit_Type__c = 'CONVENTIONAL';
            jo.ApplicationCode__c = '130';
            jo.Mileage__c = 222;
            jo.Mileage_Measure__c = 'MILES';
            jo.CSS_Hours__c = 22;
            insert jo;
    
            list<CSS_Solution_Component__c> lstsolcomp = new list<CSS_Solution_Component__c>();
            CSS_Solution_Component__c solCompObj = new CSS_Solution_Component__c();
            solCompObj.Service_Job__c = jo.Id;
            //solCompObj.Type__c = 'Campaign';
            solCompObj.Selected_Component__c= true; 
            solCompObj.Notes__c = 'testNotes';
            solCompObj.Pay_Code__c='I';        
            //solCompObj.AccountCodeType__c  = 'Emissions Warranty';
            //solCompObj.AccountCode__c = '70';
            //solCompObj.AccountCodeEdit__c = 'Emissions Warranty70';
            solCompObj.AccountCode__c = 'CZ';
            solCompObj.AccountCodeType__c = 'BJT-ZEUS Comsioning';
            solCompObj.AccountCodeEdit__c = 'BJT-ZEUS Comsioning CZ';
            solCompObj.Claim_Type__c = 'AMMPS';  
            solCompObj.CoveredTravelLabor__c = '5';
            solCompObj.CoveredTravelMiles__c ='100';
            solCompObj.CoveredTowingMiles__c = '100';
            
            lstsolcomp.add(solCompObj);
            
            CSS_Solution_Component__c solCompObj1 = new CSS_Solution_Component__c();
            solCompObj1.Service_Job__c = jo.Id;
            //solCompObj.Type__c = 'Campaign';
            solCompObj1.Selected_Component__c= true; 
            solCompObj1.Notes__c = 'testNotes';
            solCompObj1.Pay_Code__c='I';        
            //solCompObj.AccountCodeType__c  = 'Emissions Warranty';
            //solCompObj.AccountCode__c = '70';
            //solCompObj.AccountCodeEdit__c = 'Emissions Warranty70';
            solCompObj1.AccountCode__c = 'CZ';
            solCompObj1.AccountCodeType__c = 'BJT-ZEUS Comsioning';
            solCompObj1.AccountCodeEdit__c = 'BJT-ZEUS Comsioning CZ';
            solCompObj1.Claim_Type__c = 'AMMPS';  
            solCompObj1.CoveredTravelLabor__c = '5';
            solCompObj1.CoveredTravelMiles__c ='0';
            solCompObj1.CoveredTowingMiles__c = '0';
            solCompObj1.CertificateNumber__c = '12345';
            solCompObj1.Authorization_Number__c = '345678';
            solCompObj1.Approval_Code__c = '23';
            solCompObj1.DeductibleAmount__c = '5';
            
            lstsolcomp.add(solCompObj1);
            
            //insert lstsolcomp;            
            system.debug('****acccode***'+lstsolcomp[0].AccountCode__c);
            system.debug('****acccode***'+lstsolcomp[0].AccountCodeType__c);
            system.debug('****acccode***'+lstsolcomp[0].AccountCodeEdit__c);
            system.debug('****acccode***'+lstsolcomp[0].CSS_Account_Formula__c);
            system.debug('****acccode***'+lstsolcomp[0].CreatedById);
        
            CG_OP_OAGWrapper OPWrap = new CG_OP_OAGWrapper();
            CG_SL_BMS slBMSObj = new CG_SL_BMS();
            OPWrap = CG_SL_BMS.sendClaimHeadertoBMS('56270-56255',jo.Name,'56270','56255','123','WOQT',jo.Quote_ID__c,lstsolcomp,jo);
        	Test.stopTest(); 
        }
        
    }
    
    static testMethod void CG_SL_BMS_Test_Method10_1()
    {
        
        Profile p = [SELECT Id FROM Profile WHERE Name='CSS_Service_Advanced']; 
        User usr = new User(Alias = 'standt', Email='standarduser4@testorg.com', 
                            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', FederationIdentifier = 'pk548',
                            LocaleSidKey='en_US',  ProfileId = p.Id, 
                            TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTestUser14@testorg.com',User_Location__c = '56270-56270');
        insert usr;
         
            css_job_order__c jo = CSS_TestData.createJobOrder(false);
        system.runAs(usr)
        {
            Test.startTest();
            jo.Customer_Name__c='Test';
            jo.Customer_Code__c='123';
            jo.ESN__c='87965437';
            jo.Non_SRT_Details__c='Testing';
            jo.Quote_ID__c = '3452671234';
            jo.Shop_Work_Order__c = '334';
            jo.Failure_Date__c = Date.today()-10;
            jo.ESN__c = '79464646';
            jo.Warranty_Start_Date__c = Date.today()-10;
            jo.Service_Model__c = 'Test';
            jo.Make__c = 'PETERBILT';
            jo.Model__c ='365';
            jo.Unit_Type__c = 'CONVENTIONAL';
            jo.ApplicationCode__c = '130';
            jo.Mileage__c = 222;
            jo.Mileage_Measure__c = 'MILES';
            jo.CSS_Hours__c = 22;
            insert jo;
    
            list<CSS_Solution_Component__c> lstsolcomp = new list<CSS_Solution_Component__c>();
            CSS_Solution_Component__c solCompObj = new CSS_Solution_Component__c();
            solCompObj.Service_Job__c = jo.Id;
            solCompObj.Type__c = 'Campaign';
            solCompObj.Selected_Component__c= true; 
            solCompObj.Notes__c = 'testNotes';
            solCompObj.Pay_Code__c='I';        
            //solCompObj.AccountCodeType__c  = 'Emissions Warranty';
            //solCompObj.AccountCode__c = '70';
            //solCompObj.AccountCodeEdit__c = 'Emissions Warranty70';
            solCompObj.AccountCode__c = 'CZ';
            solCompObj.AccountCodeType__c = 'BJT-ZEUS Comsioning';
            solCompObj.AccountCodeEdit__c = 'BJT-ZEUS Comsioning CZ';
            solCompObj.Claim_Type__c = 'AMMPS';  
            solCompObj.CoveredTravelLabor__c = '5';
            solCompObj.CoveredTravelMiles__c ='100';
            solCompObj.CoveredTowingMiles__c = '100';
            solCompObj.CertificateNumber__c = '12345';
            solCompObj.Authorization_Number__c = '345678';
            solCompObj.Approval_Code__c = '23';
            solCompObj.DeductibleAmount__c = '5';
            
            lstsolcomp.add(solCompObj);
            
            CSS_Solution_Component__c solCompObj1 = new CSS_Solution_Component__c();
            solCompObj1.Service_Job__c = jo.Id;
            solCompObj1.Type__c = 'Campaign';
            solCompObj1.Selected_Component__c= true; 
            solCompObj1.Notes__c = 'testNotes';
            solCompObj1.Pay_Code__c='I';        
            //solCompObj.AccountCodeType__c  = 'Emissions Warranty';
            //solCompObj.AccountCode__c = '70';
            //solCompObj.AccountCodeEdit__c = 'Emissions Warranty70';
            solCompObj1.AccountCode__c = 'CZ';
            solCompObj1.AccountCodeType__c = 'BJT-ZEUS Comsioning';
            solCompObj1.AccountCodeEdit__c = 'BJT-ZEUS Comsioning CZ';
            solCompObj1.Claim_Type__c = 'AMMPS';  
            solCompObj1.CoveredTravelLabor__c = '5';
            solCompObj1.CoveredTravelMiles__c ='0';
            solCompObj1.CoveredTowingMiles__c = '0';
            solCompObj1.CertificateNumber__c = '12345';
            solCompObj1.Authorization_Number__c = '345678';
            solCompObj1.Approval_Code__c = '23';
            solCompObj1.DeductibleAmount__c = '5';
            
            lstsolcomp.add(solCompObj1);
            
            //insert lstsolcomp;            
            system.debug('****acccode***'+lstsolcomp[0].AccountCode__c);
            system.debug('****acccode***'+lstsolcomp[0].AccountCodeType__c);
            system.debug('****acccode***'+lstsolcomp[0].AccountCodeEdit__c);
            system.debug('****acccode***'+lstsolcomp[0].CSS_Account_Formula__c);
            system.debug('****acccode***'+lstsolcomp[0].CreatedById);
        
            CG_OP_OAGWrapper OPWrap = new CG_OP_OAGWrapper();
            CG_SL_BMS slBMSObj = new CG_SL_BMS();
            OPWrap = CG_SL_BMS.sendClaimHeadertoBMS('56270-56255',jo.Name,'56270','56255','123','WOQT',jo.Quote_ID__c,lstsolcomp,jo);
        	Test.stopTest(); 
        }
        
    }
    
    static testMethod void CG_SL_BMS_Test_Method11()
    {
        //Test.startTest(); 
        CSS_Integration_Details__c csInt = new CSS_Integration_Details__c();
        csInt.name = 'CG_BMSSendFailurecodes';
        csInt.ApplicationName__c='CG_BMSSendFailurecodes';
        csInt.AuthEnv__c='Test';
        //csInt.End_Point__c='https://Test-services-dev.cummins.com/css/';
        csInt.End_Point__c='https://api-ue-devnf-aw-ex.cummins.com/cmi-engine/failcodes';
        csInt.IsActive__c=true;
        csInt.Key__c='/Q0w11SmTDJ11dPRgzYfGjycs+HZbtT8sezi/jkT7Ag=';
        csInt.Passcode__c='u9pf3rdOE0SCjXDCgmzRbUlwWQWen7B9993Eh61KI1E=';
        csInt.Username__c='6dpW6v5ekUR2HzkTePJXwgNaMDgo0t53tZgmixV4rfU=';
        csInt.Method_Type__c='GET';
        insert csint;
        css_job_order__c jo = CSS_TestData.createJobOrder(false);
        jo.Customer_Name__c='Test';
        jo.Customer_Code__c='123';
        jo.ESN__c='87965437';
        jo.Non_SRT_Details__c='Testing';
        jo.Quote_ID__c = '3452671234';
        jo.Shop_Work_Order__c = '334';
        insert jo;

        list<CSS_Solution_Component__c> lstsolcomp = new list<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solCompObj = new CSS_Solution_Component__c();
        solCompObj.Service_Job__c = jo.Id;
        //solCompObj.Type__c = 'Campaign';
        solCompObj.Selected_Component__c= true; 
        solCompObj.AccountCode__c ='testing';
        // solCompObj.Fail_Code__c = 'test';
        solCompObj.Notes__c = 'testNotes';
        solCompObj.Pay_Code__c='testPay';        
        solCompObj.AccountCodeType__c  = 'ACCOUNT TEAM COVERAGE';
        solCompObj.AccountCode__c = '27';
        solCompObj.AccountCodeEdit__c = 'ACCOUNT TEAM COVERAGE 27';
        lstsolcomp.add(solCompObj);
        insert lstsolcomp;
        Test.startTest();
        string json ='{"token_type":"Bearer","expires_in":"3600","ext_expires_in":"3600", "expires_on":"1562583448","not_before":"1562579548","resource":"https://api-ue-devnf-aw-ex.cummins.com/cmi-sp","access_token":"eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsIng1dCI6IkN0ZlFDOExlLThOc0M3b0MyelFrWnBjcmZPYyIsImtpZCI6IkN0ZlFDOExlLThOc0M3b0MyelFrWnBjcmZPYyJ9.eyJhdWQiOiJodHRwczovL2Fw"}';
        string json1= '{"Header":{"Target":{"TargetID":"TSR"},"Sender":{"ServiceName":"UpsertTSR","SenderID":"GUIDANZ"}},"DataArea":{"UOM":"","TechID":null,"Symptom":"559","SupportLevel":"Cummins CARE Level 1","Status":"Open","SRNumber":"","SPCode":"21933","ShopWO":"","RepeatVisit":"N","PSN":"79464646","MileageValue":"","GeneralSymptoms":"test v","FaultCodeStatus":null,"FaultCode":null,"FailureDate":"11/7/2017","EscalationText":"","EscalationGroup":"HMLD","CustomerName":"test","CSSJobID":"CSS-00070849","ContactPhoneNumber":"","ContactLastName":"Anirudh","ContactFirstName":"Pesari","ContactEmail":"pesari.anirudhcummins.com","ComplaintCode":"101","AttachmentURL":""}}';
        CG_CL_HttpRequestMock mock1 = new CG_CL_HttpRequestMock(200,'Complete',json,null);
        CG_CL_HttpRequestMock mock2 = new CG_CL_HttpRequestMock(200,'Complete',json1,null);
        Map<String, HttpCalloutMock> endpointsResponse =new Map<String,HttpCalloutMock>();
        endpointsResponse.put('https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/auth/token',mock1);
        endpointsResponse.put('https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/send/data',mock2);
        HttpCalloutMock multiCalloutMock =  new CG_CL_HTTPMultiRequestMock(endpointsResponse);
        Test.setMock(HttpCalloutMock.class, multiCalloutMock);
        CG_OP_OAGWrapper OPWrap = new CG_OP_OAGWrapper();
        CG_SL_BMS slBMSObj = new CG_SL_BMS();
        OPWrap = CG_SL_BMS.sendFailurecode('56270-56255',jo.Name,'56270','56255','123','WOQT',jo.Quote_ID__c,lstsolcomp);
         CG_SL_BMS.getBMSPrivateSRTs(null, null, null, null);
        Test.stopTest(); 
    }
    static testMethod void CG_SL_BMS_Test_Method11_1()
    {
        Test.startTest(); 
        Test.setMock(HttpCalloutMock.class, new CG_SL_BMSMock_Test2());
        css_job_order__c jo = CSS_TestData.createJobOrder(false);
        jo.Customer_Name__c='Test';
        jo.Customer_Code__c='123';
        jo.ESN__c='87965437';
        jo.Non_SRT_Details__c='Testing';
        jo.Quote_ID__c = '3452671234';
        jo.Shop_Work_Order__c = '334';
        //insert jo;
		CSS_Integration_Details__c csInt = new CSS_Integration_Details__c();
        csInt.name = 'CG_BMSSendFailurecodes';
        csInt.ApplicationName__c='CG_BMSSendFailurecodes';
        csInt.AuthEnv__c='Test';
        //csInt.End_Point__c='https://Test-services-dev.cummins.com/css/';
        csInt.End_Point__c='https://api-ue-devnf-aw-ex.cummins.com/cmi-engine/failcodes';
        csInt.IsActive__c=true;
        csInt.Key__c='/Q0w11SmTDJ11dPRgzYfGjycs+HZbtT8sezi/jkT7Ag=';
        csInt.Passcode__c='u9pf3rdOE0SCjXDCgmzRbUlwWQWen7B9993Eh61KI1E=';
        csInt.Username__c='6dpW6v5ekUR2HzkTePJXwgNaMDgo0t53tZgmixV4rfU=';
        csInt.Method_Type__c='GET';
        insert csint;
        list<CSS_Solution_Component__c> lstsolcomp = new list<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solCompObj = new CSS_Solution_Component__c();
        solCompObj.Service_Job__c = jo.Id;
        //solCompObj.Type__c = 'Campaign';
        solCompObj.Selected_Component__c= true; 
        solCompObj.AccountCode__c ='testing';
        // solCompObj.Fail_Code__c = 'test';
        solCompObj.Notes__c = 'testNotes';
        solCompObj.Pay_Code__c='testPay';        
        solCompObj.AccountCodeType__c  = 'ACCOUNT TEAM COVERAGE';
        solCompObj.AccountCode__c = '27';
        solCompObj.AccountCodeEdit__c = 'ACCOUNT TEAM COVERAGE 27';
        lstsolcomp.add(solCompObj);
        //insert lstsolcomp;
        
        CG_OP_OAGWrapper OPWrap = new CG_OP_OAGWrapper();
        CG_SL_BMS slBMSObj = new CG_SL_BMS();
        OPWrap = CG_SL_BMS.sendFailurecode('56270-56255',jo.Name,'56270','56255','123','WOQT',jo.Quote_ID__c,lstsolcomp);
        CG_SL_BMS.deleteBMSJob(null,null,null,null,null,null);
        Test.stopTest(); 
    }
    
    static testMethod void CG_SL_BMS_Test_Method11_2(){
        CG_OP_OAGWrapper returnWrapper = new CG_OP_OAGWrapper();
        try{
             returnWrapper = CG_SL_BMS.fetchBMSCustomerDetails(null,null,null);
        }
        catch(Exception e){}
         CG_SL_BMS.createBMSAccount(null, null, null, null, null, null, null, null, null, null, null, null, null, null, null);
         CG_SL_BMS.getBMSPrivateSRTs(null, null, null, null);
         CG_SL_BMS.getBMSCustomerCreditMsgs(null, null);
         CG_SL_BMS.prepareReqWprForCustCreditMsgs(null,null,null,null,null);
         CG_SL_BMS.getMISCChargeLOVs(null,null,null) ;
        // CG_SL_BMS.sendMISCCharges(null,null,null,null,null, null, null, null, null);
         CG_SL_BMS.deleteBMSJob(null,null,null,null,null,null);
         CG_SL_BMS.sendClaimHeadertoBMS(null,null,null,null,null, null, null, null, null);
         CG_SL_BMS.prepareReqWprForClaimHeadertoBMS(null,null,null,null,null, null, null, null, null);
         
         //CG_SL_BMS.sendFailurecode(null,null,null,null,null,null,null,null);
    }
}