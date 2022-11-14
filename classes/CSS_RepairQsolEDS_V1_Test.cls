@isTest


public class CSS_RepairQsolEDS_V1_Test {
    
    static testMethod void CSS_RepairQsolEDS_V1_Test_Method1(){
        
        
        
        decimal diatime = 0.23;
        String sDTime1 ='2';
        String JSONSols  = '[ ';
        String sStat = '0';
        String sSuffix = '';
        Integer iCounter = 0;
        Boolean blnActive = false;
        //string rank = '0';
        //integer rank = 0;
        boolean failDiagResp =false;        
                   Account acc = new Account();
            acc.name='Kenworth Sales Co';
            acc.CSS_DistributorCode__c='02466';
            acc.IAM_Service_Provider_Code__c='19134';
            acc.Type='Dealer Account';
            acc.CMI_Account_Status__c = 'Active';
            insert acc;

        CSS_Job_Order__c job= new CSS_Job_Order__c();
        job.Account__c=acc.id;
       // job.esn__c='12345';
        job.Status__c = 'Intake';
        job.INSITE_UpdateTimeStamp__c =system.today();
        job.INSITE_ESN_Choice__c='Not Selected';
        job.Qsol_Engine_Family_Code__c = 'code';
        job.Warranty_Start_Date__c = date.today();
        job.CSS_Job_Location_Code__c = 'location';
        job.ApplicationCode__c = 'code';
        //job.Creator_Location__c = 'llll';
        job.DSID__c='2323';
        job.ESN__c ='21323';
        job.Application__c='asdd';
        job.Unit_Number__c='213';
        job.Failure_Point__c=213.00;
        job.Failure_Point_Measure__c='asd';
        job.Make__c='Make';
        job.ESN_Insite__c = 'insite';
        job.Model__c='Model';
        job.Equipment_ID__c='Equip';
        job.Customer_Name__c='Peterbuilt';
        job.Shop_Work_Order__c='213dssd';
        job.Service_Model__c='SMNNUM';
        job.DSID_Creation_Timestamp__c=system.today();
        job.DSID_Status__c='Stat';
        job.DSID_WorkGroup__c='Wrkgrp';
        job.Status__c = 'Triage & Diagnosis Complete' ;
        job.Previous_Status__c = 'Triage & Diagnosis' ;
        job.Failure_Date__c = date.today();
        
        insert job;
          
       /* job.Status__c = 'Triage & Diagnosis/Repair';
        job.Previous_Status__c = 'Triage & Diagnosis/Repair';
        update job;*/
        
        
        CSS_Fault_Code__c faulCodeRec = new CSS_Fault_Code__c(Name='3478',Related_Fault_Code__c='98734,95869',isPole__c = true);
        insert faulCodeRec;
        
        CSS_SymptomQA__c sym=new CSS_SymptomQA__c();
        sym.Job_Order__c=job.id;
        sym.caption__c ='white smoke';
        sym.Option1__c  ='12213';
        sym.Job_Order__c  =job.id;
        sym.Option_type__c  ='qwewqe';
        sym.Guide_Question__c  ='Do you see smoke';
        sym.Type__c  ='SearchString';
        
        insert sym; 
        
        CSS_SymptomQA__c symQA=new CSS_SymptomQA__c();
        sym.Job_Order__c=job.id;
        sym.caption__c ='fault Code';
        sym.Option1__c  ='12213';
        sym.Job_Order__c  =job.id;
        sym.SearchString__c  =sym.id;        
        sym.Type__c  ='QA';
        insert symQA;
        
        CSS_Solutions__c sol=new CSS_Solutions__c();
        //  sol.caseIndexInResultSet__c='test';
        sol.Case_Name__c='test';
        sol.Name='test';
        sol.FaultCode__c = faulCodeRec.id;
        sol.Diagnostic_Response__c='test';
        sol.Repair_Response__c='test';
        sol.Symptom__c=sym.id;
        sol.Service_Job__c=job.id;
        sol.CSS_Nested_Solutions__c = sol.id;
        sol.rank__c=0;
        sol.Out_Of_Order__c = false;
        sol.Solution_Title__c = 'test';
        sol.Solution__c ='test';
        sol.Report_Comments__c ='qwewqewqewewqe';
        sol.Diagnostic_notes__c ='asdsadad';
        
        insert sol;

//CSS_accountLanguage__c SerJob= CSS_TestData.createAccountLanguage(true);
        
        
       List<CSS_Solution_Component__c>solcomp1 = new List<CSS_Solution_Component__c>();
        
         CSS_Solution_Component__c csc=new CSS_Solution_Component__c();
        csc.Action__c='test';
        csc.Component_Id__c = 'compid';
        csc.System_Code__c = 'syst';
        csc.Component_Code__c = 'compcode';
        csc.AccountCode__c = 'acccode';
        csc.Solutions__c=sol.id;
        csc.Service_Job__c=job.id;
        csc.Selected_Component__c=true;
        insert csc;
 
        
        CSS_Solution_Component__c csc1=new CSS_Solution_Component__c();
        csc1.Action__c='test';
         csc1.Solutions__c=sol.id;
        csc1.Service_Job__c=job.id;
        csc1.Selected_Component__c=false;
       //insert csc1;
      solcomp1.add(csc1);
        insert solcomp1;
        
           Id recTypeIdpart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'Parts');
        
       
        
        CSS_Parts_Options__c parts = new CSS_Parts_Options__c();
        parts.recordtypeId = recTypeIdpart;
        parts.Option_Number__c = 'O-111';
        parts.Option_ESN__c = 'esnnnstring';
        parts.selected_part__c = true;
        parts.FailureName__c = 'fname';
        parts.Assignment__c = 'Replaced';
        parts.Notes__c = 'partsoptionnotes';
        parts.OEM__c = 'oem';
        parts.Part_Description__c = 'descrtttt';
        parts.Part_Name__c = 'nameee';
        parts.part_size__c = '8';
        parts.Quantity__c = 5;
        parts.Service_partnumber__c = 'number';
        parts.Replacement_Reason__c = 'Campaign-TRP-ATC';
        parts.Service_Job__c = job.id;
        parts.FailurepartId__c = csc.Id;
        parts.Part_Assignment__c = 'Primary';
        parts.Solutions__c=sol.id;
        insert parts;
        
        /* CSS_Parts_Options__c parts1 = new CSS_Parts_Options__c();
        parts1.recordtypeId = recTypeIdpart;
        parts1.Option_Number__c = 'O-111';
        parts1.Service_Job__c = job.id;
        parts1.selected_part__c = true;
        parts1.FailurepartId__c = csc1.Id;
        parts1.Part_Assignment__c = 'Primary';
        parts1.Solutions__c=sol.id;
        insert parts1;*/
        
        CSS_SRT__c srt=new CSS_SRT__c();
        srt.Solution_Number__c=sol.id;
        srt.Job_Order__c=job.id;
        srt.Type__c = 'Diagnosis';
        srt.SRT_Time__c=0.6;
        //srt.Diagnosis_Time__c=0.6;
        insert srt;
        
        CSS_SRT__c srtRep=new CSS_SRT__c();
        srt.Solution_Number__c=sol.id;
        srt.Job_Order__c=job.id;
        srt.Type__c = 'Repair';
        srt.SRT_Time__c=0.6;
        insert srtRep;
        
        List<CSS_SymptomQA__c> symList=new List<CSS_SymptomQA__c>();
        List<CSS_SymptomQA__c> symList1=new List<CSS_SymptomQA__c>();
        List<CSS_Solutions__c> solList=new List<CSS_Solutions__c>();
        
        
        List<CSS_Solution_Component__c> solComp  = new List<CSS_Solution_Component__c>();
        List<CSS_SRT__c> srts = new List<CSS_SRT__c>();
        List<CSS_SRT__c> srtsRep = new List<CSS_SRT__c>();
        
        symList.add(sym);
        symList1.add(symQA);
        solList.add(sol);
        
        solComp.add(csc);
        srts.add(srt) ;  
        srtsRep.add(srtRep);
        
        list<CSS_Solutions__c> solutionList = new list<CSS_Solutions__c>();
        CSS_Solutions__c solRec = new CSS_Solutions__c(Name='Solution1',Solution_Title__c='Title1',rank__c=1,Out_Of_Order__c = false,        
        Solution__c ='test',Report_Comments__c ='qwewqewqewewqe',Diagnostic_notes__c ='asdsadad',
                                                       Repair_Notes__c='',Repair_Response__c='Repair Successful with additional parts/procedures',Service_Job__c=job.id,
                                                      FaultCode__c=faulCodeRec.Id);
        
        insert solRec; 
        
       // solutionList.add(solRec);
        CSS_Solutions__c solRec1 = new CSS_Solutions__c(Name='Solution2',Rank__c=1,Solution_Title__c='Title2',
                                                        Repair_Notes__c='Notes2',Repair_Response__c='response2',Service_Job__c=job.id,
                                                        FaultCode__c=faulCodeRec.Id);
        
        solutionList.add(solRec1);
        insert solutionList;
        
          CSS_EDSAuthentication.getSolutionDetails(sol.id,job.DSID__c,'en',0,'O'); 
        
        PageReference pageRef = new PageReference('/apex/JobTndTs?id=');
        test.setCurrentPage(pageRef);
        ApexPages.CurrentPage().getParameters().put('fcid',faulCodeRec.Id);
        pageRef.getParameters().put('id',job.id);
        //pageRef.getParameters().put('symid',sym.id);
        pageref.getParameters().put('rank','1');
        
        css_repair_job  cssRep = new css_repair_job();
        CSS_RepairQsolEDS_V1 extsymRep = new CSS_RepairQsolEDS_V1(cssRep);
        extsymRep.comp = solcomp1;
        extsymRep.Components = solcomp1;
        // CSS_Solutions__c  solRec ;
        CSS_Solutions__c  solDetails;
        CSS_Solution_Component__c Components;
        CSS_accountLanguage__c accLang= CSS_TestData.createAccountLanguage(true);
        //Test.startTest();
        Test.setMock(HttpCalloutMock.class, new CSS_GetSolDetails_Test());
        /**/
        string json1 = '{"key":"1234","message":"This is a test","messageArg":["a","b"],"solutionNumber":"K74452217","solutionTitle":"Fault Code 122 triggered by another fault code","coreIssue":"There are some instances when a fault code is recorded, but is strongnotstrong the first fault code that should be diagnosed.  br ","modificationDate":"01022016","status":"success","verification":"strongConditionsstrong ulliTurn keyswitch ON.liliConnect INSITE electronic service tool.liulstrongActionstrongbr Check for active fault codes. ulliUse INSITE electronic service tool to read the fault codes.liulstrongSpecificationstrong ulliIf Fault Code 227, 352, or 386 is active, then perform a search on the appropriate fault and troubleshoot that fault prior to troubleshooting Fault Code 122.liul","resolution":"pPerform a search on the appropriate fault code.p","poleLogicSolution":true,"components":[{"value":"string","failureId":"string"}],"repCompoundSolutions":[{"solutionNumber":"K74452217","solutionTitle":"Fault Code 122 triggered by another fault code","coreIssue":"There are some instances when a fault code is recorded, but is strongnotstrong the first fault code that should be diagnosed.  br ","modificationDate":"01022016","status":"success","verification":"strongConditionsstrong ulliTurn keyswitch ON.liliConnect INSITE electronic service tool.liulstrongActionstrongbr Check for active fault codes. ulliUse INSITE electronic service tool to read the fault codes.liulstrongSpecificationstrong ulliIf Fault Code 227, 352, or 386 is active, then perform a search on the appropriate fault and troubleshoot that fault prior to troubleshooting Fault Code 122.liul","resolution":"pPerform a search on the appropriate fault code.p","poleLogicSolution":true,"components":[{"value":"string","failureId":"string"}]}],"verCompoundSolutions":[{"solutionNumber":"K74452217","solutionTitle":"Fault Code 122 triggered by another fault code","coreIssue":"There are some instances when a fault code is recorded, but is strongnotstrong the first fault code that should be diagnosed.  br ","modificationDate":"01022016","status":"success","verification":"strongConditionsstrong ulliTurn keyswitch ON.liliConnect INSITE electronic service tool.liulstrongActionstrongbr Check for active fault codes. ulliUse INSITE electronic service tool to read the fault codes.liulstrongSpecificationstrong ulliIf Fault Code 227, 352, or 386 is active, then perform a search on the appropriate fault and troubleshoot that fault prior to troubleshooting Fault Code 122.liul","resolution":"pPerform a search on the appropriate fault code.p","poleLogicSolution":true,"components":[{"value":"string","failureId":"string"}]}]}';
      
        CSS_J2ASolution_EDS j2a  = CSS_J2ASolution_EDS.parse(json1);
        //CSS_J2ASolution_EDS j2a = new CSS_J2ASolution_EDS();
        system.debug('=======j2a'+j2a);
        j2a.Components[0].failureId = '123';
        j2a.Components[0].value = '1234';
        CSS_JobEventTemporary__c jobevent = new CSS_JobEventTemporary__c();
        jobevent.File_Name__c='CSS_JobRepairRJ';
        jobevent.Circuit_Description__c='rrrr';
        jobevent.Comp_Location__c='dfgh';
        jobevent.Effect__c='klkl';
        jobevent.Engine__c='bfr';
        jobevent.Fault_Code_Description__c = 'intake';
        jobevent.File_Name__c = 'testing';
        jobevent.FMI__c = 'htyu';
        jobevent.Lamp__c = 'nhgt';
        jobevent.Reason__c = 'yyyy';
        jobevent.Service_Model_Name__c = 'fault';
        jobevent.SPN__c = 'bfgfhhj';
        jobevent.Key__c = 'GetFailureCodesSRT';
        jobevent.Attribute3__c = 'SMNNUM;;code';
        jobevent.Reason__c = 'Reason';
        jobevent.Attribute1__c = 'Test';
        insert jobevent;
        
        CSS_RepairQsolEDS_V1.NestedSolutionsClass oWrapper1 = new CSS_RepairQsolEDS_V1.NestedSolutionsClass ();
        CSS_Solutions__c sol1 = new CSS_Solutions__c();
        sol1.Repair_Notes__c = null;
        System.AssertEquals( sol1.Repair_Notes__c,null);
        oWrapper1.solRec.Repair_Response__c='Repair performed but didnot resolve the root cause.';
        oWrapper1.solRec.Repair_Response__c='Repair Successful.';
        oWrapper1.solRec.Repair_Response__c='Repair Successful with additional parts/procedures.';
        oWrapper1.solRec.Repair_Notes__c = null;
        
        //oWrapper1.solRec.Repair_Notes__c = '';
        //System.AssertEquals( oWrapper1.solRec.Repair_Notes__c,null);
        
        CSS_Solutions__c  solDetails1 = new CSS_Solutions__c();
        solDetails1.Name = 'qwert';
        solDetails1.Repair_Response__c='Repair Successful';
        solDetails1.Service_Job__c = job.id;
        insert solDetails1;
        //system.debug('Rajesh-solDetails.Id:83-->'+solDetails.Id);
        map<string,CSS_Solutions__c>  kIdSolutionMap = new map<string,CSS_Solutions__c>();
        
        CSS_J2ASolution_EDS.Components j2as = new CSS_J2ASolution_EDS.Components();        
        CSS_Solution_Component__c solcomp12  = new CSS_Solution_Component__c();
        csc.Component_Id__c = j2as.failureId;
        csc.Name =  j2as.value;
        csc.Solutions__c = solRec.ID;
        csc.Service_Job__c = job.ID;
        oWrapper1.solRec.Name = j2a.solutionNumber;
        oWrapper1.solRec.Solution_Title__c = j2a.solutionTitle;
        oWrapper1.solRec.CSS_Nested_Solutions__c =  solDetails1.Id;
        oWrapper1.solRec.Service_Job__c = job.id;
        oWrapper1.solRec.FaultCode__c = solDetails1.FaultCode__c;
        extsymRep.selectedSol = solRec;
        extsymRep.selectedNestSol = oWrapper1;
        /**/
        extsymRep.rank ='0';
        extsymRep.solDetFailed=false;
        extsymRep.rank1 ='0';
        extsymRep.rankFromTs1='0';
        extsymRep.rankFromTs='0';
        extsymRep.display = true;
        extsymRep.selectedFaulcode = '123';
        extsymRep.sKNumber = '1212';
        extsymRep.solErrorMsg = 'asdasdasd';
        extsymRep.recFaultCode = new List<CSS_Fault_Code__c>();
        
        extsymRep.workGroup ='sasd';
        extsymRep.serviceJob = job;
        extsymRep.selSolution = 'Repair Successful.';
        
        extsymRep.selectedValue='wqeqwe';
        extsymRep.selectedValue1='wqeqwe';
        extsymRep.textEntered='wqeqwe';
        extsymRep.nestSolComp = csc;
        extsymRep.getSRTComponentOnLoad();
       /* CSS_Job_Order__c jo = new CSS_Job_Order__c();
        jo.id = job.id;
        jo.Status__c = 'Triage & Diagnosis/Repair';
        jo.Previous_Status__c = 'Triage & Diagnosis/Repair';
        update jo;  */  
        
        extsymRep.getSolutionDetails();
        extsymRep.faultCodeClick();        
       //extsymRep.UpdateNestSolNotes();
        
        extsymRep.prevSolution();
        extsymRep.nextSolution();
        extsymRep.validateResponse();
        
        extsymRep.returnToRepairView();
        
        extsymRep.returnToFCView();
        //extsymRep.updateFeedBackForNestSol();
        //extsymRep.UpdateSolNotes();
        
        extsymRep.actionMethodOf();
        extsymRep.updateFeedBackForSol();
        extsymRep.updateSol(sol.id,sol.Repair_Response__c,sol.Repair_notes__c);
        
        extsymRep.getSelNestSolution();
        extsymRep.getNestSolutionsList();
          // CSS_QsolEdsController.parentId= String.ValueOf(csc.Id);
       extsymRep.getPartsList();  
          //extsymRep.parentCheckBoxLogic();
         // extsymRep.childCheckBoxLogic();
          //extsymRep.partssave();
          extsymRep.getreplacementReasonOptions(); 
        //teste cover 
        string json = '{"key":"1234","message":"This is a test","messageArg":["a","b"],"solutionNumber":"K74452217","solutionTitle":"Fault Code 122 triggered by another fault code","coreIssue":"There are some instances when a fault code is recorded, but is strongnotstrong the first fault code that should be diagnosed.  br ","modificationDate":"01022016","status":"success","verification":"strongConditionsstrong ulliTurn keyswitch ON.liliConnect INSITE electronic service tool.liulstrongActionstrongbr Check for active fault codes. ulliUse INSITE electronic service tool to read the fault codes.liulstrongSpecificationstrong ulliIf Fault Code 227, 352, or 386 is active, then perform a search on the appropriate fault and troubleshoot that fault prior to troubleshooting Fault Code 122.liul","resolution":"pPerform a search on the appropriate fault code.p","poleLogicSolution":true,"components":[{"value":"string","failureId":"string"}],"repCompoundSolutions":[{"solutionNumber":"K74452217","solutionTitle":"Fault Code 122 triggered by another fault code","coreIssue":"There are some instances when a fault code is recorded, but is strongnotstrong the first fault code that should be diagnosed.  br ","modificationDate":"01022016","status":"success","verification":"strongConditionsstrong ulliTurn keyswitch ON.liliConnect INSITE electronic service tool.liulstrongActionstrongbr Check for active fault codes. ulliUse INSITE electronic service tool to read the fault codes.liulstrongSpecificationstrong ulliIf Fault Code 227, 352, or 386 is active, then perform a search on the appropriate fault and troubleshoot that fault prior to troubleshooting Fault Code 122.liul","resolution":"pPerform a search on the appropriate fault code.p","poleLogicSolution":true,"components":[{"value":"string","failureId":"string"}]}],"verCompoundSolutions":[{"solutionNumber":"K74452217","solutionTitle":"Fault Code 122 triggered by another fault code","coreIssue":"There are some instances when a fault code is recorded, but is strongnotstrong the first fault code that should be diagnosed.  br ","modificationDate":"01022016","status":"success","verification":"strongConditionsstrong ulliTurn keyswitch ON.liliConnect INSITE electronic service tool.liulstrongActionstrongbr Check for active fault codes. ulliUse INSITE electronic service tool to read the fault codes.liulstrongSpecificationstrong ulliIf Fault Code 227, 352, or 386 is active, then perform a search on the appropriate fault and troubleshoot that fault prior to troubleshooting Fault Code 122.liul","resolution":"pPerform a search on the appropriate fault code.p","poleLogicSolution":true,"components":[{"value":"string","failureId":"string"}]}]}';
        CSS_J2ASolution_EDS r = CSS_J2ASolution_EDS.parse(json);
        //test cover end
        extsymRep.addsolcomponents(sol,r);
        extsymRep.navigateToRepair();
        //boolean b = true;
        //b= extsymRep.validatenestResponse();
        // extsymRep.addsolcomponents(extsymRep.selectedsol, extsymRep.soldet );
        extsymRep.srtAccesscheckList();
        extsymRep.getRefreshSols();
       
        Test.setMock(WebServiceMock.class, new CSS_GetWarrantyDocs_Test());
        
        extsymRep.accountlang = accLang;
        // Test.stopTest();
        test.startTest();
        extsymRep.UpdateSolNotes();
        extsymRep.getQSOLDocs();
        extsymRep.reportProblemComments();
        extsymrep.refreshPartsList();
       // extsymrep.UpdateNestSolNotes();
        string selSolution = 'test';
        //extsymRep.UpdateNestSolNotes();
        //extsymRep.validatenestResponse();
        list<String> childIds = new list<String>();
        childIds.add('test');
        list<CSS_RepairQsolEDS_V1.srtCompWrapper> srt123 = new list<CSS_RepairQsolEDS_V1.srtCompWrapper>();
        //insert childIds;
      // list<partwrap> lstpartwrap = new list<partwrap>();
        /*extsymRep.srtPartWrapper wrap = new extsymRep.srtPartWrapper();
        wrap.partIds = job.Id; 
        wrap.partname = 'comp';
        lstpartwrap.add(wrap);
        insert lstpartwrap;*/
        CSS_RepairQsolEDS_V1.srtPartWrapper partwrap = new CSS_RepairQsolEDS_V1.srtPartWrapper(job.Id,job.Id,false,'part',5,6,'not-working');
        CSS_RepairQsolEDS_V1.solWrapper solwrap =  new CSS_RepairQsolEDS_V1.solWrapper('test','3213','testcomments','dsid');
        //CSS_RepairQsolEDS_V1.srtCompWrapper compwrap = new CSS_RepairQsolEDS_V1.srtCompWrapper(job.id,true,'comp',childIds,srt123,'fc','sc','cc','ac');
        test.stopTest();
        
        
        
    }
    
    
    static testMethod void MyWrapperTestMethod() {
        
        CSS_RepairQsolEDS_V1.NestedSolutionsClass oWrapper = new CSS_RepairQsolEDS_V1.NestedSolutionsClass ();
        
        
    }
    static testmethod void qsolredirect()
    {
        css_repair_job  cssRep = new css_repair_job();
        CSS_RepairQsolEDS_V1 edsSym1 = new CSS_RepairQsolEDS_V1(cssRep);
        CSS_JobEventTemporary__c qsolRetrivedFCMaster = new CSS_JobEventTemporary__c();
        qsolRetrivedFCMaster = CSS_TestData.createJobEventTempObj(true);
        edsSym1.qsolRetrivedFCMaster = qsolRetrivedFCMaster;
        PageReference pageRef;  
        pageRef = edsSym1.qsolredirect();
        
    }
    /*static testMethod void prevStatus(){
        CSS_Job_Order__c job= new CSS_Job_Order__c();
        job.esn__c='12345';
        job.INSITE_UpdateTimeStamp__c =system.today();
        job.INSITE_ESN_Choice__c='Not Selected';
        job.DSID__c='2323';
        job.ESN__c ='21323';
        job.Application__c='asdd';
        job.Unit_Number__c='213';
        job.Failure_Point__c=213.00;
        job.Failure_Point_Measure__c='asd';
        job.Make__c='Make';
        job.Model__c='Model';
        job.Equipment_ID__c='Equip';
        job.Customer_Name__c='Peterbuilt';
        job.Shop_Work_Order__c='213dssd';
        job.Service_Model__c='SMNNUM';
        job.DSID_Creation_Timestamp__c=system.today();
        job.DSID_Status__c='Stat';
        job.DSID_WorkGroup__c='Wrkgrp';
        job.Status__c = 'Triage & Diagnosis' ;
        job.Previous_Status__c = 'Triage & Diagnosis/Repair' ;
        
        insert job;
        
        job.Status__c = 'Triage & Diagnosis/Repair';
        job.Previous_Status__c = 'Triage & Diagnosis';
        update job;
        PageReference pageRef = new PageReference('/apex/JobTndTs?id=');
        test.setCurrentPage(pageRef);
        pageRef.getParameters().put('id',job.id);
        css_repair_job  cssRep = new css_repair_job();
        CSS_RepairQsolEDS_V1 edsSym1 = new CSS_RepairQsolEDS_V1(cssRep);
        PageReference pageRefer;  
        pageRefer =edsSym1.returnToFCView();
        string json = '{"key":"1234","message":"This is a test","messageArg":["a","b"],"solutionNumber":"K74452217","solutionTitle":"Fault Code 122 triggered by another fault code","coreIssue":"There are some instances when a fault code is recorded, but is strongnotstrong the first fault code that should be diagnosed.  br ","modificationDate":"01022016","status":"success","verification":"strongConditionsstrong ulliTurn keyswitch ON.liliConnect INSITE electronic service tool.liulstrongActionstrongbr Check for active fault codes. ulliUse INSITE electronic service tool to read the fault codes.liulstrongSpecificationstrong ulliIf Fault Code 227, 352, or 386 is active, then perform a search on the appropriate fault and troubleshoot that fault prior to troubleshooting Fault Code 122.liul","resolution":"pPerform a search on the appropriate fault code.p","poleLogicSolution":true,"components":[{"value":"string","failureId":"string"}],"repCompoundSolutions":[{"solutionNumber":"K74452217","solutionTitle":"Fault Code 122 triggered by another fault code","coreIssue":"There are some instances when a fault code is recorded, but is strongnotstrong the first fault code that should be diagnosed.  br ","modificationDate":"01022016","status":"success","verification":"strongConditionsstrong ulliTurn keyswitch ON.liliConnect INSITE electronic service tool.liulstrongActionstrongbr Check for active fault codes. ulliUse INSITE electronic service tool to read the fault codes.liulstrongSpecificationstrong ulliIf Fault Code 227, 352, or 386 is active, then perform a search on the appropriate fault and troubleshoot that fault prior to troubleshooting Fault Code 122.liul","resolution":"pPerform a search on the appropriate fault code.p","poleLogicSolution":true,"components":[{"value":"string","failureId":"string"}]}],"verCompoundSolutions":[{"solutionNumber":"K74452217","solutionTitle":"Fault Code 122 triggered by another fault code","coreIssue":"There are some instances when a fault code is recorded, but is strongnotstrong the first fault code that should be diagnosed.  br ","modificationDate":"01022016","status":"success","verification":"strongConditionsstrong ulliTurn keyswitch ON.liliConnect INSITE electronic service tool.liulstrongActionstrongbr Check for active fault codes. ulliUse INSITE electronic service tool to read the fault codes.liulstrongSpecificationstrong ulliIf Fault Code 227, 352, or 386 is active, then perform a search on the appropriate fault and troubleshoot that fault prior to troubleshooting Fault Code 122.liul","resolution":"pPerform a search on the appropriate fault code.p","poleLogicSolution":true,"components":[{"value":"string","failureId":"string"}]}]}';
        CSS_J2ANestSol_EDS r = CSS_J2ANestSol_EDS.parse(json);
        edsSym1.solDet1 = r;
    }*/
    @isTest static void testGetSolutionDetails(){
        Test.setMock(HttpCalloutMock.class, new CSS_GetSolDetails_Test());
        string caseNum = 'K21484443';
        string dsid = 'DSBDT4780';
        CSS_EDSAuthentication.getSolutionDetails(caseNum,dsid,'en',0,'O');        
    }
   
    static testmethod void testmethod4()
    {
        css_repair_job rv = new css_repair_job();
      CSS_RepairQsolEDS_V1 Rv1 = new CSS_RepairQsolEDS_V1(rv);
      system.assert(Rv1.remCharcounterNest==null);
      system.assert(RV1.nestedListsrtCompWrapper==NULL);
       system.assert(Rv1.partdispjbp ==null);
        system.assert(RV1.selectedDiagRespNested==NULL);
        System.assert(Rv1.selectedNestSolTitle1==null);
        System.assert(Rv1.solDet1==null);
    }
    static testMethod void CSS_RepairQsolEDS_V1_Test_Method6(){
                   Account acc = new Account();
            acc.name='Kenworth Sales Co';
            acc.CSS_DistributorCode__c='02466';
            acc.IAM_Service_Provider_Code__c='19134';
            acc.Type='Dealer Account';
            acc.CMI_Account_Status__c = 'Active';
            insert acc;

        
        
        decimal diatime = 0.23;
        String sDTime1 ='2';
        String JSONSols  = '[ ';
        String sStat = '0';
        String sSuffix = '';
        Integer iCounter = 0;
        Boolean blnActive = false;
        
        boolean failDiagResp =false;        
        
        CSS_Job_Order__c job= new CSS_Job_Order__c();
      
        job.Status__c = 'Intake';
        job.Account__c=acc.Id;
        job.INSITE_UpdateTimeStamp__c =system.today();
        job.INSITE_ESN_Choice__c='Not Selected';
        job.Qsol_Engine_Family_Code__c = 'code';
        job.Warranty_Start_Date__c = date.today();
        job.CSS_Job_Location_Code__c = 'location';
        job.ApplicationCode__c = 'code';
        
        job.DSID__c='2323';
        job.ESN__c ='21323';
        job.Application__c='asdd';
        job.Unit_Number__c='213';
        job.Failure_Point__c=213.00;
        job.Failure_Point_Measure__c='asd';
        job.Make__c='Make';
        job.ESN_Insite__c = 'insite';
        job.Model__c='Model';
        job.Equipment_ID__c='Equip';
        job.Customer_Name__c='Peterbuilt';
        job.Shop_Work_Order__c='213dssd';
        job.Service_Model__c='SMNNUM';
        job.DSID_Creation_Timestamp__c=system.today();
        job.DSID_Status__c='Stat';
        job.DSID_WorkGroup__c='Wrkgrp';
        job.Status__c = 'Triage & Diagnosis Complete' ;
        job.Previous_Status__c = 'Triage & Diagnosis' ;
        job.Failure_Date__c = date.today();
        
        insert job;        
        
        CSS_Fault_Code__c faulCodeRec = new CSS_Fault_Code__c(Name='3478',Related_Fault_Code__c='98734,95869',isPole__c = true);
        insert faulCodeRec;
     
        CSS_Solutions__c sol=new CSS_Solutions__c();
        
        sol.Case_Name__c='test';
        sol.Name='test';
        sol.FaultCode__c = faulCodeRec.id;
        sol.Diagnostic_Response__c='test';
        sol.Repair_Response__c='test';
        sol.Service_Job__c=job.id;
        sol.CSS_Nested_Solutions__c = sol.id;
        sol.rank__c=0;
        sol.Out_Of_Order__c = false;
        sol.Solution_Title__c = 'test';
        sol.Solution__c ='test';
        sol.Report_Comments__c ='qwewqewqewewqe';
        sol.Diagnostic_notes__c ='asdsadad';
        
        insert sol;


        
        
       List<CSS_Solution_Component__c>solcomp1 = new List<CSS_Solution_Component__c>();
        
         CSS_Solution_Component__c csc=new CSS_Solution_Component__c();
        csc.Action__c='test';
        csc.Component_Id__c = 'compid';
        csc.System_Code__c = 'syst';
        csc.Component_Code__c = 'compcode';
        csc.AccountCode__c = 'acccode';
        csc.Solutions__c=sol.id;
        csc.Service_Job__c=job.id;
        csc.Selected_Component__c=true;
        insert csc;
 
        
        CSS_Solution_Component__c csc1=new CSS_Solution_Component__c();
        csc1.Action__c='test';
         csc1.Solutions__c=sol.id;
        csc1.Service_Job__c=job.id;
        csc1.Selected_Component__c=false;
       //insert csc1;
      solcomp1.add(csc1);
        insert solcomp1;
        
           Id recTypeIdpart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'Parts');
        
       
        
        CSS_Parts_Options__c parts = new CSS_Parts_Options__c();
        parts.recordtypeId = recTypeIdpart;
        parts.Option_Number__c = 'O-111';
        parts.Option_ESN__c = 'esnnnstring';
        parts.selected_part__c = true;
        parts.FailureName__c = 'fname';
        parts.Assignment__c = 'Replaced';
        parts.Notes__c = 'partsoptionnotes';
        parts.OEM__c = 'oem';
        parts.Part_Description__c = 'descrtttt';
        parts.Part_Name__c = 'nameee';
        parts.part_size__c = '8';
        parts.Quantity__c = 5;
        parts.Service_partnumber__c = 'number';
        parts.Replacement_Reason__c = 'Campaign-TRP-ATC';
        parts.Service_Job__c = job.id;
        parts.FailurepartId__c = csc.Id;
        parts.Part_Assignment__c = 'Primary';
        parts.Solutions__c=sol.id;
        insert parts;
        
        CSS_Parts_Options__c parts1 = new CSS_Parts_Options__c();
        parts1.recordtypeId = recTypeIdpart;
        parts1.Option_Number__c = 'O-111';
        parts1.Option_ESN__c = 'esnnnstring';
        parts1.selected_part__c = true;
        parts1.FailureName__c = 'fname';
        parts1.Assignment__c = 'Replaced';
        parts1.Notes__c = 'partsoptionnotes';
        parts1.OEM__c = 'oem';
        parts1.Part_Description__c = 'descrtttt';
        parts1.Part_Name__c = 'nameee';
        parts1.part_size__c = '8';
        parts1.Quantity__c = 5;
        parts1.Service_partnumber__c = 'number';
        parts1.Replacement_Reason__c = 'Select One';
        parts1.Service_Job__c = job.id;
        parts1.FailurepartId__c = csc.Id;
        parts1.Part_Assignment__c = 'Primary';
        parts1.Solutions__c=sol.id;
        insert parts1;
        
       
        
        CSS_SRT__c srt=new CSS_SRT__c();
        srt.Solution_Number__c=sol.id;
        srt.Job_Order__c=job.id;
        srt.Type__c = 'Diagnosis';
        srt.SRT_Time__c=0.6;
        //srt.Diagnosis_Time__c=0.6;
        insert srt;
        
        CSS_SRT__c srtRep=new CSS_SRT__c();
        srt.Solution_Number__c=sol.id;
        srt.Job_Order__c=job.id;
        srt.Type__c = 'Repair';
        srt.SRT_Time__c=0.6;
        insert srtRep;
        
        List<CSS_SymptomQA__c> symList=new List<CSS_SymptomQA__c>();
        List<CSS_SymptomQA__c> symList1=new List<CSS_SymptomQA__c>();
        List<CSS_Solutions__c> solList=new List<CSS_Solutions__c>();
        
        
        List<CSS_Solution_Component__c> solComp  = new List<CSS_Solution_Component__c>();
        List<CSS_SRT__c> srts = new List<CSS_SRT__c>();
        List<CSS_SRT__c> srtsRep = new List<CSS_SRT__c>();
        
        
        solList.add(sol);
        
        solComp.add(csc);
        srts.add(srt) ;  
        srtsRep.add(srtRep);
        
        list<CSS_Solutions__c> solutionList = new list<CSS_Solutions__c>();
        CSS_Solutions__c solRec = new CSS_Solutions__c(Name='Solution1',Solution_Title__c='Title1',rank__c=1,Out_Of_Order__c = false,        
        Solution__c ='test',Report_Comments__c ='qwewqewqewewqe',Diagnostic_notes__c ='asdsadad',
                                                       Repair_Notes__c='Notes1',Repair_Response__c='response1',Service_Job__c=job.id,
                                                      FaultCode__c=faulCodeRec.Id);
        
        insert solRec; 
        
       // solutionList.add(solRec);
        CSS_Solutions__c solRec1 = new CSS_Solutions__c(Name='Solution2',Rank__c=1,Solution_Title__c='Title2',
                                                        Repair_Notes__c='Notes2',Repair_Response__c='response2',Service_Job__c=job.id,
                                                        FaultCode__c=faulCodeRec.Id);
        
        solutionList.add(solRec1);
        insert solutionList;
        
          CSS_EDSAuthentication.getSolutionDetails(sol.id,job.DSID__c,'en',0,'O'); 
        
        PageReference pageRef = new PageReference('/apex/JobTndTs?id=');
        test.setCurrentPage(pageRef);
        ApexPages.CurrentPage().getParameters().put('fcid',faulCodeRec.Id);
        pageRef.getParameters().put('id',job.id);
        
        pageref.getParameters().put('rank','1');
        
        css_repair_job  cssRep = new css_repair_job();
        CSS_RepairQsolEDS_V1 extsymRep = new CSS_RepairQsolEDS_V1(cssRep);
        extsymRep.comp = solcomp1;
        extsymRep.Components = solcomp1;
        // CSS_Solutions__c  solRec ;
        CSS_Solutions__c  solDetails;
        CSS_Solution_Component__c Components;
        CSS_accountLanguage__c accLang= CSS_TestData.createAccountLanguage(true);
       
        string json1 = '{"key":"1234","message":"This is a test","messageArg":["a","b"],"solutionNumber":"K74452217","solutionTitle":"Fault Code 122 triggered by another fault code","coreIssue":"There are some instances when a fault code is recorded, but is strongnotstrong the first fault code that should be diagnosed.  br ","modificationDate":"01022016","status":"success","verification":"strongConditionsstrong ulliTurn keyswitch ON.liliConnect INSITE electronic service tool.liulstrongActionstrongbr Check for active fault codes. ulliUse INSITE electronic service tool to read the fault codes.liulstrongSpecificationstrong ulliIf Fault Code 227, 352, or 386 is active, then perform a search on the appropriate fault and troubleshoot that fault prior to troubleshooting Fault Code 122.liul","resolution":"pPerform a search on the appropriate fault code.p","poleLogicSolution":true,"components":[{"value":"string","failureId":"string"}],"repCompoundSolutions":[{"solutionNumber":"K74452217","solutionTitle":"Fault Code 122 triggered by another fault code","coreIssue":"There are some instances when a fault code is recorded, but is strongnotstrong the first fault code that should be diagnosed.  br ","modificationDate":"01022016","status":"success","verification":"strongConditionsstrong ulliTurn keyswitch ON.liliConnect INSITE electronic service tool.liulstrongActionstrongbr Check for active fault codes. ulliUse INSITE electronic service tool to read the fault codes.liulstrongSpecificationstrong ulliIf Fault Code 227, 352, or 386 is active, then perform a search on the appropriate fault and troubleshoot that fault prior to troubleshooting Fault Code 122.liul","resolution":"pPerform a search on the appropriate fault code.p","poleLogicSolution":true,"components":[{"value":"string","failureId":"string"}]}],"verCompoundSolutions":[{"solutionNumber":"K74452217","solutionTitle":"Fault Code 122 triggered by another fault code","coreIssue":"There are some instances when a fault code is recorded, but is strongnotstrong the first fault code that should be diagnosed.  br ","modificationDate":"01022016","status":"success","verification":"strongConditionsstrong ulliTurn keyswitch ON.liliConnect INSITE electronic service tool.liulstrongActionstrongbr Check for active fault codes. ulliUse INSITE electronic service tool to read the fault codes.liulstrongSpecificationstrong ulliIf Fault Code 227, 352, or 386 is active, then perform a search on the appropriate fault and troubleshoot that fault prior to troubleshooting Fault Code 122.liul","resolution":"pPerform a search on the appropriate fault code.p","poleLogicSolution":true,"components":[{"value":"string","failureId":"string"}]}]}';
      
        CSS_J2ASolution_EDS j2a  = CSS_J2ASolution_EDS.parse(json1);
        //CSS_J2ASolution_EDS j2a = new CSS_J2ASolution_EDS();
        system.debug('=======j2a'+j2a);
        j2a.Components[0].failureId = '123';
        j2a.Components[0].value = '1234';
        CSS_JobEventTemporary__c jobevent = new CSS_JobEventTemporary__c();
        jobevent.File_Name__c='CSS_JobRepairRJ';
        jobevent.Circuit_Description__c='rrrr';
        jobevent.Comp_Location__c='dfgh';
        jobevent.Effect__c='klkl';
        jobevent.Engine__c='bfr';
        jobevent.Fault_Code_Description__c = 'intake';
        jobevent.Name = '3478';
        jobevent.FMI__c = 'htyu';
        jobevent.Lamp__c = 'nhgt';
        jobevent.Reason__c = 'yyyy';
        jobevent.Service_Model_Name__c = 'fault';
        jobevent.SPN__c = 'bfgfhhj';
        insert jobevent;
        
        //Inserting Nested solution data in wrapperclass
        CSS_RepairQsolEDS_V1.NestedSolutionsClass oWrapper1 = new CSS_RepairQsolEDS_V1.NestedSolutionsClass ();
        CSS_Solutions__c sol1 = new CSS_Solutions__c();
        sol1.Repair_Notes__c = null;
        System.AssertEquals( sol1.Repair_Notes__c,null);
        oWrapper1.solRec.Repair_Response__c='Repair performed but didnot resolve the root cause.';
        oWrapper1.solRec.Repair_Response__c='Repair Successful.';
        oWrapper1.solRec.Repair_Response__c='Repair Successful with additional parts/procedures.';
        oWrapper1.solRec.Repair_Notes__c = null;
        
        //Inserting Solution Detail
        CSS_Solutions__c  solDetails1 = new CSS_Solutions__c();
        solDetails1.Name = 'qwert';
        solDetails1.Repair_Response__c='TestrajesH';
        solDetails1.Service_Job__c = job.id;
        insert solDetails1;
        css_repair_job reprjob = new css_repair_job();
      CSS_RepairQsolEDS_V1 RepQsol = new CSS_RepairQsolEDS_V1(reprjob);
        RepQsol.faultCodeClick();
        RepQsol.getPartsListNestSol(sol.Id);
        string json = '{"key":"1234","message":"This is a test","messageArg":["a","b"],"solutionNumber":"K74452217","solutionTitle":"Fault Code 122 triggered by another fault code","coreIssue":"There are some instances when a fault code is recorded, but is strongnotstrong the first fault code that should be diagnosed.  br ","modificationDate":"01022016","status":"success","verification":"strongConditionsstrong ulliTurn keyswitch ON.liliConnect INSITE electronic service tool.liulstrongActionstrongbr Check for active fault codes. ulliUse INSITE electronic service tool to read the fault codes.liulstrongSpecificationstrong ulliIf Fault Code 227, 352, or 386 is active, then perform a search on the appropriate fault and troubleshoot that fault prior to troubleshooting Fault Code 122.liul","resolution":"pPerform a search on the appropriate fault code.p","poleLogicSolution":true,"components":[{"value":"string","failureId":"string"}],"repCompoundSolutions":[{"solutionNumber":"K74452217","solutionTitle":"Fault Code 122 triggered by another fault code","coreIssue":"There are some instances when a fault code is recorded, but is strongnotstrong the first fault code that should be diagnosed.  br ","modificationDate":"01022016","status":"success","verification":"strongConditionsstrong ulliTurn keyswitch ON.liliConnect INSITE electronic service tool.liulstrongActionstrongbr Check for active fault codes. ulliUse INSITE electronic service tool to read the fault codes.liulstrongSpecificationstrong ulliIf Fault Code 227, 352, or 386 is active, then perform a search on the appropriate fault and troubleshoot that fault prior to troubleshooting Fault Code 122.liul","resolution":"pPerform a search on the appropriate fault code.p","poleLogicSolution":true,"components":[{"value":"string","failureId":"string"}]}],"verCompoundSolutions":[{"solutionNumber":"K74452217","solutionTitle":"Fault Code 122 triggered by another fault code","coreIssue":"There are some instances when a fault code is recorded, but is strongnotstrong the first fault code that should be diagnosed.  br ","modificationDate":"01022016","status":"success","verification":"strongConditionsstrong ulliTurn keyswitch ON.liliConnect INSITE electronic service tool.liulstrongActionstrongbr Check for active fault codes. ulliUse INSITE electronic service tool to read the fault codes.liulstrongSpecificationstrong ulliIf Fault Code 227, 352, or 386 is active, then perform a search on the appropriate fault and troubleshoot that fault prior to troubleshooting Fault Code 122.liul","resolution":"pPerform a search on the appropriate fault code.p","poleLogicSolution":true,"components":[{"value":"string","failureId":"string"}]}]}';
        CSS_J2ASolution_EDS sDet = CSS_J2ASolution_EDS.parse(json);
        RepQsol.addSolComponents(solDetails1, sDet);
         string sh = '{"key":"1234","message":"This is a test","messageArg":["a","b"],"solutionNumber":"K74452217","solutionTitle":"Fault Code 122 triggered by another fault code","coreIssue":"There are some instances when a fault code is recorded, but is strongnotstrong the first fault code that should be diagnosed.  br ","modificationDate":"01022016","status":"success","verification":"strongConditionsstrong ulliTurn keyswitch ON.liliConnect INSITE electronic service tool.liulstrongActionstrongbr Check for active fault codes. ulliUse INSITE electronic service tool to read the fault codes.liulstrongSpecificationstrong ulliIf Fault Code 227, 352, or 386 is active, then perform a search on the appropriate fault and troubleshoot that fault prior to troubleshooting Fault Code 122.liul","resolution":"pPerform a search on the appropriate fault code.p","poleLogicSolution":true,"components":[{"value":"string","failureId":"string"}],"repCompoundSolutions":[{"solutionNumber":"K74452217","solutionTitle":"Fault Code 122 triggered by another fault code","coreIssue":"There are some instances when a fault code is recorded, but is strongnotstrong the first fault code that should be diagnosed.  br ","modificationDate":"01022016","status":"success","verification":"strongConditionsstrong ulliTurn keyswitch ON.liliConnect INSITE electronic service tool.liulstrongActionstrongbr Check for active fault codes. ulliUse INSITE electronic service tool to read the fault codes.liulstrongSpecificationstrong ulliIf Fault Code 227, 352, or 386 is active, then perform a search on the appropriate fault and troubleshoot that fault prior to troubleshooting Fault Code 122.liul","resolution":"pPerform a search on the appropriate fault code.p","poleLogicSolution":true,"components":[{"value":"string","failureId":"string"}]}],"verCompoundSolutions":[{"solutionNumber":"K74452217","solutionTitle":"Fault Code 122 triggered by another fault code","coreIssue":"There are some instances when a fault code is recorded, but is strongnotstrong the first fault code that should be diagnosed.  br ","modificationDate":"01022016","status":"success","verification":"strongConditionsstrong ulliTurn keyswitch ON.liliConnect INSITE electronic service tool.liulstrongActionstrongbr Check for active fault codes. ulliUse INSITE electronic service tool to read the fault codes.liulstrongSpecificationstrong ulliIf Fault Code 227, 352, or 386 is active, then perform a search on the appropriate fault and troubleshoot that fault prior to troubleshooting Fault Code 122.liul","resolution":"pPerform a search on the appropriate fault code.p","poleLogicSolution":true,"components":[{"value":"stringLKFKJDFLKDJFLKADJFLKDJAFFHAKLJNADSJKKDFHAJKLFAKDJFHAJKDFHAJKSDFDSMNFJAKDFHADSJKFNADKJFHAJKDFHADFNADSBHDBSDHFLJKFHAKDJFHKJDHFAJKFHADJKFNADKJFHADJKFHDJKFHDASJKFHADFNDFDKJFHADJKLFHALDKJFHLADJKFHLADKJFHLADKFDJKNBDHFLKADJFHAKLDJFHALDKJFHLADKJFDKJFHADLKJFHLADKJFHADJFNDFDKJFHDKLJFDLFHDLKJFNADFBDHFLKJAFLDJKFNKDLFNNDBVLNLAKJFAHLDKJFADLFBNDBNVBAKLJFLDNNDBGNDBGND VNBFKDFBDNFDMFBNDBFDNFMDBDJFKLDJFDFNNDMFBFJKDFKDJ JFHJKDFHJKDFHKDJ  HF DHKJHFHQ  JHJKFH  H FADF JH  FJHL JH Lhlfjh  djh hfjkh  jhf  ljafldfufpf fuifh oeiufl fuhufileflfleufhfhfj d ufh dfhdfjahdkfah iuhef e","failureId":"string"}]}]}';
        CSS_J2ASolution_EDS sDet1 = CSS_J2ASolution_EDS.parse(sh);
        RepQsol.addSolComponents(solDetails1, sDet1);
        RepQsol.prevSolution();
    }
    static testMethod void CSS_RepairQsolEDS_V1_Test_Method7(){
                   Account acc = new Account();
            acc.name='Kenworth Sales Co';
            acc.CSS_DistributorCode__c='02466';
            acc.IAM_Service_Provider_Code__c='19134';
            acc.Type='Dealer Account';
            acc.CMI_Account_Status__c = 'Active';
            insert acc;

        
        decimal diatime = 0.23;
        String sDTime1 ='2';
        String JSONSols  = '[ ';
        String sStat = '0';
        String sSuffix = '';
        Integer iCounter = 0;
        Boolean blnActive = false;
        
        boolean failDiagResp =false;        
        
        CSS_Job_Order__c job= new CSS_Job_Order__c();
      
        job.Status__c = 'Intake';
        job.Account__c=acc.Id;
        job.INSITE_UpdateTimeStamp__c =system.today();
        job.INSITE_ESN_Choice__c='Not Selected';
        job.Qsol_Engine_Family_Code__c = 'code';
        job.Warranty_Start_Date__c = date.today();
        job.CSS_Job_Location_Code__c = 'location';
        job.ApplicationCode__c = 'code';
        
        job.DSID__c='2323';
        job.ESN__c ='21323';
        job.Application__c='asdd';
        job.Unit_Number__c='213';
        job.Failure_Point__c=213.00;
        job.Failure_Point_Measure__c='asd';
        job.Make__c='Make';
        job.ESN_Insite__c = 'insite';
        job.Model__c='Model';
        job.Equipment_ID__c='Equip';
        job.Customer_Name__c='Peterbuilt';
        job.Shop_Work_Order__c='213dssd';
        job.Service_Model__c='SMNNUM';
        job.DSID_Creation_Timestamp__c=system.today();
        job.DSID_Status__c='Stat';
        job.DSID_WorkGroup__c='Wrkgrp';
        job.Status__c = 'Triage & Diagnosis/Repair' ;
        job.Previous_Status__c = 'Triage & Diagnosis' ;
        job.Failure_Date__c = date.today();
        
        insert job;        
        
        CSS_Fault_Code__c faulCodeRec = new CSS_Fault_Code__c(Name='3478',Related_Fault_Code__c='98734,95869',isPole__c = true);
        insert faulCodeRec;
     
        CSS_Solutions__c sol=new CSS_Solutions__c();
        
        sol.Case_Name__c='test';
        sol.Name='test';
        sol.FaultCode__c = faulCodeRec.id;
        sol.Diagnostic_Response__c='test';
        sol.Repair_Response__c='test';
        sol.Service_Job__c=job.id;
        sol.CSS_Nested_Solutions__c = sol.id;
        sol.rank__c=0;
        sol.Out_Of_Order__c = false;
        sol.Solution_Title__c = 'test';
        sol.Solution__c ='test';
        sol.Report_Comments__c ='qwewqewqewewqe';
        sol.Diagnostic_notes__c ='asdsadad';
        
        insert sol;


        
        
       List<CSS_Solution_Component__c>solcomp1 = new List<CSS_Solution_Component__c>();
        
         CSS_Solution_Component__c csc=new CSS_Solution_Component__c();
        csc.Action__c='test';
        csc.Component_Id__c = 'compid';
        csc.System_Code__c = 'syst';
        csc.Component_Code__c = 'compcode';
        csc.AccountCode__c = 'acccode';
        csc.Solutions__c=sol.id;
        csc.Service_Job__c=job.id;
        csc.Selected_Component__c=true;
        insert csc;
 
        
        CSS_Solution_Component__c csc1=new CSS_Solution_Component__c();
        csc1.Action__c='test';
         csc1.Solutions__c=sol.id;
        csc1.Service_Job__c=job.id;
        csc1.Selected_Component__c=false;
       //insert csc1;
      solcomp1.add(csc1);
        insert solcomp1;
        
           Id recTypeIdpart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'Parts');
        
       
        
        CSS_Parts_Options__c parts = new CSS_Parts_Options__c();
        parts.recordtypeId = recTypeIdpart;
        parts.Option_Number__c = 'O-111';
        parts.Option_ESN__c = 'esnnnstring';
        parts.selected_part__c = true;
        parts.FailureName__c = 'fname';
        parts.Assignment__c = 'Replaced';
        parts.Notes__c = 'partsoptionnotes';
        parts.OEM__c = 'oem';
        parts.Part_Description__c = 'descrtttt';
        parts.Part_Name__c = 'nameee';
        parts.part_size__c = '8';
        parts.Quantity__c = 5;
        parts.Service_partnumber__c = 'number';
        parts.Replacement_Reason__c = 'Campaign-TRP-ATC';
        parts.Service_Job__c = job.id;
        parts.FailurepartId__c = csc.Id;
        parts.Part_Assignment__c = 'Primary';
        parts.Solutions__c=sol.id;
        insert parts;
        
       
        
        CSS_SRT__c srt=new CSS_SRT__c();
        srt.Solution_Number__c=sol.id;
        srt.Job_Order__c=job.id;
        srt.Type__c = 'Diagnosis';
        srt.SRT_Time__c=0.6;
        //srt.Diagnosis_Time__c=0.6;
        insert srt;
        
        CSS_SRT__c srtRep=new CSS_SRT__c();
        srt.Solution_Number__c=sol.id;
        srt.Job_Order__c=job.id;
        srt.Type__c = 'Repair';
        srt.SRT_Time__c=0.6;
        insert srtRep;
        
        List<CSS_SymptomQA__c> symList=new List<CSS_SymptomQA__c>();
        List<CSS_SymptomQA__c> symList1=new List<CSS_SymptomQA__c>();
        List<CSS_Solutions__c> solList=new List<CSS_Solutions__c>();
        
        
        List<CSS_Solution_Component__c> solComp  = new List<CSS_Solution_Component__c>();
        List<CSS_SRT__c> srts = new List<CSS_SRT__c>();
        List<CSS_SRT__c> srtsRep = new List<CSS_SRT__c>();
        
        
        solList.add(sol);
        
        solComp.add(csc);
        srts.add(srt) ;  
        srtsRep.add(srtRep);
        
        list<CSS_Solutions__c> solutionList = new list<CSS_Solutions__c>();
        CSS_Solutions__c solRec = new CSS_Solutions__c(Name='Solution1',Solution_Title__c='Title1',rank__c=1,Out_Of_Order__c = false,        
        Solution__c ='test',Report_Comments__c ='qwewqewqewewqe',Diagnostic_notes__c ='asdsadad',
                                                       Repair_Notes__c='',Repair_Response__c='Repair Successful.',Service_Job__c=job.id,
                                                      FaultCode__c=faulCodeRec.Id);
        
        insert solRec; 
        
       // solutionList.add(solRec);
        CSS_Solutions__c solRec1 = new CSS_Solutions__c(Name='Solution2',Rank__c=1,Solution_Title__c='Title2',
                                                        Repair_Notes__c='Notes2',Repair_Response__c='',Service_Job__c=job.id,
                                                        FaultCode__c=faulCodeRec.Id);
        
        solutionList.add(solRec1);
        insert solutionList;
        
          CSS_EDSAuthentication.getSolutionDetails(sol.id,job.DSID__c,'en',0,'O'); 
        
        PageReference pageRef = new PageReference('/apex/JobTndTs?id=');
        test.setCurrentPage(pageRef);
        ApexPages.CurrentPage().getParameters().put('fcid',faulCodeRec.Id);
        pageRef.getParameters().put('id',job.id);
        
        pageref.getParameters().put('rank','1');
        
        css_repair_job  cssRep = new css_repair_job();
        CSS_RepairQsolEDS_V1 extsymRep = new CSS_RepairQsolEDS_V1(cssRep);
        extsymRep.comp = solcomp1;
        extsymRep.Components = solcomp1;
        // CSS_Solutions__c  solRec ;
        CSS_Solutions__c  solDetails;
        CSS_Solution_Component__c Components;
        CSS_accountLanguage__c accLang= CSS_TestData.createAccountLanguage(true);
       
        string json1 = '{"key":"1234","message":"This is a test","messageArg":["a","b"],"solutionNumber":"K74452217","solutionTitle":"Fault Code 122 triggered by another fault code","coreIssue":"There are some instances when a fault code is recorded, but is strongnotstrong the first fault code that should be diagnosed.  br ","modificationDate":"01022016","status":"success","verification":"strongConditionsstrong ulliTurn keyswitch ON.liliConnect INSITE electronic service tool.liulstrongActionstrongbr Check for active fault codes. ulliUse INSITE electronic service tool to read the fault codes.liulstrongSpecificationstrong ulliIf Fault Code 227, 352, or 386 is active, then perform a search on the appropriate fault and troubleshoot that fault prior to troubleshooting Fault Code 122.liul","resolution":"pPerform a search on the appropriate fault code.p","poleLogicSolution":true,"components":[{"value":"string","failureId":"string"}],"repCompoundSolutions":[{"solutionNumber":"K74452217","solutionTitle":"Fault Code 122 triggered by another fault code","coreIssue":"There are some instances when a fault code is recorded, but is strongnotstrong the first fault code that should be diagnosed.  br ","modificationDate":"01022016","status":"success","verification":"strongConditionsstrong ulliTurn keyswitch ON.liliConnect INSITE electronic service tool.liulstrongActionstrongbr Check for active fault codes. ulliUse INSITE electronic service tool to read the fault codes.liulstrongSpecificationstrong ulliIf Fault Code 227, 352, or 386 is active, then perform a search on the appropriate fault and troubleshoot that fault prior to troubleshooting Fault Code 122.liul","resolution":"pPerform a search on the appropriate fault code.p","poleLogicSolution":true,"components":[{"value":"string","failureId":"string"}]}],"verCompoundSolutions":[{"solutionNumber":"K74452217","solutionTitle":"Fault Code 122 triggered by another fault code","coreIssue":"There are some instances when a fault code is recorded, but is strongnotstrong the first fault code that should be diagnosed.  br ","modificationDate":"01022016","status":"success","verification":"strongConditionsstrong ulliTurn keyswitch ON.liliConnect INSITE electronic service tool.liulstrongActionstrongbr Check for active fault codes. ulliUse INSITE electronic service tool to read the fault codes.liulstrongSpecificationstrong ulliIf Fault Code 227, 352, or 386 is active, then perform a search on the appropriate fault and troubleshoot that fault prior to troubleshooting Fault Code 122.liul","resolution":"pPerform a search on the appropriate fault code.p","poleLogicSolution":true,"components":[{"value":"string","failureId":"string"}]}]}';
      
        CSS_J2ASolution_EDS j2a  = CSS_J2ASolution_EDS.parse(json1);
        //CSS_J2ASolution_EDS j2a = new CSS_J2ASolution_EDS();
        system.debug('=======j2a'+j2a);
        j2a.Components[0].failureId = '123';
        j2a.Components[0].value = '1234';
        CSS_JobEventTemporary__c jobevent = new CSS_JobEventTemporary__c();
        jobevent.File_Name__c='CSS_JobRepairRJ';
        jobevent.Circuit_Description__c='rrrr';
        jobevent.Comp_Location__c='dfgh';
        jobevent.Effect__c='klkl';
        jobevent.Engine__c='bfr';
        jobevent.Fault_Code_Description__c = 'intake';
        jobevent.Name = '3478';
        jobevent.FMI__c = 'htyu';
        jobevent.Lamp__c = 'nhgt';
        jobevent.Reason__c = 'yyyy';
        jobevent.Service_Model_Name__c = 'fault';
        jobevent.SPN__c = 'bfgfhhj';
        insert jobevent;
        
        //Inserting Nested solution data in wrapperclass
        CSS_RepairQsolEDS_V1.NestedSolutionsClass oWrapper1 = new CSS_RepairQsolEDS_V1.NestedSolutionsClass ();
        CSS_Solutions__c sol1 = new CSS_Solutions__c();
        sol1.Repair_Notes__c = null;
        System.AssertEquals( sol1.Repair_Notes__c,null);
        oWrapper1.solRec.Repair_Response__c='Repair performed but didnot resolve the root cause.';
        oWrapper1.solRec.Repair_Response__c='Repair Successful.';
        oWrapper1.solRec.Repair_Response__c='Repair Successful with additional parts/procedures.';
        oWrapper1.solRec.Repair_Notes__c = null;
        
        //Inserting Solution Detail
        CSS_Solutions__c  solDetails1 = new CSS_Solutions__c();
        solDetails1.Name = 'qwert';
        solDetails1.Repair_Response__c='TestrajesH';
        solDetails1.Service_Job__c = job.id;
        insert solDetails1;
        css_repair_job reprjob = new css_repair_job();
      CSS_RepairQsolEDS_V1 RepQsol = new CSS_RepairQsolEDS_V1(reprjob);
        RepQsol.faultCodeClick();
        RepQsol.getPartsListNestSol(sol.Id);
        string json = '{"key":"1234","message":"This is a test","messageArg":["a","b"],"solutionNumber":"K74452217","solutionTitle":"Fault Code 122 triggered by another fault code","coreIssue":"There are some instances when a fault code is recorded, but is strongnotstrong the first fault code that should be diagnosed.  br ","modificationDate":"01022016","status":"success","verification":"strongConditionsstrong ulliTurn keyswitch ON.liliConnect INSITE electronic service tool.liulstrongActionstrongbr Check for active fault codes. ulliUse INSITE electronic service tool to read the fault codes.liulstrongSpecificationstrong ulliIf Fault Code 227, 352, or 386 is active, then perform a search on the appropriate fault and troubleshoot that fault prior to troubleshooting Fault Code 122.liul","resolution":"pPerform a search on the appropriate fault code.p","poleLogicSolution":true,"components":[{"value":"string","failureId":"string"}],"repCompoundSolutions":[{"solutionNumber":"K74452217","solutionTitle":"Fault Code 122 triggered by another fault code","coreIssue":"There are some instances when a fault code is recorded, but is strongnotstrong the first fault code that should be diagnosed.  br ","modificationDate":"01022016","status":"success","verification":"strongConditionsstrong ulliTurn keyswitch ON.liliConnect INSITE electronic service tool.liulstrongActionstrongbr Check for active fault codes. ulliUse INSITE electronic service tool to read the fault codes.liulstrongSpecificationstrong ulliIf Fault Code 227, 352, or 386 is active, then perform a search on the appropriate fault and troubleshoot that fault prior to troubleshooting Fault Code 122.liul","resolution":"pPerform a search on the appropriate fault code.p","poleLogicSolution":true,"components":[{"value":"string","failureId":"string"}]}],"verCompoundSolutions":[{"solutionNumber":"K74452217","solutionTitle":"Fault Code 122 triggered by another fault code","coreIssue":"There are some instances when a fault code is recorded, but is strongnotstrong the first fault code that should be diagnosed.  br ","modificationDate":"01022016","status":"success","verification":"strongConditionsstrong ulliTurn keyswitch ON.liliConnect INSITE electronic service tool.liulstrongActionstrongbr Check for active fault codes. ulliUse INSITE electronic service tool to read the fault codes.liulstrongSpecificationstrong ulliIf Fault Code 227, 352, or 386 is active, then perform a search on the appropriate fault and troubleshoot that fault prior to troubleshooting Fault Code 122.liul","resolution":"pPerform a search on the appropriate fault code.p","poleLogicSolution":true,"components":[{"value":"string","failureId":"string"}]}]}';
        CSS_J2ASolution_EDS sDet = CSS_J2ASolution_EDS.parse(json);
        RepQsol.addSolComponents(solDetails1, sDet);
         string sh = '{"key":"1234","message":"This is a test","messageArg":["a","b"],"solutionNumber":"K74452217","solutionTitle":"Fault Code 122 triggered by another fault code","coreIssue":"There are some instances when a fault code is recorded, but is strongnotstrong the first fault code that should be diagnosed.  br ","modificationDate":"01022016","status":"success","verification":"strongConditionsstrong ulliTurn keyswitch ON.liliConnect INSITE electronic service tool.liulstrongActionstrongbr Check for active fault codes. ulliUse INSITE electronic service tool to read the fault codes.liulstrongSpecificationstrong ulliIf Fault Code 227, 352, or 386 is active, then perform a search on the appropriate fault and troubleshoot that fault prior to troubleshooting Fault Code 122.liul","resolution":"pPerform a search on the appropriate fault code.p","poleLogicSolution":true,"components":[{"value":"string","failureId":"string"}],"repCompoundSolutions":[{"solutionNumber":"K74452217","solutionTitle":"Fault Code 122 triggered by another fault code","coreIssue":"There are some instances when a fault code is recorded, but is strongnotstrong the first fault code that should be diagnosed.  br ","modificationDate":"01022016","status":"success","verification":"strongConditionsstrong ulliTurn keyswitch ON.liliConnect INSITE electronic service tool.liulstrongActionstrongbr Check for active fault codes. ulliUse INSITE electronic service tool to read the fault codes.liulstrongSpecificationstrong ulliIf Fault Code 227, 352, or 386 is active, then perform a search on the appropriate fault and troubleshoot that fault prior to troubleshooting Fault Code 122.liul","resolution":"pPerform a search on the appropriate fault code.p","poleLogicSolution":true,"components":[{"value":"string","failureId":"string"}]}],"verCompoundSolutions":[{"solutionNumber":"K74452217","solutionTitle":"Fault Code 122 triggered by another fault code","coreIssue":"There are some instances when a fault code is recorded, but is strongnotstrong the first fault code that should be diagnosed.  br ","modificationDate":"01022016","status":"success","verification":"strongConditionsstrong ulliTurn keyswitch ON.liliConnect INSITE electronic service tool.liulstrongActionstrongbr Check for active fault codes. ulliUse INSITE electronic service tool to read the fault codes.liulstrongSpecificationstrong ulliIf Fault Code 227, 352, or 386 is active, then perform a search on the appropriate fault and troubleshoot that fault prior to troubleshooting Fault Code 122.liul","resolution":"pPerform a search on the appropriate fault code.p","poleLogicSolution":true,"components":[{"value":"stringLKFKJDFLKDJFLKADJFLKDJAFFHAKLJNADSJKKDFHAJKLFAKDJFHAJKDFHAJKSDFDSMNFJAKDFHADSJKFNADKJFHAJKDFHADFNADSBHDBSDHFLJKFHAKDJFHKJDHFAJKFHADJKFNADKJFHADJKFHDJKFHDASJKFHADFNDFDKJFHADJKLFHALDKJFHLADJKFHLADKJFHLADKFDJKNBDHFLKADJFHAKLDJFHALDKJFHLADKJFDKJFHADLKJFHLADKJFHADJFNDFDKJFHDKLJFDLFHDLKJFNADFBDHFLKJAFLDJKFNKDLFNNDBVLNLAKJFAHLDKJFADLFBNDBNVBAKLJFLDNNDBGNDBGND VNBFKDFBDNFDMFBNDBFDNFMDBDJFKLDJFDFNNDMFBFJKDFKDJ JFHJKDFHJKDFHKDJ  HF DHKJHFHQ  JHJKFH  H FADF JH  FJHL JH Lhlfjh  djh hfjkh  jhf  ljafldfufpf fuifh oeiufl fuhufileflfleufhfhfj d ufh dfhdfjahdkfah iuhef e","failureId":"string"}]}]}';
        CSS_J2ASolution_EDS sDet1 = CSS_J2ASolution_EDS.parse(sh);
        RepQsol.addSolComponents(solDetails1, sDet1);
        RepQsol.prevSolution();
        RepQsol.selectedSol=solrec;
        RepQsol.validateResponse();
        RepQsol.selectedSol=solrec1;
        RepQsol.validateResponse();
    } 
    public static testMethod void CSS_SymEDSRepairs_Test_Method1(){
                   Account acc = new Account();
            acc.name='Kenworth Sales Co';
            acc.CSS_DistributorCode__c='02466';
            acc.IAM_Service_Provider_Code__c='19134';
            acc.Type='Dealer Account';
            acc.CMI_Account_Status__c = 'Active';
            insert acc;

        
        decimal diatime = 0.23; 
        String sDTime1 ='2';
        String JSONSols  = '[ ';
        String sStat = '0';
        String sSuffix = '';
        Integer iCounter = 0;
        Boolean blnActive = false;
        //string rank = '0';
        //integer rank = 0;
        boolean failDiagResp =false;        
  
        CSS_Job_Order__c job= new CSS_Job_Order__c();
        job.Account__c=acc.Id;
        job.esn__c='12345';
        job.INSITE_UpdateTimeStamp__c =system.today();
        job.INSITE_ESN_Choice__c='Not Selected';
        job.DSID__c='2323';
        job.ESN__c ='21323';
        job.Status__c = 'Intake';
        job.Application__c='asdd';
        job.Unit_Number__c='213';
        job.Failure_Point__c=213.00;
        job.Failure_Point_Measure__c='asd';
        job.Make__c='Make';
        job.Model__c='Model';
        job.Equipment_ID__c='Equip';
        job.Customer_Name__c='Peterbuilt';
        job.Shop_Work_Order__c='213dssd';
        job.Service_Model__c='SMNNUM';
        job.DSID_Creation_Timestamp__c=system.today();
        job.DSID_Status__c='Stat';
        job.DSID_WorkGroup__c='Wrkgrp';
        job.Status__c = 'Triage & Diagnosis/Repair' ;
        job.Previous_Status__c = 'Triage & Diagnosis' ;
        insert job;
       
        
        CSS_Fault_Code__c faulCodeRec = new CSS_Fault_Code__c(Name='3478',Related_Fault_Code__c='98734,95869',isPole__c = true);
        insert faulCodeRec;
        
        CSS_SymptomQA__c sym=new CSS_SymptomQA__c();
        sym.Job_Order__c=job.id;
        sym.caption__c ='white smoke';
        sym.Option1__c  ='12213';
        sym.Job_Order__c  =job.id;
        sym.Option_type__c  ='qwewqe';
        sym.Guide_Question__c  ='Do you see smoke';
        sym.Type__c  ='SearchString';
        
        insert sym; 
        
        CSS_SymptomQA__c symQA=new CSS_SymptomQA__c();
        sym.Job_Order__c=job.id;
        sym.caption__c ='fault Code';
        sym.Option1__c  ='12213';
        sym.Job_Order__c  =job.id;
        sym.SearchString__c  =sym.id;        
        sym.Type__c  ='QA';
        insert symQA;
        
        
        
        CSS_Solutions__c sol=new CSS_Solutions__c();
        //  sol.caseIndexInResultSet__c='test';
        sol.Case_Name__c='test';
        sol.Name='test';
        sol.Diagnostic_Response__c='test';
        sol.Repair_Response__c='testRajesh';
        sol.Symptom__c=sym.id;
        sol.Service_Job__c=job.id;
        sol.rank__c=0;
        sol.Out_Of_Order__c = false;
        sol.Solution_Title__c = 'test';
        sol.Solution__c ='test';
        sol.Report_Comments__c ='qwewqewqewewqe';
        sol.Diagnostic_notes__c ='asdsadad';
        sol.Repair_Notes__c='asdsadad';
        insert sol;
        //sol.CSS_Nested_Solutions__c=sol.id;//Added here for nested Solutions
        //update sol;
        
        system.debug('Rajesh-sol.Id:83-->'+sol.Id);
        
        
        CSS_Solution_Component__c csc=new CSS_Solution_Component__c();
        csc.Action__c='test';
        csc.Solutions__c=sol.id;
        csc.Service_Job__c=job.id;
        csc.Selected_Component__c=true;
        insert csc;
        
        
        //Create Solution Component
        CSS_Solution_Component__c csc1=CSS_TestData.createSRT(false,job.id,sol.id);
        insert csc1;
        
        
        Id recTypeIdpart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'Parts');
        String selSolution = 'test';
        Integer remCharcounterNest = 12;
       
        list<CSS_Parts_Options__c> lstparts = new list<CSS_Parts_Options__c>();
        CSS_Parts_Options__c parts = new CSS_Parts_Options__c();
        parts.recordtypeId = recTypeIdpart;
        parts.Option_Number__c = 'O-111';
        parts.Service_Job__c = job.id;
        parts.selected_part__c = true;
        parts.FailurepartId__c = csc.Id;
        parts.Part_Assignment__c = 'Primary';
        parts.Solutions__c=sol.id;
        lstparts.add(parts);
        //insert parts;
        
         CSS_Parts_Options__c parts1 = new CSS_Parts_Options__c();
        parts1.recordtypeId = recTypeIdpart;
        parts1.Option_Number__c = 'O-111';
        parts1.Service_Job__c = job.id;
        parts1.selected_part__c = true;
        parts1.FailurepartId__c = csc1.Id;
        parts1.Part_Assignment__c = 'Primary';
        parts1.Solutions__c=sol.id;
        lstparts.add(parts1);
        //insert parts1;
        insert lstparts;
        list<string> childId = new list<string>();
        for(CSS_Parts_Options__c partLst:lstparts){
            childId.add(partLst.id);
        }
        CSS_SRT__c srt=new CSS_SRT__c();
        srt.Solution_Number__c=sol.id;
        srt.Job_Order__c=job.id;
        srt.Type__c = 'Diagnosis';
        srt.SRT_Time__c=0.6;
        
        //srt.Diagnosis_Time__c=0.6;
        insert srt;
        
        CSS_SRT__c srtRep=new CSS_SRT__c();
        srt.Solution_Number__c=sol.id;
        srt.Job_Order__c=job.id;
        srt.Type__c = 'Repair';
        srt.SRT_Time__c=0.6;
        insert srtRep;
        
        List<CSS_SymptomQA__c> symList=new List<CSS_SymptomQA__c>();
        List<CSS_SymptomQA__c> symList1=new List<CSS_SymptomQA__c>();
        List<CSS_Solutions__c> solList=new List<CSS_Solutions__c>();
        
        
        List<CSS_Solution_Component__c> solComp  = new List<CSS_Solution_Component__c>();
        List<CSS_SRT__c> srts = new List<CSS_SRT__c>();
        List<CSS_SRT__c> srtsRep = new List<CSS_SRT__c>();
        
        symList.add(sym);
        symList1.add(symQA);
        solList.add(sol);
        
        solComp.add(csc);
        srts.add(srt) ;  
        srtsRep.add(srtRep);
        
        list<CSS_Solutions__c> solutionList = new list<CSS_Solutions__c>();
        CSS_Solutions__c solRec = new CSS_Solutions__c(Name='Solution1',Rank__c=0,Solution_Title__c='Title1',
                                                       Repair_Notes__c='Notes1',Repair_Response__c='response1',Service_Job__c=job.id,
                                                       FaultCode__c=faulCodeRec.Id);
        solutionList.add(solRec);
        CSS_Solutions__c solRec1 = new CSS_Solutions__c(Name='Solution2',Rank__c=1,Solution_Title__c='Title2',
                                                        Repair_Notes__c='Notes2',Repair_Response__c='response2',Service_Job__c=job.id,
                                                        FaultCode__c=faulCodeRec.Id,CSS_Nested_Solutions__c=solRec.Id,Symptom__c=sym.id);
        
        solutionList.add(solRec1);
        insert solutionList;
        system.debug('Rajesh-sol.Id:126-->'+solRec.Id);
        system.debug('Rajesh-sol.Id:130-->'+solRec1.Id);
        String ranks ='0';
        
        PageReference pageRef = new PageReference('/apex/JobTndTs?id=');
        test.setCurrentPage(pageRef);
        ApexPages.CurrentPage().getParameters().put('fcid',faulCodeRec.Id);
        pageRef.getParameters().put('id',job.id);
        pageRef.getParameters().put('symid',sym.id);
        pageRef.getParameters().put('rank',ranks);
        
         string json = '{"key":"1234","message":"This is a test","messageArg":["a","b"],"solutionNumber":"K74452217","solutionTitle":"Fault Code 122 triggered by another fault code","coreIssue":"There are some instances when a fault code is recorded, but is strongnotstrong the first fault code that should be diagnosed.  br ","modificationDate":"01022016","status":"success","verification":"strongConditionsstrong ulliTurn keyswitch ON.liliConnect INSITE electronic service tool.liulstrongActionstrongbr Check for active fault codes. ulliUse INSITE electronic service tool to read the fault codes.liulstrongSpecificationstrong ulliIf Fault Code 227, 352, or 386 is active, then perform a search on the appropriate fault and troubleshoot that fault prior to troubleshooting Fault Code 122.liul","resolution":"pPerform a search on the appropriate fault code.p","poleLogicSolution":true,"components":[{"value":"string","failureId":"string"}],"repCompoundSolutions":[{"solutionNumber":"K74452217","solutionTitle":"Fault Code 122 triggered by another fault code","coreIssue":"There are some instances when a fault code is recorded, but is strongnotstrong the first fault code that should be diagnosed.  br ","modificationDate":"01022016","status":"success","verification":"strongConditionsstrong ulliTurn keyswitch ON.liliConnect INSITE electronic service tool.liulstrongActionstrongbr Check for active fault codes. ulliUse INSITE electronic service tool to read the fault codes.liulstrongSpecificationstrong ulliIf Fault Code 227, 352, or 386 is active, then perform a search on the appropriate fault and troubleshoot that fault prior to troubleshooting Fault Code 122.liul","resolution":"pPerform a search on the appropriate fault code.p","poleLogicSolution":true,"components":[{"value":"string","failureId":"string"}]}],"verCompoundSolutions":[{"solutionNumber":"K74452217","solutionTitle":"Fault Code 122 triggered by another fault code","coreIssue":"There are some instances when a fault code is recorded, but is strongnotstrong the first fault code that should be diagnosed.  br ","modificationDate":"01022016","status":"success","verification":"strongConditionsstrong ulliTurn keyswitch ON.liliConnect INSITE electronic service tool.liulstrongActionstrongbr Check for active fault codes. ulliUse INSITE electronic service tool to read the fault codes.liulstrongSpecificationstrong ulliIf Fault Code 227, 352, or 386 is active, then perform a search on the appropriate fault and troubleshoot that fault prior to troubleshooting Fault Code 122.liul","resolution":"pPerform a search on the appropriate fault code.p","poleLogicSolution":true,"components":[{"value":"string","failureId":"string"}]}]}';
        CSS_J2ASolution_EDS j2a  = CSS_J2ASolution_EDS.parse(json);
        //CSS_J2ASolution_EDS j2a = new CSS_J2ASolution_EDS();
        system.debug('=======j2a'+j2a);
        j2a.Components[0].failureId = '123';
        j2a.Components[0].value = '1234';
        CSS_JobEventTemporary__c jobevent = new CSS_JobEventTemporary__c();
        jobevent.File_Name__c='CSS_JobRepairRJ';
        jobevent.Circuit_Description__c='rrrr';
        jobevent.Comp_Location__c='dfgh';
        jobevent.Effect__c='klkl';
        jobevent.Engine__c='bfr';
        jobevent.Fault_Code_Description__c = 'intake';
        jobevent.File_Name__c = 'testing';
        jobevent.FMI__c = 'htyu';
        jobevent.Lamp__c = 'nhgt';
        jobevent.Reason__c = 'yyyy';
        jobevent.Service_Model_Name__c = 'fault';
        jobevent.SPN__c = 'bfgfhhj';
        insert jobevent;
        
        
        
        //j2as.failureId = '123';
        //j2as.value = 'test';
        //insert j2as;
        
        
        css_repair_job  cssRep = new css_repair_job();
        CSS_RepairQsolEDS_V1 extsymRep = new CSS_RepairQsolEDS_V1(cssRep);
        //extsymRep.getSolutionDetails();
       
       
        
        CSS_RepairQsolEDS_V1.NestedSolutionsClass oWrapper1 = new CSS_RepairQsolEDS_V1.NestedSolutionsClass ();
        CSS_Solutions__c sol1 = new CSS_Solutions__c();
        sol1.Repair_Notes__c = null;
        System.AssertEquals( sol1.Repair_Notes__c,null);
        oWrapper1.solRec.Repair_Response__c='Repair performed but didnot resolve the root cause.';
        oWrapper1.solRec.Repair_Response__c='Repair Successful.';
        oWrapper1.solRec.Repair_Response__c='Repair Successful with additional parts/procedures.';
        oWrapper1.solRec.Repair_Notes__c = null;
        
        //oWrapper1.solRec.Repair_Notes__c = '';
        //System.AssertEquals( oWrapper1.solRec.Repair_Notes__c,null);
        
        CSS_Solutions__c  solDetails = new CSS_Solutions__c();
        solDetails.Name = 'qwert';
        solDetails .Repair_Response__c='TestrajesH';
        solDetails.Service_Job__c=job.id;
        insert solDetails;
        system.debug('Rajesh-solDetails.Id:83-->'+solDetails.Id);
        map<string,CSS_Solutions__c>  kIdSolutionMap = new map<string,CSS_Solutions__c>();
        
        CSS_J2ASolution_EDS.Components j2as = new CSS_J2ASolution_EDS.Components();        
        CSS_Solution_Component__c solcomp1  = new CSS_Solution_Component__c();
        solcomp1.Component_Id__c = j2as.failureId;
        solcomp1.Name =  j2as.value;
        solcomp1.Solutions__c = solRec.ID;
        solcomp1.Service_Job__c = job.ID;
        oWrapper1.solRec.Name = j2a.solutionNumber;
        oWrapper1.solRec.Solution_Title__c = j2a.solutionTitle;
        oWrapper1.solRec.CSS_Nested_Solutions__c =  solDetails.Id;
        oWrapper1.solRec.Service_Job__c = job.id;
        oWrapper1.solRec.FaultCode__c = solDetails.FaultCode__c;
         extsymRep.selectedNestSol=oWrapper1;
         extsymRep.selectedSol=solRec;
        extsymRep.getPartsListNestSol(solRec.ID);
     //    extsymRep.selectedSymId=sym.id;
        //solcomp1.Service_Job__c = job.Id;
        
        CSS_Solutions__c solRecselec = new CSS_Solutions__c(Name='Solution2',Rank__c=1,Solution_Title__c='Title2',
                                                        Repair_Notes__c='Notes2',Repair_Response__c='response2',
                                                        FaultCode__c=faulCodeRec.Id,CSS_Nested_Solutions__c=solRec.Id,Symptom__c=sym.id);
        insert solRecselec ;
        
        CSS_Solutions__c selectedSol = new CSS_Solutions__c();
        
        //CSS_Solution_Component__c Components;
        CSS_TestData.createAccountLanguage(true);
        //Test.startTest();
        Test.setMock(HttpCalloutMock.class, new CSS_GetSolDetails_Test());
        
        extsymRep.rank ='0';
        extsymRep.solDetFailed=false;
        extsymRep.Camps = 1;
        extsymRep.Trps = 1;
        extsymRep.Tsbs = 1;
        extsymRep.Atcs = 1;
        extsymRep.rankFromTs='1';
       
        extsymRep.selectedFaulcode = '123';
        extsymRep.sKNumber = '1212';
        extsymRep.solErrorMsg = 'asdasdasd';
        extsymRep.recFaultCode = new List<CSS_Fault_Code__c>();
         extsymRep.solDetails= new List<CSS_Solutions__c>();
        extsymRep.workGroup ='sasd';
        
        extsymRep.selectedValue='wqeqwe';
        extsymRep.selectedValue1='wqeqwe';
        extsymRep.textEntered='wqeqwe';
         selectedSol.Repair_Response__c='TestrajesH';
         
       // extsymRep.returnToFCView();
        extsymRep.prevSolution();
        // extsymRep.getSolutionDetails();
         extsymRep.addSolComponents(solRec,j2a);
        extsymRep.getSelNestSolution();
       extsymRep.validatenestResponse();
       extsymRep.UpdateNestSolNotes();
        extsymRep.getSolutionDetails();
        
  //    CSS_RepairQsolEDS_V1.getAccountCodes('79464646', '12345', system.today()+7, '6', 'Miles', '89', system.today() - 10, 'temp','Test','Test');
        extsymRep.qsolredirect();
        extsymRep.nextSolution();
        extsymRep.validateResponse();
        extsymRep.failDiagResp1 = true;
        extsymRep.display = true;
        extsymRep.JSONSolsGlob = 'test';
        extsymRep.rank1='Test';
        extsymRep.rankFromTs1='Test';
        
        extsymRep.reportProblemComments();
        job.Status__c = 'Intake Complete';
       
        update job;
        
        extsymRep.getSelNestSolution();
        
        
        CSS_RepairQsolEDS_V1.NestedSolutionsClass oWrapper23 = new CSS_RepairQsolEDS_V1.NestedSolutionsClass ();
        //oWrapper23.solRec.Repair_Response__c = 'Repair Successful.'; 
        //upsert oWrapper23.solRec;
        string FeedBackValNest = ApexPages.CurrentPage().getParameters().get('firstParam');
        FeedBackValNest = oWrapper23.solRec.Repair_Response__c;
       
        //String temp = JSON.serialize(compWrap);
        date d =system.today();
        // Test.stopTest();
        
    }
    
    public static testMethod void CSS_Repairs_Test_Method(){
                   Account acc = new Account();
            acc.name='Kenworth Sales Co';
            acc.CSS_DistributorCode__c='02466';
            acc.IAM_Service_Provider_Code__c='19134';
            acc.Type='Dealer Account';
            acc.CMI_Account_Status__c = 'Active';
            insert acc;

        
        decimal diatime = 0.23; 
        String sDTime1 ='2';
        String JSONSols  = '[ ';
        String sStat = '0';
        String sSuffix = '';
        Integer iCounter = 0;
        Boolean blnActive = false;
        //string rank = '0';
        //integer rank = 0;
        boolean failDiagResp =false;        
  
        CSS_Job_Order__c job= new CSS_Job_Order__c();
        job.Account__c=acc.Id;
        job.esn__c='12345';
        job.INSITE_UpdateTimeStamp__c =system.today();
        job.INSITE_ESN_Choice__c='Not Selected';
        job.DSID__c='2323';
        job.ESN__c ='21323';
        job.Status__c = 'Intake';
        job.Application__c='asdd';
        job.Unit_Number__c='213';
        job.Failure_Point__c=213.00;
        job.Failure_Point_Measure__c='asd';
        job.Make__c='Make';
        job.Model__c='Model';
        job.Equipment_ID__c='Equip';
        job.Customer_Name__c='Peterbuilt';
        job.Shop_Work_Order__c='213dssd';
        job.Service_Model__c='SMNNUM';
        job.DSID_Creation_Timestamp__c=system.today();
        job.DSID_Status__c='Stat';
        job.DSID_WorkGroup__c='Wrkgrp';
        job.Status__c = 'Triage & Diagnosis/Repair' ;
        job.Previous_Status__c = 'Triage & Diagnosis' ;
        insert job;
       
        
        CSS_Fault_Code__c faulCodeRec = new CSS_Fault_Code__c(Name='3478',Related_Fault_Code__c='98734,95869',isPole__c = true);
        insert faulCodeRec;
        
        CSS_SymptomQA__c sym=new CSS_SymptomQA__c();
        sym.Job_Order__c=job.id;
        sym.caption__c ='white smoke';
        sym.Option1__c  ='12213';
        sym.Job_Order__c  =job.id;
        sym.Option_type__c  ='qwewqe';
        sym.Guide_Question__c  ='Do you see smoke';
        sym.Type__c  ='SearchString';
        
        insert sym; 
        
        CSS_SymptomQA__c symQA=new CSS_SymptomQA__c();
        sym.Job_Order__c=job.id;
        sym.caption__c ='fault Code';
        sym.Option1__c  ='12213';
        sym.Job_Order__c  =job.id;
        sym.SearchString__c  =sym.id;        
        sym.Type__c  ='QA';
        insert symQA;
        
        
        
        CSS_Solutions__c sol=new CSS_Solutions__c();
        //  sol.caseIndexInResultSet__c='test';
        sol.Case_Name__c='test';
        sol.Name='test';
        sol.Diagnostic_Response__c='test';
        sol.Repair_Response__c='testRajesh';
        sol.Symptom__c=sym.id;
        sol.Service_Job__c=job.id;
        sol.rank__c=0;
        sol.Out_Of_Order__c = false;
        sol.Solution_Title__c = 'test';
        sol.Solution__c ='test';
        sol.Report_Comments__c ='qwewqewqewewqe';
        sol.Diagnostic_notes__c ='asdsadad';
        sol.Repair_Notes__c='asdsadad';
        insert sol;
        
        system.debug('Rajesh-sol.Id:83-->'+sol.Id);
        
        
        CSS_Solution_Component__c csc=new CSS_Solution_Component__c();
        csc.Action__c='test';
        csc.Solutions__c=sol.id;
        csc.Service_Job__c=job.id;
        csc.Selected_Component__c=true;
        insert csc;
     CSS_Solution_Component__c csc1=CSS_TestData.createSRT(false,job.id,sol.id);
        insert csc1;
        
        
        Id recTypeIdpart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'Parts');
        String selSolution = 'test';
        Integer remCharcounterNest = 12;
       
        list<CSS_Parts_Options__c> lstparts = new list<CSS_Parts_Options__c>();
        CSS_Parts_Options__c parts = new CSS_Parts_Options__c();
        parts.recordtypeId = recTypeIdpart;
        parts.Option_Number__c = 'O-111';
        parts.Service_Job__c = job.id;
        parts.selected_part__c = true;
        parts.FailurepartId__c = csc.Id;
        parts.Part_Assignment__c = 'Primary';
        parts.Solutions__c=sol.id;
        lstparts.add(parts);
        //insert parts;
        
         CSS_Parts_Options__c parts1 = new CSS_Parts_Options__c();
        parts1.recordtypeId = recTypeIdpart;
        parts1.Option_Number__c = 'O-111';
        parts1.Service_Job__c = job.id;
        parts1.selected_part__c = true;
        parts1.FailurepartId__c = csc1.Id;
        parts1.Part_Assignment__c = 'Primary';
        parts1.Solutions__c=sol.id;
        lstparts.add(parts1);
        //insert parts1;
        insert lstparts;
        list<string> childId = new list<string>();
        for(CSS_Parts_Options__c partLst:lstparts){
            childId.add(partLst.id);
        }
        CSS_SRT__c srt=new CSS_SRT__c();
        srt.Solution_Number__c=sol.id;
        srt.Job_Order__c=job.id;
        srt.Type__c = 'Diagnosis';
        srt.SRT_Time__c=0.6;
        
        //srt.Diagnosis_Time__c=0.6;
        insert srt;
        
        CSS_SRT__c srtRep=new CSS_SRT__c();
        srt.Solution_Number__c=sol.id;
        srt.Job_Order__c=job.id;
        srt.Type__c = 'Repair';
        srt.SRT_Time__c=0.6;
        insert srtRep;
        
        List<CSS_SymptomQA__c> symList=new List<CSS_SymptomQA__c>();
        List<CSS_SymptomQA__c> symList1=new List<CSS_SymptomQA__c>();
        List<CSS_Solutions__c> solList=new List<CSS_Solutions__c>();
        
        
        List<CSS_Solution_Component__c> solComp  = new List<CSS_Solution_Component__c>();
        List<CSS_SRT__c> srts = new List<CSS_SRT__c>();
        List<CSS_SRT__c> srtsRep = new List<CSS_SRT__c>();
        
        symList.add(sym);
        symList1.add(symQA);
        solList.add(sol);
        
        solComp.add(csc);
        srts.add(srt) ;  
        srtsRep.add(srtRep);
        
        list<CSS_Solutions__c> solutionList = new list<CSS_Solutions__c>();
        CSS_Solutions__c solRec = new CSS_Solutions__c(Name='Solution1',Rank__c=0,Solution_Title__c='Title1',
                                                       Repair_Notes__c='Notes1',Repair_Response__c='response1',Service_Job__c=job.id,
                                                       FaultCode__c=faulCodeRec.Id);
        solutionList.add(solRec);
        CSS_Solutions__c solRec1 = new CSS_Solutions__c(Name='Solution2',Rank__c=1,Solution_Title__c='Title2',
                                                        Repair_Notes__c='Notes2',Repair_Response__c='response2',Service_Job__c=job.id,
                                                        FaultCode__c=faulCodeRec.Id,CSS_Nested_Solutions__c=solRec.Id,Symptom__c=sym.id);
        
        solutionList.add(solRec1);
        insert solutionList;
        system.debug('Rajesh-sol.Id:126-->'+solRec.Id);
        system.debug('Rajesh-sol.Id:130-->'+solRec1.Id);
        String ranks ='0';
        
        PageReference pageRef = new PageReference('/apex/JobTndTs?id=');
        test.setCurrentPage(pageRef);
        ApexPages.CurrentPage().getParameters().put('fcid',faulCodeRec.Id);
        pageRef.getParameters().put('id',job.id);
        pageRef.getParameters().put('symid',sym.id);
        pageRef.getParameters().put('rank',ranks);
        
         string json = '{"key":"1234","message":"This is a test","messageArg":["a","b"],"solutionNumber":"K74452217","solutionTitle":"Fault Code 122 triggered by another fault code","coreIssue":"There are some instances when a fault code is recorded, but is strongnotstrong the first fault code that should be diagnosed.  br ","modificationDate":"01022016","status":"success","verification":"strongConditionsstrong ulliTurn keyswitch ON.liliConnect INSITE electronic service tool.liulstrongActionstrongbr Check for active fault codes. ulliUse INSITE electronic service tool to read the fault codes.liulstrongSpecificationstrong ulliIf Fault Code 227, 352, or 386 is active, then perform a search on the appropriate fault and troubleshoot that fault prior to troubleshooting Fault Code 122.liul","resolution":"pPerform a search on the appropriate fault code.p","poleLogicSolution":true,"components":[{"value":"string","failureId":"string"}],"repCompoundSolutions":[{"solutionNumber":"K74452217","solutionTitle":"Fault Code 122 triggered by another fault code","coreIssue":"There are some instances when a fault code is recorded, but is strongnotstrong the first fault code that should be diagnosed.  br ","modificationDate":"01022016","status":"success","verification":"strongConditionsstrong ulliTurn keyswitch ON.liliConnect INSITE electronic service tool.liulstrongActionstrongbr Check for active fault codes. ulliUse INSITE electronic service tool to read the fault codes.liulstrongSpecificationstrong ulliIf Fault Code 227, 352, or 386 is active, then perform a search on the appropriate fault and troubleshoot that fault prior to troubleshooting Fault Code 122.liul","resolution":"pPerform a search on the appropriate fault code.p","poleLogicSolution":true,"components":[{"value":"string","failureId":"string"}]}],"verCompoundSolutions":[{"solutionNumber":"K74452217","solutionTitle":"Fault Code 122 triggered by another fault code","coreIssue":"There are some instances when a fault code is recorded, but is strongnotstrong the first fault code that should be diagnosed.  br ","modificationDate":"01022016","status":"success","verification":"strongConditionsstrong ulliTurn keyswitch ON.liliConnect INSITE electronic service tool.liulstrongActionstrongbr Check for active fault codes. ulliUse INSITE electronic service tool to read the fault codes.liulstrongSpecificationstrong ulliIf Fault Code 227, 352, or 386 is active, then perform a search on the appropriate fault and troubleshoot that fault prior to troubleshooting Fault Code 122.liul","resolution":"pPerform a search on the appropriate fault code.p","poleLogicSolution":true,"components":[{"value":"string","failureId":"string"}]}]}';
        CSS_J2ASolution_EDS j2a  = CSS_J2ASolution_EDS.parse(json);
        system.debug('=======j2a'+j2a);
        j2a.Components[0].failureId = '123';
        j2a.Components[0].value = '1234';
        CSS_JobEventTemporary__c jobevent = new CSS_JobEventTemporary__c();
        jobevent.File_Name__c='CSS_JobRepairRJ';
        jobevent.Circuit_Description__c='rrrr';
        jobevent.Comp_Location__c='dfgh';
        jobevent.Effect__c='klkl';
        jobevent.Engine__c='bfr';
        jobevent.Fault_Code_Description__c = 'intake';
        jobevent.File_Name__c = 'testing';
        jobevent.FMI__c = 'htyu';
        jobevent.Lamp__c = 'nhgt';
        jobevent.Reason__c = 'yyyy';
        jobevent.Service_Model_Name__c = 'fault';
        jobevent.SPN__c = 'bfgfhhj';
        insert jobevent;
        
        css_repair_job  cssRep = new css_repair_job();
        CSS_RepairQsolEDS_V1 extsymRep = new CSS_RepairQsolEDS_V1(cssRep);
        extsymRep.refreshPartsList();
    //    extsymRep.refreshPartsListNested();
        
        
        
        CSS_RepairQsolEDS_V1.NestedSolutionsClass oWrapper1 = new CSS_RepairQsolEDS_V1.NestedSolutionsClass ();
        CSS_Solutions__c sol1 = new CSS_Solutions__c();
        sol1.Repair_Notes__c = null;
        System.AssertEquals( sol1.Repair_Notes__c,null);
        oWrapper1.solRec.Repair_Response__c='Repair performed but didnot resolve the root cause.';
        oWrapper1.solRec.Repair_Response__c='Repair Successful.';
        oWrapper1.solRec.Repair_Response__c='Repair Successful with additional parts/procedures.';
        oWrapper1.solRec.Repair_Notes__c = null;
        
        
        CSS_Solutions__c  solDetails = new CSS_Solutions__c();
        solDetails.Name = 'qwert';
        solDetails .Repair_Response__c='TestrajesH';
        solDetails.Service_Job__c=job.id;
        insert solDetails;
        system.debug('Rajesh-solDetails.Id:83-->'+solDetails.Id);
        map<string,CSS_Solutions__c>  kIdSolutionMap = new map<string,CSS_Solutions__c>();
        
        CSS_J2ASolution_EDS.Components j2as = new CSS_J2ASolution_EDS.Components();        
        CSS_Solution_Component__c solcomp1  = new CSS_Solution_Component__c();
        solcomp1.Component_Id__c = j2as.failureId;
        solcomp1.Name =  j2as.value;
        solcomp1.Solutions__c = solRec.ID;
        solcomp1.Service_Job__c = job.ID;
        oWrapper1.solRec.Name = j2a.solutionNumber;
        oWrapper1.solRec.Solution_Title__c = j2a.solutionTitle;
        oWrapper1.solRec.CSS_Nested_Solutions__c =  solDetails.Id;
        oWrapper1.solRec.Service_Job__c = job.id;
        oWrapper1.solRec.FaultCode__c = solDetails.FaultCode__c;
         extsymRep.selectedNestSol=oWrapper1;
         extsymRep.selectedSol=solRec;
        extsymRep.getPartsListNestSol(solRec.ID);
      //   extsymRep.selectedSymId=sym.id;
        
        CSS_Solutions__c solRecselec = new CSS_Solutions__c(Name='Solution2',Rank__c=1,Solution_Title__c='Title2',
                                                        Repair_Notes__c='Notes2',Repair_Response__c='response2',
                                                        FaultCode__c=faulCodeRec.Id,CSS_Nested_Solutions__c=solRec.Id,Symptom__c=sym.id);
        insert solRecselec ;
        
        CSS_Solutions__c selectedSol = new CSS_Solutions__c();
        
         CSS_TestData.createAccountLanguage(true);
        Test.setMock(HttpCalloutMock.class, new CSS_GetSolDetails_Test());
        
        extsymRep.rank ='0';
        extsymRep.solDetFailed=false;
        extsymRep.Camps = 1;
        extsymRep.Trps = 1;
        extsymRep.Tsbs = 1;
        extsymRep.Atcs = 1;
        extsymRep.rankFromTs='1';
       
        extsymRep.selectedFaulcode = '123';
        extsymRep.sKNumber = '1212';
        extsymRep.solErrorMsg = 'asdasdasd';
        extsymRep.recFaultCode = new List<CSS_Fault_Code__c>();
         extsymRep.solDetails= new List<CSS_Solutions__c>();
        extsymRep.workGroup ='sasd';
        
        extsymRep.selectedValue='wqeqwe';
        extsymRep.selectedValue1='wqeqwe';
        extsymRep.textEntered='wqeqwe';
         selectedSol.Repair_Response__c='TestrajesH';
         extsymRep.addSolComponents(solRec,j2a);
        extsymRep.getSelNestSolution();
       extsymRep.validatenestResponse();
       extsymRep.UpdateNestSolNotes();
        extsymRep.getSolutionDetails();
        
      
        extsymRep.qsolredirect();
        extsymRep.nextSolution();
        extsymRep.validateResponse();
        extsymRep.failDiagResp1 = true;
        extsymRep.display = true;
        extsymRep.JSONSolsGlob = 'test';
        extsymRep.rank1='Test';
            extsymRep.rankFromTs1='Test';
        extsymRep.reportProblemComments();
        job.Status__c = 'Intake Complete';
       
        update job;
        extsymRep.returnToRepairView();
        extsymRep.returnToFCView();
        extsymRep.getSelNestSolution();
        extsymRep.srtAccesscheckList();
        extsymRep.actionMethodOf();
        extsymRep.updateFeedBackForSol();
        extsymRep.updateSol(sol.id,sol.Diagnostic_Response__c,sol.Repair_notes__c);
        
        extsymRep.getNestSolutionsList();
        //extsymRep.UpdateSolNotes();
        extsymRep.addSolComponents(solRec,j2a);
        extsymRep.getNestSolutionsList();
        extsymRep.returnToFCView();
        CSS_RepairQsolEDS_V1.NestedSolutionsClass oWrapper23 = new CSS_RepairQsolEDS_V1.NestedSolutionsClass ();
        string FeedBackValNest = ApexPages.CurrentPage().getParameters().get('firstParam');
        FeedBackValNest = oWrapper23.solRec.Repair_Response__c;
        extsymRep.faultCodeClick();        
       extsymRep.prevSolution();
        extsymRep.getSelNestSolution();
        extsymRep.getRefreshSols();
        extsymRep.getPartsList(); 
       
          extsymRep.getreplacementReasonOptions(); 
         date d =system.today();
        Test.setMock(WebServiceMock.class, new CSS_GetWarrantyDocs_Test());
        
        CSS_RepairQsolEDS_V1.srtPartWrapper partWrap = new CSS_RepairQsolEDS_V1.srtPartWrapper(parts.id,sol.id,false,'partName',5,9,'replacementReason');
        CSS_RepairQsolEDS_V1.srtPartWrapper partWrap1 = new CSS_RepairQsolEDS_V1.srtPartWrapper(parts.id,sol.id,false,'partName',6,8,'replacementReason1');

        
    }
}