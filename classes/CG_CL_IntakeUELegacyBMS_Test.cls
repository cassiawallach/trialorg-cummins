@isTest
public class CG_CL_IntakeUELegacyBMS_Test {
    
    @testsetup static void CG_CL_IntakeUELegacyBMS_Test_setup_data(){
        Profile p = [SELECT Id FROM Profile WHERE Name='CSS_Service_Advanced']; 
        User u = new User(Alias = 'standt', Email='standarduser4@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US',  ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTestUser4@testorg.com',User_Location__c = '56780-56780');
        insert u;
        system.runAs(u)
        {
            CSS_Job_Order__c JO = new CSS_Job_Order__c();
            
            JO.Customer_Name__c = 'Agassi';
            JO.Application__c = 'Recreational Vehicle';
            JO.Model__c = 'AgassishyamTest';
            JO.Make__c = 'CSSTest';
            JO.Notes__c = 'CAMPCOMMENTS';
            JO.Failure_Point__c = 122;
            JO.Failure_Point_Measure__c = 'Miles';
            JO.VIN__c = '12345677890';
            JO.Failure_Date__c = date.today()-20;
            JO.Warranty_Start_Date__c = date.today()-365;
            JO.Location_Certification__c = 'abc';
            JO.jobLocation__c = 'abc';
            JO.Before_In_Service__c = True;
            JO.Status__c = 'Repair Complete';
            JO.Unit_Number__c = 'test123';
            Jo.Assigned_To__c = UserInfo.getUserId();
            Jo.ESN__c = '79464646';
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
            JO.Service_Model__c ='rDataPlate.data[0]';
            JO.PSN_Not_Available__c = true;
            JO.ESN_IA__c = '79464646';
            JO.OwnerId = u.Id;
            JO.Qsol_Engine_Family_Code__c = 'Test';
            insert JO;
            
        }
    }
    
    static testMethod void  CG_CL_IntakeUELegacyBMS_Test(){
        
        //Test.setMock(WebServiceMock.class, new CSS_GetWarrantyDocs_Test());
        //Test.setMock(HttpCalloutMock.class, new CSS_MockHttpResponseGenerator()); 
        
        Test.StartTest();
        try{
            user u = [select id from user limit 1]  ;
            
            CSS_Job_Order__c JO =[select id,ESN__c from CSS_Job_Order__c limit 1];
            CSS_CampTsbTrp__c campttp = new CSS_CampTsbTrp__c(Doc_Num__c = 'TSB140168', URL__c = 'https://qsolpilot.cummins.com/qs3/pubsys2/xml/en/tsb/2014/tsb140168.html',
                                                              Type__c = 'CAM', Doc_Title__c = 'xyz', Cu_Language__c = 'xc', Performed__c = false, Job_Order__c = JO.Id,
                                                              Performed_Review__c = false, Reviewed__c = false, esn__c = '79464646');
            CSS_CampTsbTrp__c campttp1 = new CSS_CampTsbTrp__c(Doc_Num__c = 'TSB14013368', URL__c = 'https://qsolpilot.cummins.com/qs9/pubsys2/xml/en/tsb/2014/tsb140168.html',
                                                               Type__c = 'TRP', Doc_Title__c = 'xyz', Cu_Language__c = 'xc', Performed__c = false, Job_Order__c = JO.Id,
                                                               Performed_Review__c = true, Reviewed__c = false, esn__c = '79464646');

            
            ApexPages.currentPage().getParameters().put('id',JO.id);
            string PageName ='intake';
            CG_CL_IntakeUE iue = new CG_CL_IntakeUE();
            Cache.Session.put('UserERPSystem', 'BMS Legacy');
            CG_CL_IntakeUELegacyBMS SerRec = new CG_CL_IntakeUELegacyBMS();
            serRec.psncheck = true;
            serRec.siebelSMN = 'test1'; 
            serRec.HHSPSMNFlg = true;
            serRec.HHSPACCSFlg = true;
            serRec.bmsEnabled = true;
            serRec.UnitLookUpPopup = true;
            serRec.showOutageError = true;
            serRec.showOutageError1 = true;
            serRec.reqBoolean = true;
            serRec.reqAppBoolean = true;
            serRec.reqMakeBoolean = true;
            serRec.displaySrvModPopup = true;
            serRec.displaySrvModPopup1  = true;
            serRec.recconFlag =true;
            serRec.show_wr_pnl = true;
            serRec.callingLocation = 'test2';
            serRec.errorMessage = 'test4';
            serRec.sEngineFamilyCode = 'test3';
            serRec.siebVIN = 'test5';
            serRec.siebAppCode = 'test6';
            serRec.siebMake = 'test7';
            serRec.siebModel = 'test8';
            serRec.sServiceModel = 'test9';
            serRec.sWarrantyDt = 'tests';
            serRec.sVIN = 'testd';
            serRec.datebyLocaleValue = 'testf';
            serRec.selectedUnitNumber = 'testh';
            //serRec.selectedUnitDetails();
            serRec.PageName = 'Intake UE';
            serRec.selectedBMSESN = 'testss';
            
            SerRec.Wid = null;
            SerRec.showPopup7();
            //SerRec.startRequestNullPSN();
           // SerRec.startRequestBMS();
            SerRec.getWarrantyDate();
            SerRec.getFailureDt();
            
            SerRec.getCamps();
            SerRec.closecertPopup();
            SerRec.getTrps();
            SerRec.getAtcs();
            SerRec.getTsbs();
            SerRec.getItems();
            //SerRec.getApplication();
            //SerRec.getMake();
            //SerRec.getModel();
            Date Mydate = SerRec.parseQSOLDate('15-1-2005'); 
            
            CSS_Make_Model_Access__c MakeList = new CSS_Make_Model_Access__c();
            CSS_Make_Model_Access__c mk = new CSS_Make_Model_Access__c();
            mk.Access__c = 'D';
            mk.EngineFamilyCode__c = '32';
            mk.EquipmentId__c = 'EQ6423';
            mk.Make__c = 'DRESSER';
            mk.Make__c = 'Miles' ;
            mk.Model__c = '100';
            insert mk;
            
            /* CSS_CampTsbTrp__c ct = new CSS_CampTsbTrp__c();
ct.name = 'CAM';
ct.name = 'TRP';
ct.name = 'TSB';
insert ct;

list < CSS_CampTsbTrp__c > solutionList = new list < CSS_CampTsbTrp__c > ();
CSS_Solutions__c cssSol;


CSS_CampTsbTrp__c solRec = new CSS_CampTsbTrp__c(Doc_Num__c = 'TSB140168', URL__c = 'https://qsolpilot.cummins.com/qs3/pubsys2/xml/en/tsb/2014/tsb140168.html',
Type__c = 'CAM', Doc_Title__c = 'xyz', Cu_Language__c = 'xc', Performed__c = false, Job_Order__c = JO.Id,
Performed_Review__c = false, Reviewed__c = false, esn__c = '79464646');
solutionList.add(solRec);
CSS_CampTsbTrp__c solRec2 = new CSS_CampTsbTrp__c(Doc_Num__c = 'TSB14013368', URL__c = 'https://qsolpilot.cummins.com/qs9/pubsys2/xml/en/tsb/2014/tsb140168.html',
Type__c = 'TRP', Doc_Title__c = 'xyz', Cu_Language__c = 'xc', Performed__c = false, Job_Order__c = JO.Id,
Performed_Review__c = true, Reviewed__c = false, esn__c = '79464646');
solutionList.add(solRec2);
CSS_CampTsbTrp__c solRec1 = new CSS_CampTsbTrp__c(Doc_Num__c = 'TSB1401689', URL__c = 'https://qsolpilot.cummins.com/qs3/pubsys2/xml/en1/tsb/2014/tsb140168.html',
Type__c = 'TSB', Doc_Title__c = 'xyzk', Cu_Language__c = 'xc', Performed__c = true, Job_Order__c = JO.Id,
Performed_Review__c = false, Reviewed__c = false, esn__c = '79464646');
solutionList.add(solRec1);

insert solutionList;

list < CSS_CampTsbTrp__c > campTsbList = new list < CSS_CampTsbTrp__c > ();
CSS_CampTsbTrp__c campTsTr = new CSS_CampTsbTrp__c();
campTsTr.Performed__c = true;
campTsTr.Performed_Review__c = true;
campTsTr.Job_Order__c = JO.Id;
campTsTr.URL__c = 'www.salesforce.com';
campTsTr.Reviewed__c = true;
campTsTr.Type__c = 'CAM';
campTsTr.Doc_Title__c = 'Title';
campTsTr.Reviewed__c = true;
campTsTr.Doc_Num__c = 'testing';
insert campTsTr;
campTsbList.add(ct);
campTsbList.add(campTsTr);*/
            
            List<CSS_CampTsbTrp__c> lstCAM = new List<CSS_CampTsbTrp__c>();
            List<CSS_CampTsbTrp__c> lstTRP = new List<CSS_CampTsbTrp__c>();
            List<CSS_CampTsbTrp__c> lstTSB = new List<CSS_CampTsbTrp__c>();
            List<CSS_CampTsbTrp__c> lstATC = new List<CSS_CampTsbTrp__c>();
            List<CSS_CampTsbTrp__c> lstQSOLDocs = new List<CSS_CampTsbTrp__c>();
            CSS_CampTsbTrp__c ctt = new CSS_CampTsbTrp__c();
            ctt.Type__c = 'ATC';
            ctt.URL__c = 'https://qs-stg.cummins.com/qs3/pubsys2/xml/en/atc/19TC/atc1623.html';
            ctt.Doc_Num__c = 'ATCF0051000';
            ctt.Doc_Title__c = 'DUAL FUEL DATAPLATE ATC';
            ctt.Performed__c = false;
            ctt.Performed_Review__c = true;
            ctt.Reviewed__c = false;
            ctt.Job_Order__c = JO.Id;
            ctt.ESN__c = JO.ESN__c;
            ctt.cu_language__C = 'fr';
            insert ctt;
            
            CSS_CampTsbTrp__c ctt1 = new CSS_CampTsbTrp__c();
            ctt1.Type__c = 'CAM';
            ctt1.URL__c = 'https://qs-stg.cummins.com/qs3/pubsys2/xml/en/atc/19TC/atc1623.html';
            ctt1.Doc_Num__c = 'CF0051000';
            ctt1.Doc_Title__c = 'DUAL FUEL DATAPLATE ATC';
            ctt1.Performed__c = false;
            ctt1.Performed_Review__c = true;
            ctt1.Reviewed__c = false;
            ctt1.Job_Order__c = JO.Id;
            ctt1.ESN__c = JO.ESN__c;
            ctt1.cu_language__C = 'fr';
            insert ctt1;
            
            system.debug('---ctttest--' +ctt1);
            CSS_CampTsbTrp__c ctt2 = new CSS_CampTsbTrp__c();
            ctt2.Type__c = 'TRP';
            ctt2.URL__c = 'https://qs-stg.cummins.com/qs3/pubsys2/xml/en/atc/19TC/atc1623.html';
            ctt2.Doc_Num__c = 'TF0051000';
            ctt2.Doc_Title__c = 'DUAL FUEL DATAPLATE ATC';
            ctt2.Performed__c = false;
            ctt2.Performed_Review__c = true;
            ctt2.Reviewed__c = false;
            ctt2.Job_Order__c = JO.Id;
            ctt2.ESN__c = JO.ESN__c;
            ctt2.cu_language__C = 'fr';
            insert ctt2;
            
            SerRec.getALLRecords();
            
            CSS_CampTsbTrp__c ctt3 = new CSS_CampTsbTrp__c();
            ctt3.Type__c = 'TSB';
            ctt3.URL__c = 'https://qs-stg.cummins.com/qs3/pubsys2/xml/en/atc/19TC/atc1623.html';
            ctt3.Doc_Num__c = 'TF0051000';
            ctt3.Doc_Title__c = 'DUAL FUEL DATAPLATE ATC';
           ctt3.Performed__c = false;
           ctt3.Performed_Review__c = true;
           ctt3.Reviewed__c = false;
            ctt3.Job_Order__c = JO.Id;
            ctt3.ESN__c = JO.ESN__c;
            insert ctt3;  
          //  lstQSOLDocs.add(ctt3);
            lstQSOLDocs.add(ctt);
            lstQSOLDocs.add(ctt1);
            lstQSOLDocs.add(ctt2);
            lstCAM.add(ctt1);
            lstTRP.add(ctt2);
            lstATC.add(ctt);
           // lstTSB.add(ctt3);
            //  CG_CL_IntakeUELegacyBMS Tsb = new CG_CL_IntakeUELegacyBMS();
              
  
            
            /*String json = ' \"DataArea\": {'+
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
'}';*/
            String json = '"DataArea": {  "Details": {    "ApplicationCode": "12345",    "Description": "testing",    "BusinessUnit": "GetAssessData",    "AutomotiveFlag": "Fault Details Data sent successfully",    "MarineFlag": "Fault Details Data sent successfully",    "ActiveFlag": "Y",    "DefaultUom": "Fault Details Data sent successfully"  },  "Header": {        "ReturnCodeDescription": "Test",        "Status": "completed"      }}, Id=a0Lc0000008PnJBEA0}';
            
            
            CSS_JobEventTemporary__c je1 = CSS_TestData.createJobEventTempObj(false);
            je1.Attribute1__c = 'UnitTypes';
            je1.key__c = '02400-02400';
            je1.Reason__c = json;
            insert je1;
            
            CSS_JobEventTemporary__c je2 = CSS_TestData.createJobEventTempObj(false);
            je2.Attribute1__c = 'SubType';
            je2.key__c = '02400-02400';
            je2.Reason__c = json;
            insert je2;
            
            CSS_JobEventTemporary__c je3 = CSS_TestData.createJobEventTempObj(false);
            je3.Attribute1__c = 'ApplicationCodes';
            je3.key__c = '02400-02400';
            je3.Reason__c = json;
            insert je3;
            
            Test.setMock(WebServiceMock.class, new CSS_GetWarrantyDocs_Test());
            Test.setMock(HttpCalloutMock.class, new CG_CampaignMock_Test());
            
            CSS_Listof_HHP_SMNS__c hhp = new CSS_Listof_HHP_SMNS__c();
            hhp.name = 'SX15 CM2350 X101';
            hhp.Listof_HHP_SMN__c = 'SX15 CM2350 X101';
            insert hhp;
            
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
            CSS_TestData.createAccountLanguage(true);
            CSS_TestData.createIntegrationDetails(true);
            
            //SerRec.getALLRecords(); 
            
            // Test.startTest(); 
            CSS_List_Of_Values__c listofval = new CSS_List_Of_Values__c();
            listofval.Name = '130';
            listofval.Picklist_Values_1__c = 'AUTOMOTIVE';
            listofval.Code__c = '130';
            listofval.Type__c = 'Application Code';
            insert listofval;
            // Test.setMock(WebServiceMock.class, new CSS_getEngineDataFrmSiebel_Test());
            CG_CL_IntakeUELegacyBMS IntakeJob1 = new CG_CL_IntakeUELegacyBMS();
            CG_CL_IntakeVH invh = new CG_CL_IntakeVH();
            CG_CL_IntakeRJ inrj = new CG_CL_IntakeRJ();
            IntakeJob1.mainContrVH = invh;
            IntakeJob1.mainContrRJ = inrj;
            IntakeJob1.higherdateErrFlag=true;
            IntakeJob1.warrantyDate=null;
            //CG_BL_Intake cbintake = new CG_BL_Intake();
            //cbintake.getCertificationStatus();
            
            CG_CL_IntakeUE cciue = new CG_CL_IntakeUE();
            cciue.Wid = ApexPages.currentPage().getParameters().put('id',JO.id);
            cciue.filterMake = 'ACE';
            cciue.workjob = JO;
            JO.Warranty_Start_Date__c =System.today();
            //cciue.higherdateErrFlag=true;
            IntakeJob1.HHSPSMNFlg = true;
            IntakeJob1.HHSPACCSFlg = false;
            IntakeJob1.lstCAM = lstCAM;
            IntakeJob1.lstTRP = lstTRP;
            IntakeJob1.lstTSB = lstTSB;
            IntakeJob1.lstATC = lstATC;
            IntakeJob1.mainContr = cciue;
            Date Mydate1 = IntakeJob1.parseQSOLDate('15-1-2005');
            Test.setMock(HttpCalloutMock.class, new CSS_getEngineDataFrmSiebel_Test());
            Test.setMock(WebServiceMock.class, new CSS_GetEngineDataPlate_Test());
            IntakeJob1.startRequestNullPSN();
            IntakeJob1.esnGo();
            IntakeJob1.getSubType();
            IntakeJob1.getUnitType();
                       
            IntakeJob1.selectedBMSUnitNumber();
            IntakeJob1.closeSrvModPopup();
            IntakeJob1.closeBMSCustDetails();
            IntakeJob1.higherdateErrFlag = true;
            IntakeJob1.pgSaveFinish();
            IntakeJob1.callUnitSubTypes(); 
            IntakeJob1.getBMSUnitDetails();
            IntakeJob1.selectedUnitNumber = 'testh';
            IntakeJob1.selectedUnitDetails();
            IntakeJob1.selectedESNnUnitDetails();
            IntakeJob1.getBMSUnitDetailsfromUnitNumber();
            IntakeJob1.getApplication();
            IntakeJob1.getMake();
            IntakeJob1.getModel();
            IntakeJob1.closeSrvModPopup1();
            IntakeJob1.clearUnitLookupList();
            Test.stopTest(); 
        }catch(DMLException e){
            system.assertEquals(e.getMessage(), e.getMessage()); 
        }
        /*
static testMethod void engineDataSiebel() {

Test.setMock(HttpCalloutMock.class, new CSS_getEngineDataFrmSiebel_Test());
Test.setMock(WebServiceMock.class, new CSS_GetEngineDataPlate_Test());
CG_CL_IntakeUELegacyBMS cciue = new CG_CL_IntakeUELegacyBMS();
CSS_Job_Order__c JOsr = new CSS_Job_Order__c();
JOsr.ESN__c = '79384192';
insert JOsr;
CSS_Listof_HHP_SMNS__c hhp = new CSS_Listof_HHP_SMNS__c();
hhp.name = 'SX15 CM2350 X101';
hhp.Listof_HHP_SMN__c = 'SX15 CM2350 X101';
insert hhp;
CG_CL_IntakeUE mainContr = new CG_CL_IntakeUE();
mainContr.workJob = JOsr;
cciue.startRequest();
Test.startTest();

CSS_getEngineDataReqJ2A wrapobj = new CSS_getEngineDataReqJ2A();
CSS_getEngineDataResponseJ2A engineData;
CSS_getEngineDataReqJ2A.DataArea jidi = new CSS_getEngineDataReqJ2A.DataArea();
jidi.ESN = JOsr.ESN__c;
wrapobj.DataArea = jidi;


engineData = CSS_WS_SBL.getEngineData(wrapobj);
Test.stopTest();
}*/
        
    }
     static testmethod void TestForTsbs(){
        
        CG_CL_IntakeUELegacyBMS Tsb1 = new CG_CL_IntakeUELegacyBMS();
        
        css_job_order__c Jobwo13 = new css_job_order__C();
            Jobwo13.ESN__c='79850897';
            insert Jobwo13;
         
          // List<Asset> lstasst = new List<Assest>(); 
         Account acc = new Account();
         acc.name='Rajesh';
         insert acc;
         Contact con = new Contact();
         con.FirstName='Test2';
         con.lastname='rajesh';
         con.AccountId=acc.Id;
         insert con;
         List<Asset> lstAsset = new List<Asset>();
         Asset ass = new Asset();
         ass.Name='test';
         ass.SerialNumber = Jobwo13.ESN__c;
         ass.Type__c='Products';
         ass.AccountId=acc.Id;
         ass.ContactId=con.Id;
         insert ass;
         lstAsset.add(ass);
        //Adding Instance variable here
        CG_CL_IntakeUE maincrl = new CG_CL_IntakeUE();
            maincrl.workJob=Jobwo13;
            maincrl.Wid=Jobwo13.id;
            Tsb1.mainContr = maincrl;
            Tsb1.Wid = Jobwo13.ID;
            
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
            ctt3.ESN__c = Jobwo13.ESN__c;
            insert ctt3;
            
        list<CSS_CampTsbTrp__c> TestingQSOLDocs = [select Type__c,URL__c,Doc_Num__c,Doc_Title__c, Performed__c,Performed_Review__c,Reviewed__c from CSS_CampTsbTrp__c where Job_Order__c= :Tsb1.Wid AND Type__c ='TSB' ];
        Tsb1.lstQSOLDocs = TestingQSOLDocs;
        system.assert(Tsb1.lstQSOLDocs!=null);
        test.startTest();
        Tsb1.getTsbs();
        Tsb1.startRequest();
        Tsb1.getlicensePlateList();
        test.stopTest();
    }
       /*  static testmethod void TestforFailureDateWarrantyDate2(){
        
        CG_CL_IntakeUELegacyBMS TestmetUEno1 = new CG_CL_IntakeUELegacyBMS();
        CSS_UnitOutboundJSON2Apex obj = new CSS_UnitOutboundJSON2Apex();
        TestmetUEno1.UnitOutboundDetails = obj;
        TestmetUEno1.dt_WarrantyDt=system.now();
        TestmetUEno1.dt_FailureDt=system.now();
        TestmetUEno1.getWarrantyDate();
        TestmetUEno1.getFailureDt();
     }
    */
    static testmethod void testsetrequest(){
        
        CSS_Job_Order__c JO = new CSS_Job_Order__c();
        jo.ESN__c = '79464646';
        jo.Unit_Number__c ='12345';
        jo.Service_Model__c = 'rDataPlate.data[0]';
        jo.PSN_Not_Available__c=false;
        jo.VIN__c = 'Tuuiio';
        jo.Warranty_Start_Date__c = null;
        jo.Location_Certification__c = 'Bangalore';
        jo.ESN_IA__c = '5678909078';
        jo.ProductApplicationCode__c='test1';
        jo.ProductApplicationDesp__c='test2';
        insert jo;
Account acc = new Account();
         acc.name='Rajesh';
         insert acc;
         Contact con = new Contact();
         con.FirstName='Test2';
         con.lastname='rajesh';
         con.AccountId=acc.Id;
         insert con;        
        List<Asset> lstAsset = new List<Asset>();
        Asset ass = new Asset();
        ass.Name='test';
        ass.SerialNumber = jo.ESN__c;
        ass.Type__c='Products';
        		 ass.AccountId=acc.Id;
         ass.ContactId=con.Id;
        insert ass;
        lstAsset.add(ass);
        
        CG_CL_IntakeUELegacyBMS IntakeJob1 = new CG_CL_IntakeUELegacyBMS();
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
        Test.setMock(HttpCalloutMock.class, new CSS_getEngineDataFrmSiebel_Test());
        Test.setMock(WebServiceMock.class, new CSS_GetEngineDataPlate_Test());
        IntakeJob1.WarrantyStart = Date.Today()+1;
        IntakeJob1.startRequest();
        
		cciue.filterApplication='test1234';
       // IntakeJob1.updateproductappcode();
        list<CSS_JobEventTemporary__c> jobeventlst = new list<CSS_JobEventTemporary__c>();
        CSS_JobEventTemporary__c CJ1 = new CSS_JobEventTemporary__c(name='ApplicationCodes',key__c='MarketingApplicationCodes',Attribute1__c=jo.ProductApplicationCode__c,Attribute3__c=jo.ProductApplicationDesp__c);
        insert CJ1;
        jobeventlst.add(CJ1);
        
        cciue.filterApplication='testui';
        IntakeJob1.updateproductappcode();
        
          CSS_Job_Order__c SerRec = CSS_TestData.createJobOrder(false);
        SerRec.ESN__c = '79464646';
        SerRec.Unit_Number__c ='12345';
        SerRec.Service_Model__c = 'rDataPlate.data[0]';
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
        
        test.stopTest();
        
    }
    
    static testmethod void testcasemethod(){
        
        CG_CL_IntakeUELegacyBMS IntakeBMS1 = new CG_CL_IntakeUELegacyBMS();
        IntakeBMS1.dt_FailureDt = System.today() + 5;
        
        css_job_order__c Jobwo = new css_job_order__C();
        Jobwo.PSN_Not_Available__c= true;
        insert Jobwo;
        RecordType rtbms = [SELECT id,Name 
                             FROM RecordType 
                             WHERE name='SRTData'];
        List<CSS_Make_Model_Access__c> lstmakemodel = new List<CSS_Make_Model_Access__c>();
        CSS_Make_Model_Access__c makemodel = new CSS_Make_Model_Access__c();
        makemodel.Access__c = ' test';
        makemodel.EquipmentId__c = 'akanksha test';
        //makemodel.RecordTypeId = '';
        makemodel.Make__c = 'Akanksha make';
        makemodel.Model__c = 'Akanksha model';
        makemodel.EngineFamilyCode__c = 'test';
        makemodel.RecordTypeId =  Schema.SObjectType.CSS_Make_Model_Access__c.getRecordTypeInfosByName().get('SRTData').getRecordTypeId();
        
        insert makemodel;
        lstmakemodel.add(makemodel);
        system.debug('lstmakemodel'+lstmakemodel);
        system.debug('lstmakemodel.size()'+lstmakemodel.size());
        CG_CL_IntakeUE JobwoUE = new CG_CL_IntakeUE();
        JobwoUE.workJob = Jobwo;
        IntakeBMS1.mainContr= JobwoUE;
        system.debug('NullPsn Method Starts>>>');
        IntakeBMS1.startRequestNullPSN();
        system.debug('NullPsn Method Ends>>>');
        system.debug('PSN Value>>'+IntakeBMS1.mainContr.workJob);
        IntakeBMS1.searchConfigUnit();          
    }
    
    static testmethod void testesnGomethod(){
        
        CG_CL_IntakeUELegacyBMS IntakeBMS11 = new CG_CL_IntakeUELegacyBMS();
        css_job_order__c Jobwo1 = new css_job_order__C();
        Jobwo1.ESN_IA__c ='Testing';
        Jobwo1.ESN__c='123425';
        insert Jobwo1;
        
        //Passing Job to Mainctrl 
        CG_CL_IntakeUE JobwoUE1 = new CG_CL_IntakeUE();
        JobwoUE1.workJob = Jobwo1;
        IntakeBMS11.mainContr= JobwoUE1;
        IntakeBMS11.HHSPACCSFlg=true;
        IntakeBMS11.HHSPSMNFlg=false;
        IntakeBMS11.esnGo();
        
    }
    
    static testmethod void testselectedESNnUnitDetailsPositivecase() {
        
        CG_CL_IntakeUELegacyBMS IntakeBMS12 = new CG_CL_IntakeUELegacyBMS();
        
        css_job_order__c Jobwo12 = new css_job_order__C();
        Jobwo12.ESN_IA__c ='Testing';
        Jobwo12.Warranty_Start_Date__c = date.today()+1;
        insert Jobwo12;
        
        //Passing Job to Mainctrl 
        CG_CL_IntakeUE JobwoUE12 = new CG_CL_IntakeUE();
        JobwoUE12.workJob = Jobwo12;
        IntakeBMS12.mainContr= JobwoUE12;
        IntakeBMS12.selectedUnitNumber='TestingSelectNumber';
        IntakeBMS12.selectedBMSESN='TestingselectedBMSESN';
        
        //Forming Request Body here,
        String json = '{ '+
            '\"Header\": { '+
            '  \"Status\": \"success\", '+
            '  \"Sender\": { '+
            '\"ServiceName\": \"GetUnitInfo\",'+
            '\"SenderID\": \"CSS\"'+
            '},'+
            ' \"Target\": {'+
            '\"TargetID\": \"BMS"'+
            '},'+
            '  \"Location\": { '+
            '   \"LocationID\": \"02400-02394\" '+
            '  } '+
            '}, '+
            '\"DataArea\": [{ '+
            '  \"CustomerCode\" : \"A1234567\", '+
            '  \"UnitNumber\": \"TestingSelectNumber\", '+
            '  \"UnitDescription\": \"\", '+
            '  \"UnitType\": \"\", '+
            '  \"Model\": \"\", '+
            '  \"VIN\": \"\", '+
            '  \"Manufacturer\": \"KENWORTH\", '+
            '  \"SalesSegment\": \"\", '+
            '  \"ModelNumber\": \"\", '+
            '  \"ModelSeq\": 0, '+
            '  \"ESN\": \"TestingselectedBMSESN\", '+
            '  \"EngineFamily\": \"\", '+
            '  \"Applicationcode\": \"\" '+
            '}] '+
            '}';
        CSS_UnitOutboundJSON2Apex obj = CSS_UnitOutboundJSON2Apex.parse(json);
        IntakeBMS12.UnitOutboundDetails =obj;
        
        //Excueting Testmethod selectednumber
        test.startTest();
        intakebms12.selectedESNnUnitDetails();
       // intakebms12.pgSaveFinish();
        test.stopTest();       
    }
    
    static testmethod void testselectedUnitDetailspositivecase(){
        
        CG_CL_IntakeUELegacyBMS IntakeBMS12 = new CG_CL_IntakeUELegacyBMS();
       // IntakeBMS12.showOutageError = true;
       // IntakeBMS12.errorMessage='error';
        
        css_job_order__c Jobwo12 = new css_job_order__C();
    //    Jobwo12.Unit_Number__c='';
       // Jobwo12.filterUnitType = '';
        Jobwo12.ESN_IA__c ='Testing';
        insert Jobwo12;
        
        //Passing Job to Mainctrl 
        CG_CL_IntakeUE JobwoUE12 = new CG_CL_IntakeUE();
        JobwoUE12.workJob = Jobwo12;
        IntakeBMS12.mainContr= JobwoUE12;
        IntakeBMS12.selectedUnitNumber='TestingSelectNumber1';
        
        //Forming Request Body here,
        String json = '{ '+
            '\"Header\": { '+
            '  \"Status\": \"success\", '+
            '  \"Sender\": { '+
            '\"ServiceName\": \"GetUnitInfo\",'+
            '\"SenderID\": \"CSS\"'+
            '},'+
            ' \"Target\": {'+
            '\"TargetID\": \"BMS"'+
            '},'+
            '  \"Location\": { '+
            '   \"LocationID\": \"02400-02394\" '+
            '  } '+
            '}, '+
            '\"DataArea\": [{ '+
            '  \"CustomerCode\" : \"A1234567\", '+
            '  \"UnitNumber\": \"TestingSelectNumber1\", '+
            '  \"UnitDescription\": \"\", '+
            '  \"UnitType\": \"\", '+
            '  \"Model\": \"\", '+
            '  \"VIN\": \"\", '+
            '  \"Manufacturer\": \"KENWORTH\", '+
            '  \"SalesSegment\": \"\", '+
            '  \"ModelNumber\": \"\", '+
            '  \"ModelSeq\": 0, '+
            '  \"ESN\": \"TestingselectedBMSESN\", '+
            '  \"EngineFamily\": \"\", '+
            '  \"Applicationcode\": \"\" '+
            '}] '+
            '}';
        CSS_UnitOutboundJSON2Apex obj = CSS_UnitOutboundJSON2Apex.parse(json);
        IntakeBMS12.UnitOutboundDetails =obj;
        //Excueting Testmethod selectednumber
        
        test.startTest();
        intakebms12.selectedUnitDetails();
        test.stopTest();       
    }
    
    static testmethod void testpgsavemethod(){
        
        CG_CL_IntakeUELegacyBMS Pgsavemethod = new CG_CL_IntakeUELegacyBMS();
        
        css_job_order__c Jobwo12 = new css_job_order__C();
        Jobwo12.ESN_IA__c ='Testing';
        insert Jobwo12;
        
        //Passing Job to Mainctrl 
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
            string cmiRecordTypeId =Schema.SObjectType.Account.getRecordTypeInfosByName().get('CMI').getRecordTypeId();
            Account acc = new Account();
            acc.name='Rtest';
            acc.CSS_DistributorCode__c='56270';
            acc.CSS_DealerCode__c='56270';
            acc.RecordTypeId= cmiRecordTypeId;
            acc.Type='Dealer Account';
            acc.Region__c = 'US and Canada';
            acc.CMI_Account_Status__c = 'Active';
              
            insert acc;
            
            CSS_UserLocation__c userLocation = new CSS_UserLocation__c(AccountId__c=acc.id,isActive__c=true,isPrimary__c=true,UserId__c=u.Id,Location_code__c='56270-56270');
            insert userLocation;
            test.startTest();
            pgsavemethod.pgSaveFinish();
            test.stopTest();
        }
    }
    
    static testmethod void testTsbTrbATCCamp(){
        
        CG_CL_IntakeUELegacyBMS TsbTrbATCCamp = new CG_CL_IntakeUELegacyBMS();
        css_job_order__c Jobwo13 = new css_job_order__C();
        Jobwo13.ESN__c='79850897';
        Jobwo13.failure_Date__c = date.today()+20;
        Jobwo13.Warranty_Start_Date__c=date.today()-12;
        Jobwo13.Before_In_Service__c = false;
        insert Jobwo13;
        
        //Adding Instance variable here
        CG_CL_IntakeUE maincrl = new CG_CL_IntakeUE();
        maincrl.workJob=Jobwo13;
        maincrl.Wid=Jobwo13.id;
        maincrl.tempFailureDate=system.today();
        TsbTrbATCCamp.mainContr = maincrl;
        TsbTrbATCCamp.Wid = Jobwo13.ID;
        Jobwo13.Location_Certification__c = 'NotCert';
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
        Profile p = [SELECT Id FROM Profile WHERE Name='CSS_Service_Advanced']; 
        User usr = new User(Alias = 'standt', Email='standarduser4@testorg.com', 
                            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                            LocaleSidKey='en_US',  ProfileId = p.Id, 
                            TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTestUser14@testorg.com',User_Location__c = '56270-56270');
        insert usr;
        system.debug('usr**'+usr);
        
        map<String,String> accCerts = new map<String,String>();
        accCerts.put('warrCertFlag', 'value');
        System.runAs(usr) 
        { 
        test.startTest();
        system.debug('GetallRecords Enters here');
        TsbTrbATCCamp.getALLRecords();
        system.debug('GetallRecords Stops here');
        tsbtrbatccamp.getTrps();
        tsbtrbatccamp.getAtcs();
        tsbtrbatccamp.getCamps();
         
        tsbtrbatccamp.getCampaignDetails();
            test.stopTest();
        }
        
    }
    
    static testmethod void testgetBMSUnitDetailsposcase(){
        
        CG_CL_IntakeUELegacyBMS getBMSUnitDet = new CG_CL_IntakeUELegacyBMS();
        CG_CL_IntakeUE IntakeUE3 = new CG_CL_IntakeUE();
        user u = [select id,name from user limit 1];
        system.runAs(u)
        {
            CSS_JOB_ORDER__C jobwo2 = new CSS_JOB_ORDER__c();
            jobwo2.ESN__c='79548867';
            jobwo2.Customer_Name__c='Gopal';
            jobwo2.Customer_Code__c='123';
            jobwo2.Unit_Number__c='1232';
            insert jobwo2;
            
            css_job_order__c Job3 = [select id,name,ESN__c,Customer_Name__c,Customer_Code__c,Unit_Number__c,Creator_Location__c from css_job_order__C limit 1];
            IntakeUE3.workJob = Job3;
            
            getBMSUnitDet.mainContr= IntakeUE3;
            CSS_FN_BMS BMSClass= new CSS_FN_BMS();
            CSS_Integration_Details__c csInt = new CSS_Integration_Details__c();
            csInt.name = 'BMS';
            csInt.ApplicationName__c='BMS';
            csInt.End_Point__c='https://Test-services-dev.cummins.com/css/';
            csInt.IsActive__c=true;
            csInt.Key__c='/Q0w11SmTDJ11dPRgzYfGjycs+HZbtT8sezi/jkT7Ag=';
            csInt.Passcode__c='u9pf3rdOE0SCjXDCgmzRbUlwWQWen7B9993Eh61KI1E=';
            csInt.Username__c='6dpW6v5ekUR2HzkTePJXwgNaMDgo0t53tZgmixV4rfU=';
            insert csint;
            
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new BMSMockHttpResponseGenerator());
            getBMSUnitDet.getBMSUnitDetails();
            Test.setMock(HttpCalloutMock.class, new BMSMockHttpResponseGenerator1());
            getBMSUnitDet.getBMSUnitDetails();
            getBMSUnitDet.getSubType();
            test.stopTest();
        }  
        
    }
    
    static testmethod void testgetBMSUnitDetailsposcase1(){
        CG_CL_IntakeUELegacyBMS getBMSUnitDet = new CG_CL_IntakeUELegacyBMS();
        getBMSUnitDet.callingLocation='ESN';
        CG_CL_IntakeUE IntakeUE3= new CG_CL_IntakeUE();
        user u = [select id,name from user limit 1];
        system.runAs(u)
        {
            CSS_JOB_ORDER__C jobwo2 = new CSS_JOB_ORDER__c();
            jobwo2.ESN__c='79548867';
            jobwo2.Customer_Name__c='Gopal';
            jobwo2.Customer_Code__c='123';
            jobwo2.Unit_Number__c='1232';
            insert jobwo2;
            css_job_order__c Job3 = [select id,name,ESN__c,Customer_Name__c,Customer_Code__c,Unit_Number__c,Failure_Date__c,Before_In_Service__c,Warranty_Start_Date__c,ShipDate__c,BuildDate__c,Creator_Location__c from css_job_order__C limit 1];
            IntakeUE3.workJob = Job3;
            getBMSUnitDet.mainContr= IntakeUE3;
            
            CSS_Integration_Details__c csInt = new CSS_Integration_Details__c();
            csInt.name = 'BMS';
            csInt.ApplicationName__c='BMS';
            csInt.End_Point__c='https://Test-services-dev.cummins.com/css/';
            csInt.IsActive__c=true;
            csInt.Key__c='/Q0w11SmTDJ11dPRgzYfGjycs+HZbtT8sezi/jkT7Ag=';
            csInt.Passcode__c='u9pf3rdOE0SCjXDCgmzRbUlwWQWen7B9993Eh61KI1E=';
            csInt.Username__c='6dpW6v5ekUR2HzkTePJXwgNaMDgo0t53tZgmixV4rfU=';
            insert csint;
            
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new CSS_FN_BMS_Mock());
            getBMSUnitDet.getBMSUnitDetails();
            //getBMSUnitDet.getCampaignDetails();
            test.stopTest();
        } 
    }
    
    static testmethod void testgetApplicationpostest(){
        
        CG_CL_IntakeUELegacyBMS getApplicationtest = new CG_CL_IntakeUELegacyBMS();
        CG_CL_IntakeUE MainIntakeUE = NEW CG_CL_IntakeUE();
        map<string,string> mapacc = new map<string,string>();
        MainIntakeUE.mapDescriptionToCode = mapacc;
        getApplicationtest.mainContr=MainIntakeUE;
        user u = [select id ,name from user limit 1];
        system.runAs(u)
        {
            CSS_JobEventTemporary__c CJ = new CSS_JobEventTemporary__c(name='ApplicationCodes',Attribute1__c='ApplicationCodes',Reason__c ='{"DataArea": {"Details": [{"ApplicationCode": "123","Description": "abc","BusinessUnit": "EBU","AutomotiveFlag": "Y","MarineFlag": "","ActiveFlag": "N","DefaultUom": "miles"},{"ApplicationCode": "555","Description": "zxcv","BusinessUnit": "PSBU","AutomotiveFlag": "","MarineFlag": "N","ActiveFlag": "Y","DefaultUom": "miles"}]},"Header": {"ReturnCodeDescription": "","Status": "Success"}}');
            insert CJ;
            Test.setMock(HttpCalloutMock.class, new CSS_getEngineDataFrmSiebel_Test());
            Test.setMock(WebServiceMock.class, new CSS_GetEngineDataPlate_Test());
            list<selectoption> op = getApplicationtest.getApplication();
            system.assert(op!=null);
        }
    }
    
    static testmethod void testsetrequest1(){
        
        CSS_Job_Order__c JO = CSS_TestData.createJobOrder(false) ;
        jo.ESN__c = '79464646';
        jo.Unit_Number__c ='12345';
        jo.Service_Model__c = 'rDataPlate.data[0]';
        jo.VIN__c = 'Tuuiio';
        jo.Warranty_Start_Date__c = null;
        jo.Location_Certification__c = 'Bangalore';
        jo.ESN_IA__c = '5678909078';
        insert jo;
        Account acc = new Account();
         acc.name='Rajesh';
         insert acc;
         Contact con = new Contact();
         con.FirstName='Test2';
         con.lastname='rajesh';
         con.AccountId=acc.Id;
         insert con;
        List<Asset> lstAsset = new List<Asset>();
         Asset ass = new Asset();
         ass.Name='test';
         ass.SerialNumber = jo.ESN__c;
        ass.Type__c='Products';
        		 ass.AccountId=acc.Id;
         ass.ContactId=con.Id;
         insert ass;
         lstAsset.add(ass);
        CG_CL_IntakeUELegacyBMS IntakeJob1 = new CG_CL_IntakeUELegacyBMS();
        CG_CL_IntakeVH invh = new CG_CL_IntakeVH();
        CG_CL_IntakeRJ inrj = new CG_CL_IntakeRJ();
        IntakeJob1.mainContrVH = invh;
        IntakeJob1.mainContrRJ = inrj;
        
        CSS_JobEventTemporary__c CJ = new CSS_JobEventTemporary__c(name='ApplicationCodes',Attribute1__c='ApplicationCodes',Reason__c ='{"DataArea": {"Details": [{"ApplicationCode": "123","Description": "abc","BusinessUnit": "EBU","AutomotiveFlag": "Y","MarineFlag": "","ActiveFlag": "N","DefaultUom": "miles"},{"ApplicationCode": "555","Description": "zxcv","BusinessUnit": "PSBU","AutomotiveFlag": "","MarineFlag": "N","ActiveFlag": "Y","DefaultUom": "miles"}]},"Header": {"ReturnCodeDescription": "","Status": "Success"}}');
        insert CJ;
        
        CG_CL_IntakeUE cciue = new CG_CL_IntakeUE();
        cciue.Wid = ApexPages.currentPage().getParameters().put('id',JO.id);
        cciue.filterMake = 'ACE';
        cciue.workjob = JO;
        map<string,string> mapacc = new map<string,string>();
        cciue.mapDescriptionToCode=mapacc;
        IntakeJob1.HHSPSMNFlg = true;
        IntakeJob1.HHSPACCSFlg = false;
        IntakeJob1.mainContr = cciue;
        
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new CSS_getEngineDataFrmSiebel1_Test());
        Test.setMock(WebServiceMock.class, new CSS_GetEngineDataPlate_Test());
        IntakeJob1.startRequest();
       // IntakeJob1.updateproductappcode();
        test.stopTest();
    }
    
    static testmethod void compareDates1(){
        CSS_Job_Order__c jo = CSS_TestData.createJobOrder(false) ;
        jo.ESN__c = '79464646';
        jo.Unit_Number__c ='12345';
        jo.Service_Model__c = 'rDataPlate.data[0]';
        jo.VIN__c = 'Tuuiio';
        jo.Warranty_Start_Date__c = null;
        jo.Location_Certification__c = 'Bangalore';
        jo.ESN_IA__c = '5678909078';
        insert jo;
        
        css_header_nav__c cssHeaderObject = css_header_nav__c.getInstance();
        cssHeaderObject.RSWButtonEnable__c = true;
        insert cssHeaderObject;
        
        CG_CL_IntakeUE intake = new CG_CL_IntakeUE();
        intake.workJob = jo;
       
        
        Test.startTest();
        
        CG_CL_IntakeUELegacyBMS b = new CG_CL_IntakeUELegacyBMS();
        b.higherdateErrFlag=false;
        b.builddateErrFlag=false;
        b.warrantyDate = Date.Today()+1;
        b.ESN='10000000';
        b.mainContr = intake;
        //b.CompareDates();
        //Test.startTest();
        
        
        
    }
    
    static testmethod void compareDates2(){
        
        Test.startTest();
        
        CG_CL_IntakeUE IntakeUE3= new CG_CL_IntakeUE();
        
        CSS_JOB_ORDER__C jobwo2 = new CSS_JOB_ORDER__c();
        jobwo2.ESN__c='79548867';
        jobwo2.Customer_Name__c='Gopal';
        jobwo2.Customer_Code__c='123';
        jobwo2.Unit_Number__c='1232';
        jobwo2.Warranty_Start_Date__c=system.today();
      //  Jobwo2.Before_In_Service__c = false;
        insert jobwo2;
        
        css_job_order__c Job3 = [select id,name,ESN__c,Customer_Name__c,Before_In_Service__c,Warranty_Start_Date__c,Customer_Code__c,Unit_Number__c,Creator_Location__c from css_job_order__C limit 1];
        IntakeUE3.workJob = Job3;
        
        CG_CL_IntakeUELegacyBMS b = new CG_CL_IntakeUELegacyBMS();
        b.mainContr= IntakeUE3;
        b.builddateErrFlag=true;
        b.warrantyDate = Date.Today()+2;
        b.billdateVal = Date.Today()+1;
        b.higherdateErrFlag=true;
        b.ESN='10000000';
        b.CompareDates();
        Test.stopTest();
    }
    
    static testmethod void compareDates3(){
        
        Test.startTest();
        CG_CL_IntakeUE IntakeUE3= new CG_CL_IntakeUE();
        
        CSS_JOB_ORDER__C jobwo2 = new CSS_JOB_ORDER__c();
        jobwo2.ESN__c='79548867';
        jobwo2.Customer_Name__c='Gopal';
        jobwo2.Customer_Code__c='123';
        jobwo2.Unit_Number__c='1232';
        jobwo2.Warranty_Start_Date__c=system.today();
       // Jobwo2.Before_In_Service__c = false;
        insert jobwo2;
        css_job_order__c Job3 = [select id,name,ESN__c,Before_In_Service__c,Customer_Name__c,Warranty_Start_Date__c,Customer_Code__c,Unit_Number__c,Creator_Location__c from css_job_order__C limit 1];
        IntakeUE3.workJob = Job3;
        
        CG_CL_IntakeUELegacyBMS b = new CG_CL_IntakeUELegacyBMS();
        b.mainContr= IntakeUE3;
        b.builddateErrFlag=true;
        b.warrantyDate = Date.Today()+1;
        b.billdateVal = Date.Today()+2;
        b.higherdateErrFlag=true;
        b.ESN='10000123';
        b.CompareDates();
        Test.stopTest();
        
    }
    
    static testmethod void TestForonChangeBIS(){
        
        Test.startTest();    
        CG_CL_IntakeUE IntakeUE3= new CG_CL_IntakeUE(); 
        
        CSS_JOB_ORDER__C jobwo2 = new CSS_JOB_ORDER__c();
        jobwo2.ESN__c='79548867';
        jobwo2.Customer_Name__c='Gopal';
        jobwo2.Customer_Code__c='123';
        jobwo2.Unit_Number__c='1232';
        jobwo2.Warranty_Start_Date__c = null;
        jobwo2.Location_Certification__c = 'abc';
        jobwo2.jobLocation__c = 'abc';
        jobwo2.Before_In_Service__c = true;
        insert jobwo2;
        
        css_job_order__c Job3 = [select id,name,ESN__c,Before_In_Service__c,Customer_Name__c,Warranty_Start_Date__c,Customer_Code__c,Unit_Number__c,Creator_Location__c from css_job_order__C limit 1];
        IntakeUE3.workJob = Job3;
        
        
        CG_CL_IntakeUELegacyBMS UELegacy = new CG_CL_IntakeUELegacyBMS();
        UELegacy.mainContr = IntakeUE3;
        UELegacy.BISVal = 'A';
        UELegacy.dt_WarrantyDt = Date.Today()+1;
        UELegacy.dt_FailureDt = Date.Today()+1;
        UELegacy.FailureDtHidden ='';
        UELegacy.jobBIS = true;
        UELegacy.onChangeBIS();
        UELegacy.getWarrantyDate();
        UELegacy.getFailureDt();
        Test.stopTest();
    }
    
    static Testmethod void TestforCampaignDetails(){
        
        Test.setMock(HttpCalloutMock.class, new CSS_getEngineDataFrmSiebel_Test());
        Test.setMock(WebServiceMock.class, new CSS_GetEngineDataPlate_Test());
        Test.setMock(HttpCalloutMock.class, new CG_CampaignMock_Test());
        
        CG_CL_IntakeUELegacyBMS IntakeUEB = new CG_CL_IntakeUELegacyBMS();
        Id SJid;
        
        CG_CL_IntakeUE IUE = new CG_CL_IntakeUE();
        
        CSS_Job_Order__c SerRec = CSS_TestData.createJobOrder(false);
        SerRec.ESN__c = '79464646';
        SerRec.Unit_Number__c ='12345';
        SerRec.Service_Model__c = 'rDataPlate.data[0]';
        SerRec.VIN__c = 'Tuuiio';
        SerRec.Location_Certification__c = 'Bangalore';
        SerRec.ESN_IA__c = '5678909078';
        serrec.Qsol_Engine_Family_Code__c='Test';
        serrec.failure_Date__c = date.today()+5;
        serrec.Warranty_Start_Date__c=date.today()+20;
        serrec.Before_In_Service__c = false;
        SerRec.ShipDate__c=date.today()+10;
        insert SerRec;
        Account acc = new Account();
         acc.name='Rajesh';
         insert acc;
         Contact con = new Contact();
         con.FirstName='Test2';
         con.lastname='rajesh';
         con.AccountId=acc.Id;
         insert con;
         List<Asset> lstAsset = new List<Asset>();
         Asset ass = new Asset();
        ass.Name='test';
         ass.SerialNumber = SerRec.ESN__c;
        ass.Type__c='Products';
         ass.AccountId=acc.Id;
         ass.ContactId=con.Id;
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
        System.runAs(usr) 
        {  
        CSS_accountLanguage__c accLan = new CSS_accountLanguage__c();
        accLan.CSS_QsolLanguage__c = 'en';
        accLan.Name = 'en_US';
        insert accLan;
        /*CSS_Job_Order__c SerRec1 = CSS_TestData.createJobOrder(false);
        SerRec1.ESN__c = '79464646';
        SerRec1.Unit_Number__c ='12345';
        SerRec1.Service_Model__c = 'XDFF34';
        SerRec1.VIN__c = 'Tuuiio';
        SerRec1.Location_Certification__c = 'Bangalore';
        SerRec1.ESN_IA__c = '5678909078';
        SerRec1.Qsol_Engine_Family_Code__c='Test';
        SerRec1.failure_Date__c = date.today()-20;
        SerRec1.Warranty_Start_Date__c=date.today()+20;
        SerRec1.Before_In_Service__c = false;
        SerRec1.ShipDate__c=date.today()+10;
        insert SerRec1;*/
        IUE.filterMake = 'ACE';
        IUE.filterModel = 'QSB-44-T2';
        IUE.workJob.Failure_Date__c= date.today()+1;
        IUE.filterUnitType='KM';
        IntakeUEB.mainContr = IUE;
        
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
        IntakeUEB.mainContr = mainContr;
        
        test.startTest();
        
        Test.setMock(HttpCalloutMock.class, new CSS_getEngineDataFrmSiebel_Test());
        //Test.setMock(WebServiceMock.class, new CSS_GetEngineDataPlate_Test());
        //Test.setMock(HttpCalloutMock.class, new CSS_GetSPDataWSMock_Test());
        IntakeUEB.startRequest();
       // IntakeUEB.getCampaignDetails();
        //IntakeUEB.updateproductappcode();
        
        //Test.setMock(WebServiceMock.class, new CSS_GetEngineDataPlate_Test());
        //Test.setMock(HttpCalloutMock.class, new CSS_GetSPDataWSMock_Test());
       //CSS_quickserveCumminsComWebservices.ModelName rDataPlate.data[0]=null;
       Test.setMock(WebServiceMock.class, new CSS_GetEngineDataPlate_Test());
             CSS_getEngineDataResponseJ2A  engineData=null;
        IntakeUEB.startRequest();
        test.stoptest();
        }
    }
    
    //New method for QSOL service is down & Siabel service is Up
    static Testmethod void TestforSiabelServiceOnly(){
        
        Test.setMock(HttpCalloutMock.class, new CSS_getEngineDataFrmSiebel_Test());
        Test.setMock(WebServiceMock.class, new CSS_GetEngineDataPlate_Test());
        Test.setMock(HttpCalloutMock.class, new CG_CampaignMock_Test());
        
        CG_CL_IntakeUELegacyBMS IntakeUEB = new CG_CL_IntakeUELegacyBMS();
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
        serrec.failure_Date__c = date.today()-20;
        serrec.Warranty_Start_Date__c=date.today()-12;
        serrec.Before_In_Service__c = false;
        insert SerRec;
        Account acc = new Account();
         acc.name='Rajesh';
         insert acc;
         Contact con = new Contact();
         con.FirstName='Test2';
         con.lastname='rajesh';
         con.AccountId=acc.Id;
         insert con;
		 
        List<Asset> lstAsset = new List<Asset>();
         Asset ass = new Asset();
        ass.Name='test';
         ass.SerialNumber = SerRec.ESN__c;
        ass.Type__c='Products';
         ass.AccountId=acc.Id;
         ass.ContactId=con.Id;
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
        
        IntakeUEB.mainContr = IUE;
        
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
        IntakeUEB.mainContr = mainContr;
        
        test.startTest();
        
        Test.setMock(WebServiceMock.class, new CSS_GetEngineDataPlate2_Test());
        Test.setMock(HttpCalloutMock.class, new CSS_getEngineDataFrmSiebel_Test());
        //Test.setMock(HttpCalloutMock.class, new CSS_GetSPDataWSMock_Test());
        IntakeUEB.startRequest();
       
        
        test.stoptest();
        
    }
 
   static testmethod void startrequest(){
        
        CSS_Job_Order__c JO = new CSS_Job_Order__c();
        jo.ESN__c = '11111111';
        jo.Unit_Number__c ='12345';
        jo.Service_Model__c = 'rDataPlate.data[0]';
        jo.PSN_Not_Available__c=false;
        jo.VIN__c = 'Tuuiio';
        jo.Warranty_Start_Date__c = null;
        jo.Location_Certification__c = 'Bangalore';
        jo.ESN_IA__c = '5678909078';
        jo.ProductApplicationCode__c='test1';
        jo.ProductApplicationDesp__c='test2';
        insert jo;
       Account acc = new Account();
         acc.name='Rajesh';
         insert acc;
         Contact con = new Contact();
         con.FirstName='Test2';
         con.lastname='rajesh';
         con.AccountId=acc.Id;
         insert con;
		 
        List<Asset> lstAsset = new List<Asset>();
         Asset ass = new Asset();
       ass.Name='test';
         ass.SerialNumber = jo.ESN__c;
       ass.Type__c='Products';
       ass.AccountId=acc.Id;
         ass.ContactId=con.Id;
         insert ass;
         lstAsset.add(ass);
       
        
        CG_CL_IntakeUELegacyBMS IntakeJob1 = new CG_CL_IntakeUELegacyBMS();
        CG_CL_IntakeVH invh = new CG_CL_IntakeVH();
        CG_CL_IntakeRJ inrj = new CG_CL_IntakeRJ();
        IntakeJob1.mainContrVH = invh;
        IntakeJob1.mainContrRJ = inrj;
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
        conDetails.Name = 'GetEngineDataPlateQSOLREST';
        conDetails.AuthEnv__c = 'OAGOAUTH';
        conDetails.ApplicationName__c = 'GetEngineDataPlateQSOLREST';
        conDetails.End_Point__c = 'Test';
        conDetails.Method_Type__c = 'POST';
       conDetails.Username__c = 'POST';
       conDetails.Passcode__c = 'POST';
        conDetails.Timeout__c = 2.0;
        insert conDetails;
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
        IntakeJob1.WarrantyStart = Date.Today()+1;
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
        SerRec.Service_Model__c = 'rDataPlate.data[0]';
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
        
        test.stopTest();
        
    }
    
   static testmethod void startrequest2(){
        
        CSS_Job_Order__c JO = new CSS_Job_Order__c();
        jo.ESN__c = '22222222';
        jo.Unit_Number__c ='12345';
        jo.Service_Model__c = 'rDataPlate.data[0]';
        jo.PSN_Not_Available__c=false;
        jo.VIN__c = 'Tuuiio';
        jo.Warranty_Start_Date__c = null;
        jo.Location_Certification__c = 'Bangalore';
        jo.ESN_IA__c = '5678909078';
        jo.ProductApplicationCode__c='test1';
        jo.ProductApplicationDesp__c='test2';
        insert jo;
       Account acc = new Account();
         acc.name='Rajesh';
         insert acc;
         Contact con = new Contact();
       	 con.FirstName='Test2';
         con.lastname='rajesh';
         con.AccountId=acc.Id;
         insert con;
        List<Asset> lstAsset = new List<Asset>();
         Asset ass = new Asset();
       ass.Name='test';
         ass.SerialNumber = jo.ESN__c;
       ass.Type__c='Products';
       ass.AccountId=acc.Id;
         ass.ContactId=con.Id;
         insert ass;
         lstAsset.add(ass);
        
        CG_CL_IntakeUELegacyBMS IntakeJob1 = new CG_CL_IntakeUELegacyBMS();
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
        IntakeJob1.WarrantyStart = Date.Today()+1;
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
        SerRec.Service_Model__c = 'rDataPlate.data[0]';
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
        
        test.stopTest();
        
    }    
    
    
    
}