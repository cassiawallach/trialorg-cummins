@isTest
public class CSS_DARSRT_RO_Test {
    public static testMethod void testAddSRT() { 
        
        
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
        JO1.Account__c=acc.id;
        insert JO1;
        
        css_solutions__c sol = new css_solutions__c();
        sol.Service_Job__c=jo1.id;
        insert sol;
        
        CSS_Solution_Component__c solcomp = new CSS_Solution_Component__c();
        solComp.Service_Job__c=jo1.Id;
        insert solcomp;
        
        PageReference pg = Page.CSS_JobTnDRj;
        
        Test.setCurrentPage(pg);    
        ApexPages.currentPage().getParameters().put('id', JO1.Id);
        
        List<CSS_SRT__C> lstsrt = new List<CSS_SRT__C>();
        CSS_SRT__C srtRef = new CSS_SRT__C();
        srtRef.Solution_Number__c = null;
        srtRef.Job_Order__c = JO1.id;
        srtRef.SRT_AccessiblityCheck__c=True;
        srtRef.Access_Code_A__c = 65;
        srtRef.name = 'TestClassName';
        srtRef.SRT_ID__c = '00-901-00';
        insert srtRef;
        lstsrt.add(srtRef); 
        
        PageReference pref = new PageReference('/'+JO1.id);
        pref.getParameters().put('id',JO1.id);
        Test.setCurrentPage(pref);
        
        test.startTest();          
        CSS_DARSRT_RO srta = new CSS_DARSRT_RO(); 
        srta.lstDisplayDiagSRT = lstsrt;
        // srta.searchValue='Testing';
        Test.setMock(HttpCalloutMock.class, new CSS_AccessToken_SRT_Test());
        Test.setMock(HttpCalloutMock.class, new CSS_getAllRepDiagSRTs_Test());
        // srta.getDiagnosisSRTs();
        srta.gotoJobPlanSrt();
        //srta.searchDiagSRTCodeAndDescription();
        //srta.getRepairSRTs();
        //  srta.saveDiagBox();
        //    srta.saveRepBox();
        //   srta.getsVfComp();
        //   srta.getRepairAccessTime();
        //srta.getrepairTime();
        //  srta.getDiagAccessTime();
        //  srta.getAllACS();
        //   srta.changeDownOrder();
        //   srta.setsVfComp(JO1.id);
        //   srta.getallData();
        //   srta.searchSRTCodeAndDescription();
        //   srta.showPopup();
        //   srta.closePopup();
        //    srta.showPopup1();
        //    srta.closePopup1();
        //    srta.getdiagnosisTime();
        //    srta.getrepairTime();
        //    srta.changeUpOrder();
        //    srta.saveDiagData();
        //    srta.saveRepairData();
        srta.diagTotal= true;
        srta.repAccTime= 'test';
        
        
        test.stopTest();
        //CSS_WS_SRT wssrt = new CSS_WS_SRT();
        Test.setMock(HttpCalloutMock.class, new CSS_getAllRepDiagSRTs_Test());
        CSS_WS_SRT.getAllDigRepSRTs(JO1.ID,'Diagnostic');  
        CSS_WS_SRT.getAllDigRepSRTs(JO1.ID,'Repair');  
    }
    
    public static testMethod void testAddSRT_Method1() { 
        
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02466';
        acc.IAM_Service_Provider_Code__c='19134';
        acc.Type='Dealer Account';
        acc.CMI_Account_Status__c = 'Active';
        insert acc;
        
        CSS_Job_Order__c JO1 = new CSS_Job_Order__c();
        JO1.Account__c=acc.id;
        JO1.Customer_Name__c = 'CumminsTnD';
        JO1.Equipment_ID__c = 'EQ7667';
        JO1.Qsol_Engine_Family_Code__c ='56';
        JO1.AccessCode__c = 'A';
        insert JO1;
        
        css_solutions__c sol = new css_solutions__c();
        sol.Diagnostic_Response__c = 'Most likely the solution';
        sol.Service_Job__c=jo1.id;
        insert sol;
        
        CSS_Solution_Component__c solcomp = new CSS_Solution_Component__c();
        solComp.Component_Id__c ='F0051111';
        solComp.Service_Job__c=jo1.Id;
        solComp.Solutions__c = sol.id;
        insert solcomp;
        
        PageReference pg = Page.CSS_JobTnDRj;
        
        Test.setCurrentPage(pg);    
        ApexPages.currentPage().getParameters().put('id', JO1.Id);
        
        List<CSS_SRT__C> lstsrt = new List<CSS_SRT__C>();
        CSS_SRT__C srtRef = new CSS_SRT__C();
        srtRef.Solution_Number__c = sol.Id;
        srtRef.Component_Id__c = solcomp.id;
        srtRef.Job_Order__c = JO1.id;
        srtRef.SRT_AccessiblityCheck__c=True;
        srtRef.Access_Code_A__c = 65;
        srtRef.name = 'TestClassName';
        srtRef.SRT_ID__c = '00-901-00';
        srtRef.Type__c = 'Repair';
        srtRef.Assignment__c = 'Primary';
        insert srtRef;
        lstsrt.add(srtRef);
        
        //insert lstsrt;
        
        PageReference pref = new PageReference('/'+JO1.id);
        pref.getParameters().put('id',JO1.id);
        Test.setCurrentPage(pref);
        
        test.startTest();          
        CSS_DARSRT_RO srta = new CSS_DARSRT_RO(); 
        srta.lstDisplayDiagSRT = lstsrt;
        ///    srta.searchValue='00-901-00';
        Test.setMock(HttpCalloutMock.class, new CSS_AccessToken_SRT_Test());
        Test.setMock(HttpCalloutMock.class, new CSS_getAllRepDiagSRTs_Test());
        //    srta.getDiagnosisSRTs();
        srta.gotoJobPlanSrt();
        //    srta.searchDiagSRTCodeAndDescription();
        //    srta.getRepairSRTs();
        //    srta.saveDiagBox();
        //    srta.saveRepBox();
        //    srta.getsVfComp();
        //    srta.getRepairAccessTime();
        //srta.getrepairTime();
        //     srta.getDiagAccessTime();
        //    srta.getAllACS();
        //    srta.changeDownOrder();
        //    srta.setsVfComp(JO1.id);
        //    srta.getallData();
        //    srta.searchSRTCodeAndDescription();
        //    srta.showPopup();
        //    srta.closePopup();
        //    srta.showPopup1();
        //    srta.closePopup1();
        //    srta.getdiagnosisTime();
        //    srta.getrepairTime();
        //    srta.changeUpOrder();
        //    srta.saveDiagData();
        //    srta.saveRepairData();
        srta.diagTotal= true;
        srta.repAccTime= 'test';
        
        
        test.stopTest();
        //CSS_WS_SRT wssrt = new CSS_WS_SRT();
        Test.setMock(HttpCalloutMock.class, new CSS_getAllRepDiagSRTs_Test());
        CSS_WS_SRT.getAllDigRepSRTs(JO1.ID,'Diagnostic');  
        CSS_WS_SRT.getAllDigRepSRTs(JO1.ID,'Repair');  
    }
    
    public static testMethod void testAddSRT_Method2() { 
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02466';
        acc.IAM_Service_Provider_Code__c='19134';
        acc.Type='Dealer Account';
        acc.CMI_Account_Status__c = 'Active';
        insert acc;
        
        CSS_Job_Order__c JO1 = new CSS_Job_Order__c();
        JO1.Account__c=acc.id;
        JO1.Customer_Name__c = 'CumminsTnD';
        JO1.Equipment_ID__c = 'EQ7667';
        JO1.Qsol_Engine_Family_Code__c ='56';
        JO1.AccessCode__c = 'A';
        insert JO1;
        
        css_solutions__c sol = new css_solutions__c();
        sol.Diagnostic_Response__c = 'Most likely the solution';
        sol.Service_Job__c=jo1.id;
        insert sol;
        
        CSS_Solution_Component__c solcomp = new CSS_Solution_Component__c();
        solComp.Service_Job__c=jo1.Id;
        insert solcomp;
        
        PageReference pg = Page.CSS_JobTnDRj;
        
        Test.setCurrentPage(pg);    
        ApexPages.currentPage().getParameters().put('id', JO1.Id);
        
        List<CSS_SRT__C> lstsrt = new List<CSS_SRT__C>();
        CSS_SRT__C srtRef1 = new CSS_SRT__C();
        srtRef1.Solution_Number__c = sol.Id;
        srtRef1.Job_Order__c = JO1.id;
        srtRef1.SRT_AccessiblityCheck__c=True;
        srtRef1.Access_Code_A__c = 65;
        srtRef1.name = 'TestClassName';
        srtRef1.SRT_ID__c = '00-901-01';
        srtRef1.Type__c = 'Diag Access';
        insert srtRef1;
        lstsrt.add(srtRef1);
        
        //insert lstsrt;
        
        PageReference pref = new PageReference('/'+JO1.id);
        pref.getParameters().put('id',JO1.id);
        Test.setCurrentPage(pref);
        
        test.startTest();          
        CSS_DARSRT_RO srta = new CSS_DARSRT_RO(); 
        srta.lstDisplayDiagSRT = lstsrt;
        //    srta.searchValue='Testing';
        Test.setMock(HttpCalloutMock.class, new CSS_AccessToken_SRT_Test());
        Test.setMock(HttpCalloutMock.class, new CSS_getAllRepDiagSRTs_Test());
        //    srta.getDiagnosisSRTs();
        srta.gotoJobPlanSrt();
        //    srta.searchDiagSRTCodeAndDescription();
        //    srta.getRepairSRTs();
        //    srta.saveDiagBox();
        //    srta.saveRepBox();
        //    srta.getsVfComp();
        //srta.getRepairAccessTime();
        //srta.getrepairTime();
        //    srta.getDiagAccessTime();
        //    srta.getAllACS();
        //    srta.changeDownOrder();
        //    srta.setsVfComp(JO1.id);
        //    srta.getallData();
        //    srta.searchSRTCodeAndDescription();
        //    srta.showPopup();
        //    srta.closePopup();
        //    srta.showPopup1();
        //    srta.closePopup1();
        //    srta.getdiagnosisTime();
        //srta.getrepairTime();
        //   srta.changeUpOrder();
        //    srta.saveDiagData();
        //   srta.saveRepairData();
        srta.diagTotal= true;
        srta.repAccTime= 'test';
        
        
        test.stopTest();
        //CSS_WS_SRT wssrt = new CSS_WS_SRT();
        Test.setMock(HttpCalloutMock.class, new CSS_getAllRepDiagSRTs_Test());
        CSS_WS_SRT.getAllDigRepSRTs(JO1.ID,'Diagnostic');  
        CSS_WS_SRT.getAllDigRepSRTs(JO1.ID,'Repair');  
    }
    
    public static testMethod void testAddSRT_Method3() { 
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02466';
        acc.IAM_Service_Provider_Code__c='19134';
        acc.Type='Dealer Account';
        acc.CMI_Account_Status__c = 'Active';
        insert acc;
        
        CSS_Job_Order__c JO1 = new CSS_Job_Order__c();
        JO1.Account__c=acc.id;
        JO1.Customer_Name__c = 'CumminsTnD';
        JO1.Equipment_ID__c = 'EQ7667';
        JO1.Qsol_Engine_Family_Code__c ='56';
        JO1.AccessCode__c = 'A';
        insert JO1;
        
        css_solutions__c sol = new css_solutions__c();
        sol.Diagnostic_Response__c = 'Most likely the solution';
        sol.Repair_Response__c = 'Most likely';
        sol.Service_Job__c=jo1.id;
        insert sol;
        
        List<CSS_Solution_Component__c> solcompList = new List<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solcomp = new CSS_Solution_Component__c();
        solComp.Component_Id__c ='F0051000';
        solComp.Service_Job__c=jo1.Id;
        solcompList.add(solcomp);
        
        CSS_Solution_Component__c solcomp1 = new CSS_Solution_Component__c();
        solComp1.Component_Id__c ='F0051011';
        solComp1.Service_Job__c=jo1.Id;
        solComp1.Selected_Component__c = true;
        solComp1.Solutions__c = sol.id;
        solcompList.add(solcomp1);
        
        insert solcompList;
        
        List<CSS_SRT__C> lstsrt = new List<CSS_SRT__C>();
        CSS_SRT__C srtRef1 = new CSS_SRT__C();
        srtRef1.Solution_Number__c = sol.Id;
        srtRef1.Job_Order__c = JO1.id;
        srtRef1.SRT_AccessiblityCheck__c=True;
        srtRef1.Access_Code_A__c = 65;
        srtRef1.name = 'TestClassName';
        srtRef1.SRT_ID__c = '00-901-01';
        srtRef1.Type__c = 'Repair Access';
        srtRef1.Assignment__c = 'Primary';
        srtRef1.SRT_Quantity__c = 1;
        //insert srtRef1;
        lstsrt.add(srtRef1);
        
        
        CSS_SRT__C srtRef = new CSS_SRT__C();
        srtRef.Solution_Number__c = sol.Id;
        srtRef.Job_Order__c = JO1.id;
        srtRef.Component_Id__c = solcompList[1].id;
        srtRef.SRT_AccessiblityCheck__c=True;
        srtRef.Access_Code_A__c = 65;
        srtRef.name = 'TestClassName';
        srtRef.SRT_ID__c = '00-901-02';
        srtRef.Type__c = 'Repair';
        srtRef.Assignment__c = 'Primary';
        srtRef.SRT_Quantity__c = 1;
        //insert srtRef1;
        lstsrt.add(srtRef);
        
        insert lstsrt;
        
        test.startTest(); 
        PageReference pg = Page.CSS_JobTnDRj;
        Test.setCurrentPage(pg);    
        ApexPages.currentPage().getParameters().put('id', JO1.Id);        
        CSS_DARSRT_RO srta = new CSS_DARSRT_RO(); 
        srta.lstDisplayDiagSRT = lstsrt;
        //      srta.searchValue='Testing';
        Test.setMock(HttpCalloutMock.class, new CSS_AccessToken_SRT_Test());
        Test.setMock(HttpCalloutMock.class, new CSS_getAllRepDiagSRTs_Test());
        //      srta.getDiagnosisSRTs();
        srta.gotoJobPlanSrt();
        //      srta.searchDiagSRTCodeAndDescription();
        //      srta.getRepairSRTs();
        //      srta.saveDiagBox();
        //      srta.saveRepBox();
        //      srta.getsVfComp();
        //srta.getRepairAccessTime();
        //srta.getrepairTime();
        //       srta.getDiagAccessTime();
        //      srta.getAllACS();
        //      srta.changeDownOrder();
        //      srta.setsVfComp(JO1.id);
        //      srta.getallData();
        //      srta.searchSRTCodeAndDescription();
        //     srta.showPopup();
        //      srta.closePopup();
        //      srta.showPopup1();
        //       srta.closePopup1();
        //       srta.getdiagnosisTime();
        //srta.getrepairTime();
        //       srta.changeUpOrder();
        //       srta.saveDiagData();
        //       srta.saveRepairData();
        srta.diagTotal= true;
        srta.repAccTime= 'test';
        
        
        test.stopTest();
        //CSS_WS_SRT wssrt = new CSS_WS_SRT();
        Test.setMock(HttpCalloutMock.class, new CSS_getAllRepDiagSRTs_Test());
        CSS_WS_SRT.getAllDigRepSRTs(JO1.ID,'Diagnostic');  
        CSS_WS_SRT.getAllDigRepSRTs(JO1.ID,'Repair');  
    }
    
    public static testMethod void testAddSRT_Method3_1() { 
        
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02466';
        acc.IAM_Service_Provider_Code__c='19134';
        acc.Type='Dealer Account';
        acc.CMI_Account_Status__c = 'Active';
        insert acc;
        
        CSS_Job_Order__c JO1 = new CSS_Job_Order__c();
        JO1.Account__c=acc.id;
        JO1.Customer_Name__c = 'CumminsTnD';
        JO1.Equipment_ID__c = 'EQ7667';
        JO1.Qsol_Engine_Family_Code__c ='56';
        JO1.AccessCode__c = 'A';
        insert JO1;
        
        css_solutions__c sol = new css_solutions__c();
        sol.Diagnostic_Response__c = 'Most likely the solution';
        sol.Repair_Response__c = 'Most likely';
        sol.Service_Job__c=jo1.id;
        insert sol;
        
        List<CSS_Solution_Component__c> solcompList = new List<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solcomp = new CSS_Solution_Component__c();
        solComp.Component_Id__c ='F0051000';
        solComp.Service_Job__c=jo1.Id;
        solcompList.add(solcomp);
        
        CSS_Solution_Component__c solcomp1 = new CSS_Solution_Component__c();
        solComp1.Component_Id__c ='F0051011';
        solComp1.Service_Job__c=jo1.Id;
        solComp1.Selected_Component__c = true;
        solComp1.Solutions__c = sol.id;
        solcompList.add(solcomp1);
        
        insert solcompList;
        
        List<CSS_SRT__C> lstsrt = new List<CSS_SRT__C>();
        CSS_SRT__C srtRef1 = new CSS_SRT__C();
        srtRef1.Solution_Number__c = sol.Id;
        srtRef1.Job_Order__c = JO1.id;
        srtRef1.SRT_AccessiblityCheck__c=True;
        srtRef1.Access_Code_A__c = 65;
        srtRef1.name = 'TestClassName';
        srtRef1.SRT_ID__c = '00-901-01';
        srtRef1.Type__c = 'Repair Access';
        srtRef1.Assignment__c = 'Primary';
        srtRef1.SRT_Quantity__c = 1;
        //insert srtRef1;
        lstsrt.add(srtRef1);
        
        
        CSS_SRT__C srtRef = new CSS_SRT__C();
        srtRef.Solution_Number__c = sol.Id;
        srtRef.Job_Order__c = JO1.id;
        srtRef.Component_Id__c = solcompList[1].id;
        srtRef.SRT_AccessiblityCheck__c=True;
        srtRef.Access_Code_A__c = 65;
        srtRef.name = 'TestClassName';
        srtRef.SRT_ID__c = '00-901-02';
        srtRef.Type__c = 'Repair';
        srtRef.Assignment__c = 'Primary';
        srtRef.SRT_Quantity__c = 1;
        //insert srtRef1;
        lstsrt.add(srtRef);
        
        insert lstsrt;
        
        test.startTest(); 
        PageReference pg = Page.css_srtEditPopup;
        Test.setCurrentPage(pg);    
        ApexPages.currentPage().getParameters().put('id', JO1.Id);        
        CSS_DARSRT_RO srta = new CSS_DARSRT_RO(); 
        srta.lstDisplayDiagSRT = lstsrt;
        //       srta.searchValue='Testing';
        Test.setMock(HttpCalloutMock.class, new CSS_AccessToken_SRT_Test());
        Test.setMock(HttpCalloutMock.class, new CSS_getAllRepDiagSRTs_Test());
        //       srta.getDiagnosisSRTs();
        srta.gotoJobPlanSrt();
        //       srta.searchDiagSRTCodeAndDescription();
        //       srta.getRepairSRTs();
        //       srta.saveDiagBox();
        //       srta.saveRepBox();
        //       srta.getsVfComp();
        //srta.getRepairAccessTime();
        //srta.getrepairTime();
        //        srta.getDiagAccessTime();
        //        srta.getAllACS();
        //        srta.changeDownOrder();
        //        srta.setsVfComp(JO1.id);
        //        srta.getallData();
        //        srta.searchSRTCodeAndDescription();
        //        srta.showPopup();
        //        srta.closePopup();
        //        srta.showPopup1();
        //        srta.closePopup1();
        //        srta.getdiagnosisTime();
        //srta.getrepairTime();
        //        srta.changeUpOrder();
        //        srta.saveDiagData();
        //        srta.saveRepairData();
        srta.diagTotal= true;
        srta.repAccTime= 'test';
        
        
        test.stopTest();
        //CSS_WS_SRT wssrt = new CSS_WS_SRT();
        Test.setMock(HttpCalloutMock.class, new CSS_getAllRepDiagSRTs_Test());
        CSS_WS_SRT.getAllDigRepSRTs(JO1.ID,'Diagnostic');  
        CSS_WS_SRT.getAllDigRepSRTs(JO1.ID,'Repair');  
    }
    
    public static testMethod void testAddSRT_Method4() { 
        
        
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02466';
        acc.IAM_Service_Provider_Code__c='19134';
        acc.Type='Dealer Account';
        acc.CMI_Account_Status__c = 'Active';
        insert acc;
        
        CSS_Job_Order__c JO1 = new CSS_Job_Order__c();
        JO1.Account__c=acc.id;
        JO1.Customer_Name__c = 'CumminsTnD';
        JO1.Equipment_ID__c = 'EQ7667';
        JO1.Qsol_Engine_Family_Code__c ='56';
        JO1.AccessCode__c = 'A';
        insert JO1;
        
        css_solutions__c sol = new css_solutions__c();
        sol.Service_Job__c=jo1.id;
        insert sol;
        
        CSS_Solution_Component__c solcomp = new CSS_Solution_Component__c();
        solComp.Service_Job__c=jo1.Id;
        insert solcomp;
        
        List<CSS_SRT__C> lstsrt = new List<CSS_SRT__C>();
        CSS_SRT__C srtRef = new CSS_SRT__C();
        srtRef.Job_Order__c = JO1.id;
        srtRef.SRT_AccessiblityCheck__c=True;
        srtRef.Access_Code_A__c = 65;
        srtRef.name = 'TestClassName';
        srtRef.SRT_ID__c = '128969';
        srtRef.srt_category__c = 'AdditionalDiag';
        srtRef.type__c = 'Access';
        srtRef.SRT_Quantity__c = 1;
        srtRef.SRT_Time__c = 1;
        insert srtRef;
        lstsrt.add(srtRef); 
        
        PageReference pref = new PageReference('/'+JO1.id);
        pref.getParameters().put('id',JO1.id);
        Test.setCurrentPage(pref);
        
        test.startTest();    
        PageReference pg = Page.CSS_JobTnDRj;
        
        Test.setCurrentPage(pg);    
        ApexPages.currentPage().getParameters().put('id', JO1.Id);
        CSS_DARSRT_RO srta = new CSS_DARSRT_RO(); 
        srta.lstDisplayDiagSRT = lstsrt;
        //       srta.searchValue='128969';
        //       srta.searchDiagValue='128969';
        Test.setMock(HttpCalloutMock.class, new CSS_AccessToken_SRT_Test());
        Test.setMock(HttpCalloutMock.class, new CSS_getAllRepDiagSRTs_Test());
        //       srta.getDiagnosisSRTs();
        srta.gotoJobPlanSrt();
        //       srta.searchDiagSRTCodeAndDescription();
        //      srta.getRepairSRTs();
        //       srta.saveDiagBox();
        //        srta.saveRepBox();
        //        srta.getsVfComp();
        //srta.getRepairAccessTime();
        //srta.getrepairTime();
        //        srta.getDiagAccessTime();
        //        srta.getAllACS();
        //        srta.changeDownOrder();
        //        srta.setsVfComp(JO1.id);
        //        srta.getallData();
        //        srta.searchSRTCodeAndDescription();
        //        srta.showPopup();
        //        srta.closePopup();
        //        srta.showPopup1();
        //        srta.closePopup1();
        //        srta.getdiagnosisTime();
        //srta.getrepairTime();
        //        srta.changeUpOrder();
        //        srta.saveDiagData();
        //        srta.saveRepairData();
        srta.diagTotal= true;
        srta.repAccTime= 'test';
        
        
        test.stopTest();
        
    }
    
}