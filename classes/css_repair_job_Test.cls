@isTest
public class css_repair_job_Test {
    public static CSS_Job_Order__c JO;
    public static Attachment attach;
    public static list<CSS_Solutions__c> solList;
    public static CSS_CampTsbTrp__c cssTrp;
    public static CSS_Solutions__c cssSol;
    public static void TestData(){
        
        Account acc = new Account();
        acc.Name = 'bangalore';
        acc.Enable_Claims__c = true;
        acc.ERP_System__c = 'One BMS';
        acc.CSS_DBCode__c='33333';
        acc.type = 'Customer';
        acc.CSS_DistributorCode__c='11111';
        acc.CMI_Account_Status__c = 'Active';
        acc.IAM_Service_Provider_Code__c='56270';
        
        insert acc;
        
        CSS_UserLocation__c userloc=new CSS_UserLocation__c();
        userloc.AccountId__c = acc.id;
        userloc.Location_code__c='12345-12345';
        userloc.UserId__c=Userinfo.getUserId();
        userloc.isActive__c=true;
        insert userloc;
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'standt', Email='standarduser2@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, User_Location__c=userloc.Location_code__c,
                          TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTestUser2@testorg.com');
        insert u;
        System.runas(u)
        {
            List<CSS_Srt__c> additionalSRTList = new List<CSS_Srt__c>();
            
            JO = new CSS_Job_Order__c();
            JO.Customer_Name__c = 'RoopaTnD';
            JO.Model__c = 'RoopaTestTnD';      
            JO.Application__c='Automotive'; 
            JO.Date_In__c= Date.today();
            JO.Notes__c= 'Repair';
            JO.INSITE_UpdateTimeStamp__c= Date.today();
            JO.Service_Model__c=null;
            JO.General_Symptoms__c='ttrtrtrt';
            JO.ESN__c='73695829';
            //JO.Creator_Location__c = 'Ban';
            JO.DSID__c = 'DSBDT7000';
            //JO.Mileage__c=23;
            JO.Category__c = 'Leak';
            JO.Complaint_Type__c = 'AIR LEAK';
            JO.Application_Desc__c='TEST';
            JO.Failure_Date__c= Date.Today();
            JO.Failure_Point_Measure__c ='sss';
            JO.DSID_Creation_Timestamp__c=Date.Today();
            JO.DSID_Status__c='open';
            JO.Shop_Work_Order__c = 'test';
            JO.Status__c = 'Repair Complete';
            JO.Unit_Number__c = 'test1234';
            JO.BMSStatus__c = 'open';
            JO.warranty_start_date__c = System.Today();
            jo.Category_Desc__c = 'f';
            JO.Category2_Desc__c='F';
            JO.Category3_Desc__c='F';
            JO.Category4_Desc__c='F';
            JO.Category5_Desc__c='F';
            jo.CSS_Resolution__c = 'solved';
            jo.Complaint_Type_Desc__c = 'rrrr';
            jo.Email_Address__c ='a@abc.com';
            jo.Unit_Type__c = 'Conventional';
            jo.Account__c=acc.id;
            jo.CSS_Job_Location_Code__c='03520-04892';
            jo.Customer_Code__c='test';
            jo.Shop_Work_Order__c='test';
            Jo.Assigned_To__c = UserInfo.getUserId();
            insert(JO);
            
            note nn1 = new note(title='BOLD', body='Test Test Test', ParentId=JO.id);
            insert nn1;
            
            
            list<CSS_Fault_Code__c> FCS = new list<CSS_Fault_Code__c>();
            CSS_Fault_Code__c CSSFc = new CSS_Fault_Code__c();
            
            CSS_Make_Model_Access__c MakeList = new CSS_Make_Model_Access__c();
            CSS_Make_Model_Access__c mk = new CSS_Make_Model_Access__c();
            //mk.Name = '100-EQ6423-32-E';
            //  mk.name = 'make';       
            mk.Access__c = 'D';
            //  mk.EngineFamily__c = '32';
            mk.EquipmentId__c = 'EQ6423';
            mk.Make__c = 'DRESSER';
            mk.Model__c = '100';
            insert mk;
            
            PageReference pref = new PageReference('/'+JO.id);
            pref.getParameters().put('id',JO.id);
            Test.setCurrentPage(pref);
            
            CSS_Solutions__c sol = new CSS_Solutions__c();
            sol.Service_Job__c = JO.ID;
            sol.Case_Name__c = 'ABC';
            sol.Solution_Title__c='CDE';
            sol.Name='ABC';
            sol.Diagnostic_Response__c ='Most likely the solution';
            sol.Repair_Response__c = 'Most likely';
            insert sol;
            
            CSS_Solutions__c solAdd = new CSS_Solutions__c();
            solAdd.Service_Job__c = JO.ID;
            solAdd.Case_Name__c = 'Additional SRTS';
            solAdd.Solution_Title__c='Additional SRTS';
            solAdd.Name='Additional SRTS';
            solAdd.Diagnostic_Response__c ='Most likely the solution';
            solAdd.Repair_Response__c = 'Most likely ';
            insert solAdd;
            
            CSS_Solutions__c solAdd1 = new CSS_Solutions__c();
            solAdd1.Service_Job__c = JO.ID;
            solAdd1.Case_Name__c = 'Additional SRTS';
            solAdd1.Solution_Title__c='Additional SRTS';
            solAdd1.Name='Additional SRTS';
            solAdd1.Diagnostic_Response__c ='Most likely the solution';
            solAdd1.Repair_Response__c = 'Most likely ';
            insert solAdd1;
            
            CSS_Solutions__c solAdd2 = new CSS_Solutions__c();
            solAdd2.Service_Job__c = JO.ID;
            solAdd2.Case_Name__c = 'Additional SRTS';
            solAdd2.Solution_Title__c='Additional SRTS';
            solAdd2.Name='Additional SRTS';
            solAdd2.Diagnostic_Response__c ='Most likely the solution';
            solAdd2.Repair_Response__c = 'Most likely ';
            insert solAdd2;
            
            CSS_Solution_Component__c solComp = new CSS_Solution_Component__c();
            solComp.Component_Id__c ='F0051000';
            solComp.Selected_Component__c = true;
            solComp.Service_Job__c = JO.id;
            solComp.Solutions__c = sol.id;
            insert solComp;
            
            CSS_Solution_Component__c AddsolComp = new CSS_Solution_Component__c();
            AddsolComp.Component_Id__c ='F0051000';
            AddsolComp.Service_Job__c = JO.id;
            AddsolComp.Solutions__c = soladd.id;
            AddsolComp.Name = 'Additional Components';
            insert AddsolComp;
            
            CSS_SRT__c srtRep = new CSS_SRT__c();
            srtRep.Solution_Number__c = sol.id;
            srtRep.Job_Order__c = JO.id;
            srtRep.Component_Id__c = solComp.id;
            srtRep.Assignment__c = 'Primary';
            srtRep.SRT_Time__c = 65;
            srtRep.name = 'Test';
            srtRep.Extended_Hours__c = 2.32;
            srtRep.Type__c = 'Diagnosis';
            insert srtRep;
            
            CSS_SRT__c srtDiagAccess = new CSS_SRT__c();
            srtDiagAccess.Solution_Number__c = sol.id;
            srtDiagAccess.Job_Order__c = JO.id;
            srtDiagAccess.SRT_AccessiblityCheck__c=True;
            srtDiagAccess.SRT_Time__c = 65;
            //srtDiagAccess.Diagnosis_Time__c = 1.5;
            srtDiagAccess.name = 'Test';
            srtDiagAccess.Type__c = 'Diag Access';
            insert srtDiagAccess;
            
            CSS_SRT__c srtRepAccess = new CSS_SRT__c();
            srtRepAccess.Solution_Number__c = sol.id;
            srtRepAccess.SRT_AccessiblityCheck__c=True;
            srtRepAccess.SRT_Time__c = 65;
            srtRepAccess.Job_Order__c = JO.id;
            srtRepAccess.name = 'Test';
            srtRepAccess.Type__c = 'Repair Access';
            insert srtRepAccess;
            
            
            CSS_SRT__c srtAddiRepAccess = new CSS_SRT__c();
            srtAddiRepAccess.Solution_Number__c = solAdd.id;
            srtAddiRepAccess.SRT_AccessiblityCheck__c=True;
            srtAddiRepAccess.SRT_Time__c = 65;
            srtAddiRepAccess.Job_Order__c = JO.id;
            srtAddiRepAccess.name = 'Test';
            srtAddiRepAccess.Type__c = 'Repair Access';
            insert srtAddiRepAccess;
            
            
            CSS_SRT__c srtAddiDiagAccess = new CSS_SRT__c();
            srtAddiDiagAccess.Solution_Number__c = solAdd.id;
            srtAddiDiagAccess.SRT_AccessiblityCheck__c=True;
            srtAddiDiagAccess.SRT_Time__c = 65;
            srtAddiDiagAccess.Job_Order__c = JO.id;
            srtAddiDiagAccess.name = 'Test';
            srtAddiDiagAccess.Type__c = 'Repair Access';
            insert srtAddiDiagAccess;
            
            CSS_SRT__c srtAddiDiagAccess1 = new CSS_SRT__c();
            
            srtAddiDiagAccess1.isPerformed__c = True;
            srtAddiDiagAccess1.name = 'Test';
            srtAddiDiagAccess1.Type__c = 'Diagnosis';
            insert srtAddiDiagAccess1;
            
            CSS_Listof_HHP_SMNS__c hhp = new CSS_Listof_HHP_SMNS__c();
            hhp.name ='Test';
            hhp.Listof_HHP_SMN__c ='QSK19 CM2150 MCRS';
            insert hhp;
            attach=new Attachment();    
            attach.Name='Unit Test Attachment';
            Blob bodyBlob1=Blob.valueOf('Unit Test Attachment Body');
            attach.body=bodyBlob1;
            attach.parentId=jo.id;
            insert attach;
            
            Attachment attach1=new Attachment();    
            attach1.Name='Unit Test Attachment';
            Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
            attach1.body=bodyBlob;
            attach1.parentId=jo.id;
            insert attach1;
            
            // Test data for CSS_ECM__c
            List<CSS_ECM__c> ecmlist = new List<CSS_ECM__c>();
            CSS_ECM__c ecm1 = new CSS_ECM__c();
            ecm1.name='testecm';
            ecm1.ECM_Number__c=0;
            ecm1.Sequence__c=1;
            ecm1.ECM_Image_Name__c='test1';
            ecm1.Job_Order__c=jo.Id;
            ecmlist.add(ecm1);
            insert ecmlist ;
        }
    }
    public static testMethod void css_repair_job_Test_Method1() {
        //Test.setMock(HttpCalloutMock.class, new CSS_get_file());
        TestData();
        
        Test.StartTest();
        ApexPages.currentPage().getParameters().put('id',jo.Id); 
        PageReference p=Page.CSS_JobRepair; 
        Test.setCurrentPage(p);  
        ApexPages.currentPage().getParameters().put('id',jo.Id);  
        
        css_repair_job TriageJob1= new css_repair_job ();
        TriageJob1.vMore_JobId = jo.Id;
        TriageJob1.region ='123';
        TriageJob1.dispRepTime = '123';
        TriageJob1.NewrepTime = 1.2;
        TriageJob1.jobId= jo.Id;
        TriageJob1.atthId=attach.id;
        TriageJob1.editAttachment();
        string x=TriageJob1.getmil_measure();
        TriageJob1.setmil_measure(x);
        TriageJob1.getfail_measure();
        TriageJob1.setfail_measure(x);
        TriageJob1.getItems();
        TriageJob1.getDSID();
        TriageJob1.getfilterMake();
        TriageJob1.setfilterMake(X);
        TriageJob1.getfilterModel();
        TriageJob1.setfilterModel(x);
        TriageJob1.fetchModelRecords();
        TriageJob1.closeSession_close();
        TriageJob1.show_rj_pnl = true;
        TriageJob1.pgSaveAssign();
        TriageJob1.selectedRepairJobID=jo.Id;
        TriageJob1.callWarrantyoverviewlink();
        TriageJOb1.qsollanguage();
        TriageJob1.getFailureDate();
        TriageJob1.getFile();   
        Cache.Session.put('local.CSSPartition.UserPrimaryLocationCode','89768-89079');    
        //TriageJob1.createAttachment(Blob.valueOf('Unit Test Attachment Body'));
        TriageJob1.getLocations(); 
        //TriageJob1.getAttachment(attach.id);
        TriageJob1.getApplicationCodes();
        TriageJob1.blankUnitonCustCodeChange();
        TriageJob1.showFieldActionPopup();
        Test.StopTest();
    }
    public static testMethod void css_repair_job_Test_Method2() {
        TestData();
        Account acc = new Account();
        acc.Name = 'bangalore5';
        acc.Enable_Claims__c = true;
        acc.ERP_System__c = 'One BMS';
        acc.CSS_DBCode__c='333335';
        acc.type = 'Customer';
        acc.CSS_DistributorCode__c='111115';
        acc.CMI_Account_Status__c = 'Active';
        acc.IAM_Service_Provider_Code__c='562705';
        
        insert acc;
        CSS_Job_Order__c jo = CSS_TestData.createJobOrder(true);
        JO.Model__c = null;
        JO.Make__c = 'XYZ';
        jo.Email_check_box__c = false;
        jo.VIN__c='';
        jo.Service_Model__c='';
        jo.Application_Desc__c='130';
        jo.Account__c=acc.id;
        update JO;
        
        List<CSS_CampTsbTrp__c> lstcamp = new List<CSS_CampTsbTrp__c>();     
        CSS_CampTsbTrp__c solRec = new CSS_CampTsbTrp__c();
        
        solRec.Type__c='CAM';
        solRec.Doc_Num__c = 'TSB140168';
        solRec.Job_Order__c = JO.id;
        insert solRec;
        
        CSS_CampTsbTrp__c solRec1 = new CSS_CampTsbTrp__c();
        
        solRec1.Type__c='TRP';
        solRec1.Doc_Num__c = 'TSB140168';
        solRec1.Job_Order__c = JO.id;
        insert solRec1;
        
        CSS_CampTsbTrp__c solRec2 = new CSS_CampTsbTrp__c();
        
        solRec2.Type__c='TSB';
        solRec2.Doc_Num__c = 'TSB140168';
        solRec2.Job_Order__c = JO.id;
        insert solRec2;
        CSS_CampTsbTrp__c solRec23 = new CSS_CampTsbTrp__c();
        
        solRec23.Type__c='ATC';
        solRec23.Doc_Num__c = 'TSB140168';
        solRec23.Job_Order__c = JO.id;
        insert solRec23;
        lstcamp.add(solRec1);
        lstcamp.add(solRec2);
        lstcamp.add(solRec);
        lstcamp.add(solRec23);
        Test.StartTest();
        PageReference p=Page.CSS_JobRepair; 
        Test.setCurrentPage(p);  
        ApexPages.currentPage().getParameters().put('id',jo.Id);  
        css_repair_job TriageJob1= new css_repair_job ();
        TriageJob1.atthId=attach.id;
        TriageJob1.filterApplication = 'test';
        //TriageJob1.updateproductappcode();
        TriageJob1.css_redirect();
        TriageJob1.repair_vh();
        TriageJob1.getModel();
        TriageJob1.getMake();
        TriageJob1.repair_vi();
        TriageJob1.repair_jo();
        TriageJob1.repair_rj();
        TriageJob1.repair_rm();
        //TriageJob1.Cancel();
        TriageJob1.pgsave();
        TriageJob1.pgSaveFinish();
        TriageJob1.show_rj_pnl = true;
        TriageJob1.getALLRecords_old();
        TriageJob1.pgSaveAssign();
        TriageJob1.pgCustSave();
        //TriageJob1.startRequestBMS();
        TriageJob1.pgUISave();
        TriageJob1.pgCompSave();
        TriageJob1.getALLRecords();
        TriageJob1.getALLRecords_old();
        TriageJob1.getcamps();
        TriageJob1.getTrps();
        TriageJob1.getTsbs();
        TriageJob1.getAtcs();
        //TriageJob1.saveCheckBox();
        Blob fileBody=Blob.valueOf('Test Body');
        Blob fileBody2=Blob.valueOf('Test Body2');
        Blob fileBody3=Blob.valueOf('Test Body3');
        TriageJob1.fileBody = fileBody;
        TriageJob1.fileBody2 = fileBody2;
        TriageJob1.fileBody3 = fileBody3;
        TriageJob1.fileName = 'Test';
        TriageJob1.fileName2 = 'Test1';
        TriageJob1.fileName3 = 'Test2';
        TriageJob1.description1 = 'Test desc1';
        TriageJob1.description2 = 'Test desc2';
        TriageJob1.description3 = 'Test desc3';
        TriageJob1.bmsEnabled = true;
        TriageJob1.processUpload();
        TriageJob1.saveStandardAttachment(jo.Id);
        
        Test.StopTest();
        Test.setMock(HttpCalloutMock.class, new CSS_Exit_Test());
        CSS_EDSAuthentication.exitDSID('1234-5678','DSBDT4780'); 
        
    }
    public static testMethod void css_repair_job_Test_Method21() {
        Test.setMock(HttpCalloutMock.class, new CSS_Exit_Test());
        TestData();
        
        Account acc = new Account();
        acc.Name = 'bangalore';
        acc.Enable_Claims__c = true;
        acc.ERP_System__c = 'One BMS';
        acc.CSS_DBCode__c='33333';
        acc.Type = 'Customer';
        acc.CSS_DistributorCode__c='11111';
        insert acc;
        CSS_Job_Order__c jo = CSS_TestData.createJobOrder(true);
        JO.Model__c = null;
        jo.Account__c = acc.id;
        JO.Make__c = 'XYZ';
        jo.Email_check_box__c = true;
        jo.Account__c=acc.id;
        update JO;
        
        List<CSS_CampTsbTrp__c> lstcamp = new List<CSS_CampTsbTrp__c>();     
        CSS_CampTsbTrp__c solRec = new CSS_CampTsbTrp__c();
        
        solRec.Type__c='CAM';
        solRec.Doc_Num__c = 'TSB140168';
        solRec.Job_Order__c = JO.id;
        insert solRec;
        
        CSS_CampTsbTrp__c solRec1 = new CSS_CampTsbTrp__c();
        
        solRec1.Type__c='TRP';
        solRec1.Doc_Num__c = 'TSB140168';
        solRec1.Job_Order__c = JO.id;
        insert solRec1;
        
        CSS_CampTsbTrp__c solRec2 = new CSS_CampTsbTrp__c();
        
        solRec2.Type__c='TSB';
        solRec2.Doc_Num__c = 'TSB140168';
        solRec2.Job_Order__c = JO.id;
        insert solRec2;
        CSS_CampTsbTrp__c solRec23 = new CSS_CampTsbTrp__c();
        
        solRec23.Type__c='ATC';
        solRec23.Doc_Num__c = 'TSB140168';
        solRec23.Job_Order__c = JO.id;
        insert solRec23;
        lstcamp.add(solRec1);
        lstcamp.add(solRec2);
        lstcamp.add(solRec);
        lstcamp.add(solRec23);
        Test.StartTest();
        PageReference p=Page.CSS_JobRepair; 
        Test.setCurrentPage(p);  
        ApexPages.currentPage().getParameters().put('id',jo.Id);  
        css_repair_job TriageJob1= new css_repair_job ();
        CG_cancelServiceJobWrapper csjw = new CG_cancelServiceJobWrapper();
        csjw.errorFlag=false;
        csjw.errorMessage='';
        csjw.serviceJob=jo;
        TriageJob1.atthId=attach.id;
        TriageJob1.css_redirect();
        TriageJob1.repair_vh();
        TriageJob1.getModel();
        TriageJob1.getMake();
        TriageJob1.repair_vi();
        TriageJob1.repair_jo();
        TriageJob1.repair_rj();
        TriageJob1.repair_rm();
        TriageJob1.pgsave();
        TriageJob1.higherdateErrFlag=true;
        TriageJob1.pgCustSave();
        TriageJob1.pgSaveFinish();
        TriageJob1.show_rj_pnl = true;
        TriageJob1.getALLRecords_old();
        TriageJob1.pgSaveAssign();
        TriageJob1.pgCustSave();
        TriageJob1.pgUISave();
        TriageJob1.pgCompSave();
        TriageJob1.getALLRecords();
        TriageJob1.getALLRecords_old();
        TriageJob1.getcamps();
        TriageJob1.getTrps();
        TriageJob1.getTsbs();
        TriageJob1.getAtcs();
        //TriageJob1.saveCheckBox();
        Blob fileBody=Blob.valueOf('Test Body');
        Blob fileBody2=Blob.valueOf('Test Body2');
        Blob fileBody3=Blob.valueOf('Test Body3');
        TriageJob1.fileBody = fileBody;
        TriageJob1.fileBody2 = fileBody2;
        TriageJob1.fileBody3 = fileBody3;
        TriageJob1.fileName = 'Test';
        TriageJob1.fileName2 = 'Test1';
        TriageJob1.fileName3 = 'Test2';
        TriageJob1.description1 = 'Test desc1';
        TriageJob1.description2 = 'Test desc2';
        TriageJob1.description3 = 'Test desc3';
        TriageJob1.processUpload();
        TriageJob1.saveStandardAttachment(jo.Id);
        Test.StopTest();
        CSS_EDSAuthentication.exitDSID('1234-5678','DSBDT4780'); 
        
    }
    private static testMethod void css_repair_job_Test_Method3() {
        Test.StartTest();
        TestData();
        Account acc = new Account();
        acc.Name = 'bangalore4';
        acc.Enable_Claims__c = true;
        acc.ERP_System__c = 'One BMS';
        acc.CSS_DBCode__c='333334';
        acc.type = 'Customer';
        acc.CSS_DistributorCode__c='111114';
        acc.CMI_Account_Status__c = 'Active';
        acc.IAM_Service_Provider_Code__c='562704';
        
        insert acc;
        CSS_Job_Order__c jo = CSS_TestData.createJobOrder(true);
        jo.Account__c=acc.id;
        update jo;
        CSS_claims__c claims = CSS_TestData.createclaims(true,jo.id);
        claims.Account__c=acc.id;
        update claims;
        CSS_Solutions__c sol = CSS_TestData.createSolutions(true,jo.id);
        CSS_SRT__c srt= CSS_TestData.createSRT_New(true,'Diagnosis',sol.id,jo.id,claims.id);
        srt.Extended_Hours__c = 2.36;
        srt.Solution_Number__c = null;
        update srt;
        
        JO.Customer_Name__c = null;
        
        JO.Make__c = 'XYZ';
        update JO;
        PageReference p=Page.CSS_JobRepair; 
        Test.setCurrentPage(p);  
        ApexPages.currentPage().getParameters().put('id',jo.Id);  
        
        css_repair_job TriageJob1= new css_repair_job ();
        
        
        TriageJob1.atthId=attach.id;
        TriageJob1.showPopup();
        TriageJob1.showRepairBlocks(false,false,false, false, false);
        TriageJob1.closePopup();
        TriageJob1.redirectPopup();
        TriageJob1.showPopup1();
        TriageJob1.closePopup1();
        TriageJob1.showPopup4();
        TriageJob1.closePopup4();
        TriageJob1.showPopup5();
        TriageJob1.closePopup5();
        TriageJob1.showPopup6();
        TriageJob1.closePopup6();
        TriageJob1.showPopup7();
        TriageJob1.closePopup7();
        TriageJob1.updateNotes();
        TriageJob1.getRepair();
        TriageJob1.popupSave();
        TriageJob1.DeleteFile();
        TriageJob1.callRSWlink();
        TriageJob1.getInsiteTimeStamp();
        Test.setMock(HttpCalloutMock.class, new CSS_RPVSecMock_Test());
        TriageJob1.getTrps();
        JO.ESN__c = null;
        update JO;
        TriageJob1.getBMSUnitDetails();
        TriageJob1.selectedBMSUnitNumber();
        TriageJob1.selectedUnitDetails();
        TriageJob1.closeBMSUnitDetails();
        TriageJob1.closeSrvModPopup();
        TriageJob1.closeSrvModPopup1();
        TriageJob1.isPrioritized = false;
        TriageJob1.displaycertPopup = true;
        TriageJob1.displayPopup8 = true;
        TriageJob1.dsidStatus = true;
        TriageJob1.rowcount = 2;
        TriageJob1.timeinMinutes=200;
        TriageJob1.timeinhours=2;
        TriageJob1.dispDTime='4';
        TriageJob1.NewdigTime=5.0;
        TriageJob1.NewdigMin=6;
        TriageJob1.NewrepMin=7;
        TriageJob1.bmsEnabled = true;
        TriageJob1.showRepairErrorMessage= true;
        TriageJob1.comm = 'Test';
        //TriageJob1.saveCheckBox();
        TriageJob1.showRepairBlocks(false,false,false, false, true);
        TriageJob1.pgSaveAssign();
        TriageJob1.getLocCode();
        Test.StopTest();
    }
    private static testMethod void css_repair_job_Test_Method5() {
        Test.StartTest();
        Account acc = new Account();
        acc.Name = 'bangalore3';
        acc.Enable_Claims__c = true;
        acc.ERP_System__c = 'One BMS';
        acc.CSS_DBCode__c='333333';
        acc.type = 'Customer';
        acc.CSS_DistributorCode__c='111113';
        acc.CMI_Account_Status__c = 'Active';
        acc.IAM_Service_Provider_Code__c='562703';
        
        insert acc;
        TestData();
        JO.Category__c = null;
        JO.Make__c = 'XYZ';
        jo.Account__c=acc.id;
        update JO;
        PageReference p=Page.CSS_JobRepair; 
        Test.setCurrentPage(p);  
        ApexPages.currentPage().getParameters().put('id',jo.Id);
        css_repair_job TriageJob1= new css_repair_job ();
        TriageJob1.showRepairBlocks(false,false,false, false, true);
        TriageJob1.pgSaveAssign();
        Test.StopTest();
    }
    private static testMethod void css_repair_job_Test_Method6() {
        Test.StartTest();
        TestData();
        Account acc = new Account();
        acc.Name = 'bangalore2';
        acc.Enable_Claims__c = true;
        acc.ERP_System__c = 'One BMS';
        acc.CSS_DBCode__c='333332';
        acc.type = 'Customer';
        acc.CSS_DistributorCode__c='111112';
        acc.CMI_Account_Status__c = 'Active';
        acc.IAM_Service_Provider_Code__c='562702';
        
        insert acc;
        JO.Application__c = null;
        JO.Make__c = 'XYZ';
        jo.Account__c=acc.id;
        update JO;
        PageReference p=Page.CSS_JobRepair; 
        Test.setCurrentPage(p);
        ApexPages.currentPage().getParameters().put('id',jo.Id);
        css_repair_job TriageJob1= new css_repair_job ();
        TriageJob1.showRepairBlocks(false,false,false, false, true);
        TriageJob1.pgSaveAssign();
        Test.StopTest();
    }
    private static testMethod void css_repair_job_Test_Method7() {
        TestData();
        CSS_TestData.createAccountLanguage(true);
        Test.StartTest();
        Profile p1 = [SELECT Id FROM Profile WHERE Name='CSS_Service_Advanced']; 
        User u = new User(Alias = 'standt', Email='standarduser1@testorg.com',User_Location__c = 'abc', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p1.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTestUser1@testorg.com');
        insert u;
        
        Account x = new Account();
        x.WR_Certfication_Flag__c = 'st';
        x.Name = 'acs';
        x.CSS_DBCode__c = '';
        x.CSS_DistributorCode__c = 'abc';
        x.CSS_DealerCode__c= 'abc';
        x.Type = 'Customer';
        insert x;
        
        
        PageReference p=Page.CSS_JobRepair; 
        Test.setCurrentPage(p);  
        system.debug('Job Order >>>'+jo.Id);
        
        ApexPages.currentPage().getParameters().put('id',jo.Id);
        css_repair_job TriageJob1= new css_repair_job ();
        TriageJob1.showRepairs = false;
        TriageJob1.showResolutionWithRepair = true;
        TriageJob1.showRepairBlocks(false,false,false, false, true);
        TriageJob1.pgSaveAssign();
        Attachment acc= new Attachment ();
        acc.parentid=jo.Id;
        acc.Name='test';
        acc.Body=Blob.valueof('test');
        insert acc;
        TriageJob1.atthId =acc.id;
        TriageJob1.delAttachment();
        system.debug('Job Order >>>3'+jo.Id);
        TriageJob1.Wid=ApexPages.CurrentPage().getParameters().get('id');
        TriageJob1.siebelSMN = 'siebelSMN';
        TriageJob1.siebVIN = 'siebVIN';
        TriageJob1.siebAppCode = 'siebAppCode';
        CSS_Job_Order__c cjo = CSS_TestData.createJobOrder(true);
        cjo.Customer_Name__c = 'varun';
        cjo.DSID_UpdateTimestamp__c=System.now();
        cjo.INSITE_UpdateTimeStamp__c=System.now();
        cjo.Application__c = 'XYZ';
        cjo.Customer_Name__c = 'XYZ';
        cjo.ESN__c = 'XYZ';
        cjo.Make__c = 'XYZ';
        cjo.Model__c = 'XYZ';
        cjo.Category__c = 'XYZ';
        system.debug('id>>>>>>>>>'+cjo.id);
        update cjo; 
        CSS_Accreditation__c accredInfo = new CSS_Accreditation__c();
        accredInfo.Service_Model_Name__c = 'test';
        accredInfo.Certification_Status__c  = 'test';
        accredInfo.Account__c = x.id;
        insert accredInfo;
        CSS_Fault_Code_Master__c fcmaster = new CSS_Fault_Code_Master__c();
        fcmaster.Fault_Code_Description__c ='Ttest1';
        insert fcmaster;
        List<CSS_Fault_Code__c> lstfault = new List<CSS_Fault_Code__c>();
        CSS_Fault_Code__c fau = new CSS_Fault_Code__c();
        fau.Job_Order__c = cjo.id;
        fau.Sequence__c=30;
        fau.Primary_Fault_Code__c =145;
        fau.Related_Fault_Code__c='150,151,152';
        fau.Fault_Code_Type__c='APD';
        fau.Fault_Code__c = fcmaster.Id;
        lstfault.add(fau);
        insert lstfault;
        TriageJob1.closeSession();
        TriageJob1.jobClosePopup();
        TriageJob1.saveAndCloseJob();
        TriageJob1.getTsbs();
        string dt='1'+'-'+'2'+'-'+'2016';
        TriageJob1.parseQSOLDate(dt);
        Cache.Session.put('local.CSSPartition.UserPrimaryLocationCode','abc-abc'); 
        String UserLocation = (String)Cache.Session.get('local.CSSPartition.UserPrimaryLocationCode'); 
        TriageJob1.gettoken();
        TriageJob1.saveAndCloseJob();
        PageReference p2=Page.CSS_JobRepair; 
        Test.setCurrentPage(p2);  
        system.debug('Job Order1 >>>'+jo.Id);
        ApexPages.currentPage().getParameters().put('id',jo.Id);
        css_repair_job TriageJob2= new css_repair_job ();
        TriageJob2.showRepairBlocks(false,false,false, false, true);
        TriageJob2.pgSaveAssign();
        String newQuote='BMS-1';
        TriageJob2.createQuote(newQuote);
        TriageJob2.higherdateErrFlag=true;
        TriageJob2.CompareDates();
        TriageJob2.onChangeBIS();
        TriageJob2.getFailureDate();
        Test.StopTest();
    }
    private static testMethod void css_repair_job_Test_Method_TestData() {
        TestData();
        CSS_TestData.createAccountLanguage(true);
        Test.StartTest();
        
        Profile p1 = [SELECT Id FROM Profile WHERE Name='CSS_Service_Advanced']; 
        User u = new User(Alias = 'standt', Email='standarduser1@testorg.com',User_Location__c = 'abc', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p1.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTestUser1@testorg.com');
        insert u;
        
        Account x = new Account();
        x.WR_Certfication_Flag__c = 'st';
        x.Name = 'acs';
        x.CSS_DBCode__c = '';
        x.CSS_DistributorCode__c = 'abc';
        x.CSS_DealerCode__c= 'abc';
        x.Type= 'Customer';
        insert x;
        
        
        PageReference p=Page.CSS_JobRepair; 
        Test.setCurrentPage(p);  
        system.debug('Job Order >>>'+jo.Id);
        
        ApexPages.currentPage().getParameters().put('id',jo.Id);
        css_repair_job TriageJob1= new css_repair_job ();
        TriageJob1.showRepairs = false;
        TriageJob1.showResolutionWithRepair = true;
        TriageJob1.showRepairBlocks(false,false,false, false, true);
        TriageJob1.pgSaveAssign();
        
        Attachment acc= new Attachment ();
        acc.parentid=jo.Id;
        acc.Name='test';
        acc.Body=Blob.valueof('test');
        insert acc;
        TriageJob1.atthId =acc.id;
        TriageJob1.delAttachment();
        system.debug('Job Order >>>3'+jo.Id);
        TriageJob1.Wid=ApexPages.CurrentPage().getParameters().get('id');
        TriageJob1.siebelSMN = 'siebelSMN';
        TriageJob1.siebVIN = 'siebVIN';
        TriageJob1.siebAppCode = 'siebAppCode';
        CSS_Job_Order__c cjo = CSS_TestData.createJobOrder(true);
        cjo.Customer_Name__c = 'varun';
        cjo.DSID_UpdateTimestamp__c=System.now();
        cjo.INSITE_UpdateTimeStamp__c=System.now();
        cjo.Application__c = 'XYZ';
        cjo.Customer_Name__c = 'XYZ';
        cjo.ESN__c = 'XYZ';
        cjo.Make__c = 'XYZ';
        cjo.Model__c = 'XYZ';
        cjo.Category__c = 'XYZ';
        cjo.CSS_Job_Location_Code__c='03520-04892';
        // cjo.Location_Code__c='03520-04892';
        cjo.Customer_Code__c='test';
        cjo.Shop_Work_Order__c='test';
        system.debug('id>>>>>>>>>'+cjo.id);
        update cjo; 
        CSS_Accreditation__c accredInfo = new CSS_Accreditation__c();
        accredInfo.Service_Model_Name__c = 'test';
        accredInfo.Certification_Status__c  = 'test';
        accredInfo.Account__c = x.id;
        insert accredInfo;
        CSS_Fault_Code_Master__c fcmaster = new CSS_Fault_Code_Master__c();
        fcmaster.Fault_Code_Description__c ='Ttest1';
        insert fcmaster;
        List<CSS_Fault_Code__c> lstfault = new List<CSS_Fault_Code__c>();
        CSS_Fault_Code__c fau = new CSS_Fault_Code__c();
        fau.Job_Order__c = cjo.id;
        fau.Sequence__c=30;
        fau.Primary_Fault_Code__c =145;
        fau.Related_Fault_Code__c='150,151,152';
        fau.Fault_Code_Type__c='APD';
        fau.Fault_Code__c = fcmaster.Id;
        lstfault.add(fau);
        insert lstfault;
        
        List<CSS_Solutions__c> cssSol = new List<CSS_Solutions__c>();
        CSS_Solutions__c cssSol1 = new CSS_Solutions__c();
        cssSol1.Name = 'K16491166';
        cssSol1.Service_Job__c = cjo.id;
        cssSol1.FaultCode__c = lstfault[0].id;
        cssSol1.Solution_Title__c = 'Check engine build date for possible update to VGT actuator calibration';
        cssSol1.Repair_Response__c = 'Not the correct solution';
        cssSol.add(cssSol1);
        insert cssSol;
        
        TriageJob1.responseValues = cssSol;
        
        TriageJob1.closeSession();
        TriageJob1.jobClosePopup();
        TriageJob1.showRepairs = true;
        TriageJob1.showResolutionWithRepair = false;
        TriageJob1.responseValues = cssSol;
        TriageJob1.saveAndCloseJob();
        TriageJob1.getTsbs();
        string dt='1'+'-'+'2'+'-'+'2016';
        TriageJob1.parseQSOLDate(dt);
        Cache.Session.put('local.CSSPartition.UserPrimaryLocationCode','abc-abc'); 
        String UserLocation = (String)Cache.Session.get('local.CSSPartition.UserPrimaryLocationCode'); 
        
        TriageJob1.gettoken();
        TriageJob1.saveAndCloseJob();
        
        PageReference p2=Page.CSS_JobRepair; 
        Test.setCurrentPage(p2);  
        system.debug('Job Order1 >>>'+jo.Id);
        ApexPages.currentPage().getParameters().put('id',jo.Id);
        css_repair_job TriageJob2= new css_repair_job ();
        TriageJob2.showRepairBlocks(false,false,false, false, true);
        TriageJob2.pgSaveAssign();
        String newQuote='BMS-1';
        TriageJob2.createQuote(newQuote);
        TriageJob2.higherdateErrFlag=true;
        TriageJob2.CompareDates();
        TriageJob2.onChangeBIS();
        TriageJob2.getFailureDate();
        
        Test.StopTest();
    }
    static testMethod void engineDataSiebel(){ 
        
        Test.setMock(HttpCalloutMock.class, new CSS_getEngineDataFrmSiebel_Test());
        Test.setMock(WebServiceMock.class, new CSS_GetEngineDataPlate_Test()); 
        css_repair_job IntakeJobRstartReq = new css_repair_job ();
        CSS_Job_Order__c JOsr= new CSS_Job_Order__c ();
        JOsr.ESN__c='79384192'; 
        insert JOsr;
        
        Test.startTest();
        IntakeJobRstartReq.workJob=JOsr;
        CSS_getEngineDataReqJ2A wrapobj = new CSS_getEngineDataReqJ2A();
        CSS_getEngineDataResponseJ2A  engineData;
        CSS_getEngineDataReqJ2A.DataArea jidi = new CSS_getEngineDataReqJ2A.DataArea();
        jidi.ESN =JOsr.ESN__c;
        wrapobj.DataArea = jidi;
        
        
        engineData = CSS_WS_SBL.getEngineData(wrapobj);    
        IntakeJobRstartReq.startRequest();
        Test.stopTest();
    }
    static testMethod void callCreateWoAndUpdateCommentTest(){
        
        
        Test.setMock(HttpCalloutMock.class, new CSS_MockHttpResponseGenerator()); 
        CSS_unitInboundJSON2Apex unj = new CSS_unitInboundJSON2Apex();
        CSS_unitInboundJSON2Apex.DataArea jidi = new CSS_unitInboundJSON2Apex.DataArea();
        unj.DataArea = jidi;
        jidi.UnitNumber = 'ERT23';
        
        CSS_Job_Order__c JOsr1= new CSS_Job_Order__c ();
        JOsr1.ESN__c='79384192';
        JOsr1.Customer_Code__c = '45677';
        JOsr1.Unit_Number__c = '123';
        JOsr1.Application__c = 'Automotive';
        JOsr1.Customer_Code__c = '12345';
        JOsr1.Model__c = 'EXTR';
        JOsr1.Make__c = 'DFRT';
        JOsr1.VIN__c = 'WER';
        JOsr1.Service_Model__c = 'DFRTY';
        JOsr1.Qsol_Engine_Family_Code__c = 'CDFGH';
        JOsr1.Unit_Type__c = 'SWERT';
        JOsr1.Repair_Location__c ='Mobile';
        JOsr1.Shop_Work_Order__c = '1234';
        JOsr1.BMSWSStatus__c = 'UI1';
        JOsr1.BMSStatus__c = 'pass';
        insert JOsr1;
        string scode3=css_utility.getCodes('Application Code','Automotive',null,null);
        
        
        
        css_repair_job rep = new css_repair_job ();
        rep.workjob = [Select Id,Name,Customer_Name__c,Customer_Code__c,Shop_Work_Order__c,Cstmr_Contacts_Phone__c,Address__c,City__c,CSS_State__c,ZipCode__c,Country__c,CSS_Charge_Account_Status__c,Sub_Type__c,Application__c,DSID_WorkGroup__c, Unit_Number__c,BMSWSStatus__c,BMSStatus__c, Unit_Type__c, Date_in__c, INSITE_UpdateTimeStamp__c,
                       First_Name__c,BMS_Last_Name__c,Failure_Date__c, Failure_Point__c, Failure_Point_Measure__c, Service_Model__c, VIN__c, Warranty_Start_Date__c,Make__c, Qsol_Engine_Family_Code__c,Repair_Location__c,
                       DSID__c, DSID_Creation_Timestamp__c, DSID_Status__c, Repeat_Or_Recent_Calc__c, DSID_UpdateTimestamp__c,Status__c,
                       Phone_Number__c,Previous_Status__c, Category__c, Complaint_Type__c,Category2__c,Complaint_Type2__c,Category3__c,Complaint_Type3__c,Category4__c,Complaint_Type4__c,Category5__c,Complaint_Type5__c,Preventive_Maintenance__c,Expedited_Service__c, Model__c,Creator_Location__c, Control_Number__c,
                       Assigned_to__r.Name,Additional_Tech1__r.Name,Additional_Tech2__r.Name,OwnerId,JobLocation__c,ESN_Locked__c,
                       ESN__c, Mileage__c, Mileage_Measure__c, chevron_page__c, General_Symptoms__c, Assigned_To__c, LastModifiedDate,CreatedDate,
                       (Select Id,Body,title,CreatedBy.firstname,CreatedBy.lastname,CreatedDate from Notes)
                       from CSS_Job_Order__c where id= :JOsr1.id];
        
        Test.startTest();
        
        rep.callCreateWoAndUpdateComment();
        Test.stopTest();
        
        
    }
    static testMethod void qsollanguageTest(){
        Account acc = new Account();
        acc.Name = 'bangalore';
        acc.Enable_Claims__c = true;
        acc.ERP_System__c = 'One BMS';
        acc.CSS_DBCode__c='33333';
        acc.type = 'Customer';
        acc.CSS_DistributorCode__c='11111';
        acc.CMI_Account_Status__c = 'Active';
        acc.IAM_Service_Provider_Code__c='56270';
        
        insert acc;
        CSS_Job_Order__c SerRec1 = CSS_TestData.createJobOrder(True);
        serrec1.Account__c=acc.id;
        update serrec1;
        CSS_accountLanguage__c acclang = new CSS_accountLanguage__c();
        acclang.CSS_QsolLanguage__c = 'en_US';
        list<CSS_CampTsbTrp__c> lstQSOLDocs = new list<CSS_CampTsbTrp__c>();
        
        CSS_CampTsbTrp__c cam = new CSS_CampTsbTrp__c();
        cam.Name = 'ABC';
        cam.Job_Order__c = SerRec1.id;
        cam.ESN__c = '79464646';
        cam.Doc_Num__c = '1';
        cam.Cu_Language__c = 'en';
        insert cam;
        lstQSOLDocs.add(cam);
        system.debug('cam:' + cam);
        Test.setMock(WebServiceMock.class, new CSS_GetWarrantyDocs_Test());
        CSS_QuickServe.getQsolDocSaveLang(SerRec1.Id,SerRec1.ESN__c, acclang.CSS_QsolLanguage__c);
        
        ApexPages.currentPage().getParameters().put('id', SerRec1.Id);
        css_repair_job rep = new css_repair_job ();
        
        Test.startTest();
        
        Test.stopTest();
        
    }
    static testmethod void historyjobs(){
        TestData();
        
        Test.startTest();
        css_repair_job TriageJob1= new css_repair_job ();
        TriageJob1.getViewHistory();
        TriageJob1.getSubType();
        TriageJob1.getUnitType();
        TriageJob1.saveCampNotesCheckBox();
        
        Test.stopTest();
        
    }
    static testmethod void propertys(){
        TestData();
        
        Test.startTest();
        css_repair_job TriageJob1= new css_repair_job ();
        TriageJob1.BMSCustSearchPopup = true;
        CSS_customerOutboundJSON2Apex  cd = new CSS_customerOutboundJSON2Apex();
        TriageJob1.customerDetail = cd;
        List<CSS_customerOutboundJSON2Apex.DataArea> pcd = new List<CSS_customerOutboundJSON2Apex.DataArea>();
        TriageJob1.paginatedCustDetails = pcd;
        TriageJob1.fullCustDetails = pcd;
        TriageJob1.selectedCustCode = 'test';
        TriageJob1.strCntry = 'test';
        TriageJob1.strCntryState = 'test';
        TriageJob1.selectedCustDetails();
        List<CSS_CampTsbTrp__c> vvv = new List<CSS_CampTsbTrp__c>();
        TriageJob1.lstTRP = vvv;
        TriageJob1.lstTSB = vvv;
        TriageJob1.lstATC = vvv;
        css_job_order__c cj = new css_job_order__c();
        TriageJob1.closeJob = cj;
        TriageJob1.showResolution = true;
        TriageJob1.showRepairs = true;
        TriageJob1.nocamptsbtrps = true;
        list<CSS_Solutions__c> so = new list<CSS_Solutions__c>();
        TriageJob1.solutions = so;
        TriageJob1.responseValues = so;
        TriageJob1.newQuoteStr = '{get;set;}';
        TriageJob1.countquote = 500;
        List<selectOption> ro = new List<selectOption>();
        TriageJob1.responseOptions = ro;
        TriageJob1.resolutionOptions = ro;
        
        TriageJob1.reqUNumBoolean = true;
        TriageJob1.reqCusNumBoolean = true;
        TriageJob1.reqFrstNamBoolean = true;
        TriageJob1.reqLastNamBoolean = true;
        TriageJob1.reqCstmrContactPhnBoolean = true;
        TriageJob1.reqUTBoolean = true;
        TriageJob1.allFieldsValidate = true;
        string dt='1'+'-'+'3'+'-'+'2016';
        TriageJob1.parseQSOLDate(dt);
        user userlang1 = new user();
        TriageJob1.userlang = userlang1;
        
        list<CSS_CampTsbTrp__c> campList1 = new list<CSS_CampTsbTrp__c>();
        TriageJob1.campList = campList1;
        
        CSS_unitInboundJSON2Apex UIResp1 = new CSS_unitInboundJSON2Apex();
        TriageJob1.UIResp = UIResp1;
        TriageJob1.bmscustErrorMessage = 'sffs';
        
        TriageJob1.BMSContactSearchPopup = true;
        TriageJob1.contactshowOutageError= true;
        TriageJob1.bmsContacterrorMessage ='{get;set;}';
        CSS_BMSContactLookupResponseJ2A CustomerContactDetails1 = new CSS_BMSContactLookupResponseJ2A();
        TriageJob1.CustomerContactDetails = CustomerContactDetails1;
        
        Test.stopTest();
        
    }
    static testmethod void property1(){
        TestData();
        jo.Warranty_Start_Date__c=System.today();
        update jo;
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
        
        ApexPages.currentPage().getParameters().put('id',jo.Id); 
        
        PageReference p=Page.CSS_JobRepair; 
        Test.setCurrentPage(p);  
        ApexPages.currentPage().getParameters().put('id',jo.Id); 
        CSS_JobEventTemporary__c jobEvent =CSS_TestData.createJobEventTempObj(false);
        jobEvent.attribute1__c ='ApplicationCodes';
        jobEvent.Reason__c='{"DataArea":{"Details":[{"Description":"AUTOMOTIVE (C-OVER 225 HP)","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"120","MarineFlag":"N","DefaultUom":""},{"Description":"AUTOMOTIVE","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"Y","ApplicationCode":"130","MarineFlag":"N","DefaultUom":""},{"Description":"BUS","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"200","MarineFlag":"N","DefaultUom":""},{"Description":"WORLDWIDE BUS(EXC.US & CANADA SCHOOL BUS","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"Y","ApplicationCode":"210","MarineFlag":"N","DefaultUom":""},{"Description":"SCHOOL BUS (US & CANADA)","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"Y","ApplicationCode":"220","MarineFlag":"N","DefaultUom":""},{"Description":"RECREATIONAL VEHICLE","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"300","MarineFlag":"N","DefaultUom":""},{"Description":"FIRE TRUCK","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"400","MarineFlag":"N","DefaultUom":""},{"Description":"FIRE TRUCK","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"Y","ApplicationCode":"410","MarineFlag":"N","DefaultUom":""},{"Description":"OBSOLETE - TEMP VALUE ONLY","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"420","MarineFlag":"N","DefaultUom":""},{"Description":"INDUSTRIAL","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"500","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"MARINE","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"600","MarineFlag":"Y","DefaultUom":""},{"Description":"OBSOLETE-TEMP VALUE ONLY(0605)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"605","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"MARINE - RECREATIONAL(ALL ENG)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"Y","ApplicationCode":"610","MarineFlag":"Y","DefaultUom":"Hours"},{"Description":"MARINE (INTERMITTENT DUTY)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"Y","ApplicationCode":"620","MarineFlag":"Y","DefaultUom":"Hours"},{"Description":"MARINE DIVISION OF BRUNSWICK","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"625","MarineFlag":"Y","DefaultUom":"Hours"},{"Description":"OBSOLETE-TEMP VALUE ONLY(0645)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"645","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"MARINE(MEDIUM CONTINUOUS DUTY)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"Y","ApplicationCode":"650","MarineFlag":"Y","DefaultUom":"Hours"},{"Description":"MARINE (HEAVY DUTY)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"Y","ApplicationCode":"655","MarineFlag":"Y","DefaultUom":"Hours"},{"Description":"MARINE (CONTINUOUS POWER)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"665","MarineFlag":"Y","DefaultUom":"Hours"},{"Description":"AGRICULTURE","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"700","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"OBSOLETE-TEMP VALUE ONLY(0710)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"710","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"OBSOLETE-TEMP VALUE ONLY(0720)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"720","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"GENERATOR DRIVE","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"800","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"G-Drive Engine Standby","BusinessUnit":"CMI","AutomotiveFlag":"N","ActiveFlag":"Y","ApplicationCode":"810","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"G-Drive Engine Prime","BusinessUnit":"CMI","AutomotiveFlag":"N","ActiveFlag":"Y","ApplicationCode":"820","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"GENERATOR DRIVE (LIMITED PRIME POWER)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"830","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"GENERATOR DRIVE (CONTINUOUS/BASE POWER)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"840","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"MILITARY PACKAGES","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"900","MarineFlag":"N","DefaultUom":""},{"Description":"BRADLEY FIGHTING VEHICLE, LVTP71, OR M9A","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"910","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"5 TON ARMY TRUCK (M939) (NHC250)","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"920","MarineFlag":"N","DefaultUom":""},{"Description":"AIR FORCE R11 FUEL TANKER","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"930","MarineFlag":"N","DefaultUom":""},{"Description":"5 TON ARMY TRUCK (M939A2) (6CTA 8.3)","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"940","MarineFlag":"N","DefaultUom":""},{"Description":"NTTA-855-P40 PETRO PUMP ENGINE","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"950","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"TRAKS MILITARY FORKLIFT","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"960","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"0AUTOMOTIVE","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"10","MarineFlag":"N","DefaultUom":""},{"Description":"0AUTOMOTIVE (C--UP TO 225 HP)","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"11","MarineFlag":"N","DefaultUom":""},{"Description":"0AUTOMOTIVE (C--OVER 225 HP)","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"12","MarineFlag":"N","DefaultUom":""},{"Description":"0AUTOMOTIVE (OTHER THAN C-SERIES)","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"13","MarineFlag":"N","DefaultUom":""},{"Description":"0BUS","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"20","MarineFlag":"N","DefaultUom":""},{"Description":"0BUS (INTERCITY COACH, SHUTTLE AND TRANS","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"21","MarineFlag":"N","DefaultUom":""},{"Description":"0BUS (SCHOOL BUS)","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"22","MarineFlag":"N","DefaultUom":""},{"Description":"0BUS (COMPRESSED OR NATURAL GAS)","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"23","MarineFlag":"N","DefaultUom":""},{"Description":"0RECREATIONAL VEHICLE","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"30","MarineFlag":"N","DefaultUom":""},{"Description":"1RECREATIONAL VEHICLE","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"31","MarineFlag":"N","DefaultUom":""},{"Description":"0FIRE TRUCK","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"40","MarineFlag":"N","DefaultUom":""},{"Description":"0FIRE TRUCK (STANDARD COVERAGE)","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"41","MarineFlag":"N","DefaultUom":""},{"Description":"0FIRE TRUCK (SPECIAL PARTS-ONLY COVERAGE","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"42","MarineFlag":"N","DefaultUom":""},{"Description":"0INDUSTRIAL","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"50","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"0INDUSTRIAL (EXC. MARINE, AG, GEN DRIVE","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"51","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"5MARINE - DIAMOND EDITION ENGINES","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"60","MarineFlag":"Y","DefaultUom":"Hours"},{"Description":"0MARINE (RECR./LT DUTY COMMERCIAL - PERS","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"61","MarineFlag":"Y","DefaultUom":"Hours"},{"Description":"5MARINE-RECREATIONAL (HIGH OUTPUT RATING","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"62","MarineFlag":"Y","DefaultUom":"Hours"},{"Description":"5MARINE-RECREATIONAL (RECREATIONAL RATIN","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"63","MarineFlag":"Y","DefaultUom":"Hours"},{"Description":"5MARINE-COMMERCIAL (INTERMITTENT RATING)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"64","MarineFlag":"Y","DefaultUom":"Hours"},{"Description":"5MARINE-COMMERCIAL (MEDIUM CONTINUOUS RA","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"65","MarineFlag":"Y","DefaultUom":"Hours"},{"Description":"5MARINE-COMMERCIAL (CONTINUOUS RATING)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"66","MarineFlag":"Y","DefaultUom":"Hours"},{"Description":"0AGRICULTURE","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"70","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"0MOBILE FARM EQUIPMENT / IRRIGATION PUMP","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"71","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"0FARM EQUIPMENT (NON MOBILE)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"72","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"0GENERATOR DRIVE","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"80","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"0GENERATOR DRIVE (STANDBY POWER)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"81","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"0GENERATOR DRIVE (UNLIMITED PRIME POWER)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"82","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"0GENERATOR DRIVE (LIMITED PRIME POWER)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"83","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"0GENERATOR DRIVE (CONTINUOUS/BASE POWER)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"84","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"0MILITARY PACKAGES","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"90","MarineFlag":"N","DefaultUom":""},{"Description":"0BRADLEY FIGHTING VEHICLE, LVTP71, OR M9","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"91","MarineFlag":"N","DefaultUom":""},{"Description":"05 TON ARMY TRUCK (M939) (NHC250)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"92","MarineFlag":"N","DefaultUom":""},{"Description":"0AIR FORCE R11 FUEL TANKER","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"93","MarineFlag":"N","DefaultUom":""},{"Description":"05 TON ARMY TRUCK (M939A2) (6CTA 8.3)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"94","MarineFlag":"N","DefaultUom":""},{"Description":"0NTTA-855-P40 PETRO PUMP ENGINE","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"95","MarineFlag":"N","DefaultUom":""},{"Description":"0TRAKS MILITARY FORKLIFT","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"96","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"AUTOMOTIVE","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"100","MarineFlag":"N","DefaultUom":""},{"Description":"AUTOMOTIVE (C-UP TO 225 HP)","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"110","MarineFlag":"N","DefaultUom":""},{"Description":"BUS (COMPRESSED OR NATURAL GAS)","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"230","MarineFlag":"N","DefaultUom":""},{"Description":"RECREATIONAL VEHICLE","BusinessUnit":"CMI","AutomotiveFlag":"Y","ActiveFlag":"Y","ApplicationCode":"310","MarineFlag":"N","DefaultUom":""},{"Description":"WORLDWIDE OFF-HIGHWAY","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"Y","ApplicationCode":"510","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"MARINE (PRIME/CONTINUOS PRIME POWER)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"Y","ApplicationCode":"635","MarineFlag":"Y","DefaultUom":"Hours"},{"Description":"MARINE (CONTINUOUS DUTY)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"Y","ApplicationCode":"660","MarineFlag":"Y","DefaultUom":"Hours"},{"Description":"FORD GRAY AUTO","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"140","MarineFlag":"N","DefaultUom":""},{"Description":"FORD GRAY BUS","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"240","MarineFlag":"N","DefaultUom":""},{"Description":"ISC-SERIES","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"150","MarineFlag":"N","DefaultUom":""},{"Description":"CMD NONQUANTUM - INTERMITTENT","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"621","MarineFlag":"Y","DefaultUom":"Hours"},{"Description":"CMD NONQUANTUM - MEDIUM CONTINUOUS","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"651","MarineFlag":"Y","DefaultUom":"Hours"},{"Description":"CMD NONQUANTUM - HEAVY DUTY","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"656","MarineFlag":"Y","DefaultUom":"Hours"},{"Description":"CMD NONQUANTUM - CONTINUOUS","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"661","MarineFlag":"Y","DefaultUom":"Hours"},{"Description":"RECREATIONAL VEHICLE AD","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"Y","ApplicationCode":"320","MarineFlag":"N","DefaultUom":""},{"Description":"KA91 MARINE GENERIC","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"Y","ApplicationCode":"890","MarineFlag":"Y","DefaultUom":"Hours"},{"Description":"CMD QUANTUM - RECREATIONAL","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"670","MarineFlag":"Y","DefaultUom":"Hours"},{"Description":"CMD QUANTUM - INTERMITTENT","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"675","MarineFlag":"Y","DefaultUom":"Hours"},{"Description":"CMD QUANTUM - GOVERNMENT SERVICE","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"680","MarineFlag":"Y","DefaultUom":"Hours"},{"Description":"CMD QUANTUM - MEDIUM CONTINUOUS","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"685","MarineFlag":"Y","DefaultUom":"Hours"},{"Description":"CMD QUANTUM - HEAVY DUTY","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"690","MarineFlag":"Y","DefaultUom":"Hours"},{"Description":"CMD QUANTUM - CONTINUOUS","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"695","MarineFlag":"Y","DefaultUom":"Hours"},{"Description":"KA91 GENERATOR DRIVE GENERIC","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"Y","ApplicationCode":"891","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"WORLDWIDE WELDER COVERAGE","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"Y","ApplicationCode":"520","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"G-Drive (HHP Lean-Burn Gas)","BusinessUnit":"CMI","AutomotiveFlag":"N","ActiveFlag":"Y","ApplicationCode":"850","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"THOMAS BUILT BUS","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"250","MarineFlag":"N","DefaultUom":""},{"Description":"CMD QUANTUM - LIGHT COMMERCIAL","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"699","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"MARINE (LIGHT COMMERCIAL)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"Y","ApplicationCode":"662","MarineFlag":"Y","DefaultUom":"Hours"},{"Description":"MARINE (GOVERNMENT SERVICE)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"Y","ApplicationCode":"663","MarineFlag":"Y","DefaultUom":"Hours"},{"Description":"QSK95 T4 LOCOMOTIVE","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"Y","ApplicationCode":"530","MarineFlag":"N","DefaultUom":"Hours"}]},"Header":{"ReturnCodeDescription":"","Status":"Success"';
            jobEvent.Reason__c ='{'+
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
        insert jobEvent;
        CSS_JobEventTemporary__c jobEvent12 =CSS_TestData.createJobEventTempObj(false);
        jobEvent12.attribute1__c ='CategoryComplaintCodes';
        jobEvent12.Reason__c = '{'+    
            '  \"Header\": {'+
            '    \"ReturnCodeDescription\": \"test\",'+
            '    \"Status\": \"completed\"'+
            '      },'+
            '\"DataArea\": {'+
            '\"Details\": ['+
            '{'+
            '\"ComplaintCode\": \"1117\",'+
            '\"ActiveFlag\": \"Y\",'+           
            '\"Description\": \"21319736\",'+
            
            '\"BusinessUnit\": \"inactive\",'+
            '\"Category\": \"F\"'+
            '},'+
            '{'+
            '\"ComplaintCode\": \"1117\",'+
            '\"ActiveFlag\": \"Y\",'+            
            '\"Description\": \"21319736\",'+
            '\"BusinessUnit\": \"inactive\",'+
            
            '\"Category\"    : \"F\"'+
            '},'+
            '{'+
            '\"ComplaintCode\": \"1117\",'+
            '\"ActiveFlag\": \"Y\",'+            
            '\"Description\": \"21319736\",'+
            
            '\"BusinessUnit\": \"inactive\",'+
            '\"Category\"    : \"F\"'+
            '},'+
            '{'+
            '\"ComplaintCode\": \"1117\",'+
            '\"ActiveFlag\": \"Y\",'+            
            '\"Description\": \"21319736\",'+
            
            '\"BusinessUnit\": \"inactive\",'+
            '\"Category\"    : \"F\"'+
            '}'+
            
            ']'+
            '}'+
            '}';
        insert jobEvent12;
        
        
        css_repair_job TriageJob1= new css_repair_job ();
        TriageJob1.vMore_JobId = jo.Id;
        TriageJob1.jobId= jo.Id;
        string dt='1'+'-'+'4'+'-'+'2016';
        
        TriageJob1.parseQSOLDate(dt);
        TriageJob1.delAttachment();
        TriageJob1.editAttachment();
        TriageJob1.repair_jo();
        
        TriageJob1.atthId=attach.id;
        
        TriageJob1.bmsEnabled = false;
        TriageJob1.tndverification();
        
        TriageJob1.setfilterCategory(TriageJob1.getfilterCategory());
        TriageJob1.setfilterCategory2(TriageJob1.getfilterCategory2());
        TriageJob1.setfilterCategory3(TriageJob1.getfilterCategory3());
        TriageJob1.setfilterCategory4(TriageJob1.getfilterCategory4());
        TriageJob1.setfilterCategory5(TriageJob1.getfilterCategory5());
        
        TriageJob1.setfilterComplaintType(TriageJob1.getfilterComplaintType());
        TriageJob1.setfilterComplaintType2(TriageJob1.getfilterComplaintType2());
        TriageJob1.setfilterComplaintType3(TriageJob1.getfilterComplaintType3());
        TriageJob1.setfilterComplaintType4(TriageJob1.getfilterComplaintType4());
        TriageJob1.setfilterComplaintType5(TriageJob1.getfilterComplaintType5());
        
        TriageJob1.validateBeforeSave();
        
        TriageJob1.concatenateStrings();
        TriageJob1.getBMSCustDetails();
        TriageJob1.selectedCustDetails();
        TriageJob1.closeBMSCustDetails();
        TriageJob1.selectedBMSCustCode();
        
        TriageJob1.ContactLookup();
        TriageJob1.selectedContactID='Testing'; 
        TriageJob1.selectedContactDetails();
        TriageJob1.closeBMSContDetails();
        TriageJob1.getApplication();
        TriageJob1.updateproductappcode();
        //TriageJob1.getFile_Old();
        TriageJob1.getCategoryList();
        TriageJob1.getComplaintTypeList();
        TriageJob1.getComplaintTypeList2();
        TriageJob1.getComplaintTypeList3();
        TriageJob1.getComplaintTypeList4();
        TriageJob1.getComplaintTypeList5();
        
        TriageJob1.delatthId = 'hhh';
        TriageJob1.showcancelpopup();
        TriageJob1.cancelModPopup();
        Test.stopTest();
        
    }
    public static void TestData1(){
        
        Account acc = new Account();
        
        acc.Name = 'Chennai';
        acc.Enable_Claims__c = true;
        acc.type = 'Customer';
        acc.CSS_DBCode__c='33333';
        acc.CSS_DistributorCode__c = 'Bnag';
        acc.CMI_Account_Status__c = 'Active';
        acc.IAM_Service_Provider_Code__c='56270';
        
        insert acc;
        
        CSS_UserLocation__c userloc=new CSS_UserLocation__c();
        userloc.AccountId__c = acc.id;
        userloc.Location_code__c='54321-54321';
        userloc.UserId__c=Userinfo.getUserId();
        userloc.isActive__c=true;
        
        insert userloc;
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'standt', Email='standarduser2@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, User_Location__c=userloc.Location_code__c,
                          TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTestUser2@testorg.com');
        insert u;
        System.runas(u)
        {
            List<CSS_Srt__c> additionalSRTList = new List<CSS_Srt__c>();
            
            JO = new CSS_Job_Order__c();
            JO.Customer_Name__c = 'RoopaTnD';
            JO.Customer_Code__c = null;
            JO.PSN_Not_Available__c =false;
            JO.Model__c = null; 
            JO.Make__c= null;
            JO.Application__c='Automotive'; 
            JO.Date_In__c= Date.today();
            JO.Notes__c= 'Repair';
            JO.INSITE_UpdateTimeStamp__c= Date.today();
            JO.Service_Model__c='ff';
            JO.General_Symptoms__c='ttrtrtrt';
            JO.ESN__c= null;
            JO.DSID__c = 'DSBDT7000';
            JO.Category__c = 'Leak';
            JO.Complaint_Type__c = 'AIR LEAK';
            JO.Application_Desc__c=null;
            JO.Failure_Date__c= Date.Today();
            JO.Failure_Point_Measure__c ='sss';
            JO.DSID_Creation_Timestamp__c=Date.Today();
            JO.DSID_Status__c='open';
            JO.Shop_Work_Order__c = null;
            JO.Status__c = 'Repair Complete';
            JO.Unit_Number__c = 'test1234';
            JO.BMSStatus__c = 'open';
            JO.Actual_Technician_Time__c = null;
            jo.Category_Desc__c = null;
            JO.Category2_Desc__c='F';
            JO.Category3_Desc__c='F';
            JO.Category4_Desc__c='F';
            JO.Category5_Desc__c='F';
            jo.Complaint_Type_Desc__c = 'rrrr';
            jo.Email_Address__c ='a@abc.com';
            jo.Unit_Type__c = 'Conventional';
            jo.Mileage_Measure__c = 'Miles';
            Jo.Assigned_To__c = UserInfo.getUserId();
            jo.Account__c=acc.id;
            insert(JO);
            
            note nn1 = new note(title='CAMPCOMMENTS', body='Test Test Test', ParentId=JO.id);
            insert nn1;
            
            
            list<CSS_Fault_Code__c> FCS = new list<CSS_Fault_Code__c>();
            CSS_Fault_Code__c CSSFc = new CSS_Fault_Code__c();
            
            CSS_Make_Model_Access__c MakeList = new CSS_Make_Model_Access__c();
            CSS_Make_Model_Access__c mk = new CSS_Make_Model_Access__c();
            mk.Access__c = 'D';
            mk.EquipmentId__c = 'EQ6423';
            mk.Make__c = 'DRESSER';
            mk.Model__c = '100';
            insert mk;
            
            CSS_CampTsbTrp__c ct = new CSS_CampTsbTrp__c();
            ct.name = 'CAM';
            ct.name = 'TRP';
            ct.name = 'TSB';
            list<CSS_CampTsbTrp__c> solutionList = new list<CSS_CampTsbTrp__c>();
            CSS_CampTsbTrp__c solRec = new CSS_CampTsbTrp__c( Doc_Num__c='TSB140168',URL__c='https://qsolpilot.cummins.com/qs3/pubsys2/xml/en/tsb/2014/tsb140168.html',
                                                             Type__c='CAM',Doc_Title__c='xyz' ,Performed__c= false,Job_Order__c = JO.id,
                                                             Performed_Review__c= false,Reviewed__c= false , esn__c = '73695829');
            solutionList.add(solRec);
            CSS_CampTsbTrp__c solRec2 = new CSS_CampTsbTrp__c( Doc_Num__c='TSB14013368',URL__c='https://qsolpilot.cummins.com/qs9/pubsys2/xml/en/tsb/2014/tsb140168.html',
                                                              Type__c='TRP',Doc_Title__c='xyz' ,Performed__c= false,Job_Order__c = JO.id,
                                                              Performed_Review__c= true,Reviewed__c= false , esn__c = '1234');
            solutionList.add(solRec2); 
            CSS_CampTsbTrp__c solRec1 = new CSS_CampTsbTrp__c( Doc_Num__c='TSB1401689',URL__c='https://qsolpilot.cummins.com/qs3/pubsys2/xml/en1/tsb/2014/tsb140168.html',
                                                              Type__c='TSB',Doc_Title__c='xyzk' ,Performed__c= true,Job_Order__c = JO.id,
                                                              Performed_Review__c= false,Reviewed__c= false , esn__c = '1234');
            solutionList.add(solRec1);
            insert solutionList;
            
            PageReference pref = new PageReference('/'+JO.id);
            pref.getParameters().put('id',JO.id);
            Test.setCurrentPage(pref);
            
            CSS_Solutions__c sol = new CSS_Solutions__c();
            sol.Service_Job__c = JO.ID;
            sol.Case_Name__c = 'ABC';
            sol.Solution_Title__c='CDE';
            sol.Name='ABC';
            sol.Diagnostic_Response__c ='Most likely the solution';
            sol.Repair_Response__c = 'Most likely';
            insert sol;
            
            CSS_Solutions__c solAdd = new CSS_Solutions__c();
            solAdd.Service_Job__c = JO.ID;
            solAdd.Case_Name__c = 'Additional SRTS';
            solAdd.Solution_Title__c='Additional SRTS';
            solAdd.Name='Additional SRTS';
            solAdd.Diagnostic_Response__c ='Most likely the solution';
            solAdd.Repair_Response__c = 'Most likely ';
            insert solAdd;
            CSS_SRT__c srtVar = new CSS_SRT__c();
            srtVar.Job_Order__c = JO.id;
            srtVar.SRT_AccessiblityCheck__c=True;
            srtVar.Access_Code_B__c =70;
            srtVar.name = 'Test';
            srtVar.Type__c = 'Repair';
            srtVar.isPerformed__c =True;
            srtVar.SRT_Time__c=70;
            insert srtVar;
            additionalSRTList.add(srtVar);
            
            CSS_Solution_Component__c solComp = new CSS_Solution_Component__c();
            solComp.Component_Id__c ='F0051000';
            solComp.Service_Job__c = JO.id;
            solComp.Solutions__c = sol.id;
            insert solComp;
            
            CSS_Solution_Component__c AddsolComp = new CSS_Solution_Component__c();
            AddsolComp.Component_Id__c ='F0051000';
            AddsolComp.Service_Job__c = JO.id;
            AddsolComp.Solutions__c = soladd.id;
            AddsolComp.Name = 'Additional Components';
            insert AddsolComp;
            
            CSS_SRT__c srtRep = new CSS_SRT__c();
            srtRep.Solution_Number__c = sol.id;
            srtRep.Job_Order__c = JO.id;
            srtRep.Component_Id__c = solComp.id;
            srtRep.SRT_Time__c = 65;
            srtRep.name = 'Test';
            srtRep.Type__c = 'Repair';
            insert srtRep;
            
            CSS_SRT__c srtDiagAccess = new CSS_SRT__c();
            srtDiagAccess.Solution_Number__c = sol.id;
            srtDiagAccess.Job_Order__c = JO.id;
            srtDiagAccess.SRT_AccessiblityCheck__c=True;
            srtDiagAccess.SRT_Time__c = 65;
            srtDiagAccess.name = 'Test';
            srtDiagAccess.Type__c = 'Diag Access';
            insert srtDiagAccess;
            
            CSS_SRT__c srtRepAccess = new CSS_SRT__c();
            srtRepAccess.Solution_Number__c = sol.id;
            srtRepAccess.SRT_AccessiblityCheck__c=True;
            srtRepAccess.SRT_Time__c = 65;
            srtRepAccess.Job_Order__c = JO.id;
            srtRepAccess.name = 'Test';
            srtRepAccess.Type__c = 'Repair Access';
            insert srtRepAccess;
            
            
            CSS_SRT__c srtAddiRepAccess = new CSS_SRT__c();
            srtAddiRepAccess.Solution_Number__c = solAdd.id;
            srtAddiRepAccess.SRT_AccessiblityCheck__c=True;
            srtAddiRepAccess.SRT_Time__c = 65;
            srtAddiRepAccess.Job_Order__c = JO.id;
            srtAddiRepAccess.name = 'Test';
            srtAddiRepAccess.Type__c = 'Repair Access';
            insert srtAddiRepAccess;
            
            
            CSS_SRT__c srtAddiDiagAccess = new CSS_SRT__c();
            srtAddiDiagAccess.Solution_Number__c = solAdd.id;
            srtAddiDiagAccess.SRT_AccessiblityCheck__c=True;
            srtAddiDiagAccess.SRT_Time__c = 65;
            srtAddiDiagAccess.Job_Order__c = JO.id;
            srtAddiDiagAccess.name = 'Test';
            srtAddiDiagAccess.Type__c = 'Repair Access';
            insert srtAddiDiagAccess;
            
            CSS_Listof_HHP_SMNS__c hhp = new CSS_Listof_HHP_SMNS__c();
            hhp.name ='Test';
            hhp.Listof_HHP_SMN__c ='QSK19 CM2150 MCRS';
            insert hhp;
            attach=new Attachment();    
            attach.Name='Unit Test Attachment';
            Blob bodyBlob1=Blob.valueOf('Unit Test Attachment Body');
            attach.body=bodyBlob1;
            attach.parentId=jo.id;
            insert attach;
            
            Attachment attach1=new Attachment();    
            attach1.Name='Unit Test Attachment';
            Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
            attach1.body=bodyBlob;
            attach1.parentId=jo.id;
            insert attach1;
            
            
            List<CSS_ECM__c> ecmlist = new List<CSS_ECM__c>();
            CSS_ECM__c ecm1 = new CSS_ECM__c();
            ecm1.name='testecm';
            ecm1.ECM_Number__c=0;
            ecm1.Sequence__c=1;
            ecm1.ECM_Image_Name__c='test1';
            ecm1.Job_Order__c=jo.Id;
            ecmlist.add(ecm1);
            insert ecmlist ;
        }
    }
    static testmethod void method2() {
        Account acc1 = new Account();
        acc1.Name = 'bangalore';
        acc1.Enable_Claims__c = true;
        acc1.ERP_System__c = 'One BMS';
        acc1.CSS_DBCode__c='33333';
        acc1.type = 'Customer';
        acc1.CSS_DistributorCode__c='11111';
        acc1.CMI_Account_Status__c = 'Active';
        acc1.IAM_Service_Provider_Code__c='56270';
        
        insert acc1;
        Test.startTest();
        css_job_order__C jo = CSS_TestData.createJobOrder(false);
        jo.Customer_Name__c='Kr';
        jo.Customer_Code__c='123';
        jo.Warranty_Start_Date__c=system.today();
        jo.Email_Address__c = 'nkm@gmail.com';
        jo.Make__c = null;
        jo.Application_Desc__c = null;
        jo.Complaint_Type_Desc__c = null;
        jo.First_Name__c = null;
        jo.Account__c=acc1.id;
        insert jo;
        css_job_order__C jo1 = [select Id, Account__c from css_job_order__C where id = : jo.Id];
        apexpages.currentPage().getparameters().put('id',jo.id);
        
        Account acc=CSS_TestData.createAccountObj(false);
        acc.CSS_DistributorCode__c ='56270';
        acc.CSS_DealerCode__c = '56270';
        acc.Enable_Claims__c = true;
        acc.Id = jo1.Account__c;
        acc.Region__c = 'North America';
        acc.Type= '';
        acc.CSS_DBCode__c='33333';
        acc.CMI_Account_Status__c = 'Active';
        acc.IAM_Service_Provider_Code__c='56270';
        
        upsert acc;
        
        css_job_order__C jo22 = new css_job_order__C();
        jo22.Account__c = acc.Id;
        jo22.Id = jo.Id;
        jo22.First_Name__c = null;
        jo22.Account__c=acc.id;
        update jo1;
        
        list<Note> ln = new list<Note>();
        Note n = new Note();
        n.parentId = jo.Id;
        n.Title = 'Bold';
        n.body = 'sfsafsaifasf';
        ln.add(n);//insert n;
        
        Note n1 = new Note();
        n1.parentId = jo.Id;
        n1.Title = 'Bold';
        ln.add(n1);
        
        Note n12 = new Note();
        n12.parentId = jo.Id;
        n12.Title = 'CAMPCOMMENTS';
        ln.add(n12);
        
        insert ln;
        
        CSS_UserLocation__c userl = new CSS_UserLocation__c();
        userl.UserId__c= Userinfo.getUserId();
        userl.AccountId__c = acc.Id;
        userl.isActive__c = true;
        insert userl;
        css_repair_job b = new css_repair_job();
        b.higherdateErrFlag=false;
        b.bmsEnabled=true;
        b.region = 'sfsaf';
        b.dispDTime = 'xfs';
        b.NewdigTime = 11.0;
        b.NewrepTime = 1.0;
        b.dispRepTime = 'sfsdf';
        b.NewrepMin = 100;
        b.NewdigMin = 120;
        b.errorMessage = 'asf';
        b.selectedBMSESN = 'safasf';
        
        b.reqEmailBoolean = true;
        b.reqEmailInvalidBoolean= true;
        b.ReadonlyWSD = true;
        b.searchConfigUnit();
        b.onChangeBIS();
        jo.Warranty_Start_Date__c = null;
        jo.Before_In_Service__c = true;
        b.workjob = jo;
        b.onChangeBIS();
        jo.Customer_Code__c = '';
        b.workjob = jo;
        b.blankUnitonCustCodeChange();
        b.concatenateStrings();
        b.pgUISave();
        b.validateBeforeSave();
        Test.stopTest();
        
    }
    static testMethod void css_repair_job_Test_Method9(){   
        Account acc = new Account();
        acc.Name = 'bangalore11';
        acc.Enable_Claims__c = true;
        acc.ERP_System__c = 'One BMS';
        acc.CSS_DBCode__c='333311';
        acc.type = 'Customer';
        acc.CSS_DistributorCode__c='111111';
        acc.CMI_Account_Status__c = 'Active';
        acc.IAM_Service_Provider_Code__c='5627011';
        
        insert acc;
        TestData1();
        JO.ShipDate__c = Date.Today()+1;
        jo.account__c=acc.id;
        update JO;
        CSS_accountLanguage__c lang = CSS_TestData.createAccountLanguage(true);
        system.assertNotEquals(null, lang);
        CSS_CampTsbTrp__c cssTrp = new CSS_CampTsbTrp__c();
        cssTrp.Name = 'Test Trp';
        cssTrp.Job_Order__c = JO.id;
        cssTrp.performed_review__c = true;
        cssTrp.performed__c = false;
        cssTrp.Cu_Language__c = 'Hindi';
        cssTrp.Type__c='TSB';
        insert cssTrp;
        cssTrp.ESN__c = '123';
        update cssTrp;
        CSS_JobEventTemporary__c jobEvent =CSS_TestData.createJobEventTempObj(false);
        jobEvent.attribute1__c ='ApplicationCodes';
        jobEvent.Reason__c='{"DataArea":{"Details":[{"Description":"AUTOMOTIVE (C-OVER 225 HP)","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"120","MarineFlag":"N","DefaultUom":""},{"Description":"AUTOMOTIVE","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"Y","ApplicationCode":"130","MarineFlag":"N","DefaultUom":""},{"Description":"BUS","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"200","MarineFlag":"N","DefaultUom":""},{"Description":"WORLDWIDE BUS(EXC.US & CANADA SCHOOL BUS","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"Y","ApplicationCode":"210","MarineFlag":"N","DefaultUom":""},{"Description":"SCHOOL BUS (US & CANADA)","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"Y","ApplicationCode":"220","MarineFlag":"N","DefaultUom":""},{"Description":"RECREATIONAL VEHICLE","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"300","MarineFlag":"N","DefaultUom":""},{"Description":"FIRE TRUCK","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"400","MarineFlag":"N","DefaultUom":""},{"Description":"FIRE TRUCK","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"Y","ApplicationCode":"410","MarineFlag":"N","DefaultUom":""},{"Description":"OBSOLETE - TEMP VALUE ONLY","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"420","MarineFlag":"N","DefaultUom":""},{"Description":"INDUSTRIAL","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"500","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"MARINE","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"600","MarineFlag":"Y","DefaultUom":""},{"Description":"OBSOLETE-TEMP VALUE ONLY(0605)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"605","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"MARINE - RECREATIONAL(ALL ENG)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"Y","ApplicationCode":"610","MarineFlag":"Y","DefaultUom":"Hours"},{"Description":"MARINE (INTERMITTENT DUTY)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"Y","ApplicationCode":"620","MarineFlag":"Y","DefaultUom":"Hours"},{"Description":"MARINE DIVISION OF BRUNSWICK","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"625","MarineFlag":"Y","DefaultUom":"Hours"},{"Description":"OBSOLETE-TEMP VALUE ONLY(0645)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"645","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"MARINE(MEDIUM CONTINUOUS DUTY)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"Y","ApplicationCode":"650","MarineFlag":"Y","DefaultUom":"Hours"},{"Description":"MARINE (HEAVY DUTY)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"Y","ApplicationCode":"655","MarineFlag":"Y","DefaultUom":"Hours"},{"Description":"MARINE (CONTINUOUS POWER)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"665","MarineFlag":"Y","DefaultUom":"Hours"},{"Description":"AGRICULTURE","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"700","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"OBSOLETE-TEMP VALUE ONLY(0710)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"710","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"OBSOLETE-TEMP VALUE ONLY(0720)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"720","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"GENERATOR DRIVE","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"800","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"G-Drive Engine Standby","BusinessUnit":"CMI","AutomotiveFlag":"N","ActiveFlag":"Y","ApplicationCode":"810","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"G-Drive Engine Prime","BusinessUnit":"CMI","AutomotiveFlag":"N","ActiveFlag":"Y","ApplicationCode":"820","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"GENERATOR DRIVE (LIMITED PRIME POWER)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"830","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"GENERATOR DRIVE (CONTINUOUS/BASE POWER)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"840","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"MILITARY PACKAGES","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"900","MarineFlag":"N","DefaultUom":""},{"Description":"BRADLEY FIGHTING VEHICLE, LVTP71, OR M9A","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"910","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"5 TON ARMY TRUCK (M939) (NHC250)","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"920","MarineFlag":"N","DefaultUom":""},{"Description":"AIR FORCE R11 FUEL TANKER","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"930","MarineFlag":"N","DefaultUom":""},{"Description":"5 TON ARMY TRUCK (M939A2) (6CTA 8.3)","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"940","MarineFlag":"N","DefaultUom":""},{"Description":"NTTA-855-P40 PETRO PUMP ENGINE","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"950","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"TRAKS MILITARY FORKLIFT","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"960","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"0AUTOMOTIVE","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"10","MarineFlag":"N","DefaultUom":""},{"Description":"0AUTOMOTIVE (C--UP TO 225 HP)","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"11","MarineFlag":"N","DefaultUom":""},{"Description":"0AUTOMOTIVE (C--OVER 225 HP)","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"12","MarineFlag":"N","DefaultUom":""},{"Description":"0AUTOMOTIVE (OTHER THAN C-SERIES)","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"13","MarineFlag":"N","DefaultUom":""},{"Description":"0BUS","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"20","MarineFlag":"N","DefaultUom":""},{"Description":"0BUS (INTERCITY COACH, SHUTTLE AND TRANS","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"21","MarineFlag":"N","DefaultUom":""},{"Description":"0BUS (SCHOOL BUS)","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"22","MarineFlag":"N","DefaultUom":""},{"Description":"0BUS (COMPRESSED OR NATURAL GAS)","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"23","MarineFlag":"N","DefaultUom":""},{"Description":"0RECREATIONAL VEHICLE","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"30","MarineFlag":"N","DefaultUom":""},{"Description":"1RECREATIONAL VEHICLE","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"31","MarineFlag":"N","DefaultUom":""},{"Description":"0FIRE TRUCK","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"40","MarineFlag":"N","DefaultUom":""},{"Description":"0FIRE TRUCK (STANDARD COVERAGE)","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"41","MarineFlag":"N","DefaultUom":""},{"Description":"0FIRE TRUCK (SPECIAL PARTS-ONLY COVERAGE","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"42","MarineFlag":"N","DefaultUom":""},{"Description":"0INDUSTRIAL","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"50","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"0INDUSTRIAL (EXC. MARINE, AG, GEN DRIVE","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"51","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"5MARINE - DIAMOND EDITION ENGINES","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"60","MarineFlag":"Y","DefaultUom":"Hours"},{"Description":"0MARINE (RECR./LT DUTY COMMERCIAL - PERS","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"61","MarineFlag":"Y","DefaultUom":"Hours"},{"Description":"5MARINE-RECREATIONAL (HIGH OUTPUT RATING","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"62","MarineFlag":"Y","DefaultUom":"Hours"},{"Description":"5MARINE-RECREATIONAL (RECREATIONAL RATIN","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"63","MarineFlag":"Y","DefaultUom":"Hours"},{"Description":"5MARINE-COMMERCIAL (INTERMITTENT RATING)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"64","MarineFlag":"Y","DefaultUom":"Hours"},{"Description":"5MARINE-COMMERCIAL (MEDIUM CONTINUOUS RA","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"65","MarineFlag":"Y","DefaultUom":"Hours"},{"Description":"5MARINE-COMMERCIAL (CONTINUOUS RATING)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"66","MarineFlag":"Y","DefaultUom":"Hours"},{"Description":"0AGRICULTURE","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"70","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"0MOBILE FARM EQUIPMENT / IRRIGATION PUMP","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"71","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"0FARM EQUIPMENT (NON MOBILE)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"72","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"0GENERATOR DRIVE","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"80","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"0GENERATOR DRIVE (STANDBY POWER)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"81","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"0GENERATOR DRIVE (UNLIMITED PRIME POWER)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"82","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"0GENERATOR DRIVE (LIMITED PRIME POWER)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"83","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"0GENERATOR DRIVE (CONTINUOUS/BASE POWER)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"84","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"0MILITARY PACKAGES","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"90","MarineFlag":"N","DefaultUom":""},{"Description":"0BRADLEY FIGHTING VEHICLE, LVTP71, OR M9","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"91","MarineFlag":"N","DefaultUom":""},{"Description":"05 TON ARMY TRUCK (M939) (NHC250)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"92","MarineFlag":"N","DefaultUom":""},{"Description":"0AIR FORCE R11 FUEL TANKER","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"93","MarineFlag":"N","DefaultUom":""},{"Description":"05 TON ARMY TRUCK (M939A2) (6CTA 8.3)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"94","MarineFlag":"N","DefaultUom":""},{"Description":"0NTTA-855-P40 PETRO PUMP ENGINE","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"95","MarineFlag":"N","DefaultUom":""},{"Description":"0TRAKS MILITARY FORKLIFT","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"96","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"AUTOMOTIVE","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"100","MarineFlag":"N","DefaultUom":""},{"Description":"AUTOMOTIVE (C-UP TO 225 HP)","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"110","MarineFlag":"N","DefaultUom":""},{"Description":"BUS (COMPRESSED OR NATURAL GAS)","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"230","MarineFlag":"N","DefaultUom":""},{"Description":"RECREATIONAL VEHICLE","BusinessUnit":"CMI","AutomotiveFlag":"Y","ActiveFlag":"Y","ApplicationCode":"310","MarineFlag":"N","DefaultUom":""},{"Description":"WORLDWIDE OFF-HIGHWAY","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"Y","ApplicationCode":"510","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"MARINE (PRIME/CONTINUOS PRIME POWER)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"Y","ApplicationCode":"635","MarineFlag":"Y","DefaultUom":"Hours"},{"Description":"MARINE (CONTINUOUS DUTY)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"Y","ApplicationCode":"660","MarineFlag":"Y","DefaultUom":"Hours"},{"Description":"FORD GRAY AUTO","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"140","MarineFlag":"N","DefaultUom":""},{"Description":"FORD GRAY BUS","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"240","MarineFlag":"N","DefaultUom":""},{"Description":"ISC-SERIES","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"150","MarineFlag":"N","DefaultUom":""},{"Description":"CMD NONQUANTUM - INTERMITTENT","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"621","MarineFlag":"Y","DefaultUom":"Hours"},{"Description":"CMD NONQUANTUM - MEDIUM CONTINUOUS","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"651","MarineFlag":"Y","DefaultUom":"Hours"},{"Description":"CMD NONQUANTUM - HEAVY DUTY","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"656","MarineFlag":"Y","DefaultUom":"Hours"},{"Description":"CMD NONQUANTUM - CONTINUOUS","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"661","MarineFlag":"Y","DefaultUom":"Hours"},{"Description":"RECREATIONAL VEHICLE AD","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"Y","ApplicationCode":"320","MarineFlag":"N","DefaultUom":""},{"Description":"KA91 MARINE GENERIC","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"Y","ApplicationCode":"890","MarineFlag":"Y","DefaultUom":"Hours"},{"Description":"CMD QUANTUM - RECREATIONAL","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"670","MarineFlag":"Y","DefaultUom":"Hours"},{"Description":"CMD QUANTUM - INTERMITTENT","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"675","MarineFlag":"Y","DefaultUom":"Hours"},{"Description":"CMD QUANTUM - GOVERNMENT SERVICE","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"680","MarineFlag":"Y","DefaultUom":"Hours"},{"Description":"CMD QUANTUM - MEDIUM CONTINUOUS","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"685","MarineFlag":"Y","DefaultUom":"Hours"},{"Description":"CMD QUANTUM - HEAVY DUTY","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"690","MarineFlag":"Y","DefaultUom":"Hours"},{"Description":"CMD QUANTUM - CONTINUOUS","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"695","MarineFlag":"Y","DefaultUom":"Hours"},{"Description":"KA91 GENERATOR DRIVE GENERIC","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"Y","ApplicationCode":"891","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"WORLDWIDE WELDER COVERAGE","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"Y","ApplicationCode":"520","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"G-Drive (HHP Lean-Burn Gas)","BusinessUnit":"CMI","AutomotiveFlag":"N","ActiveFlag":"Y","ApplicationCode":"850","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"THOMAS BUILT BUS","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"250","MarineFlag":"N","DefaultUom":""},{"Description":"CMD QUANTUM - LIGHT COMMERCIAL","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"699","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"MARINE (LIGHT COMMERCIAL)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"Y","ApplicationCode":"662","MarineFlag":"Y","DefaultUom":"Hours"},{"Description":"MARINE (GOVERNMENT SERVICE)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"Y","ApplicationCode":"663","MarineFlag":"Y","DefaultUom":"Hours"},{"Description":"QSK95 T4 LOCOMOTIVE","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"Y","ApplicationCode":"530","MarineFlag":"N","DefaultUom":"Hours"}]},"Header":{"ReturnCodeDescription":"","Status":"Success"';
            jobEvent.Reason__c ='{'+
            '  \"Details\": {'+
            '    \"ApplicationCode\": \"12345\",'+
            '    \"Description\": \"testing\",'+
            '    \"BusinessUnit\": \"GetAssessData\",'+
            '    \"AutomotiveFlag\": \"Fault Details Data sent successfully\",'+
            '    \"MarineFlag\": \"Fault Details Data sent successfully\",'+   
            '    \"ActiveFlag\": \"Fault Details Data sent successfully\",'+    
            '    \"DefaultUom\": \"Fault Details Data sent successfully\"'+     
            '  },'+
            '  \"Header\": {'+   
            '        \"ReturnCodeDescription\": \"Test\",'+
            '        \"Status\": \"completed\"'+
            '      }'+
            '}'; 
        insert jobEvent;
        CSS_JobEventTemporary__c jobEvent1 =CSS_TestData.createJobEventTempObj(false);
        jobEvent1.attribute1__c ='CategoryComplaintCodes';
        jobEvent1.Reason__c = '{'+    
            '  \"Header\": {'+
            '    \"ReturnCodeDescription\": \"test\",'+
            '    \"Status\": \"completed\"'+
            '      },'+
            '\"DataArea\": {'+
            '\"Details\": ['+
            '{'+
            '\"ComplaintCode\": \"1117\",'+
            '\"Description\": \"21319736\",'+
            
            '\"BusinessUnit\": \"inactive\",'+
            '\"Category\": \"1\"'+
            '},'+
            '{'+
            '\"ComplaintCode\": \"1117\",'+
            '\"Description\": \"21319736\",'+
            '\"BusinessUnit\": \"inactive\",'+
            
            '\"Category\"    : \"1\"'+
            '},'+
            '{'+
            '\"ComplaintCode\": \"1117\",'+
            '\"Description\": \"21319736\",'+
            
            '\"BusinessUnit\": \"inactive\",'+
            '\"Category\"    : \"1\"'+
            '},'+
            '{'+
            '\"ComplaintCode\": \"1117\",'+
            '\"Description\": \"21319736\",'+
            
            '\"BusinessUnit\": \"inactive\",'+
            '\"Category\"    : \"1\"'+
            '}'+
            
            ']'+
            '}'+
            '}';
        insert jobEvent1;
        
        test.setMock(HttpCalloutMock.class, new CSS_MockHttpResponseGenerator());
        
        Test.startTest();        
        
        css_repair_job TriageJob= new css_repair_job ();
        TriageJob.isDealer = true;
        TriageJob.sEngineFamilyCode='878';
        PageReference p=Page.CSS_JobTnDRj; 
        Test.setCurrentPage(p);  
        ApexPages.currentPage().getParameters().put('id',jo.Id); 
        CSS_Claims__c claimobj = CSS_TestData.createclaims(true,jo.Id);
        claimobj.Account__c=acc.id;
        update claimobj;
        css_repair_job TriageJob1= new css_repair_job ();
        TriageJob1.newQuoteStr = 'Sample';
        TriageJob1.showRepairErrorMessage = true;
        
        TriageJob1.workJob = JO;
        TriageJob1.timeinMinutes = 10;
        TriageJob1.timeinhours = 20;
        TriageJob1.isdealer = true;
        TriageJob1.bmsEnabled = true;
        TriageJob1.atthId=attach.id;
        TriageJob1.fileBody =Blob.valueOf('Unit Test Attachment Body');
        TriageJob1.fileBody2 =Blob.valueOf('Unit Test Attachment Body');
        TriageJob1.fileBody3 =Blob.valueOf('Unit Test Attachment Body');
        TriageJob1.editAttachment();
        string x=TriageJob1.getmil_measure();
        TriageJob1.setmil_measure(x);
        TriageJob1.getfail_measure();
        TriageJob1.setfail_measure(x);
        TriageJob1.getItems();
        TriageJob1.repair_jo();
        TriageJob1.sServiceModel = 'a';
        string dt='1'+'-'+'5'+'-'+'2016';
        TriageJob1.parseQSOLDate(dt);
        TriageJob1.dsidStatus = true;
        TriageJob1.isPrioritized = true;
        TriageJob1.rj_btn_cls = 'we';
        TriageJob1.rj_chv_sts = 'we';
        TriageJob1.rj_txt_sts = 'we';
        TriageJob1.rj_txt_val = 'we';
        TriageJob1.HHSPSMNFlg = true;
        TriageJob1.HHSPACCSFlg = true;
        TriageJob1.displaycertPopup = true;
        TriageJob1.displaySrvModPopup = true;
        TriageJob1.displaySrvModPopup1 = true;
        TriageJob1.show_rj_pnl = true;
        TriageJob1.rowcount = 5;
        TriageJob1.getLocations();
        TriageJob1.getfilterMake();
        TriageJob1.setfilterMake(X);
        TriageJob1.getfilterModel();
        TriageJob1.setfilterModel(x);
        TriageJob1.fetchModelRecords();
        TriageJob1.css_redirect();
        TriageJob1.reqUNumBoolean=true;
        TriageJob1.reqCusNumBoolean=true;
        TriageJob1.reqFrstNamBoolean=true;
        TriageJob1.reqLastNamBoolean=true;
        TriageJob1.reqCstmrContactPhnBoolean=true;
        TriageJob1.reqUTBoolean=true;
        TriageJob1.allFieldsValidate=true;
        TriageJob1.validateBeforeSave();
        TriageJob1.getComplaintTypeList5();
        TriageJob1.getComplaintTypeList4();
        TriageJob1.getComplaintTypeList3();
        TriageJob1.getComplaintTypeList2();
        TriageJob1.getComplaintTypeList();
        TriageJob1.getCategoryList();
        TriageJob1.getApplication();
        TriageJob1.closeBMSContDetails();
        TriageJob1.selectedContactID='Testing'; 
        TriageJob1.selectedContactDetails();
        TriageJob1.ContactLookup();
        TriageJob1.bmsContacterrorMessage = 'ESN';
        TriageJob1.contactshowOutageError= False;
        TriageJob1.selectedBMSCustCode();
        TriageJob1.closeBMSCustDetails();
        TriageJob1.selectedCustDetails();
        TriageJob1.getBMSCustDetails();
        TriageJob1.bmscustErrorMessage ='true';
        TriageJob1.strCntryState='true';
        TriageJob1.strCntry='true';
        TriageJob1.getfilterCategory();
        TriageJOb1.setfilterCategory('test');
        TriageJob1.getfilterCategory2();
        TriageJob1.setfilterCategory2('test');
        TriageJob1.getfilterCategory3();
        TriageJob1.setfilterCategory3('test');
        TriageJob1.getfilterCategory4();
        TriageJob1.setfilterCategory4('test');
        TriageJob1.getfilterCategory5();
        TriageJob1.setfilterCategory5('test');
        TriageJob1.getfilterComplaintType();
        TriageJob1.setfilterComplaintType('test');
        TriageJob1.getfilterComplaintType2();
        TriageJob1.setfilterComplaintType2('test');
        TriageJob1.getfilterComplaintType3();
        TriageJob1.setfilterComplaintType3('test');
        TriageJob1.getfilterComplaintType4();
        TriageJob1.setfilterComplaintType4('test');
        TriageJob1.getfilterComplaintType5();
        TriageJob1.setfilterComplaintType5('test');
        TriageJob1.getFailureDate();
        TriageJob1.repair_vh();
        TriageJob1.getModel();
        TriageJob1.workjob.Make__c='Test';
        TriageJob1.workjob.Complaint_Type__c='AIR LEAK';
        TriageJob1.accountlang = lang;
        TriageJob1.pgSaveAssign();
        TriageJob1.ShowErrorMessagePanels(); 
        TriageJob1.pgName = 'JO';
        
        Test.stopTest();
    }
    static testmethod void compareDates1(){
        Test.startTest();
        Account acc = new Account();
        acc.Name = 'bangalore';
        acc.Enable_Claims__c = true;
        acc.ERP_System__c = 'One BMS';
        acc.CSS_DBCode__c='33333';
        acc.type = 'Customer';
        acc.CSS_DistributorCode__c='11111';
        acc.CMI_Account_Status__c = 'Active';
        acc.IAM_Service_Provider_Code__c='56270';
        
        insert acc;
        css_job_order__C jo = CSS_TestData.createJobOrder(false);
        jo.Customer_Name__c='Gopal';
        jo.Customer_Code__c='123';
        jo.Account__c=acc.id;
        jo.Warranty_Start_Date__c=system.today();
        insert jo;
        apexpages.currentPage().getparameters().put('id',jo.id);
        css_repair_job b = new css_repair_job();
        string dt='1'+'-'+'6'+'-'+'2016';
        b.parseQSOLDate(dt);
        b.higherdateErrFlag=false;
        
        b.warrantyDate = Date.Today()-1;
        
        b.CompareDates();
        Test.stopTest();
        
        
        
    }
    static testmethod void compareDates2(){
        Test.startTest();
        Account acc = new Account();
        acc.Name = 'bangalore';
        acc.Enable_Claims__c = true;
        acc.ERP_System__c = 'One BMS';
        acc.CSS_DBCode__c='33333';
        acc.type = 'Customer';
        acc.CSS_DistributorCode__c='11111';
        acc.CMI_Account_Status__c = 'Active';
        acc.IAM_Service_Provider_Code__c='56270';
        
        insert acc;
        css_job_order__C jo = CSS_TestData.createJobOrder(false);
        jo.Customer_Name__c='Gopal';
        jo.Customer_Code__c='123';
        jo.Warranty_Start_Date__c=system.today()+1;
        jo.Application_Desc__c = 'AUTOMOTIVE';
        jo.Account__c=acc.id;
        insert jo;
        apexpages.currentPage().getparameters().put('id',jo.id);
        css_repair_job b = new css_repair_job();
        
        b.higherdateErrFlag=false;
        
        b.warrantyDate = Date.Today()+1;
        
        b.CompareDates();
        b.getMake();
        Test.stopTest();
        
        
        
    }
    static testmethod void CampaignDetails1(){
        Test.startTest();
        Account acc = new Account();
        acc.Name = 'bangalore';
        acc.Enable_Claims__c = true;
        acc.ERP_System__c = 'One BMS';
        acc.CSS_DBCode__c='33333';
        acc.type = 'Customer';
        acc.CSS_DistributorCode__c='11111';
        acc.CMI_Account_Status__c = 'Active';
        acc.IAM_Service_Provider_Code__c='56270';
        
        insert acc;
        css_job_order__C jo = CSS_TestData.createJobOrder(false);
        jo.Customer_Name__c='Gopal';
        jo.Customer_Code__c='123';
        jo.Warranty_Start_Date__c=system.today()+1;
        jo.Failure_Date__c=system.today();
        jo.Before_In_Service__c=false;
        jo.ShipDate__c=system.today()-1;
        jo.Application_Desc__c = 'WORLDWIDE OFF-HIGHWAY';
        jo.Qsol_Engine_Family_Code__c = '123';
        jo.ESN__c ='';
        jo.Account__c=acc.id;
        insert jo;
        apexpages.currentPage().getparameters().put('id',jo.id);
        css_repair_job b = new css_repair_job();
        b.startRequest();
        b.getModel();
        b.getMake();
        
        Test.stopTest();
        
    }
    static testMethod void css_repair_job_Test_Method12(){
        
        TestData();
        CSS_Solutions__c sol = new CSS_Solutions__c();
        sol.Service_Job__c = JO.id;
        
        css_srt__c cssSRT = new css_srt__c();
        cssSRT.Name = 'Test';
        cssSRT.Job_Order__c = Jo.id;
        cssSRT.Type__c = 'Diagnosis';
        cssSRT.Solution_Number__c = sol.id;
        cssSRT.isPerformed__c = true;
        cssSRT.Extended_Hours__c = 2.30;
        cssSRT.Access_Code__c = 'test';
        insert cssSRT;
        
        cssSRT.Type__c = 'Repair';
        cssSRT.srt_time__c = 12.3;
        cssSRT.isPerformed__c = true;
        update cssSRT;
        
        JO.Service_Model__c = null;
        JO.ESN__c = '1234';
        JO.Mileage_Measure__c = '12';
        JO.Failure_Point_Measure__c = null;
        JO.Category_Desc__c = 'testing';
        JO.Category2_Desc__c = 'testing1';
        JO.Category3_Desc__c = 'testing2';
        JO.Category4_Desc__c = 'testing1';
        JO.Category5_Desc__c = 'testing1';
        JO.Complaint_Type_Desc__c = 'test';
        JO.Complaint_Type2_Desc__c = 'test';
        JO.Complaint_Type3_Desc__c = 'test';
        JO.Complaint_Type4_Desc__c = 'test';
        JO.Complaint_Type5_Desc__c = 'test';
        JO.BMSStatus__c = 'WC1';
        JO.FieldActionWebServiceResult__c = 'Error';
        JO.Failure_Date__c = system.today() + 7;
        JO.Application_Desc__c = 'AUTOMOTIVE';
        update JO;
        
        css_repair_job b = new css_repair_job();
        b.getLocations();
        b.updateNotes();
        //b.jobPlanAction();
        
        
        CSS_TestData.createIntegrationDetails(true);
        Test.startTest(); 
        Test.setMock(WebServiceMock.class, new CSS_GetWarrantyDocs_Test());
        b.getQSOLDocs();
        b.getLocCode();
        b.getModel();
        b.dsidIndi ='G';
        b.AdditionalUnitLookupPopup = true;
        b.getBMSUnitDetailsfromUnitNumber();
        // b.Cancel();
        
        Test.stopTest();
        
    } 
    static testMethod void css_repair_job_Test_Method11(){
        Account acc = new Account();
        acc.Name = 'bangalore';
        acc.Enable_Claims__c = true;
        acc.ERP_System__c = 'One BMS';
        acc.CSS_DBCode__c='33333';
        acc.type = 'Customer';
        acc.CSS_DistributorCode__c='11111';
        acc.CMI_Account_Status__c = 'Active';
        acc.IAM_Service_Provider_Code__c='56270';
        
        insert acc;
        CSS_Job_Order__c workJob= new CSS_Job_Order__c();
        workJob.CSS_Job_Location_Code__c='03520-04892';
        workJob.jobLocation__c='87654-56789';
        workJob.Customer_Name__c='Test';
        workJob.Customer_Code__c='Test';
        workJob.First_Name__c='Test';
        workJob.BMS_Last_Name__c='Test';
        workJob.Phone_Number__c='Test';
        workJob.Email_Address__c='Test@test.com';
        workJob.Address__c='Test';
        workJob.ZipCode__c='94356';
        
        workJob.ESN__c='Test';
        workJob.Unit_Number__c='Test';
        workJob.Application__c='Test';
        workJob.Service_Model__c='Test';
        workJob.Make__c='Test';
        workJob.Model__c='Test';
        workJob.Unit_Type__c='Test';
        workJob.VIN__c='1234';
        workJob.Warranty_Start_Date__c=Date.today();
        workJob.Before_In_Service__c=true;
        workJob.Failure_Date__c=Date.today();
        workJob.Mileage__c=23.0;
        workJob.CSS_Hours__c=10;
        workjob.Sub_Status__c='Ready for Claim Creation';
        workjob.FieldActionWebServiceResult__c = 'Error';
        workjob.Account__c=acc.id;
        insert workjob;
        
        css_repair_job b = new css_repair_job();
        b.updateNotes();
        
    }
    static testmethod void getCampaignDetailsMethod(){
        TestData();
        Account acc = new Account();
        acc.Name = 'bangalore1';
        acc.Enable_Claims__c = true;
        acc.ERP_System__c = 'One BMS';
        acc.CSS_DBCode__c='333331';
        acc.type = 'Customer';
        acc.CSS_DistributorCode__c='111111';
        acc.CMI_Account_Status__c = 'Active';
        acc.IAM_Service_Provider_Code__c='562701';
        
        insert acc;
        Test.startTest();
        css_repair_job obj = new css_repair_job();
        list<CSS_Job_Order__c> lstjob = new list<CSS_Job_Order__c>();
        CSS_Job_Order__c JO =CSS_TestData.createJobOrder(false);
        JO.Failure_Date__c = system.today()-2;
        JO.Before_In_Service__c = false;
        JO.Warranty_Start_Date__c = system.today();
        JO.ShipDate__c = system.today();
        jo.Account__c=acc.id;
        insert JO;
        lstjob.add(JO);
        ApexPages.CurrentPage().getParameters().put('id',Jo.id);
        obj.getCampaignDetails();
        Test.stopTest();
    }
    static testMethod void CG_BL_Intake_TestMethod2() {
        Test.startTest();
        Test.setMock(WebServiceMock.class, new CSS_GetWarrantyDocs_Test());
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'standt', Email='standarduser4@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US',  ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTestUser4@testorg.com',User_Location__c = 'location');
        insert u;
        system.runAs(u){
            Account acc = new Account();
            acc.Name = 'bangalore';
            acc.Enable_Claims__c = true;
            acc.ERP_System__c = 'One BMS';
            acc.CSS_DBCode__c='33333';
            acc.type = 'Customer';
            acc.CSS_DistributorCode__c='11111';
            acc.CMI_Account_Status__c = 'Active';
            acc.IAM_Service_Provider_Code__c='56270';
            
            insert acc;
            CSS_Job_Order__c JO = new CSS_Job_Order__c();
            JO.Customer_Name__c = 'TestKal';
            JO.Application__c = 'Recreational Vehicle';
            JO.Model__c = 'Ridhima test 123';
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
            Jo.esn__c = '79464646';
            JO.Unit_Type__c = 'type';
            Jo.Country__c = 'United States';
            Jo.CSS_State__c = 'Indiana';
            Jo.City__c = 'Columbus';
            Jo.Customer_Code__c = '23456';
            Jo.Service_Model__c = 'Test one';
            Jo.OwnerId = u.Id;
            JO.Notes__c = 'notessss';
            jo.Account__c=acc.id;
            insert(JO);
            system.debug('------Testing---' +JO);
            List<css_solution_component__c> solCompCTTP = new List<css_solution_component__c>();
            CSS_Solution_Component__c solComp = new CSS_Solution_Component__c();
            solComp.Component_Id__c ='F0051000';
            solComp.Service_Job__c = Jo.id;
            solComp.Action__c = '';
            solComp.Type__c = 'TRP';
            solComp.Campaign_Description__c = 'Hey Hai Man Camp';
            solComp.CampaignPartsPercentage__c = '20';
            solcomp.Performed_Review__c = True;
            solcomp.Status__c = 'Approved';
            solComp.Complete_Indicator__c = True;
            solcomp.Multiple_Times__c = True;
            insert solComp;
            solCompCTTP.add(solComp);
            List<CSS_CampTsbTrp__c> lstCAM = new List<CSS_CampTsbTrp__c>();
            List<CSS_CampTsbTrp__c> lstTRP = new List<CSS_CampTsbTrp__c>();
            List<CSS_CampTsbTrp__c> lstATC = new List<CSS_CampTsbTrp__c>();
            List<CSS_CampTsbTrp__c> lstQSOLDocs = new List<CSS_CampTsbTrp__c>();
            CSS_CampTsbTrp__c ctt = new CSS_CampTsbTrp__c();
            ctt.Type__c = 'TRP';
            ctt.URL__c = 'https://qs-stg.cummins.com/qs3/pubsys2/xml/en/atc/19TC/atc1623.html';
            ctt.Doc_Num__c = 'TF0051000';
            ctt.Doc_Title__c = 'DUAL FUEL DATAPLATE ATC';
            ctt.Performed__c = false;
            ctt.Performed_Review__c = true;
            ctt.Reviewed__c = false;
            ctt.Job_Order__c = JO.Id;
            ctt.ESN__c = JO.ESN__c;
            insert ctt;
            
            CSS_CampTsbTrp__c ctt1 = new CSS_CampTsbTrp__c();
            ctt1.Type__c = 'ATC';
            ctt1.URL__c = 'https://qs-stg.cummins.com/qs3/pubsys2/xml/en/atc/19TC/atc1623.html';
            ctt1.Doc_Num__c = 'ATCF0051000';
            ctt1.Doc_Title__c = 'DUAL FUEL DATAPLATE ATC';
            ctt1.Performed__c = false;
            ctt1.Performed_Review__c = true;
            ctt1.Reviewed__c = false;
            ctt1.Job_Order__c = JO.Id;
            ctt1.ESN__c = JO.ESN__c;
            insert ctt1;
            
            system.debug('---ctttest--' +ctt1);
            CSS_CampTsbTrp__c ctt2 = new CSS_CampTsbTrp__c();
            ctt2.Type__c = 'CAM';
            ctt2.URL__c = 'https://qs-stg.cummins.com/qs3/pubsys2/xml/en/atc/19TC/atc1623.html';
            ctt2.Doc_Num__c = 'CF0051000';
            ctt2.Doc_Title__c = 'DUAL FUEL DATAPLATE ATC';
            ctt2.Performed__c = false;
            ctt2.Performed_Review__c = true;
            ctt2.Reviewed__c = false;
            ctt2.Job_Order__c = JO.Id;
            ctt2.ESN__c = JO.ESN__c;
            insert ctt2;
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
            lstQSOLDocs.add(ctt3);
            lstQSOLDocs.add(ctt);
            lstQSOLDocs.add(ctt1);
            lstQSOLDocs.add(ctt2);
            lstCAM.add(ctt2);
            lstTRP.add(ctt);
            lstATC.add(ctt1);
            CSS_TestData.createAccountLanguage(true);
            CSS_TestData.createIntegrationDetails(true);
            
            css_customerOutboundJSON2Apex.DataArea DA = new css_customerOutboundJSON2Apex.DataArea();
            list<CSS_customerOutboundJSON2Apex.DataArea> lstDA = new list<CSS_customerOutboundJSON2Apex.DataArea>();
            DA.CustomerName='';
            DA.CustomerCode='';
            DA.LocationAddressline1='';
            DA.LocationAddressline2='';
            DA.LocationAddressline3='';
            DA.PhoneNumber='';
            DA.AreaCode='';
            DA.City='';
            DA.PaymentType='';
            DA.State='';
            DA.Country='';
            DA.Postalcode1='';
            DA.Postalcode2='';
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
                '  \"CustomerName\": \"Test1\", '+
                '  \"LocationAddressline1\": \"\", '+
                '  \"LocationAddressline2\": \"\", '+
                '  \"LocationAddressline3\": \"\", '+
                '  \"PhoneNumber\": \"\", '+
                '  \"AreaCode\": \"\", '+
                '  \"City\": \"\", '+
                '  \"PaymentType\": \"\", '+
                '  \"State\": 0, '+
                '  \"Country\": \"\", '+
                '  \"Postalcode1\": \"\", '+
                '  \"Postalcode2\": \"\" '+
                '}] '+
                '}';
            CSS_customerOutboundJSON2Apex obj = CSS_customerOutboundJSON2Apex.parse(json);
            
            
            List<List<CSS_CampTsbTrp__c>> lstQDocs = CG_BL_Intake.getQSOLDocs(JO.id, JO.esn__c,'en');
            Test.setMock(HttpCalloutMock.class, new CG_CampaignMock_Test());
            
            List<List<CSS_CampTsbTrp__c>> lstCamp = CG_BL_Intake.getCampaigns(JO.esn__c, JO.Service_Model__c,JO.Failure_Date__c, 'en',JO.id);
            List<List<CSS_CampTsbTrp__c>> lstSQDocs = CG_BL_Intake.getSiebelQSOLCampaigns(JO.id, JO.esn__c,'en',JO.Service_Model__c,JO.Failure_Date__c);
            List<List<CSS_CampTsbTrp__c>> llstQLinks = CG_BL_Intake.addQSOLLinksToSiebelData(JO.id,solCompCTTP,lstCAM,lstTRP,lstATC);
            List<css_solution_component__c> lstquery = CG_BL_Intake.addQSOLLinksToSiebelQueryList(solCompCTTP, lstQSOLDocs);    
            css_repair_job b = new css_repair_job();
            b.getQSOLDocs();
            b.statusCode = 1;
            b.statusMessage='123';
            b.getComplaintTypeList4();
            
            
            Test.stopTest();}
    }
    static testMethod void css_rep_job_Test_Method(){
        
        TestData();
        JO.Customer_Name__c = null;
        JO.Shop_Work_Order__c = null;
        JO.Application_Desc__c = null;
        JO.Warranty_Start_Date__c = system.today();
        update JO;
        PageReference p=Page.CSS_JobTnDRj; 
        Test.setCurrentPage(p);  
        ApexPages.currentPage().getParameters().put('id',jo.Id);
        Test.startTest();
        css_repair_job TriageJob1 = new css_repair_job ();
        TriageJob1.workjob.Repair_Location__c = 'Mobile';
        Test.setMock(HttpCalloutMock.class, new CSS_MockHttpResponseGenerator()); 
        TriageJob1.callCreateWoAndUpdateComment();
        Test.stopTest();
        
    } 
    static testMethod void TestForCancelWIDNull(){
        string wid = ApexPages.CurrentPage().getParameters().get('id');
        PageReference pageRef = Page.css_JobRepair;
        Test.setCurrentPage(pageRef);
        Test.startTest(); 
        css_repair_job b = new css_repair_job();
        //b.Cancel();
        Test.stopTest();
    }
    static testmethod void callWarrantyoverviewlinkmethod(){
        test.startTest();
        CSS_Job_Order__c jo = CSS_TestData.createJobOrder(true);
        CSS_claims__c claims = CSS_TestData.createclaims(true,jo.id);
        CG_CL_CreateClaims_Table claimTable = new CG_CL_CreateClaims_Table();
        claimTable.selectedJob = jo.id;
        claimTable.createdfrom = 'Repair RJ';
        css_repair_job b = new css_repair_job();
        
        test.stopTest();
    }
    static testmethod void selectedESNnUnitDetailsmethod(){
        test.startTest();
        css_repair_job b = new css_repair_job();
        b.selectedUnitNumber = 'Testing';
        Test.setMock(HttpCalloutMock.class,new BMSMockHttpResponseGenerator());
        b.getBMSUnitDetails();
        b.selectedESNnUnitDetails();
        test.stopTest();
    } 
    static testmethod void selectedESNnUnitDetailsmethod1(){
        test.startTest();
        css_repair_job b = new css_repair_job();
        b.selectedUnitNumber = 'Testing';
        b.callingLocation = 'ESN';
        b.selectedUnitNumber = '123';
        Test.setMock(HttpCalloutMock.class,new BMSMockHttpResponseGenerator1());
        b.getBMSUnitDetails();
        b.selectedESNnUnitDetails();
        b.selectedUnitDetails();
        test.stopTest();
    } 
    static testmethod void parseQSOLDate1(){
        css_repair_job b = new css_repair_job();
        string dt='1'+'-'+'7'+'-'+'2016';
        b.parseQSOLDate(dt);
    }
    static testmethod void parseQSOLDate2(){
        css_repair_job b = new css_repair_job();
        string dt='1'+'-'+'8'+'-'+'2016';
        b.parseQSOLDate(dt);
    }
    static testmethod void parseQSOLDate3(){
        css_repair_job b = new css_repair_job();
        string dt='1'+'-'+'9'+'-'+'2016';
        b.parseQSOLDate(dt);
    }
    static testmethod void parseQSOLDate4(){
        css_repair_job b = new css_repair_job();
        string dt='1'+'-'+'10'+'-'+'2016';
        b.parseQSOLDate(dt);
    }
    static testmethod void parseQSOLDate5(){
        css_repair_job b = new css_repair_job();
        string dt='1'+'-'+'11'+'-'+'2016';
        b.parseQSOLDate(dt);
    }
    static testmethod void testingMethod(){
        Account acc = new Account();
        acc.Name = 'bangalore';
        acc.Enable_Claims__c = true;
        acc.ERP_System__c = 'One BMS';
        acc.CSS_DBCode__c='33333';
        acc.type = 'Customer';
        acc.CSS_DistributorCode__c='11111';
        acc.CMI_Account_Status__c = 'Active';
        acc.IAM_Service_Provider_Code__c='56270';
        
        insert acc;
        CSS_Job_Order__c job1 =CSS_TestData.createJobOrder(false);
        job1.Customer_Name__c = null;
        job1.Application_Desc__c = null;
        job1.Unit_number__c = null;
        job1.Mileage__c = null;
        job1.ESN__c = null;
        job1.Customer_Name__c = null;
        job1.PSN_Not_Available__c = false;
        job1.General_Symptoms__c = null;
        job1.DSID_WorkGroup__c = 'hhh'; 
        job1.DSID__c= 'sgsd';
        job1.Category_Desc__c = 'test';
        job1.Account__c=acc.id;
        css_repair_job b = new css_repair_job();
        
        b.bmsEnabled = true;
        b.workJob = job1;
        
        test.startTest();
        b.validateBeforeSave();
        job1.Customer_Name__c = 'kk';
        job1.PSN_Not_Available__c = true;
        job1.Shop_Work_Order__c = '34567';
        
        css_repair_job c = new css_repair_job();
        c.isDealer = false;
        c.workJob = job1;
        c.validateBeforeSave();
        c.popupSave();
        
        job1.Shop_Work_Order__c = null;
        c.isDealer = true;
        c.workJob = job1;
        c.validateBeforeSave();
        
        css_repair_job d = new css_repair_job();
        job1.Customer_Code__c = null;
        job1.PSN_Not_Available__c = false;
        d.bmsEnabled = true;
        d.workJob = job1;
        d.validateBeforeSave();
        
        job1.Actual_Technician_Time__c = null;
        job1.Shop_Work_Order__c = '234';
        d.isdealer = true;
        d.workJob = job1;
        d.validateBeforeSave();
        
        job1.Actual_Technician_Time__c = 23.0;
        job1.Shop_Work_Order__c = '234';
        job1.Customer_Code__c = '234';
        d.bmsEnabled = true;
        d.workJob = job1;
        d.validateBeforeSave();
        
        job1.Actual_Technician_Time__c = 23.0;
        job1.Shop_Work_Order__c = '234';
        job1.Customer_Code__c = '234';
        job1.Phone_Number__c = '56567';
        d.bmsEnabled = true;
        d.workJob = job1;
        d.validateBeforeSave();
        
        job1.Actual_Technician_Time__c = 23.0;
        job1.Shop_Work_Order__c = '234';
        job1.Customer_Code__c = '234';
        job1.Phone_Number__c = '6672874287';
        job1.BMS_Last_Name__c = null;
        job1.First_Name__c = 'Anirudh';
        d.bmsEnabled = true;
        d.workJob = job1;
        d.validateBeforeSave();
        
        job1.Actual_Technician_Time__c = 23.0;
        job1.Shop_Work_Order__c = '234';
        job1.Customer_Code__c = '234';
        job1.Phone_Number__c = '6672874287';
        job1.BMS_Last_Name__c = 'Reddy';
        job1.First_Name__c = null;
        d.bmsEnabled = true;
        d.workJob = job1;
        d.validateBeforeSave();
        
        job1.Actual_Technician_Time__c = 23.0;
        job1.Shop_Work_Order__c = '234';
        job1.Customer_Code__c = '234';
        job1.Phone_Number__c = '6672874287';
        job1.BMS_Last_Name__c = 'Reddy';
        job1.First_Name__c = 'Anirudh';
        d.bmsEnabled = true;
        d.workJob = job1;
        d.validateBeforeSave();
        
        job1.Actual_Technician_Time__c = 23.0;
        job1.Shop_Work_Order__c = '234';
        job1.Customer_Code__c = '234';
        job1.Phone_Number__c = '6672874287';
        job1.BMS_Last_Name__c = 'Reddy';
        job1.First_Name__c = 'Anirudh';
        job1.Cstmr_Contacts_Phone__c ='32432';
        d.bmsEnabled = true;
        d.workJob = job1;
        d.validateBeforeSave();
        
        job1.Actual_Technician_Time__c = 23.0;
        job1.Shop_Work_Order__c = '234';
        job1.Customer_Code__c = '234';
        job1.Phone_Number__c = '6672874287';
        job1.BMS_Last_Name__c = 'Reddy';
        job1.First_Name__c = 'Anirudh';
        job1.Cstmr_Contacts_Phone__c ='2563748926';
        d.bmsEnabled = true;
        d.workJob = job1;
        d.validateBeforeSave();
        
        job1.Actual_Technician_Time__c = 23.0;
        job1.Shop_Work_Order__c = '234';
        job1.Customer_Code__c = '234';
        job1.Phone_Number__c = '6672874287';
        job1.BMS_Last_Name__c = 'Reddy';
        job1.First_Name__c = 'Anirudh';
        job1.Cstmr_Contacts_Phone__c ='2563748926';
        job1.Email_Address__c = 'anirudh@gmail.com';
        d.bmsEnabled = true;
        d.workJob = job1;
        d.validateBeforeSave();
        
        job1.Actual_Technician_Time__c = 23.0;
        job1.Shop_Work_Order__c = '234';
        job1.Customer_Code__c = '234';
        job1.Phone_Number__c = '6672874287';
        job1.BMS_Last_Name__c = 'Reddy';
        job1.First_Name__c = 'Anirudh';
        job1.Cstmr_Contacts_Phone__c ='2563748926';
        job1.Email_Address__c = 'anirudh';
        job1.Application_Desc__c = 'test';
        job1.Unit_Number__c = '23';
        d.bmsEnabled = true;
        d.workJob = job1;
        d.validateBeforeSave();
        
        job1.Actual_Technician_Time__c = 23.0;
        job1.Shop_Work_Order__c = '234';
        job1.Customer_Code__c = '234';
        job1.Phone_Number__c = '6672874287';
        job1.BMS_Last_Name__c = 'Reddy';
        job1.First_Name__c = 'Anirudh';
        job1.Cstmr_Contacts_Phone__c ='2563748926';
        job1.Email_Address__c = 'anirudh@gmail.com';
        job1.Application_Desc__c = 'test';
        job1.Unit_Number__c = '23';
        d.bmsEnabled = true;
        d.workJob = job1;
        d.validateBeforeSave();
        
        
        
        job1.Actual_Technician_Time__c = 23.0;
        
        Test.stopTest();
    }
    static testMethod void css_rep_job_Test_Method3(){  
        Test.startTest(); 
        TestData();
        JO.Model__c = null;
        update JO;
        PageReference p=Page.CSS_JobTnDRj; 
        Test.setCurrentPage(p);  
        ApexPages.currentPage().getParameters().put('id',jo.Id); 
        css_repair_job TriageJob1= new css_repair_job ();
        TriageJob1.atthId=attach.id;
        Test.setMock(HttpCalloutMock.class, new CSS_Exit_Test());
        CSS_EDSAuthentication.exitDSID('1234-5678','DSBDT4780'); 
        TriageJob1.dsidIndi = 'O';
        TriageJob1.showPopup();
        TriageJob1.closePopup();
        TriageJob1.closeSrvModPopup();
        TriageJob1.closeSrvModPopup1();
        TriageJob1.redirectPopup();
        TriageJob1.showPopup1();
        TriageJob1.closePopup1();
        TriageJob1.showPopup4();
        TriageJob1.closePopup4();
        TriageJob1.showPopup5();
        TriageJob1.closePopup5();
        TriageJob1.showPopup6();
        TriageJob1.showPopup7();
        TriageJob1.closePopup7();
        TriageJob1.getRepair();
        TriageJob1.processUpload();
        TriageJob1.popupSave();
        TriageJob1.DeleteFile();
        Test.setMock(HttpCalloutMock.class, new CSS_RPVSecMock_Test());
        TriageJob1.getALLRecords();
        TriageJob1.closePopup6();
        TriageJob1.getCamps();
        TriageJob1.getTrps();
        TriageJob1.getTsbs();
        TriageJob1.getAtcs();
        //TriageJob1.saveCheckBox();
        TriageJob1.getRepair();
        TriageJob1.bmsEnabled = true;
        JO.Customer_Code__c = null;
        TriageJob1.closeSession();
        JO.First_Name__c = null;
        TriageJob1.validateBeforeSave();
        TriageJob1.showRepairs = false;
        TriageJob1.showResolutionWithRepair = true;
        TriageJob1.saveAndCloseJob();
        string QSOLDate = '15-11-2016';
        Date parseQSOLDate = TriageJob1.parseQSOLDate(QSOLDate);
        
        CSS_Integration_Details__c cid = CSS_TestData.createIntegrationDetails(false);
        cid.name = 'CSS_SPDataLookup';
        cid.ApplicationName__c = 'CSS_SPDataLookup';
        cid.End_Point__c = 'https://services-stg.cummins.com/csswarranty/serviceproviderdataTest';
        insert cid;
        
        Test.setMock(HttpCalloutMock.class , new CG_getServiceProviderDataIntakemock_test());
        Test.stopTest();  
        
    } 
    
    
}