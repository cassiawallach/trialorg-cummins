@isTest
public class CSS_QsolEdsControllerTest {
    
    public static CSS_Fault_Code__c createFaultCode(CSS_Job_Order__c job, String fcCode,Integer seq,String mod,String fcType,String relFC){
        CSS_Fault_Code__c fc = new CSS_Fault_Code__c(FaultCodeR2__c = fcCode,Related_Fault_Code__c = relFC);
        fc.Name = fcCode;
        fc.Job_Order__c = job.Id;
        fc.Sequence__c = seq;
        fc.Fault_Code_Type__c = fcType;
        fc.Mod__c = mod;
        fc.isPole__c = false;
        insert fc;
        return fc;        
    }
    public static CSS_Solutions__c createSolutionDets(CSS_Job_Order__c job,CSS_Fault_Code__c fc, String title,String csName,Integer rank){
        CSS_Solutions__c sol = new CSS_Solutions__c();
        sol.FaultCode__c = fc.Id;
        sol.Service_Job__c = job.Id;
        sol.Name = csName;
        sol.Case_Name__c = csName;
        sol.Solution_Title__c = title;
        sol.Rank__c =20;
        sol.Diagnose_SRT__c = null;
        //sol.Diagnostic_Response__c = 'gvdg';
        //sol.Diagnostic_notes__c='sample diagonistic notes';
        
        insert sol;
        return sol;
    }
    public static testMethod void testJobOrderData() {
            Account acc = new Account();
            acc.name='Kenworth Sales Co';
            acc.CSS_DistributorCode__c='02466';
            acc.IAM_Service_Provider_Code__c='19134';
            acc.Type='Dealer Account';
            acc.CMI_Account_Status__c = 'Active';
            insert acc;
        CSS_Job_Order__c jobOrder = new CSS_Job_Order__c();
        jobOrder.Status__c = 'Created/Not Assigned';
        jobOrder.DSID__C='DSBDT5719';
        jobOrder.DSID_WorkGroup__c = '';
        jobOrder.Account__c = acc.id;
        insert jobOrder;
        //CSS_Fault_Code__c fc1 = createFaultCode(jobOrder,'441',1,'0','APD-P','234,546');
        CSS_Fault_Code__c fc1 = new CSS_Fault_Code__c(FaultCodeR2__c = '441',Related_Fault_Code__c = '234,546');
        fc1.Name = '441';
        fc1.Job_Order__c = jobOrder.Id;
        fc1.Sequence__c = 1;
        fc1.Fault_Code_Type__c = 'APD-P';
        fc1.Mod__c = '0';
        fc1.isPole__c = false;
        insert fc1;
        
        //CSS_Solutions__c sol1 = createSolutionDets(jobOrder,fc1,'Sample Title','Sample Case Name',0);
        //CSS_Solutions__c sol2 = createSolutionDets(jobOrder,fc1,'Sample Title','Sample Case Name',1);
        CSS_Solutions__c sol1 = new CSS_Solutions__c();
        sol1.FaultCode__c = fc1.Id;
        sol1.Service_Job__c = jobOrder.Id;
        sol1.Name = 'Sample Case Name';
        sol1.Case_Name__c = 'Sample Case Name';
        sol1.Solution_Title__c = 'Sample Title';
        sol1.Rank__c =0;
        sol1.Diagnostic_notes__c='sample diagonistic notes';
        //sol1.Diagnostic_Response__c = 'gvdg';
        insert sol1;
        
        CSS_Solution_Component__c csc=new CSS_Solution_Component__c();
        csc.Action__c='test';
        csc.Solutions__c=sol1.id;
        csc.Service_Job__c=jobOrder.id;
        csc.Selected_Component__c=true;
        insert csc;
        
        
        CSS_Solution_Component__c csc1=new CSS_Solution_Component__c();
        csc1.Action__c='test';
        csc1.Solutions__c=sol1.id;
        csc1.Service_Job__c=jobOrder.id;
        csc1.Selected_Component__c=false;
        insert csc1;
        
        list<CSS_Solution_Component__c> slclist=new list<CSS_Solution_Component__c>();
        slclist.add(csc);
        slclist.add(csc1);
        update slclist;
        Set<CSS_Solution_Component__c> setcomp = new  Set<CSS_Solution_Component__c>();
        setcomp.add(csc);
        setcomp.add(csc1);
        //update setcomp;
        
        Id recTypeIdpart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'Parts');
        
        CSS_Parts_Options__c parts = new CSS_Parts_Options__c();
        parts.recordtypeId = recTypeIdpart;
        parts.Option_Number__c = 'O-111';
        parts.Service_Job__c = jobOrder.id;
        parts.selected_part__c = true;
        parts.FailurepartId__c = csc.Id;
        parts.Part_Assignment__c = 'Primary';
        parts.Solutions__c=sol1.id;
        insert parts;
        
        CSS_Parts_Options__c parts1 = new CSS_Parts_Options__c();
        parts1.recordtypeId = recTypeIdpart;
        parts1.Option_Number__c = 'O-111';
        parts1.Service_Job__c = jobOrder.id;
        parts1.selected_part__c = true;
        parts1.FailurepartId__c = csc1.Id;
        parts1.Part_Assignment__c = 'Primary';
        parts1.Solutions__c=sol1.id;
        insert parts1;
        
        CSS_SRT__c srt=new CSS_SRT__c();
        srt.Solution_Number__c=sol1.id;
        srt.Job_Order__c=jobOrder.id;
        srt.Type__c = 'Diagnosis';
        srt.SRT_Time__c=0.6;
        srt.SRT_AccessiblityCheck__c = true;
        srt.Solution_Number__c = sol1.id;
        srt.Job_Order__c = jobOrder.Id;
        insert srt;
        
        CSS_SRT__c srt2=new CSS_SRT__c();
        srt2.Solution_Number__c=sol1.id;
        srt2.Job_Order__c=jobOrder.id;
        srt2.Type__c = 'Repair';
        srt2.SRT_Time__c=60.0;
        insert srt2;        
        
        CSS_SRT__c srt3=new CSS_SRT__c();
        srt3.Solution_Number__c=sol1.id;
        srt3.Job_Order__c=jobOrder.id;
        srt3.Type__c = 'Repair';
        srt3.SRT_Time__c=60.0;
        insert srt3;   
        
        
        CSS_JobEventTemporary__c jobEventTemp  =CSS_TestData.createJobEventTempObj(false);
        jobEventTemp.Name= '441';
        insert jobEventTemp;
        
        CSS_accountLanguage__c lang = CSS_TestData.createAccountLanguage(true);
        
        ApexPages.CurrentPage().getParameters().put('Id',jobOrder.id);
        ApexPages.CurrentPage().getParameters().put('fcid',fc1.Id);
        
        css_tnd_job tndCon = new css_tnd_job();
        CSS_QsolEdsController controller = new CSS_QsolEdsController(tndCon);  
        CSS_QsolEdsController.solWrapper edsWrap = new CSS_QsolEdsController.solWrapper('Pass','123','Required','12345');
        controller.comp=slclist;
        //edsWrap.solNum = '123';
        //edsWrap.status='Pass';
        //edsWrap.comment='Required';
        //edsWrap.dsid='12345';
        //controller.solWrapper = edsWrap;
        controller.Ins_JobId = jobOrder.id;
        // controller.cancel = false;
        //controller.close();
        
        // Test.startTest();
        Test.setMock(HttpCalloutMock.class, new CSS_GetSolDetails_Test());        
        
        controller.faultCodeClick();    
        
        Test.setMock(WebServiceMock.class, new CSS_GetWarrantyDocs_Test());
        Test.startTest();
        controller.getQSOLDocs();
        controller.getQSOLDocs_Existing();
        //controller.nestValidateResponse();
        controller.nextSolution();
        controller.sKNumber = 'Test';
        controller.solErrorMsg = 'Test';
        controller.queryFrom = 'Test';
        controller.validateResponse();
        controller.UpdateSolNotes();
        //controller.UpdateNestedSolNotes();
        controller.prevSolution();
        controller.reportProblemComments();
        
        //test cover 
        string json = '{"key":"1234","message":"This is a test","messageArg":["a","b"],"solutionNumber":"K74452217","solutionTitle":"Fault Code 122 triggered by another fault code","coreIssue":"There are some instances when a fault code is recorded, but is strongnotstrong the first fault code that should be diagnosed.  br ","modificationDate":"01022016","status":"success","verification":"strongConditionsstrong ulliTurn keyswitch ON.liliConnect INSITE electronic service tool.liulstrongActionstrongbr Check for active fault codes. ulliUse INSITE electronic service tool to read the fault codes.liulstrongSpecificationstrong ulliIf Fault Code 227, 352, or 386 is active, then perform a search on the appropriate fault and troubleshoot that fault prior to troubleshooting Fault Code 122.liul","resolution":"pPerform a search on the appropriate fault code.p","poleLogicSolution":true,"components":[{"value":"string","failureId":"string"}],"repCompoundSolutions":[{"solutionNumber":"K74452217","solutionTitle":"Fault Code 122 triggered by another fault code","coreIssue":"There are some instances when a fault code is recorded, but is strongnotstrong the first fault code that should be diagnosed.  br ","modificationDate":"01022016","status":"success","verification":"strongConditionsstrong ulliTurn keyswitch ON.liliConnect INSITE electronic service tool.liulstrongActionstrongbr Check for active fault codes. ulliUse INSITE electronic service tool to read the fault codes.liulstrongSpecificationstrong ulliIf Fault Code 227, 352, or 386 is active, then perform a search on the appropriate fault and troubleshoot that fault prior to troubleshooting Fault Code 122.liul","resolution":"pPerform a search on the appropriate fault code.p","poleLogicSolution":true,"components":[{"value":"string","failureId":"string"}]}],"verCompoundSolutions":[{"solutionNumber":"K74452217","solutionTitle":"Fault Code 122 triggered by another fault code","coreIssue":"There are some instances when a fault code is recorded, but is strongnotstrong the first fault code that should be diagnosed.  br ","modificationDate":"01022016","status":"success","verification":"strongConditionsstrong ulliTurn keyswitch ON.liliConnect INSITE electronic service tool.liulstrongActionstrongbr Check for active fault codes. ulliUse INSITE electronic service tool to read the fault codes.liulstrongSpecificationstrong ulliIf Fault Code 227, 352, or 386 is active, then perform a search on the appropriate fault and troubleshoot that fault prior to troubleshooting Fault Code 122.liul","resolution":"pPerform a search on the appropriate fault code.p","poleLogicSolution":true,"components":[{"value":"string","failureId":"string"}]}]}';
        CSS_J2ASolution_EDS r = CSS_J2ASolution_EDS.parse(json);
        //test cover end
        controller.addSolComponentsAndVerSols(sol1,r);
        controller.getUpdatedNestedSols(r); 
        controller.getSolutionDetails();
        jobOrder.Status__c = 'Triage & Diagnosis';   
        update jobOrder;
        controller.ContinueToRepair();
        controller.returnToFCView();
        Test.setMock(HttpCalloutMock.class, new CSS_ReportProblem_Test());       
        controller.closeOutofOrder();
        ID testID;
        //controller.getPartsListCompSol(testID);
        Date date1;
        String testing;
        
        //CSS_QsolEdsController.getAccountCodes(testing, testing, date1, testing, testing, testing, date1, testing,testing);
        //controller.getPartsListCompSol();
        controller.addNestedSolsComponents();
        controller.selectedNestSolId=sol1.Id;
        CSS_J2ASolution_EDS.verCompoundSolutions j2aSol = new CSS_J2ASolution_EDS.verCompoundSolutions();
        CSS_QsolEdsController.NestedSolutionsClass nestedSol= new CSS_QsolEdsController.NestedSolutionsClass(j2aSol,sol1);
        controller.selectedNestSolTitle= 'Test';
        controller.selectedSol= sol1; 
        // controller.UpdateNestedSolNotes();
        CSS_J2ANestSol_EDS NesSol = new CSS_J2ANestSol_EDS();
        controller.solDet1 = NesSol;
        map<string, CSS_QsolEdsController.NestedSolutionsClass> respNestedSolutionsMapTest = new map<string, CSS_QsolEdsController.NestedSolutionsClass>();
        respNestedSolutionsMapTest.put('Test',nestedSol);
        controller.respNestedSolutionsMap = respNestedSolutionsMapTest;
        controller.getNestSolutionDetails();
        controller.UpdateNestSolNotes();
        controller.returnToFCView();
        controller.closeOutofOrd(); 
        controller.remCharcounterNest = 4000;
        controller.correctplusStylClass = 'test';
        controller.selectedNestSolTitle1 = 'test1';
        // controller.selectedNestSolId = 'test2';
        //  controller.selectedNestSolId = 'test3';
        controller.getSRTComponentOnLoad();
        //  CSS_QsolEdsController.parentId= String.ValueOf(csc.Id);
        controller.getPartsList();  
        controller.refreshPartsList();
        // controller.parentCheckBoxLogic();
        //  controller.childCheckBoxLogic();
        //controller.partssave();
        controller.getreplacementReasonOptions(); 
        Test.stopTest();
        
    }/*
static testmethod void test1(){
CSS_JobEventTemporary__c qsolRetrivedFCMaster = new CSS_JobEventTemporary__c();
qsolRetrivedFCMaster.File_Name__c = 'Test';
insert qsolRetrivedFCMaster;
PageReference p=Page.CSS_Jobplan; 
Test.setCurrentPage(p);  
//ApexPages.currentPage().getParameters().put('id',qsolRetrivedFCMaster.Id); 
p = new Pagereference('/apex/CSS_JobTndTs?id='+qsolRetrivedFCMaster.id);   
}*/
    static testmethod void qsolredirect(){
        css_tnd_job tndCon = new css_tnd_job();
        CSS_QsolEdsController  edsSym1 = new CSS_QsolEdsController(tndCon);
        CSS_Job_Order__c job = CSS_TestData.createJobOrder(true);
        CSS_JobEventTemporary__c qsolRetrivedFCMaster = new CSS_JobEventTemporary__c();
        CSS_Solutions__c sol = new CSS_Solutions__c();
        //sol.FaultCode__c = fc.Id;
        sol.Id = edsSym1.selectedNestSolId;
        sol.Name = 'csName';
        sol.Diagnostic_notes__c = 'csName';
        sol.Diagnostic_Response__c = 'gvdgf';
        sol.Solution_Title__c = 'title';
        sol.Service_Job__c=job.id;
        //sol.Rank__c =rank;
        insert sol;
        qsolRetrivedFCMaster = CSS_TestData.createJobEventTempObj(true);
        edsSym1.qsolRetrivedFCMaster = qsolRetrivedFCMaster;
        PageReference pageRef;  
        pageRef = edsSym1.qsolredirect();
        // edsSym1.rank = edsSym1.rank;
        //edsSym1.UpdateNestSolNotes();
        
        
    }
    public static CSS_Job_Order__c JO;
    
    public static CSS_Solutions__c cssSol;
    public static css_srt__c cssSRT;
    public static CSS_CampTsbTrp__c cssTrp;
    public static CSS_CampTsbTrp__c cssCAM;
    public static CSS_CampTsbTrp__c cssTSB;
    public static CSS_CampTsbTrp__c cssATC;
    
    
    public static void TestData(){
        CSS_Job_Order__c job =CSS_TestData.createJobOrder(true);
        
        CSS_Fault_Code__c  faultCode= new CSS_Fault_Code__c ();
        faultCode.Fault_Code_Type__c ='BPD';
        faultCode.Sequence__c = 1;
        faultCode.Job_Order__c=job.id;
        // faultCode.Fault_Code__c =faultCodeMaster.Id;
        insert faultCode;
        
        ApexPages.CurrentPage().getParameters().put('id',job.id);
        
        CSS_Integration_Details__c CID = new CSS_Integration_Details__c();
        CID.name = 'sample';
        CID.ApplicationName__c = 'QSOL';
        CID.End_Point__c='https://qsolpilot.cummins.com/csswebservices/qsol';
        CID.IsActive__c = true;
        CID.Key__c='Rv++7jk31axoHDVpTvA3bgbFQFnJ7d4t9GGFfxtox6g=';
        CID.Passcode__c='gTqnM27bVy+M3A/Fmc3s0C6ZJorDI//NobXZXB6wNOU=';
        CID.Username__c = 'Ke/SFT1NcHvb0XlJXmnBeMvno2u23G8m5ju56+YHSbQ=';
        insert CID;
        
        CSS_accountLanguage__c lang = CSS_TestData.createAccountLanguage(true);
        
        Id AdminProfile = [select Id from Profile where Name='System Administrator'].Id;
        User testUser = new User(firstname='TestUser', Username='testemailid'+Math.random()*Math.random()+'@testemailprovider.com',Alias='P0044',Email='user@gmail.com',LastName='SA',ProfileId=AdminProfile,
                                 TimeZoneSidKey='America/Chicago',LanguageLocaleKey='en_US',LocaleSidKey='en_US',User_Location__c = '03742-02991');
        System.AssertEquals(testUser.Firstname, 'TestUser');
        
        CSS_CampTsbTrp__c ct = new CSS_CampTsbTrp__c();
        ct.name = 'CAM';
        ct.name = 'TRP';
        ct.name = 'TSB';
        ct.name = 'ATC';
        list<CSS_CampTsbTrp__c> solutionList = new list<CSS_CampTsbTrp__c>();
        CSS_CampTsbTrp__c solRec = new CSS_CampTsbTrp__c( Doc_Num__c='TSB140168',URL__c='https://qsolpilot.cummins.com/qs3/pubsys2/xml/en/tsb/2014/tsb140168.html',
                                                         Type__c='CAM',Doc_Title__c='xyz' ,Performed__c= false,Cu_Language__c = 'Hindi',
                                                         Performed_Review__c= false,Reviewed__c= false , esn__c = '73695829');
        solutionList.add(solRec);
        
        CSS_CampTsbTrp__c solRec2 = new CSS_CampTsbTrp__c( Doc_Num__c='TSB14013368',URL__c='https://qsolpilot.cummins.com/qs9/pubsys2/xml/en/tsb/2014/tsb140168.html',
                                                          Type__c='TRP',Doc_Title__c='xyz' ,Performed__c= false,
                                                          Performed_Review__c= true,Reviewed__c= false , esn__c = '1234');
        solutionList.add(solRec2); 
        
        CSS_CampTsbTrp__c solRec1 = new CSS_CampTsbTrp__c( Doc_Num__c='TSB1401689',URL__c='https://qsolpilot.cummins.com/qs3/pubsys2/xml/en1/tsb/2014/tsb140168.html',
                                                          Type__c='TSB',Doc_Title__c='xyzk' ,Performed__c= true,
                                                          Performed_Review__c= false,Reviewed__c= false , esn__c = '1234');
        solutionList.add(solRec1);
        
        CSS_CampTsbTrp__c solRec3 = new CSS_CampTsbTrp__c( Doc_Num__c='TSB1401689',URL__c='https://qsolpilot.cummins.com/qs3/pubsys2/xml/en1/tsb/2014/tsb140168.html',
                                                          Type__c='ATC',Doc_Title__c='xyzk' ,Performed__c= true,
                                                          Performed_Review__c= false,Reviewed__c= false , esn__c = '1234');
        solutionList.add(solRec3);
        
        insert solutionList;
        
        
        
        cssTrp = new CSS_CampTsbTrp__c();
        cssTrp.Name = 'Test Trp';
        cssTrp.Job_Order__c = JO.id;
        cssTrp.performed_review__c = true;
        cssTrp.performed__c = false;
        cssTrp.Cu_Language__c = 'Hindi';
        insert cssTrp;
        
        css_tnd_job x = new css_tnd_job();
        CSS_QsolEdsController qsolcon= new CSS_QsolEdsController(x);
        //qsolcon.getQSOLDocs();
        qsolcon.getSols();
        
        
    }   
    /* static testMethod void css_QsolDocs_Test_Method12()
{

TestData();
css_tnd_job TriageJob1= new css_tnd_job ();
CSS_QsolEdsController qsolcon= new CSS_QsolEdsController(TriageJob1);
TriageJob1.updateNotes();
Test.startTest(); 
Test.setMock(WebServiceMock.class, new CSS_GetWarrantyDocs_Test());
qsolcon.getQSOLDocs(); 

Test.stopTest();

} */
    static testMethod void testconstructor(){
        css_tnd_job tndCon = new css_tnd_job();
        ApexPages.CurrentPage().getParameters().put('rank','3');
        CSS_QsolEdsController  edsSym1 = new CSS_QsolEdsController(tndCon);
    }
    public static testMethod void testJobOrderData1() {
        Account acc = new Account();
            acc.name='Kenworth Sales Co';
            acc.CSS_DistributorCode__c='02466';
            acc.IAM_Service_Provider_Code__c='19134';
            acc.Type='Dealer Account';
            acc.CMI_Account_Status__c = 'Active';
            insert acc;
        CSS_Job_Order__c jobOrder = new CSS_Job_Order__c();
        jobOrder.Status__c = 'Triage & Diagnosis';
        jobOrder.DSID__C='DSBDT5719';
        jobOrder.Account__c = acc.id;
        jobOrder.DSID_WorkGroup__c = '';
        insert jobOrder;
        //CSS_Fault_Code__c fc1 = createFaultCode(jobOrder,'441',1,'0','APD-P','234,546');
        CSS_Fault_Code__c fc1 = new CSS_Fault_Code__c(FaultCodeR2__c = '441',Related_Fault_Code__c = '234,546');
        fc1.Name = '441';
        fc1.Job_Order__c = jobOrder.Id;
        fc1.Sequence__c = 1;
        fc1.Fault_Code_Type__c = 'APD-P';
        fc1.Mod__c = '0';
        fc1.isPole__c = false;
        insert fc1;
        
        //CSS_Solutions__c sol1 = createSolutionDets(jobOrder,fc1,'Sample Title','Sample Case Name',0);
        //CSS_Solutions__c sol2 = createSolutionDets(jobOrder,fc1,'Sample Title','Sample Case Name',1);
        CSS_Solutions__c sol1 = new CSS_Solutions__c();
        sol1.FaultCode__c = fc1.Id;
        sol1.Service_Job__c = jobOrder.Id;
        sol1.Name = 'Sample Case Name';
        sol1.Case_Name__c = 'Sample Case Name';
        sol1.Solution_Title__c = 'Sample Title';
        sol1.Rank__c =0;
        
        insert sol1;
        
        CSS_Solution_Component__c csc=new CSS_Solution_Component__c();
        csc.Action__c='test';
        csc.Solutions__c=sol1.id;
        csc.Service_Job__c=jobOrder.id;
        csc.Selected_Component__c=true;
        
        insert csc;
        
        
        CSS_Solution_Component__c csc1=new CSS_Solution_Component__c();
        csc1.Action__c='test';
        csc1.Solutions__c=sol1.id;
        csc1.Service_Job__c=jobOrder.id;
        csc1.Selected_Component__c=false;
        insert csc1;
        
        list<CSS_Solution_Component__c> slclist=new list<CSS_Solution_Component__c>();
        slclist.add(csc);
        slclist.add(csc1);
        update slclist;
        Set<CSS_Solution_Component__c> setcomp = new  Set<CSS_Solution_Component__c>();
        setcomp.add(csc);
        setcomp.add(csc1);
        //update setcomp;
        
        Id recTypeIdpart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'Parts');
        
        CSS_Parts_Options__c parts = new CSS_Parts_Options__c();
        parts.recordtypeId = recTypeIdpart;
        parts.Option_Number__c = 'O-111';
        parts.Service_Job__c = jobOrder.id;
        parts.selected_part__c = true;
        parts.FailurepartId__c = csc.Id;
        parts.Part_Assignment__c = 'Primary';
        parts.Solutions__c=sol1.id;
        parts.Default_Part_Quantity__c = 10;
        insert parts;
        
        CSS_Parts_Options__c parts1 = new CSS_Parts_Options__c();
        parts1.recordtypeId = recTypeIdpart;
        parts1.Option_Number__c = 'O-111';
        parts1.Service_Job__c = jobOrder.id;
        parts1.selected_part__c = true;
        parts1.FailurepartId__c = csc1.Id;
        parts1.Part_Assignment__c = 'Primary';
        parts1.Solutions__c=sol1.id;
        insert parts1;
        
        CSS_SRT__c srt=new CSS_SRT__c();
        srt.Solution_Number__c=sol1.id;
        srt.Job_Order__c=jobOrder.id;
        srt.Type__c = 'Diagnosis';
        srt.SRT_Time__c=0.6;
        insert srt;
        
        CSS_SRT__c srt2=new CSS_SRT__c();
        srt2.Solution_Number__c=sol1.id;
        srt2.Job_Order__c=jobOrder.id;
        srt2.Type__c = 'Repair';
        srt2.SRT_Time__c=60.0;
        insert srt2;        
        
        CSS_SRT__c srt3=new CSS_SRT__c();
        srt3.Solution_Number__c=sol1.id;
        srt3.Job_Order__c=jobOrder.id;
        srt3.Type__c = 'Repair';
        srt3.SRT_Time__c=60.0;
        insert srt3;   
        
        
        CSS_JobEventTemporary__c jobEventTemp  =CSS_TestData.createJobEventTempObj(false);
        jobEventTemp.Name= '441';
        insert jobEventTemp;
        
        CSS_accountLanguage__c lang = CSS_TestData.createAccountLanguage(true);
        
        ApexPages.CurrentPage().getParameters().put('Id',jobOrder.id);
        ApexPages.CurrentPage().getParameters().put('fcid',fc1.Id);
        
        css_tnd_job tndCon = new css_tnd_job();
        CSS_QsolEdsController controller = new CSS_QsolEdsController(tndCon);  
        CSS_QsolEdsController.solWrapper edsWrap = new CSS_QsolEdsController.solWrapper('Pass','123','Required','12345');
        controller.comp=slclist;
        //edsWrap.solNum = '123';
        //edsWrap.status='Pass';
        //edsWrap.comment='Required';
        //edsWrap.dsid='12345';
        //controller.solWrapper = edsWrap;
        controller.Ins_JobId = jobOrder.id;
        // controller.cancel = false;
        //controller.close();
        
        // Test.startTest();
        Test.setMock(HttpCalloutMock.class, new CSS_GetSolDetails_Test());        
        
        controller.faultCodeClick();    
        
        Test.setMock(WebServiceMock.class, new CSS_GetWarrantyDocs_Test());
        Test.startTest();
        controller.getQSOLDocs();
        controller.getQSOLDocs_Existing();
        controller.nextSolution();
        controller.sKNumber = 'Test';
        controller.solErrorMsg = 'Test';
        controller.queryFrom = 'Test';
        controller.validateResponse();
        controller.UpdateSolNotes();
        //controller.ContinueToRepairNested();
        //controller.prevSolution();
        controller.reportProblemComments();
        
        //test cover 
        string json = '{"key":"1234","message":"This is a test","messageArg":["a","b"],"solutionNumber":"K74452217","solutionTitle":"Fault Code 122 triggered by another fault code","coreIssue":"There are some instances when a fault code is recorded, but is strongnotstrong the first fault code that should be diagnosed.  br ","modificationDate":"01022016","status":"success","verification":"strongConditionsstrong ulliTurn keyswitch ON.liliConnect INSITE electronic service tool.liulstrongActionstrongbr Check for active fault codes. ulliUse INSITE electronic service tool to read the fault codes.liulstrongSpecificationstrong ulliIf Fault Code 227, 352, or 386 is active, then perform a search on the appropriate fault and troubleshoot that fault prior to troubleshooting Fault Code 122.liul","resolution":"pPerform a search on the appropriate fault code.p","poleLogicSolution":true,"components":[{"value":"string","failureId":"string"}],"repCompoundSolutions":[{"solutionNumber":"K74452217","solutionTitle":"Fault Code 122 triggered by another fault code","coreIssue":"There are some instances when a fault code is recorded, but is strongnotstrong the first fault code that should be diagnosed.  br ","modificationDate":"01022016","status":"success","verification":"strongConditionsstrong ulliTurn keyswitch ON.liliConnect INSITE electronic service tool.liulstrongActionstrongbr Check for active fault codes. ulliUse INSITE electronic service tool to read the fault codes.liulstrongSpecificationstrong ulliIf Fault Code 227, 352, or 386 is active, then perform a search on the appropriate fault and troubleshoot that fault prior to troubleshooting Fault Code 122.liul","resolution":"pPerform a search on the appropriate fault code.p","poleLogicSolution":true,"components":[{"value":"string","failureId":"string"}]}],"verCompoundSolutions":[{"solutionNumber":"K74452217","solutionTitle":"Fault Code 122 triggered by another fault code","coreIssue":"There are some instances when a fault code is recorded, but is strongnotstrong the first fault code that should be diagnosed.  br ","modificationDate":"01022016","status":"success","verification":"strongConditionsstrong ulliTurn keyswitch ON.liliConnect INSITE electronic service tool.liulstrongActionstrongbr Check for active fault codes. ulliUse INSITE electronic service tool to read the fault codes.liulstrongSpecificationstrong ulliIf Fault Code 227, 352, or 386 is active, then perform a search on the appropriate fault and troubleshoot that fault prior to troubleshooting Fault Code 122.liul","resolution":"pPerform a search on the appropriate fault code.p","poleLogicSolution":true,"components":[{"value":"string","failureId":"string"}]}]}';
        CSS_J2ASolution_EDS r = CSS_J2ASolution_EDS.parse(json);
        //test cover end
        controller.addSolComponentsAndVerSols(sol1,r);
        controller.getUpdatedNestedSols(r); 
        controller.getSolutionDetails();
        jobOrder.Status__c = 'Triage & Diagnosis';   
        update jobOrder;
        controller.ContinueToRepair();
        controller.returnToFCView();
        Test.setMock(HttpCalloutMock.class, new CSS_ReportProblem_Test());       
        controller.closeOutofOrder();
        ID testID;
        //controller.getPartsListCompSol(testID);
        Date date1;
        String testing;
        
        //CSS_QsolEdsController.getAccountCodes(testing, testing, date1, testing, testing, testing, date1, testing,testing);
        //controller.getPartsListCompSol();
        controller.addNestedSolsComponents();
        controller.selectedNestSolId=sol1.Id;
        CSS_J2ASolution_EDS.verCompoundSolutions j2aSol = new CSS_J2ASolution_EDS.verCompoundSolutions();
        CSS_QsolEdsController.NestedSolutionsClass nestedSol= new CSS_QsolEdsController.NestedSolutionsClass(j2aSol,sol1);
        controller.selectedNestSolTitle= 'Test';
        controller.selectedSol= sol1; 
        // controller.UpdateNestedSolNotes();
        CSS_J2ANestSol_EDS NesSol = new CSS_J2ANestSol_EDS();
        controller.solDet1 = NesSol;
        map<string, CSS_QsolEdsController.NestedSolutionsClass> respNestedSolutionsMapTest = new map<string, CSS_QsolEdsController.NestedSolutionsClass>();
        respNestedSolutionsMapTest.put('Test',nestedSol);
        controller.respNestedSolutionsMap = respNestedSolutionsMapTest;
        controller.getNestSolutionDetails();
        controller.UpdateNestSolNotes();
        controller.returnToFCView();
        controller.closeOutofOrd(); 
        controller.remCharcounterNest = 4000;
        controller.correctplusStylClass = 'test';
        controller.selectedNestSolTitle1 = 'test1';
        // controller.selectedNestSolId = 'test2';
        //  controller.selectedNestSolId = 'test3';
        controller.getSRTComponentOnLoad();
        //  CSS_QsolEdsController.parentId= String.ValueOf(csc.Id);
        controller.getPartsList();  
        controller.refreshPartsList();
        // controller.parentCheckBoxLogic();
         controller.ContinueToRepairNested();
        controller.nestValidateResponse();
        controller.getreplacementReasonOptions(); 
        controller.AccessSrtdisableNested();
        controller.deletesolCompNparts();
        controller.deleteNestedSolCompNparts();
       // controller.updateSol(sol1.id,  'solDiagnose', 'solDiagnoseNotes', true);
        Test.stopTest();
        
    }
}