@isTest
public class CSS_DARSRT_Test {
    
    public static testMethod void testAddSRT(){ 
        
        
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02466';
        acc.IAM_Service_Provider_Code__c='19134';
        acc.Type='Dealer Account';
        acc.CMI_Account_Status__c = 'Active';
        insert acc;
        
        CSS_Job_Order__c JO1 = new CSS_Job_Order__c();
        JO1.Customer_Name__c = 'CumminsTnD';
        JO1.Equipment_ID__c = 'EQ7667';
        JO1.Qsol_Engine_Family_Code__c ='56';
        JO1.AccessCode__c = 'A';
        JO1.Account__c = acc.id;
        insert JO1;
        
        List<CSS_JobEventTemporary__c> jETList = new List<CSS_JobEventTemporary__c>();
        CSS_JobEventTemporary__c jET = new CSS_JobEventTemporary__c();
        jET.Attribute1__c = 'AB';
        jET.Attribute3__c = 'CD';
        jET.Attribute4__c = 'DSBDV5789';
        jET.Key__c = 'AccountCodes';
        jETList.add(jET);
        insert jETList;
        
        PageReference pg = Page.CSS_JobTnDRj;
        Test.setCurrentPage(pg);    
        ApexPages.currentPage().getParameters().put('id', JO1.Id);
        
        CSS_Solutions__c Sol = CSS_TestData.createSolutions(true,JO1.Id);
        
        CSS_Solution_Component__c solcomp = CSS_TestData.createSRT(true,JO1.id,sol.id);
        solcomp.System_Code__c = 'Test';
        update solcomp;
        
        CSS_SRT__C srt = new CSS_SRT__C();
        srt.Solution_Number__c = Sol.id;
        srt.Job_Order__c = JO1.id;
        srt.SRT_AccessiblityCheck__c=True;
        srt.Access_Code_A__c = 65;
        srt.name = 'TestClassName';
        srt.type__c = 'Diagnosis';
        srt.Assignment__c = 'PRIMARY';
        srt.srt_time__c = 1;
        srt.SRT_ID__c = '00-901-10';
        srt.Component_id__c = solcomp.id;
        srt.isPerformed__c = true;
        srt.Account_Code__c = 'Select One';
        srt.SRT_Warrantable__c ='';
        srt.FailCode__c = 'Select One';
        insert srt;
        
        
        decimal time1 = [select id,Repair_Access_Calculated__c from css_srt__c where id = :srt.id].Repair_Access_Calculated__c;
        
        CSS_SRT__C srtRef = new CSS_SRT__C();
        srtRef.Solution_Number__c = sol.id;
        srtRef.Job_Order__c = JO1.id;
        srtRef.SRT_AccessiblityCheck__c=True;
        srtRef.Access_Code_A__c = 65;
        srtRef.name = 'TestClassName';
        srtRef.type__c = 'Repair';
        srtRef.SRT_ID__c = '00-901-10';
        srtRef.SRT_Time__c = 0.4;
        srtRef.Component_id__c = solcomp.id;
        srtRef.isPerformed__c = true;
        srtRef.Account_Code__c = 'Emissions Warranty 70';
        insert srtRef;
        
        CSS_SRT__C srtRef1 = new CSS_SRT__C();
        srtRef1.Solution_Number__c = null;
        srtRef1.Job_Order__c = JO1.id;
        srtRef1.SRT_AccessiblityCheck__c=True;
        srtRef1.Access_Code_A__c = 65;
        srtRef1.name = 'TestClassName1';
        srtRef1.type__c = 'Repair';
        srtRef1.SRT_ID__c = '00-901-01';
        srtRef1.srt_time__c = 0.2;
        srtRef1.Component_id__c = solcomp.id;
        srtRef1.isPerformed__c = true;
        srtRef1.Account_Code__c = 'Emissions Warranty 70';
        insert srtRef1;
        
        PageReference pg1 = Page.CSS_JobTnDRj;
        Test.setCurrentPage(pg1);    
        Id JobID = ApexPages.currentPage().getParameters().put('id', JO1.Id);   
        
        
        
        CSS_DARSRT srta = new CSS_DARSRT(); 
        srta.searchDiagValue = 'Administrative';
        srta.selectedSolId = Sol.Id;
        srta.selectedSrtId=srt.id;
        test.startTest();
        
        Test.setMock(HttpCalloutMock.class, new CSS_AccessToken_SRT_Test());
        Test.setMock(HttpCalloutMock.class, new CSS_getAllRepDiagSRTs_Test());
        
        srta.searchDiagValue = 'Administrative';
        srta.countDiag = 1;
        srta.getsVfComp();
        srta.getAllACS();
        srta.changeDownOrder();
        srta.setsVfComp(JO1.id);           
        //srta.onChangeAccountCode();
        
        test.stopTest();
    }
    
    public static testMethod void testDarSRTMoreTime(){
        
        //Covers Anirudh 2 diagList
        Test.startTest(); 
        
        List<CSS_Srt__c> additionalSRTList = new List<CSS_Srt__c>();        
        
        Account acc = new Account();
        acc.Name = 'test';
        acc.Type = 'Dealer Account';
        insert acc;
        
        CSS_Job_Order__c JO = new CSS_Job_Order__c();
        JO.Customer_Name__c = 'CumminsTnD';
        JO.Account__c = acc.id;
        JO.Equipment_ID__c = 'EQ7667';
        JO.Qsol_Engine_Family_Code__c ='56';
        JO.AccessCode__c = 'A';
        insert JO;
        
        Map<Id, Boolean> mpb = new Map<Id, Boolean>{JO.Id=>true};
            
            CSS_Solutions__c sol = new CSS_Solutions__c();
        sol.Service_Job__c = JO.ID;
        sol.Case_Name__c = 'ABC';
        sol.Solution_Title__c='CDE';
        sol.Name='ABC';
        //sol.Diagnostic_Response__c ='Most likely the solution';
        //sol.Repair_Response__c = 'Most likely';
        insert sol;
        
        CSS_Solutions__c solAdd = new CSS_Solutions__c();
        solAdd.Service_Job__c = JO.ID;
        solAdd.Case_Name__c = 'Additional SRTS';
        solAdd.Solution_Title__c='Additional SRTS';
        solAdd.Name='Additional SRTS';
        solAdd.Diagnostic_Response__c ='Most likely the solution';
        solAdd.Repair_Response__c = 'Most likely ';
        insert solAdd;
        
        CSS_SRT__C srtVar = new CSS_SRT__C();
        srtVar.Solution_Number__c = sol.id;
        srtVar.Job_Order__c = JO.id;
        srtVar.SRT_AccessiblityCheck__c=True;
        srtVar.Access_Code_A__c = 65;
        srtVar.name = 'Test';
        srtVar.SRT_ID__c = 'test';
        srtVar.Type__c = 'Diagnosis';
        srtVar.isPerformed__c =True;
        srtVar.Account_Code__c = 'Emissions Warranty 70';
        srtVar.SRT_Warrantable__c ='';
        insert srtVar;
        
        CSS_SRT__C srtVar1 = new CSS_SRT__C();
        srtVar1.Solution_Number__c = null;
        srtVar1.Job_Order__c = JO.id;
        srtVar1.SRT_AccessiblityCheck__c=True;
        srtVar1.Access_Code_A__c = 65;
        srtVar1.name = 'Test';
        srtVar1.SRT_ID__c = 'test';
        srtVar1.Account_Code__c = 'Emissions Warranty 70';
        srtVar1.Type__c = 'Diagnosis';
        srtVar1.isPerformed__c =True;
        srtVar1.SRT_Warrantable__c ='';
        insert srtVar1;
        additionalSRTList.add(srtVar);
        additionalSRTList.add(srtVar1);
        
        CSS_Solution_Component__c solComp = new CSS_Solution_Component__c();
        solComp.Component_Id__c ='F0051000';
        solComp.Service_Job__c = JO.id;
        solComp.Solutions__c = sol.id;
        solComp.Selected_Component__c = true;
        solComp.System_Code__c = 'TH';
        solComp.Component_Code__c = 'AC';
        solComp.AccountCodeType__c  = 'Emissions Warranty';
        solComp.AccountCode__c = '70';
        solComp.AccountCodeEdit__c = 'Emissions Warranty70';
        insert solComp;
        
        CSS_Solution_Component__c AddsolComp = new CSS_Solution_Component__c();
        AddsolComp.Component_Id__c ='F0051000';
        AddsolComp.Service_Job__c = JO.id;
        AddsolComp.Solutions__c = soladd.id;
        AddsolComp.Name = 'Additional Components';
        AddsolComp.Selected_Component__c = true;
        AddsolComp.System_Code__c = 'TH';
        AddsolComp.Component_Code__c = 'AC';
        AddsolComp.AccountCodeType__c  = 'Emissions Warranty';
        AddsolComp.AccountCode__c = '70';
        AddsolComp.AccountCodeEdit__c = 'Emissions Warranty70';
        insert AddsolComp;
        
        CSS_SRT__C srtRep = new CSS_SRT__C();
        srtRep.Solution_Number__c = sol.id;
        srtRep.Job_Order__c = JO.id;
        srtRep.Component_Id__c = solComp.id;
        srtRep.SRT_Time__c = 465;
        srtRep.name = 'Test';
        srtRep.Type__c = 'Repair';
        srtRep.SRT_Order__c = 1;
        srtRep.Account_Code__c = 'Emissions Warranty 70';
        insert srtRep;
        
        CSS_SRT__C srtDiagAccess = new CSS_SRT__C();
        srtDiagAccess.Solution_Number__c = sol.id;
        srtDiagAccess.Job_Order__c = JO.id;
        srtDiagAccess.SRT_AccessiblityCheck__c=True;
        srtDiagAccess.SRT_Time__c = 56;
        srtDiagAccess.name = 'Test';
        srtDiagAccess.Type__c = 'Diag Access';
        srtDiagAccess.Account_Code__c = 'Emissions Warranty 70';
        srtDiagAccess.SRT_AccessiblityCheck__c = true;
        insert srtDiagAccess;
        
        CSS_SRT__C srtRepAccess = new CSS_SRT__C();
        srtRepAccess.Solution_Number__c = sol.id;
        srtRepAccess.SRT_AccessiblityCheck__c=True;
        srtRepAccess.SRT_Time__c = 66;
        srtRepAccess.Job_Order__c = JO.id;
        srtRepAccess.name = 'Test';
        srtRepAccess.Type__c = 'Repair Access';
        srtRepAccess.Account_Code__c = 'Emissions Warranty 70';
        insert srtRepAccess;
        
        
        CSS_SRT__C srtAddiRepAccess = new CSS_SRT__C();
        srtAddiRepAccess.Solution_Number__c = solAdd.id;
        srtAddiRepAccess.SRT_AccessiblityCheck__c=True;
        srtAddiRepAccess.SRT_Time__c = 8656;
        srtAddiRepAccess.SRT_Quantity__c=1;
        srtAddiRepAccess.Job_Order__c = JO.id;
        srtAddiRepAccess.name = 'Test';
        srtAddiRepAccess.Type__c = 'Repair Access';
        srtAddiRepAccess.Account_Code__c = 'Emissions Warranty 70';
        insert srtAddiRepAccess;
        
        
        CSS_SRT__C srtAddiDiagAccess = new CSS_SRT__C();
        srtAddiDiagAccess.Solution_Number__c = NULL;
        srtAddiDiagAccess.SRT_AccessiblityCheck__c=True;
        srtAddiDiagAccess.SRT_Time__c = 8655;
        srtAddiDiagAccess.Job_Order__c = JO.id;
        srtAddiDiagAccess.name = 'Test';
        srtAddiDiagAccess.Type__c = 'Repair Access';
        srtAddiDiagAccess.Account_Code__c = 'Emissions Warranty 70';
        insert srtAddiDiagAccess;
        
        additionalSRTList.add(srtRep);
        additionalSRTList.add(srtDiagAccess);
        additionalSRTList.add(srtRepAccess);
        additionalSRTList.add(srtAddiRepAccess);
        additionalSRTList.add(srtAddiDiagAccess);
        
        List<CSS_SRT__c> repList2 = new List<CSS_SRT__c>();
        repList2.add(srtRepAccess);
        repList2.add(srtRepAccess);
        
        CSS_DARSRT.sortWrapper sortwrap = new CSS_DARSRT.sortWrapper(srtRep);
        sortwrap.compareTo(sortwrap);
        
        CSS_DARSRT.compWrapper compwrap = new CSS_DARSRT.compWrapper();
        compwrap.additionalSRT = additionalSRTList;
        compwrap.srtCount = 5;
        compwrap.compName = 'FS100000';
        
        compwrap.compenentId = solComp.Id;
        compwrap.percentagewarranty  = '7';
        compwrap.repairList  = repList2;    
        
        list<CSS_DARSRT.compWrapper> lstCompWrap = new list<CSS_DARSRT.compWrapper>();
        
        List<CSS_DARSRT.srtWrapper> repList = new List<CSS_DARSRT.srtWrapper>();
        CSS_DARSRT.srtWrapper srtwrap = new CSS_DARSRT.srtWrapper();
        srtwrap.percentagewarranty = 'Test';
        srtwrap.fautCodeName = 'Testing';
        srtwrap.solTitle='Test1';
        srtwrap.solNum='Test2';
        srtwrap.privatesolNum='Test3';
        srtwrap.symptomName='Test4';
        srtwrap.showHeader=True;
        srtwrap.AccessCodeSaved = 'AccessCodeSaved';
        srtwrap.SRTAccessCode = 'SRTAccessCode';
        srtwrap.AccessCode ='AccessCode';
        srtwrap.EquipmentID='EquipmentID';
        srtwrap.AccessCodeA ='AccessCodeA';
        repList.add(srtwrap);
        
        PageReference pg = Page.CSS_JobTnDRj;
        Test.setCurrentPage(pg);    
        ApexPages.currentPage().getParameters().put('id', JO.Id);        
        CSS_DARSRT srt = new CSS_DARSRT();
        srt.diagTotal = true;
        srt.JobID =JO.id;
        srt.isDealerUser = true;
        Test.setMock(HttpCalloutMock.class, new CSS_getAllRepDiagSRTs_Test());
        
        
        
        //  srt.getdiagnosisTime();
        srt.changeDownOrder();
        srt.getdiagAccessTime();
        srt.saveDiagData();
        srt.saveRepairData();       
        srt.showPopup();
        srt.showPopup1();
        srt.getallData();
        srt.searchValue = 'Repair';
        srt.changeUpOrder();
        srt.lstSRT_VS = additionalSRTList;
        srt.repairTime = '455';
        srt.selected1 = mpb;
        //srt.onChangeAccountCode();
        srt.CompareFailCodes();
        srt.isSRTFC=true;
        srt.seltdSolId='test';
        
        Test.stopTest();     
    }
    
    public static testMethod void testDarSRTMoreTime_1(){
        
        //Covers Anirudh 2 diagList and Outside For Loop
        Test.startTest(); 
        
        List<CSS_Srt__c> additionalSRTList = new List<CSS_Srt__c>();        
        
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02466';
        acc.IAM_Service_Provider_Code__c='19134';
        acc.Type='Dealer Account';
        acc.CMI_Account_Status__c = 'Active';
        insert acc;

        CSS_Job_Order__c JO = new CSS_Job_Order__c();
        JO.Customer_Name__c = 'CumminsTnD';
        JO.Equipment_ID__c = 'EQ7667';
        JO.Qsol_Engine_Family_Code__c ='56';
        JO.AccessCode__c = 'A';
        JO.Account__c = acc.id;
        insert JO;
        
        Map<Id, Boolean> mpb = new Map<Id, Boolean>{JO.Id=>true};
            
            CSS_Solutions__c sol = new CSS_Solutions__c();
        sol.Service_Job__c = JO.ID;
        sol.Case_Name__c = 'ABC';
        sol.Solution_Title__c='CDE';
        sol.Name='ABC';
        //sol.Diagnostic_Response__c ='Most likely the solution';
        //sol.Repair_Response__c = 'Most likely';
        insert sol;
        
        CSS_Solutions__c solAdd = new CSS_Solutions__c();
        solAdd.Service_Job__c = JO.ID;
        solAdd.Case_Name__c = 'Additional SRTS';
        solAdd.Solution_Title__c='Additional SRTS';
        solAdd.Name='Additional SRTS';
        solAdd.Diagnostic_Response__c ='Most likely the solution';
        solAdd.Repair_Response__c = 'Most likely ';
        insert solAdd;
        
        
        
        CSS_Solution_Component__c solComp = new CSS_Solution_Component__c();
        solComp.Component_Id__c ='F0051000';
        solComp.Service_Job__c = JO.id;
        solComp.Solutions__c = sol.id;
        solComp.CoveredLaborHrs__c = '12';
        solComp.Selected_Component__c = true;
        solComp.System_Code__c = 'TH';
        solComp.Component_Code__c = 'AC';
        solComp.AccountCodeType__c  = 'Emissions Warranty';
        solComp.AccountCode__c = '70';
        solComp.AccountCodeEdit__c = 'Emissions Warranty70';
        insert solComp;
        
        CSS_Solution_Component__c AddsolComp = new CSS_Solution_Component__c();
        AddsolComp.Component_Id__c ='F0051111';
        AddsolComp.Service_Job__c = JO.id;
        AddsolComp.Solutions__c = soladd.id;
        AddsolComp.Name = 'Additional Components';
        AddsolComp.Selected_Component__c = true;
        AddsolComp.System_Code__c = 'TH';
        AddsolComp.Component_Code__c = 'AC';
        AddsolComp.AccountCodeType__c  = 'Emissions Warranty';
        AddsolComp.AccountCode__c = '70';
        AddsolComp.AccountCodeEdit__c = 'Emissions Warranty70';
        insert AddsolComp;
        
        CSS_SRT__C srtRep = new CSS_SRT__C();
        srtRep.Solution_Number__c = sol.id;
        srtRep.Job_Order__c = JO.id;
        srtRep.Component_Id__c = solComp.id;
        srtRep.SRT_Time__c = 465;
        srtRep.name = 'Test';
        srtRep.Type__c = 'Repair';
        srtRep.SRT_Order__c = 1;
        srtRep.Account_Code__c = 'Emissions Warranty 70';
        insert srtRep;
    
        CSS_SRT__C srtRepAccess = new CSS_SRT__C();
        srtRepAccess.Solution_Number__c = sol.id;
        srtRepAccess.SRT_AccessiblityCheck__c=True;
        srtRepAccess.SRT_Time__c = 665;
        srtRepAccess.Job_Order__c = JO.id;
        srtRepAccess.name = 'Test';
        srtRepAccess.Type__c = 'Repair Access';
        srtRepAccess.Account_Code__c = 'Emissions Warranty 70';
        srtRepAccess.Component_Id__c = solComp.id;
        insert srtRepAccess;
        
        
        CSS_SRT__C srtAddiRepAccess = new CSS_SRT__C();
        srtAddiRepAccess.Solution_Number__c = solAdd.id;
        srtAddiRepAccess.SRT_AccessiblityCheck__c=True;
        srtAddiRepAccess.SRT_Time__c = 865;
        srtAddiRepAccess.SRT_Quantity__c=1;
        srtAddiRepAccess.Job_Order__c = JO.id;
        srtAddiRepAccess.name = 'Test';
        srtAddiRepAccess.Type__c = 'Repair';
        srtAddiRepAccess.Account_Code__c = 'Emissions Warranty 70';
        srtAddiRepAccess.Component_Id__c = AddsolComp.id;
        srtAddiRepAccess.Assignment__c = 'Primary';
        insert srtAddiRepAccess;
        
        
        additionalSRTList.add(srtRep);
        additionalSRTList.add(srtRepAccess);
        additionalSRTList.add(srtAddiRepAccess);
        
        List<CSS_SRT__c> repList2 = new List<CSS_SRT__c>();
        repList2.add(srtRepAccess);
        repList2.add(srtRepAccess);
        
        CSS_DARSRT.sortWrapper sortwrap = new CSS_DARSRT.sortWrapper(srtRep);
        sortwrap.compareTo(sortwrap);
        
        CSS_DARSRT.compWrapper compwrap = new CSS_DARSRT.compWrapper();
        compwrap.additionalSRT = additionalSRTList;
        compwrap.srtCount = 5;
        compwrap.compName = 'FS100000';
        
        compwrap.compenentId = solComp.Id;
        compwrap.percentagewarranty  = '7';
        compwrap.repairList  = repList2;    
        
        list<CSS_DARSRT.compWrapper> lstCompWrap = new list<CSS_DARSRT.compWrapper>();
        
        List<CSS_DARSRT.srtWrapper> repList = new List<CSS_DARSRT.srtWrapper>();
        CSS_DARSRT.srtWrapper srtwrap = new CSS_DARSRT.srtWrapper();
        
        PageReference pg = Page.CSS_JobRepair;
        Test.setCurrentPage(pg);    
        ApexPages.currentPage().getParameters().put('id', JO.Id);        
        CSS_DARSRT srt = new CSS_DARSRT();
        srt.diagTotal = true;
        srt.JobID =JO.id;
        srt.isDealerUser = false;
        srt.Territory = 'test';
        Test.setMock(HttpCalloutMock.class, new CSS_getAllRepDiagSRTs_Test());
        //   srt.getdiagnosisTime();
        srt.getdiagAccessTime();
        srt.saveDiagData();
        srt.saveRepairData();   
        srt.getrepairTime();
        srt.getRepairAccessTime();
        srt.selectedSrtId = srtRep.id;
        srt.selectedSolId=solAdd.id;
        
        srt.onChangeRepAccountCode();
        srt.showPopup();
        srt.showPopup1();
        srt.getallData();
        srt.searchValue = 'Repair';
        srt.changeUpOrder();
        srt.lstSRT_VS = additionalSRTList;
        srt.repairTime = '455';
        srt.selected1 = mpb;
        srt.onChangeAccountCode();
        srt.CompareFailCodes();
        //srt.etAccountCodeOptionList();
        
        Test.stopTest();     
    }
    
    public static testMethod void testDarSRTMoreTime_2(){
        
        //Covers Anirudh 2 diagList
        Test.startTest(); 
        
        List<CSS_Srt__c> additionalSRTList = new List<CSS_Srt__c>();        
        
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02466';
        acc.IAM_Service_Provider_Code__c='19134';
        acc.Type='Dealer Account';
        acc.CMI_Account_Status__c = 'Active';
        insert acc;
        
        CSS_Job_Order__c JO = new CSS_Job_Order__c();
        JO.Customer_Name__c = 'CumminsTnD';
        JO.Equipment_ID__c = 'EQ7667';
        JO.Qsol_Engine_Family_Code__c ='56';
        JO.AccessCode__c = 'A';
        JO.Account__c = acc.id;
        insert JO;
        
        Map<Id, Boolean> mpb = new Map<Id, Boolean>{JO.Id=>true};
            
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
        
        
        
        CSS_Solution_Component__c solComp = new CSS_Solution_Component__c();
        solComp.Component_Id__c ='F0051000';
        solComp.Service_Job__c = JO.id;
        solComp.Solutions__c = sol.id;
        solComp.Selected_Component__c = true;
        solComp.System_Code__c = 'TH';
        solComp.Component_Code__c = 'AC';
        solComp.AccountCodeType__c  = 'Emissions Warranty';
        solComp.AccountCode__c = '70';
        solComp.AccountCodeEdit__c = 'Emissions Warranty70';
        insert solComp;
        
        CSS_Solution_Component__c AddsolComp = new CSS_Solution_Component__c();
        AddsolComp.Component_Id__c ='F0051000';
        AddsolComp.Service_Job__c = JO.id;
        AddsolComp.Solutions__c = soladd.id;
        AddsolComp.Name = 'Additional Components';
        AddsolComp.Selected_Component__c = true;
        AddsolComp.System_Code__c = 'TH';
        AddsolComp.Component_Code__c = 'AC';
        AddsolComp.AccountCodeType__c  = 'Emissions Warranty';
        AddsolComp.AccountCode__c = '70';
        AddsolComp.AccountCodeEdit__c = 'Emissions Warranty70';
        insert AddsolComp;
        
        CSS_SRT__C srtRep = new CSS_SRT__C();
        srtRep.Solution_Number__c = sol.id;
        srtRep.Job_Order__c = JO.id;
        srtRep.Component_Id__c = solComp.id;
        srtRep.SRT_Time__c = 465;
        srtRep.name = 'Test';
        srtRep.Type__c = 'Repair';
        srtRep.SRT_Order__c = 1;
        srtRep.Account_Code__c = 'Emissions Warranty 70';
        insert srtRep;
        
        CSS_SRT__C srtRepAccess = new CSS_SRT__C();
        srtRepAccess.Solution_Number__c = sol.id;
        srtRepAccess.SRT_AccessiblityCheck__c=True;
        srtRepAccess.SRT_Time__c = 665;
        srtRepAccess.Job_Order__c = JO.id;
        srtRepAccess.name = 'Test';
        srtRepAccess.Type__c = 'Repair Access';
        srtRepAccess.Account_Code__c = 'Emissions Warranty 70';
        insert srtRepAccess;
        
        
        CSS_SRT__C srtAddiRepAccess = new CSS_SRT__C();
        srtAddiRepAccess.Solution_Number__c = solAdd.id;
        srtAddiRepAccess.SRT_AccessiblityCheck__c=True;
        srtAddiRepAccess.SRT_Time__c = 865;
        srtAddiRepAccess.SRT_Quantity__c=1;
        srtAddiRepAccess.Job_Order__c = JO.id;
        srtAddiRepAccess.name = 'Test';
        srtAddiRepAccess.Type__c = 'Repair Access';
        srtAddiRepAccess.Account_Code__c = 'Emissions Warranty 70';
        insert srtAddiRepAccess;
        
        
        additionalSRTList.add(srtRep);
        additionalSRTList.add(srtRepAccess);
        additionalSRTList.add(srtAddiRepAccess);
        
        List<CSS_SRT__c> repList2 = new List<CSS_SRT__c>();
        repList2.add(srtRepAccess);
        repList2.add(srtRepAccess);
        
        CSS_DARSRT.sortWrapper sortwrap = new CSS_DARSRT.sortWrapper(srtRep);
        sortwrap.compareTo(sortwrap);
        
        CSS_DARSRT.compWrapper compwrap = new CSS_DARSRT.compWrapper();
        compwrap.additionalSRT = additionalSRTList;
        compwrap.srtCount = 5;
        compwrap.compName = 'FS100000';
        
        compwrap.compenentId = solComp.Id;
        compwrap.percentagewarranty  = '7';
        compwrap.repairList  = repList2;    
       // compwrap.counting=12;
        list<CSS_DARSRT.compWrapper> lstCompWrap = new list<CSS_DARSRT.compWrapper>();
        
        List<CSS_DARSRT.srtWrapper> repList = new List<CSS_DARSRT.srtWrapper>();
        CSS_DARSRT.srtWrapper srtwrap = new CSS_DARSRT.srtWrapper();
        
        PageReference pg = Page.css_srtEditPopup;
        Test.setCurrentPage(pg);    
        ApexPages.currentPage().getParameters().put('id', JO.Id);        
        CSS_DARSRT srt = new CSS_DARSRT();
        srt.diagTotal = true;
        srt.JobID =JO.id;
        Test.setMock(HttpCalloutMock.class, new CSS_getAllRepDiagSRTs_Test());
        //  srt.getdiagnosisTime();
        srt.getdiagAccessTime();
        srt.saveDiagData();
        srt.saveRepairData();       
        srt.showPopup();
        srt.showPopup1();
        srt.getallData();
        srt.searchValue = 'Repair';
        srt.changeUpOrder();
        srt.lstSRT_VS = additionalSRTList;
        srt.repairTime = '455';
        srt.selected1 = mpb;
        //srt.onChangeAccountCode();
        srt.CompareFailCodes();
        
        Test.stopTest();     
    }
    
    public static testMethod void testDarSRTMoreTime_3(){
        
        //Covers Anirudh 2 diagList
        Test.startTest(); 
        
        List<CSS_Srt__c> additionalSRTList = new List<CSS_Srt__c>(); 
        
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02466';
        acc.IAM_Service_Provider_Code__c='19134';
        acc.Type='Dealer Account';
        acc.CMI_Account_Status__c = 'Active';
        insert acc;
        
        CSS_Job_Order__c JO = new CSS_Job_Order__c();
        JO.Customer_Name__c = 'CumminsTnD';
        JO.Equipment_ID__c = 'EQ7667';
        JO.Qsol_Engine_Family_Code__c ='56';
        JO.AccessCode__c = 'A';
        JO.Account__c = acc.id;
        insert JO;
        
        Map<Id, Boolean> mpb = new Map<Id, Boolean>{JO.Id=>true};
            
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
        
        CSS_Solution_Component__c AddsolComp = new CSS_Solution_Component__c();
        AddsolComp.Component_Id__c ='F0051000';
        AddsolComp.Service_Job__c = JO.id;
        AddsolComp.Solutions__c = soladd.id;
        AddsolComp.Name = 'Additional Components';
        AddsolComp.Selected_Component__c = true;
        AddsolComp.System_Code__c = 'TH';
        AddsolComp.Component_Code__c = 'AC';
        AddsolComp.AccountCodeType__c  = 'Emissions Warranty';
        AddsolComp.AccountCode__c = '70';
        AddsolComp.AccountCodeEdit__c = 'Emissions Warranty70';
        insert AddsolComp;
        
        CSS_SRT__C srtRep = new CSS_SRT__C();
        srtRep.Solution_Number__c = sol.id;
        srtRep.Job_Order__c = JO.id;
        srtRep.Component_Id__c = AddsolComp.id;
        srtRep.SRT_Time__c = 465;
        srtRep.name = 'Test';
        srtRep.Type__c = 'Repair';
        srtRep.SRT_Order__c = 1;
        srtRep.Account_Code__c = 'Emissions Warranty 70';
        srtRep.Assignment__c = 'Primary';
        insert srtRep;
       
        CSS_SRT__C srtAddiRepAccess = new CSS_SRT__C();
        srtAddiRepAccess.Solution_Number__c = solAdd.id;
        srtAddiRepAccess.SRT_AccessiblityCheck__c=True;
        srtAddiRepAccess.SRT_Time__c = 8656;
        srtAddiRepAccess.SRT_Quantity__c=1;
        srtAddiRepAccess.Job_Order__c = JO.id;
        srtAddiRepAccess.name = 'Test';
        srtAddiRepAccess.Type__c = 'Repair Access';
        srtAddiRepAccess.Account_Code__c = 'Emissions Warranty 70';
        srtAddiRepAccess.Component_Id__c = AddsolComp.id;
        srtAddiRepAccess.Assignment__c = 'Primary';
        insert srtAddiRepAccess;
        
        CSS_SRT__C srtAddiRepAccess1 = new CSS_SRT__C();
        srtAddiRepAccess1.Solution_Number__c = solAdd.id;
        srtAddiRepAccess1.SRT_AccessiblityCheck__c=True;
        srtAddiRepAccess1.SRT_Time__c = 8656;
        srtAddiRepAccess1.SRT_Quantity__c=1;
        srtAddiRepAccess1.Job_Order__c = JO.id;
        srtAddiRepAccess1.name = 'Test';
        srtAddiRepAccess1.Type__c = 'Repair';
        srtAddiRepAccess1.Account_Code__c = 'Emissions Warranty 70';
        srtAddiRepAccess1.Component_Id__c = AddsolComp.id;
        srtAddiRepAccess1.Assignment__c = 'Primary';
        insert srtAddiRepAccess1;
        
        
        additionalSRTList.add(srtRep);
        //additionalSRTList.add(srtRepAccess);
        additionalSRTList.add(srtAddiRepAccess);
        additionalSRTList.add(srtAddiRepAccess1);
        
        List<CSS_SRT__c> repList2 = new List<CSS_SRT__c>();
        //repList2.add(srtRepAccess);
        //repList2.add(srtRepAccess);
        
        CSS_DARSRT.sortWrapper sortwrap = new CSS_DARSRT.sortWrapper(srtRep);
        sortwrap.compareTo(sortwrap);
        
        CSS_DARSRT.compWrapper compwrap = new CSS_DARSRT.compWrapper();
        compwrap.additionalSRT = additionalSRTList;
        compwrap.srtCount = 5;
        compwrap.compName = 'FS100000';
        
        compwrap.compenentId = AddsolComp.Id;
        compwrap.percentagewarranty  = '7';
        compwrap.repairList  = repList2;    
        
        list<CSS_DARSRT.compWrapper> lstCompWrap = new list<CSS_DARSRT.compWrapper>();
        
        List<CSS_DARSRT.srtWrapper> repList = new List<CSS_DARSRT.srtWrapper>();
        CSS_DARSRT.srtWrapper srtwrap = new CSS_DARSRT.srtWrapper();
        
        PageReference pg = Page.css_srtEditPopup;
        Test.setCurrentPage(pg);    
        ApexPages.currentPage().getParameters().put('id', JO.Id);        
        CSS_DARSRT srt = new CSS_DARSRT();
        srt.diagTotal = true;
        srt.JobID =JO.id;
        Test.setMock(HttpCalloutMock.class, new CSS_getAllRepDiagSRTs_Test());
        //  srt.getdiagnosisTime();
        srt.getdiagAccessTime();
        srt.saveDiagData();
        srt.saveRepairData();       
        srt.showPopup();
        srt.showPopup1();
        srt.getallData();
        srt.searchValue = 'Repair';
        srt.changeUpOrder();
        srt.lstSRT_VS = additionalSRTList;
        srt.repairTime = '455';
        srt.selected1 = mpb;
        //srt.onChangeAccountCode();
        srt.CompareFailCodes();
        
        Test.stopTest();     
    }
    
    public static testMethod void testDarSRTMoreTime_4(){
        
        //Covers Anirudh 2 diagList
        Test.startTest(); 
        
        List<CSS_Srt__c> additionalSRTList = new List<CSS_Srt__c>();        
        
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02466';
        acc.IAM_Service_Provider_Code__c='19134';
        acc.Type='Dealer Account';
        acc.CMI_Account_Status__c = 'Active';
        insert acc;
        
        CSS_Job_Order__c JO = new CSS_Job_Order__c();
        JO.Customer_Name__c = 'CumminsTnD';
        JO.Equipment_ID__c = 'EQ7667';
        JO.Qsol_Engine_Family_Code__c ='56';
        JO.AccessCode__c = 'A';
        JO.Account__c = acc.id;
        insert JO;
        
        Map<Id, Boolean> mpb = new Map<Id, Boolean>{JO.Id=>true};
            
            
            
        CSS_SRT__C srtRep = new CSS_SRT__C();
        srtRep.Job_Order__c = JO.id;
        srtRep.SRT_Time__c = 465;
        srtRep.name = 'Test';
        srtRep.Type__c = 'Primary';
        srtRep.SRT_AccessiblityCheck__c = true;
        srtRep.isPerformed__c = true;
        srtRep.SRT_Order__c = 1;
        srtRep.Account_Code__c = 'Emissions Warranty 70';
        srtRep.Assignment__c = 'Primary';
        srtRep.srt_category__c = 'AdditionalDiag';
        insert srtRep;
        
        
        CSS_SRT__C srtAddiRepAccess = new CSS_SRT__C();
        srtAddiRepAccess.SRT_AccessiblityCheck__c=True;
        srtAddiRepAccess.SRT_Time__c = 865;
        srtAddiRepAccess.SRT_Quantity__c=1;
        srtAddiRepAccess.Job_Order__c = JO.id;
        srtAddiRepAccess.name = 'Test';
        srtAddiRepAccess.Type__c = 'Repair Access';
        //srtAddiRepAccess.Account_Code__c = 'Emissions Warranty 70';
        srtAddiRepAccess.Assignment__c = 'Primary';
        srtAddiRepAccess.srt_category__c = 'AdditionalDiag';
        insert srtAddiRepAccess;
        
        CSS_SRT__C srtAddiRepAccess2 = new CSS_SRT__C();
        srtAddiRepAccess2.isPerformed__c=True;
        srtAddiRepAccess2.SRT_Time__c = 865;
        srtAddiRepAccess2.SRT_Quantity__c=1;
        srtAddiRepAccess2.Job_Order__c = JO.id;
        srtAddiRepAccess2.name = 'Test';
        srtAddiRepAccess2.Type__c = 'Private';
        srtAddiRepAccess2.Access_Code__c='A';
        srtAddiRepAccess2.Access_Code_A__c=1.0;
        //srtAddiRepAccess.Account_Code__c = 'Emissions Warranty 70';
        srtAddiRepAccess2.Assignment__c = 'Primary';
        srtAddiRepAccess2.srt_category__c = 'AdditionalDiag';
        insert srtAddiRepAccess2;
        
        CSS_SRT__C srtAddiRepAccess1 = new CSS_SRT__C();
        srtAddiRepAccess1.SRT_AccessiblityCheck__c=True;
        srtAddiRepAccess1.SRT_Time__c = 865;
        srtAddiRepAccess1.SRT_Quantity__c=1;
        srtAddiRepAccess1.Job_Order__c = JO.id;
        srtAddiRepAccess1.name = 'Test';
        srtAddiRepAccess1.Type__c = 'Repair';
        srtAddiRepAccess1.Account_Code__c = 'Emissions Warranty 70';
        srtAddiRepAccess1.Assignment__c = 'Primary';
        srtAddiRepAccess1.srt_category__c = 'AdditionalRep';
        insert srtAddiRepAccess1;
        
        
        additionalSRTList.add(srtRep);
        additionalSRTList.add(srtAddiRepAccess);
        additionalSRTList.add(srtAddiRepAccess1);
        additionalSRTList.add(srtAddiRepAccess2);
        
        
        ApexPages.currentPage().getParameters().put('id', JO.Id);        
        CSS_DARSRT srt = new CSS_DARSRT();
        srt.selectedSrtId = srtAddiRepAccess2.id;
        //srt.getrepairTime();
        // srt.getRepairAccessTime();
        //Test.setMock(HttpCalloutMock.class, new CSS_MockOverlapSRT_Test());
        srt.saveRepairData(); 
        srt.onChangeRepAccountCode();
        
        Test.stopTest();     
    }
    
    public static testMethod void CSS_DARSRT_Test_Method_1(){
        
        //Covers diag response != null
        Test.startTest(); 
        
        List<CSS_Srt__c> additionalSRTList = new List<CSS_Srt__c>(); 
        
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02466';
        acc.IAM_Service_Provider_Code__c='19134';
        acc.Type='Dealer Account';
        acc.CMI_Account_Status__c = 'Active';
        insert acc;
            
        CSS_Job_Order__c JO = new CSS_Job_Order__c();
        JO.Customer_Name__c = 'CumminsTnD';
        JO.Equipment_ID__c = 'EQ7667';
        JO.Qsol_Engine_Family_Code__c ='56';
        JO.AccessCode__c = 'A';
        JO.Account__c = acc.id;
        insert JO; 
        
        css_claims__c claims = new css_claims__C();
        claims.Customer_Name__c='Oliver Trucking';
        claims.Account__c = acc.id;
        insert claims;
        
        
        
        Map<Id, Boolean> mpb = new Map<Id, Boolean>{JO.Id=>true};
            
            CSS_SymptomQA__c sqa = new CSS_SymptomQA__c();
        sqa.Name = 'black smoke';
        insert sqa;
        
        //DiagnosticResponce not null
        CSS_Solutions__c sol = new CSS_Solutions__c();
        sol.Service_Job__c = JO.ID;
        sol.Case_Name__c = 'GHI';
        sol.Solution_Title__c='CDE';
        sol.Name='GHI';
        sol.Diagnostic_Response__c ='Most likely the solution';
        sol.Repair_Response__c = 'Most likely';
        sol.Symptom__c = sqa.id;
        insert sol;
        
        CSS_Solutions__c solAdd = new CSS_Solutions__c();
        solAdd.Service_Job__c = JO.ID;
        solAdd.Case_Name__c = 'Additional SRTS';
        solAdd.Solution_Title__c='Additional SRTS';
        solAdd.Name='Additional SRTS';
        solAdd.Diagnostic_Response__c ='Most likely the solution';
        solAdd.Repair_Response__c = 'Most likely ';
        insert solAdd;
        
       
            
       

       CSS_SRT__C srtVar = new CSS_SRT__C();
        srtVar.Solution_Number__c = sol.id;
        srtVar.Job_Order__c = JO.id;
        srtVar.SRT_AccessiblityCheck__c=True;
        srtVar.Access_Code_A__c = 65;
        srtVar.name = 'Test';
        srtVar.SRT_ID__c = 'test';
        srtVar.Type__c = 'Diagnosis';
        srtVar.isPerformed__c =True;
        srtVar.Account_Code__c = 'Emissions Warranty 70';
        srtVar.CSS_Claims__c = claims.id;
        insert srtVar;
        
        CSS_SRT__C srtVar1 = new CSS_SRT__C();
        srtVar1.Solution_Number__c = null;
        srtVar1.Job_Order__c = JO.id;
        srtVar1.SRT_AccessiblityCheck__c=True;
        srtVar1.Access_Code_A__c = 65;
        srtVar1.name = 'Test';
        srtVar1.SRT_ID__c = 'test';
        srtVar1.Account_Code__c = 'Emissions Warranty 70';
        srtVar1.Type__c = 'Diagnosis';
        srtVar1.isPerformed__c =True;
        insert srtVar1;
        additionalSRTList.add(srtVar);
        additionalSRTList.add(srtVar1);
        
        CSS_Solution_Component__c solComp = new CSS_Solution_Component__c();
        solComp.Component_Id__c ='F0051000';
        solComp.Service_Job__c = JO.id;
        solComp.Solutions__c = sol.id;
        solComp.Selected_Component__c = true;
        solComp.CoveredLaborHrs__c = '12';
        solComp.System_Code__c = 'TH';
        solComp.Component_Code__c = 'AC';
        solComp.AccountCodeType__c  = 'Emissions Warranty';
        solComp.AccountCode__c = '70';
        solComp.AccountCodeEdit__c = 'Emissions Warranty70';
        insert solComp;
        
        CSS_Solution_Component__c AddsolComp = new CSS_Solution_Component__c();
        AddsolComp.Component_Id__c ='F0051000';
        AddsolComp.Service_Job__c = JO.id;
        AddsolComp.Solutions__c = soladd.id;
        AddsolComp.Name = 'Additional Components';
        AddsolComp.Selected_Component__c = true;
        AddsolComp.System_Code__c = 'TH';
        AddsolComp.Component_Code__c = 'AC';
        AddsolComp.AccountCodeType__c  = 'Emissions Warranty';
        AddsolComp.AccountCode__c = '70';
        AddsolComp.AccountCodeEdit__c = 'Emissions Warranty70';
        insert AddsolComp;
        
        CSS_SRT__C srtRep = new CSS_SRT__C();
        srtRep.Solution_Number__c = sol.id;
        srtRep.Job_Order__c = JO.id;
        srtRep.Component_Id__c = solComp.id;
        srtRep.SRT_Time__c = 465;
        srtRep.name = 'Test';
        srtRep.Type__c = 'Repair';
        srtRep.SRT_Order__c = 1;
        srtRep.Account_Code__c = 'Emissions Warranty 70';
        srtRep.Access_Code_A__c = 65;
        insert srtRep;
        
        CSS_SRT__C srtDiagAccess = new CSS_SRT__C();
        srtDiagAccess.Solution_Number__c = sol.id;
        srtDiagAccess.Job_Order__c = JO.id;
        srtDiagAccess.SRT_AccessiblityCheck__c=True;
        srtDiagAccess.SRT_Time__c = 565;
        srtDiagAccess.name = 'Test';
        srtDiagAccess.Type__c = 'Diag Access';
        srtDiagAccess.Account_Code__c = 'Emissions Warranty 70';
        srtDiagAccess.SRT_AccessiblityCheck__c = true;
        srtDiagAccess.Access_Code_A__c = 65;
        insert srtDiagAccess;
        
        CSS_SRT__C srtRepAccess = new CSS_SRT__C();
        srtRepAccess.Solution_Number__c = sol.id;
        srtRepAccess.SRT_AccessiblityCheck__c=True;
        srtRepAccess.SRT_Time__c = 6658;
        srtRepAccess.Job_Order__c = JO.id;
        srtRepAccess.name = 'Test';
        srtRepAccess.Type__c = 'Repair Access';
        srtRepAccess.Account_Code__c = 'Emissions Warranty 70';
        srtRepAccess.Access_Code_A__c = 65;
        insert srtRepAccess;
        
        
        CSS_SRT__C srtAddiRepAccess = new CSS_SRT__C();
        srtAddiRepAccess.Solution_Number__c = solAdd.id;
        srtAddiRepAccess.SRT_AccessiblityCheck__c=True;
        srtAddiRepAccess.SRT_Time__c = 8656;
        srtAddiRepAccess.SRT_Quantity__c=1;
        srtAddiRepAccess.Job_Order__c = JO.id;
        srtAddiRepAccess.name = 'Test';
        srtAddiRepAccess.Type__c = 'Repair Access';
        srtAddiRepAccess.Account_Code__c = 'Emissions Warranty 70';
        srtAddiRepAccess.Access_Code_A__c = 65;
        insert srtAddiRepAccess;
        
        
        CSS_SRT__C srtAddiDiagAccess = new CSS_SRT__C();
        srtAddiDiagAccess.Solution_Number__c = NULL;
        srtAddiDiagAccess.SRT_AccessiblityCheck__c=True;
        srtAddiDiagAccess.SRT_Time__c = 8655;
        srtAddiDiagAccess.Job_Order__c = JO.id;
        srtAddiDiagAccess.name = 'Test';
        srtAddiDiagAccess.Type__c = 'Repair Access';
        srtAddiDiagAccess.Account_Code__c = 'Emissions Warranty 70';
        srtAddiDiagAccess.Access_Code_A__c = 65;
        insert srtAddiDiagAccess;
        
        additionalSRTList.add(srtRep);
        additionalSRTList.add(srtDiagAccess);
        additionalSRTList.add(srtRepAccess);
        additionalSRTList.add(srtAddiRepAccess);
        additionalSRTList.add(srtAddiDiagAccess);
        
        List<CSS_SRT__c> repList2 = new List<CSS_SRT__c>();
        repList2.add(srtRepAccess);
        repList2.add(srtRepAccess);
        
        CSS_DARSRT.sortWrapper sortwrap = new CSS_DARSRT.sortWrapper(srtRep);
        sortwrap.compareTo(sortwrap);
        
        CSS_DARSRT.compWrapper compwrap = new CSS_DARSRT.compWrapper();
        compwrap.additionalSRT = additionalSRTList;
        compwrap.srtCount = 5;
        compwrap.compName = 'FS100000';
        
        compwrap.compenentId = solComp.Id;
        compwrap.percentagewarranty  = '7';
        compwrap.repairList  = repList2;    
        
        list<CSS_DARSRT.compWrapper> lstCompWrap = new list<CSS_DARSRT.compWrapper>();
        
        List<CSS_DARSRT.srtWrapper> repList = new List<CSS_DARSRT.srtWrapper>();
        CSS_DARSRT.srtWrapper srtwrap = new CSS_DARSRT.srtWrapper();
        
        PageReference pg = Page.CSS_JobRepair;
        Test.setCurrentPage(pg);    
        ApexPages.currentPage().getParameters().put('id', JO.Id);        
        CSS_DARSRT srt = new CSS_DARSRT();
        srt.diagTotal = true;
        srt.JobID =JO.id;
        Test.setMock(HttpCalloutMock.class, new CSS_getAllRepDiagSRTs_Test());
        //   srt.getdiagnosisTime();
        srt.changeUpOrder();
        srt.getdiagAccessTime();
        srt.saveDiagData();
        srt.saveRepairData();       
        srt.showPopup(); 
        srt.showPopup1();
        srt.getallData();
        srt.searchValue = 'Repair';
        srt.changeUpOrder();
        srt.lstSRT_VS = additionalSRTList;
        srt.repairTime = '455';
        srt.selected1 = mpb;
      //  srt.counting=123;
        srt.resetRepairData();
        srt.resetDiagData();
        srt.Failcodesrt();
        //srt.onChangeAccountCode();
        //srt.getrepairTime();
        
        Test.stopTest();     
    } 
    
    public static testMethod void testDarSRTJobLessTime(){
        
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02466';
        acc.IAM_Service_Provider_Code__c='19134';
        acc.Type='Dealer Account';
        acc.CMI_Account_Status__c = 'Active';
        insert acc;
            
        CSS_Job_Order__c JO = new CSS_Job_Order__c();
        JO.Customer_Name__c = 'CumminsTnD';
        JO.Equipment_ID__c = 'EQ7667';
        JO.Qsol_Engine_Family_Code__c ='56';
        JO.AccessCode__c = 'A';
        JO.Account__c = acc.id;
        insert JO;   
        
        CSS_SymptomQA__c sqa = new CSS_SymptomQA__c();
        sqa.Name = 'black smoke';
        insert sqa;
        
        CSS_Solutions__c sol = new CSS_Solutions__c();
        sol.Service_Job__c = JO.ID;
        sol.Case_Name__c = 'ABC';
        sol.Solution_Title__c='CDE';
        sol.Name='ABC';
        sol.Diagnostic_Response__c ='Most likely the solution';
        sol.Repair_Response__c = 'Most likely';
        sol.Symptom__c = sqa.id;
        insert sol;
        
        CSS_Solutions__c solAdd = new CSS_Solutions__c();
        solAdd.Service_Job__c = JO.ID;
        solAdd.Case_Name__c = 'Additional SRTS';
        solAdd.Solution_Title__c='Additional SRTS';
        solAdd.Name='Additional SRTS';
        solAdd.Diagnostic_Response__c ='Most likely the solution';
        solAdd.Repair_Response__c = 'Most likely ';
        insert solAdd;
        
        List<CSS_SRT__C> lstsrt = new List<CSS_SRT__C>();
        
        CSS_SRT__C srtVar = new CSS_SRT__C();
        srtVar.Solution_Number__c = sol.id;
        srtVar.Job_Order__c = JO.id;
        srtVar.SRT_AccessiblityCheck__c=True;
        srtVar.Access_Code_A__c = 65;
        srtVar.name = 'Test';
        srtVar.SRT_ID__c = 'test';
        srtVar.SRT_Time__c = 65;                
        srtVar.Type__c = 'Diagnosis';
        srtVar.isPerformed__c =True;
        insert srtVar;
        lstsrt.add(srtVar);
        
        CSS_SRT__C srtVar1 = new CSS_SRT__C();
        srtVar1.Solution_Number__c = Sol.id;
        //srtVar1.Job_Order__c = JO.id;
        srtVar1.SRT_AccessiblityCheck__c=True;
        srtVar1.Access_Code_A__c = 65;
        srtVar1.name = 'Test';
        srtVar1.Job_Order__c = JO.id;
        srtVar1.SRT_ID__c = 'test';
        srtVar1.SRT_Time__c = 65;        
        srtVar1.Type__c = 'Diag Access';
        srtVar1.isPerformed__c =True;
        insert srtVar1;
        lstsrt.add(srtVar1);
        
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
        
        CSS_SRT__C srtRep = new CSS_SRT__C();
        srtRep.Solution_Number__c = sol.id;
        srtRep.Job_Order__c = JO.id;
        srtRep.Component_Id__c = solComp.id;
        srtRep.SRT_Time__c = 65;
        srtRep.name = 'Test';
        srtRep.Type__c = 'Repair';
        insert srtRep;
        
        CSS_SRT__C srtDiagAccess = new CSS_SRT__C();
        srtDiagAccess.Solution_Number__c = sol.id;
        srtDiagAccess.Job_Order__c = JO.id;
        srtDiagAccess.SRT_AccessiblityCheck__c=True;
        srtDiagAccess.SRT_Time__c = 65;
        srtDiagAccess.name = 'Test';
        srtDiagAccess.Type__c = 'Diag Access';
        insert srtDiagAccess;
        
        CSS_SymptomQA__c sqa2 = new CSS_SymptomQA__c();
        sqa2.Name = 'white smoke';
        insert sqa2;
        
        CSS_Solutions__c sol2 = new CSS_Solutions__c();
        sol2.Service_Job__c = JO.ID;
        sol2.Case_Name__c = 'ABC';
        sol2.Solution_Title__c='CDE';
        sol2.Name='ABC';
        sol2.Diagnostic_Response__c ='Most likely the solution';
        sol2.Repair_Response__c = 'Most likely';
        sol2.Symptom__c = sqa2.id;
        insert sol2;
        
        
        CSS_SRT__C srtRepAccess = new CSS_SRT__C();
        srtRepAccess.Solution_Number__c = sol2.id;
        srtRepAccess.SRT_AccessiblityCheck__c=True;
        srtRepAccess.SRT_Time__c = 65;
        srtRepAccess.Job_Order__c = JO.id;
        srtRepAccess.name = 'Test';
        srtRepAccess.Type__c = 'Repair Access';
        srtRepAccess.Step_Id__c = '12345';
        srtRepAccess.Overlap_SRT_Number__c = '12345';
        srtRepAccess.Overlap_Hours__c = 2.5;
        srtRepAccess.SRT_Title__c = '1222';
        srtRepAccess.Overlap_Step_Id__c = '1234';
        srtRepAccess.Overlap_SRT_Number__c = '12345';
        srtRepAccess.Overlap_SRT_Title__c = '12345';
        
        insert srtRepAccess;
        
        
        CSS_SRT__C srtAddiRepAccess = new CSS_SRT__C();
        srtAddiRepAccess.Solution_Number__c = sol2.id;
        srtAddiRepAccess.SRT_AccessiblityCheck__c=True;
        srtAddiRepAccess.SRT_Time__c = 65;
        srtAddiRepAccess.SRT_Quantity__c=1;
        srtAddiRepAccess.Job_Order__c = JO.id;
        srtAddiRepAccess.name = 'Test';
        srtAddiRepAccess.Type__c = 'Repair Access';
        srtAddiRepAccess.Step_Id__c = '12345';
        srtAddiRepAccess.Overlap_Hours__c = 2.5;
        srtAddiRepAccess.Overlap_SRT_Number__c = '123';
        srtAddiRepAccess.Overlap_SRT_Title__c = 'Test';
        srtAddiRepAccess.Overlap_Step_Id__c = '00-12345';
        srtAddiRepAccess.Overlap_Hours__c = 2.5;
        insert srtAddiRepAccess;
        List<CSS_SRT__C> css=new List<CSS_SRT__C>();
        css.add(srtAddiRepAccess);
        CSS_SRT__C srtAddiDiagAccess = new CSS_SRT__C();
        //srtAddiDiagAccess.Solution_Number__c = NULL;
        srtAddiDiagAccess.Solution_Number__c = sol2.id;
        srtAddiDiagAccess.SRT_AccessiblityCheck__c=True;
        srtAddiDiagAccess.SRT_Time__c = 65;
        srtAddiDiagAccess.Job_Order__c = JO.id;
        srtAddiDiagAccess.name = 'Test';
        srtAddiDiagAccess.Type__c = 'Repair Access';
        srtAddiDiagAccess.Step_Id__c = '12345';
        insert srtAddiDiagAccess;
        
        test.startTest();
        PageReference pg = Page.CSS_JobTnDRj;
        Test.setCurrentPage(pg);    
        ApexPages.currentPage().getParameters().put('id', JO.Id);
        CSS_DARSRT srt = new CSS_DARSRT();
        srt.diagTotal = true;
        srt.selectedFailCode = 'THAS';
        srt.getAccountCodeOptionList(srt.selectedFailCode);
        srt.selectedSolId='Test';
        srt.totalDecimalTimeRep = 888;
        srt.totalDecimalTimeAccTot = 999;
        srt.JobID =JO.id;
        srt.selectedSolId = Sol.Id;
        srt.selectedSrtId=srtVar.id;
        srt.getdiagnosisTime();
        CSS_DARSRT.sortWrapper sortwrap = new CSS_DARSRT.sortWrapper(srtAddiDiagAccess);
        srt.saveDiagData();
        srt.saveRepairData();       
        srt.showPopup();
        srt.showPopup1();
        srt.getallData();
        srt.changeUpOrder();
        //srt.onChangeAccountCode();
        //Test.setMock(HttpCalloutMock.class, new CSS_MockOverlapSRT_Test());
        //srt.onChangeRepAccountCode();
        srt.overlapSRTCallout('12345',css);
        test.stopTest();
    }
    
    public static testmethod void testDarsrtmethod(){ 
        CSS_DARSRT sa = new CSS_DARSRT();
        system.assert(string.isBlank(sa.SelectedFailCode));
        system.assert(string.isBlank(sa.repAccTime));
        
        CSS_DARSRT.srtWrapper sw = new CSS_DARSRT.srtWrapper();
        system.assert(string.isBlank(sw.AccessCodeSaved));
        system.assert(string.isBlank(sw.SRTAccessCode));
        system.assert(string.isBlank(sw.accTime));
        system.assert(sw.accTimeDec==null);
    }
    
    public static testMethod void testAddSRT5(){ 
        
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02466';
        acc.IAM_Service_Provider_Code__c='19134';
        acc.Type='Dealer Account';
        acc.CMI_Account_Status__c = 'Active';
        insert acc;
            
        CSS_Job_Order__c JO1 = new CSS_Job_Order__c();
        JO1.Customer_Name__c = 'CumminsTnD';
        JO1.Equipment_ID__c = 'EQ7667';
        JO1.Qsol_Engine_Family_Code__c ='56';
        JO1.AccessCode__c = 'A';
        JO1.Account__c = acc.id;
        insert JO1;
        
        PageReference pg = Page.CSS_JobTnDRj;
        Test.setCurrentPage(pg);    
        ApexPages.currentPage().getParameters().put('id', JO1.Id);
        
        CSS_Solutions__c Sol = CSS_TestData.createSolutions(true,JO1.id);
        CSS_Solution_Component__c solcomp = CSS_TestData.createSRT(true,JO1.id,sol.id);
        solcomp.System_Code__c = 'Test';
        update solcomp;
        
        CSS_SRT__C srtRef2 = new CSS_SRT__C();
        srtRef2.Solution_Number__c = Sol.id;
        srtRef2.Job_Order__c = JO1.id;
        srtRef2.SRT_AccessiblityCheck__c=True;
        srtRef2.name = 'Additional SRT';
        srtRef2.type__c = 'Diagnosis';
        srtRef2.SRT_ID__c = '00-901-10';
        srtRef2.srt_time__c = 0.2;
        srtRef2.isPerformed__c = true;
        srtRef2.SRT_Category__c = 'Diag';
        srtRef2.Account_Code__c='Emissions';
        srtRef2.Component_id__c = solcomp.id;
        srtRef2.Assignment__c = 'PRIMARY';
        insert srtRef2;
        
        CSS_SRT__C srt = new CSS_SRT__C();
        srt.Solution_Number__c = Sol.id;
        srt.Job_Order__c = JO1.id;
        srt.SRT_AccessiblityCheck__c=True;
        srt.Access_Code_A__c = 65;
        srt.name = 'TestClassName';
        srt.type__c = 'Diagnosis';
        srt.Assignment__c = 'PRIMARY';
        srt.srt_time__c = 1;
        srt.SRT_ID__c = '00-901-10';
        srt.Component_id__c = solcomp.id;
        srt.isPerformed__c = true;
        insert srt;
        
        decimal time1 = [select id,Repair_Access_Calculated__c from css_srt__c where id = :srt.id].Repair_Access_Calculated__c;
        
        CSS_SRT__C srtRef = new CSS_SRT__C();
        srtRef.Solution_Number__c = sol.id;
        srtRef.Job_Order__c = JO1.id;
        srtRef.SRT_AccessiblityCheck__c=True;
        srtRef.Access_Code_A__c = 65;
        srtRef.name = 'TestClassName';
        srtRef.type__c = 'Repair';
        srtRef.SRT_ID__c = '00-901-10';
        srtRef.SRT_Time__c = 0.4;
        srtRef.Component_id__c = solcomp.id;
        srtRef.isPerformed__c = true;
        insert srtRef;
        
        
        CSS_SRT__C srtRef1 = new CSS_SRT__C();
        srtRef1.Job_Order__c = JO1.id;
        srtRef1.SRT_AccessiblityCheck__c=True;
        srtRef1.name = 'Additional SRT';
        srtRef1.type__c = 'Access';
        srtRef1.SRT_ID__c = '00-901-01';
        srtRef1.srt_time__c = 0.2;
        srtRef1.isPerformed__c = true;
        srtRef1.SRT_Category__c = 'AdditionalDiag';
        srtRef1.Account_Code__c='Emissions';
        insert srtRef1;
        
        List<CSS_Solution_Component__c> solsComplst = new List<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solcomp1 = new CSS_Solution_Component__c();
         solcomp1.Service_Job__c = JO1.id;
         solcomp1.Selected_Component__c = true;
         solcomp1.System_Code__c = 'THER';
         solcomp1.Component_Code__c = 'ASFF';
         solcomp1.AccountCodeEdit__c = 'Test';
         solcomp1.Type__c = 'Campaign';
         solcomp1.CoveredLaborHrs__c='99999';
         insert solcomp1;
         solsComplst.add(solcomp1);        
        
        
        list<CSS_SRT__C> AdditionalSrt = [Select id,name from CSS_SRT__C where Job_Order__c=:Jo1.Id and Solution_Number__c = null];
        map<string,string> mapwarrantymap =  new map<string,string>();
        mapwarrantymap.put('Emissions','Emissions');
        
       
        system.assert(AdditionalSrt!=null);
        CSS_DARSRT srta = new CSS_DARSRT(); 
        srta.searchDiagValue = 'Administrative';
        srta.selectedSolId='';
        srta.selectedSrtId=srt.id;
        srta.accountCodeWithWarrantMap = mapwarrantymap;
        test.startTest();
        
        Test.setMock(HttpCalloutMock.class, new CSS_AccessToken_SRT_Test());
        Test.setMock(HttpCalloutMock.class, new CSS_getAllRepDiagSRTs_Test());
        
        srta.searchDiagValue = 'Administrative';
        srta.countDiag = 1;
        
        srta.getsVfComp();
        srta.getAllACS();
        srta.changeDownOrder();
        srta.setsVfComp(JO1.id);
        //srta.onChangeAccountCode();
        srta.calculateExtendedHours();
        srta.getMaxSortOrder();
        test.stopTest();
    }
    
    public static testMethod void testAddSRT6(){
         CSS_DARSRT dd = new CSS_DARSRT();
        dd.SelectedFailCode = 'THAS';
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02466';
        acc.IAM_Service_Provider_Code__c='19134';
        acc.Type='Dealer Account';
        acc.CMI_Account_Status__c = 'Active';
        insert acc;
        
        CSS_Job_Order__c JO1 = new CSS_Job_Order__c();
        JO1.Customer_Name__c = 'CumminsTnD';
        JO1.Equipment_ID__c = 'EQ7667';
        JO1.Qsol_Engine_Family_Code__c ='56';
        JO1.AccessCode__c = 'A';
        JO1.Account__c = acc.id;
        insert JO1;
        
        PageReference pg = Page.CSS_JobTnDRj;
        Test.setCurrentPage(pg);    
        ApexPages.currentPage().getParameters().put('id', JO1.Id);
        
        CSS_Solutions__c Sol = CSS_TestData.createSolutions(true,JO1.id);
        Sol.Diagnostic_Response__c = 'Most likely the solution';
        Update sol;
        
        List<CSS_Solution_Component__c> solsComplst = new List<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solcomp = new CSS_Solution_Component__c();
         solcomp.Service_Job__c = JO1.id;
         solcomp.Selected_Component__c = true;
         solcomp.System_Code__c = 'THER';
         solcomp.Component_Code__c = 'ASFF';
         solcomp.AccountCodeEdit__c = 'Test';
         solcomp.Type__c = 'Campaign';
         solcomp.CoveredLaborHrs__c='99999';
         insert solcomp;
         solsComplst.add(solcomp);
         CSS_Solution_Component__c solcomp1 = new CSS_Solution_Component__c();
         solcomp1.Service_Job__c = JO1.id;
         solcomp1.Selected_Component__c = true;
         solcomp1.System_Code__c = 'THER';
         solcomp1.Component_Code__c = 'ASFF';
         solcomp1.AccountCodeEdit__c = 'Test';
         solcomp1.Type__c = 'Campaign';
         solcomp1.CoveredLaborHrs__c='9999';
         insert solcomp1;
         solsComplst.add(solcomp1);
         
         system.debug('solsComplst'+solsComplst);
        
        CSS_SRT__C srt = new CSS_SRT__C();
        srt.Solution_Number__c = Sol.id;
        srt.Job_Order__c = JO1.id;
        srt.SRT_AccessiblityCheck__c=True;
        srt.Access_Code_A__c = 65;
        srt.name = 'TestClassName';
        srt.type__c = 'Diagnosis';
        srt.Assignment__c = 'PRIMARY';
        srt.srt_time__c = 1;
        srt.SRT_ID__c = '00-901-10';
        srt.Component_id__c = solcomp.id;
        srt.isPerformed__c = true;
        insert srt;
        
        decimal time1 = [select id,Repair_Access_Calculated__c from css_srt__c where id = :srt.id].Repair_Access_Calculated__c;
        
        CSS_SRT__C srtRef = new CSS_SRT__C();
        srtRef.Solution_Number__c = sol.id;
        srtRef.Job_Order__c = JO1.id;
        srtRef.SRT_AccessiblityCheck__c=True;
        srtRef.Access_Code_A__c = 65;
        srtRef.name = 'TestClassName';
        srtRef.type__c = 'Diagnosis';
        srtRef.SRT_ID__c = '00-901-10';
        srtRef.SRT_Time__c = 0.4;
        srtRef.Component_id__c = solcomp.id;
        srtRef.isPerformed__c = true;
        insert srtRef;
        
        CSS_SRT__C srtRep1 = new CSS_SRT__C();
        srtRep1.Job_Order__c = JO1.id;
        srtRep1.SRT_ID__c = '00-901-10';
        srtRep1.SRT_Time__c = 465;
        srtRep1.name = 'Test';
        srtRep1.Type__c = 'Overlap';
        srtRep1.SRT_Order__c = 1;
        srtRep1.Account_Code__c = 'Emissions Warranty 70';
        srtRep1.Assignment__c = 'Primary';
        srtRep1.srt_category__c = 'AdditionalDiag';
        insert srtRep1;
        
        CSS_SRT__C srtRef1 = new CSS_SRT__C();
        srtRef1.Job_Order__c = JO1.id;
        //  srtRef1.Id = '123';
        srtRef1.SRT_AccessiblityCheck__c=True;
        srtRef1.name = 'Additional SRT';
        srtRef1.type__c = 'Access';
        srtRef1.SRT_ID__c = '00-901-01';
        srtRef1.srt_time__c = 0.2;
        srtRef1.isPerformed__c = true;
        srtRef1.SRT_Category__c = 'AdditionalRep';
        srtRef1.Account_Code__c='Emissions';
        insert srtRef1;
        list<CSS_SRT__C> AdditionalSrt = [Select id,name from CSS_SRT__C where Job_Order__c=:Jo1.Id and Solution_Number__c = null];
        map<string,string> mapwarrantymap =  new map<string,string>();
        mapwarrantymap.put('Emissions','Emissions');
        
        system.assert(AdditionalSrt!=null);
        CSS_DARSRT srta = new CSS_DARSRT();
        //CSS_DARSRT dd = new CSS_DARSRT();
        srta.SelectedFailCode = 'THAS';
        srta.searchDiagValue = 'Administrative';
        srta.selectedSolId=Sol.id;
        srta.selectedSrtId=srt.id;
        srta.accountCodeWithWarrantMap = mapwarrantymap;
        srta.seltdSRTId = string.valueOf(srtRef1.id);
        
         test.startTest();
        
        Test.setMock(HttpCalloutMock.class, new CSS_AccessToken_SRT_Test());
        Test.setMock(HttpCalloutMock.class, new CSS_getAllRepDiagSRTs_Test());
        
        srta.searchDiagValue = 'Administrative';
        srta.countDiag = 1;
        
        srta.getsVfComp();
        
        srta.getAllACS();
        //  srta.changeDownOrder();
        srta.setsVfComp(JO1.id);
        
        //srta.onChangeAccountCode();
        srta.getonchangefailCode();
        srta.onChangeofFailCode();
        Map<String,List<CSS_SRT__c>> csrt=new Map<String,List<CSS_SRT__c>>();
        csrt.put('Test',AdditionalSrt);
        srta.createOverlapSRT(csrt);
        test.stopTest();
    }
    
    public static testmethod void method7(){
        test.startTest();
        CSS_Job_Order__c JO1 = new CSS_Job_Order__c();
        JO1.Customer_Name__c = 'CumminsTnD';
        JO1.Equipment_ID__c = 'EQ7667';
        JO1.Qsol_Engine_Family_Code__c ='56';
        JO1.AccessCode__c = 'A';
        insert JO1;       
        
        PageReference pg = Page.CSS_JobTnDRj;
        Test.setCurrentPage(pg);    
        Id JobID = ApexPages.currentPage().getParameters().put('id', JO1.Id);
        
        CSS_Solutions__c Solobj = new CSS_Solutions__c();
        Solobj.Service_Job__c = JO1.id;
        Solobj.Diagnostic_Response__c ='Most likely the solution';
        Solobj.Repair_Response__c = 'Most likely ';
        insert Solobj;
        List<CSS_SRT__C> srtlst = new List<CSS_SRT__C>();
        CSS_SRT__C  obj = new CSS_SRT__C ();
        obj.Job_Order__c = JobID;
        //obj.Solution_Number__c = null;
        obj.Solution_Number__c = Solobj.id;
        insert obj;
        srtlst.add(obj);
        CSS_DARSRT srta = new CSS_DARSRT(); 
        test.stopTest();
        
    }
    
    public static testmethod void onChangeAccountCodemethod(){
        
        test.startTest();
        
        CSS_DARSRT srta = new CSS_DARSRT();
        CSS_DARSRT.srtWrapper srt = new CSS_DARSRT.srtWrapper();
        
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02466';
        acc.IAM_Service_Provider_Code__c='19134';
        acc.Type='Dealer Account';
        acc.CMI_Account_Status__c = 'Active';
        insert acc;
        
        CSS_Job_Order__c JO = new CSS_Job_Order__c();
        JO.Customer_Name__c = 'CumminsTnD';
        JO.Equipment_ID__c = 'EQ7667';
        JO.Qsol_Engine_Family_Code__c ='56';
        JO.AccessCode__c = 'A';
        JO.Account__c = acc.id;
        insert JO;
        
        CSS_Fault_Code__c fauCodRef = new CSS_Fault_Code__c();
        fauCodRef.Job_Order__c =JO.Id; 
        fauCodRef.Sequence__c=1;
        fauCodRef.Fault_Code_Type__c='BPD'; 
        fauCodRef.Primary_Fault_Code__c=3539; 
        fauCodRef.Status__c='A';
        insert fauCodRef;
        
        CSS_SymptomQA__c sym=new CSS_SymptomQA__c();
        sym.Job_Order__c=JO.id;
        sym.caption__c ='white smoke';
        sym.Option1__c  ='12213';
        sym.Job_Order__c  =Jo.id;
        sym.Option_type__c  ='qwewqe';
        sym.Guide_Question__c  ='1asdsad2213';
        sym.Type__c  ='SearchString';
        sym.Answers__c = 'ans';
        sym.Caption__c = 'cap';
        sym.Sequence__c = 1.6;
        
        insert sym;
        
        CSS_SymptomQA__c symQA2=new CSS_SymptomQA__c();
        symQA2.Job_Order__c=Jo.id;
        symQA2.caption__c ='white smoke';
        symQA2.Option1__c  ='1222134213413';
        symQA2.SearchString__c = sym.id;
        symQA2.Option_type__c  ='wewqe';
        symQA2.Sequence__c =3;
        symQA2.Type__c  ='QA';
        
        insert symQA2; 
        CSS_SymptomQA__c symQA3=new CSS_SymptomQA__c();
        symQA3.Job_Order__c=Jo.id;
        symQA3.name = '2636';
        symQA3.caption__c ='white smoke';
        symQA3.Option1__c  ='1222134213413';
        symQA3.SearchString__c = symQA2.id;
        symQA3.Option_type__c  ='wewqe';
        symQA3.Sequence__c =2;
        symQA3.Type__c  ='QA';
        
        insert symQA3;
        
        CSS_Solutions__c solAdd = new CSS_Solutions__c();
        solAdd.Service_Job__c = JO.ID;
        solAdd.Case_Name__c = 'Additional SRTS';
        solAdd.Solution_Title__c='Additional SRTS';
        solAdd.Name='Additional SRTS';
        solAdd.Diagnostic_Response__c ='Most likely the solution';
        solAdd.Repair_Response__c = 'Most likely ';
        solAdd.FaultCode__c =fauCodRef.id;
        solAdd.Symptom__c = symQA3.id;
        insert solAdd;
        
        
        CSS_Solution_Component__c solComp = new CSS_Solution_Component__c();
        solComp.Component_Id__c ='F0051000';
        solComp.Service_Job__c = JO.id;
        solComp.Solutions__c = solAdd.id;
        solComp.Selected_Component__c = true;
        solComp.System_Code__c = 'TH';
        solComp.Component_Code__c = 'AC';
        solComp.AccountCodeType__c  = 'Emissions Warranty';
        solComp.AccountCode__c = '70';
        solComp.AccountCodeEdit__c = 'Emissions Warranty70';
        insert solComp;
        
        CSS_SRT__C srtRepAccess = new CSS_SRT__C();
        srtRepAccess.Component_Id__c = solComp.id;
        srtRepAccess.Solution_Number__c = solAdd.id;
        srtRepAccess.SRT_Access_Code__c = 'R';
        srtRepAccess.Access_Code_A__c = 0.1;
        srtRepAccess.Access_Code_B__c = 0.3;
        srtRepAccess.Access_Code_C__c = 0.1;
        srtRepAccess.Access_Code_D__c = 0.1;
        srtRepAccess.Access_Code_R__c = 0.1;
        srtRepAccess.Special_Access_Code__c = '789';
        srtRepAccess.Special_Access_Code_Desc__c = '888';
        srtRepAccess.SRT_AccessiblityCheck__c=True;
        srtRepAccess.SRT_Time__c = 66;
        srtRepAccess.Job_Order__c = JO.id;
        srtRepAccess.name = 'Test';
        srtRepAccess.Type__c = 'Diagnosis';
        srtRepAccess.Account_Code__c = 'Emissions Warranty 70';
        insert srtRepAccess;
        
        srta.selectedSolId=solAdd.Id;
        srt.solTitle = solAdd.Solution_Title__c;
        srt.solNum = solAdd.Name;
        srt.jobOrderId = solAdd.Service_Job__c;
        srt.solId = solAdd.id;
        srt.fautCodeName = solAdd.FaultCode__c;
        srt.symptomName = solAdd.Symptom__r.name;
        srt.AccessCode = srtRepAccess.Job_Engine_Access_Code__c;
        srt.EquipmentID = solAdd.Service_Job__r.Equipment_ID__c;
        srt.AccessCodeA = string.valueof(srtRepAccess.Access_Code_A__c);
        srt.AccessCodeB = string.valueof(srtRepAccess.Access_Code_B__c);
        srt.AccessCodeC = string.valueof(srtRepAccess.Access_Code_C__c);
        srt.AccessCodeD = string.valueof(srtRepAccess.Access_Code_D__c);
        srt.AccessCodeR = string.valueof(srtRepAccess.Access_Code_R__c);
        srt.SpecialAccessCode = srtRepAccess.Special_Access_Code__c;
        srt.SpecialDescription = srtRepAccess.Special_Access_Code_Desc__c;
        srt.showHeader = false;
        List<CSS_DARSRT.srtWrapper> diagListWrap = new List<CSS_DARSRT.srtWrapper>();
        diagListWrap.add(srt);
        
        CSS_DARSRT.sortWrapper sortwrap = new CSS_DARSRT.sortWrapper(srtRepAccess);
        sortwrap.compareTo(sortwrap);
        
        srta.onChangeAccountCode();
        test.stopTest();
    }
    
    public static testMethod void New_testDarSRTMoreTime_3(){
        
        //Covers Anirudh 2 diagList
        
        
        List<CSS_Srt__c> additionalSRTList = new List<CSS_Srt__c>(); 
        
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02466';
        acc.IAM_Service_Provider_Code__c='19134';
        acc.Type='Dealer Account';
        acc.CMI_Account_Status__c = 'Active';
        insert acc;
        
        CSS_Job_Order__c JO = new CSS_Job_Order__c();
        JO.Customer_Name__c = 'CumminsTnD';
        JO.Equipment_ID__c = 'EQ7667';
        JO.Qsol_Engine_Family_Code__c ='56';
        JO.AccessCode__c = 'A';
        JO.Account__c = acc.id;
        insert JO;
        
        Map<Id, Boolean> mpb = new Map<Id, Boolean>{JO.Id=>true};
            
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
        
        CSS_Solution_Component__c AddsolComp = new CSS_Solution_Component__c();
        AddsolComp.Component_Id__c ='F0051000';
        AddsolComp.Service_Job__c = JO.id;
        AddsolComp.Solutions__c = soladd.id;
        AddsolComp.Name = 'Additional Components';
        AddsolComp.Selected_Component__c = true;
        AddsolComp.System_Code__c = 'TH';
        AddsolComp.Component_Code__c = 'AC';
        AddsolComp.AccountCodeType__c  = 'Emissions Warranty';
        AddsolComp.AccountCode__c = '70';
        AddsolComp.AccountCodeEdit__c = 'Emissions Warranty70';
        insert AddsolComp;
        
        CSS_SRT__C srtRep = new CSS_SRT__C();
        srtRep.Solution_Number__c = sol.id;
        srtRep.Job_Order__c = JO.id;
        srtRep.Component_Id__c = AddsolComp.id;
        srtRep.SRT_AccessiblityCheck__c = true;
        srtRep.SRT_Time__c = 465;
        srtRep.name = 'Test';
        srtRep.Type__c = 'Repair';
        srtRep.SRT_Order__c = 1;
        srtRep.Account_Code__c = 'Emissions Warranty 70';
        srtRep.Assignment__c = 'Primary';
        insert srtRep;
        
        /*CSS_SRT__C srtRepAccess = new CSS_SRT__C();
srtRepAccess.Solution_Number__c = sol.id;
srtRepAccess.SRT_AccessiblityCheck__c=True;
srtRepAccess.SRT_Time__c = 6658;
srtRepAccess.Job_Order__c = JO.id;
srtRepAccess.name = 'Test';
srtRepAccess.Type__c = 'Repair Access';
srtRepAccess.Account_Code__c = 'Emissions Warranty 70';
insert srtRepAccess;*/
        
        
        CSS_SRT__C srtAddiRepAccess = new CSS_SRT__C();
        srtAddiRepAccess.Solution_Number__c = solAdd.id;
        srtAddiRepAccess.SRT_AccessiblityCheck__c=True;
        srtAddiRepAccess.SRT_Time__c = 8656;
        srtAddiRepAccess.SRT_Quantity__c=1;
        srtAddiRepAccess.Job_Order__c = JO.id;
        srtAddiRepAccess.name = 'Test';
        srtAddiRepAccess.Type__c = 'Repair Access';
        srtAddiRepAccess.Account_Code__c = 'Emissions Warranty 70';
        srtAddiRepAccess.Component_Id__c = AddsolComp.id;
        srtAddiRepAccess.Assignment__c = 'Primary';
        insert srtAddiRepAccess;
        
        CSS_SRT__C srtAddiRepAccess1 = new CSS_SRT__C();
        srtAddiRepAccess1.Solution_Number__c = solAdd.id;
        srtAddiRepAccess1.SRT_AccessiblityCheck__c=True;
        srtAddiRepAccess1.SRT_Time__c = 8656;
        srtAddiRepAccess1.SRT_Quantity__c=1;
        srtAddiRepAccess1.Job_Order__c = JO.id;
        srtAddiRepAccess1.name = 'Test';
        srtAddiRepAccess1.Type__c = 'Repair';
        srtAddiRepAccess1.Account_Code__c = 'Emissions Warranty 70';
        srtAddiRepAccess1.Component_Id__c = AddsolComp.id;
        srtAddiRepAccess1.Assignment__c = 'Primary';
        insert srtAddiRepAccess1;
        
        
        additionalSRTList.add(srtRep);
        //additionalSRTList.add(srtRepAccess);
        additionalSRTList.add(srtAddiRepAccess);
        additionalSRTList.add(srtAddiRepAccess1);
        
        List<CSS_SRT__c> repList2 = new List<CSS_SRT__c>();
        //repList2.add(srtRepAccess);
        //repList2.add(srtRepAccess);
        
        CSS_DARSRT.sortWrapper sortwrap = new CSS_DARSRT.sortWrapper(srtRep);
        sortwrap.compareTo(sortwrap);
        
        CSS_DARSRT.compWrapper compwrap = new CSS_DARSRT.compWrapper();
        compwrap.additionalSRT = additionalSRTList;
        compwrap.srtCount = 5;
        compwrap.compName = 'FS100000';
        
        compwrap.compenentId = AddsolComp.Id;
        compwrap.percentagewarranty  = '7';
        compwrap.repairList  = repList2;    
        
        list<CSS_DARSRT.compWrapper> lstCompWrap = new list<CSS_DARSRT.compWrapper>();
        
        List<CSS_DARSRT.srtWrapper> repList = new List<CSS_DARSRT.srtWrapper>();
        CSS_DARSRT.srtWrapper srtwrap = new CSS_DARSRT.srtWrapper();
        
        PageReference pg = Page.CSS_JobTnDRj;
        Test.setCurrentPage(pg);    
        ApexPages.currentPage().getParameters().put('id', JO.Id); 
        Test.startTest(); 
        CSS_DARSRT srt = new CSS_DARSRT();
        srt.diagTotal = true;
        srt.JobID =JO.id;
        Test.setMock(HttpCalloutMock.class, new CSS_getAllRepDiagSRTs_Test());
        srt.getdiagnosisTime();
        srt.getdiagAccessTime();
        srt.saveDiagData();
        srt.saveRepairData();       
        srt.showPopup();
        srt.showPopup1();
        srt.getallData();
        srt.searchValue = 'Repair';
        srt.changeUpOrder();
        srt.lstSRT_VS = additionalSRTList;
        srt.repairTime = '455';
        srt.selected1 = mpb;
        srt.onChangeAccountCode();
        srt.CompareFailCodes();
        
        Test.stopTest();     
    } 
    
    public static testMethod void new_testDarSRTMoreTime_4(){
        
        //Covers Anirudh 2 diagList
        Test.startTest(); 
        
        List<CSS_Srt__c> additionalSRTList = new List<CSS_Srt__c>();
        
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02466';
        acc.IAM_Service_Provider_Code__c='19134';
        acc.Type='Dealer Account';
        acc.CMI_Account_Status__c = 'Active';
        insert acc;
        
        CSS_Job_Order__c JO = new CSS_Job_Order__c();
        JO.Customer_Name__c = 'CumminsTnD';
        JO.Equipment_ID__c = 'EQ7667';
        JO.Qsol_Engine_Family_Code__c ='56';
        JO.AccessCode__c = 'A';
        JO.Account__c = acc.id;
        insert JO;
        
        Map<Id, Boolean> mpb = new Map<Id, Boolean>{JO.Id=>true};
            
            
            
        CSS_SRT__C srtRep = new CSS_SRT__C();
        srtRep.Job_Order__c = JO.id;
        srtRep.SRT_Time__c = 465;
        srtRep.name = 'Test';
        srtRep.Type__c = 'Repair';
        srtRep.SRT_Order__c = 1;
        srtRep.Account_Code__c = 'Emissions Warranty 70';
        srtRep.Assignment__c = 'Primary';
        srtRep.srt_category__c = 'AdditionalDiag';
        srtRep.Job_Order__c = JO.id;
        insert srtRep;
        
        
        
        CSS_SRT__C srtAddiRepAccess = new CSS_SRT__C();
        srtAddiRepAccess.SRT_AccessiblityCheck__c=True;
        srtAddiRepAccess.SRT_Time__c = 865;
        srtAddiRepAccess.SRT_Quantity__c=1;
        srtAddiRepAccess.Job_Order__c = JO.id;
        srtAddiRepAccess.name = 'Test';
        srtAddiRepAccess.Type__c = 'Repair Access';
        //srtAddiRepAccess.Account_Code__c = 'Emissions Warranty 70';
        srtAddiRepAccess.Assignment__c = 'Primary';
        srtAddiRepAccess.srt_category__c = 'AdditionalDiag';
        insert srtAddiRepAccess;

        
        CSS_SRT__C srtAddiRepAccess1 = new CSS_SRT__C();
        srtAddiRepAccess1.SRT_AccessiblityCheck__c=True;
        srtAddiRepAccess1.SRT_Time__c = 865;
        srtAddiRepAccess1.SRT_Quantity__c=1;
        srtAddiRepAccess1.Job_Order__c = JO.id;
        srtAddiRepAccess1.name = 'Test';
        srtAddiRepAccess1.Type__c = 'Repair';
        srtAddiRepAccess1.Account_Code__c = 'Emissions Warranty 70';
        srtAddiRepAccess1.Assignment__c = 'Primary';
        srtAddiRepAccess1.srt_category__c = 'AdditionalRep';
        insert srtAddiRepAccess1;
        CSS_Solutions__c solAdd = new CSS_Solutions__c();
        solAdd.Service_Job__c = JO.ID;
        solAdd.Case_Name__c = 'Additional SRTS';
        solAdd.Solution_Title__c='Additional SRTS';
        solAdd.Name='Additional SRTS';
        solAdd.Diagnostic_Response__c ='Most likely the solution';
        solAdd.Repair_Response__c = 'Most likely ';
        insert solAdd;
        
        additionalSRTList.add(srtRep);
        additionalSRTList.add(srtAddiRepAccess);
        additionalSRTList.add(srtAddiRepAccess1);
        //  additionalSRTList.add(srtAddiRepAccess2);
        
        
        ApexPages.currentPage().getParameters().put('id', JO.Id);
        CSS_DARSRT srt = new CSS_DARSRT();

        //srt.selectedSrtId = srtRep.id;
        //srt.selectedSolId=null;
        //srt.getrepairTime();
        //srt.getRepairAccessTime();
        //Test.setMock(HttpCalloutMock.class, new CSS_MockOverlapSRT_Test());
        srt.saveRepairData();
        srt.changeUpOrder();
        srt.changeDownOrder();
        srt.onChangeRepAccountCode();
        
        Test.stopTest();     
    }
    
    public static testMethod void testForGetDiagAccessTime(){
        
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02466';
        acc.IAM_Service_Provider_Code__c='19134';
        acc.Type='Dealer Account';
        acc.CMI_Account_Status__c = 'Active';
        insert acc;
        
        CSS_Job_Order__c JO1 = new CSS_Job_Order__c();
        JO1.Customer_Name__c = 'Oliver Trucking';
        JO1.Equipment_ID__c = 'EQ7667';
        JO1.Qsol_Engine_Family_Code__c ='56';
        JO1.AccessCode__c = 'A';
        JO1.Account__c = acc.id;
        insert JO1;
        
        CSS_Solutions__c sol = new CSS_Solutions__c();
        sol.Service_Job__c = JO1.ID;
        sol.Case_Name__c = 'ABC';
        sol.Solution_Title__c='CDE';
        sol.Name='ABC';
        sol.Diagnostic_Response__c ='Most likely the solution';
        sol.Repair_Response__c = 'Most likely';
        insert sol;
        
        List<CSS_SRT__C> SRTList = new  List<CSS_SRT__C>();
        CSS_SRT__C srtRepAccess = new CSS_SRT__C();
        srtRepAccess.Solution_Number__c = sol.id;
        srtRepAccess.SRT_AccessiblityCheck__c=True;
        srtRepAccess.isPerformed__c = True;
        srtRepAccess.SRT_Time__c = 66;
        srtRepAccess.Job_Order__c = JO1.id;
        srtRepAccess.name = 'Test';
        srtRepAccess.Type__c = 'Diag Access';
        srtRepAccess.Account_Code__c = 'Emissions Warranty 70';
        srtRepAccess.SRT_Warrantable__c = '0.3';
        srtRepAccess.SRT_Time__c = 0.2;
        SRTList.add(srtRepAccess);
        insert SRTList;
        
       list<CSS_DARSRT.sortWrapper> lstDiagWrapSRTTest = new list<CSS_DARSRT.sortWrapper>();
       lstDiagWrapSRTTest.add(new CSS_DARSRT.sortWrapper(srtRepAccess));
       
        List<CSS_DARSRT.srtWrapper> SRTWrapList = new List<CSS_DARSRT.srtWrapper>();
        CSS_DARSRT.srtWrapper SRTWrapRec = new CSS_DARSRT.srtWrapper();
        SRTWrapRec.AccessCode ='A';
        SRTWrapRec.lstDiagWrapSRT = lstDiagWrapSRTTest;
        SRTWrapList.add(SRTWrapRec);
        
       /*list<CSS_DARSRT.sortWrapper> lstadditonalDiagSRTTest = new list<CSS_DARSRT.sortWrapper>();
       lstadditonalDiagSRTTest.add(new CSS_DARSRT.sortWrapper(srtRepAccess1));
        
        List<CSS_DARSRT.srtWrapper> SRTWrapList1 = new List<CSS_DARSRT.srtWrapper>();
        CSS_DARSRT.srtWrapper SRTWrapRec1 = new CSS_DARSRT.srtWrapper();
        SRTWrapRec1.AccessCode ='A';
        SRTWrapRec1.lstadditonalDiagSRT = lstadditonalDiagSRTTest;
        SRTWrapList1.add(SRTWrapRec1);*/
        
        CSS_DARSRT.sortWrapper sortwrap = new CSS_DARSRT.sortWrapper(srtRepAccess);
        sortwrap.compareTo(sortwrap);
        
        PageReference pg1 = Page.CSS_JobTnDRj;
        Test.setCurrentPage(pg1);    
        Id JobID = ApexPages.currentPage().getParameters().put('id', JO1.Id);  
        
        test.startTest();
        CSS_DARSRT Srt = new CSS_DARSRT();
        Srt.diagListWrap = SRTWrapList;
        /*Srt.additionalDiagListWrap = SRTWrapList1;*/
        Srt.getDiagAccessTime();
        SRt.saveDiagData();
        Srt.changeUpOrder();
       SRT.onChangeofFailCode();
        test.stopTest();
        
    }
    
    public static testMethod void testCalculateExtendedHours1(){ 
        
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02466';
        acc.IAM_Service_Provider_Code__c='19134';
        acc.Type='Dealer Account';
        acc.CMI_Account_Status__c = 'Active';
        insert acc;
        
        CSS_Job_Order__c JO1 = new CSS_Job_Order__c();
            JO1.Customer_Name__c = 'Oliver Trucking';
            JO1.Equipment_ID__c = 'EQ7667';
            JO1.Qsol_Engine_Family_Code__c ='56';
            JO1.AccessCode__c = 'A';
            JO1.Account__c = acc.id;
            insert JO1;
        
        CSS_Solutions__c Sol = CSS_TestData.createSolutions(true,JO1.id);
        
        CSS_Solution_Component__c solcomp = CSS_TestData.createSRT(true,JO1.id,sol.id);
            solcomp.System_Code__c = 'Test';
            update solcomp;
        
        List<CSS_SRT__C> SRTList = new List<CSS_SRT__C>();
        CSS_SRT__C srt = new CSS_SRT__C();
            srt.Solution_Number__c = Sol.id;
            srt.Job_Order__c = JO1.id;
            srt.SRT_AccessiblityCheck__c=True;
            srt.Access_Code_A__c = 65;
            srt.name = 'TestClassName';
            srt.type__c = 'Diagnosis';
            srt.Assignment__c = 'PRIMARY';
            srt.srt_time__c = 1;
            srt.SRT_ID__c = '00-901-10';
            srt.Component_id__c = solcomp.id;
            srt.isPerformed__c = true;
            SRTList.add(srt);
            
         CSS_SRT__C srt1 = new CSS_SRT__C();
            srt1.Solution_Number__c = Sol.id;
            srt1.Job_Order__c = JO1.id;
            srt1.SRT_AccessiblityCheck__c=True;
            srt1.Access_Code_A__c = 65;
            srt1.name = 'TestClassName';
            srt1.type__c = 'Diag Access';
            srt1.Assignment__c = 'PRIMARY';
            srt1.srt_time__c = 1;
            srt1.SRT_ID__c = '00-901-10';
            srt1.Component_id__c = solcomp.id;
            srt1.isPerformed__c = true;
            SRTList.add(srt1);   
            insert srtList;
            
       List<CSS_SRT__C> SRTListFA = new List<CSS_SRT__C>();
            CSS_SRT__C srtFA = new CSS_SRT__C();
            srtFA.Solution_Number__c = Sol.id;
            srtFA.Job_Order__c = JO1.id;
            srtFA.SRT_AccessiblityCheck__c=True;
            srtFA.Access_Code_A__c = 65;
            srtFA.name = 'TestClassName';
            srtFA.type__c = 'Field Action';
            srtFA.Assignment__c = 'PRIMARY';
            srtFA.srt_time__c = 1;
            srtFA.SRT_ID__c = '00-901-10';
            srtFA.Component_id__c = solcomp.id;
            srtFA.isPerformed__c = true;
            SRTListFA.add(srtFA);
            insert SRTListFA;
       
       List<CSS_SRT__C> OverlapSRTList = new List<CSS_SRT__C>();
       CSS_SRT__C srtRep1 = new CSS_SRT__C();
            srtRep1.Job_Order__c = JO1.id;
            srtRep1.SRT_ID__c = '00-901-10';
            srtRep1.SRT_Time__c = 465;
            srtRep1.name = 'Test';
            srtRep1.Type__c = 'Overlap';
            srtRep1.SRT_Order__c = 1;
            srtRep1.Account_Code__c = 'Emissions Warranty 70';
            srtRep1.Assignment__c = 'Primary';
            srtRep1.srt_category__c = 'AdditionalDiag';
            OverlapSRTList.add(srtRep1);
            insert OverlapSRTList;
        
        PageReference pg = Page.CSS_JobTnDRj;
        Test.setCurrentPage(pg);    
        ApexPages.currentPage().getParameters().put('id', JO1.Id);
        
        test.startTest();
        CSS_DARSRT srtI = new CSS_DARSRT(); 
        srtI.calculateExtendedHours();
        test.stopTest();
    }
    
    public static testMethod void testCalculateExtendedHours2(){ 
        
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02466';
        acc.IAM_Service_Provider_Code__c='19134';
        acc.Type='Dealer Account';
        acc.CMI_Account_Status__c = 'Active';
        insert acc;
        
        CSS_Job_Order__c JO1 = new CSS_Job_Order__c();
            JO1.Customer_Name__c = 'Oliver Trucking';
            JO1.Equipment_ID__c = 'EQ7667';
            JO1.Qsol_Engine_Family_Code__c ='56';
            JO1.AccessCode__c = 'A';
            JO1.Account__c = acc.id;
            insert JO1;
        
        CSS_Solutions__c Sol = CSS_TestData.createSolutions(true,JO1.id);
        
        CSS_Solution_Component__c solcomp = CSS_TestData.createSRT(true,JO1.id,sol.id);
            solcomp.System_Code__c = 'Test';
            update solcomp;
        
        List<CSS_SRT__C> SRTList = new List<CSS_SRT__C>();
        CSS_SRT__C srt = new CSS_SRT__C();
            srt.Solution_Number__c = Sol.id;
            srt.Job_Order__c = JO1.id;
            srt.SRT_AccessiblityCheck__c=True;
            srt.Access_Code_A__c = 65;
            srt.name = 'TestClassName';
            srt.type__c = 'Diagnosis';
            srt.Assignment__c = 'PRIMARY';
            srt.srt_time__c = 1;
            srt.SRT_ID__c = '00-901-10';
            srt.Component_id__c = solcomp.id;
            srt.isPerformed__c = true;
            SRTList.add(srt);
            
         CSS_SRT__C srt1 = new CSS_SRT__C();
            srt1.Solution_Number__c = Sol.id;
            srt1.Job_Order__c = JO1.id;
            srt1.SRT_AccessiblityCheck__c=True;
            srt1.Access_Code_A__c = 65;
            srt1.name = 'TestClassName';
            srt1.type__c = 'Diag Access';
            srt1.Assignment__c = 'PRIMARY';
            srt1.srt_time__c = 1;
            srt1.SRT_ID__c = '00-901-11';
            srt1.Component_id__c = solcomp.id;
            srt1.isPerformed__c = true;
            SRTList.add(srt1); 
            
        CSS_SRT__C srtRef = new CSS_SRT__C();
            srtRef.Solution_Number__c = sol.id;
            srtRef.Job_Order__c = JO1.id;
            srtRef.SRT_AccessiblityCheck__c=True;
            srtRef.Access_Code_A__c = 65;
            srtRef.name = 'TestClassName';
            srtRef.type__c = 'Repair';
            srtRef.SRT_ID__c = '00-901-10';
            srtRef.SRT_Time__c = 0.4;
            srtRef.Component_id__c = solcomp.id;
            srtRef.isPerformed__c = true;
            srtList.add(srtRef);
            insert srtList;
            
       List<CSS_SRT__C> SRTListFA = new List<CSS_SRT__C>();
            CSS_SRT__C srtFA = new CSS_SRT__C();
            srtFA.Solution_Number__c = Sol.id;
            srtFA.Job_Order__c = JO1.id;
            srtFA.SRT_AccessiblityCheck__c=True;
            srtFA.Access_Code_A__c = 65;
            srtFA.name = 'TestClassName';
            srtFA.type__c = 'Field Action';
            srtFA.Assignment__c = 'PRIMARY';
            srtFA.srt_time__c = 1;
            srtFA.SRT_ID__c = '00-901-12';
            srtFA.Component_id__c = solcomp.id;
            srtFA.isPerformed__c = true;
            SRTListFA.add(srtFA);
            insert SRTListFA;
       
       List<CSS_SRT__C> OverlapSRTList = new List<CSS_SRT__C>();
       CSS_SRT__C srtRep1 = new CSS_SRT__C();
            srtRep1.Job_Order__c = JO1.id;
            srtRep1.SRT_ID__c = '00-901-13';
            srtRep1.SRT_Time__c = 465;
            srtRep1.name = 'Test';
            srtRep1.Type__c = 'Overlap';
            srtRep1.SRT_Order__c = 1;
            srtRep1.Account_Code__c = 'Emissions Warranty 70';
            srtRep1.Assignment__c = 'Primary';
            srtRep1.srt_category__c = 'AdditionalDiag';
            OverlapSRTList.add(srtRep1);
            insert OverlapSRTList;
        
        PageReference pg = Page.CSS_JobTnDRj;
        Test.setCurrentPage(pg);    
        ApexPages.currentPage().getParameters().put('id', JO1.Id);
        
        test.startTest();
        CSS_DARSRT srtI = new CSS_DARSRT(); 
        srtI.calculateExtendedHours();
        test.stopTest();
    }
    public static testMethod void testDarSRTMoreTime_41(){
        
        //Covers Anirudh 2 diagList
        Test.startTest(); 
        
        List<CSS_Srt__c> additionalSRTList = new List<CSS_Srt__c>();        
        
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02466';
        acc.IAM_Service_Provider_Code__c='19134';
        acc.Type='Dealer Account';
        acc.CMI_Account_Status__c = 'Active';
        insert acc;
        
        CSS_Job_Order__c JO = new CSS_Job_Order__c();
        JO.Customer_Name__c = 'CumminsTnD';
        JO.Equipment_ID__c = 'EQ7667';
        JO.Qsol_Engine_Family_Code__c ='56';
        JO.AccessCode__c = 'A';
        JO.Account__c = acc.id;
        insert JO;
        
        Map<Id, Boolean> mpb = new Map<Id, Boolean>{JO.Id=>true};
            
            
            
        CSS_SRT__C srtRep = new CSS_SRT__C();
        srtRep.Job_Order__c = JO.id;
        srtRep.SRT_Time__c = 465;
        srtRep.name = 'Test';
        srtRep.isPerformed__c = true;
        srtRep.Type__c = 'Private';
        srtRep.SRT_Order__c = 1;
        srtRep.Account_Code__c = 'Emissions Warranty 70';
        srtRep.Assignment__c = 'Primary';
        srtRep.srt_category__c = 'AdditionalDiag';
        insert srtRep;
        
             
        
        CSS_SRT__C srtAddiRepAccess = new CSS_SRT__C();
        srtAddiRepAccess.SRT_AccessiblityCheck__c=True;
        srtAddiRepAccess.SRT_Time__c = 865;
        srtAddiRepAccess.SRT_Quantity__c=1;
        srtAddiRepAccess.Job_Order__c = JO.id;
        srtAddiRepAccess.name = 'Test';
        srtAddiRepAccess.isPerformed__c = true;
        srtAddiRepAccess.Type__c = 'Private';
        //srtAddiRepAccess.Account_Code__c = 'Emissions Warranty 70';
        srtAddiRepAccess.Assignment__c = 'Primary';
        srtAddiRepAccess.srt_category__c = 'AdditionalDiag';
        insert srtAddiRepAccess;
        
        CSS_SRT__C srtAddiRepAccess2 = new CSS_SRT__C();
        srtAddiRepAccess2.isPerformed__c=True;
        srtAddiRepAccess2.SRT_Time__c = 865;
        srtAddiRepAccess2.SRT_Quantity__c=1;
        srtAddiRepAccess2.Job_Order__c = JO.id;
        srtAddiRepAccess2.name = 'Test';
        srtAddiRepAccess2.isPerformed__c = true;
        srtAddiRepAccess2.Type__c = 'Private';
        srtAddiRepAccess2.Access_Code__c='A';
        srtAddiRepAccess2.Access_Code_A__c=1.0;
        //srtAddiRepAccess.Account_Code__c = 'Emissions Warranty 70';
        srtAddiRepAccess2.Assignment__c = 'Primary';
        srtAddiRepAccess2.srt_category__c = 'AdditionalDiag';
        insert srtAddiRepAccess2;
        
        CSS_SRT__C srtAddiRepAccess1 = new CSS_SRT__C();
        srtAddiRepAccess1.SRT_AccessiblityCheck__c=True;
        srtAddiRepAccess1.SRT_Time__c = 865;
        srtAddiRepAccess1.SRT_Quantity__c=1;
        srtAddiRepAccess1.isPerformed__c = true;
        srtAddiRepAccess1.Job_Order__c = JO.id;
        srtAddiRepAccess1.name = 'Test';
        srtAddiRepAccess1.Type__c = 'Private';
        srtAddiRepAccess1.Account_Code__c = 'Emissions Warranty 70';
        srtAddiRepAccess1.Assignment__c = 'Primary';
        srtAddiRepAccess1.srt_category__c = 'AdditionalRep';
        insert srtAddiRepAccess1;
        
        
        additionalSRTList.add(srtRep);
        additionalSRTList.add(srtAddiRepAccess);
        additionalSRTList.add(srtAddiRepAccess1);
        additionalSRTList.add(srtAddiRepAccess2);
        
        
        ApexPages.currentPage().getParameters().put('id', JO.Id);        
        CSS_DARSRT srt = new CSS_DARSRT();
        srt.selectedSrtId = srtAddiRepAccess2.id;
        //srt.getrepairTime();
        // srt.getRepairAccessTime();
        //Test.setMock(HttpCalloutMock.class, new CSS_MockOverlapSRT_Test());
        srt.saveRepairData(); 
        srt.onChangeRepAccountCode();
        
        Test.stopTest();     
    }
    public static testMethod void testAddSRT511(){ 
        
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02466';
        acc.IAM_Service_Provider_Code__c='19134';
        acc.Type='Dealer Account';
        acc.CMI_Account_Status__c = 'Active';
        insert acc;
            
        CSS_Job_Order__c JO1 = new CSS_Job_Order__c();
        JO1.Customer_Name__c = 'CumminsTnD';
        JO1.Equipment_ID__c = 'EQ7667';
        JO1.Qsol_Engine_Family_Code__c ='56';
        JO1.AccessCode__c = 'A';
        JO1.Account__c = acc.id;
        insert JO1;
        
        PageReference pg = Page.CSS_JobTnDRj;
        Test.setCurrentPage(pg);    
        ApexPages.currentPage().getParameters().put('id', JO1.Id);
        
        CSS_Solutions__c Sol = CSS_TestData.createSolutions(true,JO1.id);
        CSS_Solution_Component__c solcomp = CSS_TestData.createSRT(true,JO1.id,sol.id);
        solcomp.System_Code__c = 'Test';
        update solcomp;
        
        CSS_SRT__C srtRef2 = new CSS_SRT__C();
        srtRef2.Solution_Number__c = Sol.id;
        srtRef2.Job_Order__c = JO1.id;
        srtRef2.SRT_AccessiblityCheck__c=True;
        srtRef2.name = 'Additional SRT';
        srtRef2.type__c = 'Diagnosis';
        srtRef2.SRT_ID__c = '00-901-10';
        srtRef2.srt_time__c = 0.2;
        srtRef2.isPerformed__c = true;
        srtRef2.SRT_Category__c = 'Diag';
        srtRef2.Account_Code__c='Emissions';
        srtRef2.Component_id__c = solcomp.id;
        srtRef2.Assignment__c = 'PRIMARY';
        insert srtRef2;
        
        CSS_SRT__C srt = new CSS_SRT__C();
        srt.Solution_Number__c = Sol.id;
        srt.Job_Order__c = JO1.id;
        srt.SRT_AccessiblityCheck__c=True;
        srt.Access_Code_A__c = 65;
        srt.name = 'TestClassName';
        srt.type__c = 'Diagnosis';
        srt.Assignment__c = 'PRIMARY';
        srt.srt_time__c = 1;
        srt.SRT_ID__c = '00-901-10';
        srt.Component_id__c = solcomp.id;
        srt.isPerformed__c = true;
        insert srt;
        
        decimal time1 = [select id,Repair_Access_Calculated__c from css_srt__c where id = :srt.id].Repair_Access_Calculated__c;
        
        CSS_SRT__C srtRef = new CSS_SRT__C();
        srtRef.Solution_Number__c = sol.id;
        srtRef.Job_Order__c = JO1.id;
        srtRef.SRT_AccessiblityCheck__c=True;
        srtRef.Access_Code_A__c = 65;
        srtRef.name = 'TestClassName';
        srtRef.type__c = 'Diagnosis';
        srtRef.SRT_ID__c = '00-901-10';
        srtRef.SRT_Time__c = 0.4;
        srtRef.Component_id__c = solcomp.id;
        srtRef.isPerformed__c = true;
        insert srtRef;
        
        
        CSS_SRT__C srtRef1 = new CSS_SRT__C();
        srtRef1.Job_Order__c = JO1.id;
        srtRef1.SRT_AccessiblityCheck__c=True;
        srtRef1.name = 'Additional SRT';
        srtRef1.type__c = 'Diagnosis';
        srtRef1.SRT_ID__c = '00-901-01';
        srtRef1.srt_time__c = 0.2;
        srtRef1.isPerformed__c = true;
        srtRef1.SRT_Category__c = 'AdditionalDiag';
        srtRef1.Account_Code__c='Emissions';
        insert srtRef1;

List<CSS_Solution_Component__c> solsComplst = new List<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solcomp2 = new CSS_Solution_Component__c();
         solcomp2.Service_Job__c = JO1.id;
         solcomp2.Selected_Component__c = true;
         solcomp2.System_Code__c = 'THER';
         solcomp2.CoveredLaborHrs__c = '12';
         solcomp2.Component_Code__c = 'ASFF';
         solcomp2.AccountCodeEdit__c = 'Test';
         solcomp2.Type__c = 'Campaign';
         insert solcomp2;
         solsComplst.add(solcomp2);
        
         CSS_Solution_Component__c solcomp1 = new CSS_Solution_Component__c();
         solcomp1.Service_Job__c = JO1.id;
         solcomp1.Selected_Component__c = true;
         solcomp1.System_Code__c = 'THER';
         solcomp1.Component_Code__c = 'ASFF';
         solcomp1.AccountCodeEdit__c = 'Test';
         solcomp1.Type__c = 'Campaign';
         insert solcomp1;
         solsComplst.add(solcomp1);
        
        
        
        list<CSS_SRT__C> AdditionalSrt = [Select id,name from CSS_SRT__C where Job_Order__c=:Jo1.Id and Solution_Number__c = null];
        map<string,string> mapwarrantymap =  new map<string,string>();
        mapwarrantymap.put('Emissions','Emissions');
        
       
        system.assert(AdditionalSrt!=null);
        CSS_DARSRT srta = new CSS_DARSRT(); 
        srta.searchDiagValue = 'Administrative';
        srta.selectedSolId='';
        srta.selectedSrtId=srt.id;
        srta.accountCodeWithWarrantMap = mapwarrantymap;
        test.startTest();
        
        Test.setMock(HttpCalloutMock.class, new CSS_AccessToken_SRT_Test());
        Test.setMock(HttpCalloutMock.class, new CSS_getAllRepDiagSRTs_Test());
        
        srta.searchDiagValue = 'Administrative';
        srta.countDiag = 1;
        list<SelectOption> lstselect = new list<SelectOption>();
                
        srta.getsVfComp();
        srta.getAllACS();
        srta.changeDownOrder();
        srta.setsVfComp(JO1.id);
        //srta.onChangeAccountCode();
        srta.calculateExtendedHours();
        srta.getMaxSortOrder();
        test.stopTest();
    }
    public static testMethod void testAddSRT61(){
         CSS_DARSRT dd = new CSS_DARSRT();
        dd.SelectedFailCode = 'THAS';
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02466';
        acc.IAM_Service_Provider_Code__c='19134';
        acc.Type='Dealer Account';
        acc.CMI_Account_Status__c = 'Active';
        insert acc;
        
        CSS_Job_Order__c JO1 = new CSS_Job_Order__c();
        JO1.Customer_Name__c = 'CumminsTnD';
        JO1.Equipment_ID__c = 'EQ7667';
        JO1.Qsol_Engine_Family_Code__c ='56';
        JO1.AccessCode__c = 'A';
        JO1.Account__c = acc.id;
        insert JO1;
        
        PageReference pg = Page.CSS_JobTnDRj;
        Test.setCurrentPage(pg);    
        ApexPages.currentPage().getParameters().put('id', JO1.Id);
        
        CSS_Solutions__c Sol = CSS_TestData.createSolutions(true,JO1.id);
        Sol.Diagnostic_Response__c = 'Most likely the solution';
        Update sol;
        
        List<CSS_Solution_Component__c> solsComplst = new List<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solcomp = new CSS_Solution_Component__c();
         solcomp.Service_Job__c = JO1.id;
         solcomp.Selected_Component__c = true;
         solcomp.System_Code__c = 'THER';
         solcomp.Component_Code__c = 'ASFF';
         solcomp.AccountCodeEdit__c = 'Test';
         solcomp.Type__c = null;
         insert solcomp;
         solsComplst.add(solcomp);
         CSS_Solution_Component__c solcomp1 = new CSS_Solution_Component__c();
         solcomp1.Service_Job__c = JO1.id;
         solcomp1.Selected_Component__c = true;
         solcomp1.System_Code__c = 'THER';
         solcomp1.Component_Code__c = 'ASFF';
         solcomp1.AccountCodeEdit__c = 'Test';
         solcomp1.Type__c = null;
         solcomp1.CoveredLaborHrs__c='99999';
         insert solcomp1;
         solsComplst.add(solcomp1);
         
         system.debug('solsComplst'+solsComplst);
        
        CSS_SRT__C srt = new CSS_SRT__C();
        srt.Solution_Number__c = Sol.id;
        srt.Job_Order__c = JO1.id;
        srt.SRT_AccessiblityCheck__c=True;
        srt.Access_Code_A__c = 65;
        srt.name = 'TestClassName';
        srt.type__c = 'Diagnosis';
        srt.Assignment__c = 'PRIMARY';
        srt.srt_time__c = 1;
        srt.SRT_ID__c = '00-901-10';
        srt.Component_id__c = solcomp.id;
        srt.isPerformed__c = true;
        insert srt;
        
        decimal time1 = [select id,Repair_Access_Calculated__c from css_srt__c where id = :srt.id].Repair_Access_Calculated__c;
        
        CSS_SRT__C srtRef = new CSS_SRT__C();
        srtRef.Solution_Number__c = sol.id;
        srtRef.Job_Order__c = JO1.id;
        srtRef.SRT_AccessiblityCheck__c=True;
        srtRef.Access_Code_A__c = 65;
        srtRef.name = 'TestClassName';
        srtRef.type__c = 'Repair';
        srtRef.SRT_ID__c = '00-901-10';
        srtRef.SRT_Time__c = 0.4;
        srtRef.Component_id__c = solcomp.id;
        srtRef.isPerformed__c = true;
        insert srtRef;
        
        CSS_SRT__C srtRep1 = new CSS_SRT__C();
        srtRep1.Job_Order__c = JO1.id;
        srtRep1.SRT_ID__c = '00-901-10';
        srtRep1.SRT_Time__c = 465;
        srtRep1.name = 'Test';
        srtRep1.Type__c = 'Overlap';
        srtRep1.SRT_Order__c = 1;
        srtRep1.Account_Code__c = 'Emissions Warranty 70';
        srtRep1.Assignment__c = 'Primary';
        srtRep1.srt_category__c = 'AdditionalDiag';
        insert srtRep1;
        
        CSS_SRT__C srtRef1 = new CSS_SRT__C();
        srtRef1.Job_Order__c = JO1.id;
        //  srtRef1.Id = '123';
        srtRef1.SRT_AccessiblityCheck__c=True;
        srtRef1.name = 'Additional SRT';
        srtRef1.type__c = 'Access';
        srtRef1.SRT_ID__c = '00-901-01';
        srtRef1.srt_time__c = 0.2;
        srtRef1.isPerformed__c = true;
        srtRef1.SRT_Category__c = 'AdditionalRep';
        srtRef1.Account_Code__c='Emissions';
        insert srtRef1;
        list<CSS_SRT__C> AdditionalSrt = [Select id,name from CSS_SRT__C where Job_Order__c=:Jo1.Id and Solution_Number__c = null];
        map<string,string> mapwarrantymap =  new map<string,string>();
        mapwarrantymap.put('Emissions','Emissions');
        
        system.assert(AdditionalSrt!=null);
        CSS_DARSRT srta = new CSS_DARSRT();
        //CSS_DARSRT dd = new CSS_DARSRT();
        srta.SelectedFailCode = 'THAS';
        srta.searchDiagValue = 'Administrative';
        srta.selectedSolId=Sol.id;
        srta.selectedSrtId=srt.id;
        srta.accountCodeWithWarrantMap = mapwarrantymap;
        srta.seltdSRTId = string.valueOf(srtRef1.id);
        
         test.startTest();
        
        Test.setMock(HttpCalloutMock.class, new CSS_AccessToken_SRT_Test());
        Test.setMock(HttpCalloutMock.class, new CSS_getAllRepDiagSRTs_Test());
        
        srta.searchDiagValue = 'Administrative';
        srta.countDiag = 1;
        
        srta.getsVfComp();
        
        srta.getAllACS();
        //  srta.changeDownOrder();
        srta.setsVfComp(JO1.id);
        
        //srta.onChangeAccountCode();
        srta.getonchangefailCode();
        srta.onChangeofFailCode();
        Map<String,List<CSS_SRT__c>> csrt=new Map<String,List<CSS_SRT__c>>();
        csrt.put('Test',AdditionalSrt);
        srta.createOverlapSRT(csrt);
        test.stopTest();
    }
 public static testMethod void testAddSRT62(){
         CSS_DARSRT dd = new CSS_DARSRT();
        dd.SelectedFailCode = 'THAS';
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02466';
        acc.IAM_Service_Provider_Code__c='19134';
        acc.Type='Dealer Account';
        acc.CMI_Account_Status__c = 'Active';
        insert acc;
        
        CSS_Job_Order__c JO1 = new CSS_Job_Order__c();
        JO1.Customer_Name__c = 'CumminsTnD';
        JO1.Equipment_ID__c = 'EQ7667';
        JO1.Qsol_Engine_Family_Code__c ='56';
        JO1.AccessCode__c = 'A';
        JO1.Account__c = acc.id;
        insert JO1;
        
        PageReference pg = Page.CSS_JobTnDRj;
        Test.setCurrentPage(pg);    
        ApexPages.currentPage().getParameters().put('id', JO1.Id);
        
        CSS_Solutions__c Sol = CSS_TestData.createSolutions(true,JO1.id);
        Sol.Diagnostic_Response__c = 'Most likely the solution';
        Update sol;
        
        List<CSS_Solution_Component__c> solsComplst = new List<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solcomp = new CSS_Solution_Component__c();
         solcomp.Service_Job__c = JO1.id;
         solcomp.Selected_Component__c = true;
         solcomp.System_Code__c = 'THER';
         solcomp.Component_Code__c = 'ASFF';
         solcomp.AccountCodeEdit__c = 'Test';
         solcomp.Type__c = 'null';
         insert solcomp;
         solsComplst.add(solcomp);
         CSS_Solution_Component__c solcomp1 = new CSS_Solution_Component__c();
         solcomp1.Service_Job__c = JO1.id;
         solcomp1.Selected_Component__c = true;
         solcomp1.System_Code__c = 'THER';
         solcomp1.Component_Code__c = 'ASFF';
         solcomp1.AccountCodeEdit__c = 'Test';
         solcomp1.Type__c = 'TEST';
         solcomp1.CoveredLaborHrs__c='99999';
         insert solcomp1;
         solsComplst.add(solcomp1);
         
        
        
        CSS_SRT__C srt = new CSS_SRT__C();
        srt.Solution_Number__c = Sol.id;
        srt.Job_Order__c = JO1.id;
        srt.SRT_AccessiblityCheck__c=True;
        srt.Access_Code_A__c = 0;
        srt.Access_Code_B__c = 0;
        srt.Access_Code_C__c = 0;
        srt.Access_Code_D__c = 0;
        srt.Access_Code_R__c = 12;
        srt.name = 'TestClassName';
        srt.type__c = 'Diagnosis';
        srt.Assignment__c = 'PRIMARY';
        srt.srt_time__c = 1;
        srt.SRT_ID__c = '00-901-10';
        srt.Component_id__c = solcomp.id;
        srt.isPerformed__c = true;
        insert srt;
        
        decimal time1 = [select id,Repair_Access_Calculated__c from css_srt__c where id = :srt.id].Repair_Access_Calculated__c;
        
        CSS_SRT__C srtRef = new CSS_SRT__C();
        srtRef.Solution_Number__c = sol.id;
        srtRef.Job_Order__c = JO1.id;
        srtRef.SRT_AccessiblityCheck__c=True;
        srtRef.Access_Code_A__c = 65;
        srtRef.name = 'TestClassName';
        srtRef.type__c = 'Repair';
        srtRef.SRT_ID__c = '00-901-10';
        srtRef.SRT_Time__c = 0.4;
        srtRef.Component_id__c = solcomp.id;
        srtRef.isPerformed__c = true;
        insert srtRef;
        
        CSS_SRT__C srtRep1 = new CSS_SRT__C();
        srtRep1.Job_Order__c = JO1.id;
        srtRep1.SRT_ID__c = '00-901-10';
        srtRep1.SRT_Time__c = 465;
        srtRep1.name = 'Test';
        srtRep1.Type__c = 'Overlap';
        srtRep1.SRT_Order__c = 1;
        srtRep1.Account_Code__c = 'Emissions Warranty 70';
        srtRep1.Assignment__c = 'Primary';
        srtRep1.srt_category__c = 'AdditionalDiag';
        insert srtRep1;
        
        CSS_SRT__C srtRef1 = new CSS_SRT__C();
        srtRef1.Job_Order__c = JO1.id;
        //  srtRef1.Id = '123';
        srtRef1.SRT_AccessiblityCheck__c=True;
        srtRef1.name = 'Additional SRT';
        srtRef1.type__c = 'Access';
        srtRef1.SRT_ID__c = '00-901-01';
        srtRef1.srt_time__c = 0.2;
        srtRef1.isPerformed__c = true;
        srtRef1.SRT_Category__c = 'AdditionalRep';
        srtRef1.Account_Code__c='Emissions';
        insert srtRef1;
        list<CSS_SRT__C> AdditionalSrt = [Select id,name from CSS_SRT__C where Job_Order__c=:Jo1.Id and Solution_Number__c = null];
        map<string,string> mapwarrantymap =  new map<string,string>();
        mapwarrantymap.put('Emissions','Emissions');
        
        system.assert(AdditionalSrt!=null);
        CSS_DARSRT srta = new CSS_DARSRT();
        //CSS_DARSRT dd = new CSS_DARSRT();
        srta.SelectedFailCode = 'THAS';
        srta.searchDiagValue = 'Administrative';
        srta.selectedSolId=Sol.id;
        srta.selectedSrtId=srt.id;
        srta.accountCodeWithWarrantMap = mapwarrantymap;
        srta.seltdSRTId = string.valueOf(srtRef1.id);
        
         test.startTest();
        
        Test.setMock(HttpCalloutMock.class, new CSS_AccessToken_SRT_Test());
        Test.setMock(HttpCalloutMock.class, new CSS_getAllRepDiagSRTs_Test());
        
        srta.searchDiagValue = 'Administrative';
        srta.countDiag = 1;
        
        srta.getsVfComp();
        
        srta.getAllACS();
        //  srta.changeDownOrder();
        srta.setsVfComp(JO1.id);
        
        
        srta.getonchangefailCode();
        srta.onChangeofFailCode();
        Map<String,List<CSS_SRT__c>> csrt=new Map<String,List<CSS_SRT__c>>();
        csrt.put('Test',AdditionalSrt);
        srta.createOverlapSRT(csrt);  
        test.stopTest();
    }
    
    
    
    
}