@isTest
public class CG_CL_ClaimsSRTCampaignsController_Test {
    public static testmethod void CG_CL_ClaimsSRTCampaignsController_method(){
       // CSS_Job_Order__c JO = CSS_TestData.createJobOrder(true);
        
         css_job_order__c jo = new css_job_order__c();
        jo.Customer_Name__c='TestUser';
        jo.Customer_Code__c='123';
        jo.ESN__c='53467987';
        insert jo;
        
        CSS_Solution_Component__c solComp = new CSS_Solution_Component__c();
        solComp.Type__c = 'TRP';
        solComp.Campaign_Description__c='test';
        insert solComp;
        
        CSS_Solutions__c sol = new CSS_Solutions__c();
        sol.Service_Job__c = JO.ID;
        sol.Case_Name__c = 'ABC';
        sol.Solution_Title__c='CDE';
        sol.Name='ABC';
        sol.Diagnostic_Response__c ='Most likely the solution';
        sol.Repair_Response__c = 'Most likely';
        insert sol;
        
        List<CSS_Srt__c> additionalSRTList = new List<CSS_Srt__c>();
        CSS_SRT__c srt = new CSS_SRT__c();
        srt.Solution_Number__c = sol.id;
        srt.SRT_Title__c='test';
        srt.SRT_Quantity__c=123;
        srt.SRT_Time__c=123;
        srt.SRT_Access_Code__c='test';
        srt.SRT_Category__c='Campaign';
        insert srt;    
        additionalSRTList.add(srt);
        
        CSS_Claims__c claim = new CSS_Claims__C();
        claim.AccessCode__c='test';
        insert claim;
        
        ApexPages.currentPage().getParameters().put('id', claim.Id);
        test.startTest();
        CG_CL_ClaimsSRTCampaignsController claimsSRT = new CG_CL_ClaimsSRTCampaignsController();
        List<CG_CL_ClaimsSRTCampaignsController.ATCsrtWrapper> lstwrapATC = new List<CG_CL_ClaimsSRTCampaignsController.ATCsrtWrapper>();
        List<CG_CL_ClaimsSRTCampaignsController.TRPsrtWrapper> lstwrapTRP = new List<CG_CL_ClaimsSRTCampaignsController.TRPsrtWrapper>();
        List<CG_CL_ClaimsSRTCampaignsController.srtWrapper> lstwrapSRT = new List<CG_CL_ClaimsSRTCampaignsController.srtWrapper>();
        List<CG_CL_ClaimsSRTCampaignsController.sortWrapper> lstwrapSort = new List<CG_CL_ClaimsSRTCampaignsController.sortWrapper>();
        CG_CL_ClaimsSRTCampaignsController.ATCsrtWrapper wrapATC = new CG_CL_ClaimsSRTCampaignsController.ATCsrtWrapper(srt.Id,'SRTCode','SRTDesc',123,'SRT Time',123,'accesscode','SRTHours','Adjreason',true,1,'100%','campaign','fc-code','acc-code',122);
        lstwrapATC.add(wrapATC);
        CG_CL_ClaimsSRTCampaignsController.TRPsrtWrapper wrapTRP = new CG_CL_ClaimsSRTCampaignsController.TRPsrtWrapper(srt.Id,'SRTCode','SRTDesc',123,'SRT Time',123,'accesscode','SRTHours','Adjreason',true,1,'100%','campaign','fc-code','acc-code',122);
        lstwrapTRP.add(wrapTRP);
        CG_CL_ClaimsSRTCampaignsController.srtWrapper wrapSRT = new CG_CL_ClaimsSRTCampaignsController.srtWrapper(srt.Id,'SRTCode','SRTDesc',123,'SRT Time',123,'accesscode','SRTHours','Adjreason',true,1,'100%','campaign','fc-code','acc-code',122);
        lstwrapSRT.add(wrapSRT);
        CG_CL_ClaimsSRTCampaignsController.sortWrapper wrapSort = new CG_CL_ClaimsSRTCampaignsController.sortWrapper(srt);
        lstwrapSort.add(wrapSort);
        wrapSort.compareTo(wrapSort);
        
        system.debug('claim'+claim.Id);
        claimsSRT.getAllCampSrtsData();
        claimsSRT.getAllATCSrtsData();
       // claimsSRT.getAllTRPSrtsData();
        claimsSRT.getsVfComp();
        claimsSRT.setsVfComp(JO.id);
       // claimsSRT.changeDownOrder();;
        //claimsSRT.changeUpOrder();
        //claimsSRT.changeDownOrder();
        claimsSRT.saveCampTRPATCData();
        claimsSRT.resetUpdatedCampTRPATCData();
        test.stopTest();
        
    }
    static testmethod void testmethod2()
    {
        CSS_Job_Order__c JO = CSS_TestData.createJobOrder(true);
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02650';
        acc.IAM_Service_Provider_Code__c='97895';
        acc.type='Dealer Account';
        insert acc;
   
        CSS_Solutions__c sol = new CSS_Solutions__c();
        sol.Service_Job__c = JO.ID;
        sol.Case_Name__c = 'ABC';
        sol.Solution_Title__c='CDE';
        sol.Name='ABC';
        sol.Diagnostic_Response__c ='Most likely the solution';
        sol.Repair_Response__c = 'Most likely';
        insert sol;
       
        CSS_Claims__c claim = new CSS_Claims__C();
        claim.AccessCode__c='test';
        claim.CSS_Job__c=jo.id;
        claim.Account__c = acc.id;
        insert claim;
             
        CSS_Solution_Component__c solComp = new CSS_Solution_Component__c();
        solComp.Type__c = 'Campaign';
        solComp.Campaign_Description__c='test';
        solcomp.Performed_Review__c=true;
        solcomp.Status__c='approved';
        solcomp.Complete_Indicator__c=false;
        solcomp.Multiple_Times__c=true;
        solcomp.CSS_Claims__c=claim.id;
        solcomp.Solutions__c=Sol.Id;
        insert solComp;
          
        List<CSS_Srt__c> additionalSRTList = new List<CSS_Srt__c>();
        
        CSS_SRT__c srt = new CSS_SRT__c();
        srt.Solution_Number__c = sol.id;
        srt.SRT_Title__c='test';
        srt.SRT_Quantity__c=123;
        srt.SRT_Time__c=123;
        srt.SRT_Access_Code__c='test';
        srt.SRT_Category__c='Campaign';
        srt.CSS_Claims__c=claim.id;
        srt.Type__c='Field Action';
        srt.Component_Id__c=solcomp.Id;
        srt.srt_type__c='Campaign';
        srt.FailCode__c='';
        srt.Access_Code__c='';
        srt.Extended_Hours__c=4;
        srt.SRT_Select__c=true;
        insert srt;    
         
        additionalSRTList.add(srt);
        
        ApexPages.currentPage().getParameters().put('id', claim.Id);
        test.startTest();
        CG_CL_ClaimsSRTCampaignsController nw = new CG_CL_ClaimsSRTCampaignsController();
        test.stopTest();
    }
    static testmethod void testmethod21()
    {
        CSS_Job_Order__c JO = CSS_TestData.createJobOrder(true);
       
   
        CSS_Solutions__c sol = new CSS_Solutions__c();
        sol.Service_Job__c = JO.ID;
        sol.Case_Name__c = 'ABC';
        sol.Solution_Title__c='CDE';
        sol.Name='ABC';
        sol.Diagnostic_Response__c ='Most likely the solution';
        sol.Repair_Response__c = 'Most likely';
        insert sol;
       
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02650';
        acc.IAM_Service_Provider_Code__c='97895';
        acc.type='Dealer Account';
        insert acc;
       CSS_Claims__c claim = new CSS_Claims__C();
        claim.AccessCode__c='test';
        claim.CSS_Job__c=jo.id;
        claim.Account__c = acc.id;
        insert claim;
        
  CSS_Solution_Component__c solComp = new CSS_Solution_Component__c();
        solComp.Type__c = 'Campaign';
        solComp.Campaign_Description__c='test';
        solcomp.Performed_Review__c=true;
        solcomp.Status__c='approved';
        solcomp.Complete_Indicator__c=false;
        solcomp.Multiple_Times__c=true;
        solcomp.CSS_Claims__c=claim.id;
        solcomp.Solutions__c=Sol.Id;
        insert solComp;
         List<CSS_Srt__c> additionalSRTList = new List<CSS_Srt__c>();
         CSS_SRT__c srt = new CSS_SRT__c();
        srt.Solution_Number__c = sol.id;
        srt.SRT_Title__c='test';
        srt.SRT_Quantity__c=123;
        srt.SRT_Time__c=123;
        srt.SRT_Access_Code__c='test';
        srt.SRT_Category__c='Campaign';
        srt.CSS_Claims__c=claim.id;
        srt.Type__c='Field Action';
        srt.Component_Id__c=solcomp.Id;
        srt.srt_type__c='Campaign';
        srt.FailCode__c='';
        srt.Access_Code__c='';
        srt.Extended_Hours__c=4;
        srt.SRT_Select__c=true;
        insert srt;    
         additionalSRTList.add(srt);
        ApexPages.currentPage().getParameters().put('id', claim.Id);
        test.startTest();
        CG_CL_ClaimsSRTCampaignsController nw = new CG_CL_ClaimsSRTCampaignsController();
        test.stopTest();
    }
    static testmethod void testmethod3()
    {
        CSS_Job_Order__c JO = CSS_TestData.createJobOrder(true);
      
       Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02650';
        acc.IAM_Service_Provider_Code__c='97895';
        acc.type='Dealer Account';
        insert acc;
   
        CSS_Solutions__c sol = new CSS_Solutions__c();
        sol.Service_Job__c = JO.ID;
        sol.Case_Name__c = 'ABC';
        sol.Solution_Title__c='CDE';
        sol.Name='ABC';
        sol.Diagnostic_Response__c ='Most likely the solution';
        sol.Repair_Response__c = 'Most likely';
        insert sol;
        List<CSS_Srt__c> additionalSRTList = new List<CSS_Srt__c>();
       
       
        CSS_Claims__c claim = new CSS_Claims__C();
        claim.AccessCode__c='test';
        claim.CSS_Job__c=jo.id;
        claim.Account__c=acc.Id;
        insert claim;
             CSS_Solution_Component__c solComp = new CSS_Solution_Component__c();
        solComp.Type__c = 'TRP';
        solComp.Campaign_Description__c='test';
        solcomp.Performed_Review__c=true;
        solcomp.Status__c='approved';
        solcomp.Complete_Indicator__c=false;
        solcomp.Multiple_Times__c=true;
        solcomp.CSS_Claims__c=claim.id;
        solcomp.Solutions__c=Sol.Id;
        insert solComp;
         CSS_SRT__c srt = new CSS_SRT__c();
        srt.Solution_Number__c = sol.id;
        srt.SRT_Title__c='test';
        srt.SRT_Quantity__c=123;
        srt.SRT_Time__c=123;
        srt.SRT_Access_Code__c='test';
        srt.SRT_Category__c='TRP';
        srt.CSS_Claims__c=claim.id;
        srt.Type__c='Field Action';
        srt.Component_Id__c=solcomp.Id;
        srt.srt_type__c='TRP';
        srt.FailCode__c='';
        srt.Account_Code__c='er';
        srt.Access_Code__c='bt';
        srt.Extended_Hours__c=4;
        srt.SRT_Select__c=true;
        insert srt;    
         additionalSRTList.add(srt);
        ApexPages.currentPage().getParameters().put('id', claim.Id);
        test.startTest();
        CG_CL_ClaimsSRTCampaignsController nw = new CG_CL_ClaimsSRTCampaignsController();
        nw.changeDownOrdertrp();
      //  nw.changeUpOrder();
        nw.changeDownOrder();
       // nw.changeUpOrder();
        nw.getAllTRPSrtsData();
   // nw.changeUpOrder();
        nw.saveCampTRPATCData();
        test.stopTest();
    }
     static testmethod void testmethod4()
    {
        CSS_Job_Order__c JO = CSS_TestData.createJobOrder(true);
       
   
        CSS_Solutions__c sol = new CSS_Solutions__c();
        sol.Service_Job__c = JO.ID;
        sol.Case_Name__c = 'ABC';
        sol.Solution_Title__c='CDE';
        sol.Name='ABC';
        sol.Diagnostic_Response__c ='Most likely the solution';
        sol.Repair_Response__c = 'Most likely';
        insert sol;
        List<CSS_Srt__c> additionalSRTList = new List<CSS_Srt__c>();
        
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02650';
        acc.IAM_Service_Provider_Code__c='97895';
        acc.type='Dealer Account';
        insert acc;
       
        CSS_Claims__c claim = new CSS_Claims__C();
        claim.AccessCode__c='test';
        claim.CSS_Job__c=jo.id;
        claim.Account__c = acc.id;
        insert claim;
             CSS_Solution_Component__c solComp = new CSS_Solution_Component__c();
        solComp.Type__c = 'ATC';
        solComp.Campaign_Description__c='test';
        solcomp.Performed_Review__c=true;
        solcomp.Status__c='approved';
        solcomp.Complete_Indicator__c=false;
        solcomp.Multiple_Times__c=true;
        solcomp.CSS_Claims__c=claim.id;
        solcomp.Solutions__c=Sol.Id;
        insert solComp;
         CSS_SRT__c srt = new CSS_SRT__c();
        srt.Solution_Number__c = sol.id;
        srt.SRT_Title__c='test';
        srt.SRT_Quantity__c=123;
        srt.SRT_Time__c=123;
        srt.SRT_Access_Code__c='test';
        srt.SRT_Category__c='ATC';
        srt.CSS_Claims__c=claim.id;
        srt.Type__c='Field Action';
        srt.Component_Id__c=solcomp.Id;
        srt.srt_type__c='ATC';
        srt.FailCode__c='';
        srt.Access_Code__c='';
        srt.Extended_Hours__c=4;
        srt.SRT_Select__c=true;
        insert srt;    
         additionalSRTList.add(srt);
        ApexPages.currentPage().getParameters().put('id', claim.Id);
        test.startTest();
        CG_CL_ClaimsSRTCampaignsController nw = new CG_CL_ClaimsSRTCampaignsController();
        test.stopTest();
    }
    static testmethod void testmethod22()
    {
        CSS_Job_Order__c JO = CSS_TestData.createJobOrder(true);
       
   
        CSS_Solutions__c sol = new CSS_Solutions__c();
        sol.Service_Job__c = JO.ID;
        sol.Case_Name__c = 'ABC';
        sol.Solution_Title__c='CDE';
        sol.Name='ABC';
        sol.Diagnostic_Response__c ='Most likely the solution';
        sol.Repair_Response__c = 'Most likely';
        insert sol;
        List<CSS_Srt__c> additionalSRTList = new List<CSS_Srt__c>();
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02650';
        acc.IAM_Service_Provider_Code__c='97895';
        acc.type='Dealer Account';
        insert acc;
       
        CSS_Claims__c claim = new CSS_Claims__C();
        claim.AccessCode__c='test';
        claim.CSS_Job__c=jo.id;
        claim.Account__c = acc.id;
        insert claim;
             CSS_Solution_Component__c solComp = new CSS_Solution_Component__c();
        solComp.Type__c = 'Campaign';
        solComp.Campaign_Description__c='test';
        solcomp.Performed_Review__c=true;
        solcomp.Status__c='approved';
        solcomp.Complete_Indicator__c=false;
        solcomp.Multiple_Times__c=true;
        solcomp.CSS_Claims__c=claim.id;
        solcomp.Solutions__c=Sol.Id;
        insert solComp;
         CSS_SRT__c srt = new CSS_SRT__c();
        srt.Solution_Number__c = sol.id;
        srt.SRT_Title__c='test';
        srt.SRT_Quantity__c=123;
        srt.SRT_Time__c=123;
        srt.SRT_Access_Code__c='test';
        srt.SRT_Category__c='Campaign';
        srt.CSS_Claims__c=claim.id;
        srt.Type__c='Field Action Access';
        srt.Component_Id__c=solcomp.Id;
        srt.srt_type__c='Campaign';
        srt.FailCode__c='';
        srt.Access_Code__c='';
        srt.Extended_Hours__c=4;
        srt.SRT_Select__c=true;
        
        insert srt;    
         additionalSRTList.add(srt);
        ApexPages.currentPage().getParameters().put('id', claim.Id);
        test.startTest();
        CG_CL_ClaimsSRTCampaignsController nw = new CG_CL_ClaimsSRTCampaignsController();
        test.stopTest();
    }
     static testmethod void testmethod33()
    {
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02650';
        acc.IAM_Service_Provider_Code__c='97895';
        acc.type='Dealer Account';
        insert acc;
       
        CSS_Job_Order__c JO = new CSS_Job_Order__c();       
        JO.Account__c = acc.Id;
        JO.Unit_Number__c = '12345';
        JO.Failure_Point__c = 1.5;
        JO.Failure_Point_Measure__c = 'qw';  
        JO.Account__c = acc.id;
        JO.Customer_Name__c = 'CumminsTnD';
        insert JO;
        
        CSS_Solutions__c sol = new CSS_Solutions__c();
        sol.Service_Job__c = JO.ID;
        sol.Case_Name__c = 'ABC';
        sol.Solution_Title__c='CDE';
        sol.Name='ABC';
        sol.Diagnostic_Response__c ='Most likely the solution';
        sol.Repair_Response__c = 'Most likely';
        insert sol;
         
        CSS_Claims__c claim = new CSS_Claims__C();
        claim.AccessCode__c='test';
        claim.CSS_Job__c=JO.id;
        claim.Account__c = acc.id;
        insert claim;
        
        List<CSS_Solution_Component__c> listSolComp = new List<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solComp = new CSS_Solution_Component__c();
        solComp.Type__c = 'TRP';
        solComp.Component_Id__c ='test';
        solComp.Campaign_Description__c='test';
        solComp.Service_Job__c = jo.id;
        solcomp.CSS_Claims__c=claim.id;
        //solcomp.CSS_Account_Formula__c = 'test';
        solcomp.Performed_Review__c=true;
        solcomp.Status__c='Approved';
        solcomp.Complete_Indicator__c=true;
        solcomp.Multiple_Times__c=true;
        solcomp.Solutions__c=Sol.Id;
        
        insert solComp;
        listSolComp.add(solComp);
        
        List<CSS_Srt__c> additionalSRTList = new List<CSS_Srt__c>();
        CSS_SRT__c srt = new CSS_SRT__c();
        srt.Component_Id__c=solcomp.Id;
        srt.SRT_Title__c='test';
        srt.Extended_Hours__c=4;
        srt.SRT_Quantity__c=123;
        srt.SRT_Time__c=123;
        srt.SRT_Access_Code__c='test';
        srt.CSS_Claims__c=claim.id;
        srt.SRT_Warrantable__c = '12';
        srt.Adjustment_Reason__c = 'test';
        srt.Job_Order__c = JO.id;
        srt.SRT_Select__c=true;
        srt.Type__c='Field Action Access';
        srt.Account_Code__c = '123';
        srt.Solution_Number__c = sol.id;
        insert srt;    
        additionalSRTList.add(srt);
        
        ApexPages.currentPage().getParameters().put('id', claim.Id);
        test.startTest();
        CG_CL_ClaimsSRTCampaignsController nw = new CG_CL_ClaimsSRTCampaignsController();
         List<CG_CL_ClaimsSRTCampaignsController.srtWrapper> lstwrapSRT = new List<CG_CL_ClaimsSRTCampaignsController.srtWrapper>();
        list<CG_CL_ClaimsSRTCampaignsController.TRPsrtWrapper> listTRPsrtWrap = new list<CG_CL_ClaimsSRTCampaignsController.TRPsrtWrapper>();
        CG_CL_ClaimsSRTCampaignsController.TRPsrtWrapper TRPsrtWrap = new CG_CL_ClaimsSRTCampaignsController.TRPsrtWrapper( srt.id,'test12', 'SrtDescription', 1.23,'12',1.23,'123','12', 'AdjustmentReason', true, 1,'100','Repair','WEQP','CMP – Field Actions 65', 1.23);
        listTRPsrtWrap.add(TRPsrtWrap);
        CG_CL_ClaimsSRTCampaignsController.srtWrapper wrapSRT = new CG_CL_ClaimsSRTCampaignsController.srtWrapper(srt.Id,'SRTCode','SRTDesc',123,'SRT Time',123,'accesscode','SRTHours','Adjreason',true,1,'100%','campaign','fc-code','acc-code',122);
        lstwrapSRT.add(wrapSRT);
        nw.changeDownOrder();
       // nw.changeUpOrder();
      //  nw.changeUpOrder();
        nw.getAllTRPSrtsData();
        test.stopTest();
    }
     public static testmethod void CG_CL_ClaimsSRTCampaignsController_elseMethod(){
        CSS_Job_Order__c JO = CSS_TestData.createJobOrder(true);
        
        CSS_Solution_Component__c solComp = new CSS_Solution_Component__c();
        solComp.Type__c = 'TRP';
        solComp.Campaign_Description__c='test';
        insert solComp;
        
        CSS_Solutions__c sol = new CSS_Solutions__c();
        sol.Service_Job__c = JO.ID;
        sol.Case_Name__c = 'ABC';
        sol.Solution_Title__c='CDE';
        sol.Name='ABC';
        sol.Diagnostic_Response__c ='Most likely the solution';
        sol.Repair_Response__c = 'Most likely';
        insert sol;
        
        List<CSS_Srt__c> additionalSRTList = new List<CSS_Srt__c>();
        CSS_SRT__c srt = new CSS_SRT__c();
        srt.Solution_Number__c = sol.id;
        srt.SRT_Title__c='test';
        srt.SRT_Quantity__c=123;
        srt.SRT_Time__c=123;
        srt.SRT_Access_Code__c='test';
        srt.SRT_Category__c='Campaign';
        srt.SRT_Order__c = 1.23;
        insert srt;    
        additionalSRTList.add(srt);
        
        CSS_Claims__c claim = new CSS_Claims__C();
        claim.AccessCode__c='test';
        insert claim;
        
        ApexPages.currentPage().getParameters().put('id', claim.Id);
        test.startTest();
        CG_CL_ClaimsSRTCampaignsController claimsSRT = new CG_CL_ClaimsSRTCampaignsController();
        List<CG_CL_ClaimsSRTCampaignsController.ATCsrtWrapper> lstwrapATC = new List<CG_CL_ClaimsSRTCampaignsController.ATCsrtWrapper>();
        List<CG_CL_ClaimsSRTCampaignsController.TRPsrtWrapper> lstwrapTRP = new List<CG_CL_ClaimsSRTCampaignsController.TRPsrtWrapper>();
        List<CG_CL_ClaimsSRTCampaignsController.srtWrapper> lstwrapSRT = new List<CG_CL_ClaimsSRTCampaignsController.srtWrapper>();
        List<CG_CL_ClaimsSRTCampaignsController.sortWrapper> lstwrapSort = new List<CG_CL_ClaimsSRTCampaignsController.sortWrapper>();
        CG_CL_ClaimsSRTCampaignsController.ATCsrtWrapper wrapATC = new CG_CL_ClaimsSRTCampaignsController.ATCsrtWrapper(srt.Id,'SRTCode','SRTDesc',123,'SRT Time',123,'accesscode','SRTHours','Adjreason',true,1,'100%','campaign','fc-code','acc-code',122);
        lstwrapATC.add(wrapATC);
        CG_CL_ClaimsSRTCampaignsController.TRPsrtWrapper wrapTRP = new CG_CL_ClaimsSRTCampaignsController.TRPsrtWrapper(srt.Id,'SRTCode','SRTDesc',123,'SRT Time',123,'accesscode','SRTHours','Adjreason',true,1,'100%','campaign','fc-code','acc-code',122);
        lstwrapTRP.add(wrapTRP);
        CG_CL_ClaimsSRTCampaignsController.srtWrapper wrapSRT = new CG_CL_ClaimsSRTCampaignsController.srtWrapper(srt.Id,'SRTCode','SRTDesc',123,'SRT Time',123,'accesscode','SRTHours','Adjreason',true,1,'100%','campaign','fc-code','acc-code',122);
        lstwrapSRT.add(wrapSRT);
        CG_CL_ClaimsSRTCampaignsController.sortWrapper wrapSort = new CG_CL_ClaimsSRTCampaignsController.sortWrapper(srt);
        lstwrapSort.add(wrapSort);
        wrapSort.compareTo(wrapSort);
        
        system.debug('claim'+claim.Id);
        claimsSRT.getAllCampSrtsData();
        claimsSRT.getAllATCSrtsData();
        claimsSRT.getAllTRPSrtsData();
        claimsSRT.getsVfComp();
        claimsSRT.setsVfComp(JO.id);
       // claimsSRT.changeDownOrder();
      //  claimsSRT.changeUpOrder();
       // claimsSRT.changeDownOrder();
        claimsSRT.saveCampTRPATCData();
        claimsSRT.resetUpdatedCampTRPATCData();
        test.stopTest();
        
    }
   
    
}