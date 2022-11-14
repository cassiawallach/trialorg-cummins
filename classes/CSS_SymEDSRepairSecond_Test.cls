@isTest (SeeAllData = false)
//created this class with different data set to increase the coverage
public class CSS_SymEDSRepairSecond_Test {
    
    static testMethod void testData(){
        
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
        sol.Repair_Response__c='test';
        sol.Symptom__c=sym.id;
        sol.Service_Job__c=job.id;
        sol.rank__c=1;
        sol.Out_Of_Order__c = false;
        sol.Solution_Title__c = 'test';
        sol.Solution__c ='test';
        sol.Report_Comments__c ='qwewqewqewewqe';
        sol.Diagnostic_notes__c ='asdsadad';
        
        insert sol;
        
        //string sDetStr = '{"key":"1234","message":"This is a test","messageArg":["a","b"],"solutionNumber":"K74452217","solutionTitle":"Fault Code 122 triggered by another fault code","coreIssue":"There are some instances when a fault code is recorded, but is strongnotstrong the first fault code that should be diagnosed.  br ","modificationDate":"01022016","status":"success","verification":"strongConditionsstrong ulliTurn keyswitch ON.liliConnect INSITE electronic service tool.liulstrongActionstrongbr Check for active fault codes. ulliUse INSITE electronic service tool to read the fault codes.liulstrongSpecificationstrong ulliIf Fault Code 227, 352, or 386 is active, then perform a search on the appropriate fault and troubleshoot that fault prior to troubleshooting Fault Code 122.liul","resolution":"pPerform a search on the appropriate fault code.p","poleLogicSolution":true,"components":[{"value":"string","failureId":"string"}],"repCompoundSolutions":[{"solutionNumber":"K74452217","solutionTitle":"Fault Code 122 triggered by another fault code","coreIssue":"There are some instances when a fault code is recorded, but is strongnotstrong the first fault code that should be diagnosed.  br ","modificationDate":"01022016","status":"success","verification":"strongConditionsstrong ulliTurn keyswitch ON.liliConnect INSITE electronic service tool.liulstrongActionstrongbr Check for active fault codes. ulliUse INSITE electronic service tool to read the fault codes.liulstrongSpecificationstrong ulliIf Fault Code 227, 352, or 386 is active, then perform a search on the appropriate fault and troubleshoot that fault prior to troubleshooting Fault Code 122.liul","resolution":"pPerform a search on the appropriate fault code.p","poleLogicSolution":true,"components":[{"value":"string","failureId":"string"}]}],"verCompoundSolutions":[{"solutionNumber":"K74452217","solutionTitle":"Fault Code 122 triggered by another fault code","coreIssue":"There are some instances when a fault code is recorded, but is strongnotstrong the first fault code that should be diagnosed.  br ","modificationDate":"01022016","status":"success","verification":"strongConditionsstrong ulliTurn keyswitch ON.liliConnect INSITE electronic service tool.liulstrongActionstrongbr Check for active fault codes. ulliUse INSITE electronic service tool to read the fault codes.liulstrongSpecificationstrong ulliIf Fault Code 227, 352, or 386 is active, then perform a search on the appropriate fault and troubleshoot that fault prior to troubleshooting Fault Code 122.liul","resolution":"pPerform a search on the appropriate fault code.p","poleLogicSolution":true,"components":[{"value":"string","failureId":"string"}]}]}';
        
        
        
        CSS_Solution_Component__c csc=new CSS_Solution_Component__c();
        csc.Action__c='test';
        csc.Solutions__c=sol.id;
        csc.Service_Job__c=job.id;
        insert csc;
        
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
                                                       Repair_Notes__c='Notes1',Repair_Response__c='response1',
                                                       FaultCode__c=faulCodeRec.Id);
        solutionList.add(solRec);
        CSS_Solutions__c solRec1 = new CSS_Solutions__c(Name='Solution2',Rank__c=1,Solution_Title__c='Title2',
                                                        Repair_Notes__c='Notes2',Repair_Response__c='response2',
                                                        FaultCode__c=faulCodeRec.Id);
        
        solutionList.add(solRec1);
        insert solutionList;
        
        
        
        PageReference pageRef = new PageReference('/apex/JobTndTs?rank=1&id=');
        test.setCurrentPage(pageRef);
        ApexPages.CurrentPage().getParameters().put('fcid',faulCodeRec.Id);
        pageRef.getParameters().put('id',job.id);
        pageRef.getParameters().put('symid',sym.id);
        string sDetStr = '{"key":"1234","message":"This is a test","messageArg":["a","b"],"solutionNumber":"K74452217","solutionTitle":"Fault Code 122 triggered by another fault code","coreIssue":"There are some instances when a fault code is recorded, but is strongnotstrong the first fault code that should be diagnosed.  br ","modificationDate":"01022016","status":"success","verification":"strongConditionsstrong ulliTurn keyswitch ON.liliConnect INSITE electronic service tool.liulstrongActionstrongbr Check for active fault codes. ulliUse INSITE electronic service tool to read the fault codes.liulstrongSpecificationstrong ulliIf Fault Code 227, 352, or 386 is active, then perform a search on the appropriate fault and troubleshoot that fault prior to troubleshooting Fault Code 122.liul","resolution":"pPerform a search on the appropriate fault code.p","poleLogicSolution":true,"components":[{"value":"string","failureId":"string"}],"repCompoundSolutions":[{"solutionNumber":"K74452217","solutionTitle":"Fault Code 122 triggered by another fault code","coreIssue":"There are some instances when a fault code is recorded, but is strongnotstrong the first fault code that should be diagnosed.  br ","modificationDate":"01022016","status":"success","verification":"strongConditionsstrong ulliTurn keyswitch ON.liliConnect INSITE electronic service tool.liulstrongActionstrongbr Check for active fault codes. ulliUse INSITE electronic service tool to read the fault codes.liulstrongSpecificationstrong ulliIf Fault Code 227, 352, or 386 is active, then perform a search on the appropriate fault and troubleshoot that fault prior to troubleshooting Fault Code 122.liul","resolution":"pPerform a search on the appropriate fault code.p","poleLogicSolution":true,"components":[{"value":"string","failureId":"string"}]}],"verCompoundSolutions":[{"solutionNumber":"K74452217","solutionTitle":"Fault Code 122 triggered by another fault code","coreIssue":"There are some instances when a fault code is recorded, but is strongnotstrong the first fault code that should be diagnosed.  br ","modificationDate":"01022016","status":"success","verification":"strongConditionsstrong ulliTurn keyswitch ON.liliConnect INSITE electronic service tool.liulstrongActionstrongbr Check for active fault codes. ulliUse INSITE electronic service tool to read the fault codes.liulstrongSpecificationstrong ulliIf Fault Code 227, 352, or 386 is active, then perform a search on the appropriate fault and troubleshoot that fault prior to troubleshooting Fault Code 122.liul","resolution":"pPerform a search on the appropriate fault code.p","poleLogicSolution":true,"components":[{"value":"string","failureId":"string"}]}]}';
        //testData();
        Test.setMock(HttpCalloutMock.class, new CSS_J2ASolution_EDS_MockTest());
        test.startTest();
        css_repair_job  cssRep = new css_repair_job();
        CSS_SymEDSRepairs extsymRep = new CSS_SymEDSRepairs(cssRep);
        CSS_J2ASolution_EDS wo1 = (CSS_J2ASolution_EDS)JSON.deserializeStrict(sDetStr,CSS_J2ASolution_EDS.class);
        extsymRep.getSolutionDetails();
        extsymRep.addSolComponents(sol, wo1);
        test.stopTest();
    }
    
    
    static testMethod void testData1(){
        
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
        sol.Repair_Response__c='test';
        sol.Symptom__c=sym.id;
        sol.Service_Job__c=job.id;
        sol.rank__c=0;
        sol.Out_Of_Order__c = false;
        sol.Solution_Title__c = 'test';
        sol.Solution__c ='test';
        sol.Report_Comments__c ='qwewqewqewewqe';
        sol.Diagnostic_notes__c ='asdsadad';
        
        insert sol;
        
        PageReference pageRef = new PageReference('/apex/JobTndTs?rank=1&id=');
        test.setCurrentPage(pageRef);
        ApexPages.CurrentPage().getParameters().put('fcid',faulCodeRec.Id);
        pageRef.getParameters().put('id',job.id);
        pageRef.getParameters().put('symid',sym.id);
        string sDetStr = '{"key":"1234","message":"This is a test","messageArg":["a","b"],"solutionNumber":"K74452217","solutionTitle":"Fault Code 122 triggered by another fault code","coreIssue":"There are some instances when a fault code is recorded, but is strongnotstrong the first fault code that should be diagnosed.  br ","modificationDate":"01022016","status":"success","verification":"strongConditionsstrong ulliTurn keyswitch ON.liliConnect INSITE electronic service tool.liulstrongActionstrongbr Check for active fault codes. ulliUse INSITE electronic service tool to read the fault codes.liulstrongSpecificationstrong ulliIf Fault Code 227, 352, or 386 is active, then perform a search on the appropriate fault and troubleshoot that fault prior to troubleshooting Fault Code 122.liul","resolution":"pPerform a search on the appropriate fault code.p","poleLogicSolution":true,"components":[{"value":"string","failureId":"string"}],"repCompoundSolutions":[{"solutionNumber":"K74452217","solutionTitle":"Fault Code 122 triggered by another fault code","coreIssue":"There are some instances when a fault code is recorded, but is strongnotstrong the first fault code that should be diagnosed.  br ","modificationDate":"01022016","status":"success","verification":"strongConditionsstrong ulliTurn keyswitch ON.liliConnect INSITE electronic service tool.liulstrongActionstrongbr Check for active fault codes. ulliUse INSITE electronic service tool to read the fault codes.liulstrongSpecificationstrong ulliIf Fault Code 227, 352, or 386 is active, then perform a search on the appropriate fault and troubleshoot that fault prior to troubleshooting Fault Code 122.liul","resolution":"pPerform a search on the appropriate fault code.p","poleLogicSolution":true,"components":[{"value":"string","failureId":"string"}]}],"verCompoundSolutions":[{"solutionNumber":"K74452217","solutionTitle":"Fault Code 122 triggered by another fault code","coreIssue":"There are some instances when a fault code is recorded, but is strongnotstrong the first fault code that should be diagnosed.  br ","modificationDate":"01022016","status":"success","verification":"strongConditionsstrong ulliTurn keyswitch ON.liliConnect INSITE electronic service tool.liulstrongActionstrongbr Check for active fault codes. ulliUse INSITE electronic service tool to read the fault codes.liulstrongSpecificationstrong ulliIf Fault Code 227, 352, or 386 is active, then perform a search on the appropriate fault and troubleshoot that fault prior to troubleshooting Fault Code 122.liul","resolution":"pPerform a search on the appropriate fault code.p","poleLogicSolution":true,"components":[{"value":"string","failureId":"string"}]}]}';
     
        Test.setMock(HttpCalloutMock.class, new CSS_J2ASolution_EDS_MockTest());
        test.startTest();
        css_repair_job  cssRep = new css_repair_job();
        CSS_SymEDSRepairs extsymRep = new CSS_SymEDSRepairs(cssRep);
        CSS_J2ASolution_EDS wo1 = (CSS_J2ASolution_EDS)JSON.deserializeStrict(sDetStr,CSS_J2ASolution_EDS.class);
        //extsymRep.getSolutionDetails();
       
        test.stopTest();
    }
    
    @isTest static void testGetSolutionDetails(){
        Test.setMock(HttpCalloutMock.class, new CSS_GetSolDetails_Test());
        string caseNum = 'K21484443';
        string dsid = 'DSBDT4780';
        CSS_EDSAuthentication.getSolutionDetails(caseNum,dsid,'en',0,'O');        
    }
    
  
}