@isTest
public class CSS_JobPlanOverviewControllerNew_Test {

    @testSetup static void testdatasetup(){ 
        list<string> type=  new list<string>{'ApprovalAuthCode','FailCodes','CDSFaultCodes'};
        list<CSS_JobEventTemporary__c> jobs = new list<CSS_JobEventTemporary__c>();
        integer index =0;
        for(integer i=0; i<10;i++){
            if(i>=type.size())index =0;
            CSS_JobEventTemporary__c JETsys = new CSS_JobEventTemporary__c();
            JETsys.Attribute1__c = 'TH';
            JETsys.Attribute4__c ='TS';
            JETsys.key__c = type[index];
            JETsys.Attribute3__c = 'TURBO';
            JETsys.Active__c= true;
            JETsys.Attribute5__c = 'ASSEMBLY';
            JETsys.Reason__c = '{\r\n\t\"Header\": {\r\n\t\t\"ReturnCodeDescription\": \"Normal, Successful completion.\",\r\n\t\t\"ReturnCode\": \"ORA-00000\",\r\n\t\t\"MessageIdentifier\": \"S\"\r\n\t},\r\n\t\"DataArea\": [{\r\n\t\t\"SystemCode\": \"WF\",\r\n\t\t\"FailureName\": \"ATC 1795\",\r\n\t\t\"FailureMode\": \"SP\",\r\n\t\t\"FailureID\": \"F30003750\",\r\n\t\t\"ComponentCode\": \"HA\"\r\n\t}]\r\n}';
            insert JETsys;
            jobs.add(JETsys);
            index++;
        }
        for(integer i=0; i<10;i++){
            if(i>=type.size())index =0;
            CSS_JobEventTemporary__c JETsys = new CSS_JobEventTemporary__c();
            JETsys.Attribute1__c = 'POL';
            JETsys.Attribute2__c = 'MISCELLANEOUS - KA91 ADD';
            JETsys.Attribute4__c ='POL-MISCELLANEOUS - KA91 ADD-02';
            JETsys.key__c = 'AccountCodes';
            JETsys.Attribute3__c = '02';
            JETsys.Active__c= true;
            JETsys.Attribute5__c = 'N';
            JETsys.Reason__c = '{\r\n\t\"Header\": {\r\n\t\t\"ReturnCodeDescription\": \"Normal, Successful completion.\",\r\n\t\t\"ReturnCode\": \"ORA-00000\",\r\n\t\t\"MessageIdentifier\": \"S\"\r\n\t},\r\n\t\"DataArea\": [{\r\n\t\t\"SystemCode\": \"WF\",\r\n\t\t\"FailureName\": \"ATC 1795\",\r\n\t\t\"FailureMode\": \"SP\",\r\n\t\t\"FailureID\": \"F30003750\",\r\n\t\t\"ComponentCode\": \"HA\"\r\n\t}]\r\n}';
            insert JETsys;
            jobs.add(JETsys);
            index++;
        }
        //      insert jobs;
        CSS_Job_Order__c jobRef2 = CSS_TestData.createJobOrder(true); 
        
        list<CSS_Solutions__c> sollist=new list<CSS_Solutions__c>();
        CSS_Solutions__c solRef2 =  CSS_TestData.createSolutions(false,jobRef2.Id);
        solRef2.Repair_Response__c='Sucessful';
        insert solRef2;

         List<CSS_Solution_Component__c> solComList = new List<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solComRef = CSS_TestData.createSRT(false,jobRef2.Id,solRef2.Id);
        solComRef.System_Code__c = 'Test';

        solComRef.Component_Code__c = 'Test';
        solComRef.Failure_Mode__c = 'Test';
        solComRef.Solutions__c =solRef2.id;
        solComRef.AccountCodeType__c = 'Test-Test';
        solComRef.AccountCode_Call_Status__c = 'Failure';
        solComRef.Failure_Point__c=11.0;
        solComRef.Failure_Measure__c = null;
        //       solComRef.Failure_Date__c=date.parse('12-27-2014');
        solComRef.Failure_Date__c=date.today();
        solComRef.AccountCode__c = 'tst';
        solComRef.AccountCodeEdit__c='test';
        solComRef.Failure_Measure__c='test';
        solComRef.Failure_Point__c=1234;
        solComRef.name ='unlisted';
        System.debug('The Solution Component Object');
        solComList.add(solComRef);

    }
    
    public static testMethod void TestMethodacccode() {
        List<SelectOption> accCodes12 = new List<SelectOption>();
        accCodes12.add(new SelectOption('Test1','Test1'));
        CSS_JobPlanOverviewControllerNew getcomqw = new CSS_JobPlanOverviewControllerNew();
        getcomqw.accCodes = accCodes12;
        getcomqw.accCodeEditable = 'Test1';
        getcomqw.getCompID();
        getcomqw.accCodeEditable = 'Test2';
        getcomqw.fcWS = 'Test3';
        getcomqw.compName = 'Test4';
        getcomqw.getCompID(); 
        getcomqw.accCodeEditable = '';
        getcomqw.accountCodeType = 'Test5';
        getcomqw.getPayCodes(null);
        getcomqw.getPayCodesList(null);
        getcomqw.accCodeSelected='Emissions Warranty70';
        list<string> type=  new list<string>{'ApprovalAuthCode','FailCodes','CDSFaultCodes'};
        list<CSS_JobEventTemporary__c> jobs = new list<CSS_JobEventTemporary__c>();
        integer index =0;
        for(integer i=0; i<10;i++){
            if(i>=type.size())index =0;
            CSS_JobEventTemporary__c JETsys = new CSS_JobEventTemporary__c();
            JETsys.Attribute1__c = 'TH';
            JETsys.Attribute4__c ='TS';
            JETsys.key__c = type[index];
            JETsys.Attribute3__c = 'TURBO';
            JETsys.Active__c= true;
            JETsys.Attribute5__c = 'ASSEMBLY';
            JETsys.Reason__c = '{\r\n\t\"Header\": {\r\n\t\t\"ReturnCodeDescription\": \"Normal, Successful completion.\",\r\n\t\t\"ReturnCode\": \"ORA-00000\",\r\n\t\t\"MessageIdentifier\": \"S\"\r\n\t},\r\n\t\"DataArea\": [{\r\n\t\t\"SystemCode\": \"WF\",\r\n\t\t\"FailureName\": \"ATC 1795\",\r\n\t\t\"FailureMode\": \"SP\",\r\n\t\t\"FailureID\": \"F30003750\",\r\n\t\t\"ComponentCode\": \"HA\"\r\n\t}]\r\n}';
            insert JETsys;
            jobs.add(JETsys);
            index++;
        }
        //     insert jobs;

        //getPayCodesonAccCodeChangeOnLoad -where key__c = 'AccountCodes' and Attribute3__c =:accCodeSelected.right(2).trim()
        //getcomqw.accCodeSelected='Emissions Warranty70';
        //getcomqw.getPayCodesonAccCodeChange();
        //getcomqw.checkFaultCode();  key__c='CDSFaultCodes'   where key__c='FailModes'
        //checkFailMode()  onChangeofAppCode()




    }

    public static testMethod void TestMethod1()
    {

        //Creating Service Job--1
        CSS_Job_Order__c jobRef2 = CSS_TestData.createJobOrder(true); 
        //CSS_Job_Order__c jobRef2 = new CSS_Job_Order__c();    
        list<string> falist=new list<string>();
        string st='Test';
        falist.add(st);
        list<string> partfalist=new list<string>();
        string st1='Test';
        partfalist.add(st1);
        //list<string> prtlst=new list<string>();
        //string st2='Test';
        //prtlst.add(st2);
        // Set<string> faultCodeList=new Set<string>();
        //string st2='Test';
        //faultCodeList.add(st2);
        CSS_JobPlanOverviewControllerNew obj=new CSS_JobPlanOverviewControllerNew();
        obj.faultList=falist;
        obj.partlistFAULT=partfalist;
        //obj.partlist=prtlst;
        //obj.faultCodeList=faultCodeList;
        jobRef2.chevron_page__c='jo';
        jobRef2.BMSWSStatus__c = 'UI';
        jobRef2.CSS_Travel_Rate__c = '10';
        jobRef2.CSS_In_Shop_Labor_Rate__c = '10';
        jobRef2.CSS_Resolution__c = 'Test';
        jobRef2.General_Symptoms__c='';
        obj.selectedSysCodeValue = 'selectedSysCodeValue';
        obj.selectedCompCodeValue = 'selectedCompCodeValue';
        jobRef2.CoverageResponse__c = 'xyz';

        upsert jobRef2;

        list<CSS_Solutions__c> sollist=new list<CSS_Solutions__c>();
        //Creating Solutions--2
        CSS_Solutions__c solRef2 =  CSS_TestData.createSolutions(false,jobRef2.Id);
        solRef2.Repair_Response__c='Sucessful';
        //insert solRef2;
        CSS_Solutions__c solRef3 =  CSS_TestData.createSolutions(false,jobRef2.Id);
        solRef3.Repair_Response__c='Sucessful';
        //insert solRef3;
        sollist.add(solRef2);
        sollist.add(solRef3);
        upsert sollist;
        set<Id> solutionIds = new set<Id>();
        solutionIds.add(solRef2.id);
        solutionIds.add(solRef3.id);




        List<CSS_Solution_Component__c> solComList = new List<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solComRef = CSS_TestData.createSRT(false,jobRef2.Id,solRef2.Id);
        solComRef.System_Code__c = 'Test';

        solComRef.Component_Code__c = 'Test';
        solComRef.Failure_Mode__c = 'Test';
        solComRef.Solutions__c =solRef2.id;
        solComRef.AccountCodeType__c = 'Test-Test';
        solComRef.AccountCode_Call_Status__c = 'Failure';
        solComRef.Failure_Point__c=11.0;
        solComRef.Failure_Measure__c = null;
        //       solComRef.Failure_Date__c=date.parse('12-27-2014');
        solComRef.Failure_Date__c=date.today();
        solComRef.AccountCode__c = 'tst';
        solComRef.AccountCodeEdit__c='test';
        solComRef.Failure_Measure__c='test';
        solComRef.Failure_Point__c=1234;
        solComRef.name ='unlisted';
        System.debug('The Solution Component Object');
        solComList.add(solComRef);


        CSS_Solution_Component__c solComRef1 = CSS_TestData.createSRT(false,jobRef2.Id,solRef2.Id);
        solComRef.System_Code__c = 'Test';

        solComRef1.Component_Code__c = 'Test';
        solComRef1.Failure_Mode__c = 'Test';
        solComRef1.Solutions__c =solRef2.id;

        solComRef1.AccountCode_Call_Status__c = 'Failure';
        solComRef1.Failure_Point__c=11.0;
        solComRef1.Failure_Measure__c = null;
        //       solComRef.Failure_Date__c=date.parse('12-27-2014');
        solComRef1.Failure_Date__c=date.today();
        solComRef1.name ='unlisted';
        solComList.add(solComRef1);
        insert solComList;
        CSS_Fault_Code__c fc3 = new CSS_Fault_Code__c(FaultCodeR2__c = '441',Related_Fault_Code__c = '234,546');
        fc3.Name = '441';
        fc3.Job_Order__c = jobRef2.Id;
        fc3.Sequence__c = 1; 
        fc3.Fault_Code_Type__c = 'APD-P';
        fc3.Mod__c = '0';
        fc3.isPole__c = false;
        fc3.Number_of_Solutions__c = '1';
        insert fc3;

        CSS_JobEventTemporary__c JETsys = new CSS_JobEventTemporary__c();
        JETsys.Attribute1__c = 'TH';
        JETsys.Attribute4__c ='TS';
        JETsys.key__c = 'FailCodes';
        JETsys.Attribute3__c = 'TURBO';
        JETsys.Attribute5__c = 'ASSEMBLY';
        JETsys.Reason__c = '{\r\n\t\"Header\": {\r\n\t\t\"ReturnCodeDescription\": \"Normal, Successful completion.\",\r\n\t\t\"ReturnCode\": \"ORA-00000\",\r\n\t\t\"MessageIdentifier\": \"S\"\r\n\t},\r\n\t\"DataArea\": [{\r\n\t\t\"SystemCode\": \"WF\",\r\n\t\t\"FailureName\": \"ATC 1795\",\r\n\t\t\"FailureMode\": \"SP\",\r\n\t\t\"FailureID\": \"F30003750\",\r\n\t\t\"ComponentCode\": \"HA\"\r\n\t}]\r\n}';
        insert JETsys;

        CSS_JobEventTemporary__c JETsys5 = new CSS_JobEventTemporary__c();
        JETsys5.Attribute1__c = 'Test';
        JETsys5.Attribute4__c ='TS';
        JETsys5.key__c = 'FailModes';
        JETsys5.Attribute3__c = 'TURBO';
        JETsys5.Attribute5__c = 'ASSEMBLY';
        JETsys5.Reason__c = '{\r\n\t\"Header\": {\r\n\t\t\"ReturnCodeDescription\": \"Normal, Successful completion.\",\r\n\t\t\"ReturnCode\": \"ORA-00000\",\r\n\t\t\"MessageIdentifier\": \"S\"\r\n\t},\r\n\t\"DataArea\": [{\r\n\t\t\"SystemCode\": \"WF\",\r\n\t\t\"FailureName\": \"ATC 1795\",\r\n\t\t\"FailureMode\": \"SP\",\r\n\t\t\"FailureID\": \"F30003750\",\r\n\t\t\"ComponentCode\": \"HA\"\r\n\t}]\r\n}';
        insert JETsys5;

        CSS_JobEventTemporary__c JETsys1 = new CSS_JobEventTemporary__c();
        JETsys1.Attribute1__c = 'ISX12 CM2350 X102';
        JETsys1.Attribute2__c ='OK';
        JETsys1.key__c = 'GetFailureCodesSRT';
        JETsys1.Attribute3__c = 'ISX12 CM2350 X102;;0K';
        JETsys1.Attribute5__c = 'ASSEMBLY';
        JETsys1.Reason__c = '{\r\n\t\"Header\": {\r\n\t\t\"ReturnCodeDescription\": \"Normal, Successful completion.\",\r\n\t\t\"ReturnCode\": \"ORA-00000\",\r\n\t\t\"MessageIdentifier\": \"S\"\r\n\t},\r\n\t\"DataArea\": [{\r\n\t\t\"SystemCode\": \"WF\",\r\n\t\t\"FailureName\": \"ATC 1795\",\r\n\t\t\"FailureMode\": \"SP\",\r\n\t\t\"FailureID\": \"F30003750\",\r\n\t\t\"ComponentCode\": \"HA\"\r\n\t}]\r\n}';
        insert JETsys1;
        List<CSS_Fault_Code__c> lstFC1 = new List<CSS_Fault_Code__c>();
        lstFC1.add(fc3);
        PageReference pref;
        pref = new PageReference('/'+jobRef2.id);
        pref.getParameters().put('id',jobRef2.id);
        Test.setCurrentPage(pref);
        CSS_JobPlanOverviewControllerNew JobPlanOverCont1 = new CSS_JobPlanOverviewControllerNew();
        CSS_Integration_Details__c cid = CSS_TestData.createIntegrationDetails(false);
        cid.name = 'CSS_SBL_WarrantyDetailCoverage';
        cid.ApplicationName__c = 'CSS_SBL_WarrantyDetailCoverage';
        cid.End_Point__c = 'https://services-stg.cummins.com/csswarranty/accodecoverage';
        insert cid;
        test.startTest();
        
        //JobPlanOverCont1.Wid = jobRef2.Id;

        JobPlanOverCont1.mainSOQL();
        JobPlanOverCont1.jobClosePopup();
        JobPlanOverCont1.workjob.DSID__c = '12345';
        JobPlanOverCont1.workjob.ApplicationCode__c = '130';
        JobPlanOverCont1.NotesBody = 'false';
        JobPlanOverCont1.accQuoteFlag=false;
        JobPlanOverCont1.showRepairs = true;
        JobPlanOverCont1.showResolution = true;
        JobPlanOverCont1.showResolutionWithRepair=false;
        JobPlanOverCont1.onAddClick();
        JobPlanOverCont1.retry();
        JobPlanOverCont1.closeSession();
        JobPlanOverCont1.showRepairs=true;
        JobPlanOverCont1.showResolutionWithRepair=false;
        JobPlanOverCont1.getGsqcustFailurenameslist();
        JobPlanOverCont1.checkCompCode();
        CSS_JobEventTemporary__c JETsysAccCodes = new CSS_JobEventTemporary__c();
            JETsysAccCodes.Attribute1__c = 'POL';
            JETsysAccCodes.Attribute2__c = 'MISCELLANEOUS - KA91 ADD';
            JETsysAccCodes.Attribute4__c ='POL-MISCELLANEOUS - KA91 ADD-02';
            JETsysAccCodes.key__c = 'AccountCodes';
            JETsysAccCodes.Attribute3__c = '02';
            JETsysAccCodes.Active__c= true;
            JETsysAccCodes.Attribute5__c = 'N';
            JETsysAccCodes.Reason__c = '{\r\n\t\"Header\": {\r\n\t\t\"ReturnCodeDescription\": \"Normal, Successful completion.\",\r\n\t\t\"ReturnCode\": \"ORA-00000\",\r\n\t\t\"MessageIdentifier\": \"S\"\r\n\t},\r\n\t\"DataArea\": [{\r\n\t\t\"SystemCode\": \"WF\",\r\n\t\t\"FailureName\": \"ATC 1795\",\r\n\t\t\"FailureMode\": \"SP\",\r\n\t\t\"FailureID\": \"F30003750\",\r\n\t\t\"ComponentCode\": \"HA\"\r\n\t}]\r\n}';
            insert JETsysAccCodes;
            
        JobPlanOverCont1.checkFailMode();
        CSS_Job_Order__c JO = new CSS_Job_Order__c();
        JO.Customer_Name__c = 'Test';
        JO.Model__c = 'Test';
        JO.Make__c = 'CSSTest';
        JO.Failure_Point__c = 122;
        JO.Failure_Point_Measure__c ='Miles';
        JO.VIN__c='12345677890';
        JO.Failure_Date__c =date.today()-20;
        JO.Warranty_Start_Date__c =date.today()-365;
        JO.Location_Certification__c='abc';
        JO.jobLocation__c='abc';
        JO.Status__c = 'Repair Complete';
        JO.BMSStatus__c ='testt';
        insert JO;


        CSS_Fault_Code__c fc1 = new CSS_Fault_Code__c(FaultCodeR2__c = '441',Related_Fault_Code__c = '234,546');
        fc1.Name = '441';
        fc1.Job_Order__c = JO.Id;
        fc1.Sequence__c = 1;
        fc1.Fault_Code_Type__c = 'APD-P';
        fc1.Mod__c = '0';
        fc1.isPole__c = false;
        insert fc1;

        CSS_SymptomQA__c sympty = new CSS_SymptomQA__c();
        sympty.job_order__c = jobRef2.Id;
        sympty.type__c='SearchString';
        sympty.user_name__c =userinfo.getUserId();
        insert sympty;

        List<CSS_Solutions__c> postRepairList1 = new List<CSS_Solutions__c>();
        CSS_Solutions__c solAdd = new CSS_Solutions__c();
        solAdd.Service_Job__c = jobRef2.id;
        solAdd.Case_Name__c = 'Additional SRTS';
        solAdd.Solution_Title__c='Additional SRTS';
        solAdd.Name='TestSRTS'+Math.random();
        solAdd.Diagnostic_Response__c ='Most likely the solution';
        solAdd.Diagnostic_notes__c = 'solutions diagnostic notes';
        solAdd.Repair_Notes__c = 'Repair Notes';
        solAdd.FaultCode__c = fc3.Id;
        solAdd.Symptom__c=sympty.Id;
        solAdd.Repair_Response__c = 'Most likely ';
        solAdd.Repair_Response__c = 'Repair Successful.';
        solAdd.Rank__c = 3;
        solAdd.Fault_Codes__c = fc1.id; 
        insert solAdd;
        postRepairList1.add(solAdd);

        JobPlanOverCont1.saveAndCloseJob();
        JobPlanOverCont1.componentId = '12345';
        JobPlanOverCont1.AuthNumber = '12345';
        JobPlanOverCont1.PayCode = '23345';
        JobPlanOverCont1.complaintcounter = 12234;
        JobPlanOverCont1.coveragecounter = 12245;
        JobPlanOverCont1.causecounter = 35456;
        JobPlanOverCont1.compName = 'test12';
        JobPlanOverCont1.compID1 = '23454';
        JobPlanOverCont1.fcWS = 'test12';
        JobPlanOverCont1.acWS = 'test76';
        JobPlanOverCont1.fcPopup = 'test54';
        JobPlanOverCont1.acPopup = 'test34';
        JobPlanOverCont1.recordId = '12432544223';
        JobPlanOverCont1.displayMPopUp = true;
        JobPlanOverCont1.selAccCode = 'test12';
        JobPlanOverCont1.warrantyCompFailure = true;
        JobPlanOverCont1.failmode = 'test2';
        JobPlanOverCont1.claimtype = 'test23';
        JobPlanOverCont1.accountCodeType = 'test5';
        JobPlanOverCont1.selectedAccFormula = true;
        JobPlanOverCont1.FailureDtHidden = 'test24';
        JobPlanOverCont1.displayERPButtonDlr = true;
        JobPlanOverCont1.workjobStatus = 'open';
        JobPlanOverCont1.failCodeChange = true;
        JobPlanOverCont1.faultCode = 'tsestwf';
        JobPlanOverCont1.payCodeSelected = 'Select One';
        JobPlanOverCont1.selectedFName =  'siva';
        JobPlanOverCont1.selectedSysCode ='TH';
        JobPlanOverCont1.selectedCompCode='TS';
        JobPlanOverCont1.selectedFailMode = 'test1';
        JobPlanOverCont1.errormsgfailpoint = false;
        JobPlanOverCont1.selectedFaultCode = '467432356';
        JobPlanOverCont1.appCodeSelected = 'test12';
        JobPlanOverCont1.claimTypeSelected = 'open';
        JobPlanOverCont1.accCodeReturned = 'testing';
        JobPlanOverCont1.selectedCompId = '12345567';
        JobPlanOverCont1.sendfailtoERP = false;
        JobPlanOverCont1.authNumbers = '34567';
        JobPlanOverCont1.checkPartsWarrStartDt = true;

        //JobPlanOverCont1.callUnitInboundGeneric();
        JobPlanOverCont1.callUpdateUnitandWo();
        Map<String,String> tempMap  = new map<String,String>();
        tempMap.put('siva','TH');
        JobPlanOverCont1.failureNameWithSystemCodeMap  = tempMap;
        JobPlanOverCont1.failureNameWithCompCodeMap  = tempMap;
        JobPlanOverCont1.changeFailures_New();
        JobPlanOverCont1.selectedFName =  'unlisted';
        JobPlanOverCont1.changeFailures_New();
        JobPlanOverCont1.jobplan_jo();
        JobPlanOverCont1.getListWrap();
        //JobPlanOverCont1.jobplan_prt();
        JobPlanOverCont1.jobplan_war();
        JobPlanOverCont1.jobplan_narr();
        JobPlanOverCont1.pgSave();
        JobPlanOverCont1.showPopup();
        JobPlanOverCont1.closePopup();
        JobPlanOverCont1.redirectPopup();
        JobPlanOverCont1.getAccountCodes1();
        JobPlanOverCont1.closeSession_close();
        JobPlanOverCont1.jobPlanAction();
        JobPlanOverCont1.pgSaveFinish();
        JobPlanOverCont1.clearpopup();

        Test.setMock(HttpCalloutMock.class , new CSS_WS_SBL_GetWarrantyDetailCovrg_Test());
        JobPlanOverCont1.checkCoverageNew();
        JobPlanOverCont1.onChangeofAppCode();
        //JobPlanOverCont1.SRTFailurenames();
        JobPlanOverCont1.getfailurenames();
        Test.setMock(HttpCalloutMock.class , new CSS_WS_SBL_GetWarrantyDetailCovrg_Test());
        JobPlanOverCont1.checkcoverage();
        Test.stopTest();        
    }
    public static testMethod void TestMethod2()
    {

        UserRole empRole = [Select Id From UserRole Where Name = 'Factory' Limit 1];
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'kal1', Email='standarduser11@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='kal12', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='kal11111@testorg.com', user_Location__c = '56270-56255',UserRoleId = empRole.id);
        insert(u);
        System.runAs(u) 
        {  


            //Creating Job--1
            CSS_Job_Order__c jobRef = CSS_TestData.createJobOrder(false);
            jobRef.chevron_page__c='jo';
            jobRef.BMSWSStatus__c = 'UI';
            jobRef.ESN__c ='123';
            jobRef.Service_Model__c ='ISX12 CM2350 X102';
            jobRef.Qsol_Engine_Family_Code__c ='0K';
            jobref.CoverageResponse__c = 'Testing';
            jobRef.Failure_Date__c = System.today();
            insert jobRef;
            PageReference pref;
            pref = new PageReference('/'+jobRef.id);
            pref.getParameters().put('id',jobRef.id);
            Test.setCurrentPage(pref);

            CSS_JobEventTemporary__c JETsys = new CSS_JobEventTemporary__c();
            JETsys.Attribute1__c = 'TH';
            JETsys.Attribute4__c ='TS';
            JETsys.key__c = 'FailCodes';
            JETsys.Attribute3__c = 'TURBO';
            JETsys.Attribute5__c = 'ASSEMBLY';
            insert JETsys;

            CSS_JobEventTemporary__c JETsys1 = new CSS_JobEventTemporary__c();
            JETsys1.Attribute1__c = 'ISX12 CM2350 X102';
            JETsys1.Attribute2__c ='OK';
            JETsys1.key__c = 'GetFailureCodesSRT';
            JETsys1.Attribute3__c = 'ISX12 CM2350 X102;;0K';
            JETsys1.Attribute5__c = 'ASSEMBLY';
            JETsys1.Reason__c = '{\r\n\t\"Header\": {\r\n\t\t\"ReturnCodeDescription\": \"Normal, Successful completion.\",\r\n\t\t\"ReturnCode\": \"ORA-00000\",\r\n\t\t\"MessageIdentifier\": \"S\"\r\n\t},\r\n\t\"DataArea\": [{\r\n\t\t\"SystemCode\": \"WF\",\r\n\t\t\"FailureName\": \"ATC 1795\",\r\n\t\t\"FailureMode\": \"SP\",\r\n\t\t\"FailureID\": \"F30003750\",\r\n\t\t\"ComponentCode\": \"HA\"\r\n\t}]\r\n}';
            insert JETsys1;

            CSS_JobEventTemporary__c JETsys2 = new CSS_JobEventTemporary__c();
            JETsys2.Attribute1__c = 'POL';
            JETsys2.Attribute2__c ='CDA POLICY';
            JETsys2.key__c = 'AccountCodes';
            JETsys2.Attribute3__c = '58';
            JETsys2.Attribute5__c = 'ASSEMBLY';
            insert JETsys2;

            //Creating Fault code
            CSS_Fault_Code__c fauCodRef = new CSS_Fault_Code__c();
            fauCodRef.Job_Order__c =jobRef.Id; 
            fauCodRef.Sequence__c=1;
            fauCodRef.Fault_Code_Type__c='BPD'; 
            fauCodRef.Primary_Fault_Code__c=3539; 
            fauCodRef.Status__c='A';
            insert fauCodRef;
            List<CSS_Fault_Code__c> fauCodRefList = new List<CSS_Fault_Code__c>();
            fauCodRefList.add(fauCodRef);

            //Creating Soltions--3
            CSS_Solutions__c solRef =  CSS_TestData.createSolutions(true,jobRef.Id);
            solRef.FaultCode__c = fauCodRef.id;
            update solRef;


            //Creating Solution Component--4
            for(integer i=0;i<5;i++)
            {
                CSS_Solution_Component__c solComRef = CSS_TestData.createSRT(false,jobRef.Id,solRef.Id);
                solComRef.System_Code__c = 'Test';
                solComRef.Component_Code__c = 'Test';
                solComRef.Failure_Mode__c = 'Test';
                solComRef.Fault_Code__c = '12345';
                solComRef.Solutions__c =solRef.id;
                solComRef.AccountCodeType__c = 'Test-Test';
                solComRef.AccountCode_Call_Status__c = 'Failure';
                solComRef.Failure_Point__c=11.0;
                solComRef.Failure_Date__c=date.parse('12/27/2014');
                solComRef.AccountCode__c = 'test';
                solComRef.AccountCodeEdit__c = 'CHINA JV POLICY JV';
                solComRef.Failure_Point__c=1234;
                solComRef.Failure_Measure__c='Test';
                solComRef.Failure_Date__c = null;
                solComRef.name ='unlisted';
                System.debug('The Solution Component Object' +solComRef);

                insert solComRef;
            }



            list<CSS_Solution_Component__c> solcomreflist = [select id,System_Code__c,Component_Code__c,Failure_Mode__c,Solutions__c,AccountCodeType__c,AccountCode_Call_Status__c,Failure_Point__c,Failure_Date__c,AccountCodeEdit__c from CSS_Solution_Component__c];
            //System.debug('The Solution Component Object is:'+solComRef);
            boolean accCodeExist=false;

            CSS_Parts_Options__c parts = new CSS_Parts_Options__c();
            parts.Option_Number__c = 'O-111';
            parts.Service_Job__c = jobRef.Id;
            parts.selected_part__c = true;
            parts.FailurepartId__c = solcomreflist[0].Id;
            parts.Part_Assignment__c = 'Primary';
            //parts.Solutions__c=sol.Id;

            insert parts;
            //Populating Account codes
            List<SelectOption> accCodes = new List<SelectOption>();
            accCodes.add(new SelectOption('Test1','Test1'));
            accCodes.add(new SelectOption('Test2','Test2'));
            accCodes.add(new SelectOption('Test3','Test3'));
            accCodes.add(new SelectOption('Test4','Test4'));

            Account acc = new Account();
            acc.name='R1test';
            acc.CSS_DistributorCode__c='03520';
            acc.CSS_DealerCode__c='';
            acc.CSS_FleetCode__c = '';
            acc.CSS_DBCode__c = '04892';
            acc.ERP_System__c = 'One BMS';
            acc.Type = 'Customer';
            acc.Region__c = 'NORTH AMERICA';//'US and Canada';
            acc.CMI_Account_Status__c = 'Active';
            acc.IAM_Service_Provider_Code__c='56270';
            insert acc;

            CSS_Job_Order__c JO = new CSS_Job_Order__c();
            JO.Customer_Name__c = '';
            JO.Shop_Work_Order__c = '';
            JO.status__c = '';
            JO.Application__c = 'Recreational Vehicle';
            JO.Model__c = 'RajTest';

            JO.Account__c = acc.id;
            insert JO;


            test.startTest();
            CSS_JobPlanOverviewControllerNew obj1=new CSS_JobPlanOverviewControllerNew();
            obj1.accCodeEditable='Test';
            obj1.componentId = String.valueOf(solcomreflist[0].id);
            obj1.failureDate = System.today();
            obj1.failureDate1 = System.today();
            obj1.failureMeasure='hours';
            obj1.warrantyDate = System.today();
            obj1.partsWarrDt = system.today();
            obj1.warrStDtHidden = 'Testing';
            obj1.accCodeSelected = 'EMISSION WARRANTY 70';
            obj1.selectedFaultCode = null;
            obj1.selectedFaultCode = 'Test';
            //obj1.selectedCompCode='test1';
            //obj1.selectedSysCode='Test';
            obj1.Wid = null;
            obj1.comm = 'Testing';
            obj1.Cancel();

            //select Attribute1__c, Attribute3__c from CSS_JobEventTemporary__c where key__c='FailModes'
            list<CSS_JobEventTemporary__c> jetl =new list<CSS_JobEventTemporary__c>();

            CSS_JobEventTemporary__c jet=new CSS_JobEventTemporary__c();
            jet.key__c='FailModes';
            jet.Attribute1__c='Test';
            //jet11.Attribute1__c='Test';
            //jet.Attribute4__c='test1';
            jet.Name='Test';
            insert jet;
            CSS_JobEventTemporary__c jet2=new CSS_JobEventTemporary__c();
            jet2.key__c='CDSFaultCodes';
            jet2.Attribute1__c='12345';
            //jet2.Attribute4__c='test1';
            jet2.Name='Test';
            insert jet2;

            jetl.add(jet);
            //jet1.add(jet11);
            upsert jetl;

            //   obj1.loadPopup();

            obj1.jobplan_jpq();
            obj1.jobplan_srt();
            obj1.onAddClick();
            obj1.checkCoverageNew();
            obj1.failureMeasure='Hours';
            obj1.coverageType = 'POL';
            obj1.Validations();
            obj1.coverageType = 'NPW';
            obj1.coverageFound = 'false';
            obj1.accCodeSelected = '52';
            obj1.selectedFailMode = 'THAS';
            obj1.chkClickonPartsCoverage = false;
		    set<string> setBlankFieldset = new set<string>();
            setBlankFieldset.add('false');
		    //obj1.tempblankfieldset = setBlankFieldset;
            obj1.Validations();
            obj1.pgSave();
            obj1.saveCheckBox();
            obj1.getAccountCodes();
            obj1.mainSOQL();
        }
        Test.setMock(HttpCalloutMock.class, new CSS_SRTCompMockup_Test());
        CSS_JobPlanOverviewControllerNew JobPlanOverCont = new CSS_JobPlanOverviewControllerNew();
        //CSS_Solution_Component__c solComm=[select id from css_solution_component__c limit 1];
        // system.debug('solution Component value'+solComm);
        //JobPlanOverCont.componentId = 'solComRef.Id';
        JobPlanOverCont.failCodeSelected = 'Engine Control Module Calibration-EQPE';
        JobPlanOverCont.accCodeSelected = 'PARTS WARRANTY 35';
        JobPlanOverCont.failCodeEditable='Engine Control Module Calibration-EQPE';
        //JobPlanOverCont.allFaultCodes = fauCodRefList;

        //JobPlanOverCont.mainSOQL();
        JobPlanOverCont.failCodeChangeGO();
        //JobPlanOverCont.retry();
        Test.setMock(HttpCalloutMock.class, new CSS_MockHttpResponseGenerator()); 
        JobPlanOverCont.callCreateWoqtInbound('Test+Rupesh');
        //JobPlanOverCont.onAddClick();//Moved Here and it gives no error

        Test.setMock(HttpCalloutMock.class , new CSS_WS_SBL_GetWarrantyDetailCovrg_Test());
        JobPlanOverCont.partssave();
        JobPlanOverCont.clearPopup();
        JobPlanOverCont.onChangeofAppCode();
        Test.stopTest();
    }
    public static testMethod void TestMethod3()
    {

        UserRole empRole = [Select Id From UserRole Where Name = 'CEO' Limit 1];
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'kal1', Email='standarduser11@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='kal12', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='kal11111@testorg.com', user_Location__c = '562701-562551',UserRoleId = empRole.id);
        insert(u);
        System.runAs(u) 
        {  
            CSS_SMN_FaultCode__c smn = new CSS_SMN_FaultCode__c();
            smn.Name = 'test';
            smn.Description__c = 'test';
            smn.Fault_Code__c = 'test';
            smn.SMN__c = 'ISB6.7 CM2350 B101';
            insert smn;

            CSS_JobEventTemporary__c JETsys = new CSS_JobEventTemporary__c();
            JETsys.Attribute1__c = 'OTH';
            JETsys.Attribute4__c ='TS';
            JETsys.key__c = 'AccountCodes';
            JETsys.Attribute3__c = 'TURBO';
            JETsys.Attribute5__c = 'ASSEMBLY';
            insert JETsys;
            CSS_JobEventTemporary__c JETsys1 = new CSS_JobEventTemporary__c();
            JETsys1.Attribute1__c = '';
            JETsys1.Attribute2__c ='OK';
            //   JETsys1.key__c = 'AccountCodes';
            JETsys1.key__c = 'FailModes';
            JETsys1.Active__c = true;
            JETsys1.Attribute3__c = 'ISX12 CM2350 X102;;0K';
            JETsys1.Attribute5__c = 'ASSEMBLY';
            JETsys1.Reason__c = '{\r\n\t\"Header\": {\r\n\t\t\"ReturnCodeDescription\": \"Normal, Successful completion.\",\r\n\t\t\"ReturnCode\": \"ORA-00000\",\r\n\t\t\"MessageIdentifier\": \"S\"\r\n\t},\r\n\t\"DataArea\": [{\r\n\t\t\"SystemCode\": \"WF\",\r\n\t\t\"FailureName\": \"ATC 1795\",\r\n\t\t\"FailureMode\": \"SP\",\r\n\t\t\"FailureID\": \"F30003750\",\r\n\t\t\"ComponentCode\": \"HA\"\r\n\t}]\r\n}';
            insert JETsys1;
            CSS_Job_Order__c jobRef = new CSS_Job_Order__c() ;
            jobRef.chevron_page__c='jo';
            jobRef.BMSWSStatus__c = 'UI';
            //jobRef.Name='test';
            jobRef.ESN__c ='Testing';
            jobRef.Service_Model__c ='ISB6.7 CM2350 B101';
            jobRef.Qsol_Engine_Family_Code__c ='10';
            jobRef.Repair_Location__c='Mobile';
            insert jobRef;
            PageReference pref;
            pref = new PageReference('/'+jobRef.id);
            pref.getParameters().put('id',jobRef.id);
            Test.setCurrentPage(pref);
            CSS_Fault_Code__c fauCodRef = new CSS_Fault_Code__c();
            fauCodRef.Job_Order__c =jobRef.Id; 
            fauCodRef.Sequence__c=1;
            fauCodRef.Fault_Code_Type__c='BPD'; 
            fauCodRef.Primary_Fault_Code__c=3539; 
            fauCodRef.Status__c='A';
            insert fauCodRef;
            List<CSS_Fault_Code__c> fauCodRefList = new List<CSS_Fault_Code__c>();
            fauCodRefList.add(fauCodRef);

            CSS_SymptomQA__c sqa = new CSS_SymptomQA__c();
            sqa.Name = 'black smoke';
            insert sqa;

            list<CSS_Solutions__c > solReflist=new list<CSS_Solutions__c>();

            CSS_Solutions__c solRef =  CSS_TestData.createSolutions(false,jobRef.Id);
            solRef.FaultCode__c = fauCodRef.id;
            solRef.Repair_Response__c='NO';
            solRef.Symptom__c = sqa.id;
            upsert solRef;

            solReflist.add(solRef);
            upsert solReflist;

            list<CSS_Solution_Component__c> solComReflist=new list<CSS_Solution_Component__c>();
            CSS_Solution_Component__c solComRef = CSS_TestData.createSRT(false,jobRef.Id,solRef.Id);
            solComRef.System_Code__c = 'Test';
            solComRef.Component_Code__c = 'Test';
            solComRef.Failure_Mode__c = 'Test';
            solComRef.Solutions__c =solRef.id;
            //solComRef.Performed_Review__c=true;
            solComRef.Type__c=null;
            solComRef.selected_Component__c = true;
            solComRef.Service_Job__c=jobRef.id;
            solComRef.AccountCodeType__c = 'Test-Test';
            solComRef.AccountCode_Call_Status__c = 'Failure';
            solComRef.AccountCode__c = 'ACCODE';
            solComRef.AccountCodeEdit__c='ADEDIT';
            solComRef.Failure_Measure__c='ADEDIT';
            solComRef.name='unlisted';
            insert solComRef;
            solComReflist.add(solComRef);

            Set<String> failureNameList = new Set<String>();
            String grpName = 'CQ'+'-'+'56270-56255';
            Group testQue = new Group(Name=grpName, type='Queue');
            insert testQue;
            CSS_Integration_Details__c csInt = new CSS_Integration_Details__c();
            csInt.name = 'SRT';
            csInt.ApplicationName__c='SRT';
            csInt.End_Point__c='https://Test-services-dev.cummins.com/css/';
            csInt.IsActive__c=true;
            csInt.Key__c='/Q0w11SmTDJ11dPRgzYfGjycs+HZbtT8sezi/jkT7Ag=';
            csInt.Passcode__c='u9pf3rdOE0SCjXDCgmzRbUlwWQWen7B9993Eh61KI1E=';
            csInt.Username__c='6dpW6v5ekUR2HzkTePJXwgNaMDgo0t53tZgmixV4rfU=';
            insert csint;
            system.runas(new User(Id=UserInfo.getUserId()))
            { 

                QueueSObject tq = new QueueSObject(SobjectType='CSS_Claims__c', QueueId=testQue.Id);
                insert tq;


                CSS_Claims__c claims = new CSS_Claims__c();
                claims.Status__c='Submitted';
                claims.ESN__c='79462880';
                claims.Customer_Name__c='BRITESTONE COLONY';
                claims.Customer_Code__c='123';
                claims.Location_Code__c='56270-56255';
                claims.ownerId = UserInfo.getUserId();
                insert claims;
                Test.startTest();

                CSS_JobPlanOverviewControllerNew JobPlanOverCont = new CSS_JobPlanOverviewControllerNew();
                JobPlanOverCont.componentId = solComRef.Id;
                JobPlanOverCont.failCodeSelected = 'Select One';
                JobPlanOverCont.accCodeSelected = 'PARTS WARRANTY 35';
                JobPlanOverCont.failCodeEditable='Select One';
                JobPlanOverCont.allFaultCodes = fauCodRefList;
                JobPlanOverCont.failureMeasure='Kilometers';
                Test.setMock(HttpCalloutMock.class, new SRTMockHttpResponseGenerator());
                //JobPlanOverCont.SRTFailurenames();
                Test.setMock(HttpCalloutMock.class, new CSS_SRTCompMockup_Test());
                JobPlanOverCont.mainSOQL();
                JobPlanOverCont.failCodeChangeGO();
                //Test.setMock(HttpCalloutMock.class, new CSS_MockHttpResponseGenerator()); 
                JobPlanOverCont.callCreateWoqtInbound('Testing Class');
                JobPlanOverCont.jobplan_jpq();
                //      JobPlanOverCont.jobplan_srt();
                JobPlanOverCont.partsWarranty=null;
                JobPlanOverCont.accCodeSelected='62';
                JobPlanOverCont.partssave();
                JobPlanOverCont.showResolutionWithRepair=true;
                //JobPlanOverCont.saveAndCloseJob();
                JobPlanOverCont.onChangeofAppCode();
                JobPlanOverCont.SelectedFname = null; 
                JobPlanOverCont.Wid = apexpages.currentPage().getparameters().put('id',claims.Id); 
                boolean headerValidation = CG_BL_ODM.callODMHeaderValidationService(null,null,null,null,null,null); 
                JobPlanOverCont.SendFailurestoERP();
                
                

                CSS_JobEventTemporary__c jet=new CSS_JobEventTemporary__c();
                jet.Attribute1__c='OTH';jet.Attribute1__c='POL';jet.Attribute1__c='NPW';jet.Attribute1__c='RPW';jet.Attribute1__c='REW';jet.Attribute1__c='RRW ';

                jet.key__c='AccountCodes';

                //JobPlanOverCont.callUnitInboundGeneric();
                JobPlanOverCont.callUpdateUnitandWo();
                JobPlanOverCont.jobplan_jo();
                JobPlanOverCont.jobplan_war();
                JobPlanOverCont.jobplan_narr();
                JobPlanOverCont.showPopup();
                JobPlanOverCont.closePopup();
                JobPlanOverCont.redirectPopup();
                JobPlanOverCont.getAccountCodes1();
                JobPlanOverCont.closeSession_close();
                JobPlanOverCont.pgSaveFinish();
                JobPlanOverCont.CompareDates();
                JobPlanOverCont.getfailurenames();

                CSS_Solution_Component__c compe = new CSS_Solution_Component__c(System_Code__c='HCL',accountcodeedit__c=JobPlanOverCont.accCodeReturned,Component_Code__c='TCS',Service_Job__c=JobPlanOverCont.wid);
                insert compe;
                JobPlanOverCont.compont=compe;
                JobPlanOverCont.compont.Failure_Date__c=null;
                JobPlanOverCont.failureDate1=system.today();
                JobPlanOverCont.CompareDates();
                JobPlanOverCont.failureDate=system.today().adddays(2);
                JobPlanOverCont.CompareDates();
                JobPlanOverCont.compont.Failure_Date__c=system.today();
                JobPlanOverCont.CompareDates();
                JobPlanOverCont.selectedSysCode='HCL-ASP';
                JobPlanOverCont.selectedCompCode='TCS-ASP';
                JobPlanOverCont.accCodeReturned='NEW PARTS';
                JobPlanOverCont.failureMeasure='Hours';
                JobPlanOverCont.coverageType = 'POL';
                JobPlanOverCont.Validations();
                for(integer i=0; i<10;i++){
                    CSS_Solution_Component__c comp = new CSS_Solution_Component__c(System_Code__c='HCL',accountcodeedit__c=JobPlanOverCont.accCodeReturned,Component_Code__c='TCS',Service_Job__c=JobPlanOverCont.wid);
                    insert comp;
                }
                JobPlanOverCont.coverageType = 'POL';
                JobPlanOverCont.Validations();
                JobPlanOverCont.coverageType = 'NPW';
                JobPlanOverCont.coverageFound = 'false';
                JobPlanOverCont.accCodeSelected = '52';
                JobPlanOverCont.selectedFailMode = 'THAS';
                JobPlanOverCont.chkClickonPartsCoverage = false;
		        set<string> setBlankFieldset = new set<string>();
                setBlankFieldset.add('false');
    		    //JobPlanOverCont.tempblankfieldset = setBlankFieldset;
                JobPlanOverCont.Validations();
                JobPlanOverCont.getPayCodesonAccCodeChangeOnLoad();
                JobPlanOverCont.workJob.Customer_Name__c = null;
                JobPlanOverCont.workJob.Application_Desc__c = null;
                JobPlanOverCont.workJob.Shop_Work_Order__c = null;
                JobPlanOverCont.workJob.Unit_number__c = null;
                JobPlanOverCont.workJob.Mileage__c = null;
                JobPlanOverCont.workJob.ESN__c = null;

                JobPlanOverCont.ChkFieldBlank();
                JobPlanOverCont.jobplan_jo();
                JobPlanOverCont.pgSave();
                JobPlanOverCont.Cancel();
                JobPlanOverCont.loadPopup();

                Test.stopTest();
            }
        }
    }

     public static testMethod void TestMethod3_11()
    {

        UserRole empRole = [Select Id From UserRole Where Name = 'CEO' Limit 1];
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'kal1', Email='standarduser11@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='kal12', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='kal11111@testorg.com', user_Location__c = '562701-562551',UserRoleId = empRole.id);
        insert(u);
        System.runAs(u) 
        {  
            CSS_SMN_FaultCode__c smn = new CSS_SMN_FaultCode__c();
            smn.Name = 'test';
            smn.Description__c = 'test';
            smn.Fault_Code__c = 'test';
            smn.SMN__c = 'ISB6.7 CM2350 B101';
            insert smn;

            CSS_JobEventTemporary__c JETsys = new CSS_JobEventTemporary__c();
            JETsys.Attribute1__c = 'OTH';
            JETsys.Attribute4__c ='TS';
            JETsys.key__c = 'AccountCodes';
            JETsys.Attribute3__c = 'TURBO';
            JETsys.Attribute5__c = 'ASSEMBLY';
            insert JETsys;
            CSS_JobEventTemporary__c JETsys1 = new CSS_JobEventTemporary__c();
            JETsys1.Attribute1__c = '';
            JETsys1.Attribute2__c ='OK';
            //   JETsys1.key__c = 'AccountCodes';
            JETsys1.key__c = 'FailModes';
            JETsys1.Active__c = true;
            JETsys1.Attribute3__c = 'ISX12 CM2350 X102;;0K';
            JETsys1.Attribute5__c = 'ASSEMBLY';
            JETsys1.Reason__c = '{\r\n\t\"Header\": {\r\n\t\t\"ReturnCodeDescription\": \"Normal, Successful completion.\",\r\n\t\t\"ReturnCode\": \"ORA-00000\",\r\n\t\t\"MessageIdentifier\": \"S\"\r\n\t},\r\n\t\"DataArea\": [{\r\n\t\t\"SystemCode\": \"WF\",\r\n\t\t\"FailureName\": \"ATC 1795\",\r\n\t\t\"FailureMode\": \"SP\",\r\n\t\t\"FailureID\": \"F30003750\",\r\n\t\t\"ComponentCode\": \"HA\"\r\n\t}]\r\n}';
            insert JETsys1;
            CSS_Job_Order__c jobRef = new CSS_Job_Order__c() ;
            jobRef.chevron_page__c='jo';
            jobRef.BMSWSStatus__c = 'UI';
            //jobRef.Name='test';
            jobRef.ESN__c ='Testing';
            jobRef.Service_Model__c ='ISB6.7 CM2350 B101';
            jobRef.Qsol_Engine_Family_Code__c ='10';
            jobRef.Repair_Location__c='Mobile';
            insert jobRef;
            PageReference pref;
            pref = new PageReference('/'+jobRef.id);
            pref.getParameters().put('id',jobRef.id);
            Test.setCurrentPage(pref);
            CSS_Fault_Code__c fauCodRef = new CSS_Fault_Code__c();
            fauCodRef.Job_Order__c =jobRef.Id; 
            fauCodRef.Sequence__c=1;
            fauCodRef.Fault_Code_Type__c='BPD'; 
            fauCodRef.Primary_Fault_Code__c=3539; 
            fauCodRef.Status__c='A';
            insert fauCodRef;
            List<CSS_Fault_Code__c> fauCodRefList = new List<CSS_Fault_Code__c>();
            fauCodRefList.add(fauCodRef);

            CSS_SymptomQA__c sqa = new CSS_SymptomQA__c();
            sqa.Name = 'black smoke';
            insert sqa;
             CSS_JobPlanOverviewControllerNew obj1=new CSS_JobPlanOverviewControllerNew();
            obj1.accountCodeType='';

            list<CSS_Solutions__c > solReflist=new list<CSS_Solutions__c>();

            CSS_Solutions__c solRef =  CSS_TestData.createSolutions(false,jobRef.Id);
            solRef.FaultCode__c = fauCodRef.id;
            solRef.Repair_Response__c='NO';
            solRef.Symptom__c = sqa.id;
            upsert solRef;

            solReflist.add(solRef);
            upsert solReflist;

            list<CSS_Solution_Component__c> solComReflist=new list<CSS_Solution_Component__c>();
            CSS_Solution_Component__c solComRef = CSS_TestData.createSRT(false,jobRef.Id,solRef.Id);
            solComRef.System_Code__c = 'Test';
            solComRef.Component_Code__c = 'Test';
            solComRef.Failure_Mode__c = 'Test';
            solComRef.Solutions__c =solRef.id;
            //solComRef.Performed_Review__c=true;
            solComRef.Type__c=null;
            solComRef.selected_Component__c = true;
            solComRef.Service_Job__c=jobRef.id;
            solComRef.AccountCodeType__c = 'Test-Test';
            solComRef.AccountCode_Call_Status__c = 'Failure';
            solComRef.AccountCode__c = 'ACCODE';
            solComRef.AccountCodeEdit__c='ADEDIT';
            solComRef.Failure_Measure__c='ADEDIT';
            solComRef.name='unlisted';
           
            //solComRef.Parts_Warranty__c='POL'; //Class is failing, hence commented.
            insert solComRef;
            solComReflist.add(solComRef);

            Set<String> failureNameList = new Set<String>();
            String grpName = 'CQ'+'-'+'56270-56255';
            Group testQue = new Group(Name=grpName, type='Queue');
            insert testQue;
            CSS_Integration_Details__c csInt = new CSS_Integration_Details__c();
            csInt.name = 'SRT';
            csInt.ApplicationName__c='SRT';
            csInt.End_Point__c='https://Test-services-dev.cummins.com/css/';
            csInt.IsActive__c=true;
            csInt.Key__c='/Q0w11SmTDJ11dPRgzYfGjycs+HZbtT8sezi/jkT7Ag=';
            csInt.Passcode__c='u9pf3rdOE0SCjXDCgmzRbUlwWQWen7B9993Eh61KI1E=';
            csInt.Username__c='6dpW6v5ekUR2HzkTePJXwgNaMDgo0t53tZgmixV4rfU=';
            insert csint;
            system.runas(new User(Id=UserInfo.getUserId()))
            { 

                QueueSObject tq = new QueueSObject(SobjectType='CSS_Claims__c', QueueId=testQue.Id);
                insert tq;


                CSS_Claims__c claims = new CSS_Claims__c();
                claims.Status__c='Submitted';
                claims.ESN__c='79462880';
                claims.Customer_Name__c='BRITESTONE COLONY';
                claims.Customer_Code__c='123';
                claims.Location_Code__c='56270-56255';
                claims.ownerId = UserInfo.getUserId();
                insert claims;
                Test.startTest();

                CSS_JobPlanOverviewControllerNew JobPlanOverCont = new CSS_JobPlanOverviewControllerNew();
                JobPlanOverCont.componentId = solComRef.Id;
                JobPlanOverCont.failCodeSelected = 'Select One';
                JobPlanOverCont.accCodeSelected = null;
                JobPlanOverCont.failCodeEditable='Select One';
                JobPlanOverCont.allFaultCodes = fauCodRefList;
                JobPlanOverCont.failureMeasure='Kilometers';
                Test.setMock(HttpCalloutMock.class, new SRTMockHttpResponseGenerator());
                //JobPlanOverCont.SRTFailurenames();
                Test.setMock(HttpCalloutMock.class, new CSS_SRTCompMockup_Test());
                JobPlanOverCont.mainSOQL();
                JobPlanOverCont.failCodeChangeGO();
                //Test.setMock(HttpCalloutMock.class, new CSS_MockHttpResponseGenerator()); 
                JobPlanOverCont.callCreateWoqtInbound('Testing Class');
                JobPlanOverCont.jobplan_jpq();
                //      JobPlanOverCont.jobplan_srt();
                JobPlanOverCont.partsWarranty=null;
                JobPlanOverCont.accCodeSelected='62';
                JobPlanOverCont.partssave();
                JobPlanOverCont.showResolutionWithRepair=true;
                JobPlanOverCont.coverageFound=null;
                JobPlanOverCont.coverageType= 'POL';
                //JobPlanOverCont.saveAndCloseJob();
                JobPlanOverCont.onChangeofAppCode();
                JobPlanOverCont.SelectedFname = null; 
                JobPlanOverCont.Wid = apexpages.currentPage().getparameters().put('id',claims.Id); 
                boolean headerValidation = CG_BL_ODM.callODMHeaderValidationService(null,null,null,null,null,null); 
                JobPlanOverCont.SendFailurestoERP();

                CSS_JobEventTemporary__c jet=new CSS_JobEventTemporary__c();
                jet.Attribute1__c='HCL';jet.Attribute1__c='HCL';jet.Attribute1__c='HCL';jet.Attribute1__c='HCL';jet.Attribute1__c='HCL';jet.Attribute1__c='HCL';

                jet.key__c='AccountCodes';

                //JobPlanOverCont.callUnitInboundGeneric();
                JobPlanOverCont.callUpdateUnitandWo();
                JobPlanOverCont.jobplan_jo();
                JobPlanOverCont.jobplan_war();
                JobPlanOverCont.jobplan_narr();
                JobPlanOverCont.showPopup();
                JobPlanOverCont.closePopup();
                JobPlanOverCont.redirectPopup();
                JobPlanOverCont.getAccountCodes1();
                JobPlanOverCont.closeSession_close();
                JobPlanOverCont.pgSaveFinish();
                JobPlanOverCont.CompareDates();
                JobPlanOverCont.getfailurenames();

                CSS_Solution_Component__c compe = new CSS_Solution_Component__c(System_Code__c='HCL',Component_Code__c='TCS',Service_Job__c=JobPlanOverCont.wid); //accountcodeedit__c=JobPlanOverCont.accCodeReturned,
                insert compe;
                JobPlanOverCont.compont=compe;
                JobPlanOverCont.compont.Failure_Date__c=null;
                JobPlanOverCont.failureDate1=system.today();
                JobPlanOverCont.CompareDates();
                JobPlanOverCont.failureDate=system.today().adddays(2);
                JobPlanOverCont.CompareDates();
                JobPlanOverCont.compont.Failure_Date__c=system.today();
                JobPlanOverCont.CompareDates();
                JobPlanOverCont.selectedSysCode='HCL-ASP';
                JobPlanOverCont.selectedCompCode='TCS-ASP';
                JobPlanOverCont.accCodeReturned=null;
                JobPlanOverCont.failureMeasure='Hours';
                JobPlanOverCont.coverageType = 'POL';
                JobPlanOverCont.Validations();
                for(integer i=0; i<10;i++){
                    CSS_Solution_Component__c comp = new CSS_Solution_Component__c(System_Code__c='HCL',Component_Code__c='TCS',Service_Job__c=JobPlanOverCont.wid);//accountcodeedit__c=JobPlanOverCont.accCodeReturned,
                    insert comp;
                }
                JobPlanOverCont.coverageType = 'POL';
                JobPlanOverCont.Validations();
                JobPlanOverCont.coverageType = 'NPW';
                JobPlanOverCont.coverageFound = 'false';
                JobPlanOverCont.accCodeSelected = '52';
                JobPlanOverCont.selectedFailMode = 'THAS';
                JobPlanOverCont.chkClickonPartsCoverage = false;
		        set<string> setBlankFieldset = new set<string>();
                setBlankFieldset.add('false');
    		    //JobPlanOverCont.tempblankfieldset = setBlankFieldset;
                JobPlanOverCont.Validations();
                JobPlanOverCont.getPayCodesonAccCodeChangeOnLoad();
                JobPlanOverCont.workJob.Customer_Name__c = null;
                JobPlanOverCont.workJob.Application_Desc__c = null;
                JobPlanOverCont.workJob.Shop_Work_Order__c = null;
                JobPlanOverCont.workJob.Unit_number__c = null;
                JobPlanOverCont.workJob.Mileage__c = null;
                JobPlanOverCont.workJob.ESN__c = null;

                JobPlanOverCont.ChkFieldBlank();
                JobPlanOverCont.jobplan_jo();
                JobPlanOverCont.pgSave();
                JobPlanOverCont.Cancel();
                JobPlanOverCont.loadPopup();

                Test.stopTest();
            }
        }
    }
    
    public static testMethod void TestMethod3_12()
    {

        UserRole empRole = [Select Id From UserRole Where Name = 'CEO' Limit 1];
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'kal1', Email='standarduser11@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='kal12', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='kal11111@testorg.com', user_Location__c = '562701-562551',UserRoleId = empRole.id);
        insert(u);
        System.runAs(u) 
        {  
            CSS_SMN_FaultCode__c smn = new CSS_SMN_FaultCode__c();
            smn.Name = 'test';
            smn.Description__c = 'test';
            smn.Fault_Code__c = 'test';
            smn.SMN__c = 'ISB6.7 CM2350 B101';
            insert smn;

            CSS_JobEventTemporary__c JETsys = new CSS_JobEventTemporary__c();
            JETsys.Attribute1__c = 'OTH';
            JETsys.Attribute4__c ='TS';
            JETsys.key__c = 'AccountCodes';
            JETsys.Attribute3__c = 'TURBO';
            JETsys.Attribute5__c = 'ASSEMBLY';
            insert JETsys;
            CSS_JobEventTemporary__c JETsys1 = new CSS_JobEventTemporary__c();
            JETsys1.Attribute1__c = '';
            JETsys1.Attribute2__c ='OK';
            //   JETsys1.key__c = 'AccountCodes';
            JETsys1.key__c = 'FailModes';
            JETsys1.Active__c = true;
            JETsys1.Attribute3__c = 'ISX12 CM2350 X102;;0K';
            JETsys1.Attribute5__c = 'ASSEMBLY';
            JETsys1.Reason__c = '{\r\n\t\"Header\": {\r\n\t\t\"ReturnCodeDescription\": \"Normal, Successful completion.\",\r\n\t\t\"ReturnCode\": \"ORA-00000\",\r\n\t\t\"MessageIdentifier\": \"S\"\r\n\t},\r\n\t\"DataArea\": [{\r\n\t\t\"SystemCode\": \"WF\",\r\n\t\t\"FailureName\": \"ATC 1795\",\r\n\t\t\"FailureMode\": \"SP\",\r\n\t\t\"FailureID\": \"F30003750\",\r\n\t\t\"ComponentCode\": \"HA\"\r\n\t}]\r\n}';
            insert JETsys1;
            CSS_Job_Order__c jobRef = new CSS_Job_Order__c() ;
            jobRef.chevron_page__c='jo';
            jobRef.BMSWSStatus__c = 'UI';
            //jobRef.Name='test';
            jobRef.ESN__c ='Testing';
            jobRef.Service_Model__c ='ISB6.7 CM2350 B101';
            jobRef.Qsol_Engine_Family_Code__c ='10';
            jobRef.Repair_Location__c='Mobile';
            insert jobRef;
            PageReference pref;
            pref = new PageReference('/'+jobRef.id);
            pref.getParameters().put('id',jobRef.id);
            Test.setCurrentPage(pref);
            CSS_Fault_Code__c fauCodRef = new CSS_Fault_Code__c();
            fauCodRef.Job_Order__c =jobRef.Id; 
            fauCodRef.Sequence__c=1;
            fauCodRef.Fault_Code_Type__c='BPD'; 
            fauCodRef.Primary_Fault_Code__c=3539; 
            fauCodRef.Status__c='A';
            insert fauCodRef;
            List<CSS_Fault_Code__c> fauCodRefList = new List<CSS_Fault_Code__c>();
            fauCodRefList.add(fauCodRef);

            CSS_SymptomQA__c sqa = new CSS_SymptomQA__c();
            sqa.Name = 'black smoke';
            insert sqa;

            list<CSS_Solutions__c > solReflist=new list<CSS_Solutions__c>();

            CSS_Solutions__c solRef =  CSS_TestData.createSolutions(false,jobRef.Id);
            solRef.FaultCode__c = fauCodRef.id;
            solRef.Repair_Response__c='NO';
            solRef.Symptom__c = sqa.id;
            upsert solRef;

            solReflist.add(solRef);
            upsert solReflist;
            
            

            list<CSS_Solution_Component__c> solComReflist=new list<CSS_Solution_Component__c>();
            CSS_Solution_Component__c solComRef = CSS_TestData.createSRT(false,jobRef.Id,solRef.Id);
            solComRef.System_Code__c = 'Test';
            solComRef.Component_Code__c = 'Test';
            solComRef.Failure_Mode__c = 'Test';
            solComRef.Solutions__c =solRef.id;
            //solComRef.Performed_Review__c=true;
            solComRef.Type__c=null;
            solComRef.selected_Component__c = true;
            solComRef.Service_Job__c=jobRef.id;
            solComRef.AccountCodeType__c = 'Test-Test';
            solComRef.AccountCode_Call_Status__c = 'Failure';
            solComRef.AccountCode__c = 'ACCODE';
            solComRef.AccountCodeEdit__c='ADEDIT';
            solComRef.Failure_Measure__c='ADEDIT';
            solComRef.name='unlisted';
            insert solComRef;
            solComReflist.add(solComRef);

            Set<String> failureNameList = new Set<String>();
            String grpName = 'CQ'+'-'+'56270-56255';
            Group testQue = new Group(Name=grpName, type='Queue');
            insert testQue;
            CSS_Integration_Details__c csInt = new CSS_Integration_Details__c();
            csInt.name = 'SRT';
            csInt.ApplicationName__c='SRT';
            csInt.End_Point__c='https://Test-services-dev.cummins.com/css/';
            csInt.IsActive__c=true;
            csInt.Key__c='/Q0w11SmTDJ11dPRgzYfGjycs+HZbtT8sezi/jkT7Ag=';
            csInt.Passcode__c='u9pf3rdOE0SCjXDCgmzRbUlwWQWen7B9993Eh61KI1E=';
            csInt.Username__c='6dpW6v5ekUR2HzkTePJXwgNaMDgo0t53tZgmixV4rfU=';
            insert csint;
            system.runas(new User(Id=UserInfo.getUserId()))
            { 

                QueueSObject tq = new QueueSObject(SobjectType='CSS_Claims__c', QueueId=testQue.Id);
                insert tq;


                CSS_Claims__c claims = new CSS_Claims__c();
                claims.Status__c='Submitted';
                claims.ESN__c='79462880';
                claims.Customer_Name__c='BRITESTONE COLONY';
                claims.Customer_Code__c='123';
                claims.Location_Code__c='56270-56255';
                claims.ownerId = UserInfo.getUserId();
                insert claims;
                Test.startTest();

                CSS_JobPlanOverviewControllerNew JobPlanOverCont = new CSS_JobPlanOverviewControllerNew();
                JobPlanOverCont.componentId = solComRef.Id;
                JobPlanOverCont.failCodeSelected = 'Select One';
                JobPlanOverCont.accCodeSelected = null;
                JobPlanOverCont.failCodeEditable='Select One';
                JobPlanOverCont.allFaultCodes = fauCodRefList;
                JobPlanOverCont.failureMeasure='Kilometers';
                JobPlanOverCont.failCodeSelected = 'THAC';
                JobPlanOverCont.checkCoverageonfm = null;
                
                Test.setMock(HttpCalloutMock.class, new SRTMockHttpResponseGenerator());
                //JobPlanOverCont.SRTFailurenames();
                Test.setMock(HttpCalloutMock.class, new CSS_SRTCompMockup_Test());
                JobPlanOverCont.mainSOQL();
                JobPlanOverCont.failCodeChangeGO();
                //Test.setMock(HttpCalloutMock.class, new CSS_MockHttpResponseGenerator()); 
                JobPlanOverCont.callCreateWoqtInbound('Testing Class');
                JobPlanOverCont.jobplan_jpq();
                //      JobPlanOverCont.jobplan_srt();
                JobPlanOverCont.partsWarranty=null;
                JobPlanOverCont.accCodeSelected='11';
                JobPlanOverCont.partssave();
                JobPlanOverCont.showResolutionWithRepair=true;
                JobPlanOverCont.coverageFound='false';
                JobPlanOverCont.payCodeSelected = null;
                JobPlanOverCont.coverageType= 'HCL';
                //JobPlanOverCont.saveAndCloseJob();
                JobPlanOverCont.onChangeofAppCode();
                JobPlanOverCont.SelectedFname = null; 
                JobPlanOverCont.Wid = apexpages.currentPage().getparameters().put('id',claims.Id); 
                boolean headerValidation = CG_BL_ODM.callODMHeaderValidationService(null,null,null,null,null,null); 
                JobPlanOverCont.SendFailurestoERP();

                CSS_JobEventTemporary__c jet=new CSS_JobEventTemporary__c();
                jet.Attribute1__c='HCL';jet.Attribute1__c='HCL';jet.Attribute1__c='HCL';jet.Attribute1__c='HCL';jet.Attribute1__c='HCL';jet.Attribute1__c='HCL';

                jet.key__c='AccountCodes';

                //JobPlanOverCont.callUnitInboundGeneric();
                JobPlanOverCont.callUpdateUnitandWo();
                JobPlanOverCont.jobplan_jo();
                JobPlanOverCont.jobplan_war();
                JobPlanOverCont.jobplan_narr();
                JobPlanOverCont.showPopup();
                JobPlanOverCont.closePopup();
                JobPlanOverCont.redirectPopup();
                JobPlanOverCont.getAccountCodes1();
                JobPlanOverCont.closeSession_close();
                JobPlanOverCont.pgSaveFinish();
                JobPlanOverCont.CompareDates();
                JobPlanOverCont.getfailurenames();

                CSS_Solution_Component__c compe = new CSS_Solution_Component__c(System_Code__c='HCL',Component_Code__c='TCS',Service_Job__c=JobPlanOverCont.wid); //accountcodeedit__c=JobPlanOverCont.accCodeReturned,
                insert compe;
                JobPlanOverCont.compont=compe;
                JobPlanOverCont.compont.Failure_Date__c=null;
                JobPlanOverCont.failureDate1=system.today();
                JobPlanOverCont.CompareDates();
                JobPlanOverCont.failureDate=system.today().adddays(2);
                JobPlanOverCont.CompareDates();
                JobPlanOverCont.compont.Failure_Date__c=system.today();
                JobPlanOverCont.CompareDates();
                JobPlanOverCont.selectedSysCode='HCL-ASP';
                JobPlanOverCont.selectedCompCode='TCS-ASP';
                JobPlanOverCont.accCodeReturned=null;
                JobPlanOverCont.failureMeasure='Hours';
                JobPlanOverCont.coverageType = 'POL';
                JobPlanOverCont.Validations();
                for(integer i=0; i<10;i++){
                    CSS_Solution_Component__c comp = new CSS_Solution_Component__c(System_Code__c='HCL',Component_Code__c='TCS',Service_Job__c=JobPlanOverCont.wid);//accountcodeedit__c=JobPlanOverCont.accCodeReturned,
                    insert comp;
                }
                JobPlanOverCont.coverageType = 'POL';
                JobPlanOverCont.Validations();
                JobPlanOverCont.coverageType = 'NPW';
                JobPlanOverCont.coverageFound = 'false';
                JobPlanOverCont.accCodeSelected = '52';
                JobPlanOverCont.selectedFailMode = 'THAS';
                JobPlanOverCont.chkClickonPartsCoverage = false;
		        set<string> setBlankFieldset = new set<string>();
                setBlankFieldset.add('false');
    		    //JobPlanOverCont.tempblankfieldset = setBlankFieldset;
                JobPlanOverCont.Validations();
                JobPlanOverCont.getPayCodesonAccCodeChangeOnLoad();
                JobPlanOverCont.workJob.Customer_Name__c = null;
                JobPlanOverCont.workJob.Application_Desc__c = null;
                JobPlanOverCont.workJob.Shop_Work_Order__c = null;
                JobPlanOverCont.workJob.Unit_number__c = null;
                JobPlanOverCont.workJob.Mileage__c = null;
                JobPlanOverCont.workJob.ESN__c = null;

                JobPlanOverCont.ChkFieldBlank();
                JobPlanOverCont.jobplan_jo();
                JobPlanOverCont.pgSave();
                JobPlanOverCont.Cancel();
                JobPlanOverCont.loadPopup();

                Test.stopTest();
            }
        }
    }
    public static testMethod void TestMethod31()
    {

        UserRole empRole = [Select Id From UserRole Where Name = 'CEO' Limit 1];
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'kal1', Email='standarduser11@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='kal12', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='kal11111@testorg.com', user_Location__c = '562701-562551',UserRoleId = empRole.id);
        insert(u);
        System.runAs(u) 
        {  

            CSS_JobEventTemporary__c JETsys = new CSS_JobEventTemporary__c();
            JETsys.Attribute1__c = 'OTH';
            JETsys.Attribute4__c ='TS';
            JETsys.key__c = 'AccountCodes';
            JETsys.Attribute3__c = 'TURBO';
            JETsys.Attribute5__c = 'ASSEMBLY';
            insert JETsys;
            CSS_JobEventTemporary__c JETsys1 = new CSS_JobEventTemporary__c();
            JETsys1.Attribute1__c = 'NPW';
            JETsys1.Attribute2__c ='OK';
            JETsys1.key__c = 'AccountCodes';
            JETsys1.Attribute3__c = 'ISX12 CM2350 X102;;0K';
            JETsys1.Attribute5__c = 'ASSEMBLY';
            JETsys1.Reason__c = '{\r\n\t\"Header\": {\r\n\t\t\"ReturnCodeDescription\": \"Normal, Successful completion.\",\r\n\t\t\"ReturnCode\": \"ORA-00000\",\r\n\t\t\"MessageIdentifier\": \"S\"\r\n\t},\r\n\t\"DataArea\": [{\r\n\t\t\"SystemCode\": \"WF\",\r\n\t\t\"FailureName\": \"ATC 1795\",\r\n\t\t\"FailureMode\": \"SP\",\r\n\t\t\"FailureID\": \"F30003750\",\r\n\t\t\"ComponentCode\": \"HA\"\r\n\t}]\r\n}';
            insert JETsys1;
            CSS_Job_Order__c jobRef = new CSS_Job_Order__c() ;
            jobRef.chevron_page__c='jo';
            jobRef.BMSWSStatus__c = 'UI';
            //jobRef.Name='test';
            jobRef.ESN__c ='Testing';
            jobRef.Service_Model__c ='ISB6.7 CM2350 B101';
            jobRef.Qsol_Engine_Family_Code__c ='10';
            jobRef.Repair_Location__c='Mobile';
            insert jobRef;
            PageReference pref;
            pref = new PageReference('/'+jobRef.id);
            pref.getParameters().put('id',jobRef.id);
            Test.setCurrentPage(pref);
            CSS_Fault_Code__c fauCodRef = new CSS_Fault_Code__c();
            fauCodRef.Job_Order__c =jobRef.Id; 
            fauCodRef.Sequence__c=1;
            fauCodRef.Fault_Code_Type__c='BPD'; 
            fauCodRef.Primary_Fault_Code__c=3539; 
            fauCodRef.Status__c='A';
            insert fauCodRef;
            List<CSS_Fault_Code__c> fauCodRefList = new List<CSS_Fault_Code__c>();
            fauCodRefList.add(fauCodRef);

            list<CSS_Solutions__c > solReflist=new list<CSS_Solutions__c>();

            CSS_Solutions__c solRef =  CSS_TestData.createSolutions(false,jobRef.Id);
            solRef.FaultCode__c = fauCodRef.id;
            solRef.Repair_Response__c='NO';
            upsert solRef;

            solReflist.add(solRef);
            upsert solReflist;

            list<CSS_Solution_Component__c> solComReflist=new list<CSS_Solution_Component__c>();
            CSS_Solution_Component__c solComRef = CSS_TestData.createSRT(false,jobRef.Id,solRef.Id);
            solComRef.System_Code__c = 'Test';
            solComRef.Component_Code__c = 'Test';
            solComRef.Failure_Mode__c = 'Test';
            solComRef.Solutions__c =solRef.id;
            //solComRef.Performed_Review__c=true;
            solComRef.Type__c=null;
            solComRef.selected_Component__c = true;
            solComRef.Service_Job__c=jobRef.id;
            solComRef.AccountCodeType__c = 'Test-Test';
            solComRef.AccountCode_Call_Status__c = 'Failure';
            solComRef.AccountCode__c = 'ACCODE';
            solComRef.AccountCodeEdit__c='ADEDIT';
            solComRef.Failure_Measure__c='ADEDIT';
            solComRef.name='unlisted';
            insert solComRef;
            solComReflist.add(solComRef);

            Set<String> failureNameList = new Set<String>();
            String grpName = 'CQ'+'-'+'56270-56255';
            Group testQue = new Group(Name=grpName, type='Queue');
            insert testQue;
            CSS_Integration_Details__c csInt = new CSS_Integration_Details__c();
            csInt.name = 'SRT';
            csInt.ApplicationName__c='SRT';
            csInt.End_Point__c='https://Test-services-dev.cummins.com/css/';
            csInt.IsActive__c=true;
            csInt.Key__c='/Q0w11SmTDJ11dPRgzYfGjycs+HZbtT8sezi/jkT7Ag=';
            csInt.Passcode__c='u9pf3rdOE0SCjXDCgmzRbUlwWQWen7B9993Eh61KI1E=';
            csInt.Username__c='6dpW6v5ekUR2HzkTePJXwgNaMDgo0t53tZgmixV4rfU=';
            insert csint;
            system.runas(new User(Id=UserInfo.getUserId()))
            { 

                QueueSObject tq = new QueueSObject(SobjectType='CSS_Claims__c', QueueId=testQue.Id);
                insert tq;


                CSS_Claims__c claims = new CSS_Claims__c();
                claims.Status__c='Submitted';
                claims.ESN__c='79462880';
                claims.Customer_Name__c='BRITESTONE COLONY';
                claims.Customer_Code__c='123';
                claims.Location_Code__c='56270-56255';
                claims.ownerId = UserInfo.getUserId();
                insert claims;
                Test.startTest();

                CSS_JobPlanOverviewControllerNew JobPlanOverCont = new CSS_JobPlanOverviewControllerNew();
                JobPlanOverCont.componentId = solComRef.Id;
                JobPlanOverCont.failCodeSelected = 'Select One';
                JobPlanOverCont.accCodeSelected = 'PARTS WARRANTY 35';
                JobPlanOverCont.failCodeEditable='Select One';
                JobPlanOverCont.allFaultCodes = fauCodRefList;
                JobPlanOverCont.failureMeasure='Kilometers';
                Test.setMock(HttpCalloutMock.class, new SRTMockHttpResponseGenerator());
                //JobPlanOverCont.SRTFailurenames();
                Test.setMock(HttpCalloutMock.class, new CSS_SRTCompMockup_Test());
                JobPlanOverCont.mainSOQL();
                JobPlanOverCont.failCodeChangeGO();
                //Test.setMock(HttpCalloutMock.class, new CSS_MockHttpResponseGenerator()); 
                JobPlanOverCont.callCreateWoqtInbound('Testing Class');
                JobPlanOverCont.jobplan_jpq();
                //   JobPlanOverCont.jobplan_srt();
                JobPlanOverCont.partsWarranty=null;
                JobPlanOverCont.accCodeSelected='62';
                JobPlanOverCont.partssave();
                JobPlanOverCont.showResolutionWithRepair=true;
                //JobPlanOverCont.saveAndCloseJob();
                JobPlanOverCont.onChangeofAppCode();
                JobPlanOverCont.SelectedFname = null; 
                JobPlanOverCont.Wid = apexpages.currentPage().getparameters().put('id',claims.Id); 
                boolean headerValidation = CG_BL_ODM.callODMHeaderValidationService(null,null,null,null,null,null); 
                JobPlanOverCont.SendFailurestoERP();

                CSS_JobEventTemporary__c jet=new CSS_JobEventTemporary__c();
                jet.Attribute1__c='OTH';jet.Attribute1__c='POL';jet.Attribute1__c='NPW';jet.Attribute1__c='RPW';jet.Attribute1__c='REW';jet.Attribute1__c='RRW ';

                jet.key__c='AccountCodes';

                // JobPlanOverCont.callUnitInboundGeneric();
                JobPlanOverCont.callUpdateUnitandWo();
                JobPlanOverCont.jobplan_jo();
                JobPlanOverCont.jobplan_war();
                JobPlanOverCont.jobplan_narr();
                JobPlanOverCont.showPopup();
                JobPlanOverCont.closePopup();
                JobPlanOverCont.redirectPopup();
                JobPlanOverCont.getAccountCodes1();
                JobPlanOverCont.closeSession_close();
                JobPlanOverCont.pgSaveFinish();
                JobPlanOverCont.CompareDates();
                JobPlanOverCont.getfailurenames();

                CSS_Solution_Component__c compe = new CSS_Solution_Component__c(System_Code__c='HCL',accountcodeedit__c=JobPlanOverCont.accCodeReturned,Component_Code__c='TCS',Service_Job__c=JobPlanOverCont.wid);
                insert compe;
                JobPlanOverCont.compont=compe;
                JobPlanOverCont.compont.Failure_Date__c=null;
                JobPlanOverCont.failureDate1=system.today();
                JobPlanOverCont.CompareDates();
                JobPlanOverCont.failureDate=system.today().adddays(2);
                JobPlanOverCont.CompareDates();
                JobPlanOverCont.compont.Failure_Date__c=system.today();
                JobPlanOverCont.CompareDates();
                JobPlanOverCont.selectedSysCode='HCL-ASP';
                JobPlanOverCont.selectedCompCode='TCS-ASP';
                JobPlanOverCont.accCodeReturned='NEW PARTS';
                JobPlanOverCont.failureMeasure='Hours';
                JobPlanOverCont.coverageType = 'POL';
                JobPlanOverCont.Validations();
                for(integer i=0; i<10;i++){
                    CSS_Solution_Component__c comp = new CSS_Solution_Component__c(System_Code__c='HCL',accountcodeedit__c=JobPlanOverCont.accCodeReturned,Component_Code__c='TCS',Service_Job__c=JobPlanOverCont.wid);
                    insert comp;
                }
                JobPlanOverCont.coverageType = 'POL';
                JobPlanOverCont.Validations();
                JobPlanOverCont.coverageType = 'NPW';
                JobPlanOverCont.coverageFound = 'false';
                JobPlanOverCont.accCodeSelected = '52';
                JobPlanOverCont.selectedFailMode = 'THAS';
                JobPlanOverCont.chkClickonPartsCoverage = false;
		        set<string> setBlankFieldset = new set<string>();
                setBlankFieldset.add('false');
    		    //JobPlanOverCont.tempblankfieldset = setBlankFieldset;
                JobPlanOverCont.Validations();
                JobPlanOverCont.getPayCodesonAccCodeChangeOnLoad();
                JobPlanOverCont.workJob.Customer_Name__c = null;
                JobPlanOverCont.workJob.Application_Desc__c = null;
                JobPlanOverCont.workJob.Shop_Work_Order__c = null;
                JobPlanOverCont.workJob.Unit_number__c = null;
                JobPlanOverCont.workJob.Mileage__c = null;
                JobPlanOverCont.workJob.ESN__c = null;

                JobPlanOverCont.ChkFieldBlank();
                JobPlanOverCont.jobplan_jo();
                JobPlanOverCont.pgSave();
                JobPlanOverCont.Cancel();
                JobPlanOverCont.loadPopup();

                Test.stopTest();
            }
        }
    }
    
    public static testMethod void TestMethod4()
    {
        UserRole empRole = [Select Id From UserRole Where Name like '%TECHNICIAN%' Limit 1];
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'kal1', Email='standarduser11@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='kal12', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='kal11111@testorg.com', user_Location__c = '56270-56255',UserRoleId = empRole.id);
        insert(u);
        System.runAs(u) 
        {  

            //Creating Job--1
            CSS_Job_Order__c jobRef = CSS_TestData.createJobOrder(false);
            jobRef.chevron_page__c='jo';
            jobRef.BMSWSStatus__c = 'UI';
            jobRef.ESN__c ='123';
            jobRef.Service_Model__c ='ISX12 CM2350 X102';
            jobRef.Qsol_Engine_Family_Code__c ='0K';
            jobref.CoverageResponse__c = 'Testing';
            jobRef.Failure_Date__c = System.today();
            insert jobRef;
            PageReference pref;
            pref = new PageReference('/'+jobRef.id);
            pref.getParameters().put('id',jobRef.id);
            Test.setCurrentPage(pref);

            //Creating Fault code
            CSS_Fault_Code__c fauCodRef = new CSS_Fault_Code__c();
            fauCodRef.Job_Order__c =jobRef.Id; 
            fauCodRef.Sequence__c=1;
            fauCodRef.Fault_Code_Type__c='BPD'; 
            fauCodRef.Primary_Fault_Code__c=3539; 
            fauCodRef.Status__c='A';
            insert fauCodRef;
            List<CSS_Fault_Code__c> fauCodRefList = new List<CSS_Fault_Code__c>();
            fauCodRefList.add(fauCodRef);

            CSS_SymptomQA__c symqa=new CSS_SymptomQA__c();
            symqa.job_order__c = jobRef.id;
            symqa.type__c='SearchString';
            symqa.user_name__c = null;
            symqa.name='TESST';
            symqa.Caption__c = 'akanksha';
            insert symqa;

            CSS_JobEventTemporary__c JETsys = new CSS_JobEventTemporary__c();
            JETsys.Attribute1__c = 'TH';
            JETsys.Attribute4__c ='TS';
            JETsys.key__c = 'FailCodes';
            JETsys.Attribute3__c = 'TURBO';
            JETsys.Attribute5__c = 'ASSEMBLY';
            JETsys.Attribute7__c='Turbocharger';
            upsert JETsys;
            CSS_JobEventTemporary__c JETemp1 = new CSS_JobEventTemporary__c();
            JETemp1.Attribute1__c = 'TH';
            JETemp1.Attribute4__c ='TS';
            JETemp1.key__c = 'FailModes';
            JETemp1.Active__c= true;
            JETemp1.Attribute3__c = 'TURBO';
            JETemp1.Attribute5__c = 'ASSEMBLY';
            JETemp1.Attribute7__c='Turbocharger';
            upsert JETemp1;

            CSS_JobEventTemporary__c JETsys1 = new CSS_JobEventTemporary__c();
            JETsys1.Attribute1__c = 'ISX12 CM2350 X102';
            JETsys1.Attribute2__c ='OK';
            JETsys1.key__c = 'GetFailureCodesSRT';
            JETsys1.Attribute3__c = 'ISX12 CM2350 X102;;0K';
            JETsys1.Attribute5__c = 'ASSEMBLY';
            JETsys1.Reason__c = '{\r\n\t\"Header\": {\r\n\t\t\"ReturnCodeDescription\": \"Normal, Successful completion.\",\r\n\t\t\"ReturnCode\": \"ORA-00000\",\r\n\t\t\"MessageIdentifier\": \"S\"\r\n\t},\r\n\t\"DataArea\": [{\r\n\t\t\"SystemCode\": \"WF\",\r\n\t\t\"FailureName\": \"ATC 1795\",\r\n\t\t\"FailureMode\": \"SP\",\r\n\t\t\"FailureID\": \"F30003750\",\r\n\t\t\"ComponentCode\": \"HA\"\r\n\t}]\r\n}';
            insert JETsys1;
            list<CSS_JobEventTemporary__c> JETlist = new list<CSS_JobEventTemporary__c>();
            CSS_JobEventTemporary__c JETsys2 = new CSS_JobEventTemporary__c();
            JETsys2.Attribute1__c = 'POL';
            JETsys2.Attribute2__c ='CDA POLICY';
            JETsys2.key__c = 'AccountCodes';
            JETsys2.Attribute3__c = '58';
            JETsys2.Attribute5__c = 'ASSEMBLY';
            insert JETsys2;
            JETlist.add(JETsys);
            JETlist.add(JETemp1);
            JETlist.add(JETsys1);
            JETlist.add(JETsys2);
            //Creating Soltions--3
            CSS_Solutions__c solRef =  CSS_TestData.createSolutions(false,jobRef.Id);
            solRef.FaultCode__c = fauCodRef.id;
            insert solRef;
            solRef.Symptom__c=symqa.id;
            upsert solref;


            //Creating Solution Component--4
            for(integer i=0;i<5;i++)
            {
                CSS_Solution_Component__c solComRef = CSS_TestData.createSRT(false,jobRef.Id,solRef.Id);
                solComRef.System_Code__c = 'Test';
                solComRef.Component_Code__c = 'Test';

                solComRef.Failure_Mode__c = 'Test';
                solComRef.Solutions__c =solRef.id;
                solComRef.AccountCodeType__c = 'Test-Test';
                solComRef.AccountCode_Call_Status__c = 'Failure';
                solComRef.Failure_Point__c=11.0;
                solComRef.Failure_Date__c=date.parse('12/27/2014');
                solComRef.AccountCode__c = 'ACDIED-DF';
                solComRef.Fault_Code__c='Test'; 
                solComRef.SystemCode_Desc__c='test1';
                solComRef.ComponentCode_Desc__c='test2';
                System.debug('The Solution Component Object' +solComRef);

                insert solComRef;
            }

            list<CSS_Solution_Component__c> solcomreflist = [select id,System_Code__c,Component_Code__c,Failure_Mode__c,Solutions__c,AccountCodeType__c,AccountCode_Call_Status__c,Failure_Point__c,Failure_Date__c,AccountCodeEdit__c from CSS_Solution_Component__c];
            //System.debug('The Solution Component Object is:'+solComRef);
            boolean accCodeExist=false;
            //Populating Account codes
            List<SelectOption> accCodes = new List<SelectOption>();
            accCodes.add(new SelectOption('Test1','Test1'));
            accCodes.add(new SelectOption('Test2','Test2'));
            accCodes.add(new SelectOption('Test3','Test3'));
            accCodes.add(new SelectOption('Test4','Test4'));

            CSS_JobPlanOverviewControllerNew obj1=new CSS_JobPlanOverviewControllerNew();
            obj1.accCodeEditable='Test';
            obj1.componentId = String.valueOf(solcomreflist[0].id);
            obj1.selectedCompCode='TS';
            obj1.selectedSysCode='TH';

            //  obj1.loadPopup();

            list<CSS_Solution_Component__c> solcomreflist1 = [select id,System_Code__c,Component_Code__c,Failure_Mode__c,Solutions__c,AccountCodeType__c,AccountCode_Call_Status__c,Failure_Point__c,Failure_Date__c,AccountCodeEdit__c from CSS_Solution_Component__c];
            CSS_Solution_Component__c solComRef1 = CSS_TestData.createSRT(false,jobRef.Id,solRef.Id);
            solComRef1.System_Code__c = 'Test';
            solComRef1.Component_Code__c = 'Test';
            solComRef1.Failure_Mode__c = 'Test';
            solComRef1.Solutions__c =solRef.id;
            solComRef1.AccountCodeEdit__c  = 'Test-Test';
            solComRef1.AccountCode_Call_Status__c = 'Failure';
            solComRef1.Failure_Point__c=11.0;
            solComRef1.Failure_Date__c=date.parse('12/27/2014');
            solComRef1.AccountCode__c = 'ACDIED-DF';
            solComRef1.Fault_Code__c='Test';   
            solComRef1.AccountCodeType__c='ASD-AS';
            insert solComRef1;
            solcomreflist1.add(solComRef1);

            upsert solcomreflist1;

            List<SelectOption> accCodes1 = new List<SelectOption>();
            accCodes1.add(new SelectOption('Test1','Test1'));
            accCodes1.add(new SelectOption('Test2','Test2'));
            accCodes1.add(new SelectOption('Test3','Test3'));
            accCodes1.add(new SelectOption('Test4','Test4'));

            CSS_JobPlanOverviewControllerNew obj2=new CSS_JobPlanOverviewControllerNew();
            obj2.accCodeEditable='Test';
            obj2.componentId = String.valueOf(solcomreflist1[0].id);
            // obj2.loadPopup();

            obj1.warrantyDate = System.today();
            obj1.partsWarrDt = system.today();
            obj1.warrStDtHidden = 'Testing';
            obj1.accCodeSelected = 'EMISSION WARRANTY 70';
            obj1.selectedFaultCode = null;
            obj1.selectedFaultCode = '';
            obj1.Wid = null;
            obj1.comm = 'Testing';
            //obj1.compont.Failure_Date__c = null; 

            //obj1.CompareDates();
            obj1.Cancel();

            obj1.Wid = apexpages.currentPage().getparameters().put('id',jobRef.Id);

            obj1.Cancel();           


            //select Attribute1__c, Attribute3__c from CSS_JobEventTemporary__c where key__c='FailModes'
            list<CSS_JobEventTemporary__c> jetl =new list<CSS_JobEventTemporary__c>();

            CSS_JobEventTemporary__c jet=new CSS_JobEventTemporary__c();
            jet.Attribute1__c='OTH';jet.Attribute1__c='POL';jet.Attribute1__c='NPW';jet.Attribute1__c='RPW';jet.Attribute1__c='REW';jet.Attribute1__c='RRW ';
            jet.Reason__c='TEE';
            jet.key__c='FailModes';
            jet.Name='Test';
            insert jet;
            jetl.add(jet);
            upsert jetl;


            obj1.getAccountCodes1();
            obj1.pgSaveFinish();
            obj1.getFaultCodes();

            obj1.failureDate = System.today();
            obj1.failureDate1 = System.today();
            //obj1.CompareDates();

            obj1.failureDate = null;
            obj1.failureDate1 = System.today();
            //  obj1.CompareDates();

            obj1.failureDate = System.today();
            obj1.failureDate1 = null;
            //obj1.CompareDates();

            obj1.jobplan_jpq();
            obj1.saveCheckBox();
            obj1.selectedFaultCode = 'TEST';

            obj1.getAccountCodes1();
            obj1.pgSaveFinish();
            // obj1.CompareDates();
            Test.setMock(HttpCalloutMock.class , new CSS_WS_SBL_GetWarrantyDetailCovrg_Test());
            obj1.checkcoverage();
            obj1.jobplan_jpq();

            obj1.saveCheckBox();
            obj1.onChangeofAppCode();
            obj1.selectedFName='unlisted';
            //obj1.SRTFailurenames();
            obj1.createQuoteRecord('7987989');


            //obj1.callUnitInboundGeneric();
            obj1.callUpdateUnitandWo();
            obj1.jobplan_jo();
            //   obj1.jobplan_war();
            obj1.jobplan_narr();
            obj1.showPopup();
            obj1.closePopup();
            obj1.redirectPopup();
            obj1.getAccountCodes1();
            obj1.closeSession_close();
            obj1.pgSaveFinish();
            // obj1.CompareDates();
            obj1.getfailurenames();

        }
    }
    public static testMethod void TestMethod4new()
    {
        UserRole empRole = [Select Id From UserRole Where Name like '%TECHNICIAN%' Limit 1];
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'kal1', Email='standarduser11@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='kal12', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='kal11111@testorg.com', user_Location__c = '56270-56255',UserRoleId = empRole.id);
        insert(u);
        System.runAs(u) 
        {  

            //Creating Job--1
            CSS_Job_Order__c jobRef = CSS_TestData.createJobOrder(false);
            jobRef.chevron_page__c='jo';
            jobRef.BMSWSStatus__c = 'UI';
            jobRef.ESN__c ='123';
            jobRef.Service_Model__c ='ISX12 CM2350 X102';
            jobRef.Qsol_Engine_Family_Code__c ='0K';
            jobref.CoverageResponse__c = 'Testing';
            jobRef.Failure_Date__c = System.today();
            insert jobRef;
            PageReference pref;
            pref = new PageReference('/'+jobRef.id);
            pref.getParameters().put('id',jobRef.id);
            Test.setCurrentPage(pref);

            //Creating Fault code
            CSS_Fault_Code__c fauCodRef = new CSS_Fault_Code__c();
            fauCodRef.Job_Order__c =jobRef.Id; 
            fauCodRef.Sequence__c=1;
            fauCodRef.Fault_Code_Type__c='BPD'; 
            fauCodRef.Primary_Fault_Code__c=3539; 
            fauCodRef.Status__c='A';
            insert fauCodRef;
            List<CSS_Fault_Code__c> fauCodRefList = new List<CSS_Fault_Code__c>();
            fauCodRefList.add(fauCodRef);

            CSS_SymptomQA__c symqa=new CSS_SymptomQA__c();
            symqa.job_order__c = jobRef.id;
            symqa.type__c='SearchString';
            symqa.user_name__c = null;
            symqa.name='TESST';
            symqa.Caption__c = 'akanksha';
            insert symqa;

            CSS_JobEventTemporary__c JETsys = new CSS_JobEventTemporary__c();
            JETsys.Attribute1__c = 'TH';
            JETsys.Attribute4__c ='TS';
            JETsys.key__c = 'FailCodes';
            JETsys.Attribute3__c = 'TURBO';
            JETsys.Attribute5__c = 'ASSEMBLY';
            JETsys.Attribute7__c='Turbocharger';
            upsert JETsys;
            CSS_JobEventTemporary__c JETemp1 = new CSS_JobEventTemporary__c();
            JETemp1.Attribute1__c = 'TH';
            JETemp1.Attribute4__c ='TS';
            JETemp1.key__c = 'FailModes';
            JETemp1.Active__c= true;
            JETemp1.Attribute3__c = 'TURBO';
            JETemp1.Attribute5__c = 'ASSEMBLY';
            JETemp1.Attribute7__c='Turbocharger';
            upsert JETemp1;

            CSS_JobEventTemporary__c JETsys1 = new CSS_JobEventTemporary__c();
            JETsys1.Attribute1__c = 'ISX12 CM2350 X102';
            JETsys1.Attribute2__c ='OK';
            JETsys1.key__c = 'GetFailureCodesSRT';
            JETsys1.Attribute3__c = 'ISX12 CM2350 X102;;0K';
            JETsys1.Attribute5__c = 'ASSEMBLY';
            JETsys1.Reason__c = '{\r\n\t\"Header\": {\r\n\t\t\"ReturnCodeDescription\": \"Normal, Successful completion.\",\r\n\t\t\"ReturnCode\": \"ORA-00000\",\r\n\t\t\"MessageIdentifier\": \"S\"\r\n\t},\r\n\t\"DataArea\": [{\r\n\t\t\"SystemCode\": \"WF\",\r\n\t\t\"FailureName\": \"ATC 1795\",\r\n\t\t\"FailureMode\": \"SP\",\r\n\t\t\"FailureID\": \"F30003750\",\r\n\t\t\"ComponentCode\": \"HA\"\r\n\t}]\r\n}';
            insert JETsys1;
            list<CSS_JobEventTemporary__c> JETlist = new list<CSS_JobEventTemporary__c>();
            CSS_JobEventTemporary__c JETsys2 = new CSS_JobEventTemporary__c();
            JETsys2.Attribute1__c = 'POL';
            JETsys2.Attribute2__c ='CDA POLICY';
            JETsys2.key__c = 'AccountCodes';
            JETsys2.Attribute3__c = '58';
            JETsys2.Attribute5__c = 'ASSEMBLY';
            insert JETsys2;
            JETlist.add(JETsys);
            JETlist.add(JETemp1);
            JETlist.add(JETsys1);
            JETlist.add(JETsys2);
            //Creating Soltions--3
            CSS_Solutions__c solRef =  CSS_TestData.createSolutions(false,jobRef.Id);
            solRef.FaultCode__c = fauCodRef.id;
            insert solRef;
            solRef.Symptom__c=symqa.id;
            upsert solref;


            //Creating Solution Component--4
            for(integer i=0;i<5;i++)
            {
                CSS_Solution_Component__c solComRef = CSS_TestData.createSRT(false,jobRef.Id,solRef.Id);
                solComRef.System_Code__c = 'Test';
                solComRef.Component_Code__c = 'Test';

                solComRef.Failure_Mode__c = 'Test';
                solComRef.Solutions__c =solRef.id;
                solComRef.AccountCodeType__c = 'Test-Test';
                solComRef.AccountCode_Call_Status__c = 'Failure';
                solComRef.Failure_Point__c=11.0;
                solComRef.Failure_Date__c=date.parse('12/27/2014');
                solComRef.AccountCode__c = 'ACDIED-DF';
                solComRef.Fault_Code__c='Test'; 
                solComRef.SystemCode_Desc__c='test1';
                solComRef.ComponentCode_Desc__c='test2';
                System.debug('The Solution Component Object' +solComRef);

                insert solComRef;
            }

            list<CSS_Solution_Component__c> solcomreflist = [select id,System_Code__c,Component_Code__c,Failure_Mode__c,Solutions__c,AccountCodeType__c,AccountCode_Call_Status__c,Failure_Point__c,Failure_Date__c,AccountCodeEdit__c from CSS_Solution_Component__c];
            //System.debug('The Solution Component Object is:'+solComRef);
            boolean accCodeExist=false;
            //Populating Account codes
            List<SelectOption> accCodes = new List<SelectOption>();
            accCodes.add(new SelectOption('Test1','Test1'));
            accCodes.add(new SelectOption('Test2','Test2'));
            accCodes.add(new SelectOption('Test3','Test3'));
            accCodes.add(new SelectOption('Test4','Test4'));


            list<CSS_Solution_Component__c> solcomreflist1 = [select id,System_Code__c,Component_Code__c,Failure_Mode__c,Solutions__c,AccountCodeType__c,AccountCode_Call_Status__c,Failure_Point__c,Failure_Date__c,AccountCodeEdit__c from CSS_Solution_Component__c];
            CSS_Solution_Component__c solComRef1 = CSS_TestData.createSRT(false,jobRef.Id,solRef.Id);
            solComRef1.System_Code__c = 'Test';
            solComRef1.Component_Code__c = 'Test';
            solComRef1.Failure_Mode__c = 'Test';
            solComRef1.Solutions__c =solRef.id;
            solComRef1.AccountCodeEdit__c  = 'Test-Test';
            solComRef1.AccountCode_Call_Status__c = 'Failure';
            solComRef1.Failure_Point__c=11.0;
            solComRef1.Failure_Date__c=date.parse('12/27/2014');
            solComRef1.AccountCode__c = 'ACDIED-DF';
            solComRef1.Fault_Code__c='Test';   
            solComRef1.Failure_Measure__c=''; 
            solComRef1.AccountCodeType__c='ASD-AS';
            insert solComRef1;
            solcomreflist1.add(solComRef1);

            upsert solcomreflist1;

            List<SelectOption> accCodes1 = new List<SelectOption>();
            accCodes1.add(new SelectOption('Test1','Test1'));
            accCodes1.add(new SelectOption('Test2','Test2'));
            accCodes1.add(new SelectOption('Test3','Test3'));
            accCodes1.add(new SelectOption('Test4','Test4'));

            CSS_JobPlanOverviewControllerNew obj1=new CSS_JobPlanOverviewControllerNew();
            obj1.accCodeEditable='Test';
            obj1.componentId = String.valueOf(solcomreflist1[0].id);
            // obj2.loadPopup();


            //obj1.compont.Failure_Date__c = null; 



            obj1.Wid = apexpages.currentPage().getparameters().put('id',jobRef.Id);

            obj1.compont =   solComRef1;
            obj1.accCodeSelected='test62';

            //select Attribute1__c, Attribute3__c from CSS_JobEventTemporary__c where key__c='FailModes'
            list<CSS_JobEventTemporary__c> jetl =new list<CSS_JobEventTemporary__c>();

            CSS_JobEventTemporary__c jet=new CSS_JobEventTemporary__c();
            jet.Attribute1__c='OTH';jet.Attribute1__c='POL';jet.Attribute1__c='NPW';jet.Attribute1__c='RPW';jet.Attribute1__c='REW';jet.Attribute1__c='RRW ';
            jet.Reason__c='TEE';
            jet.key__c='FailModes';
            jet.Name='Test';
            insert jet;
            jetl.add(jet);
            upsert jetl;




            obj1.failureDate = System.today();
            obj1.failureDate1 = System.today();
            //obj1.CompareDates();

            obj1.failureDate = null;
            obj1.failureDate1 = System.today();
            //  obj1.CompareDates();

            obj1.failureDate = System.today();
            obj1.failureDate1 = null;
            //obj1.CompareDates();


            Test.setMock(HttpCalloutMock.class , new CSS_WS_SBL_GetWarrantyDetailCovrg_Test());
            obj1.checkcoverage();



        }
    } 
    public static testMethod void TestMethod5()
    {
        UserRole empRole = [Select Id From UserRole Where Name = 'Factory' Limit 1];
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator' Limit 1]; 
        User u = new User(Alias = 'kal1', Email='standarduser11@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='kal12', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='kal11111@testorg.com', user_Location__c = '562701-562551',UserRoleId = empRole.id);
        insert(u);

        System.runAs(u) 
        {  
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new CSS_MockHttpResponseGenerator()); 
            CSS_Job_Order__c jobRef = CSS_TestData.createJobOrder(false);
            jobRef.chevron_page__c='jo';
            jobRef.BMSWSStatus__c = 'UI';
            jobRef.Status__c='Intake';
            insert jobref;

            PageReference pref;
            pref = new PageReference('/'+jobRef.id);
            pref.getParameters().put('id',jobRef.id);
            Test.setCurrentPage(pref);

            CSS_Fault_Code__c fauCodRef = new CSS_Fault_Code__c();
            fauCodRef.Job_Order__c =jobRef.Id; 
            fauCodRef.Sequence__c=1;
            fauCodRef.Fault_Code_Type__c='BPD'; 
            fauCodRef.Primary_Fault_Code__c=3539; 
            fauCodRef.Status__c='A';
            insert fauCodRef;

            List<CSS_Fault_Code__c> fauCodRefList = new List<CSS_Fault_Code__c>();
            fauCodRefList.add(fauCodRef);

            CSS_Solutions__c solRef =  CSS_TestData.createSolutions(true,jobRef.Id);
            solRef.FaultCode__c = fauCodRef.id;
            update solRef;

            CSS_Solution_Component__c solComRef = CSS_TestData.createSRT(false,jobRef.Id,solRef.Id);
            solComRef.System_Code__c = 'Test';
            solComRef.Component_Code__c = 'Test';
            solComRef.Failure_Mode__c = 'Test';
            solComRef.Solutions__c =solRef.id;
            solComRef.AccountCodeType__c = 'Test';
            solComRef.AccountCode_Call_Status__c = 'Failure';
            solComRef.AccountCode__c = 'ACDIED-DF';
            solComRef.Failure_Date__c = date.today();
            solComRef.Failure_Measure__c='NONBB';
            solComRef.AccountCodeType__c='ASD-AS';

            insert solComRef;
			
            list<CSS_SRT__c>  repairsrtList = new list<CSS_SRT__c>();
            
            CSS_SRT__c  repairsrt = new CSS_SRT__c();
            repairsrt.Job_Order__c =jobRef.Id; 
            repairsrt.Assignment__c='PRIMARY';
            //repairsrt.SRT_ID__c = '009-99';
            repairsrt.isPerformed__c=true;
            repairsrt.Component_Id__c=solComRef.id;
            repairsrt.SRT_ID__c = '00-724-00';
            repairsrt.SRT_Access_Code__c = 'R';
            // repairsrt.CSS_Root_Cause_Failure__c = solComRef.id;
            repairsrt.isDuplicateRootCause__c =true;
            //insert repairsrt;
            repairsrtList.add(repairsrt);
            
            CSS_SRT__c  repairsrt1 = new CSS_SRT__c();
            repairsrt1.Job_Order__c =jobRef.Id; 
            repairsrt1.Assignment__c='ALTERNATIVE';
            //repairsrt.SRT_ID__c = '009-91';
            repairsrt1.isPerformed__c=true;
            repairsrt1.Component_Id__c=solComRef.id;
            repairsrt1.SRT_ID__c = '00-725-00';
            repairsrt1.SRT_Access_Code__c = 'R';
            // repairsrt.CSS_Root_Cause_Failure__c = solComRef.id;
            repairsrt1.isDuplicateRootCause__c =true;
            //insert repairsrt;
            repairsrtList.add(repairsrt1);
            
            CSS_SRT__c  repairsrt2 = new CSS_SRT__c();
            repairsrt2.Job_Order__c =jobRef.Id; 
            repairsrt2.Assignment__c='NOT CLAIMABLE';
            //repairsrt.SRT_ID__c = '009-92';
            repairsrt2.isPerformed__c=true;
            repairsrt2.Component_Id__c=solComRef.id;
            repairsrt2.SRT_ID__c = '00-726-00';
            repairsrt2.SRT_Access_Code__c = 'R';
            // repairsrt.CSS_Root_Cause_Failure__c = solComRef.id;
            repairsrt2.isDuplicateRootCause__c =true;
            //insert repairsrt;
            repairsrtList.add(repairsrt2);
            
            CSS_SRT__c  repairsrt3 = new CSS_SRT__c();
            repairsrt3.Job_Order__c =jobRef.Id; 
            repairsrt3.Assignment__c='PRIMARY';
            //repairsrt.SRT_ID__c = '009-99';
            repairsrt3.isPerformed__c=true;
            repairsrt3.Component_Id__c=solComRef.id;
            repairsrt3.SRT_ID__c = '00-724-00';
            repairsrt3.SRT_Access_Code__c = 'A';
            // repairsrt.CSS_Root_Cause_Failure__c = solComRef.id;
            repairsrt3.isDuplicateRootCause__c =true;
            //insert repairsrt;
            repairsrtList.add(repairsrt3);
            
            CSS_SRT__c  repairsrt4 = new CSS_SRT__c();
            repairsrt4.Job_Order__c =jobRef.Id; 
            repairsrt4.Assignment__c='ALTERNATIVE';
            //repairsrt.SRT_ID__c = '009-99';
            repairsrt4.isPerformed__c=true;
            repairsrt4.Component_Id__c=solComRef.id;
            repairsrt4.SRT_ID__c = '00-824-00';
            repairsrt4.SRT_Access_Code__c = 'A';
            // repairsrt.CSS_Root_Cause_Failure__c = solComRef.id;
            repairsrt4.isDuplicateRootCause__c =true;
            //insert repairsrt;
            repairsrtList.add(repairsrt4);
            
            CSS_SRT__c  repairsrt5 = new CSS_SRT__c();
            repairsrt5.Job_Order__c =jobRef.Id; 
            repairsrt5.Assignment__c='ALTERNATIVE';
            //repairsrt.SRT_ID__c = '009-99';
            repairsrt5.isPerformed__c=true;
            repairsrt5.Component_Id__c=solComRef.id;
            repairsrt5.SRT_ID__c = '00-824-00';
            repairsrt5.SRT_Access_Code__c = 'R';
            // repairsrt.CSS_Root_Cause_Failure__c = solComRef.id;
            repairsrt5.isDuplicateRootCause__c =true;
            //insert repairsrt;
            repairsrtList.add(repairsrt5);
            
            CSS_SRT__c  repairsrt6 = new CSS_SRT__c();
            repairsrt6.Job_Order__c =jobRef.Id; 
            repairsrt6.Assignment__c='PROGRESSIVE DAMAGE';
            //repairsrt.SRT_ID__c = '009-99';
            repairsrt6.isPerformed__c=true;
            repairsrt6.Component_Id__c=solComRef.id;
            repairsrt6.SRT_ID__c = '00-924-00';
            repairsrt6.SRT_Access_Code__c = 'A';
            // repairsrt.CSS_Root_Cause_Failure__c = solComRef.id;
            repairsrt6.isDuplicateRootCause__c =true;
            //insert repairsrt;
            repairsrtList.add(repairsrt6);
            
            CSS_SRT__c  repairsrt7 = new CSS_SRT__c();
            repairsrt7.Job_Order__c =jobRef.Id; 
            repairsrt7.Assignment__c='PROGRESSIVE DAMAGE';
            //repairsrt.SRT_ID__c = '009-99';
            repairsrt7.isPerformed__c=true;
            repairsrt7.Component_Id__c=solComRef.id;
            repairsrt7.SRT_ID__c = '00-924-00';
            repairsrt7.SRT_Access_Code__c = 'R';
            // repairsrt.CSS_Root_Cause_Failure__c = solComRef.id;
            repairsrt7.isDuplicateRootCause__c =true;
            //insert repairsrt;
            repairsrtList.add(repairsrt7);
            
            CSS_SRT__c  repairsrt8 = new CSS_SRT__c();
            repairsrt8.Job_Order__c =jobRef.Id; 
            repairsrt8.Assignment__c='PRIMARY';
            //repairsrt.SRT_ID__c = '009-91';
            repairsrt8.isPerformed__c=true;
            repairsrt8.Component_Id__c=solComRef.id;
            repairsrt8.SRT_ID__c = '00-125-00';
            repairsrt8.SRT_Access_Code__c = 'R';
            // repairsrt.CSS_Root_Cause_Failure__c = solComRef.id;
            repairsrt8.isDuplicateRootCause__c =true;
            //insert repairsrt;
            repairsrtList.add(repairsrt8);

            CSS_JobEventTemporary__c JETsys = new CSS_JobEventTemporary__c();
            JETsys.Attribute1__c = 'TH';
            JETsys.Attribute4__c ='TS';
            JETsys.key__c = 'FailCodes';
            JETsys.Attribute3__c = 'TURBO';
            JETsys.Attribute5__c = 'ASSEMBLY';
            insert JETsys;
            CSS_JobEventTemporary__c JETsys3 = new CSS_JobEventTemporary__c();
            JETsys3.Attribute1__c = 'TH';
            JETsys3.Attribute4__c ='TS';
            JETsys3.key__c = 'FailModes';
            JETsys3.Attribute3__c = 'TURBO';
            JETsys3.Attribute5__c = 'ASSEMBLY';
            insert JETsys3;
            CSS_JobEventTemporary__c JETsys2 = new CSS_JobEventTemporary__c();
            JETsys2.Attribute1__c = 'TH';
            JETsys2.Attribute4__c ='TS';
            JETsys2.key__c = 'CDSFaultCodes';
            JETsys2.Attribute3__c = 'TURBO';
            JETsys2.Attribute5__c = 'ASSEMBLY';
            insert JETsys2;

            CSS_JobEventTemporary__c JETsys1 = new CSS_JobEventTemporary__c();
            JETsys1.Attribute1__c = 'ISX12 CM2350 X102';
            JETsys1.Attribute2__c ='OK';
            JETsys1.key__c = 'GetFailureCodesSRT';
            JETsys1.Attribute3__c = 'ISX12 CM2350 X102;;0K';
            JETsys1.Attribute5__c = 'ASSEMBLY';
            JETsys1.Reason__c = '{\r\n\t\"Header\": {\r\n\t\t\"ReturnCodeDescription\": \"Normal, Successful completion.\",\r\n\t\t\"ReturnCode\": \"ORA-00000\",\r\n\t\t\"MessageIdentifier\": \"S\"\r\n\t},\r\n\t\"DataArea\": [{\r\n\t\t\"SystemCode\": \"WF\",\r\n\t\t\"FailureName\": \"ATC 1795\",\r\n\t\t\"FailureMode\": \"SP\",\r\n\t\t\"FailureID\": \"F30003750\",\r\n\t\t\"ComponentCode\": \"HA\"\r\n\t}]\r\n}';
            insert JETsys1;
            List<String> ss=new List<String>();
            ss.add('Test');
            CSS_WPR_JobPlanOverview wpr = new CSS_WPR_JobPlanOverview();
            wpr.Name = 'ABC';
            List<string> relatedName = new List<string>();
            string relName = 'BCD';
            relatedName.add(relName);
            string relName2 = 'PQRST';
            relatedName.add(relName);
            wpr.relatedName = relatedName;
            wpr.diagTime = 'ABC';
            wpr.repTime = 'bcd';
            wpr.failcode = '123';
            wpr.allCompCountForFC = 12;
            wpr.partsList = relatedName;

            //List<solWrapper> solwrap1 = new List<solWrapper>();        
            CSS_WPR_JobPlanOverview.solWrapper solwrap1 = new CSS_WPR_JobPlanOverview.solWrapper();
            solwrap1.solNumber = '4455';
            solwrap1.solTitle = 'title11';
            solwrap1.solResponse = 'response1';
            solwrap1.outOfOrder = true;
            solwrap1.allCompCountForSol = 23;
            List<CSS_WPR_JobPlanOverview.solWrapper> sList = new list<CSS_WPR_JobPlanOverview.solWrapper>();
            sList.add(solwrap1);
            wpr.solList = sList;
            CSS_WPR_JobPlanOverview.solCompWrapper solwrap2 = new CSS_WPR_JobPlanOverview.solCompWrapper();
            solwrap2.compName = '4455';
            solwrap2.failcodelist = 'title11';
            solwrap2.failcodeEditable = 'response1';
            solwrap2.selectedcomp = true;
            Solwrap2.failmodedesc = '123';
            Solwrap2.compId = solComRef.id;
            List<CSS_WPR_JobPlanOverview.solCompWrapper> sCompList = new list<CSS_WPR_JobPlanOverview.solCompWrapper>();
            sCompList.add(Solwrap2);
            solwrap1.solCompWrap = sCompList;
            List<CSS_WPR_JobPlanOverview> lst = new List<CSS_WPR_JobPlanOverview>();
            lst.add(wpr);
            Test.setMock(HttpCalloutMock.class, new CSS_SRTCompMockup_Test());
            CSS_JobPlanOverviewControllerNew JobPlanOverCont = new CSS_JobPlanOverviewControllerNew();
            //JobPlanOverCont.callUnitInboundGeneric();
            JobPlanOverCont.callUpdateUnitandWo();
            JobPlanOverCont.getPayCodes(ss);
            JobPlanOverCont.changeFailures_New();
            JobPlanOverCont.jobplan_jo();
            //JobPlanOverCont.jobplan_prt();
            //    JobPlanOverCont.jobplan_war();
            JobPlanOverCont.partsListWrap =lst;
            JobPlanOverCont.jobplan_narr();
            JobPlanOverCont.showPopup();
            JobPlanOverCont.closePopup();
            JobPlanOverCont.redirectPopup();
            JobPlanOverCont.getAccountCodes1();
            JobPlanOverCont.closeSession_close();
            JobPlanOverCont.jobPlanAction();
            PageReference pref1;
            pref1 = new PageReference('/'+jobRef.id);
            pref1.getParameters().put('id',jobRef.id);
            Test.setCurrentPage(pref1);
            //JobPlanOverCont.pgSaveFinish();
            //JobPlanOverCont.getFaultCodes();
            // JobPlanOverCont.createQuoteRecord('7987989');
            try
            {   
                JobPlanOverCont.SendFailurestoERP();
            }
            Catch(Exception e){}

            try
            {   
                JobPlanOverCont.createQuoteRecord('7987989');  
            }
            Catch(Exception e){}
            JobPlanOverCont.partsListWrap = lst;
            //JobPlanOverCont.clearpopup();
            //JobPlanOverCont.cancelPopup();
            JobPlanOverCont.ReDuplicationLogic(repairsrtList);
            JobPlanOverCont.onChangeofAppCode();
            JobPlanOverCont.getfailurenames();
            JobPlanOverCont.getFailModes();
            JobPlanOverCont.getComponentCodes();
            JobPlanOverCont.getSystemCodes();
            //JobPlanOverCont.callUnitInboundGeneric();
            JobPlanOverCont.callUpdateUnitandWo();
            // JobPlanOverCont.jobplan_jo();
            //JobPlanOverCont.jobplan_war();
            // JobPlanOverCont.jobplan_narr();
            JobPlanOverCont.showPopup();
            JobPlanOverCont.closePopup();
            JobPlanOverCont.redirectPopup();
            JobPlanOverCont.getAccountCodes1();
            JobPlanOverCont.closeSession_close();
            //JobPlanOverCont.pgSaveFinish();

            JobPlanOverCont.CompareDates();
            CSS_Solution_Component__c solcomp = new CSS_Solution_Component__c();
            insert solcomp;
            JobPlanOverCont.compont = solcomp;
            JobPlanOverCont.failureDate = date.today();
            JobPlanOverCont.failureDate1 = date.today();
            JobPlanOverCont.warrantyDate = date.today() +2;
            JobPlanOverCont.CompareDates();
            JobPlanOverCont.getfailurenames();
            JobPlanOverCont.jobplan_jpq();
            //JobPlanOverCont.jobplan_srt();
            //JobPlanOverCont.onAddClick();

            // JobPlanOverCont.checkCoverageNew();
            JobPlanOverCont.failureMeasure='Hours';
            JobPlanOverCont.coverageType = 'POL';
            JobPlanOverCont.Validations();
            JobPlanOverCont.coverageType = 'NPW';
            JobPlanOverCont.coverageFound = 'false';
            JobPlanOverCont.accCodeSelected = '52';
            JobPlanOverCont.selectedFailMode = 'THAS';
            JobPlanOverCont.chkClickonPartsCoverage = false;
		    set<string> setBlankFieldset = new set<string>();
            setBlankFieldset.add('false');
		    //JobPlanOverCont.tempblankfieldset = setBlankFieldset;
            JobPlanOverCont.Validations();
            JobPlanOverCont.pgSave();
            JobPlanOverCont.saveCheckBox();
            JobPlanOverCont.getAccountCodes();
            JobPlanOverCont.mainSOQL();
            JobPlanOverCont.compont.AccountCodeEdit__c = null ;
            JobPlanOverCont.onAddClick();
            JobPlanOverCont.compont.Failure_Measure__c = 'Miles' ;
            JobPlanOverCont.onAddClick();
            JobPlanOverCont.selectedFName = 'unlisted';
            test.stopTest();
        }
    }
    public static testMethod void TestMethod6()
    {
        //This function is writtten to call lines that are not being covered in any testmethods
        UserRole empRole = [Select Id From UserRole Where Name = 'Factory' Limit 1];
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'kal1', Email='standarduser11@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='kal12', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='kal11111@testorg.com', user_Location__c = '56270-56255',UserRoleId = empRole.id);
        insert(u);
        System.runAs(u) 
        {  
            //Creating Job--1
            CSS_Job_Order__c jobRef = CSS_TestData.createJobOrder(false);
            jobRef.chevron_page__c='jo';
            jobRef.BMSWSStatus__c = 'UI';
            jobRef.ESN__c ='123';
            jobRef.Service_Model__c ='X15 CM2350 X114B';
            jobRef.Qsol_Engine_Family_Code__c ='10';
            String json = '{'+
                '   \"Header\":    {'+
                '      \"ReturnCodeDescription\": \"\",'+
                '      \"Status\": \"Success\"'+
                '   },'+
                '   \"BasicCoverageResponseHeader\": {\"Response\":    {'+
                '      \"ListOfCoverageDetails\": {\"CoverageDetails\":       ['+
                '                  {'+
                '            \"ListOfCoverageComponentList\": {\"CoverageComponentList\":             ['+
                '                              {'+
                '                  \"MegawattHours\": \"1000\",'+
                '                  \"CoverageMaxMonths\": \"30\",'+
                '                  \"CoverageComponentTypeCode\": \"EMISSIONS-CA\",'+
                '                  \"CoverageMinMonths\": \"20\",'+
                '                  \"CoverageHours\": \"100\",'+
                '                  \"CoverageDefenitionType\": \"BASE\",'+
                '                  \"CoverageMiles\": \"10\"'+
                '               },'+
                '                              {'+
                '                  \"MegawattHours\": \"123\",'+
                '                  \"CoverageMaxMonths\": \"234\",'+
                '                  \"CoverageComponentTypeCode\": \"BELTS/HOSES\",'+
                '                  \"CoverageMinMonths\": \"56\",'+
                '                  \"CoverageHours\": \"123\",'+
                '                  \"CoverageDefenitionType\": \"BASE\",'+
                '                  \"CoverageMiles\": \"123\"'+
                '               }'+
                '            ]},'+
                '            \"WarrantyManualURL\": \"www.test.com/ems\",'+
                '            \"CoverageType\": \"EMS-Emissions Warranty\",'+
                '            \"ListOfCoverageDedutibles\": {\"CoverageDedutibles\": []},'+
                '            \"ProcedureNumber\": \"ProcEMS\"'+
                '         },'+
                '                  {'+
                '            \"ListOfCoverageComponentList\": {\"CoverageComponentList\":             ['+
                '                              {'+
                '                  \"MegawattHours\": \"0\",'+
                '                  \"CoverageMaxMonths\": \"120\",'+
                '                  \"CoverageComponentTypeCode\": \"EMISSIONS-CA\",'+
                '                  \"CoverageMinMonths\": \"0\",'+
                '                  \"CoverageHours\": \"100000\",'+
                '                  \"CoverageDefenitionType\": \"BASE\",'+
                '                  \"CoverageMiles\": \"100000\"'+
                '               },'+
                '                              {'+
                '                  \"MegawattHours\": \"0\",'+
                '                  \"CoverageMaxMonths\": \"60\",'+
                '                  \"CoverageComponentTypeCode\": \"EMISSIONS\",'+
                '                  \"CoverageMinMonths\": \"0\",'+
                '                  \"CoverageHours\": \"0\",'+
                '                  \"CoverageDefenitionType\": \"BASE\",'+
                '                  \"CoverageMiles\": \"100000\"'+
                '               }'+
                '            ]},'+
                '            \"WarrantyManualURL\": \"\",'+
                '            \"CoverageType\": \"NEW-New Engine Warranty\",'+
                '            \"ListOfCoverageDedutibles\": {\"CoverageDedutibles\": []},'+
                '            \"ProcedureNumber\": \"\"'+
                '         }'+
                '      ]},'+
                '      \"ListOfExtendedCoverageDetails\": {\"ExtendedCoverageDetails\":       ['+
                '                  {'+
                '            \"ListOfExtCoverageDedutibles\": {\"ExtendedCoverageDedutibles\": []},'+
                '            \"WarrantyManualURL\": \"\",'+
                '            \"BeginMiles\": \"0\",'+
                '            \"EndMiles\": \"500000\",'+
                '            \"ProcedureNumber\": \"\",'+
                '            \"CertificateNumber\": \"TP41000811\",'+
                '            \"ProgramID\": \"TP4\",'+
                '            \"BeginHours\": \"0\",'+
                '            \"EndHours\": \"0\",'+
                '            \"EndDate\": \"09/21/2015\",'+
                '            \"StartDate\": \"09/21/2010\",'+
                '            \"Months\": \"60\",'+
                '            \"CAPCoverageID\": \"CRT\"'+
                '         },'+
                '                  {'+
                '            \"ListOfExtCoverageDedutibles\": {\"ExtendedCoverageDedutibles\": []},'+
                '            \"WarrantyManualURL\": \"\",'+
                '            \"BeginMiles\": \"0\",'+
                '            \"EndMiles\": \"300000\",'+
                '            \"ProcedureNumber\": \"\",'+
                '            \"CertificateNumber\": \"TP41000811\",'+
                '            \"ProgramID\": \"TP4\",'+
                '            \"BeginHours\": \"0\",'+
                '            \"EndHours\": \"0\",'+
                '            \"EndDate\": \"09/21/2013\",'+
                '            \"StartDate\": \"09/21/2010\",'+
                '            \"Months\": \"36\",'+
                '            \"CAPCoverageID\": \"APT\"'+
                '         }'+
                '      ]}'+
                '   }}'+
                '}';
            jobref.CoverageResponse__c = json;
            jobRef.Failure_Date__c = System.today();
            insert jobRef;
            PageReference pref;
            pref = new PageReference('/'+jobRef.id);
            pref.getParameters().put('id',jobRef.id);
            Test.setCurrentPage(pref);

            //Creating Fault code
            CSS_Fault_Code__c fauCodRef = new CSS_Fault_Code__c();
            fauCodRef.Job_Order__c =jobRef.Id; 
            fauCodRef.Sequence__c=1;
            fauCodRef.Fault_Code_Type__c='BPD'; 
            fauCodRef.Primary_Fault_Code__c=3539; 
            fauCodRef.Status__c='A';
            insert fauCodRef;
            List<CSS_Fault_Code__c> fauCodRefList = new List<CSS_Fault_Code__c>();
            fauCodRefList.add(fauCodRef);

            //Creating Soltions--3
            CSS_Solutions__c solRef =  CSS_TestData.createSolutions(true,jobRef.Id);
            solRef.FaultCode__c = fauCodRef.id;
            update solRef;

            list<CSS_Solution_Component__c> solcomreflist =new list<CSS_Solution_Component__c>();

            //Creating Solution Component--4
            //for(integer i=0;i<5;i++)
            //{
            CSS_Solution_Component__c solComRef = CSS_TestData.createSRT(false,jobRef.Id,solRef.Id);
            solComRef.System_Code__c = 'Test';
            solComRef.Component_Code__c = 'Test';
            solComRef.Failure_Mode__c = 'Test';
            solComRef.Solutions__c =solRef.id;
            solComRef.AccountCodeType__c = 'Test-Test';
            solComRef.AccountCode_Call_Status__c = 'Failure';
            solComRef.Parts_Warranty__c = 'New Parts Warranty';
            solComRef.Customer_Take_Possession__c = 'Yes';
            solComRef.Failure_Point__c=11.0;
            solComRef.Failure_Date__c=date.parse('12/27/2014');
            solComRef.AccountCode__c = 'fsdff';
            solComRef.AccountCodeEdit__c =null;
            solcomRef.Selected_Component__c =true;
            solcomRef.Type__c = 'CAMPAIGN';
            solcomRef.Service_Job__c = jobRef.id;
            System.debug('The Solution Component Object' +solComRef);
            insert solComRef;
            system.debug('CSS ACCOUNT CODE FORMULA: '+solComRef.CSS_Account_Formula__c);
            solcomreflist.add(solComRef);
            upsert solcomreflist;//By Rupesh

            CSS_Parts_Options__c parts = new CSS_Parts_Options__c();
            parts.Option_Number__c = 'O-111';
            parts.Service_Job__c = jobRef.Id;
            parts.selected_part__c = true;
            parts.FailurepartId__c = solComRef.Id;
            parts.Part_Assignment__c = 'Primary';
            insert parts;

            boolean accCodeExist=false;
            //Populating Account codes
            List<SelectOption> accCodes = new List<SelectOption>();
            accCodes.add(new SelectOption('Test1','Test1'));
            accCodes.add(new SelectOption('Test2','Test2'));
            accCodes.add(new SelectOption('Test3','Test3'));
            accCodes.add(new SelectOption('Test4','Test4'));

            CSS_JobPlanOverviewControllerNew obj1=new CSS_JobPlanOverviewControllerNew();
            obj1.accCodeEditable='Test';
            obj1.componentId = String.valueOf(solcomreflist[0].id);
            obj1.failureDate = System.today();
            obj1.failureDate1 = System.today();
            obj1.warrantyDate = System.today();
            obj1.partsWarrDt = system.today();
            obj1.warrStDtHidden = 'Testing';
            obj1.accCodeSelected = 'EMISSION WARRANTY 62';
            obj1.selectedFaultCode = null;
            obj1.selectedFaultCode = '';

            obj1.comm = 'Testing';
            //obj1.compont.Failure_Date__c = null; 


            obj1.Wid = null;
            //obj1.CompareDates();
            obj1.Cancel();

            //select Attribute1__c, Attribute3__c from CSS_JobEventTemporary__c where key__c='FailModes'
            list<CSS_JobEventTemporary__c> jetl =new list<CSS_JobEventTemporary__c>();

            CSS_JobEventTemporary__c jet=new CSS_JobEventTemporary__c();
            jet.key__c='FailModes';
            jet.Name='Test';
            insert jet;
            jetl.add(jet);
            upsert jetl;

            //  obj1.loadPopup();

            obj1.jobplan_jpq();
            //    obj1.jobplan_srt();
            obj1.onAddClick();
            // obj1.checkCoverageNew();
            obj1.accCodeSelected = 'EMISSION WARRANTY 62';
            obj1.failureMeasure='Hours';
            obj1.coverageType = 'POL';
            obj1.Validations();
            obj1.coverageType = 'NPW';
            obj1.coverageFound = 'false';
            obj1.accCodeSelected = '52';
            obj1.selectedFailMode = 'THAS';
            obj1.chkClickonPartsCoverage = false;
            set<string> setBlankFieldset = new set<string>();
            setBlankFieldset.add('false');
		    //obj1.tempblankfieldset = setBlankFieldset;
            obj1.Validations();
            obj1.pgSave();
            obj1.saveCheckBox();
            obj1.getAccountCodes();
            obj1.mainSOQL();
            //obj1.retry();
            obj1.getPayCodesonAccCodeChange();
            //obj1.getPayCodesonAccCodeChangeOnLoad();


            //  }

            Test.setMock(HttpCalloutMock.class, new CSS_SRTCompMockup_Test());
            Test.startTest();
            CSS_JobPlanOverviewControllerNew JobPlanOverCont = new CSS_JobPlanOverviewControllerNew();
            //CSS_Solution_Component__c solComm=[select id from css_solution_component__c limit 1];
            // system.debug('solution Component value'+solComm);
            //JobPlanOverCont.componentId = 'solComRef.Id';
            JobPlanOverCont.failCodeSelected = 'Engine Control Module Calibration-EQPE';
            JobPlanOverCont.accCodeSelected = 'PARTS WARRANTY 35';
            JobPlanOverCont.failCodeEditable='Engine Control Module Calibration-EQPE';
            //JobPlanOverCont.allFaultCodes = fauCodRefList;

            //JobPlanOverCont.mainSOQL();
            JobPlanOverCont.failCodeChangeGO();
            //JobPlanOverCont.retry();
            Test.setMock(HttpCalloutMock.class, new CSS_MockHttpResponseGenerator()); 
            JobPlanOverCont.callCreateWoqtInbound('Test+Rupesh');
            //JobPlanOverCont.onAddClick();//Moved Here and it gives no error
            JobPlanOverCont.partssave();
            JobPlanOverCont.clearPopup();
            JobPlanOverCont.onChangeofAppCode();

            JobPlanOverCont.selectedFName= 'unlisted';

            list<CSS_JobEventTemporary__c> jetlist=new list<CSS_JobEventTemporary__c>();
            //css_testdata.createJobEventTempObj(true);
            CSS_JobEventTemporary__c x=new CSS_JobEventTemporary__c();
            x.key__c='FailCodes';
            x.Attribute3__c='X15 CM2350 X114B;;10';
            insert x;
            jetlist.add(x);
            upsert jetlist;
            system.debug('*************JETLIST*******************: '+jetlist);

            //css_testdata.createJobEventTempObj(true);
            CSS_JobEventTemporary__c jer =new CSS_JobEventTemporary__c();
            jer.key__c='getFailureCodesSRT';
            jer.Attribute3__c='X15 CM2350 X114B;;10';
            jer.Reason__c = '{"Header":{"ReturnCodeDescription":"Normal, Successful completion.","ReturnCode":"ORA-00000","MessageIdentifier":"S"},"DataArea":[{"SystemCode":"EY","FailureName":"Accelerator Pedal or Lever Position Sensor","FailureMode":"","FailureID":"F19000010","ComponentCode":"PB"},{"SystemCode":"US","FailureName":"Aftertreatment DEF Controller Calibration","FailureMode":"","FailureID":"F19000030","ComponentCode":"EQ"},{"SystemCode":"US","FailureName":"Aftertreatment DEF Dosing Unit","FailureMode":"","FailureID":"F11000030","ComponentCode":"DU"},{"SystemCode":"US","FailureName":"Aftertreatment DEF Dosing Unit Filter","FailureMode":"","FailureID":"F11000060","ComponentCode":"UF"},{"SystemCode":"US","FailureName":"Aftertreatment DEF Dosing Valve","FailureMode":"","FailureID":"F11000020","ComponentCode":"DV"},{"SystemCode":"US","FailureName":"Aftertreatment DEF Dosing Valve Mounting Gasket","FailureMode":"","FailureID":"F30001100","ComponentCode":"GK"},{"SystemCode":"XX","FailureName":"Aftertreatment DEF Line","FailureMode":"","FailureID":"F11000040","ComponentCode":"OE"},{"SystemCode":"XX","FailureName":"Aftertreatment DEF Line Heater","FailureMode":"","FailureID":"F11000100","ComponentCode":"OE"},{"SystemCode":"UD","FailureName":"Aftertreatment DEF Nozzle","FailureMode":"","FailureID":"F30000480","ComponentCode":"NZ"},{"SystemCode":"US","FailureName":"Aftertreatment DEF Tank Filter","FailureMode":"","FailureID":"F11000050","ComponentCode":"FF"},{"SystemCode":"XX","FailureName":"Aftertreatment DEF Tank Heater Control Valve","FailureMode":"","FailureID":"F11000065","ComponentCode":"OE"},{"SystemCode":"XX","FailureName":"Aftertreatment DEF Tank Level Sensor","FailureMode":"","FailureID":"F19000070","ComponentCode":"OE"},{"SystemCode":"XX","FailureName":"Aftertreatment DEF Tank Temperature Sensor","FailureMode":"","FailureID":"F19000080","ComponentCode":"OE"},{"SystemCode":"NY","FailureName":"Aftertreatment DOC","FailureMode":"","FailureID":"F11000080","ComponentCode":"CY"},{"SystemCode":"ET","FailureName":"Aftertreatment DOC Intake Temperature Sensor","FailureMode":"IN","FailureID":"F19000090","ComponentCode":"CT"},{"SystemCode":"EU","FailureName":"Aftertreatment DOC Intake Temperature Sensor Module","FailureMode":"","FailureID":"F19000130","ComponentCode":"PF"},{"SystemCode":"NY","FailureName":"Aftertreatment DPF","FailureMode":"","FailureID":"F11000090","ComponentCode":"PF"},{"SystemCode":"EA","FailureName":"Aftertreatment DPF Differential Pressure Sensor","FailureMode":"","FailureID":"F19000140","ComponentCode":"DF"},{"SystemCode":"NY","FailureName":"Aftertreatment DPF Differential Pressure Sensor Tubes","FailureMode":"","FailureID":"F11000110","ComponentCode":"PN"},{"SystemCode":"ET","FailureName":"Aftertreatment DPF Intake Temperature Sensor","FailureMode":"MI","FailureID":"F19000100","ComponentCode":"CT"},{"SystemCode":"ET","FailureName":"Aftertreatment DPF Outlet Temperature Sensor","FailureMode":"OT","FailureID":"F19000110","ComponentCode":"CT"},{"SystemCode":"HY","FailureName":"Aftertreatment DPF Temperature Sensor Module","FailureMode":"","FailureID":"F11000120","ComponentCode":"DV"},{"SystemCode":"US","FailureName":"Aftertreatment Decomposition Tube","FailureMode":"","FailureID":"F11000000","ComponentCode":"DT"},{"SystemCode":"NY","FailureName":"Aftertreatment Device Gasket","FailureMode":"","FailureID":"F30002610","ComponentCode":"GK"},{"SystemCode":"XX","FailureName":"Aftertreatment Diesel Exhaust Fluid  Line Heater","FailureMode":"","FailureID":"F19000050","ComponentCode":"OE"},{"SystemCode":"ET","FailureName":"Aftertreatment Exhaust Gas Temperature Sensor","FailureMode":"","FailureID":"F19000150","ComponentCode":"CT"},{"SystemCode":"YN","FailureName":"Aftertreatment Intake NOx Sensor","FailureMode":"IN","FailureID":"F19000170","ComponentCode":"EB"},{"SystemCode":"EU","FailureName":"Aftertreatment Interface Harness","FailureMode":"","FailureID":"F11000170","ComponentCode":"WX"},{"SystemCode":"EU","FailureName":"Aftertreatment OEM Wiring Harness","FailureMode":"X1","FailureID":"F19000190","ComponentCode":"WH"},{"SystemCode":"YN","FailureName":"Aftertreatment Outlet NOx Sensor","FailureMode":"OT","FailureID":"F19000200","ComponentCode":"EB"},{"SystemCode":"EA","FailureName":"Aftertreatment Outlet Pressure Sensor","FailureMode":"","FailureID":"F19000210","ComponentCode":"DF"},{"SystemCode":"YN","FailureName":"Aftertreatment Particulate Sensor","FailureMode":"","FailureID":"F19000215","ComponentCode":"SM"},{"SystemCode":"US","FailureName":"Aftertreatment SCR Catalyst","FailureMode":"","FailureID":"F11000200","ComponentCode":"SC"},{"SystemCode":"EU","FailureName":"Aftertreatment SCR Catalyst Temperature Sensor Module","FailureMode":"","FailureID":"F19000220","ComponentCode":"SC"},{"SystemCode":"YN","FailureName":"Aftertreatment SCR Intermediate NH3 Sensor Module","FailureMode":"","FailureID":"F19000250","ComponentCode":"AM"},{"SystemCode":"YN","FailureName":"Aftertreatment SCR Intermediate NH3 Sensor Probe","FailureMode":"","FailureID":"F19000260","ComponentCode":"AP"},{"SystemCode":"NY","FailureName":"Aftertreatment System Clamp","FailureMode":"","FailureID":"F30003590","ComponentCode":"CP"},{"SystemCode":"QC","FailureName":"Air Compressor","FailureMode":"","FailureID":"F12000000","ComponentCode":"AS"},{"SystemCode":"QI","FailureName":"Air Compressor Air Line O-Ring Seal","FailureMode":"","FailureID":"F30002840","ComponentCode":"OR"},{"SystemCode":"KC","FailureName":"Air Compressor Coolant Return Line","FailureMode":"","FailureID":"F30000220","ComponentCode":"CT"},{"SystemCode":"QC","FailureName":"Air Compressor Cylinder Head","FailureMode":"","FailureID":"F12000010","ComponentCode":"CH"},{"SystemCode":"QC","FailureName":"Air Compressor Cylinder Head Gasket","FailureMode":"","FailureID":"F12000020","ComponentCode":"GK"},{"SystemCode":"QI","FailureName":"Air Compressor Inlet Hose","FailureMode":"","FailureID":"F12000030","ComponentCode":"TH"},{"SystemCode":"QC","FailureName":"Air Compressor Mounting Hardware","FailureMode":"","FailureID":"F30002860","ComponentCode":"MH"},{"SystemCode":"SD","FailureName":"Air Filter","FailureMode":"","FailureID":"F10000010","ComponentCode":"EL"},{"SystemCode":"IN","FailureName":"Air Intake Connection","FailureMode":"","FailureID":"F10000015","ComponentCode":"CO"},{"SystemCode":"IN","FailureName":"Air Intake Pipe O-Ring Seal","FailureMode":"","FailureID":"F30000890","ComponentCode":"OR"},{"SystemCode":"EA","FailureName":"Ambient Air Temperature Sensor","FailureMode":"","FailureID":"F19000300","ComponentCode":"CD"},{"SystemCode":"NW","FailureName":"Auxiliary Water Pump","FailureMode":"","FailureID":"F30000510","ComponentCode":"WP"},{"SystemCode":"EA","FailureName":"Barometric Pressure Sensor","FailureMode":"","FailureID":"F19000310","ComponentCode":"CB"},{"SystemCode":"BC","FailureName":"Camshaft","FailureMode":"","FailureID":"F01000000","ComponentCode":"CM"},{"SystemCode":"BC","FailureName":"Camshaft Gear","FailureMode":"","FailureID":"F01000010","ComponentCode":"GR"},{"SystemCode":"BC","FailureName":"Camshaft Indicator Ring","FailureMode":"","FailureID":"F01000020","ComponentCode":"TW"},{"SystemCode":"EL","FailureName":"Camshaft Position Sensor","FailureMode":"","FailureID":"F19000330","ComponentCode":"CB"},{"SystemCode":"XX","FailureName":"Charge Air Cooler","FailureMode":"","FailureID":"F10000020","ComponentCode":"OE"},{"SystemCode":"XX","FailureName":"Charge Air Cooler Plumbing","FailureMode":"","FailureID":"F10000030","ComponentCode":"OE"},{"SystemCode":"SB","FailureName":"Charging System Alternator","FailureMode":"","FailureID":"F13000000","ComponentCode":"AA"},{"SystemCode":"SB","FailureName":"Charging System Alternator Pulley","FailureMode":"","FailureID":"F13000010","ComponentCode":"DN"},{"SystemCode":"BN","FailureName":"Connecting Rod","FailureMode":"","FailureID":"F01000040","ComponentCode":"RF"},{"SystemCode":"BN","FailureName":"Connecting Rod Bearings","FailureMode":"","FailureID":"F01000030","ComponentCode":"RB"},{"SystemCode":"BN","FailureName":"Connecting Rod Capscrews","FailureMode":"","FailureID":"F30001090","ComponentCode":"BO"},{"SystemCode":"EU","FailureName":"Connector Pins","FailureMode":"","FailureID":"F30001070","ComponentCode":"PN"},{"SystemCode":"ED","FailureName":"Coolant Level Sensor","FailureMode":"","FailureID":"F19000380","ComponentCode":"CB"},{"SystemCode":"KC","FailureName":"Coolant Line Fitting","FailureMode":"","FailureID":"F30003580","ComponentCode":"FT"},{"SystemCode":"ET","FailureName":"Coolant Temperature Sensor","FailureMode":"","FailureID":"F19000590","ComponentCode":"CB"},{"SystemCode":"KT","FailureName":"Coolant Thermostat","FailureMode":"","FailureID":"F08000020","ComponentCode":"TS"},{"SystemCode":"KT","FailureName":"Coolant Thermostat Seal","FailureMode":"","FailureID":"F30001250","ComponentCode":"SE"},{"SystemCode":"XX","FailureName":"Cooling Fan","FailureMode":"","FailureID":"F08000040","ComponentCode":"OE"},{"SystemCode":"KH","FailureName":"Cooling Fan Belt","FailureMode":"","FailureID":"F08000050","ComponentCode":"BL"},{"SystemCode":"BB","FailureName":"Crankcase Breather Element","FailureMode":"","FailureID":"F03000010","ComponentCode":"EL"},{"SystemCode":"BB","FailureName":"Crankcase Breather Gasket","FailureMode":"","FailureID":"F30003010","ComponentCode":"GK"},{"SystemCode":"BB","FailureName":"Crankcase Breather Tube","FailureMode":"","FailureID":"F01000060","ComponentCode":"BT"},{"SystemCode":"EA","FailureName":"Crankcase Pressure Sensor","FailureMode":"","FailureID":"F19000410","ComponentCode":"CC"},{"SystemCode":"EA","FailureName":"Crankcase Pressure Sensor O-Ring Seal","FailureMode":"","FailureID":"F30003030","ComponentCode":"CO"},{"SystemCode":"BS","FailureName":"Crankshaft Speed Indicator Ring","FailureMode":"","FailureID":"F01000080","ComponentCode":"TW"},{"SystemCode":"EL","FailureName":"Crankshaft Speed/Position Sensor","FailureMode":"","FailureID":"F19000420","ComponentCode":"EB"},{"SystemCode":"BK","FailureName":"Cylinder Block","FailureMode":"","FailureID":"F01000090","ComponentCode":"CA"},{"SystemCode":"BK","FailureName":"Cylinder Block Cup Plug","FailureMode":"","FailureID":"F30000810","ComponentCode":"PL"},{"SystemCode":"CH","FailureName":"Cylinder Head","FailureMode":"","FailureID":"F02000010","ComponentCode":"CA"},{"SystemCode":"CH","FailureName":"Cylinder Head Cup Plug","FailureMode":"","FailureID":"F30000350","ComponentCode":"PL"},{"SystemCode":"CH","FailureName":"Cylinder Head Exhaust Valve","FailureMode":"","FailureID":"F02000040","ComponentCode":"EV"},{"SystemCode":"CH","FailureName":"Cylinder Head Gasket","FailureMode":"","FailureID":"F02000020","ComponentCode":"GK"},{"SystemCode":"CH","FailureName":"Cylinder Head Intake Valve","FailureMode":"","FailureID":"F02000070","ComponentCode":"IV"},{"SystemCode":"CH","FailureName":"Cylinder Head Valve Guide","FailureMode":"","FailureID":"F02000100","ComponentCode":"GV"},{"SystemCode":"CH","FailureName":"Cylinder Head Valve Spring","FailureMode":"","FailureID":"F02000110","ComponentCode":"VS"},{"SystemCode":"CH","FailureName":"Cylinder Head Valve Stem Seal","FailureMode":"","FailureID":"F02000120","ComponentCode":"SE"},{"SystemCode":"IR","FailureName":"EGR Cooler","FailureMode":"","FailureID":"F11000510","ComponentCode":"CL"},{"SystemCode":"IR","FailureName":"EGR Cooler Connection","FailureMode":"","FailureID":"F30002030","ComponentCode":"BL"},{"SystemCode":"KV","FailureName":"EGR Cooler Coolant Return Tube","FailureMode":"","FailureID":"F30000170","ComponentCode":"RT"},{"SystemCode":"KV","FailureName":"EGR Cooler Coolant Supply Tube","FailureMode":"","FailureID":"F30000180","ComponentCode":"ST"},{"SystemCode":"KV","FailureName":"EGR Cooler Coolant Vent Tube","FailureMode":"","FailureID":"F30002520","ComponentCode":"VL"},{"SystemCode":"KV","FailureName":"EGR Cooler Vent Adapter","FailureMode":"","FailureID":"F30003070","ComponentCode":"VA"},{"SystemCode":"IR","FailureName":"EGR Crossover Tube","FailureMode":"","FailureID":"F11000520","ComponentCode":"TC"},{"SystemCode":"EA","FailureName":"EGR Differential Pressure Sensor","FailureMode":"","FailureID":"F19000490","ComponentCode":"DB"},{"SystemCode":"IR","FailureName":"EGR Differential Pressure Sensor Tubes","FailureMode":"","FailureID":"F11000530","ComponentCode":"PN"},{"SystemCode":"ET","FailureName":"EGR Temperature Sensor","FailureMode":"","FailureID":"F19000510","ComponentCode":"EB"},{"SystemCode":"IR","FailureName":"EGR Valve","FailureMode":"","FailureID":"F11000560","ComponentCode":"VB"},{"SystemCode":"KV","FailureName":"EGR/VGT Coolant Line Sealing Washer","FailureMode":"","FailureID":"F30003080","ComponentCode":"SW"},{"SystemCode":"EU","FailureName":"Electrical Connector","FailureMode":"","FailureID":"F30001060","ComponentCode":"CN"},{"SystemCode":"EI","FailureName":"Engine Control Module","FailureMode":"","FailureID":"F19000530","ComponentCode":"CM"},{"SystemCode":"EQ","FailureName":"Engine Control Module Calibration","FailureMode":"","FailureID":"F19000540","ComponentCode":"PE"},{"SystemCode":"EQ","FailureName":"Engine Control Module Parameters","FailureMode":"","FailureID":"F19000550","ComponentCode":"PC"},{"SystemCode":"IN","FailureName":"Engine Intake Throttle Actuator","FailureMode":"","FailureID":"F10000100","ComponentCode":"TD"},{"SystemCode":"SM","FailureName":"Engine Mount","FailureMode":"","FailureID":"F17000030","ComponentCode":"RS"},{"SystemCode":"EL","FailureName":"Engine Speed Sensor","FailureMode":"","FailureID":"F19000640","ComponentCode":"EB"},{"SystemCode":"IN","FailureName":"Engine Throttle Plate Actuator","FailureMode":"","FailureID":"F19000650","ComponentCode":"TD"},{"SystemCode":"EU","FailureName":"Engine Wiring Harness","FailureMode":"","FailureID":"F19000660","ComponentCode":"WH"},{"SystemCode":"EA","FailureName":"Exhaust Gas Pressure Sensor","FailureMode":"","FailureID":"F19000670","ComponentCode":"EB"},{"SystemCode":"IR","FailureName":"Exhaust Gas Pressure Sensor Tube","FailureMode":"","FailureID":"F11000570","ComponentCode":"TB"},{"SystemCode":"IE","FailureName":"Exhaust Manifold","FailureMode":"","FailureID":"F11000580","ComponentCode":"EM"},{"SystemCode":"IE","FailureName":"Exhaust Manifold Gasket","FailureMode":"","FailureID":"F11000590","ComponentCode":"GK"},{"SystemCode":"IE","FailureName":"Exhaust Manifold Mounting Capscrews","FailureMode":"","FailureID":"F11000600","ComponentCode":"CS"},{"SystemCode":"IE","FailureName":"Exhaust Manifold Slip Joint Seal","FailureMode":"","FailureID":"F30001190","ComponentCode":"SJ"},{"SystemCode":"IE","FailureName":"Exhaust Outlet Connection","FailureMode":"","FailureID":"F30001310","ComponentCode":"EP"},{"SystemCode":"XX","FailureName":"Exhaust Plumbing","FailureMode":"","FailureID":"F11000605","ComponentCode":"OE"},{"SystemCode":"RA","FailureName":"Exhaust Rocker Lever","FailureMode":"","FailureID":"F03000040","ComponentCode":"LV"},{"SystemCode":"SG","FailureName":"Fan Clutch","FailureMode":"","FailureID":"F08000060","ComponentCode":"EM"},{"SystemCode":"XX","FailureName":"Fan Control Switch","FailureMode":"","FailureID":"F19000740","ComponentCode":"OE"},{"SystemCode":"KF","FailureName":"Fan Hub","FailureMode":"","FailureID":"F08000065","ComponentCode":"HU"},{"SystemCode":"KH","FailureName":"Fan Pulley","FailureMode":"","FailureID":"F30000950","ComponentCode":"PU"},{"SystemCode":"SN","FailureName":"Flexplate","FailureMode":"","FailureID":"F16000000","ComponentCode":"FB"},{"SystemCode":"SN","FailureName":"Flywheel","FailureMode":"","FailureID":"F16000010","ComponentCode":"FW"},{"SystemCode":"SN","FailureName":"Flywheel Housing","FailureMode":"","FailureID":"F16000020","ComponentCode":"HS"},{"SystemCode":"SN","FailureName":"Flywheel Housing Gasket","FailureMode":"","FailureID":"F30002130","ComponentCode":"GK"},{"SystemCode":"SN","FailureName":"Flywheel Ring Gear","FailureMode":"","FailureID":"F30000960","ComponentCode":"RG"},{"SystemCode":"BM","FailureName":"Front Crankshaft Seal","FailureMode":"","FailureID":"F01000120","ComponentCode":"SF"},{"SystemCode":"BG","FailureName":"Front Gear Cover","FailureMode":"","FailureID":"F01000140","ComponentCode":"GC"},{"SystemCode":"BG","FailureName":"Front Gear Cover Gasket","FailureMode":"","FailureID":"F01000150","ComponentCode":"GM"},{"SystemCode":"FL","FailureName":"Fuel Connector","FailureMode":"","FailureID":"F05000260","ComponentCode":"FC"},{"SystemCode":"FL","FailureName":"Fuel Drain Line","FailureMode":"","FailureID":"F05000030","ComponentCode":"DL"},{"SystemCode":"FL","FailureName":"Fuel Drain Line Check Valve","FailureMode":"","FailureID":"F05000040","ComponentCode":"DB"},{"SystemCode":"FI","FailureName":"Fuel Injector","FailureMode":"","FailureID":"F05000100","ComponentCode":"AS"},{"SystemCode":"FI","FailureName":"Fuel Injector O-Ring Seal","FailureMode":"","FailureID":"F05000110","ComponentCode":"RO"},{"SystemCode":"FL","FailureName":"Fuel Injector Supply Lines","FailureMode":"","FailureID":"F06000020","ComponentCode":"IS"},{"SystemCode":"PL","FailureName":"Fuel Lift Pump","FailureMode":"","FailureID":"F05000320","ComponentCode":"HN"},{"SystemCode":"FL","FailureName":"Fuel Line Sealing Washer","FailureMode":"","FailureID":"F30003140","ComponentCode":"SW"},{"SystemCode":"FL","FailureName":"Fuel Pressure Relief Valve","FailureMode":"","FailureID":"F05000130","ComponentCode":"CX"},{"SystemCode":"FH","FailureName":"Fuel Pump","FailureMode":"","FailureID":"F05000270","ComponentCode":"AS"},{"SystemCode":"FH","FailureName":"Fuel Pump Actuator","FailureMode":"","FailureID":"F05000160","ComponentCode":"AV"},{"SystemCode":"FH","FailureName":"Fuel Pump Gear Pump","FailureMode":"","FailureID":"F05000070","ComponentCode":"PM"},{"SystemCode":"FL","FailureName":"Fuel Rail Fuel Supply Line","FailureMode":"","FailureID":"F30003200","ComponentCode":"RS"},{"SystemCode":"FL","FailureName":"Fuel Rails","FailureMode":"","FailureID":"F05000230","ComponentCode":"FR"},{"SystemCode":"FS","FailureName":"Fuel Shutoff Valve","FailureMode":"","FailureID":"F05000240","ComponentCode":"CO"},{"SystemCode":"FL","FailureName":"Fuel Supply Lines","FailureMode":"","FailureID":"F06000030","ComponentCode":"FS"},{"SystemCode":"EY","FailureName":"Idle Validation Switch","FailureMode":"","FailureID":"F19000960","ComponentCode":"PV"},{"SystemCode":"IH","FailureName":"Intake Air Heater","FailureMode":"","FailureID":"F10000060","ComponentCode":"GR"},{"SystemCode":"IN","FailureName":"Intake Manifold","FailureMode":"","FailureID":"F10000090","ComponentCode":"IM"},{"SystemCode":"IN","FailureName":"Intake Manifold Gasket","FailureMode":"","FailureID":"F30000700","ComponentCode":"GK"},{"SystemCode":"EA","FailureName":"Intake Manifold Pressure Sensor","FailureMode":"","FailureID":"F19000980","ComponentCode":"BB"},{"SystemCode":"EE","FailureName":"Intake Manifold Pressure/Temperature Sensor","FailureMode":"","FailureID":"F19000990","ComponentCode":"BT"},{"SystemCode":"RA","FailureName":"Intake Rocker Lever","FailureMode":"","FailureID":"F03000060","ComponentCode":"VI"},{"SystemCode":"XX","FailureName":"Intermittent/No Problem Found","FailureMode":"","FailureID":"F30001530","ComponentCode":"IP"},{"SystemCode":"FE","FailureName":"Low Pressure Engine Fuel Filter","FailureMode":"","FailureID":"F05000050","ComponentCode":"SW"},{"SystemCode":"LC","FailureName":"Lubricating Oil Cooler Element","FailureMode":"","FailureID":"F07000060","ComponentCode":"EL"},{"SystemCode":"LC","FailureName":"Lubricating Oil Cooler Element Mounting Gasket","FailureMode":"","FailureID":"F07000070","ComponentCode":"GM"},{"SystemCode":"LC","FailureName":"Lubricating Oil Cooler Housing Mounting Gasket","FailureMode":"","FailureID":"F07000080","ComponentCode":"GK"},{"SystemCode":"LN","FailureName":"Lubricating Oil Dipstick","FailureMode":"","FailureID":"F07000030","ComponentCode":"DS"},{"SystemCode":"FS","FailureName":"Lubricating Oil Fill Tube","FailureMode":"","FailureID":"F07000090","ComponentCode":"EL"},{"SystemCode":"LN","FailureName":"Lubricating Oil Filler Tube Seal","FailureMode":"","FailureID":"F07000100","ComponentCode":"OR"},{"SystemCode":"LF","FailureName":"Lubricating Oil Filter","FailureMode":"","FailureID":"F07000110","ComponentCode":"CA"},{"SystemCode":"LC","FailureName":"Lubricating Oil Filter Bypass Valve","FailureMode":"","FailureID":"F07000050","ComponentCode":"TS"},{"SystemCode":"LC","FailureName":"Lubricating Oil Filter Head","FailureMode":"","FailureID":"F07000120","ComponentCode":"HS"},{"SystemCode":"ED","FailureName":"Lubricating Oil Level Sensor","FailureMode":"","FailureID":"F19001024","ComponentCode":"OB"},{"SystemCode":"LN","FailureName":"Lubricating Oil Pan","FailureMode":"","FailureID":"F07000130","ComponentCode":"PN"},{"SystemCode":"LN","FailureName":"Lubricating Oil Pan Drain Plug and Gasket","FailureMode":"","FailureID":"F30003350","ComponentCode":"PL"},{"SystemCode":"LN","FailureName":"Lubricating Oil Pan Gasket","FailureMode":"","FailureID":"F07000140","ComponentCode":"GK"},{"SystemCode":"LN","FailureName":"Lubricating Oil Pan Mounting Hardware","FailureMode":"","FailureID":"F30002590","ComponentCode":"MH"},{"SystemCode":"LC","FailureName":"Lubricating Oil Pressure Regulator","FailureMode":"","FailureID":"F07000150","ComponentCode":"PR"},{"SystemCode":"EA","FailureName":"Lubricating Oil Pressure Sensor","FailureMode":"","FailureID":"F19000620","ComponentCode":"OB"},{"SystemCode":"EA","FailureName":"Lubricating Oil Pressure Switch","FailureMode":"","FailureID":"F19000625","ComponentCode":"SW"},{"SystemCode":"LP","FailureName":"Lubricating Oil Pump","FailureMode":"","FailureID":"F07000180","ComponentCode":"BO"},{"SystemCode":"LP","FailureName":"Lubricating Oil Pump Internal Gear","FailureMode":"","FailureID":"F30000390","ComponentCode":"DG"},{"SystemCode":"LN","FailureName":"Lubricating Oil Suction Tube","FailureMode":"","FailureID":"F07000190","ComponentCode":"ST"},{"SystemCode":"BK","FailureName":"Main Bearings","FailureMode":"","FailureID":"F01000190","ComponentCode":"MA"},{"SystemCode":"FH","FailureName":"Need To Assign","FailureMode":"","FailureID":"F30005350","ComponentCode":"OR"},{"SystemCode":"US","FailureName":"Need To Assign","FailureMode":"","FailureID":"F30005350","ComponentCode":"WH"},{"SystemCode":"LN","FailureName":"Need To Assign","FailureMode":"","FailureID":"F30005350","ComponentCode":"LC"},{"SystemCode":"XM","FailureName":"Need To Assign","FailureMode":"","FailureID":"F30005350","ComponentCode":"DM"},{"SystemCode":"XX","FailureName":"OEM Ambient Air Temperature Sensor ","FailureMode":"","FailureID":"F17000000","ComponentCode":"OE"},{"SystemCode":"XX","FailureName":"OEM Fuel Line","FailureMode":"","FailureID":"F06000040","ComponentCode":"OE"},{"SystemCode":"XX","FailureName":"OEM Relay","FailureMode":"","FailureID":"F17000060","ComponentCode":"OE"},{"SystemCode":"XX","FailureName":"OEM Wiring Harness","FailureMode":"","FailureID":"F19001050","ComponentCode":"OE"},{"SystemCode":"RA","FailureName":"Oil Filler Cap","FailureMode":"","FailureID":"F30000670","ComponentCode":"FP"},{"SystemCode":"RA","FailureName":"Overhead Set","FailureMode":"","FailureID":"F30001540","ComponentCode":"SA"},{"SystemCode":"BP","FailureName":"Piston","FailureMode":"","FailureID":"F01000250","ComponentCode":"CR"},{"SystemCode":"BK","FailureName":"Piston Cooling Nozzle","FailureMode":"","FailureID":"F01000260","ComponentCode":"NZ"},{"SystemCode":"BR","FailureName":"Piston Rings","FailureMode":"","FailureID":"F01000270","ComponentCode":"OC"},{"SystemCode":"FE","FailureName":"Primary Fuel Filter","FailureMode":"","FailureID":"F06000070","ComponentCode":"SP"},{"SystemCode":"RC","FailureName":"Push Rods or Tubes","FailureMode":"","FailureID":"F04000010","ComponentCode":"PV"},{"SystemCode":"XX","FailureName":"Radiator Hoses","FailureMode":"","FailureID":"F08000140","ComponentCode":"OE"},{"SystemCode":"EA","FailureName":"Rail Fuel Pressure Sensor","FailureMode":"","FailureID":"F19000840","ComponentCode":"RB"},{"SystemCode":"BM","FailureName":"Rear Crankshaft Seal","FailureMode":"","FailureID":"F01000280","ComponentCode":"SR"},{"SystemCode":"BM","FailureName":"Rear Crankshaft Seal Carrier","FailureMode":"","FailureID":"F30003410","ComponentCode":"CR"},{"SystemCode":"BD","FailureName":"Rear Gear Housing","FailureMode":"","FailureID":"F30000090","ComponentCode":"GH"},{"SystemCode":"RA","FailureName":"Rocker Lever Cover","FailureMode":"","FailureID":"F03000080","ComponentCode":"VC"},{"SystemCode":"RA","FailureName":"Rocker Lever Cover Gasket","FailureMode":"","FailureID":"F03000070","ComponentCode":"GV"},{"SystemCode":"RA","FailureName":"Rocker Lever Housing","FailureMode":"","FailureID":"F30000450","ComponentCode":"VS"},{"SystemCode":"RA","FailureName":"Rocker Lever Housing Gasket","FailureMode":"","FailureID":"F03000090","ComponentCode":"GK"},{"SystemCode":"SA","FailureName":"Starting Motor","FailureMode":"","FailureID":"F13000170","ComponentCode":"ED"},{"SystemCode":"SA","FailureName":"Starting Motor Magnetic Switch","FailureMode":"","FailureID":"F30000800","ComponentCode":"SO"},{"SystemCode":"FE","FailureName":"Suction Side Fuel Filter","FailureMode":"","FailureID":"F05000060","ComponentCode":"SW"},{"SystemCode":"WR","FailureName":"TRP 1975","FailureMode":"AV","FailureID":"F30004390","ComponentCode":"AL"},{"SystemCode":"WB","FailureName":"TRP 1993","FailureMode":"AB","FailureID":"F30004580","ComponentCode":"KC"},{"SystemCode":"RC","FailureName":"Tappets","FailureMode":"","FailureID":"F04000020","ComponentCode":"TA"},{"SystemCode":"XX","FailureName":"Terminating Resistor","FailureMode":"","FailureID":"F19001077","ComponentCode":"OE"},{"SystemCode":"TH","FailureName":"Turbocharger","FailureMode":"","FailureID":"F10000120","ComponentCode":"AS"},{"SystemCode":"TH","FailureName":"Turbocharger Actuator","FailureMode":"","FailureID":"F10000130","ComponentCode":"AC"},{"SystemCode":"ET","FailureName":"Turbocharger Compressor Intake Air Temperature Sensor","FailureMode":"","FailureID":"F19001100","ComponentCode":"TB"},{"SystemCode":"ET","FailureName":"Turbocharger Compressor Intake Humidity/Pressure/Temperature Sensor","FailureMode":"","FailureID":"F19001105","ComponentCode":"TB"},{"SystemCode":"KV","FailureName":"Turbocharger Coolant Line Seal","FailureMode":"","FailureID":"F30000620","ComponentCode":"OR"},{"SystemCode":"KV","FailureName":"Turbocharger Coolant Return Line","FailureMode":"","FailureID":"F08000170","ComponentCode":"TR"},{"SystemCode":"KV","FailureName":"Turbocharger Coolant Supply Line","FailureMode":"","FailureID":"F08000160","ComponentCode":"TS"},{"SystemCode":"IE","FailureName":"Turbocharger Mounting Gasket","FailureMode":"","FailureID":"F11000630","ComponentCode":"GM"},{"SystemCode":"LS","FailureName":"Turbocharger Oil Drain Line","FailureMode":"","FailureID":"F10000170","ComponentCode":"HT"},{"SystemCode":"LS","FailureName":"Turbocharger Oil Drain Line Mounting Gasket","FailureMode":"","FailureID":"F30001280","ComponentCode":"GK"},{"SystemCode":"LS","FailureName":"Turbocharger Oil Supply Line","FailureMode":"","FailureID":"F30000550","ComponentCode":"HH"},{"SystemCode":"EL","FailureName":"Turbocharger Speed Sensor","FailureMode":"","FailureID":"F19001120","ComponentCode":"TS"},{"SystemCode":"TH","FailureName":"Turbocharger Variable Flow Actuator","FailureMode":"","FailureID":"F19001125","ComponentCode":"AC"},{"SystemCode":"RA","FailureName":"Valve Rocker Shaft","FailureMode":"","FailureID":"F03000110","ComponentCode":"SH"},{"SystemCode":"BE","FailureName":"Vibration Damper","FailureMode":"","FailureID":"F01000320","ComponentCode":"DV"},{"SystemCode":"KC","FailureName":"Water Inlet Connection","FailureMode":"","FailureID":"F30001010","ComponentCode":"NM"},{"SystemCode":"KT","FailureName":"Water Outlet Connection","FailureMode":"","FailureID":"F30003490","ComponentCode":"CO"},{"SystemCode":"KP","FailureName":"Water Pump","FailureMode":"","FailureID":"F08000180","ComponentCode":"BE"},{"SystemCode":"KH","FailureName":"Water Pump Belt Tensioner","FailureMode":"","FailureID":"F08000000","ComponentCode":"BT"},{"SystemCode":"KP","FailureName":"Water Pump Body","FailureMode":"","FailureID":"F30000290","ComponentCode":"BD"},{"SystemCode":"KP","FailureName":"Water Pump O-Ring Seal","FailureMode":"","FailureID":"F30000680","ComponentCode":"OR"},{"SystemCode":"KP","FailureName":"Water Pump Pulley","FailureMode":"","FailureID":"F30003500","ComponentCode":"PU"},{"SystemCode":"KP","FailureName":"Water Pump Seal","FailureMode":"","FailureID":"F30000280","ComponentCode":"SE"},{"SystemCode":"ED","FailureName":"Water in Fuel Sensor","FailureMode":"","FailureID":"F19001160","ComponentCode":"WF"},{"SystemCode":"XX","FailureName":"","FailureMode":"","FailureID":"F17000040","ComponentCode":"OE"},{"SystemCode":"XX","FailureName":"","FailureMode":"","FailureID":"F13000040","ComponentCode":"OE"},{"SystemCode":"IN","FailureName":"","FailureMode":"","FailureID":"F10000040","ComponentCode":"TD"},{"SystemCode":"SN","FailureName":"","FailureMode":"","FailureID":"F01000110","ComponentCode":"FW"}]}';
            insert jer;

            //JobPlanOverCont.SRTFailurenames();

            JobPlanOverCont.invalidAppCode ='true';
            Set<String> failAcocuntCodeSet = new Set<String>();
            failAcocuntCodeSet.add('Akanksha test');
            failAcocuntCodeSet.add('Akanksha test');
            failAcocuntCodeSet.add('Akanksha test');
            failAcocuntCodeSet.add('Akanksha test');
            failAcocuntCodeSet.add('Akanksha test');
            JobPlanOverCont.selectedSysCode ='TH';
            JobPlanOverCont.selectedCompCode = 'AS';
            pref=JobPlanOverCont.updateFailCodeComponents(); 
            JobPlanOverCont.onChangeofAppCode();


            list<CSS_Solution_Component__c> solcomreflist1 =new list<CSS_Solution_Component__c>();

            //Creating Solution Component--4
            //for(integer i=0;i<5;i++)
            //{
            CSS_Solution_Component__c solComRef1 = CSS_TestData.createSRT(false,jobRef.Id,solRef.Id);
            solComRef1.System_Code__c = 'Test';
            solComRef1.Component_Code__c = 'Test';
            solComRef1.Failure_Mode__c = 'Test';
            solComRef1.Solutions__c =solRef.id;
            solComRef1.AccountCodeType__c = 'NEW-New Engine WarrantyNEW-New Engine Warranty';
            solComRef1.AccountCode_Call_Status__c = 'Failure';
            solComRef1.Failure_Point__c=11.0;
            solComRef1.Failure_Date__c=date.parse('12/27/2014');
            solComRef1.AccountCode__c = '67';
            solComRef1.AccountCodeEdit__c ='New Engine Warranty 67';
            solComRef1.Parts_Warranty__c='New Parts Warranty';
            solComRef1.Failure_Measure__c='Miles';
            System.debug('The Solution Component Object' +solComRef);
            insert solComRef1;
            system.debug('CSS ACCOUNT CODE FORMULA: 1: '+solComRef.CSS_Account_Formula__c);
            solcomreflist.add(solComRef1);
            upsert solcomreflist;//By Rupesh
            JobPlanOverCont.onAddClick();

            list<CSS_JobEventTemporary__c> jetlist1=new list<CSS_JobEventTemporary__c>();
            //css_testdata.createJobEventTempObj(true);
            CSS_JobEventTemporary__c x1=new CSS_JobEventTemporary__c();
            x1.key__c='FailModes';
            x1.Attribute3__c='ISX12/ISX11.9 CM2250;;0K';
            insert x1;
            jetlist1.add(x1);
            upsert jetlist1;//By Rupesh

            list<string> fmods=new list<string>();
            if(fmods==null)
                fmods=JobPlanOverCont.getFailModes();

            list<CSS_JobEventTemporary__c> jetlist2=new list<CSS_JobEventTemporary__c>();
            //css_testdata.createJobEventTempObj(true);
            CSS_JobEventTemporary__c x2=new CSS_JobEventTemporary__c();
            x2.key__c='CDSFaultCodes';
            x2.Attribute3__c='ISX12/ISX11.9 CM2250;;0K';
            insert x2;
            jetlist1.add(x2);
            upsert jetlist2;//By Rupesh
            Test.stopTest(); 
        }
    }
    
    public static testmethod void checkCoverageMethod() {
        List<String> failCodeSplit = new List<String>();
        String s = 'Test-teSt';
        String s1= 'Test-teSt';
        failCodeSplit.add(s);
        failCodeSplit.add(s1);
        CSS_Solution_Component__c solComp = new CSS_Solution_Component__c();
        solComp.Failure_Measure__c=null;
        solComp.AccountCode_Call_Status__c='test';
        //solcomp.CSS_Custom_Failure__c = 'null';
        test.startTest();
        CSS_JobPlanOverviewControllerNew JobPlanOverCont = new CSS_JobPlanOverviewControllerNew();
        JobPlanOverCont.failCodeSelected = s;
        JobPlanOverCont.failCodeSelected = s1;
        JobPlanOverCont.partsWarranty=null;
        Test.setMock(HttpCalloutMock.class , new CSS_WS_SBL_GetWarrantyDetailCovrg_Test());
        JobPlanOverCont.checkCoverage();
        test.stopTest();   
    } 

    public static testmethod void checkCoverageMethod1() {
        
        test.startTest();
        CSS_JobPlanOverviewControllerNew JobPlanOverCont = new CSS_JobPlanOverviewControllerNew();
        Test.setMock(HttpCalloutMock.class , new CSS_WS_SBL_GetWarrantyDetailCovrg_Test());
        JobPlanOverCont.checkCoverage();
        test.stopTest();
    }


    public static testmethod void partsmethod() {

        CSS_Job_Order__c JO = new CSS_Job_Order__c();

        JO.Customer_Name__c = 'Test';
        JO.Model__c = 'Test';
        JO.Make__c = 'CSSTest';
        JO.Failure_Point__c = 122;
        JO.Failure_Point_Measure__c ='Miles';
        JO.VIN__c='12345677890';
        JO.Failure_Date__c =date.today()-20;
        JO.Warranty_Start_Date__c =date.today()-365;
        JO.Location_Certification__c='abc';
        JO.jobLocation__c='abc';
        JO.Status__c = 'Intake Complete';
        JO.Unit_Number__c = 'test123';
        Jo.Assigned_To__c = UserInfo.getUserId();
        JO.CSS_Job_Location_Code__c='56270-56255';
        Jo.esn__c='1234';
        JO.Equipment_ID__c = 'EQ7667';
        JO.Qsol_Engine_Family_Code__c ='56';
        JO.AccessCode__c = 'A';
        JO.BMSWSStatus__c = 'UI';
        JO.BMSStatus__c = 'sample';
        JO.CSS_Resolution__c='TEST';
        JO.chevron_page__c='srt';

        insert JO;    

        CSS_Solutions__c sol = new CSS_Solutions__c();

        sol.Service_Job__c = JO.ID;
        sol.Case_Name__c = 'ABC';
        sol.Solution_Title__c='CDE';
        sol.Name='ABC';
        sol.Diagnostic_Response__c ='Most likely the solution';
        sol.Repair_Response__c = 'Most likely';

        insert sol;

        Map<id,CSS_Solution_Component__c> solCompMap = new Map<id,CSS_Solution_Component__c>();

        CSS_Solution_Component__c AddsolComp = new CSS_Solution_Component__c();

        AddsolComp.Component_Id__c ='F0051000';
        AddsolComp.Service_Job__c = JO.Id;
        AddsolComp.Action__c = 'Repair';
        //AddsolComp.Solutions__c = sol.Id;
        AddsolComp.Quantity__c = 4;
        AddsolComp.type__c='CAM';
        AddsolComp.Selected_Component__c = True;
        AddsolComp.AccountCode__c = 'Test-AccountCode';
        AddsolComp.AccountCodeEdit__c = 'Test-ACEdit';
        AddsolComp.CoveredPartsQty__c = null;
        AddsolComp.AccountCodeType__c='ASAS';
        //AddsolComp.Fail_Code__c = 'THAS';
        AddsolComp.Fail_Code_Editable__c='CAM-campaign';

        insert AddsolComp;

        CSS_Parts_Options__c parts = new CSS_Parts_Options__c();

        parts.Option_Number__c = 'O-111';
        parts.Service_Job__c = JO.Id;
        parts.selected_part__c = true;
        parts.FailurepartId__c = AddsolComp.Id;
        parts.Part_Assignment__c = 'Primary';
        //parts.Solutions__c=sol.Id;

        insert parts;
        solCompMap.put(AddsolComp.id,AddsolComp);

        test.startTest();
        CSS_JobPlanOverviewControllerNew JobPlanOverCont = new CSS_JobPlanOverviewControllerNew();
        //JobPlanOverCont.updatestatus();
        test.stopTest();   

    } 

    public static testMethod void TestMethod1New22()
    {

        CSS_Job_Order__c jobRef2 = CSS_TestData.createJobOrder(false); 
        jobRef2.Service_Model__c = 'test';
        insert jobRef2;
        CSS_JobEventTemporary__c JETsys4 = new CSS_JobEventTemporary__c();
        JETsys4.Attribute1__c = 'TH';
        JETsys4.Attribute4__c ='TS';
        JETsys4.key__c = 'FailModes';
        JETsys4.Attribute3__c = 'TURBO';
        JETsys4.Attribute5__c = 'ASSEMBLY';
        JETsys4.Attribute7__c='test';
        JETsys4.Active__c= true;
        JETsys4.Reason__c = '{\r\n\t\"Header\": {\r\n\t\t\"ReturnCodeDescription\": \"Normal, Successful completion.\",\r\n\t\t\"ReturnCode\": \"ORA-00000\",\r\n\t\t\"MessageIdentifier\": \"S\"\r\n\t},\r\n\t\"DataArea\": [{\r\n\t\t\"SystemCode\": \"WF\",\r\n\t\t\"FailureName\": \"ATC 1795\",\r\n\t\t\"FailureMode\": \"SP\",\r\n\t\t\"FailureID\": \"F30003750\",\r\n\t\t\"ComponentCode\": \"HA\"\r\n\t}]\r\n}';
        insert JETsys4;
        CSS_JobEventTemporary__c JETsys5 = new CSS_JobEventTemporary__c();
        JETsys5.Attribute1__c = 'TH';
        JETsys5.Attribute4__c ='TS';
        JETsys5.key__c = 'CDSFaultCodes';
        JETsys5.Attribute3__c = 'TURBO';
        JETsys5.Attribute5__c = 'ASSEMBLY';
        JETsys5.Attribute7__c='test';
        JETsys5.Active__c= true;
        JETsys5.Reason__c = '{\r\n\t\"Header\": {\r\n\t\t\"ReturnCodeDescription\": \"Normal, Successful completion.\",\r\n\t\t\"ReturnCode\": \"ORA-00000\",\r\n\t\t\"MessageIdentifier\": \"S\"\r\n\t},\r\n\t\"DataArea\": [{\r\n\t\t\"SystemCode\": \"WF\",\r\n\t\t\"FailureName\": \"ATC 1795\",\r\n\t\t\"FailureMode\": \"SP\",\r\n\t\t\"FailureID\": \"F30003750\",\r\n\t\t\"ComponentCode\": \"HA\"\r\n\t}]\r\n}';
        insert JETsys5;
        CSS_SMN_FaultCode__c smn = new CSS_SMN_FaultCode__c();
        smn.Name = 'test';
        smn.Description__c = 'test';
        smn.Fault_Code__c = 'test';
        smn.SMN__c = 'test';
        insert smn;
        CSS_Claims__c claims = new CSS_Claims__c();
        claims.Status__c='Submitted';
        claims.ESN__c='79462880';
        claims.Customer_Name__c='BRITESTONE COLONY';
        claims.Customer_Code__c='123';
        claims.Location_Code__c='56270-56255';
        claims.ownerId = UserInfo.getUserId();
        insert claims;
        apexpages.currentPage().getparameters().put('id',jobRef2.Id); 
        test.startTest();
        CSS_JobPlanOverviewControllerNew JobPlanOverCont1 = new CSS_JobPlanOverviewControllerNew();

        jobPlanOverCont1.selectedFailMode='TH-TURBO';
        CSS_JobEventTemporary__c JETsys = new CSS_JobEventTemporary__c();
            JETsys.Attribute1__c = 'POL';
            JETsys.Attribute2__c = 'MISCELLANEOUS - KA91 ADD';
            JETsys.Attribute4__c ='POL-MISCELLANEOUS - KA91 ADD-02';
            JETsys.key__c = 'AccountCodes';
            JETsys.Attribute3__c = '02';
            JETsys.Active__c= true;
            JETsys.Attribute5__c = 'N';
            JETsys.Reason__c = '{\r\n\t\"Header\": {\r\n\t\t\"ReturnCodeDescription\": \"Normal, Successful completion.\",\r\n\t\t\"ReturnCode\": \"ORA-00000\",\r\n\t\t\"MessageIdentifier\": \"S\"\r\n\t},\r\n\t\"DataArea\": [{\r\n\t\t\"SystemCode\": \"WF\",\r\n\t\t\"FailureName\": \"ATC 1795\",\r\n\t\t\"FailureMode\": \"SP\",\r\n\t\t\"FailureID\": \"F30003750\",\r\n\t\t\"ComponentCode\": \"HA\"\r\n\t}]\r\n}';
            insert JETsys;
        jobplanovercont1.checkFailMode();
        jobPlanOverCont1.selectedFaultCode='test-test';

        jobplanovercont1.checkFaultCode();
        test.stopTest();
    }


    public static testMethod void TestMethod1New2()
    {

        //Creating Service Job--1
        CSS_Job_Order__c jobRef2 = CSS_TestData.createJobOrder(false); 
        //CSS_Job_Order__c jobRef2 = new CSS_Job_Order__c();    
        list<string> falist=new list<string>();
        string st='Test';
        falist.add(st);
        list<string> partfalist=new list<string>();
        string st1='Test';
        partfalist.add(st1);
        CSS_Integration_Details__c csInt = new CSS_Integration_Details__c();
        csInt.name = 'SRT';
        csInt.ApplicationName__c='SRT';
        csInt.End_Point__c='https://Test-services-dev.cummins.com/css/';
        csInt.IsActive__c=true;
        csInt.Key__c='/Q0w11SmTDJ11dPRgzYfGjycs+HZbtT8sezi/jkT7Ag=';
        csInt.Passcode__c='u9pf3rdOE0SCjXDCgmzRbUlwWQWen7B9993Eh61KI1E=';
        csInt.Username__c='6dpW6v5ekUR2HzkTePJXwgNaMDgo0t53tZgmixV4rfU=';
        insert csint;


        jobRef2.chevron_page__c='jo';
        jobRef2.BMSWSStatus__c = 'UI';
        jobRef2.CSS_Resolution__c = 'Test';
        jobRef2.General_Symptoms__c='';

        jobRef2.CoverageResponse__c = 'xyz';
        jobRef2.ApplicationCode__c='130';
        upsert jobRef2;
        CSS_Parts_Options__c parts = new CSS_Parts_Options__c();
        parts.Covered__c =0.0;
        parts.Fail_Code__c ='test';
        parts.Service_partnumber__c='test';
        parts.Account_Code__c = 'test1';
        parts.Service_Job__c = jobRef2.id;  
        parts.ReturnToFactory__c = '' ;

        insert parts;
        list<CSS_Solutions__c> sollist=new list<CSS_Solutions__c>();

        CSS_Solutions__c solRef2 =  CSS_TestData.createSolutions(false,jobRef2.Id);
        solRef2.Repair_Response__c='Sucessful';
        //solRef2.ApplicationCode__c='130';

        CSS_Solutions__c solRef3 =  CSS_TestData.createSolutions(false,jobRef2.Id);
        solRef3.Repair_Response__c=null;
        //solRef3.ApplicationCode__c='130';
        sollist.add(solRef2);
        sollist.add(solRef3);
        upsert sollist;
        set<Id> solutionIds = new set<Id>();
        solutionIds.add(solRef2.id);
        solutionIds.add(solRef3.id);

        List<CSS_Solution_Component__c> solComList = new List<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solComRef = CSS_TestData.createSRT(false,jobRef2.Id,solRef2.Id);
        solComRef.System_Code__c = 'Test';

        solComRef.Component_Code__c = 'Test';
        solComRef.Failure_Mode__c = 'Test';
        solComRef.Solutions__c =solRef2.id;
        solComRef.AccountCodeType__c = 'Test-Test';
        solComRef.AccountCode_Call_Status__c = 'Failure';
        solComRef.Failure_Point__c=11.0;
        solComRef.Failure_Measure__c = null;
        solComRef.name='test';
        solComRef.Failure_Date__c=date.today();
        solComRef.AccountCode__c = 'tst';
        solComRef.AccountCodeEdit__c='test';
        solComRef.CoveredPartsQty__c='0';
        solComRef.CampaignPartsPercentage__c='100';
        solComRef.Type__c = '';
        System.debug('The Solution Component Object');
        solComList.add(solComRef);


        CSS_Solution_Component__c solComRef1 = CSS_TestData.createSRT(false,jobRef2.Id,solRef2.Id);
        solComRef1.System_Code__c = 'Test';
        solComRef1.name='test';
        solComRef1.Component_Code__c = 'Test';
        solComRef1.Failure_Mode__c = 'Test';
        solComRef1.Solutions__c =solRef2.id;
        solComRef1.AccountCode__c = 'tst';
        solComRef1.AccountCodeEdit__c='test';
        solComRef1.AccountCode_Call_Status__c = 'Failure';
        solComRef1.Failure_Point__c=11.0;
        solComRef1.Failure_Measure__c = null;
        solComRef1.CoveredPartsQty__c='9999999';
        solComRef1.CampaignPartsPercentage__c='100';
        solComRef1.Failure_Date__c=date.today();
        solComRef1.Type__c = '';
        solComList.add(solComRef1);
        insert solComList;
        CSS_Fault_Code__c fc3 = new CSS_Fault_Code__c(FaultCodeR2__c = '441',Related_Fault_Code__c = '234,546');
        fc3.Name = '441';
        fc3.Job_Order__c = jobRef2.Id;
        fc3.Sequence__c = 1; 
        fc3.Fault_Code_Type__c = 'APD-P';
        fc3.Mod__c = '0';
        fc3.isPole__c = false;
        fc3.Number_of_Solutions__c = '1';
        insert fc3;

        CSS_JobEventTemporary__c JETsys = new CSS_JobEventTemporary__c();
        JETsys.Attribute1__c = 'TH';
        JETsys.Attribute4__c ='TS';
        JETsys.key__c = 'FailCodes';
        JETsys.Attribute3__c = 'TURBO';
        JETsys.Attribute5__c = 'ASSEMBLY';
        JETsys.Attribute7__c='test';
        JETsys.Reason__c = '{\r\n\t\"Header\": {\r\n\t\t\"ReturnCodeDescription\": \"Normal, Successful completion.\",\r\n\t\t\"ReturnCode\": \"ORA-00000\",\r\n\t\t\"MessageIdentifier\": \"S\"\r\n\t},\r\n\t\"DataArea\": [{\r\n\t\t\"SystemCode\": \"WF\",\r\n\t\t\"FailureName\": \"ATC 1795\",\r\n\t\t\"FailureMode\": \"SP\",\r\n\t\t\"FailureID\": \"F30003750\",\r\n\t\t\"ComponentCode\": \"HA\"\r\n\t}]\r\n}';
        insert JETsys;
        CSS_JobEventTemporary__c JETsys4 = new CSS_JobEventTemporary__c();
        JETsys4.Attribute1__c = 'TH';
        JETsys4.Attribute4__c ='TS';
        JETsys4.key__c = 'FailModes';
        JETsys4.Attribute3__c = 'TURBO';
        JETsys4.Attribute5__c = 'ASSEMBLY';
        JETsys4.Attribute7__c='test';
        JETsys4.Active__c= true;
        JETsys4.Reason__c = '{\r\n\t\"Header\": {\r\n\t\t\"ReturnCodeDescription\": \"Normal, Successful completion.\",\r\n\t\t\"ReturnCode\": \"ORA-00000\",\r\n\t\t\"MessageIdentifier\": \"S\"\r\n\t},\r\n\t\"DataArea\": [{\r\n\t\t\"SystemCode\": \"WF\",\r\n\t\t\"FailureName\": \"ATC 1795\",\r\n\t\t\"FailureMode\": \"SP\",\r\n\t\t\"FailureID\": \"F30003750\",\r\n\t\t\"ComponentCode\": \"HA\"\r\n\t}]\r\n}';
        insert JETsys4;
        CSS_JobEventTemporary__c JETsys41 = new CSS_JobEventTemporary__c();
        JETsys41.Attribute1__c = 'TH';
        JETsys41.Attribute4__c ='TS';
        JETsys41.key__c = 'CDSFaultCodes';
        JETsys41.Attribute3__c = 'TURBO';
        JETsys41.Attribute5__c = 'ASSEMBLY';
        JETsys41.Attribute7__c='test';
        JETsys41.Active__c= true;
        JETsys41.Reason__c = '{\r\n\t\"Header\": {\r\n\t\t\"ReturnCodeDescription\": \"Normal, Successful completion.\",\r\n\t\t\"ReturnCode\": \"ORA-00000\",\r\n\t\t\"MessageIdentifier\": \"S\"\r\n\t},\r\n\t\"DataArea\": [{\r\n\t\t\"SystemCode\": \"WF\",\r\n\t\t\"FailureName\": \"ATC 1795\",\r\n\t\t\"FailureMode\": \"SP\",\r\n\t\t\"FailureID\": \"F30003750\",\r\n\t\t\"ComponentCode\": \"HA\"\r\n\t}]\r\n}';
        insert JETsys41;
        CSS_JobEventTemporary__c JETsys3 = new CSS_JobEventTemporary__c();
        JETsys3.Attribute1__c = 'TH';
        JETsys3.Attribute4__c ='TS';
        JETsys3.key__c = 'AccountCodes';
        JETsys3.Attribute3__c = 'TURBO';
        JETsys3.Attribute2__c = 'TURBO-TURBO';
        JETsys3.Attribute5__c = 'ASSEMBLY';
        JETsys3.Attribute7__c='test';
        JETsys3.Reason__c = '{\r\n\t\"Header\": {\r\n\t\t\"ReturnCodeDescription\": \"Normal, Successful completion.\",\r\n\t\t\"ReturnCode\": \"ORA-00000\",\r\n\t\t\"MessageIdentifier\": \"S\"\r\n\t},\r\n\t\"DataArea\": [{\r\n\t\t\"SystemCode\": \"WF\",\r\n\t\t\"FailureName\": \"ATC 1795\",\r\n\t\t\"FailureMode\": \"SP\",\r\n\t\t\"FailureID\": \"F30003750\",\r\n\t\t\"ComponentCode\": \"HA\"\r\n\t}]\r\n}';
        insert JETsys3;

        CSS_JobEventTemporary__c JETsys2 = new CSS_JobEventTemporary__c();
        JETsys2.Attribute1__c = 'TH';
        JETsys2.Attribute4__c ='TS';
        JETsys2.key__c = 'getFailureCodesSRT';
        JETsys2.Attribute3__c = 'ESN;;1234';
        JETsys2.Attribute5__c = 'ASSEMBLY';
        JETsys2.Attribute7__c='test';
        JETsys2.Reason__c = '{\r\n\t\"Header\": {\r\n\t\t\"ReturnCodeDescription\": \"Normal, Successful completion.\",\r\n\t\t\"ReturnCode\": \"ORA-00000\",\r\n\t\t\"MessageIdentifier\": \"S\"\r\n\t},\r\n\t\"DataArea\": [{\r\n\t\t\"SystemCode\": \"WF\",\r\n\t\t\"FailureName\": \"ATC 1795\",\r\n\t\t\"FailureMode\": \"SP\",\r\n\t\t\"FailureID\": \"F30003750\",\r\n\t\t\"ComponentCode\": \"HA\"\r\n\t}]\r\n}';
        insert JETsys2;
        CSS_JobEventTemporary__c JETsys1 = new CSS_JobEventTemporary__c();
        JETsys1.Attribute1__c = 'ISX12 CM2350 X102';
        JETsys1.Attribute2__c ='OK';
        JETsys1.key__c = 'GetFailureCodesSRT';
        JETsys1.Attribute3__c = 'ISX12 CM2350 X102;;0K';
        JETsys1.Attribute5__c = 'ASSEMBLY';
        JETsys1.Reason__c = '{\r\n\t\"Header\": {\r\n\t\t\"ReturnCodeDescription\": \"Normal, Successful completion.\",\r\n\t\t\"ReturnCode\": \"ORA-00000\",\r\n\t\t\"MessageIdentifier\": \"S\"\r\n\t},\r\n\t\"DataArea\": [{\r\n\t\t\"SystemCode\": \"WF\",\r\n\t\t\"FailureName\": \"ATC 1795\",\r\n\t\t\"FailureMode\": \"SP\",\r\n\t\t\"FailureID\": \"F30003750\",\r\n\t\t\"ComponentCode\": \"HA\"\r\n\t}]\r\n}';
        insert JETsys1;
        List<CSS_Fault_Code__c> lstFC1 = new List<CSS_Fault_Code__c>();
        lstFC1.add(fc3);
        PageReference pref;
        pref = new PageReference('/'+jobRef2.id);
        pref.getParameters().put('id',jobRef2.id);
        Test.setCurrentPage(pref);
        CSS_Integration_Details__c cid1 = CSS_TestData.createIntegrationDetails(false);
        cid1.name = 'CSS_SBL_GetPartReturns';
        cid1.ApplicationName__c = 'CSS_SBL_getpartreturn';
        cid1.End_Point__c = 'https://services-stg.cummins.com/csswarranty/getpartreturn';
        insert cid1;

        CSS_Integration_Details__c cid = CSS_TestData.createIntegrationDetails(false);
        cid.name = 'CSS_SBL_WarrantyDetailCoverage';
        cid.ApplicationName__c = 'CSS_SBL_WarrantyDetailCoverage';
        cid.End_Point__c = 'https://services-stg.cummins.com/csswarranty/accodecoverage';
        insert cid;
        Map<String,String> systemCodeMap = new Map<String,String>();
        systemCodeMap.put('THT','THT');
        systemCodeMap.put('tes','THT');
        Map<String,String> custFailureNameList = new Map<String,String>();
        custFailureNameList.put('test','THT');
        custFailureNameList.put('tes','THT');
        Map<String,String> failureNameWithSystemCodeMap = new Map<String,String>();
        failureNameWithSystemCodeMap.put('test','THT');
        failureNameWithSystemCodeMap.put('tes','THT');
        Map<String,String> failureNameWithCompCodeMap = new Map<String,String>();
        failureNameWithCompCodeMap.put('test','THT');
        failureNameWithCompCodeMap.put('tes','THT');
        Map<String,String> FailureNameWithFailureIDMap = new Map<String,String>();
        FailureNameWithFailureIDMap.put('test','THT');
        FailureNameWithFailureIDMap.put('tes','THT');
        Set<String> failureNameList=new Set<String>();
        failureNameList.add('test');
        Set<String> componentCodeList=new Set<String>();
        componentCodeList.add('test');
        componentCodeList.add('t');
        test.startTest();
        CSS_JobPlanOverviewControllerNew JobPlanOverCont1 = new CSS_JobPlanOverviewControllerNew();
        jobPlanOverCont1.selectedSysCode='THT';
        jobPlanOverCont1.systemCodeMap=systemCodeMap;
        // JobPlanOverCont1.changeSystemcode_New();
        jobPlanOverCont1.selectedCustFName='test';
        //JobPlanOverCont1.changeSystemcode_New();
        jobPlanOverCont1.selectedCustFName='test';
        jobPlanOverCont1.custFailureNameList=custFailureNameList;
        //jobplanovercont1.changeCustFailures_New();
        jobPlanOverCont1.selectedCustFName='on';
        //jobplanovercont1.changeCustFailures_New();
        jobPlanOverCont1.failureNameWithSystemCodeMap=failureNameWithSystemCodeMap;
        jobPlanOverCont1.failureNameWithCompCodeMap=failureNameWithCompCodeMap;
        jobPlanOverCont1.FailureNameWithFailureIDMap=FailureNameWithFailureIDMap;
        jobplanovercont1.failureNameList=failureNameList;
        jobplanovercont1.selectedFName='unlisted';
        //jobplanovercont1.changeFailures_New();

        jobplanovercont1.selectedFName=solComRef1.name;
        jobplanovercont1.selectedCompCode=solComRef1.Component_Code__c;
        jobplanovercont1.selectedSysCode=solComRef1.System_Code__c;
        jobplanovercont1.selectedFailMode=solComRef1.Failure_Mode__c;
        Test.setMock(HttpCalloutMock.class , new CSS_WS_SBL_GetWarrantyDetailCovrg_Test());
        jobplanovercont1.checkCoverageNew();

        jobPlanOverCont1.selectedCustFName='';
        jobPlanOverCont1.selectedCompCode='test';
        jobPlanOverCont1.componentCodeList=componentCodeList;
        jobplanovercont1.checkCompCode();
        jobPlanOverCont1.selectedCompCode='tet';
        jobplanovercont1.checkCompCode();
        jobPlanOverCont1.selectedCustFName='tet';
        jobplanovercont1.checkCompCode();

        jobPlanOverCont1.selectedFailMode='tet';
        CSS_JobEventTemporary__c JETsysAccCodes1 = new CSS_JobEventTemporary__c();
            JETsysAccCodes1.Attribute1__c = 'POL';
            JETsysAccCodes1.Attribute2__c = 'MISCELLANEOUS - KA91 ADD';
            JETsysAccCodes1.Attribute4__c ='POL-MISCELLANEOUS - KA91 ADD-02';
            JETsysAccCodes1.key__c = 'AccountCodes';
            JETsysAccCodes1.Attribute3__c = '02';
            JETsysAccCodes1.Active__c= true;
            JETsysAccCodes1.Attribute5__c = 'N';
            JETsysAccCodes1.Reason__c = '{\r\n\t\"Header\": {\r\n\t\t\"ReturnCodeDescription\": \"Normal, Successful completion.\",\r\n\t\t\"ReturnCode\": \"ORA-00000\",\r\n\t\t\"MessageIdentifier\": \"S\"\r\n\t},\r\n\t\"DataArea\": [{\r\n\t\t\"SystemCode\": \"WF\",\r\n\t\t\"FailureName\": \"ATC 1795\",\r\n\t\t\"FailureMode\": \"SP\",\r\n\t\t\"FailureID\": \"F30003750\",\r\n\t\t\"ComponentCode\": \"HA\"\r\n\t}]\r\n}';
            insert JETsysAccCodes1;
        jobplanovercont1.checkFailMode();
        jobPlanOverCont1.selectedFaultCode='tet';
        jobplanovercont1.checkFaultCode();
        jobplanovercont1.getFailModes();
        test.stopTest();
    }
      
    public static testMethod void TestMethod1New1()
    {
        Account acc = new Account();
        acc.name='R1test';
        acc.CSS_DistributorCode__c='03520';
        acc.CSS_DealerCode__c='';
        acc.CSS_FleetCode__c = '';
        acc.CSS_DBCode__c = '04892';
        acc.ERP_System__c = 'One BMS';
        acc.Type = 'Customer';
        acc.Region__c = 'NORTH AMERICA';//'US and Canada';
        acc.CMI_Account_Status__c = 'Active';
        acc.IAM_Service_Provider_Code__c='56270';
        // insert acc;
        //Creating Service Job--1
        CSS_Job_Order__c jobRef2 = CSS_TestData.createJobOrder(false); 
        //CSS_Job_Order__c jobRef2 = new CSS_Job_Order__c();    
        list<string> falist=new list<string>();
        string st='Test';
        falist.add(st);
        list<string> partfalist=new list<string>();
        string st1='Test';
        partfalist.add(st1);
        CSS_Integration_Details__c csInt = new CSS_Integration_Details__c();
        csInt.name = 'SRT';
        csInt.ApplicationName__c='SRT';
        csInt.End_Point__c='https://Test-services-dev.cummins.com/css/';
        csInt.IsActive__c=true;
        csInt.Key__c='/Q0w11SmTDJ11dPRgzYfGjycs+HZbtT8sezi/jkT7Ag=';
        csInt.Passcode__c='u9pf3rdOE0SCjXDCgmzRbUlwWQWen7B9993Eh61KI1E=';
        csInt.Username__c='6dpW6v5ekUR2HzkTePJXwgNaMDgo0t53tZgmixV4rfU=';
        insert csint;
        CSS_JobPlanOverviewControllerNew obj=new CSS_JobPlanOverviewControllerNew();
        obj.faultList=falist;
        obj.partlistFAULT=partfalist;

        jobRef2.chevron_page__c='jo';
        jobRef2.BMSWSStatus__c = 'UI';
        jobRef2.CSS_Resolution__c = 'Test';
        jobRef2.General_Symptoms__c='';

        jobRef2.CoverageResponse__c = 'xyz';
        jobRef2.ApplicationCode__c='130';
        //jobRef2.Account__c=acc.id;
        upsert jobRef2;

        CSS_Fault_Code__c fc3 = new CSS_Fault_Code__c(FaultCodeR2__c = '441',Related_Fault_Code__c = '234,546');
        fc3.Name = '441';
        fc3.Job_Order__c = jobRef2.Id;
        fc3.Sequence__c = 1; 
        fc3.Fault_Code_Type__c = 'APD-P';
        fc3.Mod__c = '0';
        fc3.isPole__c = false;
        fc3.Number_of_Solutions__c = '1';
        insert fc3;

        CSS_SymptomQA__c symqa12=new CSS_SymptomQA__c();
        symqa12.job_order__c = jobRef2.id;
        symqa12.type__c='SearchString';
        symqa12.user_name__c = null;
        symqa12.name='TESST';
        symqa12.Caption__c = 'akanksha';
        insert symqa12;

        CSS_SymptomQA__c symqa2=new CSS_SymptomQA__c();
        symqa2.job_order__c = jobRef2.id;
        symqa2.type__c='SearchString';
        symqa2.user_name__c = null;
        symqa2.name='TESST';
        symqa2.SearchString__c = symqa12.id;
        symqa2.Caption__c = 'akanksha';
        insert symqa2;

        list<CSS_Solutions__c> sollist=new list<CSS_Solutions__c>();

        CSS_Solutions__c solRef2 =  CSS_TestData.createSolutions(false,jobRef2.Id);
        solRef2.Repair_Response__c='Sucessful';
        solRef2.FaultCode__c=fc3.id;
        solref2.Symptom__c=symqa12.id;

        CSS_Solutions__c solRef3 =  CSS_TestData.createSolutions(false,jobRef2.Id);
        solRef3.Repair_Response__c=null;
        solRef3.FaultCode__c=fc3.id;
        solref3.Symptom__c=symqa2.id;
        sollist.add(solRef2);
        sollist.add(solRef3);
        upsert sollist;

        CSS_SRT__c srtVar = new CSS_SRT__c();
        srtVar.Solution_Number__c = solRef2.id;
        srtVar.Job_Order__c = jobRef2.Id;
        srtVar.SRT_AccessiblityCheck__c=True;
        srtVar.Access_Code_A__c = 65;
        srtVar.name = 'Test'+Math.random();
        srtVar.Type__c = 'Diagnosis';
        srtVar.isPerformed__c =True;

        //insert srtVar;

        CSS_SRT__c srtVar1 = new CSS_SRT__c();
        srtVar1.Solution_Number__c = solRef3.id;
        srtVar1.Job_Order__c = jobRef2.Id;
        srtVar1.SRT_AccessiblityCheck__c=True;
        srtVar1.Access_Code_A__c = 65;
        srtVar1.name = 'Test'+Math.random();
        srtVar1.Type__c = 'Diagnosis';
        srtVar1.isPerformed__c =True;

        //insert srtVar1;

        set<Id> solutionIds = new set<Id>();
        solutionIds.add(solRef2.id);
        solutionIds.add(solRef3.id);

        List<CSS_Solution_Component__c> solComList = new List<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solComRef = CSS_TestData.createSRT(false,jobRef2.Id,solRef2.Id);
        solComRef.System_Code__c = 'Test';

        solComRef.Component_Code__c = 'Test';
        solComRef.Failure_Mode__c = 'Test';
        solComRef.Solutions__c =solRef2.id;
        solComRef.AccountCodeType__c = 'Test-Test';
        solComRef.AccountCode_Call_Status__c = 'Failure';
        solComRef.Failure_Point__c=11.0;
        solComRef.Failure_Measure__c = null;
        solComRef.name='test';
        solComRef.Failure_Date__c=date.today();
        solComRef.AccountCode__c = 'tst';
        solComRef.AccountCodeEdit__c='test';
        solComRef.CoveredPartsQty__c='0';
        solComRef.CampaignPartsPercentage__c='100';
        solComRef.Type__c = '';
        System.debug('The Solution Component Object');
        solComList.add(solComRef);

        CSS_Solution_Component__c solComRef3 = CSS_TestData.createSRT(false,jobRef2.Id,solRef2.Id);
        solComRef3.System_Code__c = 'Test';

        solComRef3.Component_Code__c = 'Test';
        solComRef3.Failure_Mode__c = 'Test';
        solComRef3.Solutions__c =solRef2.id;
        solComRef3.AccountCodeType__c = 'Test-Test';
        solComRef3.AccountCode_Call_Status__c = 'Failure';
        solComRef3.Failure_Point__c=11.0;
        solComRef3.Failure_Measure__c = null;
        solComRef3.name='test';
        solComRef3.Failure_Date__c=date.today();
        solComRef3.AccountCode__c = 'tst';
        solComRef3.AccountCodeEdit__c='test';
        solComRef3.CoveredPartsQty__c='0';
        solComRef3.CampaignPartsPercentage__c='100';
        solComRef3.Type__c = '';
        System.debug('The Solution Component Object');
        solComList.add(solComRef3);

        CSS_Solution_Component__c solComRef1 = CSS_TestData.createSRT(false,jobRef2.Id,solRef2.Id);
        solComRef1.System_Code__c = 'Test';
        solComRef1.name='test';
        solComRef1.Component_Code__c = 'Test';
        solComRef1.Failure_Mode__c = 'Test';
        solComRef1.Solutions__c =solRef2.id;
        solComRef1.AccountCode__c = 'tst';
        solComRef1.AccountCodeEdit__c='test';
        solComRef1.AccountCode_Call_Status__c = 'Failure';
        solComRef1.Failure_Point__c=11.0;
        solComRef1.Failure_Measure__c = null;
        solComRef1.CoveredPartsQty__c='9999999';
        solComRef1.CampaignPartsPercentage__c='100';
        solComRef1.Failure_Date__c=date.today();
        solComRef1.Type__c = '';
        solComList.add(solComRef1);
        insert solComList;

        CSS_Parts_Options__c parts = new CSS_Parts_Options__c();
        parts.Covered__c =0.0;
        parts.Fail_Code__c ='test';
        parts.Service_partnumber__c='test';
        parts.Account_Code__c = 'test1';
        parts.Service_Job__c = jobRef2.id;  
        parts.ReturnToFactory__c = '' ;
        parts.FailurepartId__c=solComRef1.id;
        insert parts;

        CSS_Parts_Options__c parts1 = new CSS_Parts_Options__c();
        parts1.Covered__c =0.0;
        parts1.Fail_Code__c ='test';
        parts1.Service_partnumber__c='test';
        parts1.Account_Code__c = 'test1';
        parts1.Service_Job__c = jobRef2.id;  
        parts1.ReturnToFactory__c = '' ;
        parts1.FailurepartId__c=solComRef.id;
        insert parts1;

        CSS_JobEventTemporary__c JETsys = new CSS_JobEventTemporary__c();
        JETsys.Attribute1__c = 'TH';
        JETsys.Attribute4__c ='TS';
        JETsys.key__c = 'FailCodes';
        JETsys.Attribute3__c = 'TURBO';
        JETsys.Attribute5__c = 'ASSEMBLY';
        JETsys.Attribute7__c='test';
        JETsys.Reason__c = '{\r\n\t\"Header\": {\r\n\t\t\"ReturnCodeDescription\": \"Normal, Successful completion.\",\r\n\t\t\"ReturnCode\": \"ORA-00000\",\r\n\t\t\"MessageIdentifier\": \"S\"\r\n\t},\r\n\t\"DataArea\": [{\r\n\t\t\"SystemCode\": \"WF\",\r\n\t\t\"FailureName\": \"ATC 1795\",\r\n\t\t\"FailureMode\": \"SP\",\r\n\t\t\"FailureID\": \"F30003750\",\r\n\t\t\"ComponentCode\": \"HA\"\r\n\t}]\r\n}';
        insert JETsys;
        CSS_JobEventTemporary__c JETsys3 = new CSS_JobEventTemporary__c();
        JETsys3.Attribute1__c = 'TH';
        JETsys3.Attribute4__c ='TS';
        JETsys3.key__c = 'AccountCodes';
        JETsys3.Attribute3__c = 'TURBO';
        JETsys3.Attribute2__c = 'TURBO-TURBO';
        JETsys3.Attribute5__c = 'ASSEMBLY';
        JETsys3.Attribute7__c='test';
        JETsys3.Reason__c = '{\r\n\t\"Header\": {\r\n\t\t\"ReturnCodeDescription\": \"Normal, Successful completion.\",\r\n\t\t\"ReturnCode\": \"ORA-00000\",\r\n\t\t\"MessageIdentifier\": \"S\"\r\n\t},\r\n\t\"DataArea\": [{\r\n\t\t\"SystemCode\": \"WF\",\r\n\t\t\"FailureName\": \"ATC 1795\",\r\n\t\t\"FailureMode\": \"SP\",\r\n\t\t\"FailureID\": \"F30003750\",\r\n\t\t\"ComponentCode\": \"HA\"\r\n\t}]\r\n}';
        insert JETsys3;

        CSS_JobEventTemporary__c JETsys2 = new CSS_JobEventTemporary__c();
        JETsys2.Attribute1__c = 'TH';
        JETsys2.Attribute4__c ='TS';
        JETsys2.key__c = 'getFailureCodesSRT';
        JETsys2.Attribute3__c = 'ESN;;1234';
        JETsys2.Attribute5__c = 'ASSEMBLY';
        JETsys2.Attribute7__c='test';
        JETsys2.Reason__c = '{\r\n\t\"Header\": {\r\n\t\t\"ReturnCodeDescription\": \"Normal, Successful completion.\",\r\n\t\t\"ReturnCode\": \"ORA-00000\",\r\n\t\t\"MessageIdentifier\": \"S\"\r\n\t},\r\n\t\"DataArea\": [{\r\n\t\t\"SystemCode\": \"WF\",\r\n\t\t\"FailureName\": \"ATC 1795\",\r\n\t\t\"FailureMode\": \"SP\",\r\n\t\t\"FailureID\": \"F30003750\",\r\n\t\t\"ComponentCode\": \"HA\"\r\n\t}]\r\n}';
        insert JETsys2;
        CSS_JobEventTemporary__c JETsys1 = new CSS_JobEventTemporary__c();
        JETsys1.Attribute1__c = 'ISX12 CM2350 X102';
        JETsys1.Attribute2__c ='OK';
        JETsys1.key__c = 'GetFailureCodesSRT';
        JETsys1.Attribute3__c = 'ISX12 CM2350 X102;;0K';
        JETsys1.Attribute5__c = 'ASSEMBLY';
        JETsys1.Reason__c = '{\r\n\t\"Header\": {\r\n\t\t\"ReturnCodeDescription\": \"Normal, Successful completion.\",\r\n\t\t\"ReturnCode\": \"ORA-00000\",\r\n\t\t\"MessageIdentifier\": \"S\"\r\n\t},\r\n\t\"DataArea\": [{\r\n\t\t\"SystemCode\": \"WF\",\r\n\t\t\"FailureName\": \"ATC 1795\",\r\n\t\t\"FailureMode\": \"SP\",\r\n\t\t\"FailureID\": \"F30003750\",\r\n\t\t\"ComponentCode\": \"HA\"\r\n\t}]\r\n}';
        insert JETsys1;

        CSS_JobEventTemporary__c JETsys4 = new CSS_JobEventTemporary__c();
        JETsys4.Attribute1__c = 'test';
        JETsys4.Attribute4__c ='TS';
        JETsys4.key__c = 'FailModes';
        JETsys4.Attribute3__c = 'TURBO';
        JETsys4.Attribute5__c = 'ASSEMBLY';
        JETsys4.Attribute7__c='test';
        JETsys4.Active__c= true;
        JETsys4.Reason__c = '{\r\n\t\"Header\": {\r\n\t\t\"ReturnCodeDescription\": \"Normal, Successful completion.\",\r\n\t\t\"ReturnCode\": \"ORA-00000\",\r\n\t\t\"MessageIdentifier\": \"S\"\r\n\t},\r\n\t\"DataArea\": [{\r\n\t\t\"SystemCode\": \"WF\",\r\n\t\t\"FailureName\": \"ATC 1795\",\r\n\t\t\"FailureMode\": \"SP\",\r\n\t\t\"FailureID\": \"F30003750\",\r\n\t\t\"ComponentCode\": \"HA\"\r\n\t}]\r\n}';
        insert JETsys4;
        CSS_SymptomQA__c symqa1=new CSS_SymptomQA__c();
        symqa1.job_order__c = jobRef2.id;
        symqa1.type__c='SearchString';
        symqa1.user_name__c = null;
        symqa1.name='TESST';
        symqa1.Caption__c = 'akanksha';
        insert symqa1;

        CSS_SymptomQA__c symqa=new CSS_SymptomQA__c();
        symqa.job_order__c = jobRef2.id;
        symqa.type__c='SearchString';
        symqa.user_name__c = null;
        symqa.name='TESST';
        symqa.SearchString__c = symqa1.id;
        symqa.Caption__c = 'akanksha';
        insert symqa;
        map<string,CSS_JobEventTemporary__c> tempevents = new map<string,CSS_JobEventTemporary__c> ();
        tempevents.put('Test',JETsys4);
        tempevents.put('Test',JETsys1);
        tempevents.put('Test',JETsys2);
        tempevents.put('Test',JETsys3);
        tempevents.put('Test',JETsys);
        List<CSS_Fault_Code__c> lstFC1 = new List<CSS_Fault_Code__c>();
        lstFC1.add(fc3);
        PageReference pref;
        pref = new PageReference('/'+jobRef2.id);
        pref.getParameters().put('id',jobRef2.id);
        Test.setCurrentPage(pref);
        CSS_Integration_Details__c cid1 = CSS_TestData.createIntegrationDetails(false);
        cid1.name = 'CSS_SBL_GetPartReturns';
        cid1.ApplicationName__c = 'CSS_SBL_getpartreturn';
        cid1.End_Point__c = 'https://services-stg.cummins.com/csswarranty/getpartreturn';
        insert cid1;

        CSS_Integration_Details__c cid = CSS_TestData.createIntegrationDetails(false);
        cid.name = 'CSS_SBL_WarrantyDetailCoverage';
        cid.ApplicationName__c = 'CSS_SBL_WarrantyDetailCoverage';
        cid.End_Point__c = 'https://services-stg.cummins.com/csswarranty/accodecoverage';
        insert cid;
        Map<String,String> systemCodeMap = new Map<String,String>();
        systemCodeMap.put('THT','THT');
        systemCodeMap.put('tes','THT');
        Map<String,String> custFailureNameList = new Map<String,String>();
        custFailureNameList.put('test','THT');
        custFailureNameList.put('tes','THT');
        Map<String,String> failureNameWithSystemCodeMap = new Map<String,String>();
        failureNameWithSystemCodeMap.put('test','THT');
        failureNameWithSystemCodeMap.put('tes','THT');
        Map<String,String> failureNameWithCompCodeMap = new Map<String,String>();
        failureNameWithCompCodeMap.put('test','THT');
        failureNameWithCompCodeMap.put('tes','THT');
        Map<String,String> FailureNameWithFailureIDMap = new Map<String,String>();
        FailureNameWithFailureIDMap.put('test','THT');
        FailureNameWithFailureIDMap.put('tes','THT');
        Set<String> failureNameList=new Set<String>();
        failureNameList.add('test');
        test.startTest();
        CSS_JobPlanOverviewControllerNew JobPlanOverCont1 = new CSS_JobPlanOverviewControllerNew();
        JobPlanOverCont1.wid=jobRef2.id;
        jobPlanOverCont1.selectedSysCode='THT';
        jobPlanOverCont1.systemCodeMap=systemCodeMap;
        // JobPlanOverCont1.changeSystemcode_New();
        jobPlanOverCont1.selectedCustFName='test';
        //JobPlanOverCont1.changeSystemcode_New();
        jobPlanOverCont1.selectedCustFName='test';
        jobPlanOverCont1.custFailureNameList=custFailureNameList;
        //jobplanovercont1.changeCustFailures_New();
        jobPlanOverCont1.selectedCustFName='on';
        //jobplanovercont1.changeCustFailures_New();
        jobPlanOverCont1.failureNameWithSystemCodeMap=failureNameWithSystemCodeMap;
        jobPlanOverCont1.failureNameWithCompCodeMap=failureNameWithCompCodeMap;
        jobPlanOverCont1.FailureNameWithFailureIDMap=FailureNameWithFailureIDMap;
        jobplanovercont1.failureNameList=failureNameList;
        jobplanovercont1.selectedFName='unlisted';
        //jobplanovercont1.changeFailures_New();
        Test.setMock(HttpCalloutMock.class, new CSS_SRTCompMockup_Test());
        Test.setMock(HttpCalloutMock.class , new CSS_WS_SBL_GetWarrantyDetailCovrg_Test());
        jobplanovercont1.selectedFName='';
        Set<String> failureNameList1=new Set<String>();
        jobplanovercont1.failureNameList=failureNameList1;
        jobplanovercont1.getSRTFailurenamesOnLoad();
        jobplanovercont1.componentId=solComRef1.id;
        jobplanovercont1.failCodeSelected='test';
        jobplanovercont1.partssave();
        List<CSS_Solutions__c> responseValues = new List<CSS_Solutions__c>();
        responseValues.add(solRef2);
        responseValues.add(solRef3);
        Test.setMock(HttpCalloutMock.class, new CSS_GetdsidDetails_Test());
        jobplanovercont1.responseValues=responseValues;
        jobplanovercont1.postRepairList=responseValues;
        jobplanovercont1.showRepairs=true;
        jobplanovercont1.showResolutionWithRepair=false;
        jobplanovercont1.closeSession_close();
        jobplanovercont1.saveAndCloseJob();

        Test.setMock(HttpCalloutMock.class , new CSS_WS_SBL_getPartReturnDetailsMock_Test());

        // jobplanovercont1.tempevents=tempevents;
        jobplanovercont1.jobPlanAction();
        jobplanovercont1.selectedFName=solComRef1.name;
        jobplanovercont1.selectedCompCode=solComRef1.Component_Code__c;
        jobplanovercont1.selectedSysCode=solComRef1.System_Code__c;
        jobplanovercont1.selectedFailMode=solComRef1.Failure_Mode__c;
        Test.setMock(HttpCalloutMock.class , new CSS_WS_SBL_GetWarrantyDetailCovrg_Test());
        jobplanovercont1.checkCoverageNew();
        test.stopTest();
    }
	
	 public static testMethod void TestMethod1New1_one()
    {
        Account acc = new Account();
        acc.name='R1test';
        acc.CSS_DistributorCode__c='03520';
        acc.CSS_DealerCode__c='';
        acc.CSS_FleetCode__c = '';
        acc.CSS_DBCode__c = '04892';
        acc.ERP_System__c = 'One BMS';
       // acc.Type = 'Customer';
        acc.Type='Distributor Branch Account';
        acc.Region__c = 'NORTH AMERICA';//'US and Canada';
        acc.CMI_Account_Status__c = 'Active';
        acc.IAM_Service_Provider_Code__c='56270';
        
         insert acc;
        //Creating Service Job--1
        CSS_Job_Order__c jobRef2 = CSS_TestData.createJobOrder(false); 
        CSS_Job_Order__c jobRef3 = new CSS_Job_Order__c();   
         jobRef3.ApplicationCode__c = '130';
          insert jobRef3;
        list<string> falist=new list<string>();
        string st='Test';
        falist.add(st);
        list<string> partfalist=new list<string>();
        string st1='Test';
        partfalist.add(st1);
        CSS_Integration_Details__c csInt = new CSS_Integration_Details__c();
        csInt.name = 'SRT';
        csInt.ApplicationName__c='SRT';
        csInt.End_Point__c='https://Test-services-dev.cummins.com/css/';
        csInt.IsActive__c=true;
        csInt.Key__c='/Q0w11SmTDJ11dPRgzYfGjycs+HZbtT8sezi/jkT7Ag=';
        csInt.Passcode__c='u9pf3rdOE0SCjXDCgmzRbUlwWQWen7B9993Eh61KI1E=';
        csInt.Username__c='6dpW6v5ekUR2HzkTePJXwgNaMDgo0t53tZgmixV4rfU=';
        insert csint;
        CSS_JobPlanOverviewControllerNew obj=new CSS_JobPlanOverviewControllerNew();
        obj.faultList=falist;
        obj.partlistFAULT=partfalist;

        jobRef2.chevron_page__c='jo';
        jobRef2.BMSWSStatus__c = 'UI';
        jobRef2.CSS_Resolution__c = 'Test';
        jobRef2.General_Symptoms__c='';

        jobRef2.CoverageResponse__c = 'xyz';
        jobRef2.ApplicationCode__c='130';
        jobRef2.Account__c=acc.id;
        upsert jobRef2;

        CSS_Fault_Code__c fc3 = new CSS_Fault_Code__c(FaultCodeR2__c = '441',Related_Fault_Code__c = '234,546');
        fc3.Name = '441';
        fc3.Job_Order__c = jobRef2.Id;
        fc3.Sequence__c = 1; 
        fc3.Fault_Code_Type__c = 'APD-P';
        fc3.Mod__c = '0';
        fc3.isPole__c = false;
        fc3.Number_of_Solutions__c = '1';
        insert fc3;

        CSS_SymptomQA__c symqa12=new CSS_SymptomQA__c();
        symqa12.job_order__c = jobRef2.id;
        symqa12.type__c='SearchString';
        symqa12.user_name__c = null;
        symqa12.name='TESST';
        symqa12.Caption__c = 'akanksha';
        insert symqa12;

        CSS_SymptomQA__c symqa2=new CSS_SymptomQA__c();
        symqa2.job_order__c = jobRef2.id;
        symqa2.type__c='SearchString';
        symqa2.user_name__c = null;
        symqa2.name='TESST';
        symqa2.SearchString__c = symqa12.id;
        symqa2.Caption__c = 'akanksha';
        insert symqa2;

        list<CSS_Solutions__c> sollist=new list<CSS_Solutions__c>();

        CSS_Solutions__c solRef2 =  CSS_TestData.createSolutions(false,jobRef2.Id);
        solRef2.Repair_Response__c='Sucessful';
        solRef2.FaultCode__c=fc3.id;
        solref2.Symptom__c=symqa12.id;

        CSS_Solutions__c solRef3 =  CSS_TestData.createSolutions(false,jobRef2.Id);
        solRef3.Repair_Response__c=null;
        solRef3.FaultCode__c=fc3.id;
        solref3.Symptom__c=symqa2.id;
        sollist.add(solRef2);
        sollist.add(solRef3);
        upsert sollist;

        CSS_SRT__c srtVar = new CSS_SRT__c();
        srtVar.Solution_Number__c = solRef2.id;
        srtVar.Job_Order__c = jobRef2.Id;
        srtVar.SRT_AccessiblityCheck__c=True;
        srtVar.Access_Code_A__c = 65;
        srtVar.name = 'Test'+Math.random();
        srtVar.Type__c = 'Diagnosis';
        srtVar.isPerformed__c =True;

        //insert srtVar;

        CSS_SRT__c srtVar1 = new CSS_SRT__c();
        srtVar1.Solution_Number__c = solRef3.id;
        srtVar1.Job_Order__c = jobRef2.Id;
        srtVar1.SRT_AccessiblityCheck__c=True;
        srtVar1.Access_Code_A__c = 65;
        srtVar1.name = 'Test'+Math.random();
        srtVar1.Type__c = 'Diagnosis';
        srtVar1.isPerformed__c =True;

        //insert srtVar1;

        set<Id> solutionIds = new set<Id>();
        solutionIds.add(solRef2.id);
        solutionIds.add(solRef3.id);

        List<CSS_Solution_Component__c> solComList = new List<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solComRef = CSS_TestData.createSRT(false,jobRef2.Id,solRef2.Id);
        solComRef.System_Code__c = 'Test';

        solComRef.Component_Code__c = 'Test';
        solComRef.Failure_Mode__c = 'Test';
        solComRef.Solutions__c =solRef2.id;
        solComRef.AccountCodeType__c = 'Test-Test';
        solComRef.AccountCode_Call_Status__c = 'Failure';
        solComRef.Failure_Point__c=11.0;
        solComRef.Failure_Measure__c = null;
        solComRef.name='test';
        solComRef.Failure_Date__c=date.today();
        solComRef.AccountCode__c = 'tst';
        solComRef.AccountCodeEdit__c='test';
        solComRef.CoveredPartsQty__c='0';
        solComRef.CampaignPartsPercentage__c='100';
        solComRef.Type__c = '';
        System.debug('The Solution Component Object');
        solComList.add(solComRef);

        CSS_Solution_Component__c solComRef3 = CSS_TestData.createSRT(false,jobRef2.Id,solRef2.Id);
        solComRef3.System_Code__c = 'Test';

        solComRef3.Component_Code__c = 'Test';
        solComRef3.Failure_Mode__c = 'Test';
        solComRef3.Solutions__c =solRef2.id;
        solComRef3.AccountCodeType__c = 'Test-Test';
        solComRef3.AccountCode_Call_Status__c = 'Failure';
        solComRef3.Failure_Point__c=11.0;
        solComRef3.Failure_Measure__c = null;
        solComRef3.name='test';
        solComRef3.Failure_Date__c=date.today();
        solComRef3.AccountCode__c = 'tst';
        solComRef3.AccountCodeEdit__c='test';
        solComRef3.CoveredPartsQty__c='0';
        solComRef3.CampaignPartsPercentage__c='100';
        solComRef3.Type__c = '';
        System.debug('The Solution Component Object');
        solComList.add(solComRef3);

        CSS_Solution_Component__c solComRef1 = CSS_TestData.createSRT(false,jobRef2.Id,solRef2.Id);
        solComRef1.System_Code__c = 'Test';
        solComRef1.name='test';
        solComRef1.Component_Code__c = 'Test';
        solComRef1.Failure_Mode__c = 'Test';
        solComRef1.Solutions__c =solRef2.id;
        solComRef1.AccountCode__c = 'tst';
        solComRef1.AccountCodeEdit__c='test';
        solComRef1.AccountCode_Call_Status__c = 'Failure';
        solComRef1.Failure_Point__c=11.0;
        solComRef1.Failure_Measure__c = null;
        solComRef1.CoveredPartsQty__c='9999999';
        solComRef1.CampaignPartsPercentage__c='100';
        solComRef1.Failure_Date__c=date.today();
        solComRef1.Type__c = '';
        solComList.add(solComRef1);
        insert solComList;

        CSS_Parts_Options__c parts = new CSS_Parts_Options__c();
        parts.Covered__c =0.0;
        parts.Fail_Code__c ='test';
        parts.Service_partnumber__c='test';
        parts.Account_Code__c = 'test1';
        parts.Service_Job__c = jobRef2.id;  
        parts.ReturnToFactory__c = '' ;
        parts.FailurepartId__c=solComRef1.id;
        insert parts;

        CSS_Parts_Options__c parts1 = new CSS_Parts_Options__c();
        parts1.Covered__c =0.0;
        parts1.Fail_Code__c ='test';
        parts1.Service_partnumber__c='test';
        parts1.Account_Code__c = 'test1';
        parts1.Service_Job__c = jobRef2.id;  
        parts1.ReturnToFactory__c = '' ;
        parts1.FailurepartId__c=solComRef.id;
        insert parts1;

        CSS_JobEventTemporary__c JETsys = new CSS_JobEventTemporary__c();
        JETsys.Attribute1__c = 'TH';
        JETsys.Attribute4__c ='TS';
        JETsys.key__c = 'FailCodes';
        JETsys.Attribute3__c = 'TURBO';
        JETsys.Attribute5__c = 'ASSEMBLY';
        JETsys.Attribute7__c='test';
        JETsys.Reason__c = '{\r\n\t\"Header\": {\r\n\t\t\"ReturnCodeDescription\": \"Normal, Successful completion.\",\r\n\t\t\"ReturnCode\": \"ORA-00000\",\r\n\t\t\"MessageIdentifier\": \"S\"\r\n\t},\r\n\t\"DataArea\": [{\r\n\t\t\"SystemCode\": \"WF\",\r\n\t\t\"FailureName\": \"ATC 1795\",\r\n\t\t\"FailureMode\": \"SP\",\r\n\t\t\"FailureID\": \"F30003750\",\r\n\t\t\"ComponentCode\": \"HA\"\r\n\t}]\r\n}';
        insert JETsys;
        CSS_JobEventTemporary__c JETsys3 = new CSS_JobEventTemporary__c();
        JETsys3.Attribute1__c = 'TH';
        JETsys3.Attribute4__c ='TS';
        JETsys3.key__c = 'AccountCodes';
        JETsys3.Attribute3__c = 'TURBO';
        JETsys3.Attribute2__c = 'TURBO-TURBO';
        JETsys3.Attribute5__c = 'ASSEMBLY';
        JETsys3.Attribute7__c='test';
        JETsys3.Reason__c = '{\r\n\t\"Header\": {\r\n\t\t\"ReturnCodeDescription\": \"Normal, Successful completion.\",\r\n\t\t\"ReturnCode\": \"ORA-00000\",\r\n\t\t\"MessageIdentifier\": \"S\"\r\n\t},\r\n\t\"DataArea\": [{\r\n\t\t\"SystemCode\": \"WF\",\r\n\t\t\"FailureName\": \"ATC 1795\",\r\n\t\t\"FailureMode\": \"SP\",\r\n\t\t\"FailureID\": \"F30003750\",\r\n\t\t\"ComponentCode\": \"HA\"\r\n\t}]\r\n}';
        insert JETsys3;

        CSS_JobEventTemporary__c JETsys2 = new CSS_JobEventTemporary__c();
        JETsys2.Attribute1__c = 'TH';
        JETsys2.Attribute4__c ='TS';
        JETsys2.key__c = 'getFailureCodesSRT';
        JETsys2.Attribute3__c = 'ESN;;1234';
        JETsys2.Attribute5__c = 'ASSEMBLY';
        JETsys2.Attribute7__c='test';
        JETsys2.Reason__c = '{\r\n\t\"Header\": {\r\n\t\t\"ReturnCodeDescription\": \"Normal, Successful completion.\",\r\n\t\t\"ReturnCode\": \"ORA-00000\",\r\n\t\t\"MessageIdentifier\": \"S\"\r\n\t},\r\n\t\"DataArea\": [{\r\n\t\t\"SystemCode\": \"WF\",\r\n\t\t\"FailureName\": \"ATC 1795\",\r\n\t\t\"FailureMode\": \"SP\",\r\n\t\t\"FailureID\": \"F30003750\",\r\n\t\t\"ComponentCode\": \"HA\"\r\n\t}]\r\n}';
        insert JETsys2;
        CSS_JobEventTemporary__c JETsys1 = new CSS_JobEventTemporary__c();
        JETsys1.Attribute1__c = 'ISX12 CM2350 X102';
        JETsys1.Attribute2__c ='OK';
        JETsys1.key__c = 'GetFailureCodesSRT';
        JETsys1.Attribute3__c = 'ISX12 CM2350 X102;;0K';
        JETsys1.Attribute5__c = 'ASSEMBLY';
        JETsys1.Reason__c = '{\r\n\t\"Header\": {\r\n\t\t\"ReturnCodeDescription\": \"Normal, Successful completion.\",\r\n\t\t\"ReturnCode\": \"ORA-00000\",\r\n\t\t\"MessageIdentifier\": \"S\"\r\n\t},\r\n\t\"DataArea\": [{\r\n\t\t\"SystemCode\": \"WF\",\r\n\t\t\"FailureName\": \"ATC 1795\",\r\n\t\t\"FailureMode\": \"SP\",\r\n\t\t\"FailureID\": \"F30003750\",\r\n\t\t\"ComponentCode\": \"HA\"\r\n\t}]\r\n}';
        insert JETsys1;

        CSS_JobEventTemporary__c JETsys4 = new CSS_JobEventTemporary__c();
        JETsys4.Attribute1__c = 'test';
        JETsys4.Attribute4__c ='TS';
        JETsys4.key__c = 'FailModes';
        JETsys4.Attribute3__c = 'TURBO';
        JETsys4.Attribute5__c = 'ASSEMBLY';
        JETsys4.Attribute7__c='test';
        JETsys4.Active__c= true;
        JETsys4.Reason__c = '{\r\n\t\"Header\": {\r\n\t\t\"ReturnCodeDescription\": \"Normal, Successful completion.\",\r\n\t\t\"ReturnCode\": \"ORA-00000\",\r\n\t\t\"MessageIdentifier\": \"S\"\r\n\t},\r\n\t\"DataArea\": [{\r\n\t\t\"SystemCode\": \"WF\",\r\n\t\t\"FailureName\": \"ATC 1795\",\r\n\t\t\"FailureMode\": \"SP\",\r\n\t\t\"FailureID\": \"F30003750\",\r\n\t\t\"ComponentCode\": \"HA\"\r\n\t}]\r\n}';
        insert JETsys4;
        CSS_SymptomQA__c symqa1=new CSS_SymptomQA__c();
        symqa1.job_order__c = jobRef2.id;
        symqa1.type__c='SearchString';
        symqa1.user_name__c = null;
        symqa1.name='TESST';
        symqa1.Caption__c = 'akanksha';
        insert symqa1;

        CSS_SymptomQA__c symqa=new CSS_SymptomQA__c();
        symqa.job_order__c = jobRef2.id;
        symqa.type__c='SearchString';
        symqa.user_name__c = null;
        symqa.name='TESST';
        symqa.SearchString__c = symqa1.id;
        symqa.Caption__c = 'akanksha';
        insert symqa;
        map<string,CSS_JobEventTemporary__c> tempevents = new map<string,CSS_JobEventTemporary__c> ();
        tempevents.put('Test',JETsys4);
        tempevents.put('Test',JETsys1);
        tempevents.put('Test',JETsys2);
        tempevents.put('Test',JETsys3);
        tempevents.put('Test',JETsys);
        List<CSS_Fault_Code__c> lstFC1 = new List<CSS_Fault_Code__c>();
        lstFC1.add(fc3);
        PageReference pref;
        pref = new PageReference('/'+jobRef2.id);
        pref.getParameters().put('id',jobRef2.id);
        Test.setCurrentPage(pref);
        CSS_Integration_Details__c cid1 = CSS_TestData.createIntegrationDetails(false);
        cid1.name = 'CSS_SBL_GetPartReturns';
        cid1.ApplicationName__c = 'CSS_SBL_getpartreturn';
        cid1.End_Point__c = 'https://services-stg.cummins.com/csswarranty/getpartreturn';
        insert cid1;

        CSS_Integration_Details__c cid = CSS_TestData.createIntegrationDetails(false);
        cid.name = 'CSS_SBL_WarrantyDetailCoverage';
        cid.ApplicationName__c = 'CSS_SBL_WarrantyDetailCoverage';
        cid.End_Point__c = 'https://services-stg.cummins.com/csswarranty/accodecoverage';
        insert cid;
        Map<String,String> systemCodeMap = new Map<String,String>();
        systemCodeMap.put('THT','THT');
        systemCodeMap.put('tes','THT');
        Map<String,String> custFailureNameList = new Map<String,String>();
        custFailureNameList.put('test','THT');
        custFailureNameList.put('tes','THT');
        Map<String,String> failureNameWithSystemCodeMap = new Map<String,String>();
        failureNameWithSystemCodeMap.put('test','THT');
        failureNameWithSystemCodeMap.put('tes','THT');
        Map<String,String> failureNameWithCompCodeMap = new Map<String,String>();
        failureNameWithCompCodeMap.put('test','THT');
        failureNameWithCompCodeMap.put('tes','THT');
        Map<String,String> FailureNameWithFailureIDMap = new Map<String,String>();
        FailureNameWithFailureIDMap.put('test','THT');
        FailureNameWithFailureIDMap.put('tes','THT');
        Set<String> failureNameList=new Set<String>();
        failureNameList.add('test');
        test.startTest();
        CSS_JobPlanOverviewControllerNew JobPlanOverCont1 = new CSS_JobPlanOverviewControllerNew();
        JobPlanOverCont1.wid=jobRef2.id;
        jobPlanOverCont1.selectedSysCode='THT';
        jobPlanOverCont1.systemCodeMap=systemCodeMap;
        // JobPlanOverCont1.changeSystemcode_New();
        jobPlanOverCont1.selectedCustFName='test';
        //JobPlanOverCont1.changeSystemcode_New();
        jobPlanOverCont1.selectedCustFName='test';
        jobPlanOverCont1.custFailureNameList=custFailureNameList;
        //jobplanovercont1.changeCustFailures_New();
        jobPlanOverCont1.selectedCustFName='on';
        //jobplanovercont1.changeCustFailures_New();
        jobPlanOverCont1.failureNameWithSystemCodeMap=failureNameWithSystemCodeMap;
        jobPlanOverCont1.failureNameWithCompCodeMap=failureNameWithCompCodeMap;
        jobPlanOverCont1.FailureNameWithFailureIDMap=FailureNameWithFailureIDMap;
        jobplanovercont1.failureNameList=failureNameList;
        jobplanovercont1.selectedFName='unlisted';
        //jobplanovercont1.changeFailures_New();
        Test.setMock(HttpCalloutMock.class, new CSS_SRTCompMockup_Test());
        Test.setMock(HttpCalloutMock.class , new CSS_WS_SBL_GetWarrantyDetailCovrg_Test());
        jobplanovercont1.selectedFName='';
        Set<String> failureNameList1=new Set<String>();
        jobplanovercont1.failureNameList=failureNameList1;
        jobplanovercont1.getSRTFailurenamesOnLoad();
        jobplanovercont1.componentId=solComRef1.id;
        jobplanovercont1.failCodeSelected='test';
        jobplanovercont1.partssave();
        List<CSS_Solutions__c> responseValues = new List<CSS_Solutions__c>();
        responseValues.add(solRef2);
        responseValues.add(solRef3);
        Test.setMock(HttpCalloutMock.class, new CSS_GetdsidDetails_Test());
        jobplanovercont1.responseValues=responseValues;
        jobplanovercont1.postRepairList=responseValues;
        jobplanovercont1.showRepairs=true;
        jobplanovercont1.showResolutionWithRepair=false;
        jobplanovercont1.closeSession_close();
        //jobplanovercont1.saveAndCloseJob();

        Test.setMock(HttpCalloutMock.class , new CSS_WS_SBL_getPartReturnDetailsMock_Test());

        // jobplanovercont1.tempevents=tempevents;
        jobplanovercont1.jobPlanAction();
        jobplanovercont1.selectedFName=solComRef1.name;
        jobplanovercont1.selectedCompCode=solComRef1.Component_Code__c;
        jobplanovercont1.selectedSysCode=solComRef1.System_Code__c;
        jobplanovercont1.selectedFailMode=solComRef1.Failure_Mode__c;
        Test.setMock(HttpCalloutMock.class , new CSS_WS_SBL_GetWarrantyDetailCovrg_Test());
        jobplanovercont1.checkCoverageNew();
        test.stopTest();
    }
     public static testMethod void TestMethod1New1_Two()
    {
        Account acc = new Account();
        acc.name='R1test';
        acc.CSS_DistributorCode__c='03520';
        acc.CSS_DealerCode__c='';
        acc.CSS_FleetCode__c = '';
        acc.CSS_DBCode__c = '04892';
        acc.ERP_System__c = 'One BMS';
       // acc.Type = 'Customer';
        acc.Type='Distributor Branch Account';
        acc.Region__c = 'NORTH AMERICA';//'US and Canada';
        acc.CMI_Account_Status__c = 'Active';
        acc.IAM_Service_Provider_Code__c='56270';
        
         insert acc;
        //Creating Service Job--1
        CSS_Job_Order__c jobRef2 = CSS_TestData.createJobOrder(false); 
        CSS_Job_Order__c jobRef3 = new CSS_Job_Order__c();   
         jobRef3.ApplicationCode__c = '130';
          insert jobRef3;
        list<string> falist=new list<string>();
        string st='Test';
        falist.add(st);
        list<string> partfalist=new list<string>();
        string st1='Test';
        partfalist.add(st1);
        CSS_Integration_Details__c csInt = new CSS_Integration_Details__c();
        csInt.name = 'SRT';
        csInt.ApplicationName__c='SRT';
        csInt.End_Point__c='https://Test-services-dev.cummins.com/css/';
        csInt.IsActive__c=true;
        csInt.Key__c='/Q0w11SmTDJ11dPRgzYfGjycs+HZbtT8sezi/jkT7Ag=';
        csInt.Passcode__c='u9pf3rdOE0SCjXDCgmzRbUlwWQWen7B9993Eh61KI1E=';
        csInt.Username__c='6dpW6v5ekUR2HzkTePJXwgNaMDgo0t53tZgmixV4rfU=';
        insert csint;
        
        id wid = apexpages.currentpage().getparameters().put('id',jobRef2.id);
        
        CSS_JobPlanOverviewControllerNew obj=new CSS_JobPlanOverviewControllerNew();
        obj.faultList=falist;
        obj.partlistFAULT=partfalist;

        jobRef2.chevron_page__c='jo';
        jobRef2.BMSWSStatus__c = 'UI';
        jobRef2.CSS_Resolution__c = 'Test';
        jobRef2.General_Symptoms__c='';

        jobRef2.CoverageResponse__c = 'xyz';
       jobRef2.ApplicationCode__c='130';
        jobRef2.Account__c=acc.id;
        upsert jobRef2;

        CSS_Fault_Code__c fc3 = new CSS_Fault_Code__c(FaultCodeR2__c = '441',Related_Fault_Code__c = '234,546');
        fc3.Name = '441';
        fc3.Job_Order__c = jobRef2.Id;
        fc3.Sequence__c = 1; 
        fc3.Fault_Code_Type__c = 'APD-P';
        fc3.Mod__c = '0';
        fc3.isPole__c = false;
        fc3.Number_of_Solutions__c = '1';
        insert fc3;

        CSS_SymptomQA__c symqa12=new CSS_SymptomQA__c();
        symqa12.job_order__c = jobRef2.id;
        symqa12.type__c='SearchString';
        symqa12.user_name__c = null;
        symqa12.name='TESST';
        symqa12.Caption__c = 'akanksha';
        insert symqa12;

        CSS_SymptomQA__c symqa2=new CSS_SymptomQA__c();
        symqa2.job_order__c = jobRef2.id;
        symqa2.type__c='SearchString';
        symqa2.user_name__c = null;
        symqa2.name='TESST';
        symqa2.SearchString__c = symqa12.id;
        symqa2.Caption__c = 'akanksha';
        insert symqa2;

        list<CSS_Solutions__c> sollist=new list<CSS_Solutions__c>();

        CSS_Solutions__c solRef2 =  CSS_TestData.createSolutions(false,jobRef2.Id);
        solRef2.Repair_Response__c='Sucessful';
        solRef2.FaultCode__c=fc3.id;
        solref2.Symptom__c=symqa12.id;

        CSS_Solutions__c solRef3 =  CSS_TestData.createSolutions(false,jobRef2.Id);
        solRef3.Repair_Response__c=null;
        solRef3.FaultCode__c=fc3.id;
        solref3.Symptom__c=symqa2.id;
        sollist.add(solRef2);
        sollist.add(solRef3);
        upsert sollist;

        CSS_SRT__c srtVar = new CSS_SRT__c();
        srtVar.Solution_Number__c = solRef2.id;
        srtVar.Job_Order__c = jobRef2.Id;
        srtVar.SRT_AccessiblityCheck__c=True;
        srtVar.Access_Code_A__c = 65;
        srtVar.name = 'Test'+Math.random();
        srtVar.Type__c = 'Diagnosis';
        srtVar.isPerformed__c =True;

        //insert srtVar;

        CSS_SRT__c srtVar1 = new CSS_SRT__c();
        srtVar1.Solution_Number__c = solRef3.id;
        srtVar1.Job_Order__c = jobRef2.Id;
        srtVar1.SRT_AccessiblityCheck__c=True;
        srtVar1.Access_Code_A__c = 65;
        srtVar1.name = 'Test'+Math.random();
        srtVar1.Type__c = 'Diagnosis';
        srtVar1.isPerformed__c =True;

        //insert srtVar1;

        set<Id> solutionIds = new set<Id>();
        solutionIds.add(solRef2.id);
        solutionIds.add(solRef3.id);

        List<CSS_Solution_Component__c> solComList = new List<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solComRef = CSS_TestData.createSRT(false,jobRef2.Id,solRef2.Id);
        solComRef.System_Code__c = 'Test';

        solComRef.Component_Code__c = 'Test';
        solComRef.Failure_Mode__c = 'Test';
        solComRef.Solutions__c =solRef2.id;
        solComRef.AccountCodeType__c = 'Test-Test';
        solComRef.AccountCode_Call_Status__c = 'Failure';
        solComRef.Failure_Point__c=11.0;
        solComRef.Failure_Measure__c = 'test';
        solComRef.name='test';
        solComRef.Failure_Date__c=date.today();
        solComRef.AccountCode__c = 'tst';
        solComRef.AccountCodeEdit__c='test';
        solComRef.CoveredPartsQty__c='0';
        solComRef.CampaignPartsPercentage__c='100';
        solComRef.Type__c = '';
        System.debug('The Solution Component Object');
        solComList.add(solComRef);

        CSS_Solution_Component__c solComRef3 = CSS_TestData.createSRT(false,jobRef2.Id,solRef2.Id);
        solComRef3.System_Code__c = 'Test';

        solComRef3.Component_Code__c = 'Test';
        solComRef3.Failure_Mode__c = 'Test';
        solComRef3.Solutions__c =solRef2.id;
        solComRef3.AccountCodeType__c = 'Test-Test';
        solComRef3.AccountCode_Call_Status__c = 'Failure';
        solComRef3.Failure_Point__c=11.0;
        solComRef3.Failure_Measure__c = 'test';
        solComRef3.name='test';
        solComRef3.Failure_Date__c=date.today();
        solComRef3.AccountCode__c = 'tst';
        solComRef3.AccountCodeEdit__c='test';
        solComRef3.CoveredPartsQty__c='0';
        solComRef3.CampaignPartsPercentage__c='100';
        solComRef3.Type__c = '';
        System.debug('The Solution Component Object');
        solComList.add(solComRef3);

        CSS_Solution_Component__c solComRef1 = CSS_TestData.createSRT(false,jobRef2.Id,solRef2.Id);
        solComRef1.System_Code__c = 'Test';
        solComRef1.name='test';
        solComRef1.Component_Code__c = 'Test';
        solComRef1.Failure_Mode__c = 'Test';
        solComRef1.Solutions__c =solRef2.id;
        solComRef1.AccountCode__c = 'tst';
        solComRef1.AccountCodeEdit__c='test';
        solComRef1.AccountCode_Call_Status__c = 'Failure';
        solComRef1.Failure_Point__c=11.0;
        solComRef1.Failure_Measure__c = 'test';
        solComRef1.CoveredPartsQty__c='9999999';
        solComRef1.CampaignPartsPercentage__c='100';
        solComRef1.Failure_Date__c=date.today();
        solComRef1.Type__c = '';
        solComList.add(solComRef1);
        insert solComList;

        CSS_Parts_Options__c parts = new CSS_Parts_Options__c();
        parts.Covered__c =0.0;
        parts.Fail_Code__c ='test';
        parts.Service_partnumber__c='test';
        parts.Account_Code__c = 'test1';
        parts.Service_Job__c = jobRef2.id;  
        parts.ReturnToFactory__c = '' ;
        parts.FailurepartId__c=solComRef1.id;
        insert parts;

        CSS_Parts_Options__c parts1 = new CSS_Parts_Options__c();
        parts1.Covered__c =0.0;
        parts1.Fail_Code__c ='test';
        parts1.Service_partnumber__c='test';
        parts1.Account_Code__c = 'test1';
        parts1.Service_Job__c = jobRef2.id;  
        parts1.ReturnToFactory__c = '' ;
        parts1.FailurepartId__c=solComRef.id;
        insert parts1;

        CSS_JobEventTemporary__c JETsys = new CSS_JobEventTemporary__c();
        JETsys.Attribute1__c = 'TH';
        JETsys.Attribute4__c ='TS';
        JETsys.key__c = 'FailCodes';
        JETsys.Attribute3__c = 'TURBO';
        JETsys.Attribute5__c = 'ASSEMBLY';
        JETsys.Attribute7__c='test';
        JETsys.Reason__c = '{\r\n\t\"Header\": {\r\n\t\t\"ReturnCodeDescription\": \"Normal, Successful completion.\",\r\n\t\t\"ReturnCode\": \"ORA-00000\",\r\n\t\t\"MessageIdentifier\": \"S\"\r\n\t},\r\n\t\"DataArea\": [{\r\n\t\t\"SystemCode\": \"WF\",\r\n\t\t\"FailureName\": \"ATC 1795\",\r\n\t\t\"FailureMode\": \"SP\",\r\n\t\t\"FailureID\": \"F30003750\",\r\n\t\t\"ComponentCode\": \"HA\"\r\n\t}]\r\n}';
        insert JETsys;
        CSS_JobEventTemporary__c JETsys3 = new CSS_JobEventTemporary__c();
        JETsys3.Attribute1__c = 'TH';
        JETsys3.Attribute4__c ='TS';
        JETsys3.key__c = 'AccountCodes';
        JETsys3.Attribute3__c = 'TURBO';
        JETsys3.Attribute2__c = 'TURBO-TURBO';
        JETsys3.Attribute5__c = 'ASSEMBLY';
        JETsys3.Attribute7__c='test';
        JETsys3.Reason__c = '{\r\n\t\"Header\": {\r\n\t\t\"ReturnCodeDescription\": \"Normal, Successful completion.\",\r\n\t\t\"ReturnCode\": \"ORA-00000\",\r\n\t\t\"MessageIdentifier\": \"S\"\r\n\t},\r\n\t\"DataArea\": [{\r\n\t\t\"SystemCode\": \"WF\",\r\n\t\t\"FailureName\": \"ATC 1795\",\r\n\t\t\"FailureMode\": \"SP\",\r\n\t\t\"FailureID\": \"F30003750\",\r\n\t\t\"ComponentCode\": \"HA\"\r\n\t}]\r\n}';
        insert JETsys3;

        CSS_JobEventTemporary__c JETsys2 = new CSS_JobEventTemporary__c();
        JETsys2.Attribute1__c = 'TH';
        JETsys2.Attribute4__c ='TS';
        JETsys2.key__c = 'getFailureCodesSRT';
        JETsys2.Attribute3__c = 'ESN;;1234';
        JETsys2.Attribute5__c = 'ASSEMBLY';
        JETsys2.Attribute7__c='test';
        JETsys2.Reason__c = '{\r\n\t\"Header\": {\r\n\t\t\"ReturnCodeDescription\": \"Normal, Successful completion.\",\r\n\t\t\"ReturnCode\": \"ORA-00000\",\r\n\t\t\"MessageIdentifier\": \"S\"\r\n\t},\r\n\t\"DataArea\": [{\r\n\t\t\"SystemCode\": \"WF\",\r\n\t\t\"FailureName\": \"ATC 1795\",\r\n\t\t\"FailureMode\": \"SP\",\r\n\t\t\"FailureID\": \"F30003750\",\r\n\t\t\"ComponentCode\": \"HA\"\r\n\t}]\r\n}';
        insert JETsys2;
        CSS_JobEventTemporary__c JETsys1 = new CSS_JobEventTemporary__c();
        JETsys1.Attribute1__c = 'ISX12 CM2350 X102';
        JETsys1.Attribute2__c ='OK';
        JETsys1.key__c = 'GetFailureCodesSRT';
        JETsys1.Attribute3__c = 'ISX12 CM2350 X102;;0K';
        JETsys1.Attribute5__c = 'ASSEMBLY';
        JETsys1.Reason__c = '{\r\n\t\"Header\": {\r\n\t\t\"ReturnCodeDescription\": \"Normal, Successful completion.\",\r\n\t\t\"ReturnCode\": \"ORA-00000\",\r\n\t\t\"MessageIdentifier\": \"S\"\r\n\t},\r\n\t\"DataArea\": [{\r\n\t\t\"SystemCode\": \"WF\",\r\n\t\t\"FailureName\": \"ATC 1795\",\r\n\t\t\"FailureMode\": \"SP\",\r\n\t\t\"FailureID\": \"F30003750\",\r\n\t\t\"ComponentCode\": \"HA\"\r\n\t}]\r\n}';
        insert JETsys1;

        CSS_JobEventTemporary__c JETsys4 = new CSS_JobEventTemporary__c();
        JETsys4.Attribute1__c = 'test';
        JETsys4.Attribute4__c ='TS';
        JETsys4.key__c = 'FailModes';
        JETsys4.Attribute3__c = 'TURBO';
        JETsys4.Attribute5__c = 'ASSEMBLY';
        JETsys4.Attribute7__c='test';
        JETsys4.Active__c= true;
        JETsys4.Reason__c = '{\r\n\t\"Header\": {\r\n\t\t\"ReturnCodeDescription\": \"Normal, Successful completion.\",\r\n\t\t\"ReturnCode\": \"ORA-00000\",\r\n\t\t\"MessageIdentifier\": \"S\"\r\n\t},\r\n\t\"DataArea\": [{\r\n\t\t\"SystemCode\": \"WF\",\r\n\t\t\"FailureName\": \"ATC 1795\",\r\n\t\t\"FailureMode\": \"SP\",\r\n\t\t\"FailureID\": \"F30003750\",\r\n\t\t\"ComponentCode\": \"HA\"\r\n\t}]\r\n}';
        insert JETsys4;
        CSS_SymptomQA__c symqa1=new CSS_SymptomQA__c();
        symqa1.job_order__c = jobRef2.id;
        symqa1.type__c='SearchString';
        symqa1.user_name__c = null;
        symqa1.name='TESST';
        symqa1.Caption__c = 'akanksha';
        insert symqa1;

        CSS_SymptomQA__c symqa=new CSS_SymptomQA__c();
        symqa.job_order__c = jobRef2.id;
        symqa.type__c='SearchString';
        symqa.user_name__c = null;
        symqa.name='TESST';
        symqa.SearchString__c = symqa1.id;
        symqa.Caption__c = 'akanksha';
        insert symqa;
        map<string,CSS_JobEventTemporary__c> tempevents = new map<string,CSS_JobEventTemporary__c> ();
        tempevents.put('Test',JETsys4);
        tempevents.put('Test',JETsys1);
        tempevents.put('Test',JETsys2);
        tempevents.put('Test',JETsys3);
        tempevents.put('Test',JETsys);
        List<CSS_Fault_Code__c> lstFC1 = new List<CSS_Fault_Code__c>();
        lstFC1.add(fc3);
        PageReference pref;
        pref = new PageReference('/'+jobRef2.id);
        pref.getParameters().put('id',jobRef2.id);
        Test.setCurrentPage(pref);
        CSS_Integration_Details__c cid1 = CSS_TestData.createIntegrationDetails(false);
        cid1.name = 'CSS_SBL_GetPartReturns';
        cid1.ApplicationName__c = 'CSS_SBL_getpartreturn';
        cid1.End_Point__c = 'https://services-stg.cummins.com/csswarranty/getpartreturn';
        insert cid1;

        CSS_Integration_Details__c cid = CSS_TestData.createIntegrationDetails(false);
        cid.name = 'CSS_SBL_WarrantyDetailCoverage';
        cid.ApplicationName__c = 'CSS_SBL_WarrantyDetailCoverage';
        cid.End_Point__c = 'https://services-stg.cummins.com/csswarranty/accodecoverage';
        insert cid;
        Map<String,String> systemCodeMap = new Map<String,String>();
        systemCodeMap.put('THT','THT');
        systemCodeMap.put('tes','THT');
        Map<String,String> custFailureNameList = new Map<String,String>();
        custFailureNameList.put('test','THT');
        custFailureNameList.put('tes','THT');
        Map<String,String> failureNameWithSystemCodeMap = new Map<String,String>();
        failureNameWithSystemCodeMap.put('test','THT');
        failureNameWithSystemCodeMap.put('tes','THT');
        Map<String,String> failureNameWithCompCodeMap = new Map<String,String>();
        failureNameWithCompCodeMap.put('test','THT');
        failureNameWithCompCodeMap.put('tes','THT');
        Map<String,String> FailureNameWithFailureIDMap = new Map<String,String>();
        FailureNameWithFailureIDMap.put('test','THT');
        FailureNameWithFailureIDMap.put('tes','THT');
        Set<String> failureNameList=new Set<String>();
        failureNameList.add('test');
        test.startTest();
        CSS_JobPlanOverviewControllerNew JobPlanOverCont1 = new CSS_JobPlanOverviewControllerNew();
        JobPlanOverCont1.wid = apexpages.currentpage().getparameters().put('id',jobRef2.id);
        //JobPlanOverCont1.wid=jobRef2.id;
        jobPlanOverCont1.selectedSysCode='THT';
        jobPlanOverCont1.systemCodeMap=systemCodeMap;
        // JobPlanOverCont1.changeSystemcode_New();
        jobPlanOverCont1.selectedCustFName='test';
        //JobPlanOverCont1.changeSystemcode_New();
        jobPlanOverCont1.selectedCustFName='test';
        jobPlanOverCont1.custFailureNameList=custFailureNameList;
        //jobplanovercont1.changeCustFailures_New();
        jobPlanOverCont1.selectedCustFName='on';
        //jobplanovercont1.changeCustFailures_New();
        jobPlanOverCont1.failureNameWithSystemCodeMap=failureNameWithSystemCodeMap;
        jobPlanOverCont1.failureNameWithCompCodeMap=failureNameWithCompCodeMap;
        jobPlanOverCont1.FailureNameWithFailureIDMap=FailureNameWithFailureIDMap;
        jobplanovercont1.failureNameList=failureNameList;
        jobplanovercont1.selectedFName='unlisted';
        //jobplanovercont1.changeFailures_New();
        Test.setMock(HttpCalloutMock.class, new CSS_SRTCompMockup_Test());
        Test.setMock(HttpCalloutMock.class , new CSS_WS_SBL_GetWarrantyDetailCovrg_Test());
        jobplanovercont1.selectedFName='';
        Set<String> failureNameList1=new Set<String>();
        jobplanovercont1.failureNameList=failureNameList1;
        jobplanovercont1.getSRTFailurenamesOnLoad();
        jobplanovercont1.componentId=solComRef1.id;
        jobplanovercont1.failCodeSelected='test';
        jobplanovercont1.partssave();
        List<CSS_Solutions__c> responseValues = new List<CSS_Solutions__c>();
        responseValues.add(solRef2);
        responseValues.add(solRef3);
        Test.setMock(HttpCalloutMock.class, new CSS_GetdsidDetails_Test());
        jobplanovercont1.responseValues=responseValues;
        jobplanovercont1.postRepairList=responseValues;
        jobplanovercont1.showRepairs=true;
        jobplanovercont1.showResolutionWithRepair=false;
        jobplanovercont1.closeSession_close();
        //jobplanovercont1.saveAndCloseJob();

        Test.setMock(HttpCalloutMock.class , new CSS_WS_SBL_getPartReturnDetailsMock_Test());

        // jobplanovercont1.tempevents=tempevents;
        jobplanovercont1.jobPlanAction();
        jobplanovercont1.selectedFName=solComRef1.name;
        jobplanovercont1.selectedCompCode=solComRef1.Component_Code__c;
        jobplanovercont1.selectedSysCode=solComRef1.System_Code__c;
        jobplanovercont1.selectedFailMode=solComRef1.Failure_Mode__c;
        Test.setMock(HttpCalloutMock.class , new CSS_WS_SBL_GetWarrantyDetailCovrg_Test());
        jobplanovercont1.checkCoverageNew();
        test.stopTest();
    }
	
    public static testMethod void TestMethod1New111()
    {
        Account acc = new Account();
        acc.name='R1test';
        acc.CSS_DistributorCode__c='03520';
        acc.CSS_DealerCode__c='';
        acc.CSS_FleetCode__c = '';
        acc.CSS_DBCode__c = '04892';
        acc.ERP_System__c = 'One BMS';
        acc.Type = 'Customer';
        acc.Region__c = 'NORTH AMERICA';//'US and Canada';
        acc.CMI_Account_Status__c = 'Active';
        acc.IAM_Service_Provider_Code__c='56270';
        insert acc;
        //Creating Service Job--1
        CSS_Job_Order__c jobRef2 = CSS_TestData.createJobOrder(false); 
        //CSS_Job_Order__c jobRef2 = new CSS_Job_Order__c();    
        list<string> falist=new list<string>();
        string st='Test';
        falist.add(st);
        list<string> partfalist=new list<string>();
        string st1='Test';
        partfalist.add(st1);
        CSS_Integration_Details__c csInt = new CSS_Integration_Details__c();
        csInt.name = 'SRT';
        csInt.ApplicationName__c='SRT';
        csInt.End_Point__c='https://Test-services-dev.cummins.com/css/';
        csInt.IsActive__c=true;
        csInt.Key__c='/Q0w11SmTDJ11dPRgzYfGjycs+HZbtT8sezi/jkT7Ag=';
        csInt.Passcode__c='u9pf3rdOE0SCjXDCgmzRbUlwWQWen7B9993Eh61KI1E=';
        csInt.Username__c='6dpW6v5ekUR2HzkTePJXwgNaMDgo0t53tZgmixV4rfU=';
        insert csint;
        CSS_JobPlanOverviewControllerNew obj=new CSS_JobPlanOverviewControllerNew();
        obj.faultList=falist;
        obj.partlistFAULT=partfalist;

        jobRef2.chevron_page__c='jo';
        jobRef2.BMSWSStatus__c = 'UI';
        jobRef2.CSS_Resolution__c = 'Test';
        jobRef2.General_Symptoms__c='';

        jobRef2.CoverageResponse__c = 'xyz';
        jobRef2.ApplicationCode__c='130';
        jobRef2.Account__c=acc.id;
        upsert jobRef2;

        CSS_Fault_Code__c fc3 = new CSS_Fault_Code__c(FaultCodeR2__c = '441',Related_Fault_Code__c = '234,546');
        fc3.Name = '441';
        fc3.Job_Order__c = jobRef2.Id;
        fc3.Sequence__c = 1; 
        fc3.Fault_Code_Type__c = 'APD-P';
        fc3.Mod__c = '0';
        fc3.isPole__c = false;
        fc3.Number_of_Solutions__c = '1';
        insert fc3;
        CSS_SymptomQA__c symqa12=new CSS_SymptomQA__c();
        symqa12.job_order__c = jobRef2.id;
        symqa12.type__c='SearchString';
        symqa12.user_name__c = null;
        symqa12.name='TESST';
        symqa12.Caption__c = 'akanksha';
        insert symqa12;

        CSS_SymptomQA__c symqa2=new CSS_SymptomQA__c();
        symqa2.job_order__c = jobRef2.id;
        symqa2.type__c='SearchString';
        symqa2.user_name__c = null;
        symqa2.name='TESST';
        symqa2.SearchString__c = symqa12.id;
        symqa2.Caption__c = 'akanksha';
        insert symqa2;

        list<CSS_Solutions__c> sollist=new list<CSS_Solutions__c>();

        CSS_Solutions__c solRef2 =  CSS_TestData.createSolutions(false,jobRef2.Id);
        solRef2.Repair_Response__c='Sucessful';
        solRef2.FaultCode__c=fc3.id;
        solref2.Symptom__c=symqa12.id;

        CSS_Solutions__c solRef3 =  CSS_TestData.createSolutions(false,jobRef2.Id);
        solRef3.Repair_Response__c=null;
        solRef3.FaultCode__c=fc3.id;
        solref3.Symptom__c=symqa2.id;
        sollist.add(solRef2);
        sollist.add(solRef3);
        upsert sollist;



        set<Id> solutionIds = new set<Id>();
        solutionIds.add(solRef2.id);
        solutionIds.add(solRef3.id);

        List<CSS_Solution_Component__c> solComList = new List<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solComRef = CSS_TestData.createSRT(false,jobRef2.Id,solRef2.Id);
        solComRef.System_Code__c = 'Test';

        solComRef.Component_Code__c = 'Test';
        solComRef.Failure_Mode__c = 'Test';
        solComRef.Solutions__c =solRef2.id;
        solComRef.AccountCodeType__c = 'Test-Test';
        solComRef.AccountCode_Call_Status__c = 'Failure';
        solComRef.Failure_Point__c=11.0;
        solComRef.Failure_Measure__c = null;
        solComRef.name='test';
        solComRef.Failure_Date__c=date.today();
        solComRef.AccountCode__c = 'tst';
        solComRef.AccountCodeEdit__c='test';
        solComRef.CoveredPartsQty__c='0';
        solComRef.CampaignPartsPercentage__c='100';
        solComRef.Type__c = '';
        solComRef.CSS_CoverageType__c='POL';
        System.debug('The Solution Component Object');
        solComList.add(solComRef);

        CSS_Solution_Component__c solComRef3 = CSS_TestData.createSRT(false,jobRef2.Id,solRef2.Id);
        solComRef3.System_Code__c = 'Test';

        solComRef3.Component_Code__c = 'Test';
        solComRef3.Failure_Mode__c = 'Test';
        solComRef3.Solutions__c =solRef2.id;
        solComRef3.AccountCodeType__c = 'Test-Test';
        solComRef3.AccountCode_Call_Status__c = 'Failure';
        solComRef3.Failure_Point__c=11.0;
        solComRef3.Failure_Measure__c = null;
        solComRef3.name='test';
        solComRef3.Failure_Date__c=date.today();
        solComRef3.AccountCode__c = 'tst';
        solComRef3.AccountCodeEdit__c='test';
        solComRef3.CoveredPartsQty__c='0';
        solComRef3.CampaignPartsPercentage__c='100';
        solComRef3.CSS_CoverageType__c='POL';
        solComRef3.Type__c = '';
        System.debug('The Solution Component Object');
        solComList.add(solComRef3);

        CSS_Solution_Component__c solComRef1 = CSS_TestData.createSRT(false,jobRef2.Id,solRef2.Id);
        solComRef1.System_Code__c = 'Test';
        solComRef1.name='test';
        solComRef1.Component_Code__c = 'Test';
        solComRef1.Failure_Mode__c = 'Test';
        solComRef1.Solutions__c =solRef2.id;
        solComRef1.AccountCode__c = 'tst';
        solComRef1.AccountCodeEdit__c='test';
        solComRef1.AccountCode_Call_Status__c = 'Failure';
        solComRef1.Failure_Point__c=11.0;
        solComRef1.Failure_Measure__c = null;
        solComRef1.CoveredPartsQty__c='9999999';
        solComRef1.CampaignPartsPercentage__c='100';
        solComRef1.Failure_Date__c=date.today();
        solComRef1.Type__c = '';
        solComRef1.CSS_CoverageType__c='POL';
        solComList.add(solComRef1);
        insert solComList;
        CSS_SRT__c srtVar = new CSS_SRT__c();
        srtVar.Solution_Number__c = solRef2.id;
        srtVar.Job_Order__c = jobRef2.Id;
        srtVar.SRT_AccessiblityCheck__c=True;
        srtVar.Access_Code_A__c = 65;
        srtVar.name = 'Test'+Math.random();
        srtVar.Type__c = 'Repair';
        srtVar.isPerformed__c =True;
        srtVar.Component_Id__c=solComRef1.id;
        insert srtVar;

        CSS_SRT__c srtVar1 = new CSS_SRT__c();
        srtVar1.Solution_Number__c = solRef3.id;
        srtVar1.Job_Order__c = jobRef2.Id;
        srtVar1.SRT_AccessiblityCheck__c=True;
        srtVar1.Access_Code_A__c = 65;
        srtVar1.name = 'Test'+Math.random();
        srtVar1.Type__c = 'Repair';
        srtVar1.Component_Id__c=solComRef1.id;
        srtVar1.isPerformed__c =True;

        insert srtVar1;
        CSS_Parts_Options__c parts = new CSS_Parts_Options__c();
        parts.Covered__c =0.0;
        parts.Fail_Code__c ='test';
        parts.Service_partnumber__c='test';
        parts.Account_Code__c = 'test1';
        parts.Service_Job__c = jobRef2.id;  
        parts.ReturnToFactory__c = '' ;
        parts.FailurepartId__c=solComRef1.id;
        insert parts;

        CSS_Parts_Options__c parts1 = new CSS_Parts_Options__c();
        parts1.Covered__c =0.0;
        parts1.Fail_Code__c ='test';
        parts1.Service_partnumber__c='test';
        parts1.Account_Code__c = 'test1';
        parts1.Service_Job__c = jobRef2.id;  
        parts1.ReturnToFactory__c = '' ;
        parts1.FailurepartId__c=solComRef.id;
        insert parts1;


        List<CSS_JobEventTemporary__c> lstjobeve =  new List<CSS_JobEventTemporary__c>();
        CSS_JobEventTemporary__c JETsys11 = new CSS_JobEventTemporary__c();
        JETsys11.Attribute1__c = 'OTH';
        JETsys11.Attribute4__c ='TS';
        JETsys11.key__c ='AccountCodes';
        JETsys11.Attribute3__c = 'TURBO';
        JETsys11.Attribute5__c = 'ASSEMBLY';
        insert JETsys11;
        lstjobeve.add(JETsys11);
        CSS_JobEventTemporary__c JETsys12 = new CSS_JobEventTemporary__c();
        JETsys12.Attribute1__c = 'NPW';
        JETsys12.Attribute2__c ='OK';
        JETsys12.key__c = 'AccountCodes';
        JETsys12.Attribute3__c = 'ISX12 CM2350 X102;;0K';
        JETsys12.Attribute5__c = 'ASSEMBLY';
        JETsys12.Reason__c = '{\r\n\t\"Header\": {\r\n\t\t\"ReturnCodeDescription\": \"Normal, Successful completion.\",\r\n\t\t\"ReturnCode\": \"ORA-00000\",\r\n\t\t\"MessageIdentifier\": \"S\"\r\n\t},\r\n\t\"DataArea\": [{\r\n\t\t\"SystemCode\": \"WF\",\r\n\t\t\"FailureName\": \"ATC 1795\",\r\n\t\t\"FailureMode\": \"SP\",\r\n\t\t\"FailureID\": \"F30003750\",\r\n\t\t\"ComponentCode\": \"HA\"\r\n\t}]\r\n}';
        insert JETsys12;
        lstjobeve.add(JETsys12);


        CSS_JobEventTemporary__c JETsys = new CSS_JobEventTemporary__c();
        JETsys.Attribute1__c = 'TH';
        JETsys.Attribute4__c ='TS';
        JETsys.key__c = 'FailCodes';
        JETsys.Attribute3__c = 'TURBO';
        JETsys.Attribute5__c = 'ASSEMBLY';
        JETsys.Attribute7__c='test';
        JETsys.Reason__c = '{\r\n\t\"Header\": {\r\n\t\t\"ReturnCodeDescription\": \"Normal, Successful completion.\",\r\n\t\t\"ReturnCode\": \"ORA-00000\",\r\n\t\t\"MessageIdentifier\": \"S\"\r\n\t},\r\n\t\"DataArea\": [{\r\n\t\t\"SystemCode\": \"WF\",\r\n\t\t\"FailureName\": \"ATC 1795\",\r\n\t\t\"FailureMode\": \"SP\",\r\n\t\t\"FailureID\": \"F30003750\",\r\n\t\t\"ComponentCode\": \"HA\"\r\n\t}]\r\n}';
        insert JETsys;

        CSS_JobEventTemporary__c JETsys2 = new CSS_JobEventTemporary__c();
        JETsys2.Attribute1__c = 'TH';
        JETsys2.Attribute4__c ='TS';
        JETsys2.key__c = 'getFailureCodesSRT';
        JETsys2.Attribute3__c = 'ESN;;1234';
        JETsys2.Attribute5__c = 'ASSEMBLY';
        JETsys2.Attribute7__c='test';
        JETsys2.Reason__c = '{\r\n\t\"Header\": {\r\n\t\t\"ReturnCodeDescription\": \"Normal, Successful completion.\",\r\n\t\t\"ReturnCode\": \"ORA-00000\",\r\n\t\t\"MessageIdentifier\": \"S\"\r\n\t},\r\n\t\"DataArea\": [{\r\n\t\t\"SystemCode\": \"WF\",\r\n\t\t\"FailureName\": \"ATC 1795\",\r\n\t\t\"FailureMode\": \"SP\",\r\n\t\t\"FailureID\": \"F30003750\",\r\n\t\t\"ComponentCode\": \"HA\"\r\n\t}]\r\n}';
        insert JETsys2;
        CSS_JobEventTemporary__c JETsys1 = new CSS_JobEventTemporary__c();
        JETsys1.Attribute1__c = 'ISX12 CM2350 X102';
        JETsys1.Attribute2__c ='OK';
        JETsys1.key__c = 'GetFailureCodesSRT';
        JETsys1.Attribute3__c = 'ISX12 CM2350 X102;;0K';
        JETsys1.Attribute5__c = 'ASSEMBLY';
        JETsys1.Reason__c = '{\r\n\t\"Header\": {\r\n\t\t\"ReturnCodeDescription\": \"Normal, Successful completion.\",\r\n\t\t\"ReturnCode\": \"ORA-00000\",\r\n\t\t\"MessageIdentifier\": \"S\"\r\n\t},\r\n\t\"DataArea\": [{\r\n\t\t\"SystemCode\": \"WF\",\r\n\t\t\"FailureName\": \"ATC 1795\",\r\n\t\t\"FailureMode\": \"SP\",\r\n\t\t\"FailureID\": \"F30003750\",\r\n\t\t\"ComponentCode\": \"HA\"\r\n\t}]\r\n}';
        insert JETsys1;

        CSS_JobEventTemporary__c JETsys4 = new CSS_JobEventTemporary__c();
        JETsys4.Attribute1__c = 'test';
        JETsys4.Attribute4__c ='TS';
        JETsys4.key__c = 'FailModes';
        JETsys4.Attribute3__c = 'TURBO';
        JETsys4.Attribute5__c = 'ASSEMBLY';
        JETsys4.Attribute7__c='test';
        JETsys4.Active__c= true;
        JETsys4.Reason__c = '{\r\n\t\"Header\": {\r\n\t\t\"ReturnCodeDescription\": \"Normal, Successful completion.\",\r\n\t\t\"ReturnCode\": \"ORA-00000\",\r\n\t\t\"MessageIdentifier\": \"S\"\r\n\t},\r\n\t\"DataArea\": [{\r\n\t\t\"SystemCode\": \"WF\",\r\n\t\t\"FailureName\": \"ATC 1795\",\r\n\t\t\"FailureMode\": \"SP\",\r\n\t\t\"FailureID\": \"F30003750\",\r\n\t\t\"ComponentCode\": \"HA\"\r\n\t}]\r\n}';
        insert JETsys4;
        CSS_SymptomQA__c symqa1=new CSS_SymptomQA__c();
        symqa1.job_order__c = jobRef2.id;
        symqa1.type__c='SearchString';
        symqa1.user_name__c = null;
        symqa1.name='TESST';
        symqa1.Caption__c = 'akanksha';
        insert symqa1;

        CSS_SymptomQA__c symqa=new CSS_SymptomQA__c();
        symqa.job_order__c = jobRef2.id;
        symqa.type__c='SearchString';
        symqa.user_name__c = null;
        symqa.name='TESST';
        symqa.SearchString__c = symqa1.id;
        symqa.Caption__c = 'akanksha';
        insert symqa;
        map<string,CSS_JobEventTemporary__c> tempevents = new map<string,CSS_JobEventTemporary__c> ();
        tempevents.put('Test',JETsys4);
        tempevents.put('Test',JETsys1);
        tempevents.put('Test',JETsys2);
        //tempevents.put('Test',JETsys3);
        tempevents.put('Test',JETsys);
        List<CSS_Fault_Code__c> lstFC1 = new List<CSS_Fault_Code__c>();
        lstFC1.add(fc3);
        PageReference pref;
        pref = new PageReference('/'+jobRef2.id);
        pref.getParameters().put('id',jobRef2.id);
        Test.setCurrentPage(pref);
        CSS_Integration_Details__c cid1 = CSS_TestData.createIntegrationDetails(false);
        cid1.name = 'CSS_SBL_GetPartReturns';
        cid1.ApplicationName__c = 'CSS_SBL_getpartreturn';
        cid1.End_Point__c = 'https://services-stg.cummins.com/csswarranty/getpartreturn';
        insert cid1;

        CSS_Integration_Details__c cid = CSS_TestData.createIntegrationDetails(false);
        cid.name = 'CSS_SBL_WarrantyDetailCoverage';
        cid.ApplicationName__c = 'CSS_SBL_WarrantyDetailCoverage';
        cid.End_Point__c = 'https://services-stg.cummins.com/csswarranty/accodecoverage';
        insert cid;
        Map<String,String> systemCodeMap = new Map<String,String>();
        systemCodeMap.put('THT','THT');
        systemCodeMap.put('tes','THT');
        Map<String,String> custFailureNameList = new Map<String,String>();
        custFailureNameList.put('test','THT');
        custFailureNameList.put('tes','THT');
        Map<String,String> failureNameWithSystemCodeMap = new Map<String,String>();
        failureNameWithSystemCodeMap.put('test','THT');
        failureNameWithSystemCodeMap.put('tes','THT');
        Map<String,String> failureNameWithCompCodeMap = new Map<String,String>();
        failureNameWithCompCodeMap.put('test','THT');
        failureNameWithCompCodeMap.put('tes','THT');
        Map<String,String> FailureNameWithFailureIDMap = new Map<String,String>();
        FailureNameWithFailureIDMap.put('test','THT');
        FailureNameWithFailureIDMap.put('tes','THT');
        Set<String> failureNameList=new Set<String>();
        failureNameList.add('test');
        system.runAs(new user(id = userinfo.getUserId())){
            CSS_JobEventTemporary__c JETsys3 = new CSS_JobEventTemporary__c();
            JETsys3.Attribute1__c = 'OTH';
            JETsys3.Attribute4__c ='TS';
            JETsys3.key__c = 'AccountCodes';
            JETsys3.Attribute3__c = 'TURst';
            JETsys3.Attribute2__c = 'TURBO-TURBO';
            JETsys3.Attribute5__c = 'ASSEMBLY';
            JETsys3.Attribute7__c='test';
            JETsys3.Reason__c = '{\r\n\t\"Header\": {\r\n\t\t\"ReturnCodeDescription\": \"Normal, Successful completion.\",\r\n\t\t\"ReturnCode\": \"ORA-00000\",\r\n\t\t\"MessageIdentifier\": \"S\"\r\n\t},\r\n\t\"DataArea\": [{\r\n\t\t\"SystemCode\": \"WF\",\r\n\t\t\"FailureName\": \"ATC 1795\",\r\n\t\t\"FailureMode\": \"SP\",\r\n\t\t\"FailureID\": \"F30003750\",\r\n\t\t\"ComponentCode\": \"HA\"\r\n\t}]\r\n}';
            insert JETsys3;
            test.startTest();
            CSS_JobPlanOverviewControllerNew JobPlanOverCont1 = new CSS_JobPlanOverviewControllerNew();
            JobPlanOverCont1.accCodeSelected='test';
            jobPlanOverCont1.selectedSysCode='THT';
            jobPlanOverCont1.systemCodeMap=systemCodeMap;
            // JobPlanOverCont1.changeSystemcode_New();
            jobPlanOverCont1.selectedCustFName='test';
            //JobPlanOverCont1.changeSystemcode_New();
            jobPlanOverCont1.selectedCustFName='test';
            jobPlanOverCont1.custFailureNameList=custFailureNameList;
            //jobplanovercont1.changeCustFailures_New();
            jobPlanOverCont1.selectedCustFName='on';
            //jobplanovercont1.changeCustFailures_New();
            jobPlanOverCont1.failureNameWithSystemCodeMap=failureNameWithSystemCodeMap;
            jobPlanOverCont1.failureNameWithCompCodeMap=failureNameWithCompCodeMap;
            jobPlanOverCont1.FailureNameWithFailureIDMap=FailureNameWithFailureIDMap;
            jobplanovercont1.failureNameList=failureNameList;
            jobplanovercont1.selectedFName='unlisted';
            //jobplanovercont1.changeFailures_New();
            //Test.setMock(HttpCalloutMock.class, new CSS_SRTCompMockup_Test());
            //Test.setMock(HttpCalloutMock.class , new CSS_WS_SBL_GetWarrantyDetailCovrg_Test());
            jobplanovercont1.selectedFName='';
            Set<String> failureNameList1=new Set<String>();
            jobplanovercont1.failureNameList=failureNameList1;
            //jobplanovercont1.getSRTFailurenamesOnLoad();
            jobplanovercont1.componentId=solComRef1.id;
            jobplanovercont1.failCodeSelected='test';
            //jobplanovercont1.partssave();
            List<CSS_Solutions__c> responseValues = new List<CSS_Solutions__c>();
            responseValues.add(solRef2);
            responseValues.add(solRef3);
            //Test.setMock(HttpCalloutMock.class, new CSS_GetdsidDetails_Test());
            jobplanovercont1.responseValues=responseValues;
            jobplanovercont1.postRepairList=responseValues;
            jobplanovercont1.showRepairs=true;
            jobplanovercont1.showResolutionWithRepair=false;
            // jobplanovercont1.closeSession_close();
            //jobplanovercont1.saveAndCloseJob();

            // Test.setMock(HttpCalloutMock.class , new CSS_WS_SBL_getPartReturnDetailsMock_Test());

            // jobplanovercont1.tempevents=tempevents;
            //jobplanovercont1.jobPlanAction();
            jobplanovercont1.selectedFName=solComRef1.name;
            jobplanovercont1.selectedCompCode=solComRef1.Component_Code__c;
            jobplanovercont1.selectedSysCode=solComRef1.System_Code__c;
            jobplanovercont1.selectedFailMode=solComRef1.Failure_Mode__c;
            Test.setMock(HttpCalloutMock.class , new CSS_WS_SBL_GetWarrantyDetailCovrg_Test());
            jobplanovercont1.checkCoverageNew();
            test.stopTest();}
    }
    
     public static testMethod void TestMethod1New111_one()
    {
        Account acc = new Account();
        acc.name='R1test';
        acc.CSS_DistributorCode__c='03520';
        acc.CSS_DealerCode__c='';
        acc.CSS_FleetCode__c = '';
        acc.CSS_DBCode__c = '04892';
        acc.ERP_System__c = 'One BMS';
        acc.Type = 'Customer';
        acc.Region__c = 'NORTH AMERICA';//'US and Canada';
        acc.CMI_Account_Status__c = 'Active';
        acc.IAM_Service_Provider_Code__c='56270';
        insert acc;
        //Creating Service Job--1
        CSS_Job_Order__c jobRef2 = CSS_TestData.createJobOrder(false); 
        //CSS_Job_Order__c jobRef2 = new CSS_Job_Order__c();    
        list<string> falist=new list<string>();
        string st='Test';
        falist.add(st);
        list<string> partfalist=new list<string>();
        string st1='Test';
        partfalist.add(st1);
        CSS_Integration_Details__c csInt = new CSS_Integration_Details__c();
        csInt.name = 'SRT';
        csInt.ApplicationName__c='SRT';
        csInt.End_Point__c='https://Test-services-dev.cummins.com/css/';
        csInt.IsActive__c=true;
        csInt.Key__c='/Q0w11SmTDJ11dPRgzYfGjycs+HZbtT8sezi/jkT7Ag=';
        csInt.Passcode__c='u9pf3rdOE0SCjXDCgmzRbUlwWQWen7B9993Eh61KI1E=';
        csInt.Username__c='6dpW6v5ekUR2HzkTePJXwgNaMDgo0t53tZgmixV4rfU=';
        insert csint;
        CSS_JobPlanOverviewControllerNew obj=new CSS_JobPlanOverviewControllerNew();
        obj.faultList=falist;
        obj.partlistFAULT=partfalist;

        jobRef2.chevron_page__c='jo';
        jobRef2.BMSWSStatus__c = 'UI';
        jobRef2.CSS_Resolution__c = 'Test';
        jobRef2.General_Symptoms__c='';

        jobRef2.CoverageResponse__c = 'xyz';
        jobRef2.ApplicationCode__c='130';
        jobRef2.Account__c=acc.id;
        upsert jobRef2;

        CSS_Fault_Code__c fc3 = new CSS_Fault_Code__c(FaultCodeR2__c = '441',Related_Fault_Code__c = '234,546');
        fc3.Name = '441';
        fc3.Job_Order__c = jobRef2.Id;
        fc3.Sequence__c = 1; 
        fc3.Fault_Code_Type__c = 'APD-P';
        fc3.Mod__c = '0';
        fc3.isPole__c = false;
        fc3.Number_of_Solutions__c = '1';
        insert fc3;
        CSS_SymptomQA__c symqa12=new CSS_SymptomQA__c();
        symqa12.job_order__c = jobRef2.id;
        symqa12.type__c='SearchString';
        symqa12.user_name__c = null;
        symqa12.name='TESST';
        symqa12.Caption__c = 'akanksha';
        insert symqa12;

        CSS_SymptomQA__c symqa2=new CSS_SymptomQA__c();
        symqa2.job_order__c = jobRef2.id;
        symqa2.type__c='SearchString';
        symqa2.user_name__c = null;
        symqa2.name='TESST';
        symqa2.SearchString__c = symqa12.id;
        symqa2.Caption__c = 'akanksha';
        insert symqa2;

        list<CSS_Solutions__c> sollist=new list<CSS_Solutions__c>();

        CSS_Solutions__c solRef2 =  CSS_TestData.createSolutions(false,jobRef2.Id);
        solRef2.Repair_Response__c='Sucessful';
        solRef2.FaultCode__c=fc3.id;
        solref2.Symptom__c=symqa12.id;

        CSS_Solutions__c solRef3 =  CSS_TestData.createSolutions(false,jobRef2.Id);
        solRef3.Repair_Response__c=null;
        solRef3.FaultCode__c=fc3.id;
        solref3.Symptom__c=symqa2.id;
        sollist.add(solRef2);
        sollist.add(solRef3);
        upsert sollist;



        set<Id> solutionIds = new set<Id>();
        solutionIds.add(solRef2.id);
        solutionIds.add(solRef3.id);

        List<CSS_Solution_Component__c> solComList = new List<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solComRef = CSS_TestData.createSRT(false,jobRef2.Id,solRef2.Id);
        solComRef.System_Code__c = 'Test';

        solComRef.Component_Code__c = 'Test';
        solComRef.Failure_Mode__c = 'Test';
        solComRef.Solutions__c =solRef2.id;
        solComRef.AccountCodeType__c = 'Test-Test';
        solComRef.AccountCode_Call_Status__c = 'error';
        solComRef.Failure_Point__c=11.0;
        solComRef.Failure_Measure__c = null;
        solComRef.name='test';
        solComRef.Failure_Date__c=date.today();
        solComRef.AccountCode__c = 'tst';
        solComRef.AccountCodeEdit__c='';
        solComRef.CoveredPartsQty__c='0';
        solComRef.CampaignPartsPercentage__c='100';
        solComRef.Type__c = '';
        solComRef.CSS_CoverageType__c='POL';
        System.debug('The Solution Component Object');
        solComList.add(solComRef);

        CSS_Solution_Component__c solComRef3 = CSS_TestData.createSRT(false,jobRef2.Id,solRef2.Id);
        solComRef3.System_Code__c = 'Test';

        solComRef3.Component_Code__c = 'Test';
        solComRef3.Failure_Mode__c = 'Test';
        solComRef3.Solutions__c =solRef2.id;
        solComRef3.AccountCodeType__c = 'Test-Test';
        solComRef3.AccountCode_Call_Status__c = 'error';
        solComRef3.Failure_Point__c=11.0;
        solComRef3.Failure_Measure__c = null;
        solComRef3.name='test';
        solComRef3.Failure_Date__c=date.today();
        solComRef3.AccountCode__c = 'tst';
        solComRef3.AccountCodeEdit__c='';
        solComRef3.CoveredPartsQty__c='0';
        solComRef3.CampaignPartsPercentage__c='100';
        solComRef3.CSS_CoverageType__c='POL';
        solComRef3.Type__c = '';
        System.debug('The Solution Component Object');
        solComList.add(solComRef3);

        CSS_Solution_Component__c solComRef1 = CSS_TestData.createSRT(false,jobRef2.Id,solRef2.Id);
        solComRef1.System_Code__c = 'Test';
        solComRef1.name='test';
        solComRef1.Component_Code__c = 'Test';
        solComRef1.Failure_Mode__c = 'Test';
        solComRef1.Solutions__c =solRef2.id;
        solComRef1.AccountCode__c = 'tst';
        solComRef1.AccountCodeEdit__c='';
        solComRef1.AccountCode_Call_Status__c = 'error';
        solComRef1.Failure_Point__c=11.0;
        solComRef1.Failure_Measure__c = null;
        solComRef1.CoveredPartsQty__c='9999999';
        solComRef1.CampaignPartsPercentage__c='100';
        solComRef1.Failure_Date__c=date.today();
        solComRef1.Type__c = '';
        solComRef1.CSS_CoverageType__c='POL';
        solComList.add(solComRef1);
        insert solComList;
        CSS_SRT__c srtVar = new CSS_SRT__c();
        srtVar.Solution_Number__c = solRef2.id;
        srtVar.Job_Order__c = jobRef2.Id;
        srtVar.SRT_AccessiblityCheck__c=True;
        srtVar.Access_Code_A__c = 65;
        srtVar.name = 'Test'+Math.random();
        srtVar.Type__c = 'Repair';
        srtVar.isPerformed__c =True;
        srtVar.Component_Id__c=solComRef1.id;
        insert srtVar;

        CSS_SRT__c srtVar1 = new CSS_SRT__c();
        srtVar1.Solution_Number__c = solRef3.id;
        srtVar1.Job_Order__c = jobRef2.Id;
        srtVar1.SRT_AccessiblityCheck__c=True;
        srtVar1.Access_Code_A__c = 65;
        srtVar1.name = 'Test'+Math.random();
        srtVar1.Type__c = 'Repair';
        srtVar1.Component_Id__c=solComRef1.id;
        srtVar1.isPerformed__c =True;

        insert srtVar1;
        CSS_Parts_Options__c parts = new CSS_Parts_Options__c();
        parts.Covered__c =0.0;
        parts.Fail_Code__c ='test';
        parts.Service_partnumber__c='test';
        parts.Account_Code__c = 'test1';
        parts.Service_Job__c = jobRef2.id;  
        parts.ReturnToFactory__c = '' ;
        parts.FailurepartId__c=solComRef1.id;
        insert parts;

        CSS_Parts_Options__c parts1 = new CSS_Parts_Options__c();
        parts1.Covered__c =0.0;
        parts1.Fail_Code__c ='test';
        parts1.Service_partnumber__c='test';
        parts1.Account_Code__c = 'test1';
        parts1.Service_Job__c = jobRef2.id;  
        parts1.ReturnToFactory__c = '' ;
        parts1.FailurepartId__c=solComRef.id;
        insert parts1;


        List<CSS_JobEventTemporary__c> lstjobeve =  new List<CSS_JobEventTemporary__c>();
        CSS_JobEventTemporary__c JETsys11 = new CSS_JobEventTemporary__c();
        JETsys11.Attribute1__c = 'OTH';
        JETsys11.Attribute4__c ='TS';
        JETsys11.key__c ='AccountCodes';
        JETsys11.Attribute3__c = 'TURBO';
        JETsys11.Attribute5__c = 'ASSEMBLY';
        insert JETsys11;
        lstjobeve.add(JETsys11);
        CSS_JobEventTemporary__c JETsys12 = new CSS_JobEventTemporary__c();
        JETsys12.Attribute1__c = 'NPW';
        JETsys12.Attribute2__c ='OK';
        JETsys12.key__c = 'AccountCodes';
        JETsys12.Attribute3__c = 'ISX12 CM2350 X102;;0K';
        JETsys12.Attribute5__c = 'ASSEMBLY';
        JETsys12.Reason__c = '{\r\n\t\"Header\": {\r\n\t\t\"ReturnCodeDescription\": \"Normal, Successful completion.\",\r\n\t\t\"ReturnCode\": \"ORA-00000\",\r\n\t\t\"MessageIdentifier\": \"S\"\r\n\t},\r\n\t\"DataArea\": [{\r\n\t\t\"SystemCode\": \"WF\",\r\n\t\t\"FailureName\": \"ATC 1795\",\r\n\t\t\"FailureMode\": \"SP\",\r\n\t\t\"FailureID\": \"F30003750\",\r\n\t\t\"ComponentCode\": \"HA\"\r\n\t}]\r\n}';
        insert JETsys12;
        lstjobeve.add(JETsys12);


        CSS_JobEventTemporary__c JETsys = new CSS_JobEventTemporary__c();
        JETsys.Attribute1__c = 'TH';
        JETsys.Attribute4__c ='TS';
        JETsys.key__c = 'FailCodes';
        JETsys.Attribute3__c = 'TURBO';
        JETsys.Attribute5__c = 'ASSEMBLY';
        JETsys.Attribute7__c='test';
        JETsys.Reason__c = '{\r\n\t\"Header\": {\r\n\t\t\"ReturnCodeDescription\": \"Normal, Successful completion.\",\r\n\t\t\"ReturnCode\": \"ORA-00000\",\r\n\t\t\"MessageIdentifier\": \"S\"\r\n\t},\r\n\t\"DataArea\": [{\r\n\t\t\"SystemCode\": \"WF\",\r\n\t\t\"FailureName\": \"ATC 1795\",\r\n\t\t\"FailureMode\": \"SP\",\r\n\t\t\"FailureID\": \"F30003750\",\r\n\t\t\"ComponentCode\": \"HA\"\r\n\t}]\r\n}';
        insert JETsys;

        CSS_JobEventTemporary__c JETsys2 = new CSS_JobEventTemporary__c();
        JETsys2.Attribute1__c = 'TH';
        JETsys2.Attribute4__c ='TS';
        JETsys2.key__c = 'getFailureCodesSRT';
        JETsys2.Attribute3__c = 'ESN;;1234';
        JETsys2.Attribute5__c = 'ASSEMBLY';
        JETsys2.Attribute7__c='test';
        JETsys2.Reason__c = '{\r\n\t\"Header\": {\r\n\t\t\"ReturnCodeDescription\": \"Normal, Successful completion.\",\r\n\t\t\"ReturnCode\": \"ORA-00000\",\r\n\t\t\"MessageIdentifier\": \"S\"\r\n\t},\r\n\t\"DataArea\": [{\r\n\t\t\"SystemCode\": \"WF\",\r\n\t\t\"FailureName\": \"ATC 1795\",\r\n\t\t\"FailureMode\": \"SP\",\r\n\t\t\"FailureID\": \"F30003750\",\r\n\t\t\"ComponentCode\": \"HA\"\r\n\t}]\r\n}';
        insert JETsys2;
        CSS_JobEventTemporary__c JETsys1 = new CSS_JobEventTemporary__c();
        JETsys1.Attribute1__c = 'ISX12 CM2350 X102';
        JETsys1.Attribute2__c ='OK';
        JETsys1.key__c = 'GetFailureCodesSRT';
        JETsys1.Attribute3__c = 'ISX12 CM2350 X102;;0K';
        JETsys1.Attribute5__c = 'ASSEMBLY';
        JETsys1.Reason__c = '{\r\n\t\"Header\": {\r\n\t\t\"ReturnCodeDescription\": \"Normal, Successful completion.\",\r\n\t\t\"ReturnCode\": \"ORA-00000\",\r\n\t\t\"MessageIdentifier\": \"S\"\r\n\t},\r\n\t\"DataArea\": [{\r\n\t\t\"SystemCode\": \"WF\",\r\n\t\t\"FailureName\": \"ATC 1795\",\r\n\t\t\"FailureMode\": \"SP\",\r\n\t\t\"FailureID\": \"F30003750\",\r\n\t\t\"ComponentCode\": \"HA\"\r\n\t}]\r\n}';
        insert JETsys1;

        CSS_JobEventTemporary__c JETsys4 = new CSS_JobEventTemporary__c();
        JETsys4.Attribute1__c = 'test';
        JETsys4.Attribute4__c ='TS';
        JETsys4.key__c = 'FailModes';
        JETsys4.Attribute3__c = 'TURBO';
        JETsys4.Attribute5__c = 'ASSEMBLY';
        JETsys4.Attribute7__c='test';
        JETsys4.Active__c= true;
        JETsys4.Reason__c = '{\r\n\t\"Header\": {\r\n\t\t\"ReturnCodeDescription\": \"Normal, Successful completion.\",\r\n\t\t\"ReturnCode\": \"ORA-00000\",\r\n\t\t\"MessageIdentifier\": \"S\"\r\n\t},\r\n\t\"DataArea\": [{\r\n\t\t\"SystemCode\": \"WF\",\r\n\t\t\"FailureName\": \"ATC 1795\",\r\n\t\t\"FailureMode\": \"SP\",\r\n\t\t\"FailureID\": \"F30003750\",\r\n\t\t\"ComponentCode\": \"HA\"\r\n\t}]\r\n}';
        insert JETsys4;
        CSS_SymptomQA__c symqa1=new CSS_SymptomQA__c();
        symqa1.job_order__c = jobRef2.id;
        symqa1.type__c='SearchString';
        symqa1.user_name__c = null;
        symqa1.name='TESST';
        symqa1.Caption__c = 'akanksha';
        insert symqa1;

        CSS_SymptomQA__c symqa=new CSS_SymptomQA__c();
        symqa.job_order__c = jobRef2.id;
        symqa.type__c='SearchString';
        symqa.user_name__c = null;
        symqa.name='TESST';
        symqa.SearchString__c = symqa1.id;
        symqa.Caption__c = 'akanksha';
        insert symqa;
        map<string,CSS_JobEventTemporary__c> tempevents = new map<string,CSS_JobEventTemporary__c> ();
        tempevents.put('Test',JETsys4);
        tempevents.put('Test',JETsys1);
        tempevents.put('Test',JETsys2);
        //tempevents.put('Test',JETsys3);
        tempevents.put('Test',JETsys);
        List<CSS_Fault_Code__c> lstFC1 = new List<CSS_Fault_Code__c>();
        lstFC1.add(fc3);
        PageReference pref;
        pref = new PageReference('/'+jobRef2.id);
        pref.getParameters().put('id',jobRef2.id);
        Test.setCurrentPage(pref);
        CSS_Integration_Details__c cid1 = CSS_TestData.createIntegrationDetails(false);
        cid1.name = 'CSS_SBL_GetPartReturns';
        cid1.ApplicationName__c = 'CSS_SBL_getpartreturn';
        cid1.End_Point__c = 'https://services-stg.cummins.com/csswarranty/getpartreturn';
        insert cid1;

        CSS_Integration_Details__c cid = CSS_TestData.createIntegrationDetails(false);
        cid.name = 'CSS_SBL_WarrantyDetailCoverage';
        cid.ApplicationName__c = 'CSS_SBL_WarrantyDetailCoverage';
        cid.End_Point__c = 'https://services-stg.cummins.com/csswarranty/accodecoverage';
        insert cid;
        Map<String,String> systemCodeMap = new Map<String,String>();
        systemCodeMap.put('THT','THT');
        systemCodeMap.put('tes','THT');
        Map<String,String> custFailureNameList = new Map<String,String>();
        custFailureNameList.put('test','THT');
        custFailureNameList.put('tes','THT');
        Map<String,String> failureNameWithSystemCodeMap = new Map<String,String>();
        failureNameWithSystemCodeMap.put('test','THT');
        failureNameWithSystemCodeMap.put('tes','THT');
        Map<String,String> failureNameWithCompCodeMap = new Map<String,String>();
        failureNameWithCompCodeMap.put('test','THT');
        failureNameWithCompCodeMap.put('tes','THT');
        Map<String,String> FailureNameWithFailureIDMap = new Map<String,String>();
        FailureNameWithFailureIDMap.put('test','THT');
        FailureNameWithFailureIDMap.put('tes','THT');
        Set<String> failureNameList=new Set<String>();
        failureNameList.add('test');
        system.runAs(new user(id = userinfo.getUserId())){
            CSS_JobEventTemporary__c JETsys3 = new CSS_JobEventTemporary__c();
            JETsys3.Attribute1__c = 'OTH';
            JETsys3.Attribute4__c ='TS';
            JETsys3.key__c = 'AccountCodes';
            JETsys3.Attribute3__c = 'TURst';
            JETsys3.Attribute2__c = 'TURBO-TURBO';
            JETsys3.Attribute5__c = 'ASSEMBLY';
            JETsys3.Attribute7__c='test';
            JETsys3.Reason__c = '{\r\n\t\"Header\": {\r\n\t\t\"ReturnCodeDescription\": \"Normal, Successful completion.\",\r\n\t\t\"ReturnCode\": \"ORA-00000\",\r\n\t\t\"MessageIdentifier\": \"S\"\r\n\t},\r\n\t\"DataArea\": [{\r\n\t\t\"SystemCode\": \"WF\",\r\n\t\t\"FailureName\": \"ATC 1795\",\r\n\t\t\"FailureMode\": \"SP\",\r\n\t\t\"FailureID\": \"F30003750\",\r\n\t\t\"ComponentCode\": \"HA\"\r\n\t}]\r\n}';
            insert JETsys3;
            test.startTest();
            CSS_JobPlanOverviewControllerNew JobPlanOverCont1 = new CSS_JobPlanOverviewControllerNew();
            JobPlanOverCont1.accCodeSelected='test';
            jobPlanOverCont1.selectedSysCode='THT';
            jobPlanOverCont1.systemCodeMap=systemCodeMap;
            // JobPlanOverCont1.changeSystemcode_New();
            jobPlanOverCont1.selectedCustFName='test';
            //JobPlanOverCont1.changeSystemcode_New();
            jobPlanOverCont1.selectedCustFName='test';
            jobPlanOverCont1.custFailureNameList=custFailureNameList;
            //jobplanovercont1.changeCustFailures_New();
            jobPlanOverCont1.selectedCustFName='on';
            //jobplanovercont1.changeCustFailures_New();
            jobPlanOverCont1.failureNameWithSystemCodeMap=failureNameWithSystemCodeMap;
            jobPlanOverCont1.failureNameWithCompCodeMap=failureNameWithCompCodeMap;
            jobPlanOverCont1.FailureNameWithFailureIDMap=FailureNameWithFailureIDMap;
            jobplanovercont1.failureNameList=failureNameList;
            jobplanovercont1.selectedFName='unlisted';
            //jobplanovercont1.changeFailures_New();
            //Test.setMock(HttpCalloutMock.class, new CSS_SRTCompMockup_Test());
            //Test.setMock(HttpCalloutMock.class , new CSS_WS_SBL_GetWarrantyDetailCovrg_Test());
            jobplanovercont1.selectedFName='';
            Set<String> failureNameList1=new Set<String>();
            jobplanovercont1.failureNameList=failureNameList1;
            //jobplanovercont1.getSRTFailurenamesOnLoad();
            jobplanovercont1.componentId=solComRef1.id;
            jobplanovercont1.failCodeSelected='test';
            //jobplanovercont1.partssave();
            List<CSS_Solutions__c> responseValues = new List<CSS_Solutions__c>();
            responseValues.add(solRef2);
            responseValues.add(solRef3);
            //Test.setMock(HttpCalloutMock.class, new CSS_GetdsidDetails_Test());
            jobplanovercont1.responseValues=responseValues;
            jobplanovercont1.postRepairList=responseValues;
            jobplanovercont1.showRepairs=true;
            jobplanovercont1.showResolutionWithRepair=false;
            // jobplanovercont1.closeSession_close();
            //jobplanovercont1.saveAndCloseJob();

            // Test.setMock(HttpCalloutMock.class , new CSS_WS_SBL_getPartReturnDetailsMock_Test());

            // jobplanovercont1.tempevents=tempevents;
            //jobplanovercont1.jobPlanAction();
            jobplanovercont1.selectedFName=solComRef1.name;
            jobplanovercont1.selectedCompCode=solComRef1.Component_Code__c;
            jobplanovercont1.selectedSysCode=solComRef1.System_Code__c;
            jobplanovercont1.selectedFailMode=solComRef1.Failure_Mode__c;
            Test.setMock(HttpCalloutMock.class , new CSS_WS_SBL_GetWarrantyDetailCovrg_Test());
            jobplanovercont1.checkCoverageNew();
            test.stopTest();}
    }
    
    public static testMethod void TestMethod1New1112()
    {
        Account acc = new Account();
        acc.name='R1test';
        acc.CSS_DistributorCode__c='03520';
        acc.CSS_DealerCode__c='';
        acc.CSS_FleetCode__c = '';
        acc.CSS_DBCode__c = '04892';
        acc.ERP_System__c = 'One BMS';
        acc.Type = 'Customer';
        acc.Region__c = 'NORTH AMERICA';//'US and Canada';
        acc.CMI_Account_Status__c = 'Active';
        acc.IAM_Service_Provider_Code__c='56270';
        insert acc;
        //Creating Service Job--1
        CSS_Job_Order__c jobRef2 = CSS_TestData.createJobOrder(false); 
        //CSS_Job_Order__c jobRef2 = new CSS_Job_Order__c();    
        list<string> falist=new list<string>();
        string st='Test';
        falist.add(st);
        list<string> partfalist=new list<string>();
        string st1='Test';
        partfalist.add(st1);
        CSS_Integration_Details__c csInt = new CSS_Integration_Details__c();
        csInt.name = 'SRT';
        csInt.ApplicationName__c='SRT';
        csInt.End_Point__c='https://Test-services-dev.cummins.com/css/';
        csInt.IsActive__c=true;
        csInt.Key__c='/Q0w11SmTDJ11dPRgzYfGjycs+HZbtT8sezi/jkT7Ag=';
        csInt.Passcode__c='u9pf3rdOE0SCjXDCgmzRbUlwWQWen7B9993Eh61KI1E=';
        csInt.Username__c='6dpW6v5ekUR2HzkTePJXwgNaMDgo0t53tZgmixV4rfU=';
        insert csint;
        CSS_JobPlanOverviewControllerNew obj=new CSS_JobPlanOverviewControllerNew();
        obj.faultList=falist;
        obj.partlistFAULT=partfalist;

        jobRef2.chevron_page__c='jo';
        jobRef2.BMSWSStatus__c = 'UI';
        jobRef2.CSS_Resolution__c = 'Test';
        jobRef2.General_Symptoms__c='';

        jobRef2.CoverageResponse__c = 'xyz';
        jobRef2.ApplicationCode__c='130';
        jobRef2.Account__c=acc.id;
        upsert jobRef2;

        CSS_Fault_Code__c fc3 = new CSS_Fault_Code__c(FaultCodeR2__c = '441',Related_Fault_Code__c = '234,546');
        fc3.Name = '441';
        fc3.Job_Order__c = jobRef2.Id;
        fc3.Sequence__c = 1; 
        fc3.Fault_Code_Type__c = 'APD-P';
        fc3.Mod__c = '0';
        fc3.isPole__c = false;
        fc3.Number_of_Solutions__c = '1';
        insert fc3;
        CSS_SymptomQA__c symqa12=new CSS_SymptomQA__c();
        symqa12.job_order__c = jobRef2.id;
        symqa12.type__c='SearchString';
        symqa12.user_name__c = null;
        symqa12.name='TESST';
        symqa12.Caption__c = 'akanksha';
        insert symqa12;

        CSS_SymptomQA__c symqa2=new CSS_SymptomQA__c();
        symqa2.job_order__c = jobRef2.id;
        symqa2.type__c='SearchString';
        symqa2.user_name__c = null;
        symqa2.name='TESST';
        symqa2.SearchString__c = symqa12.id;
        symqa2.Caption__c = 'akanksha';
        insert symqa2;

        list<CSS_Solutions__c> sollist=new list<CSS_Solutions__c>();

        CSS_Solutions__c solRef2 =  CSS_TestData.createSolutions(false,jobRef2.Id);
        solRef2.Repair_Response__c='Sucessful';
        solRef2.FaultCode__c=fc3.id;
        solref2.Symptom__c=symqa12.id;

        CSS_Solutions__c solRef3 =  CSS_TestData.createSolutions(false,jobRef2.Id);
        solRef3.Repair_Response__c=null;
        solRef3.FaultCode__c=fc3.id;
        solref3.Symptom__c=symqa2.id;
        sollist.add(solRef2);
        sollist.add(solRef3);
        upsert sollist;



        set<Id> solutionIds = new set<Id>();
        solutionIds.add(solRef2.id);
        solutionIds.add(solRef3.id);

        List<CSS_Solution_Component__c> solComList = new List<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solComRef = CSS_TestData.createSRT(false,jobRef2.Id,solRef2.Id);
        solComRef.System_Code__c = 'Test';

        solComRef.Component_Code__c = 'Test';
        solComRef.Failure_Mode__c = 'Test';
        solComRef.Solutions__c =solRef2.id;
        solComRef.AccountCodeType__c = 'Test-Test';
        solComRef.AccountCode_Call_Status__c = 'Failure';
        solComRef.Failure_Point__c=11.0;
        solComRef.Failure_Measure__c = null;
        solComRef.name='test';
        solComRef.Failure_Date__c=date.today();
        solComRef.AccountCode__c = 'tst';
        solComRef.AccountCodeEdit__c='test';
        solComRef.CoveredPartsQty__c='0';
        solComRef.CampaignPartsPercentage__c='100';
        solComRef.Type__c = '';
        solComRef.CSS_CoverageType__c='POL';
        System.debug('The Solution Component Object');
        solComList.add(solComRef);

        CSS_Solution_Component__c solComRef3 = CSS_TestData.createSRT(false,jobRef2.Id,solRef2.Id);
        solComRef3.System_Code__c = 'Test';

        solComRef3.Component_Code__c = 'Test';
        solComRef3.Failure_Mode__c = 'Test';
        solComRef3.Solutions__c =solRef2.id;
        solComRef3.AccountCodeType__c = 'Test-Test';
        solComRef3.AccountCode_Call_Status__c = 'Failure';
        solComRef3.Failure_Point__c=11.0;
        solComRef3.Failure_Measure__c = null;
        solComRef3.name='test';
        solComRef3.Failure_Date__c=date.today();
        solComRef3.AccountCode__c = 'tst';
        solComRef3.AccountCodeEdit__c='test';
        solComRef3.CoveredPartsQty__c='0';
        solComRef3.CampaignPartsPercentage__c='100';
        solComRef3.CSS_CoverageType__c='POL';
        solComRef3.Type__c = '';
        System.debug('The Solution Component Object');
        solComList.add(solComRef3);

        CSS_Solution_Component__c solComRef1 = CSS_TestData.createSRT(false,jobRef2.Id,solRef2.Id);
        solComRef1.System_Code__c = 'Test';
        solComRef1.name='test';
        solComRef1.Component_Code__c = 'Test';
        solComRef1.Failure_Mode__c = 'Test';
        solComRef1.Solutions__c =solRef2.id;
        solComRef1.AccountCode__c = 'tst';
        solComRef1.AccountCodeEdit__c='test';
        solComRef1.AccountCode_Call_Status__c = 'Failure';
        solComRef1.Failure_Point__c=11.0;
        solComRef1.Failure_Measure__c = null;
        solComRef1.CoveredPartsQty__c='9999999';
        solComRef1.CampaignPartsPercentage__c='100';
        solComRef1.Failure_Date__c=date.today();
        solComRef1.Type__c = '';
        solComRef1.CSS_CoverageType__c='POL';
        solComList.add(solComRef1);
        insert solComList;
        CSS_SRT__c srtVar = new CSS_SRT__c();
        srtVar.Solution_Number__c = solRef2.id;
        srtVar.Job_Order__c = jobRef2.Id;
        srtVar.SRT_AccessiblityCheck__c=True;
        srtVar.Access_Code_A__c = 65;
        srtVar.name = 'Test'+Math.random();
        srtVar.Type__c = 'Repair';
        srtVar.isPerformed__c =True;
        srtVar.Component_Id__c=solComRef1.id;
        insert srtVar;

        CSS_SRT__c srtVar1 = new CSS_SRT__c();
        srtVar1.Solution_Number__c = solRef3.id;
        srtVar1.Job_Order__c = jobRef2.Id;
        srtVar1.SRT_AccessiblityCheck__c=True;
        srtVar1.Access_Code_A__c = 65;
        srtVar1.name = 'Test'+Math.random();
        srtVar1.Type__c = 'Repair';
        srtVar1.Component_Id__c=solComRef1.id;
        srtVar1.isPerformed__c =True;

        insert srtVar1;
        CSS_Parts_Options__c parts = new CSS_Parts_Options__c();
        parts.Covered__c =0.0;
        parts.Fail_Code__c ='test';
        parts.Service_partnumber__c='test';
        parts.Account_Code__c = 'test1';
        parts.Service_Job__c = jobRef2.id;  
        parts.ReturnToFactory__c = '' ;
        parts.FailurepartId__c=solComRef1.id;
        insert parts;

        CSS_Parts_Options__c parts1 = new CSS_Parts_Options__c();
        parts1.Covered__c =0.0;
        parts1.Fail_Code__c ='test';
        parts1.Service_partnumber__c='test';
        parts1.Account_Code__c = 'test1';
        parts1.Service_Job__c = jobRef2.id;  
        parts1.ReturnToFactory__c = '' ;
        parts1.FailurepartId__c=solComRef.id;
        insert parts1;

        CSS_JobEventTemporary__c JETsys = new CSS_JobEventTemporary__c();
        JETsys.Attribute1__c = 'TH';
        JETsys.Attribute4__c ='TS';
        JETsys.key__c = 'FailCodes';
        JETsys.Attribute3__c = 'TURBO';
        JETsys.Attribute5__c = 'ASSEMBLY';
        JETsys.Attribute7__c='test';
        JETsys.Reason__c = '{\r\n\t\"Header\": {\r\n\t\t\"ReturnCodeDescription\": \"Normal, Successful completion.\",\r\n\t\t\"ReturnCode\": \"ORA-00000\",\r\n\t\t\"MessageIdentifier\": \"S\"\r\n\t},\r\n\t\"DataArea\": [{\r\n\t\t\"SystemCode\": \"WF\",\r\n\t\t\"FailureName\": \"ATC 1795\",\r\n\t\t\"FailureMode\": \"SP\",\r\n\t\t\"FailureID\": \"F30003750\",\r\n\t\t\"ComponentCode\": \"HA\"\r\n\t}]\r\n}';
        insert JETsys;


        CSS_JobEventTemporary__c JETsys2 = new CSS_JobEventTemporary__c();
        JETsys2.Attribute1__c = 'TH';
        JETsys2.Attribute4__c ='TS';
        JETsys2.key__c = 'getFailureCodesSRT';
        JETsys2.Attribute3__c = 'ESN;;1234';
        JETsys2.Attribute5__c = 'ASSEMBLY';
        JETsys2.Attribute7__c='test';
        JETsys2.Reason__c = '{\r\n\t\"Header\": {\r\n\t\t\"ReturnCodeDescription\": \"Normal, Successful completion.\",\r\n\t\t\"ReturnCode\": \"ORA-00000\",\r\n\t\t\"MessageIdentifier\": \"S\"\r\n\t},\r\n\t\"DataArea\": [{\r\n\t\t\"SystemCode\": \"WF\",\r\n\t\t\"FailureName\": \"ATC 1795\",\r\n\t\t\"FailureMode\": \"SP\",\r\n\t\t\"FailureID\": \"F30003750\",\r\n\t\t\"ComponentCode\": \"HA\"\r\n\t}]\r\n}';
        insert JETsys2;
        CSS_JobEventTemporary__c JETsys1 = new CSS_JobEventTemporary__c();
        JETsys1.Attribute1__c = 'ISX12 CM2350 X102';
        JETsys1.Attribute2__c ='OK';
        JETsys1.key__c = 'GetFailureCodesSRT';
        JETsys1.Attribute3__c = 'ISX12 CM2350 X102;;0K';
        JETsys1.Attribute5__c = 'ASSEMBLY';
        JETsys1.Reason__c = '{\r\n\t\"Header\": {\r\n\t\t\"ReturnCodeDescription\": \"Normal, Successful completion.\",\r\n\t\t\"ReturnCode\": \"ORA-00000\",\r\n\t\t\"MessageIdentifier\": \"S\"\r\n\t},\r\n\t\"DataArea\": [{\r\n\t\t\"SystemCode\": \"WF\",\r\n\t\t\"FailureName\": \"ATC 1795\",\r\n\t\t\"FailureMode\": \"SP\",\r\n\t\t\"FailureID\": \"F30003750\",\r\n\t\t\"ComponentCode\": \"HA\"\r\n\t}]\r\n}';
        insert JETsys1;

        CSS_JobEventTemporary__c JETsys4 = new CSS_JobEventTemporary__c();
        JETsys4.Attribute1__c = 'test';
        JETsys4.Attribute4__c ='TS';
        JETsys4.key__c = 'FailModes';
        JETsys4.Attribute3__c = 'TURBO';
        JETsys4.Attribute5__c = 'ASSEMBLY';
        JETsys4.Attribute7__c='test';
        JETsys4.Active__c= true;
        JETsys4.Reason__c = '{\r\n\t\"Header\": {\r\n\t\t\"ReturnCodeDescription\": \"Normal, Successful completion.\",\r\n\t\t\"ReturnCode\": \"ORA-00000\",\r\n\t\t\"MessageIdentifier\": \"S\"\r\n\t},\r\n\t\"DataArea\": [{\r\n\t\t\"SystemCode\": \"WF\",\r\n\t\t\"FailureName\": \"ATC 1795\",\r\n\t\t\"FailureMode\": \"SP\",\r\n\t\t\"FailureID\": \"F30003750\",\r\n\t\t\"ComponentCode\": \"HA\"\r\n\t}]\r\n}';
        insert JETsys4;
        CSS_SymptomQA__c symqa1=new CSS_SymptomQA__c();
        symqa1.job_order__c = jobRef2.id;
        symqa1.type__c='SearchString';
        symqa1.user_name__c = null;
        symqa1.name='TESST';
        symqa1.Caption__c = 'akanksha';
        insert symqa1;

        CSS_SymptomQA__c symqa=new CSS_SymptomQA__c();
        symqa.job_order__c = jobRef2.id;
        symqa.type__c='SearchString';
        symqa.user_name__c = null;
        symqa.name='TESST';
        symqa.SearchString__c = symqa1.id;
        symqa.Caption__c = 'akanksha';
        insert symqa;
        map<string,CSS_JobEventTemporary__c> tempevents = new map<string,CSS_JobEventTemporary__c> ();
        tempevents.put('Test',JETsys4);
        tempevents.put('Test',JETsys1);
        tempevents.put('Test',JETsys2);
        //tempevents.put('Test',JETsys3);
        tempevents.put('Test',JETsys);
        List<CSS_Fault_Code__c> lstFC1 = new List<CSS_Fault_Code__c>();
        lstFC1.add(fc3);
        PageReference pref;
        pref = new PageReference('/'+jobRef2.id);
        pref.getParameters().put('id',jobRef2.id);
        Test.setCurrentPage(pref);
        CSS_Integration_Details__c cid1 = CSS_TestData.createIntegrationDetails(false);
        cid1.name = 'CSS_SBL_GetPartReturns';
        cid1.ApplicationName__c = 'CSS_SBL_getpartreturn';
        cid1.End_Point__c = 'https://services-stg.cummins.com/csswarranty/getpartreturn';
        insert cid1;

        CSS_Integration_Details__c cid = CSS_TestData.createIntegrationDetails(false);
        cid.name = 'CSS_SBL_WarrantyDetailCoverage';
        cid.ApplicationName__c = 'CSS_SBL_WarrantyDetailCoverage';
        cid.End_Point__c = 'https://services-stg.cummins.com/csswarranty/accodecoverage';
        insert cid;
        Map<String,String> systemCodeMap = new Map<String,String>();
        systemCodeMap.put('THT','THT');
        systemCodeMap.put('tes','THT');
        Map<String,String> custFailureNameList = new Map<String,String>();
        custFailureNameList.put('test','THT');
        custFailureNameList.put('tes','THT');
        Map<String,String> failureNameWithSystemCodeMap = new Map<String,String>();
        failureNameWithSystemCodeMap.put('test','THT');
        failureNameWithSystemCodeMap.put('tes','THT');
        Map<String,String> failureNameWithCompCodeMap = new Map<String,String>();
        failureNameWithCompCodeMap.put('test','THT');
        failureNameWithCompCodeMap.put('tes','THT');
        Map<String,String> FailureNameWithFailureIDMap = new Map<String,String>();
        FailureNameWithFailureIDMap.put('test','THT');
        FailureNameWithFailureIDMap.put('tes','THT');
        Set<String> failureNameList=new Set<String>();
        failureNameList.add('test');
        system.runAs(new user(id = userinfo.getUserId())){
            CSS_JobEventTemporary__c JETsys3 = new CSS_JobEventTemporary__c();
            JETsys3.Attribute1__c = 'OTH';
            JETsys3.Attribute4__c ='TS';
            JETsys3.key__c = 'AccountCodes';
            JETsys3.Attribute3__c = 'TURst';
            JETsys3.Attribute2__c = 'TURBO-TURBO';
            JETsys3.Attribute5__c = 'ASSEMBLY';
            JETsys3.Attribute7__c='test';
            JETsys3.Reason__c = '{\r\n\t\"Header\": {\r\n\t\t\"ReturnCodeDescription\": \"Normal, Successful completion.\",\r\n\t\t\"ReturnCode\": \"ORA-00000\",\r\n\t\t\"MessageIdentifier\": \"S\"\r\n\t},\r\n\t\"DataArea\": [{\r\n\t\t\"SystemCode\": \"WF\",\r\n\t\t\"FailureName\": \"ATC 1795\",\r\n\t\t\"FailureMode\": \"SP\",\r\n\t\t\"FailureID\": \"F30003750\",\r\n\t\t\"ComponentCode\": \"HA\"\r\n\t}]\r\n}';
            insert JETsys3;
            test.startTest();
            CSS_JobPlanOverviewControllerNew JobPlanOverCont1 = new CSS_JobPlanOverviewControllerNew();
            JobPlanOverCont1.accCodeSelected='test';
            jobPlanOverCont1.selectedSysCode='THT';
            jobPlanOverCont1.systemCodeMap=systemCodeMap;
            // JobPlanOverCont1.changeSystemcode_New();
            jobPlanOverCont1.selectedCustFName='test';
            //JobPlanOverCont1.changeSystemcode_New();
            jobPlanOverCont1.selectedCustFName='test';
            jobPlanOverCont1.custFailureNameList=custFailureNameList;
            //jobplanovercont1.changeCustFailures_New();
            jobPlanOverCont1.selectedCustFName='on';
            //jobplanovercont1.changeCustFailures_New();
            jobPlanOverCont1.failureNameWithSystemCodeMap=failureNameWithSystemCodeMap;
            jobPlanOverCont1.failureNameWithCompCodeMap=failureNameWithCompCodeMap;
            jobPlanOverCont1.FailureNameWithFailureIDMap=FailureNameWithFailureIDMap;
            jobplanovercont1.failureNameList=failureNameList;
            jobplanovercont1.selectedFName='unlisted';
            //jobplanovercont1.changeFailures_New();
            //Test.setMock(HttpCalloutMock.class, new CSS_SRTCompMockup_Test());
            //Test.setMock(HttpCalloutMock.class , new CSS_WS_SBL_GetWarrantyDetailCovrg_Test());
            jobplanovercont1.selectedFName='';
            Set<String> failureNameList1=new Set<String>();
            jobplanovercont1.failureNameList=failureNameList1;
            //jobplanovercont1.getSRTFailurenamesOnLoad();
            jobplanovercont1.componentId=solComRef1.id;
            jobplanovercont1.failCodeSelected='test';
            //jobplanovercont1.partssave();
            List<CSS_Solutions__c> responseValues = new List<CSS_Solutions__c>();
            responseValues.add(solRef2);
            responseValues.add(solRef3);
            //Test.setMock(HttpCalloutMock.class, new CSS_GetdsidDetails_Test());
            jobplanovercont1.responseValues=responseValues;
            jobplanovercont1.postRepairList=responseValues;
            jobplanovercont1.showRepairs=true;
            jobplanovercont1.showResolutionWithRepair=false;
            // jobplanovercont1.closeSession_close();
            //jobplanovercont1.saveAndCloseJob();

            // Test.setMock(HttpCalloutMock.class , new CSS_WS_SBL_getPartReturnDetailsMock_Test());

            //jobplanovercont1.tempevents=tempevents;
            jobplanovercont1.jobPlanAction();
            jobplanovercont1.selectedFName=solComRef1.name;
            jobplanovercont1.selectedCompCode=solComRef1.Component_Code__c;
            jobplanovercont1.selectedSysCode=solComRef1.System_Code__c;
            jobplanovercont1.selectedFailMode=solComRef1.Failure_Mode__c;
            Test.setMock(HttpCalloutMock.class , new CSS_WS_SBL_GetWarrantyDetailCovrg_Test());
            jobplanovercont1.checkCoverageNew();
            test.stopTest();}
    }
    public static testMethod void TestMethod1New()
    {

        //Creating Service Job--1
        CSS_Job_Order__c jobRef2 = CSS_TestData.createJobOrder(false); 
        //CSS_Job_Order__c jobRef2 = new CSS_Job_Order__c();    
        list<string> falist=new list<string>();
        string st='Test';
        falist.add(st);
        list<string> partfalist=new list<string>();
        string st1='Test';
        partfalist.add(st1);
        CSS_Integration_Details__c csInt = new CSS_Integration_Details__c();
        csInt.name = 'SRT';
        csInt.ApplicationName__c='SRT';
        csInt.End_Point__c='https://Test-services-dev.cummins.com/css/';
        csInt.IsActive__c=true;
        csInt.Key__c='/Q0w11SmTDJ11dPRgzYfGjycs+HZbtT8sezi/jkT7Ag=';
        csInt.Passcode__c='u9pf3rdOE0SCjXDCgmzRbUlwWQWen7B9993Eh61KI1E=';
        csInt.Username__c='6dpW6v5ekUR2HzkTePJXwgNaMDgo0t53tZgmixV4rfU=';
        insert csint;
        CSS_JobPlanOverviewControllerNew obj=new CSS_JobPlanOverviewControllerNew();
        obj.faultList=falist;
        obj.partlistFAULT=partfalist;

        jobRef2.chevron_page__c='jo';
        jobRef2.BMSWSStatus__c = 'UI';
        jobRef2.CSS_Resolution__c = 'Test';
        jobRef2.General_Symptoms__c='';

        jobRef2.CoverageResponse__c = 'xyz';

        upsert jobRef2;

        list<CSS_Solutions__c> sollist=new list<CSS_Solutions__c>();

        CSS_Solutions__c solRef2 =  CSS_TestData.createSolutions(false,jobRef2.Id);
        solRef2.Repair_Response__c='Sucessful';

        CSS_Solutions__c solRef3 =  CSS_TestData.createSolutions(false,jobRef2.Id);
        solRef3.Repair_Response__c='Sucessful';

        sollist.add(solRef2);
        sollist.add(solRef3);
        upsert sollist;
        set<Id> solutionIds = new set<Id>();
        solutionIds.add(solRef2.id);
        solutionIds.add(solRef3.id);

        List<CSS_Solution_Component__c> solComList = new List<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solComRef = CSS_TestData.createSRT(false,jobRef2.Id,solRef2.Id);
        solComRef.System_Code__c = 'Test';

        solComRef.Component_Code__c = 'Test';
        solComRef.Failure_Mode__c = 'Test';
        solComRef.Solutions__c =solRef2.id;
        solComRef.AccountCodeType__c = 'Test-Test';
        solComRef.AccountCode_Call_Status__c = 'Failure';
        solComRef.Failure_Point__c=11.0;
        solComRef.Failure_Measure__c = null;

        solComRef.Failure_Date__c=date.today();
        solComRef.AccountCode__c = 'tst';
        solComRef.AccountCodeEdit__c='test';
        solComRef.CoveredPartsQty__c='0';
        solComRef.CampaignPartsPercentage__c='100';
        System.debug('The Solution Component Object');
        solComList.add(solComRef);


        CSS_Solution_Component__c solComRef1 = CSS_TestData.createSRT(false,jobRef2.Id,solRef2.Id);
        solComRef.System_Code__c = 'Test';

        solComRef1.Component_Code__c = 'Test';
        solComRef1.Failure_Mode__c = 'Test';
        solComRef1.Solutions__c =solRef2.id;

        solComRef1.AccountCode_Call_Status__c = 'Failure';
        solComRef1.Failure_Point__c=11.0;
        solComRef1.Failure_Measure__c = null;
        solComRef1.CoveredPartsQty__c='9999999';
        solComRef1.CampaignPartsPercentage__c='100';
        solComRef1.Failure_Date__c=date.today();

        solComList.add(solComRef1);
        insert solComList;
        CSS_Fault_Code__c fc3 = new CSS_Fault_Code__c(FaultCodeR2__c = '441',Related_Fault_Code__c = '234,546');
        fc3.Name = '441';
        fc3.Job_Order__c = jobRef2.Id;
        fc3.Sequence__c = 1; 
        fc3.Fault_Code_Type__c = 'APD-P';
        fc3.Mod__c = '0';
        fc3.isPole__c = false;
        fc3.Number_of_Solutions__c = '1';
        insert fc3;

        CSS_JobEventTemporary__c JETsys = new CSS_JobEventTemporary__c();
        JETsys.Attribute1__c = 'TH';
        JETsys.Attribute4__c ='TS';
        JETsys.key__c = 'FailCodes';
        JETsys.Attribute3__c = 'TURBO';
        JETsys.Attribute5__c = 'ASSEMBLY';
        JETsys.Attribute7__c='test';
        JETsys.Reason__c = '{\r\n\t\"Header\": {\r\n\t\t\"ReturnCodeDescription\": \"Normal, Successful completion.\",\r\n\t\t\"ReturnCode\": \"ORA-00000\",\r\n\t\t\"MessageIdentifier\": \"S\"\r\n\t},\r\n\t\"DataArea\": [{\r\n\t\t\"SystemCode\": \"WF\",\r\n\t\t\"FailureName\": \"ATC 1795\",\r\n\t\t\"FailureMode\": \"SP\",\r\n\t\t\"FailureID\": \"F30003750\",\r\n\t\t\"ComponentCode\": \"HA\"\r\n\t}]\r\n}';
        insert JETsys;

        CSS_JobEventTemporary__c JETsys1 = new CSS_JobEventTemporary__c();
        JETsys1.Attribute1__c = 'ISX12 CM2350 X102';
        JETsys1.Attribute2__c ='OK';
        JETsys1.key__c = 'GetFailureCodesSRT';
        JETsys1.Attribute3__c = 'ISX12 CM2350 X102;;0K';
        JETsys1.Attribute5__c = 'ASSEMBLY';
        JETsys1.Reason__c = '{\r\n\t\"Header\": {\r\n\t\t\"ReturnCodeDescription\": \"Normal, Successful completion.\",\r\n\t\t\"ReturnCode\": \"ORA-00000\",\r\n\t\t\"MessageIdentifier\": \"S\"\r\n\t},\r\n\t\"DataArea\": [{\r\n\t\t\"SystemCode\": \"WF\",\r\n\t\t\"FailureName\": \"ATC 1795\",\r\n\t\t\"FailureMode\": \"SP\",\r\n\t\t\"FailureID\": \"F30003750\",\r\n\t\t\"ComponentCode\": \"HA\"\r\n\t}]\r\n}';
        insert JETsys1;
        List<CSS_Fault_Code__c> lstFC1 = new List<CSS_Fault_Code__c>();
        lstFC1.add(fc3);
        PageReference pref;
        pref = new PageReference('/'+jobRef2.id);
        pref.getParameters().put('id',jobRef2.id);
        Test.setCurrentPage(pref);

        CSS_Integration_Details__c cid = CSS_TestData.createIntegrationDetails(false);
        cid.name = 'CSS_SBL_WarrantyDetailCoverage';
        cid.ApplicationName__c = 'CSS_SBL_WarrantyDetailCoverage';
        cid.End_Point__c = 'https://services-stg.cummins.com/csswarranty/accodecoverage';
        insert cid;
        Map<String,String> systemCodeMap = new Map<String,String>();
        systemCodeMap.put('THT','THT');
        systemCodeMap.put('tes','THT');
        Map<String,String> custFailureNameList = new Map<String,String>();
        custFailureNameList.put('test','THT');
        custFailureNameList.put('tes','THT');
        Map<String,String> failureNameWithSystemCodeMap = new Map<String,String>();
        failureNameWithSystemCodeMap.put('test','THT');
        failureNameWithSystemCodeMap.put('tes','THT');
        Map<String,String> failureNameWithCompCodeMap = new Map<String,String>();
        failureNameWithCompCodeMap.put('test','THT');
        failureNameWithCompCodeMap.put('tes','THT');
        Map<String,String> FailureNameWithFailureIDMap = new Map<String,String>();
        FailureNameWithFailureIDMap.put('test','THT');
        FailureNameWithFailureIDMap.put('tes','THT');
        Set<String> failureNameList=new Set<String>();
        failureNameList.add('test');
        test.startTest();
        CSS_JobPlanOverviewControllerNew JobPlanOverCont1 = new CSS_JobPlanOverviewControllerNew();
        jobPlanOverCont1.selectedSysCode='THT';
        jobPlanOverCont1.systemCodeMap=systemCodeMap;
        JobPlanOverCont1.changeSystemcode_New();
        jobPlanOverCont1.selectedCustFName='test';
        JobPlanOverCont1.changeSystemcode_New();
        jobPlanOverCont1.selectedCustFName='test';
        jobPlanOverCont1.custFailureNameList=custFailureNameList;
        jobplanovercont1.changeCustFailures_New();
        jobPlanOverCont1.selectedCustFName='on';
        jobplanovercont1.changeCustFailures_New();
        jobPlanOverCont1.failureNameWithSystemCodeMap=failureNameWithSystemCodeMap;
        jobPlanOverCont1.failureNameWithCompCodeMap=failureNameWithCompCodeMap;
        jobPlanOverCont1.FailureNameWithFailureIDMap=FailureNameWithFailureIDMap;
        jobplanovercont1.failureNameList=failureNameList;
        jobplanovercont1.selectedFName='unlisted';
        jobplanovercont1.changeFailures_New();
        Test.setMock(HttpCalloutMock.class, new CSS_SRTCompMockup_Test());
        jobplanovercont1.selectedFName='';
        Set<String> failureNameList1=new Set<String>();
        jobplanovercont1.failureNameList=failureNameList1;
        jobplanovercont1.getSRTFailurenamesOnLoad();


        test.stopTest();
    }
    public static testMethod void TestMethod112()
    {

        //Creating Service Job--1
        CSS_Job_Order__c jobRef2 = CSS_TestData.createJobOrder(false); 
        jobRef2.Status__c='test';
        //CSS_Job_Order__c jobRef2 = new CSS_Job_Order__c();    
        list<string> falist=new list<string>();
        string st='Test';
        falist.add(st);
        list<string> partfalist=new list<string>();
        string st1='Test';
        partfalist.add(st1);

        CSS_JobPlanOverviewControllerNew obj=new CSS_JobPlanOverviewControllerNew();
        obj.faultList=falist;
        obj.partlistFAULT=partfalist;

        jobRef2.chevron_page__c='jo';
        jobRef2.BMSWSStatus__c = 'UI';
        jobRef2.CSS_Resolution__c = 'Test';
        jobRef2.General_Symptoms__c='';

        jobRef2.CoverageResponse__c = 'xyz';

        upsert jobRef2;

        list<CSS_Solutions__c> sollist=new list<CSS_Solutions__c>();

        CSS_Solutions__c solRef2 =  CSS_TestData.createSolutions(false,jobRef2.Id);
        solRef2.Repair_Response__c='Sucessful';

        CSS_Solutions__c solRef3 =  CSS_TestData.createSolutions(false,jobRef2.Id);
        solRef3.Repair_Response__c='Sucessful';

        sollist.add(solRef2);
        sollist.add(solRef3);
        upsert sollist;
        set<Id> solutionIds = new set<Id>();
        solutionIds.add(solRef2.id);
        solutionIds.add(solRef3.id);

        List<CSS_Solution_Component__c> solComList = new List<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solComRef = CSS_TestData.createSRT(false,jobRef2.Id,solRef2.Id);
        solComRef.System_Code__c = 'Test';

        solComRef.Component_Code__c = 'Test';
        solComRef.Failure_Mode__c = 'Test';
        solComRef.Solutions__c =solRef2.id;
        solComRef.AccountCodeType__c = 'Test-Test';
        solComRef.AccountCode_Call_Status__c = 'Failure';
        solComRef.Failure_Point__c=11.0;
        solComRef.Failure_Measure__c = null;
        solComRef.Root_Cause__c = true;
        solComRef.Failure_Date__c=date.today();
        solComRef.AccountCode__c = 'tst';
        solComRef.AccountCodeEdit__c='test';
        solComRef.CoveredPartsQty__c='0';
        solComRef.CampaignPartsPercentage__c='100';
        System.debug('The Solution Component Object');
        solComList.add(solComRef);


        CSS_Solution_Component__c solComRef1 = CSS_TestData.createSRT(false,jobRef2.Id,solRef2.Id);
        solComRef.System_Code__c = 'Test';

        solComRef1.Component_Code__c = 'Test';
        solComRef1.Failure_Mode__c = 'Test';
        solComRef1.Solutions__c =solRef2.id;
        solComRef1.Root_Cause__c = true;
        solComRef1.AccountCode_Call_Status__c = 'Failure';
        solComRef1.Failure_Point__c=11.0;
        solComRef1.Failure_Measure__c = null;
        solComRef1.CoveredPartsQty__c='9999999';
        solComRef1.CampaignPartsPercentage__c='100';
        solComRef1.Failure_Date__c=date.today();

        solComList.add(solComRef1);
        insert solComList;
        CSS_Fault_Code__c fc3 = new CSS_Fault_Code__c(FaultCodeR2__c = '441',Related_Fault_Code__c = '234,546');
        fc3.Name = '441';
        fc3.Job_Order__c = jobRef2.Id;
        fc3.Sequence__c = 1; 
        fc3.Fault_Code_Type__c = 'APD-P';
        fc3.Mod__c = '0';
        fc3.isPole__c = false;
        fc3.Number_of_Solutions__c = '1';
        insert fc3;

        CSS_JobEventTemporary__c JETsys = new CSS_JobEventTemporary__c();
        JETsys.Attribute1__c = 'TH';
        JETsys.Attribute4__c ='TS';
        JETsys.key__c = 'FailCodes';
        JETsys.Attribute3__c = 'TURBO';
        JETsys.Attribute5__c = 'ASSEMBLY';
        JETsys.Reason__c = '{\r\n\t\"Header\": {\r\n\t\t\"ReturnCodeDescription\": \"Normal, Successful completion.\",\r\n\t\t\"ReturnCode\": \"ORA-00000\",\r\n\t\t\"MessageIdentifier\": \"S\"\r\n\t},\r\n\t\"DataArea\": [{\r\n\t\t\"SystemCode\": \"WF\",\r\n\t\t\"FailureName\": \"ATC 1795\",\r\n\t\t\"FailureMode\": \"SP\",\r\n\t\t\"FailureID\": \"F30003750\",\r\n\t\t\"ComponentCode\": \"HA\"\r\n\t}]\r\n}';
        insert JETsys;

        CSS_JobEventTemporary__c JETsys1 = new CSS_JobEventTemporary__c();
        JETsys1.Attribute1__c = 'ISX12 CM2350 X102';
        JETsys1.Attribute2__c ='OK';
        JETsys1.key__c = 'GetFailureCodesSRT';
        JETsys1.Attribute3__c = 'ISX12 CM2350 X102;;0K';
        JETsys1.Attribute5__c = 'ASSEMBLY';
        JETsys1.Reason__c = '{\r\n\t\"Header\": {\r\n\t\t\"ReturnCodeDescription\": \"Normal, Successful completion.\",\r\n\t\t\"ReturnCode\": \"ORA-00000\",\r\n\t\t\"MessageIdentifier\": \"S\"\r\n\t},\r\n\t\"DataArea\": [{\r\n\t\t\"SystemCode\": \"WF\",\r\n\t\t\"FailureName\": \"ATC 1795\",\r\n\t\t\"FailureMode\": \"SP\",\r\n\t\t\"FailureID\": \"F30003750\",\r\n\t\t\"ComponentCode\": \"HA\"\r\n\t}]\r\n}';
        insert JETsys1;
        List<CSS_Fault_Code__c> lstFC1 = new List<CSS_Fault_Code__c>();
        lstFC1.add(fc3);
        PageReference pref;
        pref = new PageReference('/'+jobRef2.id);
        pref.getParameters().put('id',jobRef2.id);
        Test.setCurrentPage(pref);

        CSS_Integration_Details__c cid = CSS_TestData.createIntegrationDetails(false);
        cid.name = 'CSS_SBL_WarrantyDetailCoverage';
        cid.ApplicationName__c = 'CSS_SBL_WarrantyDetailCoverage';
        cid.End_Point__c = 'https://services-stg.cummins.com/csswarranty/accodecoverage';
        insert cid;
        test.startTest();
        CSS_JobPlanOverviewControllerNew JobPlanOverCont1 = new CSS_JobPlanOverviewControllerNew();
        JobPlanOverCont1.mainSOQL();
        JobPlanOverCont1.jobClosePopup();
        JobPlanOverCont1.workjob.DSID__c = '12345';
        JobPlanOverCont1.workjob.Quote_ID__c = '12345';
        JobPlanOverCont1.workjob.ApplicationCode__c = '130';
        JobPlanOverCont1.NotesBody = 'false';
        JobPlanOverCont1.accQuoteFlag=false;
        JobPlanOverCont1.showRepairs = true;
        JobPlanOverCont1.showResolution = true;
        JobPlanOverCont1.showResolutionWithRepair=false;
        JobPlanOverCont1.onAddClick();
        JobPlanOverCont1.retry();
        JobPlanOverCont1.closeSession();
        JobPlanOverCont1.showRepairs=true;
        JobPlanOverCont1.showResolutionWithRepair=false;
        JobPlanOverCont1.changefailmode();
        JobPlanOverCont1.changefaultcode();
        JobPlanOverCont1.checkFaultCode();
        JobPlanOverCont1.updatestatus();
        JobPlanOverCont1.parts();
        JobPlanOverCont1.changeCustFailures_New();
        JobPlanOverCont1.changeSystemcode_New();
        JobPlanOverCont1.componentId = '12345';
        JobPlanOverCont1.AuthNumber = '12345';
        JobPlanOverCont1.PayCode = '23345';
        JobPlanOverCont1.complaintcounter = 12234;
        JobPlanOverCont1.coveragecounter = 12245;
        JobPlanOverCont1.causecounter = 35456;
        JobPlanOverCont1.compName = 'test12';
        JobPlanOverCont1.compID1 = '23454';
        JobPlanOverCont1.fcWS = 'test12';
        JobPlanOverCont1.acWS = 'test76';
        JobPlanOverCont1.fcPopup = 'test54';
        JobPlanOverCont1.acPopup = 'test34';
        JobPlanOverCont1.recordId = '12432544223';
        JobPlanOverCont1.displayMPopUp = true;
        JobPlanOverCont1.selAccCode = 'test12';
        JobPlanOverCont1.warrantyCompFailure = true;
        JobPlanOverCont1.failmode = 'test2';
        JobPlanOverCont1.claimtype = 'test23';
        JobPlanOverCont1.accountCodeType = 'test5';
        JobPlanOverCont1.selectedAccFormula = true;
        JobPlanOverCont1.FailureDtHidden = 'test24';
        JobPlanOverCont1.displayERPButtonDlr = true;
        JobPlanOverCont1.workjobStatus = 'open';
        JobPlanOverCont1.failCodeChange = true;
        JobPlanOverCont1.faultCode = 'tsestwf';
        JobPlanOverCont1.payCodeSelected = 'Select One';
        JobPlanOverCont1.selectedFName =  'siva';
        JobPlanOverCont1.selectedSysCode ='THE';
        JobPlanOverCont1.selectedCompCode='TS';
        JobPlanOverCont1.selectedFailMode = 'test1';
        JobPlanOverCont1.errormsgfailpoint = false;
        JobPlanOverCont1.selectedFaultCode = '467432356';
        JobPlanOverCont1.appCodeSelected = 'test12';
        JobPlanOverCont1.claimTypeSelected = 'open';
        JobPlanOverCont1.accCodeReturned = 'testing';
        JobPlanOverCont1.selectedCompId = '12345567';
        JobPlanOverCont1.sendfailtoERP = false;
        JobPlanOverCont1.authNumbers = '34567';
        JobPlanOverCont1.checkPartsWarrStartDt = true;

        //JobPlanOverCont1.callUnitInboundGeneric();
        JobPlanOverCont1.callUpdateUnitandWo();
        Map<String,String> tempMap  = new map<String,String>();
        tempMap.put('siva','TH');
        JobPlanOverCont1.failureNameWithSystemCodeMap  = tempMap;
        JobPlanOverCont1.failureNameWithCompCodeMap  = tempMap;
        JobPlanOverCont1.changeFailures_New();
        JobPlanOverCont1.selectedFName =  'unlisted';
        JobPlanOverCont1.changeFailures_New();
        JobPlanOverCont1.jobplan_jo();
        //JobPlanOverCont1.getListWrap();

        //     JobPlanOverCont1.jobplan_war();
        JobPlanOverCont1.jobplan_narr();
        JobPlanOverCont1.jobplan_prt();
        JobPlanOverCont1.saveRootCause();

        JobPlanOverCont1.pgSave();
        JobPlanOverCont1.showPopup();
        JobPlanOverCont1.closePopup();
        JobPlanOverCont1.redirectPopup();
        JobPlanOverCont1.getAccountCodes1();
        JobPlanOverCont1.closeSession_close();
        JobPlanOverCont1.jobPlanAction();
        //JobPlanOverCont1.pgSaveFinish();
        // JobPlanOverCont1.clearpopup();
        //   JobPlanOverCont1.parts();
        //     JobPlanOverCont1.updatestatus();
        // JobPlanOverCont1.jobplan_prt();
        Test.setMock(HttpCalloutMock.class , new CSS_WS_SBL_GetWarrantyDetailCovrg_Test());
        JobPlanOverCont1.checkCoverageNew();
        JobPlanOverCont1.onChangeofAppCode();

        JobPlanOverCont1.getfailurenames();
        jobplanovercont1.getclaimTypes();
        Test.setMock(HttpCalloutMock.class , new CSS_WS_SBL_GetWarrantyDetailCovrg_Test());
        JobPlanOverCont1.checkcoverage();
        jobplanovercont1.showEditLink=false;
        jobplanovercont1.showRepairErrorMessage=false;
        jobplanovercont1.newQuoteStr='Test';
        jobplanovercont1.displayBMSuserClosePopup=false;
        jobplanovercont1.solCompRec=solComRef1;
        system.assert(jobplanovercont1.listcertificatedetails==null);
        system.assert(jobplanovercont1.faultCodeList==null);
        jobplanovercont1.solnCompRec=solComRef1;
        jobplanovercont1.ParentSolName='Test';
        JobPlanOverCont1.Wid=null;
        JobPlanOverCont1.pgSave();
        Test.stopTest();        
    }
    public static testMethod void TestMethod211()
    {

        UserRole empRole = [Select Id From UserRole Where Name = 'Factory' Limit 1];
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'kal1', Email='standarduser11@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='kal12', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='kal11111@testorg.com', user_Location__c = '56270-56255',UserRoleId = empRole.id);
        insert(u);
        list<CSS_Solution_Component__c> solcomreflist ;
        CSS_Solutions__c solRef;
        CSS_Job_Order__c jobRef;
        CSS_Solution_Component__c solComRef1;
        System.runAs(u) 
        {  


            //Creating Job--1
            jobRef = CSS_TestData.createJobOrder(false);
            jobRef.chevron_page__c='jo';
            jobRef.BMSWSStatus__c = 'UI';
            jobRef.ESN__c ='123';
            jobRef.Service_Model__c ='ISX12 CM2350 X102';
            jobRef.Qsol_Engine_Family_Code__c ='0K';
            jobref.CoverageResponse__c = 'Testing';
            jobRef.Failure_Date__c = System.today();
            insert jobRef;
            PageReference pref;
            pref = new PageReference('/'+jobRef.id);
            pref.getParameters().put('id',jobRef.id);
            Test.setCurrentPage(pref);

            CSS_JobEventTemporary__c JETsys = new CSS_JobEventTemporary__c();
            JETsys.Attribute1__c = 'TH';
            JETsys.Attribute4__c ='TS';
            JETsys.key__c = 'FailCodes';
            JETsys.Attribute3__c = 'TURBO';
            JETsys.Attribute5__c = 'ASSEMBLY';
            insert JETsys;

            CSS_JobEventTemporary__c JETsys1 = new CSS_JobEventTemporary__c();
            JETsys1.Attribute1__c = 'ISX12 CM2350 X102';
            JETsys1.Attribute2__c ='OK';
            JETsys1.key__c = 'GetFailureCodesSRT';
            JETsys1.Attribute3__c = 'ISX12 CM2350 X102;;0K';
            JETsys1.Attribute5__c = 'ASSEMBLY';
            //  JETsys1.Reason__c = '{\r\n\t\"Header\": {\r\n\t\t\"ReturnCodeDescription\": \"Normal, Successful completion.\",\r\n\t\t\"ReturnCode\": \"ORA-00000\",\r\n\t\t\"MessageIdentifier\": \"S\"\r\n\t},\r\n\t\"DataArea\": [{\r\n\t\t\"SystemCode\": \"WF\",\r\n\t\t\"FailureName\": \"ATC 1795\",\r\n\t\t\"FailureMode\": \"SP\",\r\n\t\t\"FailureID\": \"F30003750\",\r\n\t\t\"ComponentCode\": \"HA\"\r\n\t}]\r\n}';
            JETsys1.Reason__c = '{ "DataArea": [ { "ComponentCode": "CG", "FailureMode": "", "FailureID": "F30000860", "FailureName": "Accessory Plate Cover Gasket", "SystemCode": "BG" }],  "Header": { "ReturnCodeDescription":"Normal, Successful completion.", "ReturnCode": "ORA-00000", "MessageIdentifier": "S" } }';
            insert JETsys1;

            CSS_JobEventTemporary__c JETsys2 = new CSS_JobEventTemporary__c();
            JETsys2.Attribute1__c = 'POL';
            JETsys2.Attribute2__c ='CDA POLICY';
            JETsys2.key__c = 'AccountCodes';
            JETsys2.Attribute3__c = '58';
            JETsys2.Attribute5__c = 'ASSEMBLY';
            insert JETsys2;

            //Creating Fault code
            CSS_Fault_Code__c fauCodRef = new CSS_Fault_Code__c();
            fauCodRef.Job_Order__c =jobRef.Id; 
            fauCodRef.Sequence__c=1;
            fauCodRef.Fault_Code_Type__c='BPD'; 
            fauCodRef.Primary_Fault_Code__c=3539; 
            fauCodRef.Status__c='A';
            insert fauCodRef;
            List<CSS_Fault_Code__c> fauCodRefList = new List<CSS_Fault_Code__c>();
            fauCodRefList.add(fauCodRef);

            //Creating Soltions--3
            solRef =  CSS_TestData.createSolutions(true,jobRef.Id);
            solRef.FaultCode__c = fauCodRef.id;
            update solRef;


            //Creating Solution Component--4
            for(integer i=0;i<5;i++)
            {
                CSS_Solution_Component__c solComRef = CSS_TestData.createSRT(false,jobRef.Id,solRef.Id);
                solComRef.System_Code__c = 'Test';
                solComRef.Component_Code__c = 'Test';
                solComRef.Failure_Mode__c = 'Test';
                solComRef.Solutions__c =solRef.id;
                solComRef.AccountCodeType__c = 'Test-Test';
                solComRef.AccountCode_Call_Status__c = 'Failure';
                solComRef.Failure_Point__c=11.0;
                solComRef.Failure_Date__c=date.parse('12/27/2014');
                solComRef.AccountCode__c = 'test';
                solComRef.AccountCodeEdit__c = 'CHINA JV POLICY JV';
                solcomref.Component_Id__c='F30000860';
                //solComRef.Failure_Date__c = null;
                System.debug('The Solution Component Object' +solComRef);

                insert solComRef;
            }

            CSS_Solution_Component__c solnComp = new CSS_Solution_Component__c();
            solnComp.Failure_Measure__c = 'miles';
            solnComp.CoveredLaborHrs__c='0';
            solnComp.CoveredMealsLodgingAmt__c='0';
            solnComp.CoveredOCAmount__c='0';
            solnComp.CoveredPartsQty__c='0';
            solnComp.CoveredTowingMiles__c='0';
            solnComp.CoveredTravelLabor__c='0';
            solnComp.CoveredTravelMiles__c='0';
            solnComp.CampaignPartsPercentage__c='0';
            solnComp.CoveredTravelBaseFareAmt__c='0';
            solnComp.WarrantyId__c='0';
            solnComp.CampaignLaborPercentage__c='0';
            solnComp.CampaignOCPercentage__c='0';
            solnComp.CampaignTowingPercentage__c='0';
            solnComp.CampaignTravelPercentage__c='0';
            solnComp.DeductibleAmount__c='0';
            insert solnComp;

            solComRef1 = CSS_TestData.createSRT(false,jobRef.Id,solRef.Id);
            solComRef1.System_Code__c = 'Test';
            solComRef1.Component_Code__c = 'Test';
            solComRef1.Failure_Mode__c = 'Test';
            solComRef1.Solutions__c =solRef.id;

            solComRef1.AccountCode_Call_Status__c = 'Failure';
            solComRef1.Failure_Point__c=11.0;
            solComRef1.Failure_Date__c=date.parse('12/27/2014');
            solComRef1.AccountCode__c = 'test';
            solComRef1.AccountCodeEdit__c ='';
            solcomref1.Component_Id__c='F30000860';
            solcomref1.AccountCodeType__c='NEW-New Engine Warranty';
            solcomref1.Parts_Warranty__c='New Parts Warranty';
            solcomref1.Customer_Take_Possession__c='Yes';
            //solComRef.Failure_Date__c = null;
            System.debug('The Solution Component Object' +solComRef1);

            insert solComRef1;

            solcomreflist = [select id,Component_Id__c,name,System_Code__c,Component_Code__c,CSS_Account_Formula__c,Failure_Mode__c,Solutions__c,AccountCodeType__c,AccountCode_Call_Status__c,Failure_Point__c,Failure_Date__c,AccountCodeEdit__c from CSS_Solution_Component__c];
            //System.debug('The Solution Component Object is:'+solComRef);
            boolean accCodeExist=false;

            CSS_Parts_Options__c parts = new CSS_Parts_Options__c();
            parts.Option_Number__c = 'O-111';
            parts.Service_Job__c = jobRef.Id;
            parts.selected_part__c = true;
            parts.FailurepartId__c = solcomreflist[0].Id;
            parts.Part_Assignment__c = 'Primary';
            //parts.Solutions__c=sol.Id;

            insert parts;
            //Populating Account codes
            List<SelectOption> accCodes = new List<SelectOption>();
            accCodes.add(new SelectOption('Test1','Test1'));
            accCodes.add(new SelectOption('Test2','Test2'));
            accCodes.add(new SelectOption('Test3','Test3'));
            accCodes.add(new SelectOption('Test4','Test4'));

            Account acc = new Account();
            acc.name='R1test';
            acc.CSS_DistributorCode__c='03520';
            acc.CSS_DealerCode__c='';
            acc.CSS_FleetCode__c = '';
            acc.CSS_DBCode__c = '04892';
            acc.ERP_System__c = 'One BMS';
            acc.Type = 'Customer';

            insert acc;

            CSS_Job_Order__c JO = new CSS_Job_Order__c();
            JO.Customer_Name__c = '';
            JO.Shop_Work_Order__c = '';
            JO.status__c = '';
            JO.Application__c = 'Recreational Vehicle';
            JO.Model__c = 'RajTest';

            JO.Account__c = acc.id;
            insert JO;


            test.startTest();
            CSS_JobPlanOverviewControllerNew obj1=new CSS_JobPlanOverviewControllerNew();
            obj1.accCodeEditable='Test';
            obj1.componentId = String.valueOf(solcomreflist[0].id);
            obj1.failureDate = System.today();
            obj1.failureDate1 = System.today();
            obj1.warrantyDate = System.today();
            obj1.partsWarrDt = system.today();
            obj1.warrStDtHidden = 'Testing';
            obj1.accCodeSelected = 'EMISSION WARRANTY 70';
            obj1.selectedFaultCode = null;
            obj1.selectedFaultCode = '';
            obj1.Wid = null;
            obj1.comm = 'Testing';
            obj1.Cancel();

            //select Attribute1__c, Attribute3__c from CSS_JobEventTemporary__c where key__c='FailModes'
            list<CSS_JobEventTemporary__c> jetl =new list<CSS_JobEventTemporary__c>();

            CSS_JobEventTemporary__c jet=new CSS_JobEventTemporary__c();
            jet.key__c='FailModes';
            jet.Name='Test';
            insert jet;
            jetl.add(jet);
            upsert jetl;

            //obj1.loadPopup();

            obj1.jobplan_jpq();
            obj1.jobplan_srt();
            obj1.onAddClick();
            CSS_JobEventTemporary__c jetAccCodes = new CSS_JobEventTemporary__c();
            jetAccCodes.key__c='AccountCodes';
            jetAccCodes.Attribute1__c = 'OTH';
            jetAccCodes.Attribute2__c = 'EQ7556';
            jetAccCodes.Name='Test';
            insert jetAccCodes;
            obj1.checkCoverageNew();
            obj1.failureMeasure='Hours';
            obj1.coverageType = 'POL';
            obj1.Validations();
            obj1.coverageType = 'NPW';
            obj1.coverageFound = 'false';
            obj1.accCodeSelected = '52';
            obj1.selectedFailMode = 'THAS';
            obj1.chkClickonPartsCoverage = false;
		    set<string> setBlankFieldset = new set<string>();
            setBlankFieldset.add('false');
		    //obj1.tempblankfieldset = setBlankFieldset;
            obj1.Validations();
            obj1.pgSave();
            obj1.saveCheckBox();
            obj1.getAccountCodes();
            obj1.mainSOQL();
        }
        Test.setMock(HttpCalloutMock.class, new CSS_SRTCompMockup_Test());
        CSS_JobPlanOverviewControllerNew JobPlanOverCont = new CSS_JobPlanOverviewControllerNew();
        //CSS_Solution_Component__c solComm=[select id from css_solution_component__c limit 1];
        // system.debug('solution Component value'+solComm);
        //JobPlanOverCont.componentId = 'solComRef.Id';
        JobPlanOverCont.failCodeSelected = 'Engine Control Module Calibration-EQPE';
        JobPlanOverCont.accCodeSelected = 'PARTS WARRANTY 35';
        JobPlanOverCont.failCodeEditable='Engine Control Module Calibration-EQPE';
        //JobPlanOverCont.allFaultCodes = fauCodRefList;

        //JobPlanOverCont.mainSOQL();
        JobPlanOverCont.failCodeChangeGO();
        //JobPlanOverCont.retry();
        Test.setMock(HttpCalloutMock.class, new CSS_MockHttpResponseGenerator()); 
        JobPlanOverCont.callCreateWoqtInbound('Test+Rupesh');
        //JobPlanOverCont.onAddClick();//Moved Here and it gives no error

        Test.setMock(HttpCalloutMock.class , new CSS_WS_SBL_GetWarrantyDetailCovrg_Test());
        JobPlanOverCont.partssave();
        JobPlanOverCont.clearPopup();
        JobPlanOverCont.onChangeofAppCode();
        jobplanovercont.compPartsList=solcomreflist;
        jobplanovercont.buildConcatenatedFailCodes();
        string json ='[ { "PAYCODEDESCRIPTION": "PAYCODEDESCRIPTION", "PAYCODE": "PAYCODE" } ]';
        map<string,string> maptemp = new map<string,string>();
        maptemp.put('test', json);
        jobplanovercont.mapAccCode=maptemp;
        jobplanovercont.getPayCodesList('test');
        jobplanovercont.checkCoverageNew();
        jobplanovercont.compont=solComRef1;
        jobplanovercont.onAddClick();
        Test.stopTest();
    }

    public static testMethod void TestMethod4_1()
    {
        CSS_Job_Order__c jobRef = CSS_TestData.createJobOrder(false);
        jobRef.chevron_page__c='jo';
        jobRef.BMSWSStatus__c = 'UI';
        jobRef.ESN__c ='123';
        jobRef.Service_Model__c ='ISX12 CM2350 X102';
        jobRef.Qsol_Engine_Family_Code__c ='0K';
        jobref.CoverageResponse__c = 'Testing';
        jobRef.Failure_Date__c = System.today();
        jobRef.CSS_Job_Location_Code__c = '03742-03742';
        insert jobRef;
        PageReference pref;
        pref = new PageReference('/'+jobRef.id);
        pref.getParameters().put('id',jobRef.id);
        Test.setCurrentPage(pref);

        //Creating Fault code
        CSS_Fault_Code__c fauCodRef = new CSS_Fault_Code__c();
        fauCodRef.Job_Order__c =jobRef.Id; 
        fauCodRef.Sequence__c=1;
        fauCodRef.Fault_Code_Type__c='BPD'; 
        fauCodRef.Primary_Fault_Code__c=3539; 
        fauCodRef.Status__c='A';
        insert fauCodRef;
        List<CSS_Fault_Code__c> fauCodRefList = new List<CSS_Fault_Code__c>();
        fauCodRefList.add(fauCodRef);

        CSS_SymptomQA__c symqa=new CSS_SymptomQA__c();
        symqa.name='TESST';
        insert symqa; 

        CSS_Solutions__c solRef =  CSS_TestData.createSolutions(false,jobRef.Id);
        solRef.FaultCode__c = fauCodRef.id;
        insert solRef;
        solRef.Symptom__c=symqa.id;
        upsert solref;

        for(integer i=0;i<5;i++)
        {
            CSS_Solution_Component__c solComRef = CSS_TestData.createSRT(false,jobRef.Id,solRef.Id);
            solComRef.System_Code__c = 'Test';
            solComRef.Component_Code__c = 'Test';
            solComRef.Failure_Mode__c = 'Test';
            solComRef.Solutions__c =solRef.id;
            solComRef.AccountCodeType__c = 'Test-Test';
            solComRef.AccountCode_Call_Status__c = 'Failure';
            solComRef.Failure_Point__c=11.0;
            // solComRef.Failure_Date__c=date.parse('12/27/2014');
            solComRef.Failure_Date__c = Date.newInstance(2014, 12, 27);
            solComRef.AccountCode__c = 'ACDIED-DF';
            solComRef.Fault_Code__c='Test';    
            System.debug('The Solution Component Object' +solComRef);

            insert solComRef;
        }

        list<CSS_Solution_Component__c> solcomreflist = [select id,System_Code__c,Component_Code__c,Failure_Mode__c,Solutions__c,AccountCodeType__c,AccountCode_Call_Status__c,Failure_Point__c,Failure_Date__c,AccountCodeEdit__c from CSS_Solution_Component__c];
        //System.debug('The Solution Component Object is:'+solComRef);
        boolean accCodeExist=false;

        CSS_JobEventTemporary__c JETsys = new CSS_JobEventTemporary__c();
        JETsys.Attribute1__c = 'TH';
        JETsys.Attribute4__c ='TS';
        JETsys.key__c = 'FailCodes';
        JETsys.Attribute3__c = 'TURBO';
        JETsys.Attribute5__c = 'ASSEMBLY';
        JETsys.Active__c  = true;
        insert JETsys;

        CSS_JobEventTemporary__c JETsys1 = new CSS_JobEventTemporary__c();
        JETsys1.Attribute1__c = 'ISX12 CM2350 X102';
        JETsys1.Attribute2__c ='OK';
        JETsys1.key__c = 'GetFailureCodesSRT';
        JETsys1.Attribute3__c = 'ISX12 CM2350 X102;;0K';
        JETsys1.Attribute5__c = 'ASSEMBLY';
        JETsys1.Reason__c = '{\r\n\t\"Header\": {\r\n\t\t\"ReturnCodeDescription\": \"Normal, Successful completion.\",\r\n\t\t\"ReturnCode\": \"ORA-00000\",\r\n\t\t\"MessageIdentifier\": \"S\"\r\n\t},\r\n\t\"DataArea\": [{\r\n\t\t\"SystemCode\": \"WF\",\r\n\t\t\"FailureName\": \"ATC 1795\",\r\n\t\t\"FailureMode\": \"SP\",\r\n\t\t\"FailureID\": \"F30003750\",\r\n\t\t\"ComponentCode\": \"HA\"\r\n\t}]\r\n}';
        insert JETsys1;

        CSS_JobEventTemporary__c JETsys2 = new CSS_JobEventTemporary__c();
        JETsys2.Attribute1__c = 'POL';
        JETsys2.Attribute2__c ='CDA POLICY';
        JETsys2.key__c = 'AccountCodes';
        JETsys2.Attribute3__c = '58';
        JETsys2.Attribute5__c = 'ASSEMBLY';
        insert JETsys2;

        list<CSS_JobEventTemporary__c> jetl =new list<CSS_JobEventTemporary__c>();

        CSS_JobEventTemporary__c jet=new CSS_JobEventTemporary__c();
        jet.Attribute1__c='OTH';jet.Attribute1__c='POL';jet.Attribute1__c='NPW';jet.Attribute1__c='RPW';jet.Attribute1__c='REW';jet.Attribute1__c='RRW ';
        jet.Reason__c='TEE';
        jet.key__c='FailModes';
        jet.Name='Test';
        insert jet;
        jetl.add(jet);
        upsert jetl;

        Profile p = [SELECT Id FROM Profile WHERE Name='CSS_Dealer_Data_ExChange_Admin'];
        Account objAcc = new Account(name ='Test Account',CSS_DealerCode__c='03742',CSS_DBCode__c='33333',CSS_DistributorCode__c='11111',Type = 'Customer');
        insert objAcc; 

        Contact objContact = new Contact(LastName ='testCon',AccountId = objAcc.Id,CMI_Contact_Type__c = 'Secondary', IAM_Cummins_login_ID__c='Danielakanksha@truck.com',IAM_Contact_Status__c = 'Active',Email = 'akanksha.p@gmail.com',FirstName ='akanksha',Phone='000-000-0000');
        insert objContact;  
        Account acc = new Account();
        acc.name='Rtest';
        acc.CSS_DistributorCode__c='03742';
        acc.CSS_DealerCode__c='03742';
        acc.CSS_DBCode__c='33333';
        acc.Type = 'Customer';
        //  acc.Location__c = '12345-12345';

        insert acc;
        User u = new User(Alias = 'standt', Email='standarduser2@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTestUser2@testorg.com',User_Location__c = '03742-03742',ContactId=objContact.id);
        // insert u;
        CSS_UserLocation__c userLocation = new CSS_UserLocation__c (AccountId__c=acc.id,isActive__c=true,isPrimary__c=true,UserId__c=u.Id,Location_code__c='03742-03742');
        insert userLocation;
        id UserId = u.Id;
        system.debug('UserId:' +UserId);
        css_utility.getOrgType(UserId);


        test.startTest();

        //System.runAs(u) 

        CSS_JobPlanOverviewControllerNew obj1=new CSS_JobPlanOverviewControllerNew();
        obj1.accCodeEditable='Test';
        obj1.componentId = String.valueOf(solcomreflist[0].id);

        //obj1.loadPopup();
        obj1.getAccountCodes1();
        //obj1.pgSaveFinish();
        obj1.getFaultCodes();
        // obj1.jobplan_jpq();
        obj1.saveCheckBox();
        obj1.selectedFaultCode = 'TEST';

        obj1.getAccountCodes1();
        Test.setMock(HttpCalloutMock.class , new CSS_WS_SBL_GetWarrantyDetailCovrg_Test());
        obj1.checkcoverage();
        //obj1.jobplan_jpq();

        obj1.saveCheckBox();
        obj1.onChangeofAppCode();
        obj1.selectedFName='unlisted';


        test.stopTest();
    }

    public static testMethod void TestMethod6_1()
    {
        //This function is writtten to call lines that are not being covered in any testmethods
        UserRole empRole = [Select Id From UserRole Where Name = 'Factory' Limit 1];
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'kal1', Email='standarduser11@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='kal12', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='kal11111@testorg.com', user_Location__c = '56270-56255',UserRoleId = empRole.id);
        insert(u);
        System.runAs(u) 
        {  
            //Creating Job--1
            CSS_Job_Order__c jobRef = CSS_TestData.createJobOrder(false);
            jobRef.chevron_page__c='jo';
            jobRef.BMSWSStatus__c = 'UI';
            jobRef.ESN__c ='123';
            jobRef.Status__c='test';
            jobRef.Service_Model__c ='ISX12 CM2350 X102';
            jobRef.Qsol_Engine_Family_Code__c ='0K';
            String json = '{'+
                '   \"Header\":    {'+
                '      \"ReturnCodeDescription\": \"\",'+
                '      \"Status\": \"Success\"'+
                '   },'+
                '   \"BasicCoverageResponseHeader\": {\"Response\":    {'+
                '      \"ListOfCoverageDetails\": {\"CoverageDetails\":       ['+
                '                  {'+
                '            \"ListOfCoverageComponentList\": {\"CoverageComponentList\":             ['+
                '                              {'+
                '                  \"MegawattHours\": \"1000\",'+
                '                  \"CoverageMaxMonths\": \"30\",'+
                '                  \"CoverageComponentTypeCode\": \"EMISSIONS-CA\",'+
                '                  \"CoverageMinMonths\": \"20\",'+
                '                  \"CoverageHours\": \"100\",'+
                '                  \"CoverageDefenitionType\": \"BASE\",'+
                '                  \"CoverageMiles\": \"10\"'+
                '               },'+
                '                              {'+
                '                  \"MegawattHours\": \"123\",'+
                '                  \"CoverageMaxMonths\": \"234\",'+
                '                  \"CoverageComponentTypeCode\": \"BELTS/HOSES\",'+
                '                  \"CoverageMinMonths\": \"56\",'+
                '                  \"CoverageHours\": \"123\",'+
                '                  \"CoverageDefenitionType\": \"BASE\",'+
                '                  \"CoverageMiles\": \"123\"'+
                '               }'+
                '            ]},'+
                '            \"WarrantyManualURL\": \"www.test.com/ems\",'+
                '            \"CoverageType\": \"EMS-Emissions Warranty\",'+
                '            \"ListOfCoverageDedutibles\": {\"CoverageDedutibles\": []},'+
                '            \"ProcedureNumber\": \"ProcEMS\"'+
                '         },'+
                '                  {'+
                '            \"ListOfCoverageComponentList\": {\"CoverageComponentList\":             ['+
                '                              {'+
                '                  \"MegawattHours\": \"0\",'+
                '                  \"CoverageMaxMonths\": \"120\",'+
                '                  \"CoverageComponentTypeCode\": \"EMISSIONS-CA\",'+
                '                  \"CoverageMinMonths\": \"0\",'+
                '                  \"CoverageHours\": \"100000\",'+
                '                  \"CoverageDefenitionType\": \"BASE\",'+
                '                  \"CoverageMiles\": \"100000\"'+
                '               },'+
                '                              {'+
                '                  \"MegawattHours\": \"0\",'+
                '                  \"CoverageMaxMonths\": \"60\",'+
                '                  \"CoverageComponentTypeCode\": \"EMISSIONS\",'+
                '                  \"CoverageMinMonths\": \"0\",'+
                '                  \"CoverageHours\": \"0\",'+
                '                  \"CoverageDefenitionType\": \"BASE\",'+
                '                  \"CoverageMiles\": \"100000\"'+
                '               }'+
                '            ]},'+
                '            \"WarrantyManualURL\": \"\",'+
                '            \"CoverageType\": \"NEW-New Engine Warranty\",'+
                '            \"ListOfCoverageDedutibles\": {\"CoverageDedutibles\": []},'+
                '            \"ProcedureNumber\": \"\"'+
                '         }'+
                '      ]},'+
                '      \"ListOfExtendedCoverageDetails\": {\"ExtendedCoverageDetails\":       ['+
                '                  {'+
                '            \"ListOfExtCoverageDedutibles\": {\"ExtendedCoverageDedutibles\": []},'+
                '            \"WarrantyManualURL\": \"\",'+
                '            \"BeginMiles\": \"0\",'+
                '            \"EndMiles\": \"500000\",'+
                '            \"ProcedureNumber\": \"\",'+
                '            \"CertificateNumber\": \"TP41000811\",'+
                '            \"ProgramID\": \"TP4\",'+
                '            \"BeginHours\": \"0\",'+
                '            \"EndHours\": \"0\",'+
                '            \"EndDate\": \"09/21/2015\",'+
                '            \"StartDate\": \"09/21/2010\",'+
                '            \"Months\": \"60\",'+
                '            \"CAPCoverageID\": \"CRT\"'+
                '         },'+
                '                  {'+
                '            \"ListOfExtCoverageDedutibles\": {\"ExtendedCoverageDedutibles\": []},'+
                '            \"WarrantyManualURL\": \"\",'+
                '            \"BeginMiles\": \"0\",'+
                '            \"EndMiles\": \"300000\",'+
                '            \"ProcedureNumber\": \"\",'+
                '            \"CertificateNumber\": \"TP41000811\",'+
                '            \"ProgramID\": \"TP4\",'+
                '            \"BeginHours\": \"0\",'+
                '            \"EndHours\": \"0\",'+
                '            \"EndDate\": \"09/21/2013\",'+
                '            \"StartDate\": \"09/21/2010\",'+
                '            \"Months\": \"36\",'+
                '            \"CAPCoverageID\": \"APT\"'+
                '         }'+
                '      ]}'+
                '   }}'+
                '}';
            jobref.CoverageResponse__c = json;
            jobRef.Failure_Date__c = System.today();
            insert jobRef;
            PageReference pref;
            pref = new PageReference('/'+jobRef.id);
            pref.getParameters().put('id',jobRef.id);
            Test.setCurrentPage(pref);

            //Creating Fault code
            CSS_Fault_Code__c fauCodRef = new CSS_Fault_Code__c();
            fauCodRef.Job_Order__c =jobRef.Id; 
            fauCodRef.Sequence__c=1;
            fauCodRef.Fault_Code_Type__c='BPD'; 
            fauCodRef.Primary_Fault_Code__c=3539; 
            fauCodRef.Status__c='A';
            insert fauCodRef;
            List<CSS_Fault_Code__c> fauCodRefList = new List<CSS_Fault_Code__c>();
            fauCodRefList.add(fauCodRef);

            //Creating Soltions--3
            CSS_Solutions__c solRef =  CSS_TestData.createSolutions(true,jobRef.Id);
            solRef.FaultCode__c = fauCodRef.id;
            update solRef;

            list<CSS_Solution_Component__c> solcomreflist =new list<CSS_Solution_Component__c>();

            //Creating Solution Component--4
            //for(integer i=0;i<5;i++)
            //{
            CSS_Solution_Component__c solComRef = CSS_TestData.createSRT(false,jobRef.Id,solRef.Id);
            solComRef.System_Code__c = 'Test';
            solComRef.Component_Code__c = 'Test';
            solComRef.Failure_Mode__c = 'Test';
            solComRef.Solutions__c =solRef.id;
            solComRef.AccountCodeType__c = 'Test-Test';
            solComRef.AccountCode_Call_Status__c = 'Failure';
            solComRef.Failure_Point__c=11.0;
            // solComRef.Parts_Warranty__c = 'dfhfdh';
            solComRef.Customer_Take_Possession__c = 'sgdsg';
            solComRef.Failure_Date__c=date.parse('12/27/2014');
            solComRef.AccountCode__c = '';
            solComRef.AccountCodeEdit__c =null;
            System.debug('The Solution Component Object' +solComRef);
            insert solComRef;
            system.debug('CSS ACCOUNT CODE FORMULA: '+solComRef.CSS_Account_Formula__c);
            solcomreflist.add(solComRef);
            upsert solcomreflist;//By Rupesh

            CSS_Parts_Options__c parts = new CSS_Parts_Options__c();
            parts.Option_Number__c = 'O-111';
            parts.Service_Job__c = jobRef.Id;
            parts.selected_part__c = true;
            parts.FailurepartId__c = solComRef.Id;
            parts.Part_Assignment__c = 'Primary';
            insert parts;

            boolean accCodeExist=false;
            //Populating Account codes
            List<SelectOption> accCodes = new List<SelectOption>();
            accCodes.add(new SelectOption('Test1','Test1'));
            accCodes.add(new SelectOption('Test2','Test2'));
            accCodes.add(new SelectOption('Test3','Test3'));
            accCodes.add(new SelectOption('Test4','Test4'));

            CSS_JobPlanOverviewControllerNew obj1=new CSS_JobPlanOverviewControllerNew();
            obj1.accCodeEditable='Test';
            obj1.componentId = String.valueOf(solcomreflist[0].id);
            obj1.failureDate = System.today();
            obj1.failureDate1 = System.today();
            obj1.warrantyDate = System.today();
            obj1.partsWarrDt = system.today();
            obj1.warrStDtHidden = 'Testing';
            obj1.accCodeSelected = 'EMISSION WARRANTY 62';
            obj1.selectedFaultCode = null;
            obj1.selectedFaultCode = '';

            obj1.comm = 'Testing';
            //obj1.compont.Failure_Date__c = null; 


            obj1.Wid = null;
            //obj1.CompareDates();
            obj1.Cancel();

            //select Attribute1__c, Attribute3__c from CSS_JobEventTemporary__c where key__c='FailModes'
            list<CSS_JobEventTemporary__c> jetl =new list<CSS_JobEventTemporary__c>();

            CSS_JobEventTemporary__c jet=new CSS_JobEventTemporary__c();
            jet.key__c='FailModes';
            jet.Name='Test';
            insert jet;
            jetl.add(jet);
            upsert jetl;

            //obj1.loadPopup();

            obj1.jobplan_jpq();
            //     obj1.jobplan_srt();
            obj1.onAddClick();
            // obj1.checkCoverageNew();
            obj1.accCodeSelected = 'EMISSION WARRANTY 62';
            obj1.failureMeasure='Hours';
            obj1.coverageType = 'POL';
            obj1.Validations();
            obj1.coverageType = 'NPW';
            obj1.coverageFound = 'false';
            obj1.accCodeSelected = '52';
            obj1.selectedFailMode = 'THAS';
            obj1.chkClickonPartsCoverage = false;
		    set<string> setBlankFieldset = new set<string>();
            setBlankFieldset.add('false');
		    //obj1.tempblankfieldset = setBlankFieldset;
            obj1.Validations();
            obj1.pgSave();
            obj1.saveCheckBox();
            obj1.getAccountCodes();
            obj1.mainSOQL();
            //obj1.retry();
            obj1.getPayCodesonAccCodeChange();
            //obj1.getPayCodesonAccCodeChangeOnLoad();


            //  }

            Test.setMock(HttpCalloutMock.class, new CSS_SRTCompMockup_Test());
            Test.startTest();
            CSS_JobPlanOverviewControllerNew JobPlanOverCont = new CSS_JobPlanOverviewControllerNew();
            //CSS_Solution_Component__c solComm=[select id from css_solution_component__c limit 1];
            // system.debug('solution Component value'+solComm);
            //JobPlanOverCont.componentId = 'solComRef.Id';
            JobPlanOverCont.failCodeSelected = 'Engine Control Module Calibration-EQPE';
            JobPlanOverCont.accCodeSelected = 'PARTS WARRANTY 35';
            JobPlanOverCont.failCodeEditable='Engine Control Module Calibration-EQPE';
            //JobPlanOverCont.allFaultCodes = fauCodRefList;

            //JobPlanOverCont.mainSOQL();
            JobPlanOverCont.failCodeChangeGO();
            //JobPlanOverCont.retry();
            Test.setMock(HttpCalloutMock.class, new CSS_MockHttpResponseGenerator()); 
            JobPlanOverCont.callCreateWoqtInbound('Test+Rupesh');
            //JobPlanOverCont.onAddClick();//Moved Here and it gives no error
            JobPlanOverCont.partssave();
            JobPlanOverCont.clearPopup();
            JobPlanOverCont.onChangeofAppCode();

            JobPlanOverCont.selectedFName= 'unlisted';

            list<CSS_JobEventTemporary__c> jetlist=new list<CSS_JobEventTemporary__c>();
            //css_testdata.createJobEventTempObj(true);
            CSS_JobEventTemporary__c x=new CSS_JobEventTemporary__c();
            x.key__c='FailCodes';
            x.Attribute3__c='X15 CM2350 X114B;;10';
            insert x;
            jetlist.add(x);
            upsert jetlist;
            system.debug('*************JETLIST*******************: '+jetlist);

            //JobPlanOverCont.SRTFailurenames();

            JobPlanOverCont.invalidAppCode ='true';
            JobPlanOverCont.selectedSysCode ='TH';
            JobPlanOverCont.selectedCompCode = 'AS';
            pref=JobPlanOverCont.updateFailCodeComponents(); 
            JobPlanOverCont.onChangeofAppCode();


            list<CSS_Solution_Component__c> solcomreflist1 =new list<CSS_Solution_Component__c>();

            //Creating Solution Component--4
            //for(integer i=0;i<5;i++)
            //{
            CSS_Solution_Component__c solComRef1 = CSS_TestData.createSRT(false,jobRef.Id,solRef.Id);
            solComRef1.System_Code__c = 'Test';
            solComRef1.Component_Code__c = 'Test';
            solComRef1.Failure_Mode__c = 'Test';
            solComRef1.Solutions__c =solRef.id;
            solComRef1.AccountCodeType__c = 'NEW-New Engine WarrantyNEW-New Engine Warranty';
            solComRef1.AccountCode_Call_Status__c = 'Failure';
            solComRef1.Failure_Point__c=11.0;
            solComRef1.Failure_Date__c=date.parse('12/27/2014');
            solComRef1.AccountCode__c = '67';
            solComRef1.AccountCodeEdit__c ='New Engine Warranty 67';
            solComRef1.Parts_Warranty__c='New Parts Warranty';
            solComRef1.Failure_Measure__c='Kilometers';
            System.debug('The Solution Component Object' +solComRef);
            insert solComRef1;
            system.debug('CSS ACCOUNT CODE FORMULA: 1: '+solComRef.CSS_Account_Formula__c);
            solcomreflist.add(solComRef1);
            upsert solcomreflist1;//By Rupesh
            JobPlanOverCont.onAddClick();

            list<CSS_JobEventTemporary__c> jetlist1=new list<CSS_JobEventTemporary__c>();
            //css_testdata.createJobEventTempObj(true);
            CSS_JobEventTemporary__c x1=new CSS_JobEventTemporary__c();
            x1.key__c='FailModes';
            x1.Attribute3__c='ISX12/ISX11.9 CM2250;;0K';
            insert x1;
            jetlist1.add(x1);
            upsert jetlist1;//By Rupesh

            list<string> fmods=new list<string>();
            if(fmods==null)
                fmods=JobPlanOverCont.getFailModes();

            list<CSS_JobEventTemporary__c> jetlist2=new list<CSS_JobEventTemporary__c>();
            //css_testdata.createJobEventTempObj(true);
            CSS_JobEventTemporary__c x2=new CSS_JobEventTemporary__c();
            x2.key__c='CDSFaultCodes';
            x2.Attribute3__c='ISX12/ISX11.9 CM2250;;0K';
            insert x2;
            jetlist1.add(x2);
            upsert jetlist2;//By Rupesh
            Test.stopTest(); 
        }

    }

    public static testMethod void TestMethod1_1()
    {

        //Creating Service Job--1
        CSS_Job_Order__c jobRef2 = CSS_TestData.createJobOrder(true); 
        //CSS_Job_Order__c jobRef2 = new CSS_Job_Order__c();    
        list<string> falist=new list<string>();
        string st='Test';
        falist.add(st);
        list<string> partfalist=new list<string>();
        string st1='Test';
        partfalist.add(st1);
        //list<string> prtlst=new list<string>();
        //string st2='Test';
        //prtlst.add(st2);
        // Set<string> faultCodeList=new Set<string>();
        //string st2='Test';
        //faultCodeList.add(st2);
        CSS_JobPlanOverviewControllerNew obj=new CSS_JobPlanOverviewControllerNew();
        obj.faultList=falist;
        obj.partlistFAULT=partfalist;
        //obj.partlist=prtlst;
        //obj.faultCodeList=faultCodeList;
        jobRef2.chevron_page__c='jo';
        jobRef2.BMSWSStatus__c = 'UI';
        jobRef2.CSS_Resolution__c = 'Test';
        jobRef2.General_Symptoms__c='';

        jobRef2.CoverageResponse__c = 'xyz';

        upsert jobRef2;

        list<CSS_Solutions__c> sollist=new list<CSS_Solutions__c>();
        //Creating Solutions--2
        CSS_Solutions__c solRef2 =  CSS_TestData.createSolutions(false,jobRef2.Id);
        solRef2.Diagnostic_Response__c  = 'Most Likely the Solution';
        //insert solRef2;
        CSS_Solutions__c solRef3 =  CSS_TestData.createSolutions(false,jobRef2.Id);
        solRef3.Diagnostic_Response__c  = 'Most Likely the Solution';
        //insert solRef3;
        sollist.add(solRef2);
        sollist.add(solRef3);
        upsert sollist;
        set<Id> solutionIds = new set<Id>();
        solutionIds.add(solRef2.id);
        solutionIds.add(solRef3.id);

        List<CSS_Solution_Component__c> solComList = new List<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solComRef = CSS_TestData.createSRT(false,jobRef2.Id,solRef2.Id);
        solComRef.System_Code__c = 'Test';

        solComRef.Component_Code__c = 'Test';
        solComRef.Failure_Mode__c = 'Test';
        solComRef.Solutions__c =solRef2.id;
        solComRef.AccountCodeType__c = 'Test-Test';
        solComRef.AccountCode_Call_Status__c = 'Failure';
        solComRef.Failure_Point__c=11.0;
        solComRef.Failure_Measure__c = 'null';
        //       solComRef.Failure_Date__c=date.parse('12-27-2014');
        solComRef.Failure_Date__c=date.today();
        solComRef.AccountCode__c = '';
        solComRef.AccountCodeEdit__c='';
        solComRef.Failure_Point__c=2323;
        System.debug('The Solution Component Object');
        solComList.add(solComRef);


        CSS_Solution_Component__c solComRef1 = CSS_TestData.createSRT(false,jobRef2.Id,solRef2.Id);
        solComRef.System_Code__c = 'Test';

        solComRef1.Component_Code__c = 'Test';
        solComRef1.Failure_Mode__c = 'Test';
        solComRef1.Solutions__c =solRef2.id;

        solComRef1.AccountCode_Call_Status__c = 'Failure';
        solComRef1.Failure_Point__c=11.0;
        solComRef1.Failure_Measure__c = null;
        //       solComRef.Failure_Date__c=date.parse('12-27-2014');
        solComRef1.Failure_Date__c=date.today();

        solComList.add(solComRef1);
        insert solComList;
        CSS_Fault_Code__c fc3 = new CSS_Fault_Code__c(FaultCodeR2__c = '441',Related_Fault_Code__c = '234,546');
        fc3.Name = '441';
        fc3.Job_Order__c = jobRef2.Id;
        fc3.Sequence__c = 1; 
        fc3.Fault_Code_Type__c = 'APD-P';
        fc3.Mod__c = '0';
        fc3.isPole__c = false;
        fc3.Number_of_Solutions__c = '1';
        insert fc3;

        CSS_JobEventTemporary__c JETsys = new CSS_JobEventTemporary__c();
        JETsys.Attribute1__c = 'TH';
        JETsys.Attribute4__c ='TS';
        JETsys.key__c = 'FailCodes';
        JETsys.Attribute3__c = 'TURBO';
        JETsys.Attribute5__c = 'ASSEMBLY';
        JETsys.Reason__c = '{\r\n\t\"Header\": {\r\n\t\t\"ReturnCodeDescription\": \"Normal, Successful completion.\",\r\n\t\t\"ReturnCode\": \"ORA-00000\",\r\n\t\t\"MessageIdentifier\": \"S\"\r\n\t},\r\n\t\"DataArea\": [{\r\n\t\t\"SystemCode\": \"WF\",\r\n\t\t\"FailureName\": \"ATC 1795\",\r\n\t\t\"FailureMode\": \"SP\",\r\n\t\t\"FailureID\": \"F30003750\",\r\n\t\t\"ComponentCode\": \"HA\"\r\n\t}]\r\n}';
        insert JETsys;

        CSS_JobEventTemporary__c JETsys1 = new CSS_JobEventTemporary__c();
        JETsys1.Attribute1__c = 'ISX12 CM2350 X102';
        JETsys1.Attribute2__c ='OK';
        JETsys1.key__c = 'GetFailureCodesSRT';
        JETsys1.Attribute3__c = 'ISX12 CM2350 X102;;0K';
        JETsys1.Attribute5__c = 'ASSEMBLY';
        JETsys1.Reason__c = '{\r\n\t\"Header\": {\r\n\t\t\"ReturnCodeDescription\": \"Normal, Successful completion.\",\r\n\t\t\"ReturnCode\": \"ORA-00000\",\r\n\t\t\"MessageIdentifier\": \"S\"\r\n\t},\r\n\t\"DataArea\": [{\r\n\t\t\"SystemCode\": \"WF\",\r\n\t\t\"FailureName\": \"ATC 1795\",\r\n\t\t\"FailureMode\": \"SP\",\r\n\t\t\"FailureID\": \"F30003750\",\r\n\t\t\"ComponentCode\": \"HA\"\r\n\t}]\r\n}';
        insert JETsys1;
        List<CSS_Fault_Code__c> lstFC1 = new List<CSS_Fault_Code__c>();
        lstFC1.add(fc3);
        PageReference pref;
        pref = new PageReference('/'+jobRef2.id);
        pref.getParameters().put('id',jobRef2.id);
        Test.setCurrentPage(pref);
        CSS_JobPlanOverviewControllerNew JobPlanOverCont1 = new CSS_JobPlanOverviewControllerNew();
        CSS_Integration_Details__c cid = CSS_TestData.createIntegrationDetails(false);
        cid.name = 'CSS_SBL_WarrantyDetailCoverage';
        cid.ApplicationName__c = 'CSS_SBL_WarrantyDetailCoverage';
        cid.End_Point__c = 'https://services-stg.cummins.com/csswarranty/accodecoverage';
        insert cid;
        test.startTest();

        JobPlanOverCont1.mainSOQL();
        JobPlanOverCont1.jobClosePopup();
        JobPlanOverCont1.workjob.DSID__c = '12345';
        JobPlanOverCont1.workjob.ApplicationCode__c = '130';

        JobPlanOverCont1.NotesBody = 'false';
        JobPlanOverCont1.accQuoteFlag=false;
        JobPlanOverCont1.showRepairs = true;
        JobPlanOverCont1.showResolution = true;
        JobPlanOverCont1.showResolutionWithRepair=false;
        JobPlanOverCont1.onAddClick();
        JobPlanOverCont1.retry();
        JobPlanOverCont1.closeSession();
        JobPlanOverCont1.showRepairs=true;
        JobPlanOverCont1.showResolutionWithRepair=false;

        //JobPlanOverCont1.saveAndCloseJob();
        JobPlanOverCont1.componentId = '12345';
        JobPlanOverCont1.AuthNumber = '12345';
        JobPlanOverCont1.PayCode = '23345';
        JobPlanOverCont1.complaintcounter = 12234;
        JobPlanOverCont1.coveragecounter = 12245;
        JobPlanOverCont1.causecounter = 35456;
        JobPlanOverCont1.compName = 'test12';
        JobPlanOverCont1.compID1 = '23454';
        JobPlanOverCont1.fcWS = 'test12';
        JobPlanOverCont1.acWS = 'test76';
        JobPlanOverCont1.fcPopup = 'test54';
        JobPlanOverCont1.acPopup = 'test34';
        JobPlanOverCont1.recordId = '12432544223';
        JobPlanOverCont1.displayMPopUp = true;
        JobPlanOverCont1.selAccCode = 'test12';
        JobPlanOverCont1.warrantyCompFailure = true;
        JobPlanOverCont1.failmode = 'test2';
        JobPlanOverCont1.claimtype = 'test23';
        JobPlanOverCont1.accountCodeType = 'test5';
        JobPlanOverCont1.selectedAccFormula = true;
        JobPlanOverCont1.FailureDtHidden = 'test24';
        JobPlanOverCont1.displayERPButtonDlr = true;
        JobPlanOverCont1.workjobStatus = 'open';
        JobPlanOverCont1.failCodeChange = true;
        JobPlanOverCont1.faultCode = 'tsestwf';
        JobPlanOverCont1.payCodeSelected = 'Select One';
        JobPlanOverCont1.selectedFName =  'siva';
        JobPlanOverCont1.selectedSysCode ='TH';
        JobPlanOverCont1.selectedCompCode='TS';
        JobPlanOverCont1.selectedFailMode = 'test1';
        JobPlanOverCont1.errormsgfailpoint = false;
        JobPlanOverCont1.selectedFaultCode = '467432356';
        JobPlanOverCont1.appCodeSelected = 'test12';
        JobPlanOverCont1.claimTypeSelected = 'open';
        JobPlanOverCont1.accCodeReturned = 'testing';
        JobPlanOverCont1.selectedCompId = '12345567';
        JobPlanOverCont1.sendfailtoERP = false;
        JobPlanOverCont1.authNumbers = '34567';
        JobPlanOverCont1.checkPartsWarrStartDt = true;

        // JobPlanOverCont1.callUnitInboundGeneric();
        JobPlanOverCont1.callUpdateUnitandWo();
        Map<String,String> tempMap  = new map<String,String>();
        tempMap.put('siva','TH');
        JobPlanOverCont1.failureNameWithSystemCodeMap  = tempMap;
        JobPlanOverCont1.failureNameWithCompCodeMap  = tempMap;
        JobPlanOverCont1.changeFailures_New();
        JobPlanOverCont1.selectedFName =  'unlisted';
        JobPlanOverCont1.changeFailures_New();
        JobPlanOverCont1.jobplan_jo();
        //JobPlanOverCont1.getListWrap();
        JobPlanOverCont1.saveRootCause();
        JobPlanOverCont1.jobplan_war();
        JobPlanOverCont1.jobplan_narr();
        JobPlanOverCont1.pgSave();
        JobPlanOverCont1.showPopup();
        JobPlanOverCont1.closePopup();
        JobPlanOverCont1.redirectPopup();
        JobPlanOverCont1.getAccountCodes1();
        JobPlanOverCont1.closeSession_close();
        JobPlanOverCont1.jobPlanAction();
        //JobPlanOverCont1.pgSaveFinish();
        //JobPlanOverCont1.clearpopup();

        //  Test.setMock(HttpCalloutMock.class , new CSS_WS_SBL_GetWarrantyDetailCovrg_Test());
        //   Test.setMock(HttpCalloutMock.class, new CSS_WS_SBL_GetWarrantyDetailCovrg_Test());
        Test.setMock(HttpCalloutMock.class, new CSS_WS_SBL_GetWarrantyDetailCovrg_Test());
        JobPlanOverCont1.checkCoverageNew();
        JobPlanOverCont1.onChangeofAppCode();
        //JobPlanOverCont1.SRTFailurenames();
        JobPlanOverCont1.getfailurenames();
        Test.setMock(HttpCalloutMock.class , new CSS_WS_SBL_GetWarrantyDetailCovrg_Test());
        JobPlanOverCont1.checkcoverage();

        Test.stopTest();        
    }

    public static testMethod void TestMethod7_7()
    {

        UserRole empRole = [Select Id From UserRole Where Name = 'Factory' Limit 1];
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'kal1', Email='standarduser11@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='kal12', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='kal11111@testorg.com', user_Location__c = '562701-562551',UserRoleId = empRole.id);
        insert(u);
        System.runAs(u) 
        {  

            CSS_JobEventTemporary__c JETsys = new CSS_JobEventTemporary__c();
            JETsys.Attribute1__c = 'TH';
            JETsys.Attribute4__c ='TS';
            JETsys.key__c = 'FailCodes';
            JETsys.Attribute3__c = 'TURBO';
            JETsys.Attribute5__c = 'ASSEMBLY';
            insert JETsys;
            CSS_JobEventTemporary__c JETsys1 = new CSS_JobEventTemporary__c();
            JETsys1.Attribute1__c = 'ISX12 CM2350 X102';
            JETsys1.Attribute2__c ='OK';
            JETsys1.key__c = 'GetFailureCodesSRT';
            JETsys1.Attribute3__c = 'ISX12 CM2350 X102;;0K';
            JETsys1.Attribute5__c = 'ASSEMBLY';
            JETsys1.Reason__c = '{\r\n\t\"Header\": {\r\n\t\t\"ReturnCodeDescription\": \"Normal, Successful completion.\",\r\n\t\t\"ReturnCode\": \"ORA-00000\",\r\n\t\t\"MessageIdentifier\": \"S\"\r\n\t},\r\n\t\"DataArea\": [{\r\n\t\t\"SystemCode\": \"WF\",\r\n\t\t\"FailureName\": \"ATC 1795\",\r\n\t\t\"FailureMode\": \"SP\",\r\n\t\t\"FailureID\": \"F30003750\",\r\n\t\t\"ComponentCode\": \"HA\"\r\n\t}]\r\n}';
            insert JETsys1;
            CSS_Job_Order__c jobRef = CSS_TestData.createJobOrder(false);
            jobRef.chevron_page__c='jo';
            jobRef.BMSWSStatus__c = 'UI';
            jobRef.ESN__c ='Testing';
            jobRef.Service_Model__c ='ISB6.7 CM2350 B101';
            jobRef.Qsol_Engine_Family_Code__c ='10';
            jobRef.Repair_Location__c='Mobile';
            insert jobRef;
            PageReference pref;
            pref = new PageReference('/'+jobRef.id);
            pref.getParameters().put('id',jobRef.id);
            Test.setCurrentPage(pref);
            CSS_Fault_Code__c fauCodRef = new CSS_Fault_Code__c();
            fauCodRef.Job_Order__c =jobRef.Id; 
            fauCodRef.Sequence__c=1;
            fauCodRef.Fault_Code_Type__c='BPD'; 
            fauCodRef.Primary_Fault_Code__c=3539; 
            fauCodRef.Status__c='A';
            insert fauCodRef;
            List<CSS_Fault_Code__c> fauCodRefList = new List<CSS_Fault_Code__c>();
            fauCodRefList.add(fauCodRef);

            list<CSS_Solutions__c > solReflist=new list<CSS_Solutions__c>();

            CSS_Solutions__c solRef =  CSS_TestData.createSolutions(false,jobRef.Id);
            solRef.FaultCode__c = fauCodRef.id;
            solRef.Repair_Response__c='NO';
            upsert solRef;

            solReflist.add(solRef);
            upsert solReflist;

            list<CSS_Solution_Component__c> solComReflist=new list<CSS_Solution_Component__c>();
            CSS_Solution_Component__c solComRef = CSS_TestData.createSRT(false,jobRef.Id,solRef.Id);
            solComRef.System_Code__c = 'Test';
            solComRef.Component_Code__c = 'Test';
            solComRef.Failure_Mode__c = 'Test';
            solComRef.Solutions__c =solRef.id;
            solComRef.AccountCodeType__c = 'Test-Test';
            solComRef.AccountCode_Call_Status__c = 'Failure';
            solComRef.AccountCode__c = 'ACCODE';
            solComRef.AccountCodeEdit__c='ADEDIT';
            solComRef.Failure_Measure__c='ADEDIT';
            insert solComRef;
            solComReflist.add(solComRef);

            Set<String> failureNameList = new Set<String>();
            String grpName = 'CQ'+'-'+'56270-56255';
            Group testQue = new Group(Name=grpName, type='Queue');
            insert testQue;
            CSS_Integration_Details__c csInt = new CSS_Integration_Details__c();
            csInt.name = 'SRT';
            csInt.ApplicationName__c='SRT';
            csInt.End_Point__c='https://Test-services-dev.cummins.com/css/';
            csInt.IsActive__c=true;
            csInt.Key__c='/Q0w11SmTDJ11dPRgzYfGjycs+HZbtT8sezi/jkT7Ag=';
            csInt.Passcode__c='u9pf3rdOE0SCjXDCgmzRbUlwWQWen7B9993Eh61KI1E=';
            csInt.Username__c='6dpW6v5ekUR2HzkTePJXwgNaMDgo0t53tZgmixV4rfU=';
            insert csint;
            system.runas(new User(Id=UserInfo.getUserId()))
            { 

                QueueSObject tq = new QueueSObject(SobjectType='CSS_Claims__c', QueueId=testQue.Id);
                insert tq;


                CSS_Claims__c claims = new CSS_Claims__c();
                claims.Status__c='Submitted';
                claims.ESN__c='79462880';
                claims.Customer_Name__c='BRITESTONE COLONY';
                claims.Customer_Code__c='123';
                claims.Location_Code__c='56270-56255';
                claims.ownerId = UserInfo.getUserId();
                insert claims;
                Test.startTest();

                CSS_JobPlanOverviewControllerNew JobPlanOverCont = new CSS_JobPlanOverviewControllerNew();
                JobPlanOverCont.componentId = solComRef.Id;
                JobPlanOverCont.failCodeSelected = 'Select One';
                JobPlanOverCont.accCodeSelected = 'PARTS WARRANTY 35';
                JobPlanOverCont.failCodeEditable='Select One';
                JobPlanOverCont.allFaultCodes = fauCodRefList;
                Test.setMock(HttpCalloutMock.class, new SRTMockHttpResponseGenerator());
                Test.setMock(HttpCalloutMock.class, new CSS_SRTCompMockup_Test());
                Test.setMock(HttpCalloutMock.class, new CSS_MockHttpResponseGenerator()); 
                JobPlanOverCont.callCreateWoqtInbound('Testing Class');
                JobPlanOverCont.partsWarranty=null;
                JobPlanOverCont.accCodeSelected='62359741Z';
                JobPlanOverCont.showResolutionWithRepair=true;
                JobPlanOverCont.onChangeofAppCode();
                JobPlanOverCont.SelectedFname = null; 
                JobPlanOverCont.Wid = apexpages.currentPage().getparameters().put('id',claims.Id); 





                CSS_JobEventTemporary__c jer =new CSS_JobEventTemporary__c();
                jer.key__c='getFailureCodesSRT';
                jer.Attribute3__c='ISB6.7 CM2350 B101;;10';
                jer.Reason__c = '{"Header":{"ReturnCodeDescription":"Normal, Successful completion.","ReturnCode":"ORA-00000","MessageIdentifier":"S"},"DataArea":[{"SystemCode":"EY","FailureName":"Accelerator Pedal or Lever Position Sensor","FailureMode":"","FailureID":"F19000010","ComponentCode":"PB"},{"SystemCode":"US","FailureName":"Aftertreatment DEF Controller Calibration","FailureMode":"","FailureID":"F19000030","ComponentCode":"EQ"},{"SystemCode":"US","FailureName":"Aftertreatment DEF Dosing Unit","FailureMode":"","FailureID":"F11000030","ComponentCode":"DU"},{"SystemCode":"US","FailureName":"Aftertreatment DEF Dosing Unit Filter","FailureMode":"","FailureID":"F11000060","ComponentCode":"UF"},{"SystemCode":"US","FailureName":"Aftertreatment DEF Dosing Valve","FailureMode":"","FailureID":"F11000020","ComponentCode":"DV"},{"SystemCode":"US","FailureName":"Aftertreatment DEF Dosing Valve Mounting Gasket","FailureMode":"","FailureID":"F30001100","ComponentCode":"GK"},{"SystemCode":"XX","FailureName":"Aftertreatment DEF Line","FailureMode":"","FailureID":"F11000040","ComponentCode":"OE"},{"SystemCode":"XX","FailureName":"Aftertreatment DEF Line Heater","FailureMode":"","FailureID":"F11000100","ComponentCode":"OE"},{"SystemCode":"UD","FailureName":"Aftertreatment DEF Nozzle","FailureMode":"","FailureID":"F30000480","ComponentCode":"NZ"},{"SystemCode":"US","FailureName":"Aftertreatment DEF Tank Filter","FailureMode":"","FailureID":"F11000050","ComponentCode":"FF"},{"SystemCode":"XX","FailureName":"Aftertreatment DEF Tank Heater Control Valve","FailureMode":"","FailureID":"F11000065","ComponentCode":"OE"},{"SystemCode":"XX","FailureName":"Aftertreatment DEF Tank Level Sensor","FailureMode":"","FailureID":"F19000070","ComponentCode":"OE"},{"SystemCode":"XX","FailureName":"Aftertreatment DEF Tank Temperature Sensor","FailureMode":"","FailureID":"F19000080","ComponentCode":"OE"},{"SystemCode":"NY","FailureName":"Aftertreatment DOC","FailureMode":"","FailureID":"F11000080","ComponentCode":"CY"},{"SystemCode":"ET","FailureName":"Aftertreatment DOC Intake Temperature Sensor","FailureMode":"IN","FailureID":"F19000090","ComponentCode":"CT"},{"SystemCode":"EU","FailureName":"Aftertreatment DOC Intake Temperature Sensor Module","FailureMode":"","FailureID":"F19000130","ComponentCode":"PF"},{"SystemCode":"NY","FailureName":"Aftertreatment DPF","FailureMode":"","FailureID":"F11000090","ComponentCode":"PF"},{"SystemCode":"EA","FailureName":"Aftertreatment DPF Differential Pressure Sensor","FailureMode":"","FailureID":"F19000140","ComponentCode":"DF"},{"SystemCode":"NY","FailureName":"Aftertreatment DPF Differential Pressure Sensor Tubes","FailureMode":"","FailureID":"F11000110","ComponentCode":"PN"},{"SystemCode":"ET","FailureName":"Aftertreatment DPF Intake Temperature Sensor","FailureMode":"MI","FailureID":"F19000100","ComponentCode":"CT"},{"SystemCode":"ET","FailureName":"Aftertreatment DPF Outlet Temperature Sensor","FailureMode":"OT","FailureID":"F19000110","ComponentCode":"CT"},{"SystemCode":"HY","FailureName":"Aftertreatment DPF Temperature Sensor Module","FailureMode":"","FailureID":"F11000120","ComponentCode":"DV"},{"SystemCode":"US","FailureName":"Aftertreatment Decomposition Tube","FailureMode":"","FailureID":"F11000000","ComponentCode":"DT"},{"SystemCode":"NY","FailureName":"Aftertreatment Device Gasket","FailureMode":"","FailureID":"F30002610","ComponentCode":"GK"},{"SystemCode":"XX","FailureName":"Aftertreatment Diesel Exhaust Fluid  Line Heater","FailureMode":"","FailureID":"F19000050","ComponentCode":"OE"},{"SystemCode":"ET","FailureName":"Aftertreatment Exhaust Gas Temperature Sensor","FailureMode":"","FailureID":"F19000150","ComponentCode":"CT"},{"SystemCode":"YN","FailureName":"Aftertreatment Intake NOx Sensor","FailureMode":"IN","FailureID":"F19000170","ComponentCode":"EB"},{"SystemCode":"EU","FailureName":"Aftertreatment Interface Harness","FailureMode":"","FailureID":"F11000170","ComponentCode":"WX"},{"SystemCode":"EU","FailureName":"Aftertreatment OEM Wiring Harness","FailureMode":"X1","FailureID":"F19000190","ComponentCode":"WH"},{"SystemCode":"YN","FailureName":"Aftertreatment Outlet NOx Sensor","FailureMode":"OT","FailureID":"F19000200","ComponentCode":"EB"},{"SystemCode":"EA","FailureName":"Aftertreatment Outlet Pressure Sensor","FailureMode":"","FailureID":"F19000210","ComponentCode":"DF"},{"SystemCode":"YN","FailureName":"Aftertreatment Particulate Sensor","FailureMode":"","FailureID":"F19000215","ComponentCode":"SM"},{"SystemCode":"US","FailureName":"Aftertreatment SCR Catalyst","FailureMode":"","FailureID":"F11000200","ComponentCode":"SC"},{"SystemCode":"EU","FailureName":"Aftertreatment SCR Catalyst Temperature Sensor Module","FailureMode":"","FailureID":"F19000220","ComponentCode":"SC"},{"SystemCode":"YN","FailureName":"Aftertreatment SCR Intermediate NH3 Sensor Module","FailureMode":"","FailureID":"F19000250","ComponentCode":"AM"},{"SystemCode":"YN","FailureName":"Aftertreatment SCR Intermediate NH3 Sensor Probe","FailureMode":"","FailureID":"F19000260","ComponentCode":"AP"},{"SystemCode":"NY","FailureName":"Aftertreatment System Clamp","FailureMode":"","FailureID":"F30003590","ComponentCode":"CP"},{"SystemCode":"QC","FailureName":"Air Compressor","FailureMode":"","FailureID":"F12000000","ComponentCode":"AS"},{"SystemCode":"QI","FailureName":"Air Compressor Air Line O-Ring Seal","FailureMode":"","FailureID":"F30002840","ComponentCode":"OR"},{"SystemCode":"KC","FailureName":"Air Compressor Coolant Return Line","FailureMode":"","FailureID":"F30000220","ComponentCode":"CT"},{"SystemCode":"QC","FailureName":"Air Compressor Cylinder Head","FailureMode":"","FailureID":"F12000010","ComponentCode":"CH"},{"SystemCode":"QC","FailureName":"Air Compressor Cylinder Head Gasket","FailureMode":"","FailureID":"F12000020","ComponentCode":"GK"},{"SystemCode":"QI","FailureName":"Air Compressor Inlet Hose","FailureMode":"","FailureID":"F12000030","ComponentCode":"TH"},{"SystemCode":"QC","FailureName":"Air Compressor Mounting Hardware","FailureMode":"","FailureID":"F30002860","ComponentCode":"MH"},{"SystemCode":"SD","FailureName":"Air Filter","FailureMode":"","FailureID":"F10000010","ComponentCode":"EL"},{"SystemCode":"IN","FailureName":"Air Intake Connection","FailureMode":"","FailureID":"F10000015","ComponentCode":"CO"},{"SystemCode":"IN","FailureName":"Air Intake Pipe O-Ring Seal","FailureMode":"","FailureID":"F30000890","ComponentCode":"OR"},{"SystemCode":"EA","FailureName":"Ambient Air Temperature Sensor","FailureMode":"","FailureID":"F19000300","ComponentCode":"CD"},{"SystemCode":"NW","FailureName":"Auxiliary Water Pump","FailureMode":"","FailureID":"F30000510","ComponentCode":"WP"},{"SystemCode":"EA","FailureName":"Barometric Pressure Sensor","FailureMode":"","FailureID":"F19000310","ComponentCode":"CB"},{"SystemCode":"BC","FailureName":"Camshaft","FailureMode":"","FailureID":"F01000000","ComponentCode":"CM"},{"SystemCode":"BC","FailureName":"Camshaft Gear","FailureMode":"","FailureID":"F01000010","ComponentCode":"GR"},{"SystemCode":"BC","FailureName":"Camshaft Indicator Ring","FailureMode":"","FailureID":"F01000020","ComponentCode":"TW"},{"SystemCode":"EL","FailureName":"Camshaft Position Sensor","FailureMode":"","FailureID":"F19000330","ComponentCode":"CB"},{"SystemCode":"XX","FailureName":"Charge Air Cooler","FailureMode":"","FailureID":"F10000020","ComponentCode":"OE"},{"SystemCode":"XX","FailureName":"Charge Air Cooler Plumbing","FailureMode":"","FailureID":"F10000030","ComponentCode":"OE"},{"SystemCode":"SB","FailureName":"Charging System Alternator","FailureMode":"","FailureID":"F13000000","ComponentCode":"AA"},{"SystemCode":"SB","FailureName":"Charging System Alternator Pulley","FailureMode":"","FailureID":"F13000010","ComponentCode":"DN"},{"SystemCode":"BN","FailureName":"Connecting Rod","FailureMode":"","FailureID":"F01000040","ComponentCode":"RF"},{"SystemCode":"BN","FailureName":"Connecting Rod Bearings","FailureMode":"","FailureID":"F01000030","ComponentCode":"RB"},{"SystemCode":"BN","FailureName":"Connecting Rod Capscrews","FailureMode":"","FailureID":"F30001090","ComponentCode":"BO"},{"SystemCode":"EU","FailureName":"Connector Pins","FailureMode":"","FailureID":"F30001070","ComponentCode":"PN"},{"SystemCode":"ED","FailureName":"Coolant Level Sensor","FailureMode":"","FailureID":"F19000380","ComponentCode":"CB"},{"SystemCode":"KC","FailureName":"Coolant Line Fitting","FailureMode":"","FailureID":"F30003580","ComponentCode":"FT"},{"SystemCode":"ET","FailureName":"Coolant Temperature Sensor","FailureMode":"","FailureID":"F19000590","ComponentCode":"CB"},{"SystemCode":"KT","FailureName":"Coolant Thermostat","FailureMode":"","FailureID":"F08000020","ComponentCode":"TS"},{"SystemCode":"KT","FailureName":"Coolant Thermostat Seal","FailureMode":"","FailureID":"F30001250","ComponentCode":"SE"},{"SystemCode":"XX","FailureName":"Cooling Fan","FailureMode":"","FailureID":"F08000040","ComponentCode":"OE"},{"SystemCode":"KH","FailureName":"Cooling Fan Belt","FailureMode":"","FailureID":"F08000050","ComponentCode":"BL"},{"SystemCode":"BB","FailureName":"Crankcase Breather Element","FailureMode":"","FailureID":"F03000010","ComponentCode":"EL"},{"SystemCode":"BB","FailureName":"Crankcase Breather Gasket","FailureMode":"","FailureID":"F30003010","ComponentCode":"GK"},{"SystemCode":"BB","FailureName":"Crankcase Breather Tube","FailureMode":"","FailureID":"F01000060","ComponentCode":"BT"},{"SystemCode":"EA","FailureName":"Crankcase Pressure Sensor","FailureMode":"","FailureID":"F19000410","ComponentCode":"CC"},{"SystemCode":"EA","FailureName":"Crankcase Pressure Sensor O-Ring Seal","FailureMode":"","FailureID":"F30003030","ComponentCode":"CO"},{"SystemCode":"BS","FailureName":"Crankshaft Speed Indicator Ring","FailureMode":"","FailureID":"F01000080","ComponentCode":"TW"},{"SystemCode":"EL","FailureName":"Crankshaft Speed/Position Sensor","FailureMode":"","FailureID":"F19000420","ComponentCode":"EB"},{"SystemCode":"BK","FailureName":"Cylinder Block","FailureMode":"","FailureID":"F01000090","ComponentCode":"CA"},{"SystemCode":"BK","FailureName":"Cylinder Block Cup Plug","FailureMode":"","FailureID":"F30000810","ComponentCode":"PL"},{"SystemCode":"CH","FailureName":"Cylinder Head","FailureMode":"","FailureID":"F02000010","ComponentCode":"CA"},{"SystemCode":"CH","FailureName":"Cylinder Head Cup Plug","FailureMode":"","FailureID":"F30000350","ComponentCode":"PL"},{"SystemCode":"CH","FailureName":"Cylinder Head Exhaust Valve","FailureMode":"","FailureID":"F02000040","ComponentCode":"EV"},{"SystemCode":"CH","FailureName":"Cylinder Head Gasket","FailureMode":"","FailureID":"F02000020","ComponentCode":"GK"},{"SystemCode":"CH","FailureName":"Cylinder Head Intake Valve","FailureMode":"","FailureID":"F02000070","ComponentCode":"IV"},{"SystemCode":"CH","FailureName":"Cylinder Head Valve Guide","FailureMode":"","FailureID":"F02000100","ComponentCode":"GV"},{"SystemCode":"CH","FailureName":"Cylinder Head Valve Spring","FailureMode":"","FailureID":"F02000110","ComponentCode":"VS"},{"SystemCode":"CH","FailureName":"Cylinder Head Valve Stem Seal","FailureMode":"","FailureID":"F02000120","ComponentCode":"SE"},{"SystemCode":"IR","FailureName":"EGR Cooler","FailureMode":"","FailureID":"F11000510","ComponentCode":"CL"},{"SystemCode":"IR","FailureName":"EGR Cooler Connection","FailureMode":"","FailureID":"F30002030","ComponentCode":"BL"},{"SystemCode":"KV","FailureName":"EGR Cooler Coolant Return Tube","FailureMode":"","FailureID":"F30000170","ComponentCode":"RT"},{"SystemCode":"KV","FailureName":"EGR Cooler Coolant Supply Tube","FailureMode":"","FailureID":"F30000180","ComponentCode":"ST"},{"SystemCode":"KV","FailureName":"EGR Cooler Coolant Vent Tube","FailureMode":"","FailureID":"F30002520","ComponentCode":"VL"},{"SystemCode":"KV","FailureName":"EGR Cooler Vent Adapter","FailureMode":"","FailureID":"F30003070","ComponentCode":"VA"},{"SystemCode":"IR","FailureName":"EGR Crossover Tube","FailureMode":"","FailureID":"F11000520","ComponentCode":"TC"},{"SystemCode":"EA","FailureName":"EGR Differential Pressure Sensor","FailureMode":"","FailureID":"F19000490","ComponentCode":"DB"},{"SystemCode":"IR","FailureName":"EGR Differential Pressure Sensor Tubes","FailureMode":"","FailureID":"F11000530","ComponentCode":"PN"},{"SystemCode":"ET","FailureName":"EGR Temperature Sensor","FailureMode":"","FailureID":"F19000510","ComponentCode":"EB"},{"SystemCode":"IR","FailureName":"EGR Valve","FailureMode":"","FailureID":"F11000560","ComponentCode":"VB"},{"SystemCode":"KV","FailureName":"EGR/VGT Coolant Line Sealing Washer","FailureMode":"","FailureID":"F30003080","ComponentCode":"SW"},{"SystemCode":"EU","FailureName":"Electrical Connector","FailureMode":"","FailureID":"F30001060","ComponentCode":"CN"},{"SystemCode":"EI","FailureName":"Engine Control Module","FailureMode":"","FailureID":"F19000530","ComponentCode":"CM"},{"SystemCode":"EQ","FailureName":"Engine Control Module Calibration","FailureMode":"","FailureID":"F19000540","ComponentCode":"PE"},{"SystemCode":"EQ","FailureName":"Engine Control Module Parameters","FailureMode":"","FailureID":"F19000550","ComponentCode":"PC"},{"SystemCode":"IN","FailureName":"Engine Intake Throttle Actuator","FailureMode":"","FailureID":"F10000100","ComponentCode":"TD"},{"SystemCode":"SM","FailureName":"Engine Mount","FailureMode":"","FailureID":"F17000030","ComponentCode":"RS"},{"SystemCode":"EL","FailureName":"Engine Speed Sensor","FailureMode":"","FailureID":"F19000640","ComponentCode":"EB"},{"SystemCode":"IN","FailureName":"Engine Throttle Plate Actuator","FailureMode":"","FailureID":"F19000650","ComponentCode":"TD"},{"SystemCode":"EU","FailureName":"Engine Wiring Harness","FailureMode":"","FailureID":"F19000660","ComponentCode":"WH"},{"SystemCode":"EA","FailureName":"Exhaust Gas Pressure Sensor","FailureMode":"","FailureID":"F19000670","ComponentCode":"EB"},{"SystemCode":"IR","FailureName":"Exhaust Gas Pressure Sensor Tube","FailureMode":"","FailureID":"F11000570","ComponentCode":"TB"},{"SystemCode":"IE","FailureName":"Exhaust Manifold","FailureMode":"","FailureID":"F11000580","ComponentCode":"EM"},{"SystemCode":"IE","FailureName":"Exhaust Manifold Gasket","FailureMode":"","FailureID":"F11000590","ComponentCode":"GK"},{"SystemCode":"IE","FailureName":"Exhaust Manifold Mounting Capscrews","FailureMode":"","FailureID":"F11000600","ComponentCode":"CS"},{"SystemCode":"IE","FailureName":"Exhaust Manifold Slip Joint Seal","FailureMode":"","FailureID":"F30001190","ComponentCode":"SJ"},{"SystemCode":"IE","FailureName":"Exhaust Outlet Connection","FailureMode":"","FailureID":"F30001310","ComponentCode":"EP"},{"SystemCode":"XX","FailureName":"Exhaust Plumbing","FailureMode":"","FailureID":"F11000605","ComponentCode":"OE"},{"SystemCode":"RA","FailureName":"Exhaust Rocker Lever","FailureMode":"","FailureID":"F03000040","ComponentCode":"LV"},{"SystemCode":"SG","FailureName":"Fan Clutch","FailureMode":"","FailureID":"F08000060","ComponentCode":"EM"},{"SystemCode":"XX","FailureName":"Fan Control Switch","FailureMode":"","FailureID":"F19000740","ComponentCode":"OE"},{"SystemCode":"KF","FailureName":"Fan Hub","FailureMode":"","FailureID":"F08000065","ComponentCode":"HU"},{"SystemCode":"KH","FailureName":"Fan Pulley","FailureMode":"","FailureID":"F30000950","ComponentCode":"PU"},{"SystemCode":"SN","FailureName":"Flexplate","FailureMode":"","FailureID":"F16000000","ComponentCode":"FB"},{"SystemCode":"SN","FailureName":"Flywheel","FailureMode":"","FailureID":"F16000010","ComponentCode":"FW"},{"SystemCode":"SN","FailureName":"Flywheel Housing","FailureMode":"","FailureID":"F16000020","ComponentCode":"HS"},{"SystemCode":"SN","FailureName":"Flywheel Housing Gasket","FailureMode":"","FailureID":"F30002130","ComponentCode":"GK"},{"SystemCode":"SN","FailureName":"Flywheel Ring Gear","FailureMode":"","FailureID":"F30000960","ComponentCode":"RG"},{"SystemCode":"BM","FailureName":"Front Crankshaft Seal","FailureMode":"","FailureID":"F01000120","ComponentCode":"SF"},{"SystemCode":"BG","FailureName":"Front Gear Cover","FailureMode":"","FailureID":"F01000140","ComponentCode":"GC"},{"SystemCode":"BG","FailureName":"Front Gear Cover Gasket","FailureMode":"","FailureID":"F01000150","ComponentCode":"GM"},{"SystemCode":"FL","FailureName":"Fuel Connector","FailureMode":"","FailureID":"F05000260","ComponentCode":"FC"},{"SystemCode":"FL","FailureName":"Fuel Drain Line","FailureMode":"","FailureID":"F05000030","ComponentCode":"DL"},{"SystemCode":"FL","FailureName":"Fuel Drain Line Check Valve","FailureMode":"","FailureID":"F05000040","ComponentCode":"DB"},{"SystemCode":"FI","FailureName":"Fuel Injector","FailureMode":"","FailureID":"F05000100","ComponentCode":"AS"},{"SystemCode":"FI","FailureName":"Fuel Injector O-Ring Seal","FailureMode":"","FailureID":"F05000110","ComponentCode":"RO"},{"SystemCode":"FL","FailureName":"Fuel Injector Supply Lines","FailureMode":"","FailureID":"F06000020","ComponentCode":"IS"},{"SystemCode":"PL","FailureName":"Fuel Lift Pump","FailureMode":"","FailureID":"F05000320","ComponentCode":"HN"},{"SystemCode":"FL","FailureName":"Fuel Line Sealing Washer","FailureMode":"","FailureID":"F30003140","ComponentCode":"SW"},{"SystemCode":"FL","FailureName":"Fuel Pressure Relief Valve","FailureMode":"","FailureID":"F05000130","ComponentCode":"CX"},{"SystemCode":"FH","FailureName":"Fuel Pump","FailureMode":"","FailureID":"F05000270","ComponentCode":"AS"},{"SystemCode":"FH","FailureName":"Fuel Pump Actuator","FailureMode":"","FailureID":"F05000160","ComponentCode":"AV"},{"SystemCode":"FH","FailureName":"Fuel Pump Gear Pump","FailureMode":"","FailureID":"F05000070","ComponentCode":"PM"},{"SystemCode":"FL","FailureName":"Fuel Rail Fuel Supply Line","FailureMode":"","FailureID":"F30003200","ComponentCode":"RS"},{"SystemCode":"FL","FailureName":"Fuel Rails","FailureMode":"","FailureID":"F05000230","ComponentCode":"FR"},{"SystemCode":"FS","FailureName":"Fuel Shutoff Valve","FailureMode":"","FailureID":"F05000240","ComponentCode":"CO"},{"SystemCode":"FL","FailureName":"Fuel Supply Lines","FailureMode":"","FailureID":"F06000030","ComponentCode":"FS"},{"SystemCode":"EY","FailureName":"Idle Validation Switch","FailureMode":"","FailureID":"F19000960","ComponentCode":"PV"},{"SystemCode":"IH","FailureName":"Intake Air Heater","FailureMode":"","FailureID":"F10000060","ComponentCode":"GR"},{"SystemCode":"IN","FailureName":"Intake Manifold","FailureMode":"","FailureID":"F10000090","ComponentCode":"IM"},{"SystemCode":"IN","FailureName":"Intake Manifold Gasket","FailureMode":"","FailureID":"F30000700","ComponentCode":"GK"},{"SystemCode":"EA","FailureName":"Intake Manifold Pressure Sensor","FailureMode":"","FailureID":"F19000980","ComponentCode":"BB"},{"SystemCode":"EE","FailureName":"Intake Manifold Pressure/Temperature Sensor","FailureMode":"","FailureID":"F19000990","ComponentCode":"BT"},{"SystemCode":"RA","FailureName":"Intake Rocker Lever","FailureMode":"","FailureID":"F03000060","ComponentCode":"VI"},{"SystemCode":"XX","FailureName":"Intermittent/No Problem Found","FailureMode":"","FailureID":"F30001530","ComponentCode":"IP"},{"SystemCode":"FE","FailureName":"Low Pressure Engine Fuel Filter","FailureMode":"","FailureID":"F05000050","ComponentCode":"SW"},{"SystemCode":"LC","FailureName":"Lubricating Oil Cooler Element","FailureMode":"","FailureID":"F07000060","ComponentCode":"EL"},{"SystemCode":"LC","FailureName":"Lubricating Oil Cooler Element Mounting Gasket","FailureMode":"","FailureID":"F07000070","ComponentCode":"GM"},{"SystemCode":"LC","FailureName":"Lubricating Oil Cooler Housing Mounting Gasket","FailureMode":"","FailureID":"F07000080","ComponentCode":"GK"},{"SystemCode":"LN","FailureName":"Lubricating Oil Dipstick","FailureMode":"","FailureID":"F07000030","ComponentCode":"DS"},{"SystemCode":"FS","FailureName":"Lubricating Oil Fill Tube","FailureMode":"","FailureID":"F07000090","ComponentCode":"EL"},{"SystemCode":"LN","FailureName":"Lubricating Oil Filler Tube Seal","FailureMode":"","FailureID":"F07000100","ComponentCode":"OR"},{"SystemCode":"LF","FailureName":"Lubricating Oil Filter","FailureMode":"","FailureID":"F07000110","ComponentCode":"CA"},{"SystemCode":"LC","FailureName":"Lubricating Oil Filter Bypass Valve","FailureMode":"","FailureID":"F07000050","ComponentCode":"TS"},{"SystemCode":"LC","FailureName":"Lubricating Oil Filter Head","FailureMode":"","FailureID":"F07000120","ComponentCode":"HS"},{"SystemCode":"ED","FailureName":"Lubricating Oil Level Sensor","FailureMode":"","FailureID":"F19001024","ComponentCode":"OB"},{"SystemCode":"LN","FailureName":"Lubricating Oil Pan","FailureMode":"","FailureID":"F07000130","ComponentCode":"PN"},{"SystemCode":"LN","FailureName":"Lubricating Oil Pan Drain Plug and Gasket","FailureMode":"","FailureID":"F30003350","ComponentCode":"PL"},{"SystemCode":"LN","FailureName":"Lubricating Oil Pan Gasket","FailureMode":"","FailureID":"F07000140","ComponentCode":"GK"},{"SystemCode":"LN","FailureName":"Lubricating Oil Pan Mounting Hardware","FailureMode":"","FailureID":"F30002590","ComponentCode":"MH"},{"SystemCode":"LC","FailureName":"Lubricating Oil Pressure Regulator","FailureMode":"","FailureID":"F07000150","ComponentCode":"PR"},{"SystemCode":"EA","FailureName":"Lubricating Oil Pressure Sensor","FailureMode":"","FailureID":"F19000620","ComponentCode":"OB"},{"SystemCode":"EA","FailureName":"Lubricating Oil Pressure Switch","FailureMode":"","FailureID":"F19000625","ComponentCode":"SW"},{"SystemCode":"LP","FailureName":"Lubricating Oil Pump","FailureMode":"","FailureID":"F07000180","ComponentCode":"BO"},{"SystemCode":"LP","FailureName":"Lubricating Oil Pump Internal Gear","FailureMode":"","FailureID":"F30000390","ComponentCode":"DG"},{"SystemCode":"LN","FailureName":"Lubricating Oil Suction Tube","FailureMode":"","FailureID":"F07000190","ComponentCode":"ST"},{"SystemCode":"BK","FailureName":"Main Bearings","FailureMode":"","FailureID":"F01000190","ComponentCode":"MA"},{"SystemCode":"FH","FailureName":"Need To Assign","FailureMode":"","FailureID":"F30005350","ComponentCode":"OR"},{"SystemCode":"US","FailureName":"Need To Assign","FailureMode":"","FailureID":"F30005350","ComponentCode":"WH"},{"SystemCode":"LN","FailureName":"Need To Assign","FailureMode":"","FailureID":"F30005350","ComponentCode":"LC"},{"SystemCode":"XM","FailureName":"Need To Assign","FailureMode":"","FailureID":"F30005350","ComponentCode":"DM"},{"SystemCode":"XX","FailureName":"OEM Ambient Air Temperature Sensor ","FailureMode":"","FailureID":"F17000000","ComponentCode":"OE"},{"SystemCode":"XX","FailureName":"OEM Fuel Line","FailureMode":"","FailureID":"F06000040","ComponentCode":"OE"},{"SystemCode":"XX","FailureName":"OEM Relay","FailureMode":"","FailureID":"F17000060","ComponentCode":"OE"},{"SystemCode":"XX","FailureName":"OEM Wiring Harness","FailureMode":"","FailureID":"F19001050","ComponentCode":"OE"},{"SystemCode":"RA","FailureName":"Oil Filler Cap","FailureMode":"","FailureID":"F30000670","ComponentCode":"FP"},{"SystemCode":"RA","FailureName":"Overhead Set","FailureMode":"","FailureID":"F30001540","ComponentCode":"SA"},{"SystemCode":"BP","FailureName":"Piston","FailureMode":"","FailureID":"F01000250","ComponentCode":"CR"},{"SystemCode":"BK","FailureName":"Piston Cooling Nozzle","FailureMode":"","FailureID":"F01000260","ComponentCode":"NZ"},{"SystemCode":"BR","FailureName":"Piston Rings","FailureMode":"","FailureID":"F01000270","ComponentCode":"OC"},{"SystemCode":"FE","FailureName":"Primary Fuel Filter","FailureMode":"","FailureID":"F06000070","ComponentCode":"SP"},{"SystemCode":"RC","FailureName":"Push Rods or Tubes","FailureMode":"","FailureID":"F04000010","ComponentCode":"PV"},{"SystemCode":"XX","FailureName":"Radiator Hoses","FailureMode":"","FailureID":"F08000140","ComponentCode":"OE"},{"SystemCode":"EA","FailureName":"Rail Fuel Pressure Sensor","FailureMode":"","FailureID":"F19000840","ComponentCode":"RB"},{"SystemCode":"BM","FailureName":"Rear Crankshaft Seal","FailureMode":"","FailureID":"F01000280","ComponentCode":"SR"},{"SystemCode":"BM","FailureName":"Rear Crankshaft Seal Carrier","FailureMode":"","FailureID":"F30003410","ComponentCode":"CR"},{"SystemCode":"BD","FailureName":"Rear Gear Housing","FailureMode":"","FailureID":"F30000090","ComponentCode":"GH"},{"SystemCode":"RA","FailureName":"Rocker Lever Cover","FailureMode":"","FailureID":"F03000080","ComponentCode":"VC"},{"SystemCode":"RA","FailureName":"Rocker Lever Cover Gasket","FailureMode":"","FailureID":"F03000070","ComponentCode":"GV"},{"SystemCode":"RA","FailureName":"Rocker Lever Housing","FailureMode":"","FailureID":"F30000450","ComponentCode":"VS"},{"SystemCode":"RA","FailureName":"Rocker Lever Housing Gasket","FailureMode":"","FailureID":"F03000090","ComponentCode":"GK"},{"SystemCode":"SA","FailureName":"Starting Motor","FailureMode":"","FailureID":"F13000170","ComponentCode":"ED"},{"SystemCode":"SA","FailureName":"Starting Motor Magnetic Switch","FailureMode":"","FailureID":"F30000800","ComponentCode":"SO"},{"SystemCode":"FE","FailureName":"Suction Side Fuel Filter","FailureMode":"","FailureID":"F05000060","ComponentCode":"SW"},{"SystemCode":"WR","FailureName":"TRP 1975","FailureMode":"AV","FailureID":"F30004390","ComponentCode":"AL"},{"SystemCode":"WB","FailureName":"TRP 1993","FailureMode":"AB","FailureID":"F30004580","ComponentCode":"KC"},{"SystemCode":"RC","FailureName":"Tappets","FailureMode":"","FailureID":"F04000020","ComponentCode":"TA"},{"SystemCode":"XX","FailureName":"Terminating Resistor","FailureMode":"","FailureID":"F19001077","ComponentCode":"OE"},{"SystemCode":"TH","FailureName":"Turbocharger","FailureMode":"","FailureID":"F10000120","ComponentCode":"AS"},{"SystemCode":"TH","FailureName":"Turbocharger Actuator","FailureMode":"","FailureID":"F10000130","ComponentCode":"AC"},{"SystemCode":"ET","FailureName":"Turbocharger Compressor Intake Air Temperature Sensor","FailureMode":"","FailureID":"F19001100","ComponentCode":"TB"},{"SystemCode":"ET","FailureName":"Turbocharger Compressor Intake Humidity/Pressure/Temperature Sensor","FailureMode":"","FailureID":"F19001105","ComponentCode":"TB"},{"SystemCode":"KV","FailureName":"Turbocharger Coolant Line Seal","FailureMode":"","FailureID":"F30000620","ComponentCode":"OR"},{"SystemCode":"KV","FailureName":"Turbocharger Coolant Return Line","FailureMode":"","FailureID":"F08000170","ComponentCode":"TR"},{"SystemCode":"KV","FailureName":"Turbocharger Coolant Supply Line","FailureMode":"","FailureID":"F08000160","ComponentCode":"TS"},{"SystemCode":"IE","FailureName":"Turbocharger Mounting Gasket","FailureMode":"","FailureID":"F11000630","ComponentCode":"GM"},{"SystemCode":"LS","FailureName":"Turbocharger Oil Drain Line","FailureMode":"","FailureID":"F10000170","ComponentCode":"HT"},{"SystemCode":"LS","FailureName":"Turbocharger Oil Drain Line Mounting Gasket","FailureMode":"","FailureID":"F30001280","ComponentCode":"GK"},{"SystemCode":"LS","FailureName":"Turbocharger Oil Supply Line","FailureMode":"","FailureID":"F30000550","ComponentCode":"HH"},{"SystemCode":"EL","FailureName":"Turbocharger Speed Sensor","FailureMode":"","FailureID":"F19001120","ComponentCode":"TS"},{"SystemCode":"TH","FailureName":"Turbocharger Variable Flow Actuator","FailureMode":"","FailureID":"F19001125","ComponentCode":"AC"},{"SystemCode":"RA","FailureName":"Valve Rocker Shaft","FailureMode":"","FailureID":"F03000110","ComponentCode":"SH"},{"SystemCode":"BE","FailureName":"Vibration Damper","FailureMode":"","FailureID":"F01000320","ComponentCode":"DV"},{"SystemCode":"KC","FailureName":"Water Inlet Connection","FailureMode":"","FailureID":"F30001010","ComponentCode":"NM"},{"SystemCode":"KT","FailureName":"Water Outlet Connection","FailureMode":"","FailureID":"F30003490","ComponentCode":"CO"},{"SystemCode":"KP","FailureName":"Water Pump","FailureMode":"","FailureID":"F08000180","ComponentCode":"BE"},{"SystemCode":"KH","FailureName":"Water Pump Belt Tensioner","FailureMode":"","FailureID":"F08000000","ComponentCode":"BT"},{"SystemCode":"KP","FailureName":"Water Pump Body","FailureMode":"","FailureID":"F30000290","ComponentCode":"BD"},{"SystemCode":"KP","FailureName":"Water Pump O-Ring Seal","FailureMode":"","FailureID":"F30000680","ComponentCode":"OR"},{"SystemCode":"KP","FailureName":"Water Pump Pulley","FailureMode":"","FailureID":"F30003500","ComponentCode":"PU"},{"SystemCode":"KP","FailureName":"Water Pump Seal","FailureMode":"","FailureID":"F30000280","ComponentCode":"SE"},{"SystemCode":"ED","FailureName":"Water in Fuel Sensor","FailureMode":"","FailureID":"F19001160","ComponentCode":"WF"},{"SystemCode":"XX","FailureName":"","FailureMode":"","FailureID":"F17000040","ComponentCode":"OE"},{"SystemCode":"XX","FailureName":"","FailureMode":"","FailureID":"F13000040","ComponentCode":"OE"},{"SystemCode":"IN","FailureName":"","FailureMode":"","FailureID":"F10000040","ComponentCode":"TD"},{"SystemCode":"SN","FailureName":"","FailureMode":"","FailureID":"F01000110","ComponentCode":"FW"}]}';
                insert jer;
                system.debug('Anirudh method call out'+jer);
                JobPlanOverCont.accCodeSelected = 'EMISSION WARRANTY 70';
                JobPlanOverCont.failureMeasure='Hours';
                JobPlanOverCont.coverageType = 'POL';
                JobPlanOverCont.Validations();
                JobPlanOverCont.coverageType = 'NPW';
                JobPlanOverCont.coverageFound = 'false';
                JobPlanOverCont.accCodeSelected = '52';
                JobPlanOverCont.selectedFailMode = 'THAS';
                JobPlanOverCont.chkClickonPartsCoverage = false;
		        set<string> setBlankFieldset = new set<string>();
                setBlankFieldset.add('false');
    		    //JobPlanOverCont.tempblankfieldset = setBlankFieldset;
                JobPlanOverCont.Validations();
                //JobPlanOverCont.SRTFailurenames();


                Test.stopTest();
            }
        }
    }
    public static testMethod void TestMethod11_1()
    {

        //Creating Service Job--1
        CSS_Job_Order__c jobRef2 = CSS_TestData.createJobOrder(true); 
        //CSS_Job_Order__c jobRef2 = new CSS_Job_Order__c();    
        list<string> falist=new list<string>();
        string st='Test';
        falist.add(st);
        list<string> partfalist=new list<string>();
        string st1='Test';
        partfalist.add(st1);
        //list<string> prtlst=new list<string>();
        //string st2='Test';
        //prtlst.add(st2);
        // Set<string> faultCodeList=new Set<string>();
        //string st2='Test';
        //faultCodeList.add(st2);
        CSS_JobPlanOverviewControllerNew obj=new CSS_JobPlanOverviewControllerNew();
        obj.faultList=falist;
        obj.partlistFAULT=partfalist;
        //obj.partlist=prtlst;
        //obj.faultCodeList=faultCodeList;
        jobRef2.chevron_page__c='jo';
        jobRef2.BMSWSStatus__c = 'UI';
        jobRef2.CSS_Resolution__c = 'Test';
        jobRef2.General_Symptoms__c='';

        jobRef2.CoverageResponse__c = 'xyz';

        upsert jobRef2;

        list<CSS_Solutions__c> sollist=new list<CSS_Solutions__c>();
        //Creating Solutions--2
        CSS_Solutions__c solRef2 =  CSS_TestData.createSolutions(false,jobRef2.Id);
        solRef2.Diagnostic_Response__c  = 'Most Likely the Solution';
        //insert solRef2;
        CSS_Solutions__c solRef3 =  CSS_TestData.createSolutions(false,jobRef2.Id);
        solRef3.Diagnostic_Response__c  = 'Most Likely the Solution';
        //insert solRef3;
        sollist.add(solRef2);
        sollist.add(solRef3);
        upsert sollist;
        set<Id> solutionIds = new set<Id>();
        solutionIds.add(solRef2.id);
        solutionIds.add(solRef3.id);

        List<CSS_Solution_Component__c> solComList = new List<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solComRef = CSS_TestData.createSRT(false,jobRef2.Id,solRef2.Id);
        solComRef.System_Code__c = 'Test';

        solComRef.Component_Code__c = 'Test';
        solComRef.Failure_Mode__c = 'Test';
        solComRef.Solutions__c =solRef2.id;
        solComRef.AccountCodeType__c = 'Test-Test';
        solComRef.AccountCode_Call_Status__c = 'Failure';
        solComRef.Failure_Point__c=11.0;
        solComRef.Failure_Measure__c = null;
        //       solComRef.Failure_Date__c=date.parse('12-27-2014');
        solComRef.Failure_Date__c=date.today();
        solComRef.AccountCode__c = '';
        solComRef.AccountCodeEdit__c='';

        System.debug('The Solution Component Object');
        solComList.add(solComRef);


        CSS_Solution_Component__c solComRef1 = CSS_TestData.createSRT(false,jobRef2.Id,solRef2.Id);
        solComRef.System_Code__c = 'Test';

        solComRef1.Component_Code__c = 'Test';
        solComRef1.Failure_Mode__c = 'Test';
        solComRef1.Solutions__c =solRef2.id;

        solComRef1.AccountCode_Call_Status__c = 'Failure';
        solComRef1.Failure_Point__c=11.0;
        solComRef1.Failure_Measure__c = null;
        //       solComRef.Failure_Date__c=date.parse('12-27-2014');
        solComRef1.Failure_Date__c=date.today();

        solComList.add(solComRef1);
        insert solComList;
        CSS_Fault_Code__c fc3 = new CSS_Fault_Code__c(FaultCodeR2__c = '441',Related_Fault_Code__c = '234,546');
        fc3.Name = '441';
        fc3.Job_Order__c = jobRef2.Id;
        fc3.Sequence__c = 1; 
        fc3.Fault_Code_Type__c = 'APD-P';
        fc3.Mod__c = '0';
        fc3.isPole__c = false;
        fc3.Number_of_Solutions__c = '1';
        insert fc3;

        CSS_JobEventTemporary__c JETsys = new CSS_JobEventTemporary__c();
        JETsys.Attribute1__c = 'Te';
        JETsys.Attribute4__c ='Te';
        JETsys.key__c = 'FailCodes';
        JETsys.Attribute3__c = 'TURBO';
        JETsys.Attribute5__c = 'ASSEMBLY';
        JETsys.Reason__c = '{\r\n\t\"Header\": {\r\n\t\t\"ReturnCodeDescription\": \"Normal, Successful completion.\",\r\n\t\t\"ReturnCode\": \"ORA-00000\",\r\n\t\t\"MessageIdentifier\": \"S\"\r\n\t},\r\n\t\"DataArea\": [{\r\n\t\t\"SystemCode\": \"WF\",\r\n\t\t\"FailureName\": \"ATC 1795\",\r\n\t\t\"FailureMode\": \"SP\",\r\n\t\t\"FailureID\": \"F30003750\",\r\n\t\t\"ComponentCode\": \"HA\"\r\n\t}]\r\n}';
        insert JETsys;

        CSS_JobEventTemporary__c JETsys1 = new CSS_JobEventTemporary__c();
        JETsys1.Attribute1__c = 'ISX12 CM2350 X102';
        JETsys1.Attribute2__c ='OK';
        JETsys1.key__c = 'GetFailureCodesSRT';
        JETsys1.Attribute3__c = 'ISX12 CM2350 X102;;0K';
        JETsys1.Attribute5__c = 'ASSEMBLY';
        JETsys1.Reason__c = '{\r\n\t\"Header\": {\r\n\t\t\"ReturnCodeDescription\": \"Normal, Successful completion.\",\r\n\t\t\"ReturnCode\": \"ORA-00000\",\r\n\t\t\"MessageIdentifier\": \"S\"\r\n\t},\r\n\t\"DataArea\": [{\r\n\t\t\"SystemCode\": \"WF\",\r\n\t\t\"FailureName\": \"ATC 1795\",\r\n\t\t\"FailureMode\": \"SP\",\r\n\t\t\"FailureID\": \"F30003750\",\r\n\t\t\"ComponentCode\": \"HA\"\r\n\t}]\r\n}';
        insert JETsys1;
        List<CSS_Fault_Code__c> lstFC1 = new List<CSS_Fault_Code__c>();
        lstFC1.add(fc3);
        PageReference pref;
        pref = new PageReference('/'+jobRef2.id);
        pref.getParameters().put('id',jobRef2.id);
        Test.setCurrentPage(pref);

        CSS_Integration_Details__c cid = CSS_TestData.createIntegrationDetails(false);
        cid.name = 'CSS_SBL_WarrantyDetailCoverage';
        cid.ApplicationName__c = 'CSS_SBL_WarrantyDetailCoverage';
        cid.End_Point__c = 'https://services-stg.cummins.com/csswarranty/accodecoverage';
        insert cid;

        test.startTest();
        CSS_JobPlanOverviewControllerNew JobPlanOverCont1 = new CSS_JobPlanOverviewControllerNew();
        JobPlanOverCont1.failCodeSelected='EGCD-EGCD';
        Test.setMock(HttpCalloutMock.class, new CSS_WS_SBL_GetWarrantyDetailCovrg_Test());
        system.debug('Start>>');
        JobPlanOverCont1.checkcoverage();
        system.debug('Stop>>');
        Test.stopTest();        
    }
    public static testMethod void TestMethod3111()
    {

        UserRole empRole = [Select Id From UserRole Where Name = 'CEO' Limit 1];
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'kal1', Email='standarduser11@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='kal12', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='kal11111@testorg.com', user_Location__c = '562701-562551',UserRoleId = empRole.id);
        insert(u);
        System.runAs(u) 
        { 

            Account acc = new Account();
            acc.name='aka';
            acc.CSS_DistributorCode__c='02650';
            acc.ERP_System__c = 'One BMS';
            acc.IAM_Service_Provider_Code__c='97895';
            acc.Type ='Dealer Account';
            insert acc;

            CSS_Job_Order__c jobRef = new CSS_Job_Order__c();
            jobRef.chevron_page__c='jo';
            jobRef.ApplicationCode__c = '130';

            jobRef.BMSWSStatus__c = 'UI';
            //jobRef.Name='test';
            jobRef.ESN__c ='Testing';
            jobRef.Service_Model__c ='ISB6.7 CM2350 B101';
            jobRef.Qsol_Engine_Family_Code__c ='10';
            jobRef.Repair_Location__c='Mobile';
            insert jobRef;

            PageReference pref;
            pref = new PageReference('/'+jobRef.id);
            pref.getParameters().put('id',jobRef.id);
            Test.setCurrentPage(pref);

            CSS_JobEventTemporary__c JETsys = new CSS_JobEventTemporary__c();
            JETsys.Attribute1__c = 'Te';
            JETsys.Attribute4__c ='Te';
            JETsys.key__c ='FailCodes';
            JETsys.Attribute3__c = 'TURBO';
            JETsys.Attribute5__c = 'ASSEMBLY';
            insert JETsys;
            CSS_JobEventTemporary__c JETsys1 = new CSS_JobEventTemporary__c();
            JETsys1.Attribute1__c = 'NPW';
            JETsys1.Attribute2__c ='OK';
            JETsys1.key__c = 'FailCodes';
            JETsys1.Attribute3__c = 'ISX12 CM2350 X102;;0K';
            JETsys1.Attribute5__c = 'ASSEMBLY';
            JETsys1.Reason__c = '{\r\n\t\"Header\": {\r\n\t\t\"ReturnCodeDescription\": \"Normal, Successful completion.\",\r\n\t\t\"ReturnCode\": \"ORA-00000\",\r\n\t\t\"MessageIdentifier\": \"S\"\r\n\t},\r\n\t\"DataArea\": [{\r\n\t\t\"SystemCode\": \"WF\",\r\n\t\t\"FailureName\": \"ATC 1795\",\r\n\t\t\"FailureMode\": \"SP\",\r\n\t\t\"FailureID\": \"F30003750\",\r\n\t\t\"ComponentCode\": \"HA\"\r\n\t}]\r\n}';
            insert JETsys1;


            CSS_Fault_Code__c fauCodRef = new CSS_Fault_Code__c();
            fauCodRef.Job_Order__c =jobRef.Id; 
            fauCodRef.Sequence__c=1;
            fauCodRef.Fault_Code_Type__c='BPD'; 
            fauCodRef.Primary_Fault_Code__c=3539; 
            fauCodRef.Status__c='A';
            insert fauCodRef;
            List<CSS_Fault_Code__c> fauCodRefList = new List<CSS_Fault_Code__c>();
            fauCodRefList.add(fauCodRef);
            CSS_SymptomQA__c sym = new CSS_SymptomQA__c();
            sym.Name = 'test';
            insert sym;

            list<CSS_Solutions__c > solReflist=new list<CSS_Solutions__c>();

            CSS_Solutions__c solRef =  CSS_TestData.createSolutions(false,jobRef.Id);
            solRef.FaultCode__c = fauCodRef.id;
            solRef.Symptom__c = sym.id;
            solRef.Repair_Response__c='NO';
            upsert solRef;

            solReflist.add(solRef);
            upsert solReflist;

            list<CSS_Solution_Component__c> solComReflist=new list<CSS_Solution_Component__c>();
            CSS_Solution_Component__c solComRef = CSS_TestData.createSRT(false,jobRef.Id,solRef.Id);
            solComRef.System_Code__c = 'Test';
            solComRef.SystemCode_Desc__c = 'test';
            solComRef.Component_Code__c = 'Test';
            solComRef.ComponentCode_Desc__c = 'test';
            solComRef.Fault_Code__c = 'test';
            solComRef.Failure_Mode__c = 'Test';
            solComRef.Solutions__c =solRef.id;
            //solComRef.Performed_Review__c=true;
            solComRef.Type__c=null;
            solComRef.selected_Component__c = true;
            solComRef.Service_Job__c=jobRef.id;
            solComRef.AccountCodeType__c = 'Test-Test';
            solComRef.AccountCode_Call_Status__c = 'Failure';
            solComRef.AccountCode__c = 'ACCODE';
            //solComRef.AccountCodeEdit__c='ADEDIT';
            solComRef.Failure_Measure__c='ADEDIT';
            solComRef.name='unlisted';
            insert solComRef;
            solComReflist.add(solComRef);

            Set<String> failureNameList = new Set<String>();
            String grpName = 'CQ'+'-'+'56270-56255';
            Group testQue = new Group(Name=grpName, type='Queue');
            insert testQue;
            CSS_Integration_Details__c csInt = new CSS_Integration_Details__c();
            csInt.name = 'SRT';
            csInt.ApplicationName__c='SRT';
            csInt.End_Point__c='https://Test-services-dev.cummins.com/css/';
            csInt.IsActive__c=true;
            csInt.Key__c='/Q0w11SmTDJ11dPRgzYfGjycs+HZbtT8sezi/jkT7Ag=';
            csInt.Passcode__c='u9pf3rdOE0SCjXDCgmzRbUlwWQWen7B9993Eh61KI1E=';
            csInt.Username__c='6dpW6v5ekUR2HzkTePJXwgNaMDgo0t53tZgmixV4rfU=';
            insert csint;
            system.runas(new User(Id=UserInfo.getUserId()))
            { 

                QueueSObject tq = new QueueSObject(SobjectType='CSS_Claims__c', QueueId=testQue.Id);
                insert tq;


                CSS_Claims__c claims = new CSS_Claims__c();
                claims.Status__c='Submitted';
                claims.ESN__c='79462880';
                claims.Customer_Name__c='BRITESTONE COLONY';
                claims.Customer_Code__c='123';
                claims.Location_Code__c='56270-56255';
                claims.ownerId = UserInfo.getUserId();
                insert claims;
                Test.startTest();

                CSS_JobPlanOverviewControllerNew JobPlanOverCont = new CSS_JobPlanOverviewControllerNew();
                JobPlanOverCont.componentId = solComRef.Id;
                JobPlanOverCont.failCodeSelected = 'Select One';
                JobPlanOverCont.accCodeSelected = 'PARTS WARRANTY 35';
                JobPlanOverCont.failCodeEditable='Select One';
                JobPlanOverCont.allFaultCodes = fauCodRefList;
                JobPlanOverCont.failureMeasure='Kilometers';
                Test.setMock(HttpCalloutMock.class, new SRTMockHttpResponseGenerator());
                //JobPlanOverCont.SRTFailurenames();
                Test.setMock(HttpCalloutMock.class, new CSS_SRTCompMockup_Test());
                JobPlanOverCont.mainSOQL();
                JobPlanOverCont.failCodeChangeGO();
                //Test.setMock(HttpCalloutMock.class, new CSS_MockHttpResponseGenerator()); 
                JobPlanOverCont.callCreateWoqtInbound('Testing Class');
                JobPlanOverCont.jobplan_jpq();
                //    JobPlanOverCont.jobplan_srt();
                JobPlanOverCont.partsWarranty=null;
                JobPlanOverCont.accCodeSelected='62';
                JobPlanOverCont.partssave();
                JobPlanOverCont.showResolutionWithRepair=true;
                //JobPlanOverCont.saveAndCloseJob();
                JobPlanOverCont.onChangeofAppCode();
                JobPlanOverCont.SelectedFname = null; 
                JobPlanOverCont.Wid = apexpages.currentPage().getparameters().put('id',claims.Id); 
                boolean headerValidation = CG_BL_ODM.callODMHeaderValidationService(null,null,null,null,null,null); 
                JobPlanOverCont.SendFailurestoERP();

                CSS_JobEventTemporary__c jet=new CSS_JobEventTemporary__c();
                jet.Attribute1__c='OTH';jet.Attribute1__c='POL';jet.Attribute1__c='NPW';jet.Attribute1__c='RPW';jet.Attribute1__c='REW';jet.Attribute1__c='RRW ';

                jet.key__c='AccountCodes';

                //JobPlanOverCont.callUnitInboundGeneric();
                JobPlanOverCont.callUpdateUnitandWo();
                JobPlanOverCont.jobplan_jo();
                JobPlanOverCont.jobplan_war();
                JobPlanOverCont.jobplan_narr();
                JobPlanOverCont.showPopup();
                JobPlanOverCont.closePopup();
                JobPlanOverCont.redirectPopup();
                JobPlanOverCont.getAccountCodes1();
                JobPlanOverCont.closeSession_close();
                JobPlanOverCont.pgSaveFinish();
                JobPlanOverCont.CompareDates();
                JobPlanOverCont.getfailurenames();

                CSS_Solution_Component__c compe = new CSS_Solution_Component__c(System_Code__c='HCL',accountcodeedit__c=JobPlanOverCont.accCodeReturned,Component_Code__c='TCS',Service_Job__c=JobPlanOverCont.wid);
                insert compe;
                JobPlanOverCont.compont=compe;
                JobPlanOverCont.compont.Failure_Date__c=null;
                JobPlanOverCont.failureDate1=system.today();
                JobPlanOverCont.CompareDates();
                JobPlanOverCont.failureDate=system.today().adddays(2);
                JobPlanOverCont.CompareDates();
                JobPlanOverCont.compont.Failure_Date__c=system.today();
                JobPlanOverCont.CompareDates();
                JobPlanOverCont.selectedSysCode='HCL-ASP';
                JobPlanOverCont.selectedCompCode='TCS-ASP';
                JobPlanOverCont.accCodeReturned='NEW PARTS';
                JobPlanOverCont.failureMeasure='Hours';
                JobPlanOverCont.coverageType = 'POL';
                JobPlanOverCont.Validations();
                for(integer i=0; i<10;i++){
                    CSS_Solution_Component__c comp = new CSS_Solution_Component__c(System_Code__c='HCL',accountcodeedit__c=JobPlanOverCont.accCodeReturned,Component_Code__c='TCS',Service_Job__c=JobPlanOverCont.wid);
                    insert comp;
                }
                JobPlanOverCont.coverageType = 'POL';
                JobPlanOverCont.Validations();
                JobPlanOverCont.coverageType = 'NPW';
                JobPlanOverCont.coverageFound = 'false';
                JobPlanOverCont.accCodeSelected = '52';
                JobPlanOverCont.selectedFailMode = 'THAS';
                JobPlanOverCont.chkClickonPartsCoverage = false;
		        set<string> setBlankFieldset = new set<string>();
                setBlankFieldset.add('false');
    		    //obPlanOverCont.tempblankfieldset = setBlankFieldset;
                JobPlanOverCont.Validations();
                JobPlanOverCont.getPayCodesonAccCodeChangeOnLoad();
                JobPlanOverCont.workJob.Customer_Name__c = null;
                JobPlanOverCont.workJob.Application_Desc__c = null;
                JobPlanOverCont.workJob.Shop_Work_Order__c = null;
                JobPlanOverCont.workJob.Unit_number__c = null;
                JobPlanOverCont.workJob.Mileage__c = null;
                JobPlanOverCont.workJob.ESN__c = null;
                JobPlanOverCont.checkCoverageNew();
                JobPlanOverCont.ChkFieldBlank();
                JobPlanOverCont.coverageType = 'TH';
                JobPlanOverCont.coverageFound = 'False';
                //JobPlanOverCont.accCodeEdit = '53';
                JobPlanOverCont.jobplan_jo();
                JobPlanOverCont.pgSave();
                JobPlanOverCont.Cancel();
                JobPlanOverCont.loadPopup();

                Test.stopTest();
            }
        }
    }
    static testMethod void cancelPopupMethod(){
        //Creating Service Job--1
        CSS_Job_Order__c jobRef2 = CSS_TestData.createJobOrder(true); 
        Test.startTest();
        CSS_JobPlanOverviewControllerNew obj=new CSS_JobPlanOverviewControllerNew();
        obj.workjob = jobRef2;
        obj.cancelPopup();
        Test.stopTest();
    }
    static testMethod void onChangeofLicensePlateMethod(){
        Test.startTest();
        CSS_JobPlanOverviewControllerNew obj=new CSS_JobPlanOverviewControllerNew();
        obj.onChangeofLicensePlate();
        obj.licenseplateSelected = '';
        obj.onChangeofLicensePlate();
        Test.stopTest();
    }
    static testMethod void jobplan_prtMethod(){
        Test.startTest();
        CSS_JobPlanOverviewControllerNew obj=new CSS_JobPlanOverviewControllerNew();
        //obj.jobplan_prt();
        Test.stopTest();
    }
    static testMethod void getlicensePlateListMethod(){
        Test.startTest();
        CSS_JobPlanOverviewControllerNew obj=new CSS_JobPlanOverviewControllerNew();
        obj.getlicensePlateList();
        Test.stopTest();
    }
    static testMethod void onChangeofAppCode(){
        CSS_JobEventTemporary__c jj = new CSS_JobEventTemporary__c();
        jj.Attribute1__c = 'test';
        jj.Attribute2__c = 'test';
        jj.Attribute3__c = 'test';
        jj.Attribute4__c = 'krishna';
        jj.Attribute5__c = 'Y';
        jj.Reason__c = 'test';
        jj.Key__c = 'ApprovalAuthCode';
        insert jj;
        
        Test.startTest();
        CSS_JobPlanOverviewControllerNew obj=new CSS_JobPlanOverviewControllerNew();
        obj.appCodeSelected = 'krishna';
        obj.onChangeofLicensePlate();
        obj.licenseplateSelected = '';
        obj.onChangeofLicensePlate();
        Test.stopTest();
    }
}