@isTest
public class CG_CL_ClaimsSRTCampaignsController_NTest {
    
    //In this test method, we have used Campaign SRTs
    public static testmethod void CG_CL_ClaimsSRTCampaignsController_New_method1()
    {
        
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02650';
        acc.IAM_Service_Provider_Code__c='97895';
        acc.type='Dealer Account';
        insert acc;
        
        CSS_Job_Order__c JO = CSS_TestData.createJobOrder(true);
        
        List<CSS_Claims__c> claimlst = new List<CSS_Claims__c>();
        CSS_Claims__c claim = new CSS_Claims__C();
        claim.AccessCode__c='test';
        claim.Account__c = acc.id;
        claim.CSS_Job__c=jo.id;
        claim.ODM_Penalty__c='20';
        claim.SP_INSHOP_LABOR_RATE__c='99999';
        claim.Information_Only_Claim__c=true;
        insert claim;
        
        css_psn__c psn = new css_psn__c();
        psn.CSS_Claims__c=claim.id;
        psn.Equipment_ID__c='45678';
        insert psn;
        claimlst.add(claim);
        system.debug('claimlst'+claimlst);
        
        CSS_Solutions__c sol = new CSS_Solutions__c();
        sol.Service_Job__c = JO.ID;
        sol.Case_Name__c = 'ABC';
        sol.Solution_Title__c='CDE';
        sol.Name='ABC';
        sol.Diagnostic_Response__c ='Most likely the solution';
        sol.Repair_Response__c = 'Most likely';
        insert sol;
        
        CSS_Solution_Component__c solComp = new CSS_Solution_Component__c();
        solComp.Type__c = 'TRP';
        solComp.Campaign_Description__c='test';
        solComp.Selected_Component__c = true;
        solComp.AccountCodeEdit__c='NPW-New Product Warranty 62';
        solcomp.ODM_Penalty__c='20';
        insert solComp;
        
        List<CSS_Srt__c> additionalSRTList = new List<CSS_Srt__c>();
        CSS_SRT__c srt = new CSS_SRT__c();
        srt.Solution_Number__c = sol.id;
        srt.SRT_Title__c='test';
        srt.SRT_Quantity__c=123;
        srt.Component_Id__c = solcomp.id;
        srt.Assignment__c = 'Primary';
        srt.SRT_ID__c = '123';
        srt.SRT_Time__c=123;
        srt.SRT_Access_Code__c='test';
        srt.srt_type__c = 'Campaign';
        srt.SRT_Category__c = null;
        srt.CSS_Claims__c=claim.id;
        srt.Type__c='Field Action';
        
        CSS_SRT__c srt1 = new CSS_SRT__c();
        srt1.Solution_Number__c = sol.id;
        srt1.SRT_Title__c='test';
        srt1.SRT_Quantity__c=123;
        srt1.Component_Id__c = solcomp.id;
        srt1.Assignment__c = 'Primary';
        srt1.SRT_ID__c = '123';
        srt1.SRT_Time__c=123;
        srt1.SRT_Access_Code__c='test';
        srt1.srt_type__c = 'Field Action';
        srt1.SRT_Category__c = 'Campaign';
        srt1.CSS_Claims__c=claim.id;
        srt1.Type__c='Field Action';
        additionalSRTList.add(srt); 
        additionalSRTList.add(srt1); 
        
        CSS_SRT__c srt2 = new CSS_SRT__c();
        srt2.Solution_Number__c = sol.id;
        srt2.SRT_Title__c='test';
        srt2.SRT_Quantity__c=123;
        srt2.SRT_Time__c=123;
        srt1.SRT_Access_Code__c='test';
        srt2.SRT_Category__c='Campaign';
        srt2.CSS_Claims__c=claim.id;
        srt2.Type__c='Field Action Access ';
        srt2.srt_type__c='Campaign';
        srt2.isPerformed__c = true;
        srt2.Component_Id__c=solcomp.id;
        additionalSRTList.add(srt2);
        
        insert additionalSRTList;
        
        
        CG_CL_ClaimsSRTCampaignsController_New.srtWrapper nw= new CG_CL_ClaimsSRTCampaignsController_New.srtWrapper();
        nw.selectedRecord=true;
        nw.compDescription='';
        nw.srtAccessTime=0.0;
        nw.accTime='';
        nw.accTimeDec=0.0;
        
        ApexPages.currentPage().getParameters().put('id', claim.Id);
        
        test.startTest();
        CG_CL_ClaimsSRTCampaignsController_New claimsSRT = new CG_CL_ClaimsSRTCampaignsController_New();
        List<CG_CL_ClaimsSRTCampaignsController_New.srtWrapper> lstwrapSRT = new List<CG_CL_ClaimsSRTCampaignsController_New.srtWrapper>();
        List<CG_CL_ClaimsSRTCampaignsController_New.sortWrapper> lstwrapSort = new List<CG_CL_ClaimsSRTCampaignsController_New.sortWrapper>();
        CG_CL_ClaimsSRTCampaignsController_New.sortWrapper wrapSort = new CG_CL_ClaimsSRTCampaignsController_New.sortWrapper(nw);
        lstwrapSort.add(wrapSort);
        wrapSort.compareTo(wrapSort);
        
        system.debug('claim'+claim.Id);
        claimsSRT.getsVfComp();
        claimsSRT.setsVfComp(JO.id);
        claimsSRT.saveCampTRPATCData();
        claimsSRT.getalltrpSRTs();
        claimsSRT.callClaimsAccessStepDetailsCamp();
        claimsSRT.ClaimsCampNotesPopupOk();
        claimsSRT.callClaimsAccessStepDetailsTRP();
        claimsSRT.ClaimsTRPNotesPopupOk();
        claimsSRT.callClaimsAccessStepDetailsATC();
        claimsSRT.ClaimsATCNotesPopupOk();
        claimsSRT.PenaltyExists= true;
        claimsSRT.selCoveredVal = 'Data';
        claimsSRT.lineItemStepIdClaimsCamp = 'lineItemStepIdClaimsCamp';
        claimsSRT.StepDescriptionClaims = 'StepDescriptionClaims';
        claimsSRT.lineItemStepIdClaimsTRP = 'lineItemStepIdClaimsTRP';
        claimsSRT.StepDescriptionTRP = 'StepDescriptionTRP';
        claimsSRT.lineItemStepIdClaimsATC = 'lineItemStepIdClaimsATC';
        claimsSRT.StepDescriptionATC = 'StepDescriptionATC';
        test.stopTest();
        
    }
    
    //In this test method, we have used ATC SRTs
    public static testmethod void CG_CL_ClaimsSRTCampaignsController_New_method2()
    {
        
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02650';
        acc.IAM_Service_Provider_Code__c='97895';
        acc.type='Dealer Account';
        insert acc;
        
        CSS_Job_Order__c JO = CSS_TestData.createJobOrder(true);
        
        CSS_Claims__c claim1 = new CSS_Claims__c();
        claim1.Customer_Name__c='Wenchin Techno Village';
        claim1.Customer_Code__c='123';
        claim1.Status__c='Draft';
        claim1.Actual_Technician_Time__c=1.2;
        claim1.Catastrophic__c = true;
        insert claim1; 
        
        CSS_Claims__c claim = new CSS_Claims__C();
        claim.AccessCode__c='test';
        claim.CSS_Job__c=jo.id;
        claim.Account__c = acc.id;
        claim.ODM_Penalty__c='20';
        insert claim;
        
        CSS_Solutions__c sol = new CSS_Solutions__c();
        sol.Service_Job__c = JO.ID;
        sol.Case_Name__c = 'ABC';
        sol.Solution_Title__c='CDE';
        sol.Name='ABC';
        sol.Diagnostic_Response__c ='Most likely the solution';
        sol.Repair_Response__c = 'Most likely';
        insert sol;
        
        CSS_Solution_Component__c solComp = new CSS_Solution_Component__c();
        solComp.Type__c = 'TRP';
        solComp.AccountCodeEdit__c='NPW-New Product Warranty 62';
        solComp.Campaign_Description__c='test';
        solcomp.ODM_Penalty__c='20';
        insert solComp;
        
        CSS_Solution_Component__c solComp1 = new CSS_Solution_Component__c();
        solComp1.Type__c = 'Campaign';
        solComp1.AccountCodeEdit__c='NPW-New Product Warranty 62';
        solComp1.css_claims__c = claim1.id;
        solComp1.Campaign_Description__c='test';
        solcomp1.ODM_Penalty__c='20';
        insert solComp1;
        
        
        List<CSS_Srt__c> additionalSRTList = new List<CSS_Srt__c>();
        CSS_SRT__c srt = new CSS_SRT__c();
        srt.Solution_Number__c = sol.id;
        srt.SRT_Title__c='test';
        srt.SRT_Quantity__c=123;
        srt.SRT_Time__c=123;
        srt.SRT_Access_Code__c='test';
        srt.SRT_Category__c= null;
        srt.CSS_Claims__c=claim.id;
        srt.Type__c='Field Action';
        srt.SRT_Category__c='';
        srt.srt_type__c='ATC';
        additionalSRTList.add(srt);
 
        
        CSS_SRT__c srt1 = new CSS_SRT__c();
        srt1.Solution_Number__c = sol.id;
        srt1.SRT_Title__c='test';
        srt1.SRT_Quantity__c=123;
        srt1.SRT_Time__c=123;
        srt1.SRT_Access_Code__c='test';
        srt1.SRT_Category__c='ATC';
        srt1.CSS_Claims__c=claim.id;
        srt1.Type__c='Field Action Access';
        srt1.srt_type__c='Campaign';
        srt1.Component_Id__c=solcomp1.id;
        additionalSRTList.add(srt1);
        
        CSS_SRT__c srt2 = new CSS_SRT__c();
        srt2.Solution_Number__c = sol.id;
        srt2.SRT_Title__c='test';
        srt2.SRT_Quantity__c=123;
        srt2.SRT_Time__c=123;
        srt1.SRT_Access_Code__c='test';
        srt2.SRT_Category__c='ATC';
        srt2.CSS_Claims__c=claim.id;
        srt2.Type__c='Field Action';
        srt2.srt_type__c='Campaign';
        srt2.isPerformed__c = true;
        srt2.Component_Id__c=solcomp1.id;
        additionalSRTList.add(srt2);
        
        insert additionalSRTList;
        
        ApexPages.currentPage().getParameters().put('id', claim.Id);
        
        test.startTest();
        CG_CL_ClaimsSRTCampaignsController_New.srtWrapper nw= new CG_CL_ClaimsSRTCampaignsController_New.srtWrapper();
        nw.selectedRecord=true;
        nw.compDescription='';
        nw.srtAccessTime=0.0;
        nw.accTime='';
        nw.accTimeDec=0.0;
        nw.sortOrder = 1;
       
        List<CG_CL_ClaimsSRTCampaignsController_New.srtWrapper> lstwrapSRT = new List<CG_CL_ClaimsSRTCampaignsController_New.srtWrapper>();
        List<CG_CL_ClaimsSRTCampaignsController_New.sortWrapper> lstwrapSort = new List<CG_CL_ClaimsSRTCampaignsController_New.sortWrapper>();
        CG_CL_ClaimsSRTCampaignsController_New.sortWrapper wrapSort = new CG_CL_ClaimsSRTCampaignsController_New.sortWrapper(nw);
        lstwrapSort.add(wrapSort);
        wrapSort.compareTo(wrapSort);
        system.debug('claim'+claim.Id);
        
        CG_CL_ClaimsSRTCampaignsController_New claimsSRT = new CG_CL_ClaimsSRTCampaignsController_New();
        ClaimsSRT.SRTList = additionalSRTList;
        claimsSRT.getsVfComp();
        claimsSRT.setsVfComp(JO.id);
        claimsSRT.saveCampTRPATCData();
        claimsSRT.getallatcSRTs();
        test.stopTest();
        
    }
    
    //In this test method, we have used TRP SRTs
    public static testmethod void CG_CL_ClaimsSRTCampaignsController_New_method3()
    {
        
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02650';
        acc.IAM_Service_Provider_Code__c='97895';
        acc.type='Dealer Account';
        insert acc;
        
        CSS_Job_Order__c JO = CSS_TestData.createJobOrder(true);
        
        CSS_Claims__c claim = new CSS_Claims__C();
        claim.AccessCode__c='test';
        claim.ODM_Penalty__c='20';
        claim.CSS_Job__c=jo.id;
        claim.Account__c = acc.id;
        insert claim;
        
        CSS_Solutions__c sol = new CSS_Solutions__c();
        sol.Service_Job__c = JO.ID;
        sol.Case_Name__c = 'ABC';
        sol.Solution_Title__c='CDE';
        sol.Name='ABC';
        sol.Diagnostic_Response__c ='Most likely the solution';
        sol.Repair_Response__c = 'Most likely';
        insert sol;
        
        CSS_Solution_Component__c solComp = new CSS_Solution_Component__c();
        solComp.Type__c = 'TRP';
        solComp.Campaign_Description__c='test';
        solComp.AccountCodeEdit__c='NPW-New Product Warranty 62';
        solcomp.ODM_Penalty__c='20';
        insert solComp;
        
        List<CSS_Srt__c> additionalSRTList = new List<CSS_Srt__c>();
        CSS_SRT__c srt = new CSS_SRT__c();
        srt.Solution_Number__c = sol.id;
        srt.SRT_Title__c='test';
        srt.isPerformed__c =  true;
        srt.SRT_Quantity__c=123;
        srt.SRT_Time__c=123;
        srt.SRT_Access_Code__c='test';
        srt.CSS_Claims__c=claim.id;
        srt.Type__c='Field Action';
        srt.SRT_Category__c = null;
        srt.srt_type__c='TRP';
        additionalSRTList.add(srt);
        
        CSS_SRT__c srt1 = new CSS_SRT__c();
        srt1.Solution_Number__c = sol.id;
        srt1.SRT_Title__c='test';
        srt1.isPerformed__c =  true;
        srt1.SRT_Quantity__c=123;
        srt1.SRT_Time__c=123;
        srt1.SRT_Access_Code__c='test';
        srt1.CSS_Claims__c=claim.id;
        srt1.Type__c='Field Action';
        srt1.SRT_Category__c = 'TRP';
        srt1.srt_type__c='TRP';
        additionalSRTList.add(srt1);
        
        CSS_SRT__c srt2 = new CSS_SRT__c();
        srt2.Solution_Number__c = sol.id;
        srt2.SRT_Title__c='test';
        srt2.SRT_Quantity__c=123;
        srt2.SRT_Time__c=123;
        srt1.SRT_Access_Code__c='test';
        srt2.SRT_Category__c='TRP';
        srt2.CSS_Claims__c=claim.id;
        srt2.Type__c='Field Action Access';
        srt2.srt_type__c='Campaign';
        srt2.isPerformed__c = true;
        srt2.Component_Id__c=solcomp.id;
        additionalSRTList.add(srt2);
        
        insert additionalSRTList;  
        
        ApexPages.currentPage().getParameters().put('id', claim.Id);
        
        test.startTest();
        CG_CL_ClaimsSRTCampaignsController_New.srtWrapper nw= new CG_CL_ClaimsSRTCampaignsController_New.srtWrapper();
        nw.selectedRecord=true;
        CG_CL_ClaimsSRTCampaignsController_New claimsSRT = new CG_CL_ClaimsSRTCampaignsController_New();
        ClaimsSRT.SRTList = additionalSRTList;
        List<CG_CL_ClaimsSRTCampaignsController_New.srtWrapper> lstwrapSRT = new List<CG_CL_ClaimsSRTCampaignsController_New.srtWrapper>();
        List<CG_CL_ClaimsSRTCampaignsController_New.sortWrapper> lstwrapSort = new List<CG_CL_ClaimsSRTCampaignsController_New.sortWrapper>();
        system.debug('claim'+claim.Id);
        claimsSRT.getsVfComp();
        claimsSRT.setsVfComp(JO.id);
        claimsSRT.saveCampTRPATCData();
        claimsSRT.getalltrpSRTs();
        test.stopTest();
        
    }  
    
    public static testmethod void SRTPercReqFAMethod()
    {
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02466';
        acc.IAM_Service_Provider_Code__c='19134';
        acc.Type='Dealer Account';
        acc.CMI_Account_Status__c = 'Active';
        insert acc;
        
        List<CSS_Claims__c> claimlst = new List<CSS_Claims__c>();
        CSS_Claims__c claim = new CSS_Claims__C();
        claim.AccessCode__c='test';
        claim.Account__c = acc.id;
        claim.ODM_Penalty__c='20';
        claim.SP_INSHOP_LABOR_RATE__c='99999';
        claimlst.add(claim);
        insert claimlst;
        
        
        CSS_Solution_Component__c solComp = new CSS_Solution_Component__c();
        solComp.Component_Id__c ='F0051000';
        solComp.CoveredLaborHrs__c = '12';
        solComp.Selected_Component__c = true;
        solComp.System_Code__c = 'TH';
        solComp.Component_Code__c = 'AC';
        solComp.AccountCodeType__c  = 'Emissions Warranty';
        solComp.AccountCode__c = '70';
        solComp.AccountCodeEdit__c = 'Emissions Warranty70';
        insert solComp;
        
        CSS_SRT__C srtRep = new CSS_SRT__C();
        srtRep.Component_Id__c = solComp.id;
        srtRep.SRT_Time__c = 465;
        srtRep.name = 'Test';
        srtRep.Type__c = 'Repair';
        srtRep.SRT_Order__c = 1;
        srtRep.Account_Code__c = 'Emissions Warranty 70';
        
        
        CSS_SRT__C srtRep1 = new CSS_SRT__C();
        srtRep1.Component_Id__c = solComp.id;
        srtRep1.SRT_Time__c = 465;
        srtRep1.name = 'Test';
        srtRep1.Type__c = 'Repair';
        srtRep1.SRT_Order__c = 1;
        srtRep1.Account_Code__c = 'Emissions Warranty 70';
        
        
        List<CSS_SRT__C> srtlst = new List<CSS_SRT__C>();
        srtlst.add(srtRep);
        srtlst.add(srtRep1);
        insert srtlst;
        
        Test.startTest();
        
        CG_CL_ClaimsSRTCampaignsController_New claimsSRT = new CG_CL_ClaimsSRTCampaignsController_New();
        ClaimsSRT.claimsRecList = claimlst;
        
        CG_CL_ClaimsSRTCampaignsController_New.srtWrapper nw= new CG_CL_ClaimsSRTCampaignsController_New.srtWrapper();
        nw.selectedRecord=true;
        nw.compDescription='';
        nw.srtAccessTime=0.0;
        nw.accTime='';
        nw.accTimeDec=0.0;
        
        List<CG_CL_ClaimsSRTCampaignsController_New.srtWrapper> lstwrapSRT = new List<CG_CL_ClaimsSRTCampaignsController_New.srtWrapper>();
        List<CG_CL_ClaimsSRTCampaignsController_New.sortWrapper> lstwrapSort = new List<CG_CL_ClaimsSRTCampaignsController_New.sortWrapper>();
        CG_CL_ClaimsSRTCampaignsController_New.sortWrapper wrapSort = new CG_CL_ClaimsSRTCampaignsController_New.sortWrapper(nw);
        lstwrapSort.add(wrapSort);
        claimsSRT.campListWrap = lstwrapSort;
        claimsSRT.atcListWrap = lstwrapSort;
        claimsSRT.trpListWrap = lstwrapSort;
        claimsSRT.SRTPercReqFA();
        Test.stopTest();
    }
    
    public static testmethod void CampaignMethod()
    {
        test.startTest();
        
        
        CSS_SRT__C srtRep1 = new CSS_SRT__C();
        insert srtRep1;
        
        CG_CL_ClaimsSRTCampaignsController_New.srtWrapper nw= new CG_CL_ClaimsSRTCampaignsController_New.srtWrapper();
        nw.selectedRecord = true;
        nw.srtCheckBox = true;
        nw.compDescription='';
        nw.srtAccessTime=0.0;
        nw.accTime='';
        nw.accTimeDec=0.0;
        nw.ClaimedHrs = 1.0;
        nw.Sid = srtRep1.id;
        
        List<CG_CL_ClaimsSRTCampaignsController_New.sortWrapper> lstwrapSort = new List<CG_CL_ClaimsSRTCampaignsController_New.sortWrapper>();
        CG_CL_ClaimsSRTCampaignsController_New.sortWrapper wrapSort = new CG_CL_ClaimsSRTCampaignsController_New.sortWrapper(nw);
        lstwrapSort.add(wrapSort);
        
        CG_CL_ClaimsSRTCampaignsController_New claimsSRT = new CG_CL_ClaimsSRTCampaignsController_New();
        claimsSRt.campListWrap = lstwrapSort;
        claimsSRT.changeUpOrder();
        claimsSRT.changeDownOrder();
        claimsSRT.getdiagnosisTime();
        claimsSRT.saveCampTRPATCData();
        Test.stopTest();
        
    }
    
    public static testmethod void ATCMethod()
    {
        test.startTest();
        
        CSS_SRT__C srtRep1 = new CSS_SRT__C();
        insert srtRep1;
        
        CG_CL_ClaimsSRTCampaignsController_New.srtWrapper nw= new CG_CL_ClaimsSRTCampaignsController_New.srtWrapper();
        nw.selectedRecord = true;
        nw.srtCheckBox = true;
        nw.compDescription='';
        nw.srtAccessTime=0.0;
        nw.accTime='';
        nw.accTimeDec=0.0;
        nw.ClaimedHrs = 1.0;
        nw.Sid = srtRep1.id;
        
        
        List<CG_CL_ClaimsSRTCampaignsController_New.sortWrapper> lstwrapSort = new List<CG_CL_ClaimsSRTCampaignsController_New.sortWrapper>();
        CG_CL_ClaimsSRTCampaignsController_New.sortWrapper wrapSort = new CG_CL_ClaimsSRTCampaignsController_New.sortWrapper(nw);
        lstwrapSort.add(wrapSort);
        
        CG_CL_ClaimsSRTCampaignsController_New claimsSRT = new CG_CL_ClaimsSRTCampaignsController_New();
        claimsSRt.atcListWrap = lstwrapSort;
        claimsSRT.changeUpOrderATC();
        claimsSRT.changeDownOrderATC();
        claimsSRT.getdiagnosisTimeATC();
        claimsSRT.saveCampTRPATCData();
        Test.stopTest();
        
    }
    
    public static testmethod void TRPMethod()
    {
        test.startTest();
        
        CSS_SRT__C srtRep1 = new CSS_SRT__C();
        insert srtRep1;
        
        CG_CL_ClaimsSRTCampaignsController_New.srtWrapper nw= new CG_CL_ClaimsSRTCampaignsController_New.srtWrapper();
        nw.selectedRecord = true;
        nw.srtCheckBox = true;
        nw.compDescription='';
        nw.srtAccessTime=0.0;
        nw.accTime='';
        nw.accTimeDec=0.0;
        nw.ClaimedHrs = 1.0;
        nw.Sid = srtRep1.id;
        
        
        List<CG_CL_ClaimsSRTCampaignsController_New.sortWrapper> lstwrapSort = new List<CG_CL_ClaimsSRTCampaignsController_New.sortWrapper>();
        CG_CL_ClaimsSRTCampaignsController_New.sortWrapper wrapSort = new CG_CL_ClaimsSRTCampaignsController_New.sortWrapper(nw);
        lstwrapSort.add(wrapSort);
        
        CG_CL_ClaimsSRTCampaignsController_New claimsSRT = new CG_CL_ClaimsSRTCampaignsController_New();
        claimsSRt.trpListWrap = lstwrapSort;
        claimsSRT.changeUpOrderTRP();
        claimsSRT.changeDownOrderTRP();
        claimsSRT.getdiagnosisTimeTRP();
        claimsSRT.saveCampTRPATCData();
        Test.stopTest();
        
    }
    
}