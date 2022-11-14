@isTest
public class CSS_SymEDSRepairs_Test {
    
     public static testMethod void CSS_SymEDSRepairs_Test_Method1(){
        
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
        acc.Name = 'test';
        acc.Type = 'Other';
        insert acc;

        CSS_Job_Order__c job= new CSS_Job_Order__c();
        job.esn__c='12345';
        job.Account__c=acc.id;
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
        //sol.caseIndexInResultSet__c='test';
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
         csc.Solutions__c=sol.id;
        csc.Selected_Component__c=true;
        insert csc;
        //csc.Solutions__c=sol.Id;
        //update csc;
        
        
        
        /*CSS_Solution_Component__c csc1=new CSS_Solution_Component__c();
        csc1.Action__c='test';
        csc1.Solutions__c=sol.id;
        csc1.Service_Job__c=job.id;
        csc1.Selected_Component__c=false;
        insert csc1;
        
        //Create Solution Component
        CSS_Solution_Component__c csc1=CSS_TestData.createSRT(false,job.id,sol.id);
        insert csc1;*/
        
        
        Id recTypeIdpart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'Parts');
        String selSolution = 'test';
        Integer remCharcounterNest = 12;
       
        list<CSS_Parts_Options__c> lstparts = new list<CSS_Parts_Options__c>();
        CSS_Parts_Options__c parts = new CSS_Parts_Options__c();
        parts.recordtypeId = recTypeIdpart;
        parts.Option_Number__c = 'O-111';
        parts.Service_Job__c = job.id;
        parts.selected_part__c = true;
        //parts.FailurepartId__c = csc.Id;
        parts.Part_Assignment__c = 'Primary';
        parts.Solutions__c=sol.id;
        lstparts.add(parts);
        //insert parts;
        
         CSS_Parts_Options__c parts1 = new CSS_Parts_Options__c();
        parts1.recordtypeId = recTypeIdpart;
        parts1.Option_Number__c = 'O-111';
        parts1.Service_Job__c = job.id;
        parts1.selected_part__c = true;
       // parts1.FailurepartId__c = sol.Id;
        parts1.Part_Assignment__c = 'Primary';
        parts1.Solutions__c=sol.id;
        lstparts.add(parts1);
        //insert parts1;
        insert lstparts;
        list<string> childId = new list<string>();
        for(CSS_Parts_Options__c partLst:lstparts){
            childId.add(partLst.id);
        }
       /* CSS_SRT__c srt=new CSS_SRT__c();
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
        insert srtRep;*/
        
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
       // srts.add(srt) ;  
        //srtsRep.add(srtRep);
        
        list<CSS_Solutions__c> solutionList = new list<CSS_Solutions__c>();
        CSS_Solutions__c solRec = new CSS_Solutions__c(Name='Solution1',Rank__c=0,Solution_Title__c='Title1',Service_Job__c=job.id,
                                                       Repair_Notes__c='Notes1',Repair_Response__c='response1',
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
        CSS_SymEDSRepairs extsymRep = new CSS_SymEDSRepairs(cssRep);
        //extsymRep.getSolutionDetails();
        //
         
        extsymRep.refreshPartsList();
        extsymRep.refreshPartsListNested();
        
        
        
        CSS_SymEDSRepairs.NestedSolutionsClass oWrapper1 = new CSS_SymEDSRepairs.NestedSolutionsClass ();
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
         extsymRep.selectedSol =sol;
        extsymRep.getPartsListNestSol(solRec.ID);
         extsymRep.selectedSymId=sym.id;
        //solcomp1.Service_Job__c = job.Id;
        
        /*CSS_Solutions__c solRecselec = new CSS_Solutions__c(Name='Solution2',Rank__c=1,Solution_Title__c='Title2',
                                                        Repair_Notes__c='Notes2',Repair_Response__c='response2',
                                                        FaultCode__c=faulCodeRec.Id,CSS_Nested_Solutions__c=solRec.Id,Symptom__c=sym.id);
        insert solRecselec ;
        
        CSS_Solutions__c selectedSol = new CSS_Solutions__c();*/
        
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
         //selectedSol.Repair_Response__c='TestrajesH';
         
        //extsymRep.returnToFCView();
        
        //extsymRep.getSolutionDetails();
         extsymRep.addSolComponents(solRec,j2a);
         extsymRep.getSelNestSolution();
         extsymRep.validatenestResponse();
         extsymRep.UpdateNestSolNotes();
         extsymRep.selectedSol =sol;
         extsymRep.getSolutionDetails();
        
      
        extsymRep.qsolredirect();
        extsymRep.nextSolution();
        extsymRep.validateResponse();
        extsymRep.failDiagResp1 = true;
        extsymRep.display = true;
        extsymRep.JSONSolsGlob = 'test';
        extsymRep.rank1='Test';
            extsymRep.rankFromTs1='Test';
        //boolean nesFailed=false;
        //boolean nesFailed1=true;
        
        

        //extsymRep.validatenestResponse();
        extsymRep.reportProblemComments();
        job.Status__c = 'Intake Complete';
       
        update job;
        extsymRep.returnToRepairView();
        extsymRep.returnToFCView();
        //Test.setMock(HttpCalloutMock.class, new CSS_ReportProblem_Test());
        extsymRep.getSelNestSolution();
        //extsymRep.updateFeedBackForNestSol();
        extsymRep.srtAccesscheckList();
        extsymRep.actionMethodOf();
        extsymRep.updateFeedBackForSol();
        extsymRep.updateSol(sol.id,sol.Diagnostic_Response__c,sol.Repair_notes__c);
        
        //extsymRep.getSelNestSolution();
        extsymRep.getNestSolutionsList();
        //extsymRep.updateFeedBackForNestSol();
        extsymRep.UpdateSolNotes();
        extsymRep.addSolComponents(solRec,j2a);
        extsymRep.getNestSolutionsList();
        extsymRep.returnToFCView();
        CSS_SymEDSRepairs.NestedSolutionsClass oWrapper23 = new CSS_SymEDSRepairs.NestedSolutionsClass ();
        //oWrapper23.solRec.Repair_Response__c = 'Repair Successful.'; 
        //upsert oWrapper23.solRec;
        string FeedBackValNest = ApexPages.CurrentPage().getParameters().get('firstParam');
        FeedBackValNest = oWrapper23.solRec.Repair_Response__c;
        extsymRep.faultCodeClick();        
        //pagereference p = extsymRep.UpdateNestSolNotes();
        extsymRep.prevSolution();
        extsymRep.getSelNestSolution();
        extsymRep.getRefreshSols();
        //extsymRep.validatenestResponse();
         Test.startTest();
          extsymRep.getPartsList(); 
       // Test.stopTest();
          //extsymRep.parentCheckBoxLogic();
          //extsymRep.childCheckBoxLogic();
          //extsymRep.partssave();
          extsymRep.getreplacementReasonOptions(); 
         // extsymRep.getSRTComponentOnLoad();
        //list<srtCompWrapper> lstcompWrap = new list<srtCompWrapper>();
        //list<srtPartWrapper> lstpartsWrap = new list<srtPartWrapper>();
        //String temp = JSON.serialize(compWrap);
        date d =system.today();
        //CSS_SymEDSRepairs.getAccountCodes('79464646', '12345', d, '6', 'Miles', '89', d, 'temp');
        Test.setMock(WebServiceMock.class, new CSS_GetWarrantyDocs_Test());
        //Test.startTest();
        extsymRep.getQSOLDocs();
         extsymRep.getQSOLDocs_Existing();
        //extsymRep.addsolcomponents(extsymRep.selectedsol, extsymRep.soldet );
        Test.stopTest();
        CSS_SymEDSRepairs.srtPartWrapper partWrap = new CSS_SymEDSRepairs.srtPartWrapper(parts.id,sol.id,false,'partName',5,9,'replacementReason');
        CSS_SymEDSRepairs.srtPartWrapper partWrap1 = new CSS_SymEDSRepairs.srtPartWrapper(parts.id,sol.id,false,'partName',6,8,'replacementReason1');

        //CSS_SymEDSRepairs.srtCompWrapper compWrap = new CSS_SymEDSRepairs.srtCompWrapper(sol.id,false,'compName',childId,lstpartsWrap,'faultCode','systemCode','compCode','accountCode');
         extsymRep.selectedSol.Repair_Response__c='Repair Successful.';
         extsymRep.selectedSol.Repair_notes__c = null;
         extsymRep.rJobOrd.Status__c ='Repair Successful';
         extsymRep.prevSolution();
         extsymRep.validateResponse(); 
         extsymRep.selectedSol.Repair_Response__c=null;
         extsymRep.selectedSol.Repair_notes__c ='Repair Successful' ;
         extsymRep.validateResponse();
         extsymRep.selectedNestSol= new CSS_SymEDSRepairs.NestedSolutionsClass();
         extsymRep.selectedNestSol.solRec=new CSS_Solutions__c();
       //  extsymRep.UpdateNestSolNotes(); //ANvesh commented for 101 Soql queries
         
         extsymRep.rJobOrd.Status__c ='Repair Successful';
         extsymRep.selectedSol.Repair_Response__c='';
         extsymRep.returnToRepairView();  
         extsymRep.returnToFCView();
         extsymRep.prevSolution();
         extsymRep.nestSolComp= new CSS_Solution_Component__c();
         extsymRep.selectedNestSolTitle1='test ';
   }
    
    static testmethod void testmethod2()
    {
        decimal diatime = 0.23; 
        String sDTime1 ='2';
        String JSONSols  = '[ ';
        String sStat = '0';
        String sSuffix = '';
        Integer iCounter = 0;
        Boolean blnActive = false;
        Account acc = new Account();
        acc.Name = 'test';
        acc.Type = 'Other';
        insert acc;
        boolean failDiagResp =false;   
        CSS_Job_Order__c job= new CSS_Job_Order__c();
        job.Account__c=acc.id;
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
        
        list<CSS_Solution_Component__c> sollist=new list<CSS_Solution_Component__c>();
        CSS_Solution_Component__c csc=new CSS_Solution_Component__c();
        csc.Action__c='test';
        csc.Solutions__c=sol.id;
        csc.Service_Job__c=job.id;
        csc.Selected_Component__c=true;
        insert csc;
        sollist.add(csc);
         //Create Solution Component
        CSS_Solution_Component__c csc1=CSS_TestData.createSRT(false,job.id,sol.id);
        csc1.Solutions__c=sol.id;
        insert csc1;
        sollist.add(csc1);
        
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

        
         CSS_Parts_Options__c parts1 = new CSS_Parts_Options__c();
        parts1.recordtypeId = recTypeIdpart;
        parts1.Option_Number__c = 'O-111';
        parts1.Service_Job__c = job.id;
        parts1.selected_part__c = true;
        parts1.FailurepartId__c = csc1.Id;
        parts1.Part_Assignment__c = 'Primary';
        parts1.Solutions__c=sol.id;
        lstparts.add(parts1);
        
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
        List<CSS_Solutions__c> solList1=new List<CSS_Solutions__c>();
        
        
        List<CSS_Solution_Component__c> solComp  = new List<CSS_Solution_Component__c>();
        List<CSS_SRT__c> srts = new List<CSS_SRT__c>();
        List<CSS_SRT__c> srtsRep = new List<CSS_SRT__c>();
        
        symList.add(sym);
        symList1.add(symQA);
        solList1.add(sol);
        
        solComp.add(csc);
        srts.add(srt) ;  
        srtsRep.add(srtRep);
        
        list<CSS_Solutions__c> solutionList = new list<CSS_Solutions__c>();
        CSS_Solutions__c solRec = new CSS_Solutions__c(Name='Solution1',Rank__c=0,Solution_Title__c='Title1',Service_Job__c=job.id,
                                                       Repair_Notes__c='Notes1',Repair_Response__c='response1',
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
        
         string json1 = '{"key":"1234","message":"This is a test","messageArg":["a","b"],"solutionNumber":"K74452217","solutionTitle":"Fault Code 122 triggered by another fault code","coreIssue":"There are some instances when a fault code is recorded, but is strongnotstrong the first fault code that should be diagnosed.  br ","modificationDate":"01022016","status":"success","verification":"strongConditionsstrong ulliTurn keyswitch ON.liliConnect INSITE electronic service tool.liulstrongActionstrongbr Check for active fault codes. ulliUse INSITE electronic service tool to read the fault codes.liulstrongSpecificationstrong ulliIf Fault Code 227, 352, or 386 is active, then perform a search on the appropriate fault and troubleshoot that fault prior to troubleshooting Fault Code 122.liul","resolution":"pPerform a search on the appropriate fault code.p","poleLogicSolution":true,"components":[{"value":"string","failureId":"string"}],"repCompoundSolutions":[{"solutionNumber":"K74452217","solutionTitle":"Fault Code 122 triggered by another fault code","coreIssue":"There are some instances when a fault code is recorded, but is strongnotstrong the first fault code that should be diagnosed.  br ","modificationDate":"01022016","status":"success","verification":"strongConditionsstrong ulliTurn keyswitch ON.liliConnect INSITE electronic service tool.liulstrongActionstrongbr Check for active fault codes. ulliUse INSITE electronic service tool to read the fault codes.liulstrongSpecificationstrong ulliIf Fault Code 227, 352, or 386 is active, then perform a search on the appropriate fault and troubleshoot that fault prior to troubleshooting Fault Code 122.liul","resolution":"pPerform a search on the appropriate fault code.p","poleLogicSolution":true,"components":[{"value":"string","failureId":"string"}]}],"verCompoundSolutions":[{"solutionNumber":"K74452217","solutionTitle":"Fault Code 122 triggered by another fault code","coreIssue":"There are some instances when a fault code is recorded, but is strongnotstrong the first fault code that should be diagnosed.  br ","modificationDate":"01022016","status":"success","verification":"strongConditionsstrong ulliTurn keyswitch ON.liliConnect INSITE electronic service tool.liulstrongActionstrongbr Check for active fault codes. ulliUse INSITE electronic service tool to read the fault codes.liulstrongSpecificationstrong ulliIf Fault Code 227, 352, or 386 is active, then perform a search on the appropriate fault and troubleshoot that fault prior to troubleshooting Fault Code 122.liul","resolution":"pPerform a search on the appropriate fault code.p","poleLogicSolution":true,"components":[{"value":"string","failureId":"string"}]}]}';
        CSS_J2ASolution_EDS rep = CSS_J2ASolution_EDS.parse(json1);
         String json123 = '{'+
    '                \"DataArea\": ['+
    '                {'+
    '                                \"ComponentCode\": \"CG\",'+
    '                                \"FailureMode\": \"\",'+
    '                                \"FailureID\": \"string\",'+
    '                                \"FailureName\": \"Accessory Plate Cover Gasket\",'+
    '                                \"SystemCode\": \"BG\"'+
    '                }],'+
    ''+
    '                \"Header\": {'+
    '                                \"ReturnCodeDescription\":\"Normal, Successful completion.\",'+
    '                                \"ReturnCode\": \"ORA-00000\",'+
    '                                \"MessageIdentifier\": \"S\"'+
    '                }'+
    '}';
    CSS_SRTComponentLookupResponseJ2A controller11 = CSS_SRTComponentLookupResponseJ2A.parse(json123);
        //j2as.failureId = '123';
        //j2as.value = 'test';
        //insert j2as;
        test.startTest();
        
        css_repair_job  cssRep = new css_repair_job();
        CSS_SymEDSRepairs extsymRep = new CSS_SymEDSRepairs(cssRep);
        extsymRep.selectedNestSolId=solRec.ID;
       extsymRep.failureCodeDetails=controller11;
        extsymRep.selectedSol = solRec;
        extsymRep.comp=sollist;
        extsymRep.selSolution='test';
        extsymRep.getSelNestSolution();
        extsymRep.addSolComponents(solRec,rep);
        test.stopTest();
    }
       
  }