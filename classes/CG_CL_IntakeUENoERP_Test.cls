@isTest(SeeAllData=false)

public class CG_CL_IntakeUENoERP_Test {
    Static String recordType_Id = Schema.SObjectType.Account.getRecordTypeInfosByName().get('WWSPS').getRecordTypeId();    
    static testmethod void mainMethod(){
        
        CSS_Job_Order__c SerRec = CSS_TestData.createJobOrder(false);
        SerRec.ESN__c = '79464646';
        SerRec.ProductAppcodeErrorflag__c = true;
        SerRec.ReconEngineFlag__c = 'Y';
        SerRec.SP_WarrantyCertificationEndDate__c = '02/02/18';
        SerRec.Unit_Number__c ='12345';
        SerRec.Service_Model__c = 'XDFF34';
        SerRec.VIN__c = '';
        SerRec.VIN_Flag__c = true;
        SerRec.Warranty_Start_Date__c = null;
        SerRec.Location_Certification__c = 'Bangalore';
        SerRec.ESN_IA__c = '5678909078';
        serrec.Qsol_Engine_Family_Code__c='Test';
        SerRec.Failure_Date__c = system.today()+1;
        serrec.Before_In_Service__c = false;
        SerRec.Warranty_Start_Date__c = system.today()+10;
        SerRec.ShipDate__c=null;
       // SerRec.faildtshdtflag= true;
        insert SerRec;
        account acc = new account();
            acc.Name = 'test';
            acc.Type = 'Customer';
            acc.CSS_DistributorCode__c = '25270';
            acc.CMI_Account_Status__c = 'Active';
            acc.IAM_Service_Provider_Code__c = '25720';
            insert acc;
        contact c=new contact();
        c.AccountId=acc.id;
        c.FirstName='Test2';
        c.LastName='test1';
        insert c;

        List<Asset> lstAsset = new List<Asset>();
        Asset ass = new Asset();
        ass.Name='test';
        ass.AccountId=acc.id;
        ass.ContactId=c.id;
        ass.SerialNumber = SerRec.ESN__c;
        ass.Type__c='Engines';
        insert ass;
        lstAsset.add(ass);	
        ApexPages.currentPage().getParameters().put('id', SerRec.Id);
        
        CG_CL_IntakeUENoERP intakeJob = new CG_CL_IntakeUENoERP();
        string PageName ='intake';
        
        CG_CL_IntakeUE iue = new CG_CL_IntakeUE();
        iue.workJob.Failure_Date__c = system.today()+1;
        
        CG_CL_IntakeUENoERP noERP = new CG_CL_IntakeUENoERP();
        noERP.show_ue_pnl = true;
        noERP.bmsEnabled = true;
        noERP.displaySrvModPopup = true;
        noERP.showOutageError = true;
        noERP.showOutageError1 = false;
        noERP.recconFlag = true;
        noERP.psncheck = true;
        noERP.HHSPSMNFlg = true;
        noERP.HHSPACCSFlg = true;
        noERP.sWarrantyDt = '123';
        noERP.displayPopup7 = true;
        noERP.displaycertPopup = true;
        noERP.displaySrvModPopup1 = true;
        noERP.errorMessage = 'test2';
        noERP.equipmentId ='568';
        noERP.sEngineFamilyCode = 'test2';
        noERP.siebelSMN = 'test2';
        noERP.siebVIN = 'test2';
        noERP.siebAppCode = 'test2';
        noERP.sServiceModel = 'test2';
        noERP.filterApplication = 'test2';
        noERP.filterCategory = 'test2';
        noERP.filterCategory2 = 'test2';
        noERP.filterCategory3 = 'test2';
        noERP.filterCategory4 = 'test2';
        noERP.filterCategory5 = 'test2';
        noERP.filterComplaintType = 'test2';
        noERP.filterComplaintType2 = 'test2';
        noERP.filterComplaintType3 = 'test2';
        noERP.filterComplaintType4 = 'test2';
        noERP.filterComplaintType5 = 'test2';
        noERP.EmailAddress = 'test2';
        noERP.EmailAddress1 = 'test2';
        noERP.comm = 'test2';
        noERP.Wid = null;
        noERP.faildtwsdtflag = false;
        noERP.dt_WarrantyDt=date.today()-20;
        noERP.dt_FailureDt=system.now();
        noERP.ReadonlyBIS =true;
        noERP.showPopup7();
        //noERP.esnGo();
        // noERP.esnGo();
        noERP.getCamps();
        noERP.closecertPopup();
        noERP.closeSrvModPopup();
        noERP.getTrps();
        noERP.getAtcs();   
        noERP.getTsbs();
        noERP.getItems();
        noERP.getApplication();
        noERP.getALLRecords();
        noERP.faildtshdtflag =true;
        
        CSS_Make_Model_Access__c MakeList = new CSS_Make_Model_Access__c();
        
        CSS_Make_Model_Access__c mk = new CSS_Make_Model_Access__c();
        // mk.Name = '100-EQ6423-32-A';
        mk.Access__c = 'D';
        //mk.EngineFamily__c = '32';
        //mk.EngineFamily__c = '878';
        mk.EquipmentId__c = 'EQ6423';
        // mk.Make__c = 'DRESSER';
        mk.Make__c = 'Miles' ;
        mk.Model__c = '100';
        insert mk;
        
        
        CSS_CampTsbTrp__c ct = new CSS_CampTsbTrp__c();
        ct.name = 'CAM';
        ct.name = 'TRP';
        ct.name = 'TSB';
        insert ct;
        
        list < CSS_CampTsbTrp__c > solutionList = new list < CSS_CampTsbTrp__c > ();
        CSS_Solutions__c cssSol;
        
        CSS_CampTsbTrp__c solRec = new CSS_CampTsbTrp__c(Doc_Num__c = 'TSB140168', URL__c = 'https://qsolpilot.cummins.com/qs3/pubsys2/xml/en/tsb/2014/tsb140168.html',
                                                         Type__c = 'CAM', Doc_Title__c = 'xyz', Cu_Language__c = 'xc', Performed__c = false, Job_Order__c = SerRec.Id,
                                                         Performed_Review__c = false, Reviewed__c = false, esn__c = '79464646');
        solutionList.add(solRec);
        
        CSS_CampTsbTrp__c solRec2 = new CSS_CampTsbTrp__c(Doc_Num__c = 'TSB14013368', URL__c = 'https://qsolpilot.cummins.com/qs9/pubsys2/xml/en/tsb/2014/tsb140168.html',
                                                          Type__c = 'TRP', Doc_Title__c = 'xyz', Cu_Language__c = 'xc', Performed__c = false, Job_Order__c = SerRec.Id,
                                                          Performed_Review__c = true, Reviewed__c = false, esn__c = '79464646');
        solutionList.add(solRec2);
        
        CSS_CampTsbTrp__c solRec1 = new CSS_CampTsbTrp__c(Doc_Num__c = 'TSB1401689', URL__c = 'https://qsolpilot.cummins.com/qs3/pubsys2/xml/en1/tsb/2014/tsb140168.html',
                                                          Type__c = 'TSB', Doc_Title__c = 'xyzk', Cu_Language__c = 'xc', Performed__c = true, Job_Order__c = SerRec.Id,
                                                          Performed_Review__c = false, Reviewed__c = false, esn__c = '79464646');
        solutionList.add(solRec1);
        insert solutionList;
        
        list < CSS_CampTsbTrp__c > campTsbList = new list < CSS_CampTsbTrp__c > ();
        CSS_CampTsbTrp__c campTsTr = new CSS_CampTsbTrp__c();
        campTsTr.Performed__c = true;
        campTsTr.Performed_Review__c = true;
        campTsTr.Job_Order__c = SerRec.Id;
        campTsTr.URL__c = 'www.salesforce.com';
        campTsTr.Reviewed__c = true;
        campTsTr.Type__c = 'CAM';
        campTsTr.Doc_Title__c = 'Title';
        campTsTr.Reviewed__c = true;
        campTsTr.Doc_Num__c = 'testing';
        insert campTsTr;
        campTsbList.add(ct);
        campTsbList.add(campTsTr);
        
        
        
        String json = '{'+
            '  \"Details\": {'+
            '    \"ApplicationCode\": \"12345\",'+
            '    \"Description\": \"testing\",'+
            '    \"BusinessUnit\": \"GetAssessData\",'+
            '    \"AutomotiveFlag\": \"Fault Details Data sent successfully\",'+
            '    \"MarineFlag\": \"Fault Details Data sent successfully\",'+
            '    \"ActiveFlag\": \"Y\",'+   
            '    \"DefaultUom\": \"Fault Details Data sent successfully\"'+    
            '  },'+
            '  \"Header\": {'+ 
            '        \"ReturnCodeDescription\": \"Test\",'+
            '        \"Status\": \"completed\"'+
            '      }'+
            '}';
        
        
        CSS_JobEventTemporary__c je1 = CSS_TestData.createJobEventTempObj(false);
        je1.Attribute1__c = 'UnitTypes';
        je1.key__c = 'MarketingApplicationCodes';
        je1.Attribute5__c='test123';
        je1.Attribute2__c='test';
        je1.Reason__c = json;
        insert je1;
        
        CSS_JobEventTemporary__c je2 = CSS_TestData.createJobEventTempObj(false);
        je2.Attribute1__c = 'SubType';
        je2.key__c = '02400-02400';
        je2.Reason__c = json;
        insert je2;
        
        CSS_Listof_HHP_SMNS__c hhp = new CSS_Listof_HHP_SMNS__c();
        hhp.name = 'SX15 CM2350 X101';
        hhp.Listof_HHP_SMN__c = 'SX15 CM2350 X101';
        insert hhp;
        
        Profile p = [SELECT Id FROM Profile WHERE Name='CSS_Service_Advanced'];
        
        User u = new User(Alias = 'standt', Email='standarduser4@testorg.com',
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                          LocaleSidKey='en_US',  ProfileId = p.Id,
                          TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTestUser4@testorg.com',User_Location__c = 'location');
        insert u;
        
        
        list<account> lstAcc = new list<Account>();
        
        list<CSS_UserLocation__c> lstUsrLoc =new list<CSS_UserLocation__c>();
        
        if(lstAcc!=null && lstAcc.size()>0) {
            
            CSS_UserLocation__c userLocation = new CSS_UserLocation__c(AccountId__c=lstAcc[0].id,isActive__c=true,isPrimary__c=true,UserId__c=u.Id,Location_code__c='56270-56270');
            CSS_UserLocation__c userLocation1 = new CSS_UserLocation__c(AccountId__c=lstAcc[1].id,isActive__c=true,isPrimary__c=false,UserId__c=u.Id,Location_code__c='56271-56271');
            CSS_UserLocation__c userLocation2 = new CSS_UserLocation__c(AccountId__c=lstAcc[2].id,isActive__c=true,isPrimary__c=false,UserId__c=u.Id,Location_code__c='56272-56272');
            lstUsrLoc.add(userLocation);
            lstUsrLoc.add(userLocation1);
            lstUsrLoc.add(userLocation2);
            insert lstUsrLoc;
        }
        
        // CSS_Job_Order__c job =CSS_TestData.createJobOrder(true);    
        
        CSS_CampTsbTrp__c cssTrp = new CSS_CampTsbTrp__c();
        cssTrp.Name = 'Test Trp';
        //cssTrp.Job_Order__c = Job.id;
        cssTrp.performed_review__c = true;
        cssTrp.performed__c = false;
        cssTrp.Cu_Language__c = 'Hindi';
        
        insert cssTrp;
        
        
        
        PageReference pref;
        pref = new PageReference('/'+SerRec.Id);
        pref.getParameters().put('id',SerRec.Id);
        pref.getParameters().put('partsUr','Parts');
        Test.setCurrentPage(pref);
        
        //CG_CL_IntakeUE job12 = new CG_CL_IntakeUE();
        //Inserting test data for CSS_accountLanguage__c accountlang
        
        CSS_TestData.createAccountLanguage(true);
        CSS_TestData.createIntegrationDetails(true);
        //IntakeJob.updateNotes();
        
        Test.startTest();
        Test.setMock(WebServiceMock.class, new CSS_GetEngineDataPlate_Test());
        Test.setMock(HttpCalloutMock.class, new CSS_getEngineDataFrmSiebel_Test());
        CG_CL_IntakeUENoERP IntakeJob1 = new CG_CL_IntakeUENoERP();
        CG_CL_IntakeVH invh = new CG_CL_IntakeVH();
        CG_CL_IntakeRJ inrj = new CG_CL_IntakeRJ();
        IntakeJob1.mainContrVH = invh;
        IntakeJob1.mainContrRJ = inrj;
        
        CG_CL_IntakeUE cciue = new CG_CL_IntakeUE();
        cciue.Wid = ApexPages.currentPage().getParameters().put('id',SerRec.id);
        cciue.filterApplication='test2';
        cciue.workJob = SerRec;
        cciue.filterMake='Test';
        cciue.filterModel='Test';
        
        //insert cciue;
        
        IntakeJob1.mainContr = cciue;
        IntakeJob1.sEngineFamilyCode='Test';
        IntakeJob1.getModel();
        Intakejob1.getMake();
        Date Mydate1 = IntakeJob1.parseQSOLDate('15-1-2005');
        IntakeJob1.PageName = 'test4';
        cciue.workjob.Failure_Date__c = date.today()+1;
        IntakeJob1.callingLocation = 'test2';
        IntakeJob1.contactshowOutageError = true;
        IntakeJob1.UnitLookUpPopup = true;
        IntakeJob1.reqAppBoolean = true;
        IntakeJob1.startRequestNullPSN();
        Intakejob1.getALLRecords();
        IntakeJob1.esnGo();
        // IntakeJob1.pgSaveFinish();
        IntakeJob1.closeSrvModPopup1();
        IntakeJob1.getCampaignDetails();
        IntakeJob1.updateproductappcode();
       // intakeJOb1.checkFailureDateerror();
       // intakejob1.GetEngineDataPlateQSOL();
        CSS_Job_Order__c SerRec1 = new CSS_Job_Order__c();
        SerRec1.Failure_Date__c = date.today();
        serRec1.BuildDate__c = date.today()-1;
       // SerRec1.checkFailureDateerror =true;
        SerRec1.Before_In_Service__c = false;
        SerRec1.Warranty_Start_Date__c = system.today()+10;
        insert SerRec1;
        CG_CL_IntakeUE intkobj = new CG_CL_IntakeUE();
        intkobj.workJob= SerRec1;
        /*System.runAs(u){
CSS_Job_Order__c jobordr = new CSS_Job_Order__c();
jobordr.ESN__c = '79464646';
insert jobordr;

}*/
        CSS_JobEventTemporary__c obj = new CSS_JobEventTemporary__c();
        obj.Key__c = 'MarketingApplicationCodes';
        obj.Attribute1__c= 'BB';
        obj.Attribute3__c = 'AUTOMOTIVE';  
        insert obj;
        
        CSS_List_Of_Values__c lof = new CSS_List_Of_Values__c();
        lof.Name = 'test';
        lof.Code__c ='123';
        insert lof;
        IntakeJob1.mainContr.workJob.SP_WarrantyCertificationEndDate__c = 'Y';
        intakeJob1.mainContr.filterApplication='345';
        //   intakeJob1.mainContr.ShipDate__c=date.today();
        IntakeJob1.updateproductappcode();
        IntakeJob1.startRequest();
        Test.stopTest();
    }
    static testMethod void getCampaignDetails(){
        Profile p = [SELECT Id FROM Profile WHERE Name='CSS_Service_Advanced'];
        
        User u = new User(Alias = 'standt', Email='standarduser4@testorg.com',
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                          LocaleSidKey='en_US',  ProfileId = p.Id,
                          TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTestUser4@testorg.com',User_Location__c = 'location');
        insert u;
        
        test.startTest();
        
        System.runAs(u){
            CSS_Job_Order__c jobordr = new CSS_Job_Order__c();
            jobordr.ESN__c = '79464646';
            jobordr.Failure_Date__c = date.today();
            jobordr.Before_In_Service__c = false;
            insert jobordr;
            /*account acc = new account();
            acc.Name = 'test';
            acc.Type = 'Customer';
            acc.CSS_DistributorCode__c = '25270';
            acc.CMI_Account_Status__c = 'Active';
           // acc.IAM_Service_Provider_Code__c = '25720';
            insert acc;
        contact c=new contact();
        c.AccountId=acc.id;
        c.LastName='test1';
        insert c;

        List<Asset> lstAsset = new List<Asset>();
        Asset ass = new Asset();
        ass.Name='test';
        ass.AccountId=acc.id;
        ass.ContactId=c.id;
        ass.SerialNumber = jobordr.ESN__c;
        ass.Type__c='Engines';
        insert ass;
        lstAsset.add(ass);*/
            CG_CL_IntakeUE obj = new CG_CL_IntakeUE();
            obj.workJob = jobordr;
            obj.workJob.PSN_Not_Available__c = false;
            obj.workjob.ProductAppcodeErrorflag__c = true;
            //obj.esnGo();
            
            CSS_quickserveCumminsComWebservices.ModelName md = new CSS_quickserveCumminsComWebservices.ModelName();
            md.buildDate = '20/10/10';
            CG_CL_IntakeUENoERP IntakeJob2 = new CG_CL_IntakeUENoERP(); 
            CG_CL_IntakeUE intakeue = new CG_CL_IntakeUE();
            intakeue.workjob.Failure_Date__c =system.today()+1;
            IntakeJob2.mainContr = obj;
            IntakeJob2.mainContr.workJob.SP_WarrantyCertificationEndDate__c = 'Y';
            Test.setMock(WebServiceMock.class, new CSS_GetEngineDataPlate_Test());
            IntakeJob2.startRequest();
            IntakeJob2.getCampaignDetails();
            IntakeJob2.startRequestNullPSN();
        }
        test.stopTest();
    }
    static testMethod void engineDataSiebel() {
        
        Test.setMock(HttpCalloutMock.class, new CSS_getEngineDataFrmSiebel_Test());
        Test.setMock(WebServiceMock.class, new CSS_GetEngineDataPlate_Test());
        //Test.setMock(HttpCalloutMock.class, new CG_WS_QSOLMock());
        //css_intake_job_R2 IntakeJobRstartReq = new css_intake_job_R2();
        
        CSS_Job_Order__c JOsr = new CSS_Job_Order__c();
        JOsr.ESN__c = '79384192';
        JOsr.Failure_Date__c = system.today();
        JOsr.Before_In_Service__c = false;
        JOsr.Warranty_Start_Date__c = system.today()+10;
        insert JOsr;
        
        CSS_Listof_HHP_SMNS__c hhp = new CSS_Listof_HHP_SMNS__c();
        hhp.name = 'SX15 CM2350 X101';
        hhp.Listof_HHP_SMN__c = 'SX15 CM2350 X101';
        insert hhp;
        
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
        conDetails.Name = 'GetCampaign';
        conDetails.AuthEnv__c = 'OAGOAUTH';
        conDetails.ApplicationName__c = 'GetCampaignBL';
        conDetails.End_Point__c = 'https://services-stg.cummins.com/css/getcampaigndetails';
        conDetails.Method_Type__c = 'POST';
        conDetails.Timeout__c = 2.0;
        insert conDetails;
        
        Test.setMock(WebServiceMock.class, new CSS_GetEngineDataPlate_Test());
        Test.setMock(HttpCalloutMock.class, new CSS_getEngineDataFrmSiebel_Test());
        Test.setMock(HttpCalloutMock.class, new CG_CampaignMock_Test());
        
        Test.startTest();
       // CG_CL_IntakeUeNoERP IntakeJobRstartReq = new CG_CL_IntakeUeNoERP();
        //IntakeJobRstartReq.workJob = JOsr;
        CSS_getEngineDataReqJ2A wrapobj = new CSS_getEngineDataReqJ2A();
        CSS_getEngineDataResponseJ2A engineData;
        CSS_getEngineDataReqJ2A.DataArea jidi = new CSS_getEngineDataReqJ2A.DataArea();
        jidi.ESN = JOsr.ESN__c;
        wrapobj.DataArea = jidi;
        //engineData = CSS_WS_SBL.getEngineData(wrapobj);
        //IntakeJobRstartReq.startRequest();
        //IntakeJobRstartReq.pgSaveFinish();
        Test.stopTest();
    }
    
    static testmethod void TestforFailureDateWarrantyDate(){
        
        CG_CL_IntakeUENoERP TestmetUEno = new CG_CL_IntakeUENoERP();
        CSS_UnitOutboundJSON2Apex obj = new CSS_UnitOutboundJSON2Apex();
        TestmetUEno.UnitOutboundDetails = obj;
        TestmetUEno.dt_WarrantyDt=system.now();
        TestmetUEno.dt_FailureDt=system.now();
        TestmetUEno.getWarrantyDate();
        TestmetUEno.getFailureDt();
    }
    
    static testmethod void TestforTsbTrbATCCamp(){
        
        CG_CL_IntakeUENoERP TsbTrbATCCamp = new CG_CL_IntakeUENoERP();
        
        css_job_order__c Jobwo13 = new css_job_order__C();
        Jobwo13.ESN__c='79850897';
        Jobwo13.Failure_Date__c = date.today();
        Jobwo13.Before_In_Service__c = false;
        Jobwo13.Warranty_Start_Date__c = date.today()-3;
        insert Jobwo13;
        
        //Adding Instance variable here
        CG_CL_IntakeUE maincrl = new CG_CL_IntakeUE();
        maincrl.workJob=Jobwo13;
        maincrl.Wid=Jobwo13.id;
        TsbTrbATCCamp.mainContr = maincrl;
        TsbTrbATCCamp.Wid = Jobwo13.ID;
        
        //Inserting CampTSBTRPATC record here,
        CSS_CampTsbTrp__c ctt = new CSS_CampTsbTrp__c();
        ctt.Type__c = 'ATC';
        ctt.URL__c = 'https://qs-stg.cummins.com/qs3/pubsys2/xml/en/atc/19TC/atc1623.html';
        ctt.Doc_Num__c = 'ATCF0051000';
        ctt.Doc_Title__c = 'DUAL FUEL DATAPLATE ATC';
        ctt.Performed__c = false;
        ctt.Performed_Review__c = true;
        ctt.Reviewed__c = false;
        ctt.Job_Order__c = maincrl.Wid;
        ctt.ESN__c = Jobwo13.ESN__c;
        ctt.cu_language__C = 'fr';
        insert ctt;
        
        CSS_CampTsbTrp__c ctt1 = new CSS_CampTsbTrp__c();
        ctt1.Type__c = 'CAM';
        ctt1.URL__c = 'https://qs-stg.cummins.com/qs3/pubsys2/xml/en/atc/19TC/camp1623.html';
        ctt1.Doc_Num__c = 'CF0051000';
        ctt1.Doc_Title__c = 'DUAL FUEL DATAPLATE Camp';
        ctt1.Performed__c = false;
        ctt1.Performed_Review__c = true;
        ctt1.Reviewed__c = false;
        ctt1.Job_Order__c = maincrl.Wid;
        ctt1.ESN__c = Jobwo13.ESN__c;
        ctt1.cu_language__C = 'fr';
        insert ctt1;
        system.debug('---ctttest--' +ctt1);
        
        CSS_CampTsbTrp__c ctt2 = new CSS_CampTsbTrp__c();
        ctt2.Type__c = 'TRP';
        ctt2.URL__c = 'https://qs-stg.cummins.com/qs3/pubsys2/xml/en/atc/19TC/trb1623.html';
        ctt2.Doc_Num__c = 'TF0051000';
        ctt2.Doc_Title__c = 'DUAL FUEL DATAPLATE TRP';
        ctt2.Performed__c = false;
        ctt2.Performed_Review__c = true;
        ctt2.Reviewed__c = false;
        ctt2.Job_Order__c = maincrl.Wid;
        ctt2.ESN__c = Jobwo13.ESN__c;
        ctt2.cu_language__C = 'fr';
        insert ctt2;
        
        CSS_CampTsbTrp__c ctt3 = new CSS_CampTsbTrp__c();
        ctt3.Type__c = 'TSB';
        ctt3.URL__c = 'https://qs-stg.cummins.com/qs3/pubsys2/xml/en/atc/19TC/TSB1623.html';
        ctt3.Doc_Num__c = 'TF0051000';
        ctt3.Doc_Title__c = 'DUAL FUEL DATAPLATE TSB';
        ctt3.Performed__c = false;
        ctt3.Performed_Review__c = true;
        ctt3.Reviewed__c = false;
        ctt3.Job_Order__c = maincrl.Wid;
        ctt3.ESN__c = Jobwo13.ESN__c;
        insert ctt3;
        
        list<CSS_CampTsbTrp__c> TestingQsolcttp = [select Type__c,URL__c,Doc_Num__c,Doc_Title__c, Performed__c,Performed_Review__c,Reviewed__c from CSS_CampTsbTrp__c where Job_Order__c= :TsbTrbATCCamp.Wid AND Type__c !='TSB' ];
        system.assert(TestingQsolcttp!=null);
        
        test.startTest();
        system.debug('GetallRecords Enters here');
        TsbTrbATCCamp.getALLRecords();
        TsbTrbATCCamp.getALLRecords();
        system.debug('GetallRecords Stops here');
        tsbtrbatccamp.getTrps();
        tsbtrbatccamp.getAtcs();
        tsbtrbatccamp.getCamps();
        
        CSS_Job_Order__c SerRec1 = new CSS_Job_Order__c();
        SerRec1.Failure_Date__c = system.today()+1;
        SerRec1.Before_In_Service__c = false;
        SerRec1.Warranty_Start_Date__c = system.today()+10;
        insert SerRec1;
        CG_CL_IntakeUE intkobj = new CG_CL_IntakeUE();
        intkobj.workJob= SerRec1;
        intkobj.workJob.Failure_Date__c = system.today()+1;
        tsbtrbatccamp.getCampaignDetails();
        test.stopTest();
    }
    
    static testmethod void TestForPageSave(){
        
        CG_CL_IntakeUENoERP Pgsavemethod = new CG_CL_IntakeUENoERP();
        css_job_order__c Jobwo12 = new css_job_order__C();
        Jobwo12.ESN_IA__c ='Testing';
        insert Jobwo12;
        
        //Passing Job to Mainctrl 
        //
        CG_CL_IntakeUE JobwoUE12 = new CG_CL_IntakeUE();
        JobwoUE12.workJob = Jobwo12;
        JobwoUE12.filterUnitType='Auto';
        JobwoUE12.filterSubType='Automative';
        JobwoUE12.filterApplication='App';
        map<string,string> map1 = new map<string,string>();
        map1.put('App','App');
        JobwoUE12.mapDescriptionToCode=map1;
        Pgsavemethod.mainContr= JobwoUE12;
        pgsavemethod.HHSPACCSFlg=false;
        pgsavemethod.HHSPSMNFlg=true;
        
        user u = [select id,name from user limit 1];
        system.runAs(u)
        {
            Account acc = new Account();
            acc.name='Rtest';
            acc.CSS_DistributorCode__c='56270';
            acc.IAM_Service_Provider_Code__c='56270';
            acc.Type='Dealer Account';
            //acc.Region__c = 'US and Canada';
            acc.CMI_Account_Status__c = 'Active';
            //acc.IAM_Service_Provider_Code__c = '562551';
            acc.RecordTypeId=recordType_Id;
           
            insert acc;
            
            CSS_UserLocation__c userLocation = new CSS_UserLocation__c(AccountId__c=acc.id,isActive__c=true,isPrimary__c=true,UserId__c=u.Id,Location_code__c='56270-56270');
            insert userLocation;
            test.startTest();
            pgsavemethod.pgSaveFinish();
            test.stopTest();
        }
    }
    
    static testmethod void TestForSetRequest(){
        
        CSS_Job_Order__c JO = CSS_TestData.createJobOrder(false) ;
        jo.ESN__c = '79464646';
        jo.Unit_Number__c ='12345';
        jo.Make__c = 'test';
        jo.Service_Model__c = null;
        jo.VIN__c = '';
        jo.Warranty_Start_Date__c = null;
        jo.Location_Certification__c = 'NotCert';
        jo.ESN_IA__c = '5678909078';
        jo.Failure_Date__c = system.today();
        jo.Before_In_Service__c = false;
        jo.Warranty_Start_Date__c = system.today()+10;
        insert jo;
        
        account acc = new account();
            acc.Name = 'test';
            acc.Type = 'Customer';
            acc.CSS_DistributorCode__c = '25270';
            acc.CMI_Account_Status__c = 'Active';
            acc.IAM_Service_Provider_Code__c = '25720';
            insert acc;
        contact c=new contact();
        c.AccountId=acc.id;
        c.FirstName='Test2';
        c.LastName='test1';
        insert c;

        List<Asset> lstAsset = new List<Asset>();
        Asset ass = new Asset();
        ass.Name='test';
        ass.AccountId=acc.id;
        ass.ContactId=c.id;
        ass.SerialNumber = JO.ESN__c;
        ass.Type__c='Engines';
        insert ass;
        lstAsset.add(ass);
        CG_CL_IntakeUENoERP IntakeJob1 = new CG_CL_IntakeUENoERP();
        CG_CL_IntakeVH invh = new CG_CL_IntakeVH();
        CG_CL_IntakeRJ inrj = new CG_CL_IntakeRJ();
        IntakeJob1.mainContrVH = invh;
        IntakeJob1.mainContrRJ = inrj;
        
        CSS_JobEventTemporary__c CJ = new CSS_JobEventTemporary__c(name='ApplicationCodes',Attribute1__c='ApplicationCodes',Reason__c ='{"DataArea": {"Details": [{"ApplicationCode": "123","Description": "abc","BusinessUnit": "EBU","AutomotiveFlag": "Y","MarineFlag": "","ActiveFlag": "N","DefaultUom": "miles"},{"ApplicationCode": "555","Description": "zxcv","BusinessUnit": "PSBU","AutomotiveFlag": "","MarineFlag": "N","ActiveFlag": "Y","DefaultUom": "miles"}]},"Header": {"ReturnCodeDescription": "","Status": "Success"}}');
        insert CJ;
        
        CG_CL_IntakeUE cciue = new CG_CL_IntakeUE();
        cciue.Wid = ApexPages.currentPage().getParameters().put('id',JO.id);
        cciue.filterMake = 'ACE';
        cciue.filterModel='Test';
        cciue.workjob = jo;
        map<string,string> mapacc = new map<string,string>();
        cciue.mapDescriptionToCode=mapacc;
        IntakeJob1.HHSPSMNFlg = true;
        IntakeJob1.HHSPACCSFlg = false;
        IntakeJob1.mainContr = cciue;
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new CSS_getEngineDataFrmSiebel1_Test());
        Test.setMock(WebServiceMock.class, new CSS_GetEngineDataPlate_Test());
        IntakeJob1.mainContr.workJob.SP_WarrantyCertificationEndDate__c = 'Y';
        IntakeJob1.startRequest();
        IntakeJob1.getApplication();
        Test.stopTest();
    }
    
    static testmethod void TestForGetApplication(){
        
        CG_CL_IntakeUENoERP getApplicationtest = new CG_CL_IntakeUENoERP();
        CG_CL_IntakeUE MainIntakeUE = NEW CG_CL_IntakeUE();
        map<string,string> mapacc = new map<string,string>();
        MainIntakeUE.mapDescriptionToCode = mapacc;
        getApplicationtest.mainContr=MainIntakeUE;
        
        user u = [select id ,name from user limit 1];
        system.runAs(u)
        {
            CSS_JobEventTemporary__c CJ = new CSS_JobEventTemporary__c(name='ApplicationCodes',Attribute1__c='ApplicationCodes',Reason__c ='{"DataArea": {"Details": [{"ApplicationCode": "123","Description": "abc","BusinessUnit": "EBU","AutomotiveFlag": "Y","MarineFlag": "","ActiveFlag": "N","DefaultUom": "miles"},{"ApplicationCode": "555","Description": "zxcv","BusinessUnit": "PSBU","AutomotiveFlag": "","MarineFlag": "N","ActiveFlag": "Y","DefaultUom": "miles"}]},"Header": {"ReturnCodeDescription": "","Status": "Success"}}');
            insert CJ;
            //new CSS_getEngineDataFrmSiebel_Test(map<'Success',>);
            Test.setMock(HttpCalloutMock.class, new CSS_getEngineDataFrmSiebel_Test());
            Test.setMock(WebServiceMock.class, new CSS_GetEngineDataPlate_Test());
            list<selectoption> op = getApplicationtest.getApplication();
            system.assert(op!=null);
        }
    }
    
    static testmethod void TestForTsb(){
        
        CG_CL_IntakeUENoERP Tsb = new CG_CL_IntakeUENoERP();
        
        css_job_order__c Jobwo13 = new css_job_order__C();
        Jobwo13.ESN__c='79850897';
        Jobwo13.Make__c = 'test';
        Jobwo13.ApplicationCode__c = '123';
        Jobwo13.Warranty_Start_Date__c = null;
        Jobwo13.ESN__c ='79464646';
        Jobwo13.VIN__c = null;
        Jobwo13.VIN_Flag__c = true;
        insert Jobwo13;
        
        account acc = new account();
            acc.Name = 'test';
            acc.Type = 'Customer';
            acc.CSS_DistributorCode__c = '25270';
            acc.CMI_Account_Status__c = 'Active';
            acc.IAM_Service_Provider_Code__c = '25720';
            insert acc;
        contact c=new contact();
        c.AccountId=acc.id;
        c.FirstName='Test2';
        c.LastName='test1';
        insert c;

        List<Asset> lstAsset = new List<Asset>();
        Asset ass = new Asset();
        ass.Name='test';
        ass.AccountId=acc.id;
        ass.ContactId=c.id;
        ass.SerialNumber = Jobwo13.ESN__c;
        ass.Type__c='Engines';
        insert ass;
        lstAsset.add(ass);
        //Adding Instance variable here
        CG_CL_IntakeUE maincrl = new CG_CL_IntakeUE();
        maincrl.workJob=Jobwo13;
        maincrl.workJob.ESN__c = '79464646';
        maincrl.workJob.VIN__c = null;
        maincrl.Wid=Jobwo13.id;
        Tsb.mainContr = maincrl;
        Tsb.Wid = Jobwo13.ID;
        
        //Inserting TSB record here,
        CSS_CampTsbTrp__c ctt3 = new CSS_CampTsbTrp__c();
        ctt3.Type__c = 'TSB';
        ctt3.URL__c = 'https://qs-stg.cummins.com/qs3/pubsys2/xml/en/atc/19TC/TSB1623.html';
        ctt3.Doc_Num__c = 'TF0051000';
        ctt3.Doc_Title__c = 'DUAL FUEL DATAPLATE TSB';
        ctt3.Performed__c = false;
        ctt3.Performed_Review__c = true;
        ctt3.Reviewed__c = false;
        ctt3.Job_Order__c = maincrl.Wid;
        //ctt3.ESN__c = Jobwo13.ESN__c;
        insert ctt3;
        
        list<CSS_CampTsbTrp__c> TestingQSOLDocs = [select Type__c,URL__c,Doc_Num__c,Doc_Title__c, Performed__c,Performed_Review__c,Reviewed__c from CSS_CampTsbTrp__c where Job_Order__c= :Tsb.Wid AND Type__c ='TSB' ];
        Tsb.lstQSOLDocs = TestingQSOLDocs;
        system.assert(Tsb.lstQSOLDocs!=null);
        test.startTest();
        Tsb.getTsbs();
        
        
        CSS_Job_Order__c SerRec1 = new CSS_Job_Order__c();
        SerRec1.Failure_Date__c = system.today()+1;
        SerRec1.Before_In_Service__c = false;
        SerRec1.Warranty_Start_Date__c = system.today()+10;
        insert SerRec1;
        CG_CL_IntakeUE intkobj = new CG_CL_IntakeUE();
        intkobj.workJob= SerRec1;
        intkobj.workJob.Failure_Date__c = system.today()+1;
        intkobj.workJob.Service_Model__c = null;
        intkobj.filterApplication =null;
        
        Tsb.siebelWarrantyDate = null;
        Tsb.getCampaignDetails();
        Tsb.mainContr.workJob.SP_WarrantyCertificationEndDate__c = 'Y';
        Tsb.startRequest();
        test.stopTest();
    }
    static testmethod void TestForTsb12(){
        
        CG_CL_IntakeUENoERP Tsb = new CG_CL_IntakeUENoERP();
        
        css_job_order__c Jobwo13 = new css_job_order__C();
        Jobwo13.ESN__c='79850897';
        Jobwo13.Make__c = 'test';
        Jobwo13.ApplicationCode__c = '123';
        Jobwo13.Warranty_Start_Date__c = null;
        Jobwo13.ESN__c ='79464646';
        Jobwo13.VIN__c = null;
        Jobwo13.VIN_Flag__c = true;
        insert Jobwo13;
        
        //Adding Instance variable here
        CG_CL_IntakeUE maincrl = new CG_CL_IntakeUE();
        maincrl.workJob=Jobwo13;
        maincrl.Wid=Jobwo13.id;
        maincrl.filterApplication='test1';
        Tsb.mainContr = maincrl;
        Tsb.Wid = Jobwo13.ID;
        
        //Inserting TSB record here,
        CSS_CampTsbTrp__c ctt3 = new CSS_CampTsbTrp__c();
        ctt3.Type__c = 'TSB';
        ctt3.URL__c = 'https://qs-stg.cummins.com/qs3/pubsys2/xml/en/atc/19TC/TSB1623.html';
        ctt3.Doc_Num__c = 'TF0051000';
        ctt3.Doc_Title__c = 'DUAL FUEL DATAPLATE TSB';
        ctt3.Performed__c = false;
        ctt3.Performed_Review__c = true;
        ctt3.Reviewed__c = false;
        ctt3.Job_Order__c = maincrl.Wid;
        //ctt3.ESN__c = Jobwo13.ESN__c;
        insert ctt3;
        
        list<CSS_CampTsbTrp__c> TestingQSOLDocs = [select Type__c,URL__c,Doc_Num__c,Doc_Title__c, Performed__c,Performed_Review__c,Reviewed__c from CSS_CampTsbTrp__c where Job_Order__c= :Tsb.Wid AND Type__c ='TSB' ];
        Tsb.lstQSOLDocs = TestingQSOLDocs;
        system.assert(Tsb.lstQSOLDocs!=null);
        test.startTest();
        Tsb.getTsbs();
        
        
        CSS_Job_Order__c SerRec1 = new CSS_Job_Order__c();
        SerRec1.Failure_Date__c = system.today()+1;
        SerRec1.Before_In_Service__c = false;
        SerRec1.Warranty_Start_Date__c = system.today()+10;
        insert SerRec1;
        CG_CL_IntakeUE intkobj = new CG_CL_IntakeUE();
        intkobj.workJob= SerRec1;
        intkobj.workJob.Failure_Date__c = date.today()+1;
        intkobj.filterApplication ='test123';
        Tsb.getCampaignDetails();
        Tsb.mainContr.workJob.SP_WarrantyCertificationEndDate__c = 'Y';
        Tsb.startRequest();
        test.stopTest();
    }
    
    static testmethod void compareDates1(){
        
        Test.startTest();
        CG_CL_IntakeUE IntakeUE3= new CG_CL_IntakeUE();
        
        CSS_JOB_ORDER__C jobwo2 = new CSS_JOB_ORDER__c();
        jobwo2.ESN__c='79548867';
        jobwo2.Customer_Name__c='';
        jobwo2.Customer_Code__c='123';
        jobwo2.Unit_Number__c='1232';
        jobwo2.Warranty_Start_Date__c=system.today();
        insert jobwo2;
        
        css_job_order__c Job3 = [select id,name,ESN__c,Before_In_Service__c,Customer_Name__c,Warranty_Start_Date__c,Customer_Code__c,Unit_Number__c,Creator_Location__c from css_job_order__C limit 1];
        IntakeUE3.workJob = Job3;
        
        CG_CL_IntakeUENoERP b = new CG_CL_IntakeUENoERP();
        b.mainContr= IntakeUE3;
        b.builddateErrFlag=true;
        b.warrantyDate = Date.Today()+1;
        b.billdateVal = Date.Today()+2;
        b.higherdateErrFlag=true;
        b.recconFlag = true;
        b.ESN='10000000';
        b.CompareDates();
        Test.stopTest();
    }
    
    static testmethod void compareDates2(){
        
        Test.startTest();
        
        CG_CL_IntakeUE IntakeUE3= new CG_CL_IntakeUE();
        
        CSS_JOB_ORDER__C jobwo2 = new CSS_JOB_ORDER__c();
        jobwo2.ESN__c='79548867';
        jobwo2.Customer_Name__c='';
        jobwo2.Customer_Code__c='123';
        jobwo2.Unit_Number__c='1232';
        jobwo2.Warranty_Start_Date__c=system.today();
        insert jobwo2;
        
        css_job_order__c Job3 = [select id,name,ESN__c,Before_In_Service__c,Customer_Name__c,Warranty_Start_Date__c,Customer_Code__c,Unit_Number__c,Creator_Location__c from css_job_order__C limit 1];
        IntakeUE3.workJob = Job3;
        
        CG_CL_IntakeUENoERP b = new CG_CL_IntakeUENoERP();
        b.mainContr= IntakeUE3;
        b.builddateErrFlag=true;
        b.warrantyDate = Date.Today()-1;
        b.billdateVal = Date.Today()+2;
        b.higherdateErrFlag=true;
        b.ESN='10000123';
        b.CompareDates();
        Test.stopTest();
    }
    
    static testmethod void compareDates3(){
        
        Test.startTest();
        
        CG_CL_IntakeUE IntakeUE3= new CG_CL_IntakeUE();
        //IntakeUE3.filterMake = 'Filter';
        // IntakeUE3.filterModel = 'Model';
        // insert IntakeUE3;
        
        CSS_JOB_ORDER__C jobwo2 = new CSS_JOB_ORDER__c();
        jobwo2.ESN__c='79548867';
        jobwo2.Customer_Name__c='';
        jobwo2.Customer_Code__c='123';
        jobwo2.Unit_Number__c='1232';
        jobwo2.Warranty_Start_Date__c=null;
        insert jobwo2;
        
        css_job_order__c Job3 = [select id,name,ESN__c,Before_In_Service__c,Customer_Name__c,Warranty_Start_Date__c,Customer_Code__c,Unit_Number__c,Creator_Location__c from css_job_order__C limit 1];
        IntakeUE3.workJob = Job3;
        
        CG_CL_IntakeUENoERP b = new CG_CL_IntakeUENoERP();
        b.mainContr= IntakeUE3;
        // b.mainContr.filterMake='automotive';
        b.CompareDates();
        Test.stopTest();
    }
    
    static testmethod void TestForonChangeBIS(){
        
        Test.startTest();    
        CG_CL_IntakeUE IntakeUE3= new CG_CL_IntakeUE(); 
        IntakeUE3.workJob.ESN__c = null;
        
        CSS_JOB_ORDER__C jobwo2 = new CSS_JOB_ORDER__c();
        jobwo2.Service_Model__c = null;
        jobwo2.VIN__c = null;
        jobwo2.VIN_Flag__c = true;
        jobwo2.Customer_Name__c='';
        jobwo2.Customer_Code__c='123';
        jobwo2.Unit_Number__c='1232';
        jobwo2.Warranty_Start_Date__c = null;
        jobwo2.Location_Certification__c = 'NotCert';
        jobwo2.jobLocation__c = 'abc';
        jobwo2.Before_In_Service__c = true;
        insert jobwo2;
        
        css_job_order__c Job3 = [select id,name,Before_In_Service__c,Customer_Name__c,Warranty_Start_Date__c,Customer_Code__c,Unit_Number__c,Creator_Location__c from css_job_order__C limit 1];
        IntakeUE3.workJob = Job3;
        
        
        CG_CL_IntakeUENoERP UE= new CG_CL_IntakeUENoERP();
        UE.mainContr = IntakeUE3;
        UE.mainContr.filterApplication = 'null';
        UE.failuredthidden = '';
        UE.onChangeBIS();
        UE.mainContr.workJob.SP_WarrantyCertificationEndDate__c = 'Y';
        UE.startRequest();
        Test.stopTest();
    }
    
    static testmethod void TestForOnChangeBISFalse(){
        
        Test.startTest();    
        CG_CL_IntakeUE IntakeUE3= new CG_CL_IntakeUE(); 
        
        CSS_JOB_ORDER__C jobwo2 = new CSS_JOB_ORDER__c();
        jobwo2.ESN__c='79548867';
        jobwo2.Customer_Name__c='';
        jobwo2.Customer_Code__c='123';
        jobwo2.Unit_Number__c='1232';
        jobwo2.Warranty_Start_Date__c = null;
        jobwo2.Location_Certification__c = 'abc';
        jobwo2.jobLocation__c = 'abc';
        jobwo2.Before_In_Service__c = false;
        insert jobwo2;
        
        css_job_order__c Job3 = [select id,name,ESN__c,Before_In_Service__c,Customer_Name__c,Warranty_Start_Date__c,Customer_Code__c,Unit_Number__c,Creator_Location__c from css_job_order__C limit 1];
        IntakeUE3.workJob = Job3;
        
        
        CG_CL_IntakeUENoERP UE= new CG_CL_IntakeUENoERP();
        UE.mainContr = IntakeUE3;
        UE.onChangeBIS();
        Test.stopTest();
    }
    
    public static Testmethod void TestforCampaignDetails(){
        
        Test.setMock(HttpCalloutMock.class, new CSS_getEngineDataFrmSiebel_Test());
        Test.setMock(WebServiceMock.class, new CSS_GetEngineDataPlate_Test());
        Test.setMock(HttpCalloutMock.class, new CG_CampaignMock_Test());
        
        CG_CL_IntakeUENoERP IntakeUEN = new CG_CL_IntakeUENoERP();
        Id SJid;
        
        CG_CL_IntakeUE IUE = new CG_CL_IntakeUE();
        
        CSS_Job_Order__c SerRec = CSS_TestData.createJobOrder(false);
        SerRec.ESN__c = '79464646';
        SerRec.Unit_Number__c ='12345';
        SerRec.Service_Model__c = 'XDFF34';
        SerRec.VIN__c = 'Tuuiio';
        SerRec.Location_Certification__c = 'Bangalore';
        SerRec.ESN_IA__c = '5678909078';
        serrec.Qsol_Engine_Family_Code__c='Test';
        serrec.failure_Date__c = date.today();
        serrec.Warranty_Start_Date__c=date.today()+12;
        insert SerRec;
        
        account acc = new account();
            acc.Name = 'test';
            acc.Type = 'Customer';
            acc.CSS_DistributorCode__c = '25270';
            acc.CMI_Account_Status__c = 'Active';
            acc.IAM_Service_Provider_Code__c = '25720';
            insert acc;
        contact c=new contact();
        c.AccountId=acc.id;
        c.FirstName='Test2';
        c.LastName='test1';
        insert c;

        List<Asset> lstAsset = new List<Asset>();
        Asset ass = new Asset();
        ass.Name='test';
        ass.AccountId=acc.id;
        ass.ContactId=c.id;
        ass.SerialNumber = serrec.ESN__c;
        ass.Type__c='Engines';
        insert ass;
        lstAsset.add(ass);        
        SerRec=[Select Id,Name,IsAppointment__c, bmsCreateAccount__c,CSS_Bms_ContactBoolean__c,Email_Address__c,Email_check_box__c,BMSStatus__c,Contact_ID__c,Customer_Name__c,Customer_Code__c,Phone_Number__c,Contact_Name__c,Cstmr_Contacts_Phone__c,Address__c,City__c,ZipCode__c,Country__c,CSS_Charge_Account_Status__c,Shop_Work_Order__c,Application__c, Unit_Number__c, Status__c, css_resolution__c,CSS_Feedback_Comments__c, Previous_Status__c,previousESN_MultiLoc__c,date_in__c,Date_in_Shop__c,
                ESN__c, ESN_IA__c, First_Name__c,BMS_Last_Name__c, Mileage__c,CSS_Hours__c, Mileage_Measure__c, chevron_page__c, General_Symptoms__c, LastModifiedDate,CreatedDate, Location_Certification__c,CSS_State__c,Primary_Segment__c,Before_In_Service__c,ESN_Locked__c, 
                Make__c,Model__c,AccessCode__c,Failure_Date__c,Failure_Point__c,Failure_Point_Measure__c,Service_Model__c,VIN__c,VIN_Flag__c,Warranty_Start_Date__c,Region__c,Creator_Location__c,EditCoverage__c,Unit_Type__c, Sub_Type__c,Account__r.ERP_System__c,SP_AccountStatus__c,SP_BusinessUnit__c,SP_CampaignTRP__c,SP_CMISPExpirationDate__c,
                Repeat_Visit__c,TSR_EscalateNumber__c,Automotive_App_Flag__c,RecentVisit__c,Repeat_Or_Recent_Calc__c,JobLocation__c,CSS_Job_Location_Code__c,CreatedById,Qsol_Engine_Family_Code__c,Repair_Location__c,Territory__c,Warranty_Authorization_Flag__c,PSN_Not_Available__c,Sub_Status__c,LastUpdateSubStatus__c,Actual_Technician_Time__c,SP_CommunicationMethod__c,SP_CommunicationOccurrence__c,SP_CostEffectiveExclusion__c,SP_CutOffClaimAmt__c,SP_DisableWebAccessFlag__c,SP_DistributorHQCode__c,SP_DistributorHQName__c,SP_DSID__c,SP_DTNAFlag__c,SP_FreezeSubmitButton__c,SP_GroupName__c,SP_LTAFlag__c,SP_MaxClaimAmt__c,SP_NewOEM__c,SP_OutfileAllClaims__c,SP_PACCAR__c,SP_PMUSplitPayment__c,SP_Policy__c,SP_PrimaryOEMCode__c,SP_PrimaryOEMName__c,SP_ProductCertification__c,SP_PromotionId__c,SP_PSBUProductCertification__c,SP_Region__c,SP_RepairLevel__c,SP_SCMDeductiblePercentage__c,SP_SCMDollarAmt__c,SP_State__c,SP_TechActualHoursRequired__c,SP_ViewDollarAmount__c,SP_WarrantyCertificationEndDate__c,SP_WarrantyEmail__c,SP_WarrantyFax__c,SP_WarrantyTrainingCertification__c,SP_WarrantyTrainingStatus__c,SP_WWSPSSPFlag__c,
                CSS_Channel_Code__c, CSS_Channel_Of_Distribution__c, CSS_Travel_Rate__c, CSS_In_Shop_Labor_Rate__c, CSS_Field_Service_Labor_Rate__c, Territory_Class__c, Territory_Class_Name__c, 
                BillToCode__c,BuildDate__c,ProductApplicationCode__c,DesignPhaseCode__c,EngineFamilyCode__c,ShipDate__c, ETOOldESN__c, EngineFamilyName__c,EtoConversionDate__c,MarineFlag__c,OemCode__c,
                ProductApplicationDesp__c,warrantyIndicatorFlag__c,SP_ClaimAllowedDays__c,SP_Country__c,CSS_Mission_Disabling__c,ReconEngineFlag__c,ProductAppcodeErrorflag__c,
                (Select Id,Body,title,CreatedBy.firstname,CreatedBy.lastname,CreatedDate from Notes Order By CreatedDate DESC),Category__c,Category2__c,Category3__c,Category4__c,Category5__c,Complaint_Type__c,Complaint_Type2__c,Complaint_Type3__c,Complaint_Type4__c,Complaint_Type5__c, Preventive_Maintenance__c,Expedited_Service__c, Category_Desc__c, Category2_Desc__c, Category3_Desc__c, Category4_Desc__c, Category5_Desc__c, Complaint_Type_Desc__c, Complaint_Type2_Desc__c, Complaint_Type3_Desc__c, Complaint_Type4_Desc__c, Complaint_Type5_Desc__c, Application_Desc__c,ApplicationCode__c,
                (Select Id,Name, Case_Name__c, Service_Job__c,Repair_response__c,Solution_Title__c ,Solution__c,Diagnostic_Response__c FROM CSS_Solutions__r),
                (Select id, name , performed__c, performed_review__c, Reviewed__c from CSS_CampTsbTrp__r where( job_order__C=:SerRec.Id and( performed_review__c=True and performed__c=False))),
                (select Id,name,OrderReference__c from css_quotes__r)
                from CSS_Job_Order__c where id=:SerRec.Id];
        
        Profile p = [SELECT Id FROM Profile WHERE Name='CSS_Service_Advanced']; 
        User usr = new User(Alias = 'standt', Email='standarduser4@testorg.com', 
                            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                            LocaleSidKey='en_US',  ProfileId = p.Id, 
                            TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTestUser14@testorg.com',User_Location__c = '56270-56270');
        insert usr;
        
        system.debug('usr**'+usr);
        
        CSS_accountLanguage__c accLan = new CSS_accountLanguage__c();
        accLan.CSS_QsolLanguage__c = 'en';
        accLan.Name = 'en_US';
        insert accLan;
        IUE.filterMake = 'ACE';
        IUE.filterModel = 'QSB-44-T2';
        
        IntakeUEN.mainContr = IUE;
        
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
        conDetails.Name = 'GetCampaign';
        conDetails.AuthEnv__c = 'OAGOAUTH';
        conDetails.ApplicationName__c = 'GetCampaign';
        conDetails.End_Point__c = 'Test';
        conDetails.Method_Type__c = 'POST';
        conDetails.Timeout__c = 2.0;
        insert conDetails;
        
        CG_CL_IntakeUE mainContr = new CG_CL_IntakeUE();
        SerRec.Id = SJid;
        mainContr.workJob = SerRec;
        
        IntakeUEN.mainContr = mainContr;
        
        test.startTest();
        
        Test.setMock(HttpCalloutMock.class, new CSS_getEngineDataFrmSiebel_Test());
        IntakeUEN.mainContr.workJob.SP_WarrantyCertificationEndDate__c = 'Y';
        IntakeUEN.startRequest();
        // IntakeUEN.getCampaignDetails();
        
        CSS_Job_Order__c SerRec1 = new CSS_Job_Order__c();
        SerRec1.Failure_Date__c = system.today();
        SerRec1.Before_In_Service__c = false;
        SerRec1.Warranty_Start_Date__c = system.today()+10;
        insert SerRec1;
        CG_CL_IntakeUE intkobj = new CG_CL_IntakeUE();
        intkobj.workJob= SerRec1;
        CSS_JobEventTemporary__c obj = new CSS_JobEventTemporary__c();
        obj.Key__c = 'MarketingApplicationCodes';
        obj.Attribute1__c= 'BB';
        obj.Attribute3__c = 'AUTOMOTIVE';  
        insert obj;
        
        IntakeUEN.updateproductappcode();
        
        test.stoptest();
        
    }
    public static Testmethod void TestforCampaignDetails1(){
        
        //Test.setMock(HttpCalloutMock.class, new CSS_getEngineDataFrmSiebel_Test());
        // Test.setMock(WebServiceMock.class, new CSS_GetEngineDataPlate_Test());
        // Test.setMock(HttpCalloutMock.class, new CG_CampaignMock_Test());
        
        CG_CL_IntakeUENoERP IntakeUEN = new CG_CL_IntakeUENoERP();
        Id SJid;
        
        CG_CL_IntakeUE IUE = new CG_CL_IntakeUE();
        
        CSS_Job_Order__c SerRec = CSS_TestData.createJobOrder(false);
        SerRec.ESN__c = '79464646';
        SerRec.Unit_Number__c ='12345';
        SerRec.Service_Model__c = 'XDFF34';
        SerRec.VIN__c = 'Tuuiio';
        SerRec.Location_Certification__c = 'Bangalore';
        SerRec.ESN_IA__c = '5678909078';
        serrec.Qsol_Engine_Family_Code__c='Test';
        serrec.failure_Date__c = date.today();
        serrec.Warranty_Start_Date__c=date.today()+12;
        insert SerRec;
        
        account acc = new account();
            acc.Name = 'test';
            acc.Type = 'Customer';
            acc.CSS_DistributorCode__c = '25270';
            acc.CMI_Account_Status__c = 'Active';
            acc.IAM_Service_Provider_Code__c = '25720';
            insert acc;
        contact c=new contact();
        c.AccountId=acc.id;
        c.FirstName='Test2';
        c.LastName='test1';
        insert c;

        List<Asset> lstAsset = new List<Asset>();
        Asset ass = new Asset();
        ass.Name='test';
        ass.AccountId=acc.id;
        ass.ContactId=c.id;
        ass.SerialNumber = serrec.ESN__c;
        ass.Type__c='Engines';
        insert ass;
        lstAsset.add(ass);
        
        SerRec=[Select Id,Name,IsAppointment__c, bmsCreateAccount__c,CSS_Bms_ContactBoolean__c,Email_Address__c,Email_check_box__c,BMSStatus__c,Contact_ID__c,Customer_Name__c,Customer_Code__c,Phone_Number__c,Contact_Name__c,Cstmr_Contacts_Phone__c,Address__c,City__c,ZipCode__c,Country__c,CSS_Charge_Account_Status__c,Shop_Work_Order__c,Application__c, Unit_Number__c, Status__c, css_resolution__c,CSS_Feedback_Comments__c, Previous_Status__c,previousESN_MultiLoc__c,date_in__c,Date_in_Shop__c,
                ESN__c, ESN_IA__c, First_Name__c,BMS_Last_Name__c, Mileage__c,CSS_Hours__c, Mileage_Measure__c, chevron_page__c, General_Symptoms__c, LastModifiedDate,CreatedDate, Location_Certification__c,CSS_State__c,Primary_Segment__c,Before_In_Service__c,ESN_Locked__c, 
                Make__c,Model__c,AccessCode__c,Failure_Date__c,Failure_Point__c,Failure_Point_Measure__c,Service_Model__c,VIN__c,VIN_Flag__c,Warranty_Start_Date__c,Region__c,Creator_Location__c,EditCoverage__c,Unit_Type__c, Sub_Type__c,Account__r.ERP_System__c,SP_AccountStatus__c,SP_BusinessUnit__c,SP_CampaignTRP__c,SP_CMISPExpirationDate__c,
                Repeat_Visit__c,TSR_EscalateNumber__c,Automotive_App_Flag__c,RecentVisit__c,Repeat_Or_Recent_Calc__c,JobLocation__c,CSS_Job_Location_Code__c,CreatedById,Qsol_Engine_Family_Code__c,Repair_Location__c,Territory__c,Warranty_Authorization_Flag__c,PSN_Not_Available__c,Sub_Status__c,LastUpdateSubStatus__c,Actual_Technician_Time__c,SP_CommunicationMethod__c,SP_CommunicationOccurrence__c,SP_CostEffectiveExclusion__c,SP_CutOffClaimAmt__c,SP_DisableWebAccessFlag__c,SP_DistributorHQCode__c,SP_DistributorHQName__c,SP_DSID__c,SP_DTNAFlag__c,SP_FreezeSubmitButton__c,SP_GroupName__c,SP_LTAFlag__c,SP_MaxClaimAmt__c,SP_NewOEM__c,SP_OutfileAllClaims__c,SP_PACCAR__c,SP_PMUSplitPayment__c,SP_Policy__c,SP_PrimaryOEMCode__c,SP_PrimaryOEMName__c,SP_ProductCertification__c,SP_PromotionId__c,SP_PSBUProductCertification__c,SP_Region__c,SP_RepairLevel__c,SP_SCMDeductiblePercentage__c,SP_SCMDollarAmt__c,SP_State__c,SP_TechActualHoursRequired__c,SP_ViewDollarAmount__c,SP_WarrantyCertificationEndDate__c,SP_WarrantyEmail__c,SP_WarrantyFax__c,SP_WarrantyTrainingCertification__c,SP_WarrantyTrainingStatus__c,SP_WWSPSSPFlag__c,
                CSS_Channel_Code__c, CSS_Channel_Of_Distribution__c, CSS_Travel_Rate__c, CSS_In_Shop_Labor_Rate__c, CSS_Field_Service_Labor_Rate__c, Territory_Class__c, Territory_Class_Name__c, 
                BillToCode__c,BuildDate__c,ProductApplicationCode__c,DesignPhaseCode__c,EngineFamilyCode__c,ShipDate__c, ETOOldESN__c, EngineFamilyName__c,EtoConversionDate__c,MarineFlag__c,OemCode__c,
                ProductApplicationDesp__c,warrantyIndicatorFlag__c,SP_ClaimAllowedDays__c,SP_Country__c,CSS_Mission_Disabling__c,ReconEngineFlag__c,ProductAppcodeErrorflag__c,
                (Select Id,Body,title,CreatedBy.firstname,CreatedBy.lastname,CreatedDate from Notes Order By CreatedDate DESC),Category__c,Category2__c,Category3__c,Category4__c,Category5__c,Complaint_Type__c,Complaint_Type2__c,Complaint_Type3__c,Complaint_Type4__c,Complaint_Type5__c, Preventive_Maintenance__c,Expedited_Service__c, Category_Desc__c, Category2_Desc__c, Category3_Desc__c, Category4_Desc__c, Category5_Desc__c, Complaint_Type_Desc__c, Complaint_Type2_Desc__c, Complaint_Type3_Desc__c, Complaint_Type4_Desc__c, Complaint_Type5_Desc__c, Application_Desc__c,ApplicationCode__c,
                (Select Id,Name, Case_Name__c, Service_Job__c,Repair_response__c,Solution_Title__c ,Solution__c,Diagnostic_Response__c FROM CSS_Solutions__r),
                (Select id, name , performed__c, performed_review__c, Reviewed__c from CSS_CampTsbTrp__r where( job_order__C=:SerRec.Id and( performed_review__c=True and performed__c=False))),
                (select Id,name,OrderReference__c from css_quotes__r)
                from CSS_Job_Order__c where id=:SerRec.Id];
        
        Profile p = [SELECT Id FROM Profile WHERE Name='CSS_Service_Advanced']; 
        User usr = new User(Alias = 'standt', Email='standarduser4@testorg.com', 
                            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                            LocaleSidKey='en_US',  ProfileId = p.Id, 
                            TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTestUser14@testorg.com',User_Location__c = '56270-56270');
        insert usr;
        
        system.debug('usr**'+usr);
        
        CSS_accountLanguage__c accLan = new CSS_accountLanguage__c();
        accLan.CSS_QsolLanguage__c = 'en';
        accLan.Name = 'en_US';
        insert accLan;
        IUE.filterMake = 'ACE';
        IUE.filterModel = 'QSB-44-T2';
        
        IntakeUEN.mainContr = IUE;
        
        
        CG_CL_IntakeUE mainContr = new CG_CL_IntakeUE();
        SerRec.Id = SJid;
        mainContr.workJob = SerRec;
        
        IntakeUEN.mainContr = mainContr;
        
        test.startTest();
        
        // Test.setMock(HttpCalloutMock.class, new CSS_getEngineDataFrmSiebel_Test());
        IntakeUEN.mainContr.workJob.SP_WarrantyCertificationEndDate__c = 'Y';
        IntakeUEN.startRequest();
        // IntakeUEN.getCampaignDetails();
        
        CSS_Job_Order__c SerRec1 = new CSS_Job_Order__c();
        SerRec1.Failure_Date__c = system.today();
        SerRec1.Before_In_Service__c = false;
        SerRec1.Warranty_Start_Date__c = system.today()+10;
        insert SerRec1;
        CG_CL_IntakeUE intkobj = new CG_CL_IntakeUE();
        intkobj.workJob= SerRec1;
        CSS_JobEventTemporary__c obj = new CSS_JobEventTemporary__c();
        obj.Key__c = 'MarketingApplicationCodes';
        obj.Attribute1__c= 'BB';
        obj.Attribute3__c = 'AUTOMOTIVE';  
        insert obj;
        
        IntakeUEN.updateproductappcode();
        
        test.stoptest();
        
    }
    static testmethod void mainMethod1(){
        
        
        //CSS_Job_Order__c jo = CSS_TestData.createJobOrder(false) ;
        //jo.ESN__c = '79464646';
        CSS_Job_Order__c jo = new CSS_Job_Order__c();
        jo.Unit_Number__c ='12345';
        jo.ApplicationCode__c = '123';
        jo.ProductApplicationCode__c = '123';
        jo.Qsol_Engine_Family_Code__c = '123';
        jo.Service_Model__c = 'XDFF34';
        jo.VIN__c = '';
        jo.VIN_Flag__c = true;
        jo.Warranty_Start_Date__c = null;
        jo.Location_Certification__c = 'Bangalore';
        jo.ESN_IA__c = '5678909078';
        jo.Failure_Date__c = system.today();
        jo.Before_In_Service__c = false;
        jo.ProductAppcodeErrorflag__c = true;
        jo.Warranty_Start_Date__c = null;
        insert jo;
        
        CG_CL_IntakeUENoERP IntakeJob1 = new CG_CL_IntakeUENoERP();
        
        CG_CL_IntakeUE cciue = new CG_CL_IntakeUE();
        cciue.Wid = ApexPages.currentPage().getParameters().put('id',JO.id);
        cciue.filterMake = 'ACE';
        cciue.filterModel='Test';
        cciue.workjob = jo;
        IntakeJob1.mainContr = cciue;
        Test.startTest();
        IntakeJob1.mainContr.workJob.SP_WarrantyCertificationEndDate__c = 'Y';
        IntakeJob1.startRequest();
        // IntakeJob1.getApplication();
        Test.stopTest();
    }
    
    static testmethod void startrequest(){
        
        list<CSS_Integration_Details__c> recs= new list<CSS_Integration_Details__c>();
        
        CSS_Integration_Details__c condetails1 = new CSS_Integration_Details__c();
        condetails1.name='GetEngineDataPlateQSOLREST';
        condetails1.ApplicationName__c='QSOL Soft';
        condetails1.AuthEnv__c='QSOL Auth Token';
        condetails1.End_Point__c='https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/send/data';
        condetails1.grant_type__c='Refresh_full';
        condetails1.IsActive__c=true;
        condetails1.Key__c='7r7F6tyJlMmmC6JHSUMqK6dEUPvhL171LYrK6URZB3zKLO45503MD61NA8LTSTQCRvGn5Qroo3CkG7RRlFe9Bw==';
        condetails1.Logging__c='BOTH';
        condetails1.Method_Type__c='POST';
        condetails1.Passcode__c='7r7F6tyJlMmmC6JHSUMqK6dEUPvhL171LYrK6URZB3zKLO45503MD61NA8LTSTQCRvGn5Qroo3CkG7RRlFe9Bw==';
        condetails1.Timeout__c=120;
        condetails1.Username__c='wQPYUk3iFjCz7sofEcwrXu+voqsIza/dbcO3QlGuxTVNg/ly+0Sy1nWe59U01nRfRW/q9ogg4q6LfncwdAZmBg==';
        recs.add(condetails1);
        insert recs;  
        Test.setMock(HttpCalloutMock.class, new CSS_getEngineDataFrmSiebel_Test());
        Test.setMock(WebServiceMock.class, new CSS_GetEngineDataPlate_Test());
        Test.setMock(HttpCalloutMock.class, new CG_BLIntakeMock_Test());
        system.debug('Test**Kal1');
        
        CSS_Job_Order__c JO = new CSS_Job_Order__c();
        jo.ESN__c = '11111111';
        jo.Unit_Number__c ='12345';
        jo.Service_Model__c = 'XDFF34';
        jo.PSN_Not_Available__c=false;
        jo.VIN__c = 'Tuuiio';
        jo.Warranty_Start_Date__c = null;
        jo.Location_Certification__c = 'Bangalore';
        jo.ESN_IA__c = '5678909078';
        jo.ProductApplicationCode__c='test1';
        jo.ProductApplicationDesp__c='test2';
        insert jo;
        
       account acc = new account();
            acc.Name = 'test';
            acc.Type = 'Customer';
            acc.CSS_DistributorCode__c = '25270';
            acc.CMI_Account_Status__c = 'Active';
            acc.IAM_Service_Provider_Code__c = '25720';
            insert acc;
        contact c=new contact();
        c.AccountId=acc.id;
        c.FirstName='Test2';
        c.LastName='test1';
        insert c;

        List<Asset> lstAsset = new List<Asset>();
        Asset ass = new Asset();
        ass.Name='test';
        ass.AccountId=acc.id;
        ass.ContactId=c.id;
        ass.SerialNumber = jo.ESN__c;
        ass.Type__c='Engines';
        insert ass;
        lstAsset.add(ass);
        CG_CL_IntakeUENoERP IntakeJob2 = new CG_CL_IntakeUENoERP();
        CG_CL_IntakeVH invh = new CG_CL_IntakeVH();
        CG_CL_IntakeRJ inrj = new CG_CL_IntakeRJ();
        // IntakeJob1.mainContrVH = invh;
        //IntakeJob1.mainContrRJ = inrj;
        /* list<CSS_Integration_Details__c> recs= new list<CSS_Integration_Details__c>();

CSS_Integration_Details__c condetails1 = new CSS_Integration_Details__c();
condetails1.name='GetEngineDataPlateQSOLREST';
condetails1.ApplicationName__c='QSOL Soft';
condetails1.AuthEnv__c='QSOL Auth Token';
condetails1.End_Point__c='https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/send/data';
condetails1.grant_type__c='Refresh_full';
condetails1.IsActive__c=true;
condetails1.Key__c='7r7F6tyJlMmmC6JHSUMqK6dEUPvhL171LYrK6URZB3zKLO45503MD61NA8LTSTQCRvGn5Qroo3CkG7RRlFe9Bw==';
condetails1.Logging__c='BOTH';
condetails1.Method_Type__c='POST';
condetails1.Passcode__c='7r7F6tyJlMmmC6JHSUMqK6dEUPvhL171LYrK6URZB3zKLO45503MD61NA8LTSTQCRvGn5Qroo3CkG7RRlFe9Bw==';
condetails1.Timeout__c=120;
condetails1.Username__c='wQPYUk3iFjCz7sofEcwrXu+voqsIza/dbcO3QlGuxTVNg/ly+0Sy1nWe59U01nRfRW/q9ogg4q6LfncwdAZmBg==';
recs.add(condetails1);
insert recs; 
Test.setMock(HttpCalloutMock.class, new CSS_getEngineDataFrmSiebel_Test());
//Test.setMock(WebServiceMock.class, new CSS_GetEngineDataPlate_Test());
Test.setMock(HttpCalloutMock.class, new CG_BLIntakeMock_Test());*/
        
        CG_CL_IntakeUENoERP IntakeJob1 = new CG_CL_IntakeUENoERP();
        CG_CL_IntakeVH invh1 = new CG_CL_IntakeVH();
        CG_CL_IntakeRJ inrj1 = new CG_CL_IntakeRJ();
        IntakeJob1.mainContrVH = invh;
        IntakeJob1.mainContrRJ = inrj;
        
        CSS_JobEventTemporary__c CJ = new CSS_JobEventTemporary__c(name='ApplicationCodes',key__c='MarketingApplicationCodes',Attribute1__c='test12',Attribute3__c='test',Attribute5__c='select one',Reason__c ='{"DataArea": {"Details": [{"ApplicationCode": "123","Description": "abc","BusinessUnit": "EBU","AutomotiveFlag": "Y","MarineFlag": "","ActiveFlag": "N","DefaultUom": "miles"},{"ApplicationCode": "555","Description": "zxcv","BusinessUnit": "PSBU","AutomotiveFlag": "","MarineFlag": "N","ActiveFlag": "Y","DefaultUom": "miles"}]},"Header": {"ReturnCodeDescription": "","Status": "Success"}}');
        insert CJ;
        
        CG_CL_IntakeUE cciue = new CG_CL_IntakeUE();
        cciue.Wid = ApexPages.currentPage().getParameters().put('id',JO.id);
        cciue.filterMake = 'ACE';
        cciue.filterApplication='select one';
        cciue.workjob = JO;
        map<string,string> mapacc = new map<string,string>();
        cciue.mapDescriptionToCode=mapacc;
        IntakeJob1.HHSPSMNFlg = true;
        IntakeJob1.HHSPACCSFlg = false;
        IntakeJob1.mainContr = cciue;
        
        test.startTest();
        
        Test.setMock(HttpCalloutMock.class, new CG_WS_QSOLMock()); 
        IntakeJob1.warrantyDate = Date.Today()+1;
        system.debug('entering start Request');
        IntakeJob1.startRequest();
        
        cciue.filterApplication='test1234';
        
        list<CSS_JobEventTemporary__c> jobeventlst = new list<CSS_JobEventTemporary__c>();
        CSS_JobEventTemporary__c CJ1 = new CSS_JobEventTemporary__c(name='ApplicationCodes',key__c='MarketingApplicationCodes',Attribute1__c=jo.ProductApplicationCode__c,Attribute3__c=jo.ProductApplicationDesp__c);
        insert CJ1;
        jobeventlst.add(CJ1);
        
        cciue.filterApplication='testui';
        IntakeJob1.updateproductappcode();
        
        CSS_Job_Order__c SerRec = CSS_TestData.createJobOrder(false);
        SerRec.ESN__c = '11111111';
        SerRec.Unit_Number__c ='12345';
        SerRec.Service_Model__c = 'XDFF34';
        SerRec.VIN__c = 'Tuuiio';
        SerRec.Location_Certification__c = 'Bangalore';
        SerRec.ESN_IA__c = '5678909078';
        serrec.Qsol_Engine_Family_Code__c='Test';
        serrec.failure_Date__c = date.today()-20;
        serrec.Warranty_Start_Date__c=date.today()-12;
        serrec.ProductApplicationDesp__c=null;
        serrec.ProductApplicationCode__c=null;
        //serec.PSNFlag=true;
        serrec.Before_In_Service__c = false;
        insert SerRec;
        CSS_CampTsbTrp__c camp=new CSS_CampTsbTrp__c();
        camp.Job_Order__c=SerRec.id;
        camp.Type__c='TSB';
        insert camp;
        
        
        //IntakeUEB.updateproductappcode();
        CG_CL_IntakeUE mainContr = new CG_CL_IntakeUE();
        mainContr.filterApplication='test-1234';
        mainContr.workJob = SerRec; 
        mainContr.PSNFlag=true;
        
        List<SelectOption> accCodes = new List<SelectOption>();
        accCodes.add(new SelectOption('Test1','test-1234'));
        accCodes.add(new SelectOption('Test2','test-12345'));
        accCodes.add(new SelectOption('Test3','test-1234'));
        accCodes.add(new SelectOption('Test4','test-1234'));
        CSS_JobEventTemporary__c JETproductcode = new CSS_JobEventTemporary__c();
        CSS_JobEventTemporary__c JETproductcode1 = new CSS_JobEventTemporary__c();
        JETproductcode.Key__c = 'MarketingApplicationCodes' ;
        JETproductcode.Attribute1__c=null;
        JETproductcode.Attribute3__c=null;
        insert JETproductcode;
        IntakeJob1.updateproductappcode();
        IntakeJob1.getlicensePlateList();
        test.stopTest();
        
    }
    
    
    
    static testmethod void startrequest2(){
        
        CSS_Job_Order__c JO = new CSS_Job_Order__c();
        jo.ESN__c = '22222222';
        jo.Unit_Number__c ='12345';
        jo.Service_Model__c = 'XDFF34';
        jo.PSN_Not_Available__c=false;
        jo.VIN__c = 'Tuuiio';
        jo.Warranty_Start_Date__c = null;
        jo.Location_Certification__c = 'Bangalore';
        jo.ESN_IA__c = '5678909078';
        jo.ProductApplicationCode__c='test1';
        jo.ProductApplicationDesp__c='test2';
        insert jo;
        
        
        account acc = new account();
            acc.Name = 'test';
            acc.Type = 'Customer';
            acc.CSS_DistributorCode__c = '25270';
            acc.CMI_Account_Status__c = 'Active';
            acc.IAM_Service_Provider_Code__c = '25720';
            insert acc;
        contact c=new contact();
        c.AccountId=acc.id;
        c.FirstName='Test2';
        c.LastName='test1';
        insert c;

        List<Asset> lstAsset = new List<Asset>();
        Asset ass = new Asset();
        ass.Name='test';
        ass.AccountId=acc.id;
        ass.ContactId=c.id;
        ass.SerialNumber = jo.ESN__c;
        ass.Type__c='Engines';
        insert ass;
        lstAsset.add(ass);
        
        CG_CL_IntakeUENoERP IntakeJob1 = new CG_CL_IntakeUENoERP();
        CG_CL_IntakeVH invh = new CG_CL_IntakeVH();
        CG_CL_IntakeRJ inrj = new CG_CL_IntakeRJ();
        IntakeJob1.mainContrVH = invh;
        IntakeJob1.mainContrRJ = inrj;
        
        CSS_JobEventTemporary__c CJ = new CSS_JobEventTemporary__c(name='ApplicationCodes',key__c='MarketingApplicationCodes',Attribute1__c='test12',Attribute3__c='test',Attribute5__c='select one',Reason__c ='{"DataArea": {"Details": [{"ApplicationCode": "123","Description": "abc","BusinessUnit": "EBU","AutomotiveFlag": "Y","MarineFlag": "","ActiveFlag": "N","DefaultUom": "miles"},{"ApplicationCode": "555","Description": "zxcv","BusinessUnit": "PSBU","AutomotiveFlag": "","MarineFlag": "N","ActiveFlag": "Y","DefaultUom": "miles"}]},"Header": {"ReturnCodeDescription": "","Status": "Success"}}');
        insert CJ;
        
        CG_CL_IntakeUE cciue = new CG_CL_IntakeUE();
        cciue.Wid = ApexPages.currentPage().getParameters().put('id',JO.id);
        cciue.filterMake = 'ACE';
        cciue.filterApplication='select one';
        cciue.workjob = JO;
        map<string,string> mapacc = new map<string,string>();
        cciue.mapDescriptionToCode=mapacc;
        IntakeJob1.HHSPSMNFlg = true;
        IntakeJob1.HHSPACCSFlg = false;
        IntakeJob1.mainContr = cciue;
        
        test.startTest();
        IntakeJob1.warrantyDate = Date.Today()+1;
        system.debug('entering start Request');
        IntakeJob1.startRequest();
        
        cciue.filterApplication='test1234';
        
        list<CSS_JobEventTemporary__c> jobeventlst = new list<CSS_JobEventTemporary__c>();
        CSS_JobEventTemporary__c CJ1 = new CSS_JobEventTemporary__c(name='ApplicationCodes',key__c='MarketingApplicationCodes',Attribute1__c=jo.ProductApplicationCode__c,Attribute3__c=jo.ProductApplicationDesp__c);
        insert CJ1;
        jobeventlst.add(CJ1);
        
        cciue.filterApplication='testui';
        IntakeJob1.updateproductappcode();
        
        CSS_Job_Order__c SerRec = CSS_TestData.createJobOrder(false);
        SerRec.ESN__c = '22222222';
        SerRec.Unit_Number__c ='12345';
        SerRec.Service_Model__c = 'XDFF34';
        SerRec.VIN__c = 'Tuuiio';
        SerRec.Location_Certification__c = 'Bangalore';
        SerRec.ESN_IA__c = '5678909078';
        serrec.Qsol_Engine_Family_Code__c='Test';
        serrec.failure_Date__c = date.today()-20;
        serrec.Warranty_Start_Date__c=date.today()-12;
        serrec.Failure_Date__c=date.today()+12;
        serrec.ShipDate__c=date.today()+15;
        serrec.ProductApplicationDesp__c=null;
        serrec.ProductApplicationCode__c=null;
        //serec.PSNFlag=true;
        serrec.Before_In_Service__c = false;
        insert SerRec;
        
        CSS_CampTsbTrp__c camp=new CSS_CampTsbTrp__c();
        camp.Job_Order__c=SerRec.id;
        camp.Type__c='TSB';
        insert camp;
        
        
        //IntakeUEB.updateproductappcode();
        CG_CL_IntakeUE mainContr = new CG_CL_IntakeUE();
        mainContr.filterApplication='test-1234';
        mainContr.workJob = SerRec; 
        mainContr.PSNFlag=true;
        
        List<SelectOption> accCodes = new List<SelectOption>();
        accCodes.add(new SelectOption('Test1','test-1234'));
        accCodes.add(new SelectOption('Test2','test-12345'));
        accCodes.add(new SelectOption('Test3','test-1234'));
        accCodes.add(new SelectOption('Test4','test-1234'));
        CSS_JobEventTemporary__c JETproductcode = new CSS_JobEventTemporary__c();
        CSS_JobEventTemporary__c JETproductcode1 = new CSS_JobEventTemporary__c();
        JETproductcode.Key__c = 'MarketingApplicationCodes' ;
        JETproductcode.Attribute1__c=null;
        JETproductcode.Attribute3__c=null;
        insert JETproductcode;
        IntakeJob1.updateproductappcode();
        IntakeJob1.getlicensePlateList();
        IntakeJob1.getCampaignDetails();
        
        test.stopTest();
        
    } 
    
    
}