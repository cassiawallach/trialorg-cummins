@isTest
public class CG_BL_Campaigns_Test { 
    
    @testsetup static void testsetupdata()
    {
        
        Profile p = [SELECT Id FROM Profile WHERE Name='CSS_Service_Advanced']; 
        User u = new User(Alias = 'standt', Email='standarduser4@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US',  ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTestUser4@testorg.com',User_Location__c = '56270-56270');
        insert u;
    }
    
    static  testMethod void CG_BL_Campaigns_getAccCodesTestMethod() {
        Test.startTest();
        CSS_Job_Order__c JO = new CSS_Job_Order__c();
        CSS_Integration_Details__c cid = CSS_TestData.createIntegrationDetails(false);
        cid.name = 'CSS_SBL_WarrantyDetailCoverage';
        cid.ApplicationName__c = 'CSS_SBL_WarrantyDetailCoverage';
        cid.End_Point__c = 'https://services-stg.cummins.com/csswarranty/accodecoverage';
        insert cid;
        // Test.startTest();
        Test.setMock(HttpCalloutMock.class , new CSS_WS_SBL_GetWarrantyDetailCovrg_Test());
        //Test.setMock(HttpCalloutMock.class, new CSS_MockHttpResponseGenerator()); 
        //Test.setMock(HttpCalloutMock.class, new CG_CampaignMock_Test());
        JO.Customer_Name__c = 'Agassi';
        JO.Application__c = 'Recreational Vehicle';
        JO.Model__c = 'AgassishyamTest';
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
        JO.Unit_Number__c = 'test123';
        Jo.Assigned_To__c = UserInfo.getUserId();
        Jo.esn__c = '33186363';
        JO.Unit_Type__c = 'type';
        Jo.Country__c = 'United States';
        Jo.CSS_State__c = 'Indiana';
        Jo.City__c = 'Columbus';
        Jo.Customer_Code__c = '23456';
        Jo.EditComplaint__c = 'complaint';
        Jo.EditCoverage__c = 'coverage';
        Jo.EditCause__c = 'cause';
        Jo.EditCorrection__c = 'correction';
        JO.chevron_page__c = 'prt';
        JO.CSS_Resolution__c = 'Test';
        JO.DSID__c = 'VFD23';
        insert JO;
        
        PageReference pref;
        pref = new PageReference('/'+JO.id);
        pref.getParameters().put('id',JO.id);
        //pref.getParameters().put('partsUr','Parts');
        Test.setCurrentPage(pref);
        
        CSS_Solution_Component__c solComp = new CSS_Solution_Component__c();
        solComp.Component_Id__c ='F0051000';
        solComp.Service_Job__c = Jo.id;
        solComp.Action__c = '';
        solComp.Type__c = 'Campaign';
        solComp.Campaign_Description__c = 'Hey Hai Man Camp';
        solComp.CampaignPartsPercentage__c = '20';
        solcomp.Performed_Review__c = True;
        solcomp.AccountCode__c='62';
        insert solComp;
        
        
        
        CSS_Parts_Options__c parts = new CSS_Parts_Options__c();
        //parts.FailurepartId__c = solComp.Id;
        parts.selected_part__c = True;
        parts.Service_partnumber__c = '540571401';
        parts.OEM__c = 'OEMWRS';
        parts.Part_Name__c = 'TestPartCamp';
        parts.ReturnToFactory__c = 'Campaign-TRP-ATC';
        parts.Replacement_Reason__c = 'Campaign-TRP-ATC';
        parts.Quantity__c = 55;
        parts.Notes__c = 'Hai how are you guys';
        parts.Service_Job__c = Jo.id;
        insert parts;
        
        CSS_Parts_Options__c partstrp = new CSS_Parts_Options__c();
        //partstrp.FailurepartId__c = solComptrp.Id;
        partstrp.selected_part__c = True;
        partstrp.Service_partnumber__c = '540571401';
        partstrp.OEM__c = 'OEMWRS';
        partstrp.Part_Name__c = 'TestPartCamp';
        partstrp.ReturnToFactory__c = 'Campaign-TRP-ATC';
        partstrp.Replacement_Reason__c = 'Campaign-TRP-ATC';
        partstrp.Quantity__c = 55;
        partstrp.Notes__c = 'Hai how are you guys';
        partstrp.Service_Job__c = Jo.id;
        insert partstrp;
        
        CSS_Parts_Options__c partsatc = new CSS_Parts_Options__c();
        //partsatc.FailurepartId__c = solCompatc.Id;
        partsatc.selected_part__c = True;
        partsatc.Service_partnumber__c = '540571401';
        partsatc.OEM__c = 'OEMWRS';
        partsatc.Part_Name__c = 'TestPartCamp';
        partsatc.ReturnToFactory__c = 'Campaign-TRP-ATC';
        partsatc.Replacement_Reason__c = 'Campaign-TRP-ATC';
        partsatc.Quantity__c = 55;
        partsatc.Notes__c = 'Hai how are you guys';
        partsatc.Service_Job__c = Jo.id;
        
        insert partsatc; 
        
        
        
        Set<String> FieldActNumSet = new Set<String>();
        Set<String> NonSelFieldActNumSet = new Set<String>();
        CG_BL_Campaigns.callGetCampaignsWSforJobsonReselect('','','','','','','','',null,FieldActNumSet,NonSelFieldActNumSet);
        
        ///string Json = '{"DataArea":{{"Details":{BusinessUnit=CMI, CampaignDesc=ISX15 CM2350 - TRP FOR CALIBRATION FLEET COUNT COSTS WHEN CHANGING ECM BASE CODE POST, CampaignEndDate=2020-12-31, CampaignNumber=1609, CampaignStartDate=2015-02-27, CampaignType=TRP, CompleteIndicator=N, FailCode=WEQP, FailMode=EZ, InShopSrtLimitFlag=N, MultipleTimes=N, {"PartList":{PartDescription=6.2 CALIBRATION FLT REG., PartNumber=388639600, PartQuantity=1}}, {"SrtList":{SrtCode=00-901-00, SrtDescription=Administrative Time - Open and Close Repair Order (Shop Repairs)},  Status=Approved}}}},"Header":{"ReturnCodeDescription":"Success","Status":"SUCCESS","ReturnCode":"","MessageIdentifier":"CSS-00070849"}}';
        //CG_BL_Campaigns.getAccountCodes(Json);
        //   CG_BL_Campaigns.getAccountCodes(JO.id,'FU','PU', solComp.id,solComp.Component_id__c);
        //  CG_BL_Campaigns.getAccountCodes(JO.id,'FU','PU', solComp.id,'R123');
        
        
        Test.stopTest();
    }
    static  testMethod void CG_BL_Campaigns_TestMethod1() {
        Test.startTest();
        CSS_Job_Order__c JO = new CSS_Job_Order__c();
        
        
        Test.setMock(HttpCalloutMock.class , new CSS_WS_SBL_GetWarrantyDetailCovrg_Test());
        //Test.setMock(HttpCalloutMock.class, new CG_CampaignMock_Test());
        JO.Customer_Name__c = 'Agassi';
        JO.Application__c = 'Recreational Vehicle';
        JO.Model__c = 'AgassishyamTest';
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
        JO.Unit_Number__c = 'test123';
        Jo.Assigned_To__c = UserInfo.getUserId();
        Jo.esn__c = '33186363';
        JO.Unit_Type__c = 'type';
        Jo.Country__c = 'United States';
        Jo.CSS_State__c = 'Indiana';
        Jo.City__c = 'Columbus';
        Jo.Customer_Code__c = '23456';
        Jo.EditComplaint__c = 'complaint';
        Jo.EditCoverage__c = 'coverage';
        Jo.EditCause__c = 'cause';
        Jo.EditCorrection__c = 'correction';
        JO.chevron_page__c = 'prt';
        JO.CSS_Resolution__c = 'Test';
        JO.DSID__c = 'VFD23';
        insert JO;
        
        PageReference pref;
        pref = new PageReference('/'+JO.id);
        pref.getParameters().put('id',JO.id);
        //pref.getParameters().put('partsUr','Parts');
        Test.setCurrentPage(pref);
        
        CSS_Solution_Component__c solComp = new CSS_Solution_Component__c();
        solComp.Component_Id__c ='F0051000';
        solComp.Service_Job__c = Jo.id;
        solComp.Action__c = '';
        solComp.Type__c = 'Campaign';
        solComp.Campaign_Description__c = 'Hey Hai Man Camp';
        solComp.CampaignPartsPercentage__c = '20';
        solcomp.Performed_Review__c = True;
        solcomp.AccountCode__c='new parts warranty 62';
        insert solComp;
        
        CSS_Integration_Error__c interr = new  CSS_Integration_Error__c();
        interr.Service_Name__c = 'GetFieldActions/Campaigns';
        interr.Source__c = 'campaignJob';
        insert interr;
        
        /*CSS_Solution_Component__c solComptrp = new CSS_Solution_Component__c();
solComptrp.Component_Id__c ='F0051000';
solComptrp.Service_Job__c = Jo.id;
solComptrp.Type__c = 'TRP';
solComptrp.Campaign_Description__c = 'Hey Hai Man TRP';
solComptrp.CampaignPartsPercentage__c = '10';
solcomptrp.Performed_Review__c = True;
insert solComptrp;

CSS_Solution_Component__c solCompatc = new CSS_Solution_Component__c();
solCompatc.Component_Id__c ='F0051000';
solCompatc.Service_Job__c = Jo.id;
solCompatc.Type__c = 'ATC';
solCompatc.Campaign_Description__c = 'Hey Hai Man ATC';
solCompatc.CampaignPartsPercentage__c = '10';
solcompatc.Performed_Review__c = True;
insert solCompatc;*/ 
        
        CSS_Parts_Options__c parts = new CSS_Parts_Options__c();
        //parts.FailurepartId__c = solComp.Id;
        parts.selected_part__c = True;
        parts.Service_partnumber__c = '540571401';
        parts.OEM__c = 'OEMWRS';
        parts.Part_Name__c = 'TestPartCamp';
        parts.ReturnToFactory__c = 'Campaign-TRP-ATC';
        parts.Replacement_Reason__c = 'Campaign-TRP-ATC';
        parts.Quantity__c = 55;
        parts.Notes__c = 'Hai how are you guys';
        parts.Service_Job__c = Jo.id;
        insert parts;
        
        CSS_Parts_Options__c partstrp = new CSS_Parts_Options__c();
        //partstrp.FailurepartId__c = solComptrp.Id;
        partstrp.selected_part__c = True;
        partstrp.Service_partnumber__c = '540571401';
        partstrp.OEM__c = 'OEMWRS';
        partstrp.Part_Name__c = 'TestPartCamp';
        partstrp.ReturnToFactory__c = 'Campaign-TRP-ATC';
        partstrp.Replacement_Reason__c = 'Campaign-TRP-ATC';
        partstrp.Quantity__c = 55;
        partstrp.Notes__c = 'Hai how are you guys';
        partstrp.Service_Job__c = Jo.id;
        insert partstrp;
        
        CSS_Parts_Options__c partsatc = new CSS_Parts_Options__c();
        //partsatc.FailurepartId__c = solCompatc.Id;
        partsatc.selected_part__c = True;
        partsatc.Service_partnumber__c = '540571401';
        partsatc.OEM__c = 'OEMWRS';
        partsatc.Part_Name__c = 'TestPartCamp';
        partsatc.ReturnToFactory__c = 'Campaign-TRP-ATC';
        partsatc.Replacement_Reason__c = 'Campaign-TRP-ATC';
        partsatc.Quantity__c = 55;
        partsatc.Notes__c = 'Hai how are you guys';
        partsatc.Service_Job__c = Jo.id;
        
        insert partsatc; 
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
        conDetails.Name = 'GetCampaign';
        conDetails.AuthEnv__c = 'OAGOAUTH';
        conDetails.ApplicationName__c = 'GetCampaignBL';
        conDetails.End_Point__c = 'https://services-stg.cummins.com/css/getcampaigndetails';
        conDetails.Method_Type__c = 'POST';
        conDetails.Timeout__c = 2.0;
        insert conDetails;
        
        CG_OP_OAGWrapper OPWrap = new CG_OP_OAGWrapper();
        OPWrap = CG_BL_Campaigns.callGetCampaignsWS(null, null, null, null,null, null,null, null, null, null);
        Test.stopTest();
    }
    
    static Testmethod void CG_BL_Campaign_Campaignstestmethod2()
    {
        
        Account acc = new Account();
        acc.name='Rtest';
        acc.CSS_DistributorCode__c='56270';
        acc.IAM_Service_Provider_Code__c='56270';
        //acc.IAM_Service_Provider_Code__c = '56270';
        acc.Type = 'Cuetomer';
        //acc.IAM_Service_Provider_Code__c  = '56270';
        acc.CMI_Account_Status__c = 'Active';
        
        
        insert acc;
        string location = [select id,location__c from account where id=:acc.id].location__c;
        user u = [select id, name from user limit 1];
        
        system.runAs(u){
            CSS_UserLocation__c userLocation = new CSS_UserLocation__c(AccountId__c=acc.id,isActive__c=true,isPrimary__c=true,UserId__c=u.Id,Location_code__c='12345-12345');
            insert userLocation;
            CSS_TestData.createAccountLanguage(true);
        }
        
        CSS_Job_Order__c JO = new CSS_Job_Order__c();
        JO.Customer_Name__c = 'Agassi';
        JO.Application__c = 'Recreational Vehicle';
        JO.Model__c = 'AgassishyamTest';
        JO.Make__c = 'CSSTest';
        JO.Notes__c = 'CAMPCOMMENTS';
        JO.Failure_Point__c = 122;
        JO.Failure_Point_Measure__c = 'Miles';
        JO.VIN__c = '12345677890';
        JO.Failure_Date__c = date.today() - 20;
        JO.Warranty_Start_Date__c = date.today() - 40;
        JO.Location_Certification__c = 'abc';
        JO.jobLocation__c = 'abc';
        JO.Before_In_Service__c = True;
        JO.Status__c = 'Repair Complete';
        JO.Unit_Number__c = 'test123';
        Jo.Equipment_ID__c='Equip';
        Jo.Failure_Date__c =Date.Today();
        Jo.Assigned_To__c = u.id;
        Jo.ESN__c = '33186363';
        JO.Unit_Type__c = 'type';
        Jo.Country__c = 'United States';
        Jo.CSS_State__c = 'Indiana';
        Jo.Region__c='NORTH AMERICA';
        Jo.Territory__c='UNITED STATES';
        Jo.City__c = 'Columbus';
        Jo.Customer_Code__c = '23456';
        Jo.EditComplaint__c = 'complaint';
        Jo.EditCoverage__c = 'coverage';
        Jo.EditCause__c = 'cause';
        Jo.EditCorrection__c = 'correction';
        JO.chevron_page__c = 'prt';
        JO.CSS_Resolution__c = 'Test';
        JO.Qsol_Engine_Family_Code__c='Test';
        JO.DSID__c = 'VFD23';
        JO.Service_Model__c='ESN';
        //Jo.Service_Model__c, servJob.Qsol_Engine_Family_Code__c, 'en', servJob.Equipment_ID__c, solCompList
        
        
        insert JO;
        
        //CG_BL_Campaigns.callFieldActionSRT(solCompList,JO.Id);
        // CG_BL_Campaigns.callFieldActionSRTClaims(solCompList,JO.Id);
        Test.startTest();
        Test.setMock(HttpCalloutMock.class , new CSS_WS_SBL_GetWarrantyDetailCovrg_Test());
        Test.setMock(HttpCalloutMock.class, new CG_CampaignMock_Test());
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
        conDetails.Name = 'GetCampaign';
        conDetails.AuthEnv__c = 'OAGOAUTH';
        conDetails.ApplicationName__c = 'GetCampaign';
        conDetails.End_Point__c = 'Test';
        conDetails.Method_Type__c = 'POST';
        conDetails.Timeout__c = 2.0;
        insert conDetails;
        
        CSS_Integration_Details__c conDetails1 = new CSS_Integration_Details__c();
        conDetails1.Name = 'CG_FieldActionSRT';
        conDetails1.AuthEnv__c = 'OAGOAuth';
        conDetails1.ApplicationName__c = 'SRT';
        conDetails1.End_Point__c = 'https://services-stg.cummins.com/csswarranty/srtfieldactions';
        conDetails1.Method_Type__c = 'POST';
        conDetails1.Timeout__c = 120000.0;
        insert conDetails1;
        //String grpName;// = 'CQ'+'-'+'12345-12345';
        CSS_Claims__c testclaimsRec = new CSS_Claims__c();
        CSS_PSN__c testpsnNewRec = new CSS_PSN__c();
        CSS_PSN__c testpsnNewRec1 = new CSS_PSN__c();
        List<CSS_PSN__c> lstNewPsn = new List<CSS_PSN__c>();
        //String grpName = 'CQ'+'-'+'12345-12345';
        testclaimsRec.Customer_Name__c='TestCustomer';
        testclaimsRec.Customer_Code__c = '1234';
        //testclaimsRec.id=JO.id;
        testclaimsRec.Contact_Last_Name__c = 'T';
        testclaimsRec.location_code__C = '02850-02991';
        String grpName = 'CQ'+'-'+'12345-12345';
        Group testQue = new Group(Name=grpName, type='Queue');
        insert testQue;
        
        system.runas(new User(Id=UserInfo.getUserId()))
        { 
            
            QueueSObject tq = new QueueSObject(SobjectType='CSS_Claims__c', QueueId=testQue.Id);
            insert tq;
            //Id recTyIdpart = Schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName().get('BMS Parts').getRecordTypeId();
            //css_job_order__c joorder = css_testdata.createJobOrder(true);
            //testclaimsRec = CSS_TestData.createclaims(true,joorder.Id); 
            testclaimsRec.Service_Model__c='test';
            testclaimsRec.EngineFamilyCode__c='test';
            testclaimsRec.ESN__c='79462880';
            testclaimsRec.Region__c='NORTH AMERICA';
            testclaimsRec.Territory__c='UNITED STATES';
            testclaimsRec.CSS_Job__c=JO.Id;
            // testclaimsRec.Name='test';
            testclaimsRec.FieldActionWebServiceResult__c='Error';
            insert testclaimsRec;
            
        }
        List<CSS_Solution_Component__c> solCompList = new List<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solComp = new CSS_Solution_Component__c();
        solComp.Component_Id__c ='1609';
        solComp.Service_Job__c = Jo.id;
        solComp.Action__c = '';
        solComp.Type__c = 'CAMPAIGN';
        solComp.Campaign_Description__c = 'Hey Hai Man Camp';
        solComp.CampaignPartsPercentage__c = '20';
        solcomp.Performed_Review__c = True;
        solcomp.css_claims__c =testclaimsRec.id;
        solcomp.AccountCode__c='new parts warranty 62';
        solCompList.add(solComp);
        insert solCompList;
        testpsnNewRec.psn__c = '79464646';
        testpsnNewRec.Service_Model__c ='test';
        testpsnNewRec.Qsol_Engine_Family_Code__c='test';
        testpsnNewRec.Primary__C = true;
        testpsnNewRec.failure_Date__c = date.today() - 20;
        testpsnNewRec.Equipment_ID__c='test';
        testpsnNewRec.css_claims__C = testclaimsRec.id;
        lstNewPsn.add(testpsnNewRec);
        testpsnNewRec1.psn__c = '79464646';
        testpsnNewRec1.Service_Model__c ='test1';
        testpsnNewRec1.Qsol_Engine_Family_Code__c='test1';
        testpsnNewRec1.Primary__C = true;
        testpsnNewRec1.failure_Date__c = date.today() - 21;
        testpsnNewRec1.Equipment_ID__c='test';
        testpsnNewRec1.css_claims__C = testclaimsRec.id;
        testclaimsRec.FieldActionWebServiceResult__c='Error';
        //insert testpsnNewRec1;
        lstNewPsn.add(testpsnNewRec1);
        insert lstNewPsn;
        CG_BL_Campaigns.callFieldActionSRT(solCompList,JO.Id);
        //CG_BL_Campaigns.callFieldActionSRTClaims(solCompList,JO.Id);
        list<CG_BL_Campaigns.CampaignsWrapper> pwlist=new list<CG_BL_Campaigns.CampaignsWrapper>();
        
        CG_BL_Campaigns.CampaignsWrapper ccw=new CG_BL_Campaigns.CampaignsWrapper(JO.id,'FU','PU', solComp.id,solComp.Component_id__c,true);
        pwlist.add(ccw);
        
        //CG_OP_OAGWrapper oagwrap = CG_BL_Campaigns.callGetCampaignsWS('33186363', '10/10/2017', 'NA', 'Alaska', '', 'Test', 'CSS_ID', 'Message', 'CSS-000464667', 'CSS-00070849', '', 'Auto', 'ENG', 'Test_eqID');
        
        CG_OP_OAGWrapper OPWrap = new CG_OP_OAGWrapper();
        OPWrap = CG_BL_Campaigns.callGetCampaignsWS('33186363', '10/10/2017', 'NA', 'Alaska','CSS', 'GetCampaign','UniqueID', 'CSSWarranty', 'CSS-00070849', JO.Id);
        OPWrap = CG_BL_Campaigns.callGetCampaignsWSforClaims('33186363', '10/10/2017', 'NA', 'Alaska','CSS', 'GetCampaign','UniqueID', 'CSSWarranty', testclaimsRec.Id);
        CG_BL_Campaigns.callGetCampaignsWebService('33186363', '10/10/2017', 'NA', 'Alaska','CSS', 'GetCampaign','UniqueID', 'CSSWarranty', 'CSS-00070849', JO.Id);
        
        CG_BL_Campaigns.callGetCampaignsWebServiceOnChevronChangeJob('33186363', '10/10/2017', 'United states', 'Indiana','CSS', 'GetCampaign','UniqueID', 'CSSWarranty', 'CSS-00070849', JO.Id);
        
        CG_BL_Campaigns.callGetCampaignsWebServiceforClaims('33186363', '10/10/2017', 'NA', 'Alaska','CSS', 'GetCampaign','UniqueID', 'CSSWarranty',testclaimsRec.Id);
        CG_BL_Campaigns.callGetCampaignsWebServiceforClaimsOnChevronChangeClaim('33186363', '10/10/2017', 'NA', 'Alaska','CSS', 'GetCampaign','UniqueID', 'CSSWarranty',testclaimsRec.Id);
        set<String> code = new set<String>();
        code.add('1609');
        CG_BL_Campaigns.callGetCampaignsWSforClaimsonReselect('33186363', '10/10/2017', 'NA', 'Alaska','CSS', 'GetCampaign','UniqueID', 'CSSWarranty',testclaimsRec.Id,code,code);
        system.debug('SLOutput**'+OPWrap);
        
        Map<id,CSS_PSN__c> oldMap = new Map<id,CSS_PSN__c>();
        // oldMap.put(testpsnNewRec.id,testpsnNewRec);
        oldMap.put(testpsnNewRec1.id,testpsnNewRec);
        // CG_FieldActionSRTResponse fieldActionSRTResponse = CSS_FN_SRT.getFieldActionSRT(servJob.Service_Model__c, servJob.Qsol_Engine_Family_Code__c, 'en', servJob.Equipment_ID__c, solCompList);
        
        cg_bl_campaigns.callPSNAfterInsert(lstNewPsn);
        cg_bl_campaigns.callPSNAfterUpdate(lstNewPsn,oldMap);
        
        Set<String> FieldActNumSet = new Set<String>();
        Set<String> NonSelFieldActNumSet = new Set<String>();
        CG_BL_Campaigns.callGetCampaignsWSforJobsonReselect('33186363', '10/10/2017', 'NA', 'Alaska','CSS', 'GetCampaign','UniqueID', 'CSSWarranty',testclaimsRec.Id,FieldActNumSet,NonSelFieldActNumSet);
        
        
        // string Json = '{"DataArea":{{"Details":{BusinessUnit=CMI, CampaignDesc=ISX15 CM2350 - TRP FOR CALIBRATION FLEET COUNT COSTS WHEN CHANGING ECM BASE CODE POST, CampaignEndDate=2020-12-31, CampaignNumber=1609, CampaignStartDate=2015-02-27, CampaignType=TRP, CompleteIndicator=N, FailCode=WEQP, FailMode=EZ, InShopSrtLimitFlag=N, MultipleTimes=N, {"PartList":{PartDescription=6.2 CALIBRATION FLT REG., PartNumber=388639600, PartQuantity=1}}, {"SrtList":{SrtCode=00-901-00, SrtDescription=Administrative Time - Open and Close Repair Order (Shop Repairs)},  Status=Approved}}}},"Header":{"ReturnCodeDescription":"Success","Status":"SUCCESS","ReturnCode":"","MessageIdentifier":"CSS-00070849"}}';
        //CG_BL_Campaigns.getAccountCodes(Json);
        //CG_BL_Campaigns.getAccountCodes(JO.id,'FU','PU', solComp.id,solComp.Component_id__c);
        
        Test.stopTest();
    }
    static Testmethod void CG_BL_Campaign_Campaignstestmethod21()
    {
        
        Account acc = new Account();
        acc.name='Rtest';
        acc.CSS_DistributorCode__c='56270';
        //acc.IAM_Service_Provider_Code__c='56270';
        //acc.IAM_Service_Provider_Code__c = '56270';
        acc.Type = 'Cuetomer';
        acc.IAM_Service_Provider_Code__c = '56270';
        acc.CMI_Account_Status__c = 'Active';
        
        insert acc;
        string location = [select id,location__c from account where id=:acc.id].location__c;
        user u = [select id, name from user limit 1];
        
        system.runAs(u){
            CSS_UserLocation__c userLocation = new CSS_UserLocation__c(AccountId__c=acc.id,isActive__c=true,isPrimary__c=true,UserId__c=u.Id,Location_code__c='12345-12345');
            insert userLocation;
            CSS_TestData.createAccountLanguage(true);
        }
        
        CSS_Job_Order__c JO = new CSS_Job_Order__c();
        JO.Customer_Name__c = 'Agassi';
        JO.Application__c = 'Recreational Vehicle';
        JO.Model__c = 'AgassishyamTest';
        JO.Make__c = 'CSSTest';
        JO.Notes__c = 'CAMPCOMMENTS';
        JO.Failure_Point__c = 122;
        JO.Failure_Point_Measure__c = 'Miles';
        JO.VIN__c = '12345677890';
        JO.Failure_Date__c = date.today() - 20;
        JO.Warranty_Start_Date__c = date.today() - 40;
        JO.Location_Certification__c = 'abc';
        JO.jobLocation__c = 'abc';
        JO.Before_In_Service__c = True;
        JO.Status__c = 'Repair Complete';
        JO.Unit_Number__c = 'test123';
        Jo.Equipment_ID__c='Equip';
        Jo.Failure_Date__c =Date.Today();
        Jo.Assigned_To__c = u.id;
        Jo.ESN__c = '33186363';
        JO.Unit_Type__c = 'type';
        Jo.Country__c = 'United States';
        Jo.CSS_State__c = 'Indiana';
        Jo.Region__c='NORTH AMERICA';
        Jo.Territory__c='UNITED STATES';
        Jo.City__c = 'Columbus';
        Jo.Customer_Code__c = '23456';
        Jo.EditComplaint__c = 'complaint';
        Jo.EditCoverage__c = 'coverage';
        Jo.EditCause__c = 'cause';
        Jo.EditCorrection__c = 'correction';
        JO.chevron_page__c = 'prt';
        JO.CSS_Resolution__c = 'Test';
        JO.Qsol_Engine_Family_Code__c='Test';
        JO.DSID__c = 'VFD23';
        JO.Service_Model__c='ESN';
        //Jo.Service_Model__c, servJob.Qsol_Engine_Family_Code__c, 'en', servJob.Equipment_ID__c, solCompList
        insert JO;
        
        CSS_Integration_Details__c conDetails1 = new CSS_Integration_Details__c();
        conDetails1.Name = 'CG_FieldActionSRT';
        conDetails1.AuthEnv__c = 'OAGOAuth';
        conDetails1.ApplicationName__c = 'SRT';
        conDetails1.End_Point__c = 'https://services-stg.cummins.com/csswarranty/srtfieldactions';
        conDetails1.Method_Type__c = 'POST';
        conDetails1.Timeout__c = 120000.0;
        insert conDetails1;
        
        CSS_Claims__c testclaimsRec = new CSS_Claims__c();
        testclaimsRec.Customer_Name__c='TestCustomer';
        testclaimsRec.Customer_Code__c = '1234';
        //testclaimsRec.id=JO.id;
        testclaimsRec.Contact_Last_Name__c = 'T';
        testclaimsRec.location_code__C = '02850-02991';
        testclaimsRec.Service_Model__c='test';
        testclaimsRec.EngineFamilyCode__c='test';
        testclaimsRec.ESN__c='79462880';
        testclaimsRec.Region__c='NORTH AMERICA';
        testclaimsRec.Territory__c='UNITED STATES';
        testclaimsRec.CSS_Job__c=JO.Id;
        // testclaimsRec.Name='test';
        testclaimsRec.FieldActionWebServiceResult__c='Error';
        insert testclaimsRec;
        
        CSS_PSN__c testpsnNewRec = new CSS_PSN__c();
        testpsnNewRec.psn__c = '79464646';
        testpsnNewRec.Service_Model__c ='test';
        testpsnNewRec.Qsol_Engine_Family_Code__c='test';
        testpsnNewRec.Primary__C = true;
        testpsnNewRec.failure_Date__c = date.today() - 20;
        testpsnNewRec.Equipment_ID__c='test';
        testpsnNewRec.css_claims__C = testclaimsRec.id;
        testclaimsRec.FieldActionWebServiceResult__c='Error';
        insert testpsnNewRec;
        
        
        List<CSS_Solution_Component__c> solCompLst = new List<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solComp1 = new CSS_Solution_Component__c();
        solComp1.Component_Id__c ='F0051000';
        solComp1.CSS_Claims__c = testclaimsRec.id;
        solComp1.Action__c = '';
        solComp1.Type__c = 'Campaign';
        solComp1.Campaign_Description__c = 'Hey Hai Man Camp';
        solComp1.CampaignPartsPercentage__c = '20';
        solComp1.CampaignLaborPercentage__c = '20';
        solcomp1.Performed_Review__c = True;
        solCompLst.add(solComp1);
        insert solCompLst;
        Test.setMock(HttpCalloutMock.class, new CG_FieldSRTMock_Test());
        Test.startTest();
        CG_BL_Campaigns.callFieldActionSRTClaims(solCompLst,testclaimsRec.Id);
        Set<String> FieldActNumSet = new Set<String>();
        Set<String> NonSelFieldActNumSet = new Set<String>();
        CG_BL_Campaigns.callGetCampaignsWSforJobsonReselect('33186363', '10/10/2017', 'NA', 'Alaska','CSS', 'GetCampaign','UniqueID', 'CSSWarranty',testclaimsRec.Id,FieldActNumSet,NonSelFieldActNumSet);
        Test.stopTest();
    }
    static Testmethod void CG_BL_Campaign_Campaignstestmethod112()
    {
        
        Account acc = new Account();
        acc.name='Rtest';
        acc.CSS_DistributorCode__c='56270';
        //acc.IAM_Service_Provider_Code__c='56270';
        //acc.IAM_Service_Provider_Code__c = '56270';
        acc.Type = 'Cuetomer';
        acc.IAM_Service_Provider_Code__c = '56270';
        acc.CMI_Account_Status__c = 'Active';
        
        
        insert acc;
        string location = [select id,location__c from account where id=:acc.id].location__c;
        user u = [select id, name from user limit 1];
        
        system.runAs(u){
            CSS_UserLocation__c userLocation = new CSS_UserLocation__c(AccountId__c=acc.id,isActive__c=true,isPrimary__c=true,UserId__c=u.Id,Location_code__c='12345-12345');
            insert userLocation;
            CSS_TestData.createAccountLanguage(true);
        }
        
        CSS_Job_Order__c JO = new CSS_Job_Order__c();
        JO.Customer_Name__c = 'Agassi';
        JO.Application__c = 'Recreational Vehicle';
        JO.Model__c = 'AgassishyamTest';
        JO.Make__c = 'CSSTest';
        JO.Notes__c = 'CAMPCOMMENTS';
        JO.Failure_Point__c = 122;
        JO.Failure_Point_Measure__c = 'Miles';
        JO.VIN__c = '12345677890';
        JO.Failure_Date__c = date.today() - 20;
        JO.Warranty_Start_Date__c = date.today() - 40;
        JO.Location_Certification__c = 'abc';
        JO.jobLocation__c = 'abc';
        JO.Before_In_Service__c = True;
        JO.Status__c = 'Repair Complete';
        JO.Unit_Number__c = 'test123';
        Jo.Equipment_ID__c='Equip';
        Jo.Failure_Date__c =Date.Today();
        Jo.Assigned_To__c = u.id;
        Jo.ESN__c = '33186363';
        JO.Unit_Type__c = 'type';
        Jo.Country__c = 'United States';
        Jo.CSS_State__c = 'Indiana';
        Jo.Region__c='NORTH AMERICA';
        Jo.Territory__c='UNITED STATES';
        Jo.City__c = 'Columbus';
        Jo.Customer_Code__c = '23456';
        Jo.EditComplaint__c = 'complaint';
        Jo.EditCoverage__c = 'coverage';
        Jo.EditCause__c = 'cause';
        Jo.EditCorrection__c = 'correction';
        JO.chevron_page__c = 'prt';
        JO.CSS_Resolution__c = 'Test';
        JO.Qsol_Engine_Family_Code__c='Test';
        JO.DSID__c = 'VFD23';
        JO.Service_Model__c='ESN';
        //Jo.Service_Model__c, servJob.Qsol_Engine_Family_Code__c, 'en', servJob.Equipment_ID__c, solCompList
        
        
        insert JO;
        
        //CG_BL_Campaigns.callFieldActionSRT(solCompList,JO.Id);
        // CG_BL_Campaigns.callFieldActionSRTClaims(solCompList,JO.Id);
        Test.startTest();
        Test.setMock(HttpCalloutMock.class , new CSS_WS_SBL_GetWarrantyDetailCovrg_Test());
        Test.setMock(HttpCalloutMock.class, new CG_CampaignMock_Test());
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
        conDetails.Name = 'GetCampaign';
        conDetails.AuthEnv__c = 'OAGOAUTH';
        conDetails.ApplicationName__c = 'GetCampaign';
        conDetails.End_Point__c = 'Test';
        conDetails.Method_Type__c = 'POST';
        conDetails.Timeout__c = 2.0;
        insert conDetails;
        
        CSS_Integration_Details__c conDetails1 = new CSS_Integration_Details__c();
        conDetails1.Name = 'CG_FieldActionSRT';
        conDetails1.AuthEnv__c = 'OAGOAuth';
        conDetails1.ApplicationName__c = 'SRT';
        conDetails1.End_Point__c = 'https://services-stg.cummins.com/csswarranty/srtfieldactions';
        conDetails1.Method_Type__c = 'POST';
        conDetails1.Timeout__c = 120000.0;
        insert conDetails1;
        CSS_Integration_Details__c cid = CSS_TestData.createIntegrationDetails(false);
        cid.name = 'CSS_SBL_WarrantyDetailCoverage';
        cid.ApplicationName__c = 'CSS_SBL_WarrantyDetailCoverage';
        cid.End_Point__c = 'https://services-stg.cummins.com/csswarranty/accodecoverage';
        insert cid;
        //String grpName;// = 'CQ'+'-'+'12345-12345';
        CSS_Claims__c testclaimsRec = new CSS_Claims__c();
        CSS_PSN__c testpsnNewRec = new CSS_PSN__c();
        CSS_PSN__c testpsnNewRec1 = new CSS_PSN__c();
        List<CSS_PSN__c> lstNewPsn = new List<CSS_PSN__c>();
        //String grpName = 'CQ'+'-'+'12345-12345';
        testclaimsRec.Customer_Name__c='TestCustomer';
        testclaimsRec.Customer_Code__c = '1234';
        //testclaimsRec.id=JO.id;
        testclaimsRec.Contact_Last_Name__c = 'T';
        testclaimsRec.location_code__C = '02850-02991';
        String grpName = 'CQ'+'-'+'12345-12345';
        Group testQue = new Group(Name=grpName, type='Queue');
        insert testQue;
        
        system.runas(new User(Id=UserInfo.getUserId()))
        { 
            
            QueueSObject tq = new QueueSObject(SobjectType='CSS_Claims__c', QueueId=testQue.Id);
            insert tq;
            //Id recTyIdpart = Schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName().get('BMS Parts').getRecordTypeId();
            //css_job_order__c joorder = css_testdata.createJobOrder(true);
            //testclaimsRec = CSS_TestData.createclaims(true,joorder.Id); 
            testclaimsRec.Service_Model__c='test';
            testclaimsRec.EngineFamilyCode__c='test';
            testclaimsRec.ESN__c='79462880';
            testclaimsRec.Region__c='NORTH AMERICA';
            testclaimsRec.Territory__c='UNITED STATES';
            //testclaimsRec.CSS_Job__c=JO.Id;
            // testclaimsRec.Name='test';
            testclaimsRec.FieldActionWebServiceResult__c='Error';
            insert testclaimsRec;
            
        }
        List<CSS_Solution_Component__c> solCompList = new List<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solComp = new CSS_Solution_Component__c();
        solComp.Component_Id__c ='1609';
        solComp.Service_Job__c = Jo.id;
        solComp.Action__c = '';
        solComp.Type__c = 'CAMPAIGN';
        solComp.Campaign_Description__c = 'Hey Hai Man Camp';
        solComp.CampaignPartsPercentage__c = '20';
        solcomp.Performed_Review__c = True;
        solcomp.css_claims__c =testclaimsRec.id;
        
        solCompList.add(solComp);
        insert solCompList;
        testpsnNewRec.psn__c = '79464646';
        testpsnNewRec.Service_Model__c ='test';
        testpsnNewRec.Qsol_Engine_Family_Code__c='test';
        testpsnNewRec.Primary__C = true;
        testpsnNewRec.failure_Date__c = date.today() - 20;
        testpsnNewRec.Equipment_ID__c='test';
        testpsnNewRec.css_claims__C = testclaimsRec.id;
        lstNewPsn.add(testpsnNewRec);
        testpsnNewRec1.psn__c = '79464646';
        testpsnNewRec1.Service_Model__c ='test1';
        testpsnNewRec1.Qsol_Engine_Family_Code__c='test1';
        testpsnNewRec1.Primary__C = true;
        testpsnNewRec1.failure_Date__c = date.today() - 21;
        testpsnNewRec1.Equipment_ID__c='test';
        testpsnNewRec1.css_claims__C = testclaimsRec.id;
        //testpsnNewRec1.FieldActionWebServiceResult__c='Error';
        //insert testpsnNewRec1;
        lstNewPsn.add(testpsnNewRec1);
        insert lstNewPsn;
        CG_BL_Campaigns.callFieldActionSRT(solCompList,JO.Id);
        //CG_BL_Campaigns.callFieldActionSRTClaims(solCompList,JO.Id);
        list<CG_BL_Campaigns.CampaignsWrapper> pwlist=new list<CG_BL_Campaigns.CampaignsWrapper>();
        
        CG_BL_Campaigns.CampaignsWrapper ccw=new CG_BL_Campaigns.CampaignsWrapper(JO.id,'FU','PU', solComp.id,solComp.Component_id__c,true);
        pwlist.add(ccw);
        
        //CG_OP_OAGWrapper oagwrap = CG_BL_Campaigns.callGetCampaignsWS('33186363', '10/10/2017', 'NA', 'Alaska', '', 'Test', 'CSS_ID', 'Message', 'CSS-000464667', 'CSS-00070849', '', 'Auto', 'ENG', 'Test_eqID');
        
        CG_OP_OAGWrapper OPWrap = new CG_OP_OAGWrapper();
        OPWrap = CG_BL_Campaigns.callGetCampaignsWS('33186363', '10/10/2017', 'NA', 'Alaska','CSS', 'GetCampaign','UniqueID', 'CSSWarranty', 'CSS-00070849', JO.Id);
        OPWrap = CG_BL_Campaigns.callGetCampaignsWSforClaims('33186363', '10/10/2017', 'NA', 'Alaska','CSS', 'GetCampaign','UniqueID', 'CSSWarranty', testclaimsRec.Id);
        CG_BL_Campaigns.callGetCampaignsWebService('33186363', '10/10/2017', 'NA', 'Alaska','CSS', 'GetCampaign','UniqueID', 'CSSWarranty', 'CSS-00070849', JO.Id);
        CG_BL_Campaigns.callGetCampaignsWebServiceforClaims('33186363', '10/10/2017', 'NA', 'Alaska','CSS', 'GetCampaign','UniqueID', 'CSSWarranty',testclaimsRec.Id);
        CG_BL_Campaigns.callGetCampaignsWSforClaimsRetrigger('esn','failureDate', 'region', 'territory', 'senderID', 'serviceName', 'messageID', 'target', testclaimsRec.Id );
        set<String> code = new set<String>();
        code.add('1609');
        CG_BL_Campaigns.callGetCampaignsWSforClaimsonReselect('33186363', '10/10/2017', 'NA', 'Alaska','CSS', 'GetCampaign','UniqueID', 'CSSWarranty',testclaimsRec.Id,code,code);
        system.debug('SLOutput**'+OPWrap);
        
        Map<id,CSS_PSN__c> oldMap = new Map<id,CSS_PSN__c>();
        // oldMap.put(testpsnNewRec.id,testpsnNewRec);
        oldMap.put(testpsnNewRec1.id,testpsnNewRec);
        // CG_FieldActionSRTResponse fieldActionSRTResponse = CSS_FN_SRT.getFieldActionSRT(servJob.Service_Model__c, servJob.Qsol_Engine_Family_Code__c, 'en', servJob.Equipment_ID__c, solCompList);
        /*for(CSS_Solution_Component__c sc : solCompList) {
CampaignsWrapperList.add(new CampaignsWrapper(JobId,sc.System_Code__c,sc.Component_Code__c,sc.Id,sc.Component_Id__c,sc.Selected_Component__c));     
}*/
         cg_bl_campaigns.callPSNAfterInsert(lstNewPsn);
        cg_bl_campaigns.callPSNAfterUpdate(lstNewPsn,oldMap);
        string Json = '{"DataArea":{"Details":[{"BusinessUnit":"CMI", "CampaignDesc":"ISX15 CM2350 - TRP FOR CALIBRATION FLEET COUNT COSTS WHEN CHANGING ECM BASE CODE POST", "CampaignEndDate":"2020-12-31", "CampaignNumber":1609, "CampaignStartDate":"2015-02-27", "CampaignType":"TRP", "CompleteIndicator":"N", "FailCode":"WEQP", "FailMode":"EZ", "InShopSrtLimitFlag":"Y", "MultipleTimes":"N", "PartList":[{"PartDescription":"6.2 CALIBRATION FLT REG.", "PartNumber":"388639600", "PartQuantity":"1"}],"SrtList":[{"SrtCode":"00-901-00", "SrtDescription":"Administrative Time - Open and Close Repair Order (Shop Repairs)"}],  "Status":"Approved"}]},"Header":{"ReturnCodeDescription":"Success","Status":"SUCCESS"}}';
        //CG_BL_Campaigns.getAccountCodes(Json);
        //CG_BL_Campaigns.getAccountCodes(JO.id,'FU','PU', solComp.id,solComp.Component_id__c);
        string js = system.JSON.serialize(pwlist);
        //CG_BL_Campaigns.getAccountCodes(js);
        Set<String> FieldActNumSet = new Set<String>();
        Set<String> NonSelFieldActNumSet = new Set<String>();
        CG_BL_Campaigns.callGetCampaignsWSforJobsonReselect('33186363', '10/10/2017', 'NA', 'Alaska','CSS', 'GetCampaign','UniqueID', 'CSSWarranty',testclaimsRec.Id,FieldActNumSet,NonSelFieldActNumSet);
        
        
        Test.stopTest();
    }
    static Testmethod void CG_BL_Campaign_Campaignstestmethod212()
    {
        
        Account acc = new Account();
        acc.name='Rtest';
        acc.CSS_DistributorCode__c='56270';
        //acc.IAM_Service_Provider_Code__c='56270';
        //acc.IAM_Service_Provider_Code__c = '56270';
        acc.Type = 'Cuetomer';
        acc.IAM_Service_Provider_Code__c = '56270';
        acc.CMI_Account_Status__c = 'Active';
        
        
        insert acc;
        string location = [select id,location__c from account where id=:acc.id].location__c;
        user u = [select id, name from user limit 1];
        
        
        
        CSS_Job_Order__c JO = new CSS_Job_Order__c();
        JO.Customer_Name__c = 'Agassi';
        JO.Application__c = 'Recreational Vehicle';
        JO.Model__c = 'AgassishyamTest';
        JO.Make__c = 'CSSTest';
        JO.Notes__c = 'CAMPCOMMENTS';
        JO.Failure_Point__c = 122;
        JO.Failure_Point_Measure__c = 'Miles';
        JO.VIN__c = '12345677890';
        JO.Failure_Date__c = date.today() - 20;
        JO.Warranty_Start_Date__c = date.today() - 40;
        JO.Location_Certification__c = 'abc';
        JO.jobLocation__c = 'abc';
        JO.Before_In_Service__c = True;
        JO.Status__c = 'Repair Complete';
        JO.Unit_Number__c = 'test123';
        Jo.Equipment_ID__c='Equip';
        Jo.Failure_Date__c =Date.Today();
        Jo.Assigned_To__c = u.id;
        Jo.ESN__c = '33186363';
        JO.Unit_Type__c = 'type';
        Jo.Country__c = 'United States';
        Jo.CSS_State__c = 'Indiana';
        Jo.Region__c='NORTH AMERICA';
        Jo.Territory__c='UNITED STATES';
        Jo.City__c = 'Columbus';
        Jo.Customer_Code__c = '23456';
        Jo.EditComplaint__c = 'complaint';
        Jo.EditCoverage__c = 'coverage';
        Jo.EditCause__c = 'cause';
        Jo.EditCorrection__c = 'correction';
        JO.chevron_page__c = 'prt';
        JO.CSS_Resolution__c = 'Test';
        JO.Qsol_Engine_Family_Code__c='Test';
        JO.DSID__c = 'VFD23';
        JO.Service_Model__c='ESN';
        //Jo.Service_Model__c, servJob.Qsol_Engine_Family_Code__c, 'en', servJob.Equipment_ID__c, solCompList
        
        
        insert JO;
        
        //CG_BL_Campaigns.callFieldActionSRT(solCompList,JO.Id);
        // CG_BL_Campaigns.callFieldActionSRTClaims(solCompList,JO.Id);
        Test.startTest();
        Test.setMock(HttpCalloutMock.class , new CSS_WS_SBL_GetWarrantyDetailCovrg_Test());
        Test.setMock(HttpCalloutMock.class, new CG_CampaignMock_Test());
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
        conDetails.Name = 'GetCampaign';
        conDetails.AuthEnv__c = 'OAGOAUTH';
        conDetails.ApplicationName__c = 'GetCampaign';
        conDetails.End_Point__c = 'Test';
        conDetails.Method_Type__c = 'POST';
        conDetails.Timeout__c = 2.0;
        insert conDetails;
        
        CSS_Integration_Details__c conDetails1 = new CSS_Integration_Details__c();
        conDetails1.Name = 'CG_FieldActionSRT';
        conDetails1.AuthEnv__c = 'OAGOAuth';
        conDetails1.ApplicationName__c = 'SRT';
        conDetails1.End_Point__c = 'https://services-stg.cummins.com/csswarranty/srtfieldactions';
        conDetails1.Method_Type__c = 'POST';
        conDetails1.Timeout__c = 120000.0;
        insert conDetails1;
        
        CSS_Integration_Details__c cid = CSS_TestData.createIntegrationDetails(false);
        cid.name = 'CSS_SBL_WarrantyDetailCoverage';
        cid.ApplicationName__c = 'CSS_SBL_WarrantyDetailCoverage';
        cid.End_Point__c = 'https://services-stg.cummins.com/csswarranty/accodecoverage';
        insert cid;
        //String grpName;// = 'CQ'+'-'+'12345-12345';
        CSS_Claims__c testclaimsRec = new CSS_Claims__c();
        CSS_PSN__c testpsnNewRec = new CSS_PSN__c();
        CSS_PSN__c testpsnNewRec1 = new CSS_PSN__c();
        List<CSS_PSN__c> lstNewPsn = new List<CSS_PSN__c>();
        //String grpName = 'CQ'+'-'+'12345-12345';
        testclaimsRec.Customer_Name__c='TestCustomer';
        testclaimsRec.Customer_Code__c = '1234';
        //testclaimsRec.id=JO.id;
        testclaimsRec.Contact_Last_Name__c = 'T';
        testclaimsRec.location_code__C = '02850-02991';
        String grpName = 'CQ'+'-'+'12345-12345';
        Group testQue = new Group(Name=grpName, type='Queue');
        insert testQue;
        
        //Id recTyIdpart = Schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName().get('BMS Parts').getRecordTypeId();
        //css_job_order__c joorder = css_testdata.createJobOrder(true);
        //testclaimsRec = CSS_TestData.createclaims(true,joorder.Id); 
        testclaimsRec.Service_Model__c='test';
        testclaimsRec.EngineFamilyCode__c='test';
        testclaimsRec.ESN__c='79462880';
        testclaimsRec.Region__c='NORTH AMERICA';
        testclaimsRec.Territory__c='UNITED STATES';
        //testclaimsRec.CSS_Job__c=JO.Id;
        // testclaimsRec.Name='test';
        testclaimsRec.FieldActionWebServiceResult__c='Error';
        insert testclaimsRec;
        
        
        List<CSS_Solution_Component__c> solCompList = new List<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solComp = new CSS_Solution_Component__c();
        solComp.Component_Id__c ='1609';
        solComp.Service_Job__c = jo.id;
        solComp.Action__c = '';
        solComp.Type__c = 'CAMPAIGN';
        solComp.Campaign_Description__c = 'Hey Hai Man Camp';
        solComp.CampaignPartsPercentage__c = '20';
        solcomp.Performed_Review__c = True;
        solcomp.css_claims__c =testclaimsRec.id;
        
        solCompList.add(solComp);
        insert solCompList;
        testpsnNewRec.psn__c = '7946446';
        testpsnNewRec.Service_Model__c ='test';
        testpsnNewRec.Qsol_Engine_Family_Code__c='test';
        testpsnNewRec.Primary__C = true;
        testpsnNewRec.failure_Date__c = date.today() - 20;
        testpsnNewRec.Equipment_ID__c='test';
        testpsnNewRec.css_claims__C = testclaimsRec.id;
        lstNewPsn.add(testpsnNewRec);
        testpsnNewRec1.psn__c = '79464646';
        testpsnNewRec1.Service_Model__c ='test1';
        testpsnNewRec1.Qsol_Engine_Family_Code__c='test1';
        testpsnNewRec1.Primary__C = true;
        testpsnNewRec1.failure_Date__c = date.today() - 21;
        testpsnNewRec1.Equipment_ID__c='test';
        testpsnNewRec1.css_claims__C = testclaimsRec.id;
        //insert testpsnNewRec1;
        lstNewPsn.add(testpsnNewRec1);
        insert lstNewPsn;
        CSS_PSN__c testpsnNewRec2 = new CSS_PSN__c();
        testpsnNewRec2.psn__c = '7946';
        testpsnNewRec2.Service_Model__c ='test';
        testpsnNewRec2.Qsol_Engine_Family_Code__c='test';
        testpsnNewRec2.Primary__C = true;
        testpsnNewRec2.failure_Date__c = date.today() - 10;
        testpsnNewRec2.Equipment_ID__c='test';
        testpsnNewRec2.css_claims__C = testclaimsRec.id;
        //testclaimsRec2.FieldActionWebServiceResult__c='Error';
        insert testpsnNewRec2;
        
        
        Map<id,CSS_PSN__c> oldMap = new Map<id,CSS_PSN__c>();
        
        oldMap.put(testpsnNewRec.id,testpsnNewRec2);
        
        user u1 = [select id, name from user limit 1];
        
        system.runAs(u1){
            CSS_UserLocation__c userLocation = new CSS_UserLocation__c(AccountId__c=acc.id,isActive__c=true,isPrimary__c=true,UserId__c=u1.Id,Location_code__c='12345-12345');
            insert userLocation;
            CSS_TestData.createAccountLanguage(true);
        }
        
        cg_bl_campaigns.callPSNAfterUpdate(lstNewPsn,oldMap);
        
        Set<String> FieldActNumSet = new Set<String>();
        FieldActNumSet.add('1609');
        Set<String> NonSelFieldActNumSet = new Set<String>();
        CG_BL_Campaigns.callGetCampaignsWSforJobsonReselect('33186363', '10/10/2017', 'NA', 'Alaska','CSS', 'GetCampaign','UniqueID', 'CSSWarranty',testclaimsRec.Id,FieldActNumSet,NonSelFieldActNumSet);
        
        CG_BL_Campaigns.callGetCampaignsWSforJobsonReselect('33186363', '10/10/2017', 'NA', 'Alaska','CSS', 'GetCampaign','UniqueID', 'CSSWarranty',jo.Id,FieldActNumSet,NonSelFieldActNumSet);
        
        
        Test.stopTest();
    }
    static testmethod void exceptionMethod(){
        test.startTest();
        CG_OP_OAGWrapper OPWrap = new CG_OP_OAGWrapper();
        OPWrap = CG_BL_Campaigns.callGetCampaignsWS(null, null, null, null,null, null,null, null, null, null);
        CG_BL_Campaigns.callGetCampaignsWSforClaims(null, null, null, null, null, null, null, null, null);
        
    }
    static Testmethod void CG_BL_Campaign_Campaignstestmethod1122()
    {
        
        Account acc = new Account();
        acc.name='Rtest';
        acc.CSS_DistributorCode__c='56270';
        //acc.IAM_Service_Provider_Code__c='56270';
        //acc.IAM_Service_Provider_Code__c = '56270';
        acc.Type = 'Cuetomer';
        acc.IAM_Service_Provider_Code__c = '56270';
        acc.CMI_Account_Status__c = 'Active';
        
        
        insert acc;
        string location = [select id,location__c from account where id=:acc.id].location__c;
        user u = [select id, name from user limit 1];
        
        system.runAs(u){
            CSS_UserLocation__c userLocation = new CSS_UserLocation__c(AccountId__c=acc.id,isActive__c=true,isPrimary__c=true,UserId__c=u.Id,Location_code__c='12345-12345');
            insert userLocation;
            CSS_TestData.createAccountLanguage(true);
        }
        
        CSS_Job_Order__c JO = new CSS_Job_Order__c();
        JO.Customer_Name__c = 'Agassi';
        JO.Application__c = 'Recreational Vehicle';
        JO.ApplicationCode__c = '130';
        JO.Model__c = 'AgassishyamTest';
        JO.Make__c = 'CSSTest';
        JO.Notes__c = 'CAMPCOMMENTS';
        JO.Failure_Point__c = 122;
        JO.Failure_Point_Measure__c = 'Miles';
        JO.VIN__c = '12345677890';
        JO.Failure_Date__c = date.today() - 20;
        JO.Warranty_Start_Date__c = date.today() - 40;
        JO.Location_Certification__c = 'abc';
        JO.jobLocation__c = 'abc';
        JO.Before_In_Service__c = True;
        JO.Status__c = 'Repair Complete';
        JO.Unit_Number__c = 'test123';
        Jo.Equipment_ID__c='Equip';
        Jo.Failure_Date__c =Date.Today();
        Jo.Assigned_To__c = u.id;
        Jo.ESN__c = '33186363';
        JO.Unit_Type__c = 'type';
        Jo.Country__c = 'United States';
        Jo.CSS_State__c = 'Indiana';
        Jo.Region__c='NORTH AMERICA';
        Jo.Territory__c='UNITED STATES';
        Jo.City__c = 'Columbus';
        Jo.Customer_Code__c = '23456';
        Jo.EditComplaint__c = 'complaint';
        Jo.EditCoverage__c = 'coverage';
        Jo.EditCause__c = 'cause';
        Jo.EditCorrection__c = 'correction';
        JO.chevron_page__c = 'prt';
        JO.CSS_Resolution__c = 'Test';
        JO.Qsol_Engine_Family_Code__c='Test';
        JO.DSID__c = 'VFD23';
        JO.Service_Model__c='ESN';
        //Jo.Service_Model__c, servJob.Qsol_Engine_Family_Code__c, 'en', servJob.Equipment_ID__c, solCompList
        
        
        insert JO;
        
        //CG_BL_Campaigns.callFieldActionSRT(solCompList,JO.Id);
        // CG_BL_Campaigns.callFieldActionSRTClaims(solCompList,JO.Id);
        Test.startTest();
        Test.setMock(HttpCalloutMock.class , new CSS_WS_SBL_GetWarrantyDetailCovrg_Test());
        Test.setMock(HttpCalloutMock.class, new CG_CampaignMock_Test());
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
        conDetails.Name = 'GetCampaign';
        conDetails.AuthEnv__c = 'OAGOAUTH';
        conDetails.ApplicationName__c = 'GetCampaign';
        conDetails.End_Point__c = 'Test';
        conDetails.Method_Type__c = 'POST';
        conDetails.Timeout__c = 2.0;
        insert conDetails;
        
        CSS_Integration_Error__c interr = new  CSS_Integration_Error__c();
        interr.Service_Name__c = 'GetFieldActions/Campaigns';
        interr.Source__c = 'campaignJob';
        insert interr;
        CSS_Integration_Details__c cid = CSS_TestData.createIntegrationDetails(false);
        cid.name = 'CSS_SBL_WarrantyDetailCoverage';
        cid.ApplicationName__c = 'CSS_SBL_WarrantyDetailCoverage';
        cid.End_Point__c = 'https://services-stg.cummins.com/csswarranty/accodecoverage';
        insert cid;
        CSS_Integration_Details__c conDetails1 = new CSS_Integration_Details__c();
        conDetails1.Name = 'CG_FieldActionSRT';
        conDetails1.AuthEnv__c = 'OAGOAuth';
        conDetails1.ApplicationName__c = 'SRT';
        conDetails1.End_Point__c = 'https://services-stg.cummins.com/csswarranty/srtfieldactions';
        conDetails1.Method_Type__c = 'POST';
        conDetails1.Timeout__c = 120000.0;
        insert conDetails1;
        //String grpName;// = 'CQ'+'-'+'12345-12345';
        CSS_Claims__c testclaimsRec = new CSS_Claims__c();
        CSS_PSN__c testpsnNewRec = new CSS_PSN__c();
        CSS_PSN__c testpsnNewRec1 = new CSS_PSN__c();
        List<CSS_PSN__c> lstNewPsn = new List<CSS_PSN__c>();
        //String grpName = 'CQ'+'-'+'12345-12345';
        testclaimsRec.Customer_Name__c='TestCustomer';
        testclaimsRec.Customer_Code__c = '1234';
        //testclaimsRec.id=JO.id;
        testclaimsRec.Contact_Last_Name__c = 'T';
        testclaimsRec.location_code__C = '02850-02991';
        String grpName = 'CQ'+'-'+'12345-12345';
        Group testQue = new Group(Name=grpName, type='Queue');
        insert testQue;
        
        system.runas(new User(Id=UserInfo.getUserId()))
        { 
            
            QueueSObject tq = new QueueSObject(SobjectType='CSS_Claims__c', QueueId=testQue.Id);
            insert tq;
            //Id recTyIdpart = Schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName().get('BMS Parts').getRecordTypeId();
            //css_job_order__c joorder = css_testdata.createJobOrder(true);
            //testclaimsRec = CSS_TestData.createclaims(true,joorder.Id); 
            testclaimsRec.Service_Model__c='test';
            testclaimsRec.EngineFamilyCode__c='test';
            testclaimsRec.ESN__c='79462880';
            testclaimsRec.Region__c='NORTH AMERICA';
            testclaimsRec.Territory__c='UNITED STATES';
            testclaimsRec.FieldActionWebServiceResult__c='Error';
            //testclaimsRec.CSS_Job__c=JO.Id;
            // testclaimsRec.Name='test';
            insert testclaimsRec;
            
        }
        List<CSS_Solution_Component__c> solCompList = new List<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solComp = new CSS_Solution_Component__c();
        solComp.Component_Id__c ='1609';
        solComp.Service_Job__c = Jo.id;
        solComp.Action__c = '';
        solComp.Type__c = 'CAMPAIGN';
        solComp.Campaign_Description__c = 'Hey Hai Man Camp';
        solComp.CampaignPartsPercentage__c = '20';
        solcomp.Performed_Review__c = True;
        solcomp.css_claims__c =testclaimsRec.id;
        //solcomp.AccountCode__c='new parts warranty 62';
        
        solCompList.add(solComp);
        insert solCompList;
        testpsnNewRec.psn__c = '79464646';
        testpsnNewRec.Service_Model__c ='test';
        testpsnNewRec.Qsol_Engine_Family_Code__c='test';
        testpsnNewRec.Primary__C = true;
        testpsnNewRec.failure_Date__c = date.today() - 20;
        testpsnNewRec.Equipment_ID__c='test';
        testpsnNewRec.css_claims__C = testclaimsRec.id;
        lstNewPsn.add(testpsnNewRec);
        testpsnNewRec1.psn__c = '79464646';
        testpsnNewRec1.Service_Model__c ='test1';
        testpsnNewRec1.Qsol_Engine_Family_Code__c='test1';
        testpsnNewRec1.Primary__C = true;
        testpsnNewRec1.failure_Date__c = date.today() - 21;
        testpsnNewRec1.Equipment_ID__c='test';
        testpsnNewRec1.css_claims__C = testclaimsRec.id;
        //insert testpsnNewRec1;
        lstNewPsn.add(testpsnNewRec1);
        insert lstNewPsn;
        CG_BL_Campaigns.callFieldActionSRT(solCompList,JO.Id);
        //CG_BL_Campaigns.callFieldActionSRTClaims(solCompList,JO.Id);
        list<CG_BL_Campaigns.CampaignsWrapper> pwlist=new list<CG_BL_Campaigns.CampaignsWrapper>();
        
        CG_BL_Campaigns.CampaignsWrapper ccw=new CG_BL_Campaigns.CampaignsWrapper(JO.id,'FU','PU', solComp.id,solComp.Component_id__c,true);
        pwlist.add(ccw);
        
        //CG_OP_OAGWrapper oagwrap = CG_BL_Campaigns.callGetCampaignsWS('33186363', '10/10/2017', 'NA', 'Alaska', '', 'Test', 'CSS_ID', 'Message', 'CSS-000464667', 'CSS-00070849', '', 'Auto', 'ENG', 'Test_eqID');
        
        CG_OP_OAGWrapper OPWrap = new CG_OP_OAGWrapper();
        OPWrap = CG_BL_Campaigns.callGetCampaignsWS('33186363', '10/10/2017', 'NA', 'Alaska','CSS', 'GetCampaign','UniqueID', 'CSSWarranty', 'CSS-00070849', JO.Id);
        OPWrap = CG_BL_Campaigns.callGetCampaignsWSforClaims('33186363', '10/10/2017', 'NA', 'Alaska','CSS', 'GetCampaign','UniqueID', 'CSSWarranty', testclaimsRec.Id);
        CG_BL_Campaigns.callGetCampaignsWebService('33186363', '10/10/2017', 'NA', 'Alaska','CSS', 'GetCampaign','UniqueID', 'CSSWarranty', 'CSS-00070849', JO.Id);
        CG_BL_Campaigns.callGetCampaignsWebServiceforClaims('33186363', '10/10/2017', 'NA', 'Alaska','CSS', 'GetCampaign','UniqueID', 'CSSWarranty',testclaimsRec.Id);
        CG_BL_Campaigns.callGetCampaignsWSforClaimsRetrigger('esn','failureDate', 'region', 'territory', 'senderID', 'serviceName', 'messageID', 'target', testclaimsRec.Id );
        set<String> code = new set<String>();
        code.add('1609');
        CG_BL_Campaigns.callGetCampaignsWSforClaimsonReselect('33186363', '10/10/2017', 'NA', 'Alaska','CSS', 'GetCampaign','UniqueID', 'CSSWarranty',testclaimsRec.Id,code,code);
        system.debug('SLOutput**'+OPWrap);
        
        Map<id,CSS_PSN__c> oldMap = new Map<id,CSS_PSN__c>();
        // oldMap.put(testpsnNewRec.id,testpsnNewRec);
        oldMap.put(testpsnNewRec1.id,testpsnNewRec);
        // CG_FieldActionSRTResponse fieldActionSRTResponse = CSS_FN_SRT.getFieldActionSRT(servJob.Service_Model__c, servJob.Qsol_Engine_Family_Code__c, 'en', servJob.Equipment_ID__c, solCompList);
        
        cg_bl_campaigns.callPSNAfterInsert(lstNewPsn);
        cg_bl_campaigns.callPSNAfterUpdate(lstNewPsn,oldMap);
        string Json = '{"DataArea":{"Details":[{"BusinessUnit":"CMI", "CampaignDesc":"ISX15 CM2350 - TRP FOR CALIBRATION FLEET COUNT COSTS WHEN CHANGING ECM BASE CODE POST", "CampaignEndDate":"2020-12-31", "CampaignNumber":1609, "CampaignStartDate":"2015-02-27", "CampaignType":"TRP", "CompleteIndicator":"N", "FailCode":"WEQP", "FailMode":"EZ", "InShopSrtLimitFlag":"N", "MultipleTimes":"Y", "PartList":[{"PartDescription":"6.2 CALIBRATION FLT REG.", "PartNumber":"388639600", "PartQuantity":"1"}],"SrtList":[{"SrtCode":"00-901-00", "SrtDescription":"Administrative Time - Open and Close Repair Order (Shop Repairs)"}],  "Status":"Approved"}]},"Header":{"ReturnCodeDescription":"Success","Status":"SUCCESS"}}';
        //CG_BL_Campaigns.getAccountCodes(Json);
        //CG_BL_Campaigns.getAccountCodes(JO.id,'FU','PU', solComp.id,solComp.Component_id__c);
        Set<String> FieldActNumSet = new Set<String>();
        Set<String> NonSelFieldActNumSet = new Set<String>();
        CG_BL_Campaigns.callGetCampaignsWSforJobsonReselect('33186363', '10/10/2017', 'NA', 'Alaska','CSS', 'GetCampaign','UniqueID', 'CSSWarranty',testclaimsRec.Id,FieldActNumSet,NonSelFieldActNumSet);
        
        Test.stopTest();
    }
    static Testmethod void CG_BL_Campaign_Campaignstestmethod112212()
    {
        
        Account acc = new Account();
        acc.name='Rtest';
        acc.CSS_DistributorCode__c='56270';
        //acc.IAM_Service_Provider_Code__c='56270';
        //acc.IAM_Service_Provider_Code__c = '56270';
        acc.Type = 'Cuetomer';
        acc.IAM_Service_Provider_Code__c = '56270';
        acc.CMI_Account_Status__c = 'Active';
        
        
        insert acc;
        string location = [select id,location__c from account where id=:acc.id].location__c;
        user u = [select id, name from user limit 1];
        
        system.runAs(u){
            CSS_UserLocation__c userLocation = new CSS_UserLocation__c(AccountId__c=acc.id,isActive__c=true,isPrimary__c=true,UserId__c=u.Id,Location_code__c='12345-12345');
            insert userLocation;
            CSS_TestData.createAccountLanguage(true);
        }
        
        CSS_Job_Order__c JO = new CSS_Job_Order__c();
        JO.Customer_Name__c = 'Agassi';
        JO.Application__c = 'Recreational Vehicle';
        JO.ApplicationCode__c = '130';
        JO.Model__c = 'AgassishyamTest';
        JO.Make__c = 'CSSTest';
        JO.Notes__c = 'CAMPCOMMENTS';
        JO.Failure_Point__c = 122;
        JO.Failure_Point_Measure__c = 'Miles';
        JO.VIN__c = '12345677890';
        JO.Failure_Date__c = date.today() - 20;
        JO.Warranty_Start_Date__c = date.today() - 40;
        JO.Location_Certification__c = 'abc';
        JO.jobLocation__c = 'abc';
        JO.Before_In_Service__c = True;
        JO.Status__c = 'Repair Complete';
        JO.Unit_Number__c = 'test123';
        Jo.Equipment_ID__c='Equip';
        Jo.Failure_Date__c =Date.Today();
        Jo.Assigned_To__c = u.id;
        Jo.ESN__c = '33186363';
        JO.Unit_Type__c = 'type';
        Jo.Country__c = 'United States';
        Jo.CSS_State__c = 'Indiana';
        Jo.Region__c='NORTH AMERICA';
        Jo.Territory__c='UNITED STATES';
        Jo.City__c = 'Columbus';
        Jo.Customer_Code__c = '23456';
        Jo.EditComplaint__c = 'complaint';
        Jo.EditCoverage__c = 'coverage';
        Jo.EditCause__c = 'cause';
        Jo.EditCorrection__c = 'correction';
        JO.chevron_page__c = 'prt';
        JO.CSS_Resolution__c = 'Test';
        JO.Qsol_Engine_Family_Code__c='Test';
        JO.DSID__c = 'VFD23';
        JO.Service_Model__c='ESN';
        //Jo.Service_Model__c, servJob.Qsol_Engine_Family_Code__c, 'en', servJob.Equipment_ID__c, solCompList
        
        
        insert JO;
        
        //CG_BL_Campaigns.callFieldActionSRT(solCompList,JO.Id);
        // CG_BL_Campaigns.callFieldActionSRTClaims(solCompList,JO.Id);
        
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
        conDetails.Name = 'GetCampaign';
        conDetails.AuthEnv__c = 'OAGOAUTH';
        conDetails.ApplicationName__c = 'GetCampaign';
        conDetails.End_Point__c = 'Test';
        conDetails.Method_Type__c = 'POST';
        conDetails.Timeout__c = 2.0;
        insert conDetails;
        
        CSS_Integration_Error__c interr = new  CSS_Integration_Error__c();
        interr.Service_Name__c = 'GetFieldActions/Campaigns';
        interr.Source__c = 'campaignJob';
        insert interr;
        CSS_Integration_Details__c cid = CSS_TestData.createIntegrationDetails(false);
        cid.name = 'CSS_SBL_WarrantyDetailCoverage';
        cid.ApplicationName__c = 'CSS_SBL_WarrantyDetailCoverage';
        cid.End_Point__c = 'https://services-stg.cummins.com/csswarranty/accodecoverage';
        insert cid;
        CSS_Integration_Details__c conDetails1 = new CSS_Integration_Details__c();
        conDetails1.Name = 'CG_FieldActionSRT';
        conDetails1.AuthEnv__c = 'OAGOAuth';
        conDetails1.ApplicationName__c = 'SRT';
        conDetails1.End_Point__c = 'https://services-stg.cummins.com/csswarranty/srtfieldactions';
        conDetails1.Method_Type__c = 'POST';
        conDetails1.Timeout__c = 120000.0;
        insert conDetails1;
        //String grpName;// = 'CQ'+'-'+'12345-12345';
        CSS_Claims__c testclaimsRec = new CSS_Claims__c();
        CSS_PSN__c testpsnNewRec = new CSS_PSN__c();
        CSS_PSN__c testpsnNewRec1 = new CSS_PSN__c();
        List<CSS_PSN__c> lstNewPsn = new List<CSS_PSN__c>();
        //String grpName = 'CQ'+'-'+'12345-12345';
        testclaimsRec.Customer_Name__c='TestCustomer';
        testclaimsRec.Customer_Code__c = '1234';
        //testclaimsRec.id=JO.id;
        testclaimsRec.Contact_Last_Name__c = 'T';
        testclaimsRec.location_code__C = '02850-02991';
        String grpName = 'CQ'+'-'+'12345-12345';
        Group testQue = new Group(Name=grpName, type='Queue');
        insert testQue;
        
        system.runas(new User(Id=UserInfo.getUserId()))
        { 
            
            QueueSObject tq = new QueueSObject(SobjectType='CSS_Claims__c', QueueId=testQue.Id);
            insert tq;
            //Id recTyIdpart = Schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName().get('BMS Parts').getRecordTypeId();
            //css_job_order__c joorder = css_testdata.createJobOrder(true);
            //testclaimsRec = CSS_TestData.createclaims(true,joorder.Id); 
            testclaimsRec.Service_Model__c='test';
            testclaimsRec.EngineFamilyCode__c='test';
            testclaimsRec.ESN__c='79462880';
            testclaimsRec.Region__c='NORTH AMERICA';
            testclaimsRec.Territory__c='UNITED STATES';
            testclaimsRec.FieldActionWebServiceResult__c='Error';
            //testclaimsRec.CSS_Job__c=JO.Id;
            // testclaimsRec.Name='test';
            insert testclaimsRec;
            
        }
        List<CSS_Solution_Component__c> solCompList = new List<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solComp = new CSS_Solution_Component__c();
        solComp.Component_Id__c ='1609';
        solComp.Service_Job__c = Jo.id;
        solComp.Action__c = '';
        solComp.Type__c = 'CAMPAIGN';
        solComp.Campaign_Description__c = 'Hey Hai Man Camp';
        solComp.CampaignPartsPercentage__c = '20';
        solcomp.Performed_Review__c = True;
        solcomp.css_claims__c =testclaimsRec.id;
        //solcomp.AccountCode__c='new parts warranty 62';
        
        solCompList.add(solComp);
        insert solCompList;
        testpsnNewRec.psn__c = '79464646';
        testpsnNewRec.Service_Model__c ='test';
        testpsnNewRec.Qsol_Engine_Family_Code__c='test';
        testpsnNewRec.Primary__C = true;
        testpsnNewRec.failure_Date__c = date.today() - 20;
        testpsnNewRec.Equipment_ID__c='test';
        testpsnNewRec.css_claims__C = testclaimsRec.id;
        lstNewPsn.add(testpsnNewRec);
        testpsnNewRec1.psn__c = '79464646';
        testpsnNewRec1.Service_Model__c ='test1';
        testpsnNewRec1.Qsol_Engine_Family_Code__c='test1';
        testpsnNewRec1.Primary__C = true;
        testpsnNewRec1.failure_Date__c = date.today() - 21;
        testpsnNewRec1.Equipment_ID__c='test';
        testpsnNewRec1.css_claims__C = testclaimsRec.id;
        //insert testpsnNewRec1;
        lstNewPsn.add(testpsnNewRec1);
        insert lstNewPsn;
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class , new CSS_WS_SBL_GetWarrantyDetailCovrg_Test());
        
        
        //CG_OP_OAGWrapper oagwrap = CG_BL_Campaigns.callGetCampaignsWS('33186363', '10/10/2017', 'NA', 'Alaska', '', 'Test', 'CSS_ID', 'Message', 'CSS-000464667', 'CSS-00070849', '', 'Auto', 'ENG', 'Test_eqID');
        
        CG_OP_OAGWrapper OPWrap = new CG_OP_OAGWrapper();
        //OPWrap = CG_BL_Campaigns.callGetCampaignsWS('33186363', '10/10/2017', 'NA', 'Alaska','CSS', 'GetCampaign','UniqueID', 'CSSWarranty', 'CSS-00070849', JO.Id);
        OPWrap = CG_BL_Campaigns.callGetCampaignsWSforClaims('33186363', '10/10/2017', 'NA', 'Alaska','CSS', 'GetCampaign','UniqueID', 'CSSWarranty', testclaimsRec.Id);
        
        
        Test.stopTest();
    }
    
    static Testmethod void CG_BL_CampaignsTest()
    {
        
        Account acc = new Account();
        acc.name='Rtest';
        acc.CSS_DistributorCode__c='56270';
        acc.Type = 'Dealer Account';
        acc.IAM_Service_Provider_Code__c = '56270';
        acc.CMI_Account_Status__c = 'Active';
        insert acc;
        
        string location = [select id,location__c from account where id=:acc.id].location__c;
        user u = [select id, name from user limit 1];
        
        system.runAs(u){
            
            CSS_UserLocation__c userLocation = new CSS_UserLocation__c(AccountId__c=acc.id,isActive__c=true,isPrimary__c=true,UserId__c=u.Id,Location_code__c='12345-12345');
            insert userLocation;
            CSS_TestData.createAccountLanguage(true);
        }
        
        CSS_Job_Order__c JO = new CSS_Job_Order__c();
        JO.Customer_Name__c = 'Agassi';
        JO.Application__c = 'Recreational Vehicle';
        JO.ApplicationCode__c = '130';
        JO.Model__c = 'AgassishyamTest';
        JO.Make__c = 'CSSTest';
        JO.Notes__c = 'CAMPCOMMENTS';
        JO.Failure_Point__c = 122;
        JO.Failure_Point_Measure__c = 'Miles';
        JO.VIN__c = '12345677890';
        JO.Failure_Date__c = date.today() - 20;
        JO.Warranty_Start_Date__c = date.today() - 40;
        JO.Location_Certification__c = 'abc';
        JO.jobLocation__c = 'abc';
        JO.Before_In_Service__c = True;
        JO.Status__c = 'Repair Complete';
        JO.Unit_Number__c = 'test123';
        Jo.Equipment_ID__c='Equip';
        Jo.Failure_Date__c =Date.Today();
        Jo.Assigned_To__c = u.id;
        Jo.ESN__c = '33186363';
        JO.Unit_Type__c = 'type';
        Jo.Country__c = 'United States';
        Jo.CSS_State__c = 'Indiana';
        Jo.Region__c='NORTH AMERICA';
        Jo.Territory__c='UNITED STATES';
        Jo.City__c = 'Columbus';
        Jo.Customer_Code__c = '23456';
        Jo.EditComplaint__c = 'complaint';
        Jo.EditCoverage__c = 'coverage';
        Jo.EditCause__c = 'cause';
        Jo.EditCorrection__c = 'correction';
        JO.chevron_page__c = 'prt';
        JO.CSS_Resolution__c = 'Test';
        JO.Qsol_Engine_Family_Code__c='Test';
        JO.DSID__c = 'VFD23';
        JO.Service_Model__c='ESN';
        insert JO;
        
        
        CSS_Claims__c testclaimsRec = new CSS_Claims__c();
        testclaimsRec.Customer_Name__c='TestCustomer';
        testclaimsRec.Customer_Code__c = '1234';
        testclaimsRec.Contact_Last_Name__c = 'T';
        testclaimsRec.location_code__C = '02850-02991';
        testclaimsRec.Service_Model__c='test';
        testclaimsRec.EngineFamilyCode__c='test';
        testclaimsRec.ESN__c='79462880';
        testclaimsRec.Region__c='NORTH AMERICA';
        testclaimsRec.Territory__c='UNITED STATES';
        testclaimsRec.FieldActionWebServiceResult__c='Error';
        insert testclaimsRec;
        
        List<CSS_PSN__c> lstNewPsn = new List<CSS_PSN__c>();
        CSS_PSN__c testpsnNewRec = new CSS_PSN__c();
        testpsnNewRec.psn__c = '79464646';
        testpsnNewRec.Service_Model__c ='test';
        testpsnNewRec.Qsol_Engine_Family_Code__c='test';
        testpsnNewRec.Primary__C = true;
        testpsnNewRec.failure_Date__c = date.today() - 20;
        testpsnNewRec.Equipment_ID__c='test';
        testpsnNewRec.css_claims__C = testclaimsRec.id;
        lstNewPsn.add(testpsnNewRec);
        insert lstNewPsn;
        
        List<CSS_Solution_Component__c> solCompList = new List<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solComp = new CSS_Solution_Component__c();
        solComp.Component_Id__c ='1609';
        solComp.Service_Job__c = Jo.id;
        solComp.Action__c = '';
        solComp.Type__c = 'CAMPAIGN';
        solComp.Campaign_Description__c = 'Hey Hai Man Camp';
        solComp.CampaignPartsPercentage__c = '20';
        solcomp.Performed_Review__c = True;
        solcomp.css_claims__c =testclaimsRec.id;
        solCompList.add(solComp);
        insert solCompList;
        
        
        String grpName = 'CQ'+'-'+'12345-12345';
        Group testQue = new Group(Name=grpName, type='Queue');
        insert testQue;
        
        system.runas(new User(Id=UserInfo.getUserId()))
        { 
            QueueSObject tq = new QueueSObject(SobjectType='CSS_Claims__c', QueueId=testQue.Id);
            insert tq;
        }
        
        
        test.startTest();
        
        Map<id,CSS_PSN__c> oldMap = new Map<id,CSS_PSN__c>();
        list<CG_BL_Campaigns.CampaignsWrapper> pwlist=new list<CG_BL_Campaigns.CampaignsWrapper>();
        set<String> code = new set<String>();
        code.add('1609');
        oldMap.put(testpsnNewRec.id,testpsnNewRec);
        
        CG_OP_OAGWrapper OPWrap = new CG_OP_OAGWrapper();
        OPWrap = CG_BL_Campaigns.callGetCampaignsWS('33186363', '10/10/2017', 'NA', 'Alaska','CSS', 'GetCampaign','UniqueID', 'CSSWarranty', 'CSS-00070849', JO.Id);
        OPWrap = CG_BL_Campaigns.callGetCampaignsWSforClaims('33186363', '10/10/2017', 'NA', 'Alaska','CSS', 'GetCampaign','UniqueID', 'CSSWarranty', testclaimsRec.Id);
        CG_BL_Campaigns.callGetCampaignsWSforClaimsRetrigger('esn','failureDate', 'region', 'territory', 'senderID', 'serviceName', 'messageID', 'target', testclaimsRec.Id );
        cg_bl_campaigns.callPSNAfterInsert(lstNewPsn);
        cg_bl_campaigns.callPSNAfterUpdate(lstNewPsn,oldMap);
        CG_BL_Campaigns.callGetCampaignsWSforClaimsonReselect('33186363', '10/10/2017', 'NA', 'Alaska','CSS', 'GetCampaign','UniqueID', 'CSSWarranty',testclaimsRec.Id,code,code);
        Set<String> FieldActNumSet = new Set<String>();
        Set<String> NonSelFieldActNumSet = new Set<String>();
        CG_BL_Campaigns.callGetCampaignsWSforJobsonReselect('33186363', '10/10/2017', 'NA', 'Alaska','CSS', 'GetCampaign','UniqueID', 'CSSWarranty',testclaimsRec.Id,FieldActNumSet,NonSelFieldActNumSet);
        
        Test.stopTest();
    }
    
}