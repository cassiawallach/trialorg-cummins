@isTest
public class CSS_JobPlanQuoteController_Test 
{
    static testmethod void testmethod1(){
        Account acc = new Account();
        acc.name='Rtest';
        acc.CSS_DistributorCode__c='56270';
        acc.IAM_Service_Provider_Code__c='56270';
        acc.BMS_Enabled__c = true;
        acc.ERP_System__c ='One BMS';
        acc.Type='Dealer Account';
        acc.Region__c = 'US and Canada';
        acc.CMI_Account_Status__c = 'Active';
        acc.IAM_Service_Provider_Code__c = '562551';
        insert acc;
        
        //Add test data for Service job order
        CSS_Job_Order__c JO = CSS_TestData.createJobOrder(true);
        JO.CSS_Job_Location_Code__c='56270-56270';
        Jo.Customer_Code__c = '23456';
        JO.Unit_Number__c = 'test123';
        Jo.Shop_Work_Order__c='uiafh';
        JO.chevron_page__c ='jpg';
        JO.CSS_Resolution__c='Testing';
        JO.General_Symptoms__c = null;
        JO.Account__c=acc.Id;
        update JO;
        
        CSS_UserLocation__c userLocation = new CSS_UserLocation__c(AccountId__c=acc.id,isActive__c=true,isPrimary__c=true,UserId__c=userinfo.getUserId(),Location_code__c='56270-56270');
        insert userLocation;
        
        CSS_Quote__c quote = new CSS_Quote__c();
        quote.OrderReference__c ='5875876';
        quote.Quote_decline_Reason__c ='faiiled';
        quote.AcceptQuote__c = true ;
        quote.QuoteTotal__c = 1000;
        quote.Service_Job__c = JO.id;
        //quote.ODMMessage='Testing';
        insert quote;
        
        PageReference pref;
        pref = new PageReference('/'+JO.id);
        pref.getParameters().put('id',JO.id);
        Test.setCurrentPage(pref);
        
        test.startTest();
        CSS_JobPlanQuoteController jobPlan= new CSS_JobPlanQuoteController();
        jobPlan.accQuoteFlag = true;
        jobPlan.displaycancelModPopup = false;
        
        
        JobPlan.workJob = [Select Id,Name,AccessCode__c,Customer_Name__c,Shop_Work_Order__c, Application__c, Application_Desc__c, BMS_Last_Name__c, DSID_WorkGroup__c, Unit_Number__c, Date_in__c, INSITE_UpdateTimeStamp__c, First_Name__c,
                           Repair_Location__c,Failure_Date__c, Failure_Point__c, Failure_Point_Measure__c, Service_Model__c,BMSStatus__c,Unit_Type__c, VIN__c, Warranty_Start_Date__c,Make__c, Qsol_Engine_Family_Code__c,
                           DSID__c, DSID_Creation_Timestamp__c, DSID_Status__c, Repeat_Or_Recent_Calc__c, DSID_UpdateTimestamp__c,Customer_Code__c,Status__c,
                           Phone_Number__c, Previous_Status__c,Sub_Type__c, Category__c, Complaint_Type__c, Model__c,Creator_Location__c, Control_Number__c,
                           Assigned_to__r.Name,Additional_Tech1__r.Name,Additional_Tech2__r.Name,OwnerId,JobLocation__c,CSS_Resolution__c,CSS_Feedback_Comments__c, BMSWSStatus__c,
                           ESN__c, Mileage__c, Mileage_Measure__c, chevron_page__c, General_Symptoms__c, Assigned_To__c, LastModifiedDate,CreatedDate,ESN_Locked__c,Region__c,Territory__c,EditComplaint__c
                           from CSS_Job_Order__c where id= :JO.id];
        
        
        CSS_List_Of_Values__c CLV = new CSS_List_Of_Values__c();
        CLV.Name = 'Test'+math.random();
        CLV.Type__c = 'ApplicationCode';
        CLV.Code__c = 'UKEU';
        CLV.Picklist_Values_1__c = 'EUROPE';
        insert(CLV);
        
        CSS_Job_Order__c jobOrder = new CSS_Job_Order__c();
        jobOrder.Status__c = 'Repair';
        insert jobOrder;
        
        CSS_Fault_Code__c fc1 = new CSS_Fault_Code__c(FaultCodeR2__c = '441',Related_Fault_Code__c = '234,546');
        fc1.Name = '441';
        fc1.Job_Order__c = jobOrder.Id;
        fc1.Sequence__c = 1; 
        fc1.Fault_Code_Type__c = 'BPD-P';
        fc1.Mod__c = '0';
        fc1.isPole__c = false;
        insert fc1;
        List<CSS_Fault_Code__c> lstFC = new List<CSS_Fault_Code__c>();
        lstFC.add(fc1);
        
        CSS_Solutions__c cssSol ;
        
        CSS_Solutions__c sol = new CSS_Solutions__c();
        sol.Name = 'CGG_CG_SOlution1';
        sol.Service_Job__c = JO.Id;
        sol.Diagnostic_Response__c = 'Most likely the solution';
        sol.repair_Response__c = 'Successful';
        insert sol;
        
        
        CSS_CampTsbTrp__c x1 = new CSS_CampTsbTrp__c();
        x1.Job_order__c = Jo.Id;
        x1.performed_review__c = true;
        x1.performed__c =false;
        
        string x = jobPlan.comm = 'euiewdh';
        jobPlan.showJobPlanBlocks(false,false,false,true,false,false,false); 
        jobPlan.ChkFieldBlank();
        jobplan.dsidStatus = true;
        jobplan.requiredBMSMessage = true;
        jobplan.pgSaveAssign();
        jobplan.showRepairs = true;
        jobplan.showResolutionWithRepair = true;
        jobplan.showRepairErrorMessage = true;
        jobplan.requiredBMSMessage = true;
        pref = jobPlan.jobplan_prt();
        pref = jobPlan.jobplan_srt();
        pref = jobPlan.jobplan_war();
        pref = jobPlan.jobplan_narr();
        pref = jobPlan.jobplan_jo();
        pref = jobPlan.jobplan_jpq();
        pref = jobPlan.pgSave();
        pref = jobPlan.pgSaveFinish();
        pref = jobPlan.saveCheckBox();
        jobPlan.bmsUserCloseFlag = false;
        pref = jobPlan.closeSession();
        jobPlan.closeSession_Close();
        jobPlan.showPopup();
        jobPlan.jobClosePopup();        
        jobPlan.redirectPopup();  
        jobPlan.closePopup();
        jobPlan.showcancelpopup();
        jobPlan.cancelModPopup();
        jobplan.showRepairs = true;
        jobplan.showResolutionWithRepair = false;
        
        List<CSS_Solutions__c> lstsol = new List<CSS_Solutions__c>();
        CSS_Solutions__c solAdd = new CSS_Solutions__c();
        solAdd.Service_Job__c = JO.ID;
        solAdd.Case_Name__c = 'Additional SRTS';
        solAdd.Solution_Title__c='Additional SRTS';
        solAdd.Name='Additional SRTS';
        solAdd.Diagnostic_Response__c ='Most likely the solution';
        solAdd.Repair_Response__c = 'Most likely ';
        insert solAdd;
        lstsol.add(solAdd);
        jobPlan.postRepairList = lstsol;
        jobPlan.showResolutionWithRepair=true;
        jobPlan.saveAndCloseJob();
        jobplan.getItems();
        jobplan.checkAcceptedDate();
        jobplan.Cancel();
        jobPlan.generateQuote();
        
        Note n = new Note();
        n.Title = 'CAMPCOMMENTS';
        n.ParentId = JO.Id;  
        n.Body = x;
        insert n;
        test.stopTest();
    }
    
    static testmethod void testmethodChkFieldBlank(){
        Account acc = new Account();
        acc.name='Rtest';
        acc.CSS_DistributorCode__c='56270';
        acc.IAM_Service_Provider_Code__c='56270';
        acc.BMS_Enabled__c = true;
        acc.ERP_System__c ='One BMS';
        insert acc;
        
        //Add test data for Service job order
        CSS_Job_Order__c JO = CSS_TestData.createJobOrder(true);
        JO.CSS_Job_Location_Code__c='56270-56270';
        JO.Customer_Name__c = 'testing';
        JO.Shop_Work_Order__c='uiafh';
        JO.Application_Desc__c = 'testing';
        JO.Customer_Code__c = '23456';
        JO.Unit_Number__c = 'test123';
        JO.Mileage__c = 6.12;
        JO.ESN__c = 'testing';
        JO.General_Symptoms__c = 'testing';
        JO.chevron_page__c ='jpg';
        JO.CSS_Resolution__c='Testing';
        JO.Account__c=acc.Id;
        update JO;
        
        CSS_UserLocation__c userLocation = new CSS_UserLocation__c(AccountId__c=acc.id,isActive__c=true,isPrimary__c=true,UserId__c=userinfo.getUserId(),Location_code__c='56270-56270');
        insert userLocation;
        
        CSS_Quote__c quote = new CSS_Quote__c();
        quote.OrderReference__c ='5875876';
        quote.Quote_decline_Reason__c ='faiiled';
        quote.AcceptQuote__c = true ;
        quote.QuoteTotal__c = 1000;
        quote.Service_Job__c = JO.id;
        //quote.ODMMessage='Testing';
        insert quote;
        
        PageReference pref;
        pref = new PageReference('/'+JO.id);
        pref.getParameters().put('id',JO.id);
        Test.setCurrentPage(pref);
        
        test.startTest();
        CSS_JobPlanQuoteController jobPlan= new CSS_JobPlanQuoteController();
        jobPlan.accQuoteFlag = true;
        jobPlan.displaycancelModPopup = false;
        jobPlan.ChkFieldBlank();
        
        
        JobPlan.workJob = [Select Id,Name,AccessCode__c,Customer_Name__c,Shop_Work_Order__c, Application__c, Application_Desc__c, BMS_Last_Name__c, DSID_WorkGroup__c, Unit_Number__c, Date_in__c, INSITE_UpdateTimeStamp__c, First_Name__c,
                           Repair_Location__c,Failure_Date__c, Failure_Point__c, Failure_Point_Measure__c, Service_Model__c,BMSStatus__c,Unit_Type__c, VIN__c, Warranty_Start_Date__c,Make__c, Qsol_Engine_Family_Code__c,
                           DSID__c, DSID_Creation_Timestamp__c, DSID_Status__c, Repeat_Or_Recent_Calc__c, DSID_UpdateTimestamp__c,Customer_Code__c,Status__c,
                           Phone_Number__c, Previous_Status__c,Sub_Type__c, Category__c, Complaint_Type__c, Model__c,Creator_Location__c, Control_Number__c,
                           Assigned_to__r.Name,Additional_Tech1__r.Name,Additional_Tech2__r.Name,OwnerId,JobLocation__c,CSS_Resolution__c,CSS_Feedback_Comments__c, BMSWSStatus__c,
                           ESN__c, Mileage__c, Mileage_Measure__c, chevron_page__c, General_Symptoms__c, Assigned_To__c, LastModifiedDate,CreatedDate,ESN_Locked__c,Region__c,Territory__c,EditComplaint__c
                           from CSS_Job_Order__c where id= :JO.id];
        
        
        CSS_List_Of_Values__c CLV = new CSS_List_Of_Values__c();
        CLV.Name = 'Test'+math.random();
        CLV.Type__c = 'ApplicationCode';
        CLV.Code__c = 'UKEU';
        CLV.Picklist_Values_1__c = 'EUROPE';
        insert(CLV);
        
        
        
        CSS_Fault_Code__c fc1 = new CSS_Fault_Code__c(FaultCodeR2__c = '441',Related_Fault_Code__c = '234,546');
        fc1.Name = '441';
        fc1.Job_Order__c = JO.Id;
        fc1.Sequence__c = 1; 
        fc1.Fault_Code_Type__c = 'BPD-P';
        fc1.Mod__c = '0';
        fc1.isPole__c = false;
        insert fc1;
        List<CSS_Fault_Code__c> lstFC = new List<CSS_Fault_Code__c>();
        lstFC.add(fc1);
        
        CSS_Solutions__c cssSol ;
        
        CSS_Solutions__c sol = new CSS_Solutions__c();
        sol.Name = 'CGG_CG_SOlution1';
        sol.Service_Job__c = JO.Id;
        sol.Diagnostic_Response__c = 'Most likely the solution';
        sol.repair_Response__c = 'Successful';
        insert sol;
        
        
        CSS_CampTsbTrp__c x1 = new CSS_CampTsbTrp__c();
        x1.Job_order__c = Jo.Id;
        x1.performed_review__c = true;
        x1.performed__c =false;
        
        string x = jobPlan.comm = 'euiewdh';
        
        jobplan.dsidStatus = true;
        jobplan.requiredBMSMessage = true;
        jobplan.pgSaveAssign();
        jobplan.showRepairs = true;
        jobplan.showResolutionWithRepair = true;
        jobplan.showRepairErrorMessage = true;
        jobplan.requiredBMSMessage = true;
        pref = jobPlan.jobplan_prt();
        pref = jobPlan.jobplan_srt();
        pref = jobPlan.jobplan_war();
        pref = jobPlan.jobplan_narr();
        pref = jobPlan.jobplan_jo();
        pref = jobPlan.jobplan_jpq();
        pref = jobPlan.pgSave();
        pref = jobPlan.pgSaveFinish();
        pref = jobPlan.saveCheckBox();
        jobPlan.bmsUserCloseFlag = false;
        pref = jobPlan.closeSession();
        
        
        List<CSS_Solutions__c> lstsol = new List<CSS_Solutions__c>();
        CSS_Solutions__c solAdd = new CSS_Solutions__c();
        solAdd.Service_Job__c = JO.ID;
        solAdd.Case_Name__c = 'Additional SRTS';
        solAdd.Solution_Title__c='Additional SRTS';
        solAdd.Name='Additional SRTS';
        solAdd.Diagnostic_Response__c ='Most likely the solution';
        solAdd.Repair_Response__c = 'Most likely ';
        insert solAdd;
        lstsol.add(solAdd);
        jobPlan.postRepairList = lstsol;
        jobPlan.showResolutionWithRepair=true;
        
        Note n = new Note();
        n.Title = 'CAMPCOMMENTS';
        n.ParentId = JO.Id;  
        n.Body = x;
        insert n;
        test.stopTest();
    }
    static testmethod void testmethod2(){
        CSS_Job_Order__c JO1 = CSS_TestData.createJobOrder(true);
        CSS_JobPlanQuoteController jobplan = new CSS_JobPlanQuoteController();
        system.assert(string.isblank(jobplan.ERPErrorMsg));
        system.assert(string.isBlank(jobplan.assignSelectedDeclineQuotevalue));
        system.assert(jobplan.complaintcounter==null);
        system.assert(jobplan.coveragecounter==null);
        system.assert(jobplan.coveragecounter==null);
        system.assert(jobplan.correctioncounter==null);
        system.assert(jobplan.quote==null);
        system.assert(jobplan.EnableDecline==null);
        system.assert(jobplan.datetoday==null);
        system.assert(jobplan.attachObj==null);
        system.assert(jobplan.showErrorERP==null);
        system.assert(jobplan.causecounter==null);
        system.assert(jobplan.accURL==null);
        
        CSS_JobPlanQuoteController.getReasonQuoteDeclne(JO1.id,'creater location');
        
        
    }
    
    static testmethod void testmethod4(){
        CSS_Quote__c qt1 = new CSS_Quote__c(); 
        qt1.OrderReference__c = 'TEst';
        qt1.AcceptQuote__c = true;
        qt1.QuoteTotal__c = 1000;
        qt1.Quote_decline_Reason__c = 'TestString1';
        insert qt1;
        
        Account acc = new Account();
        acc.name='Rtest';
        acc.CSS_DistributorCode__c='56270';
        acc.IAM_Service_Provider_Code__c='56270';
        acc.BMS_Enabled__c = true;
        acc.ERP_System__c ='One BMS';
        insert acc;
        
        CSS_Job_Order__c JO = CSS_TestData.createJobOrder(true);
        JO.CSS_Job_Location_Code__c='56270-56270';
        Jo.Customer_Code__c = '23456';
        JO.Unit_Number__c = 'test123';
        Jo.Shop_Work_Order__c='uiafh';
        JO.chevron_page__c ='jpg';
        JO.CSS_Resolution__c='Testing';
        JO.General_Symptoms__c = null;
        JO.Account__c=acc.Id;
        update JO;
        
        PageReference pref;
        pref = new PageReference('/'+JO.id);
        pref.getParameters().put('id',JO.id);
        Test.setCurrentPage(pref);
        
        test.startTest();
        CSS_JobPlanQuoteController joplan= new CSS_JobPlanQuoteController();
        joplan.quoteObj=qt1;
        css_job_order__c wo = new css_job_order__C();
        joplan.workJob=wo;
        joplan.acceptQuote();
        joplan.declineQuote();
        joplan.Cancel();
        pref = joplan.pgSave();
        test.stopTest();
        
        
    }
    
    static testmethod void fetchAccountFailCodeCombomethod(){
        
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02650';
        acc.IAM_Service_Provider_Code__c='97895';
        acc.type='Dealer Account';
        insert acc;
        
        CSS_Job_Order__c JO1 = css_testdata.createJobOrder(true);
        JO1.Account__c=acc.Id;
        update Jo1;
        
        CSS_Solutions__c sol = new CSS_Solutions__c();
        sol.Service_Job__c = JO1.ID;
        sol.Case_Name__c = 'ABC';
        sol.Solution_Title__c='CDE';
        sol.Name='ABC';
        sol.Diagnostic_Response__c ='Most likely the solution';
        sol.Repair_Response__c = 'Most likely';
        insert sol;
        
        CSS_Claims__c claim = new CSS_Claims__C();
        claim.AccessCode__c='test';
        claim.CSS_Job__c=JO1.id;
        claim.Account__c=acc.Id;
        insert claim;
        
       CSS_Solution_Component__c JO = new CSS_Solution_Component__c();
        JO.Service_Job__c = JO1.id;
        JO.AccountCode__c = 'Testing';
        JO.AccountCodeType__c ='Testing';
        JO.AccountCodeEdit__c='Testing';
        JO.System_Code__c='Testing';
        JO.Component_Code__c='Testing';
        JO.Failure_Mode__c='Testing';
        JO.Selected_Component__c=true;
        JO.CSS_Claims__c=claim.id;
        JO.Solutions__c=Sol.Id;
        insert JO;
        
        
        ApexPages.currentPage().getParameters().put('id',JO1.id);
        Id Wid=ApexPages.CurrentPage().getParameters().get('id');
        
        
        CSS_Parts_Options__c prts = new CSS_Parts_Options__c();
        prts.Service_Job__c = JO1.Id;
        prts.Account_Code__c='Testing';
        prts.Fail_Code__c='Test-ing';
        prts.selected_part__c=true;
        insert prts;
        
        
        list<CSS_SRT__c> srtList = New  list<CSS_SRT__c>();
        CSS_SRT__c srt = new CSS_SRT__c();
        srt.Job_Order__c = JO1.id;
        srt.Account_Code__c='SERVICE TOOL WARRANTY 52'; 
        srt.Solution_Number__c = sol.id;
        srt.SRT_Title__c='test';
        srt.SRT_Quantity__c=123;
        srt.SRT_Time__c=123;
        srt.SRT_Access_Code__c='test';
        srt.SRT_Category__c='Campaign';
        srt.CSS_Claims__c=claim.id;
        srt.Type__c='Diag Access';
        srt.Component_Id__c=JO.Id;
        srt.srt_type__c='Diag Access';
        srt.FailCode__c = 'THAC';
        srt.SRT_AccessiblityCheck__c=TRUE;
        srt.Access_Code__c='';
        srt.Extended_Hours__c=4;
        srt.SRT_Select__c=true;
        srtList.add(srt);
        insert srtList;
        
        
        
        
        test.startTest();
        
        CSS_JobPlanQuoteController obj = new CSS_JobPlanQuoteController();
        obj.claimsSRTList = srtList;
        obj.fetchAccountFailCodeCombo();
        test.stopTest();
        
    }
    
    static testmethod void fetchAccountFailCodeCombomethodFailcodeNull(){
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02650';
        acc.IAM_Service_Provider_Code__c='97895';
        acc.type='Dealer Account';
        insert acc;
        
        CSS_Job_Order__c JO1 = css_testdata.createJobOrder(true);
        Jo1.Account__c = acc.id;
        JO1.BMSStatus__c = 'QTFI0';
        JO1.chevron_page__c = 'jpq';
        update JO1;
        
        CSS_Claims__c claim = new CSS_Claims__C();
        claim.AccessCode__c='test';
        claim.CSS_Job__c=JO1.id;
        claim.Account__c=acc.Id;
        insert claim;
        
        CSS_Solutions__c sol = new CSS_Solutions__c();
        sol.Service_Job__c = JO1.ID;
        sol.Case_Name__c = 'ABC';
        sol.Solution_Title__c='CDE';
        sol.Name='ABC';
        sol.Diagnostic_Response__c ='Most likely the solution';
        sol.Repair_Response__c = 'Most likely';
        insert sol;
        
        CSS_Solution_Component__c JO = new CSS_Solution_Component__c();
        JO.Service_Job__c = JO1.id;
        JO.AccountCode__c = 'Testing';
        JO.AccountCodeType__c ='Testing';
        JO.AccountCodeEdit__c='Testing';
        JO.System_Code__c='Testing';
        JO.Component_Code__c='Testing';
        JO.Failure_Mode__c='Testing';
        JO.Selected_Component__c=true;
        JO.CSS_Claims__c=claim.id;
        JO.Solutions__c=Sol.Id;
        insert JO;
        
        
        ApexPages.currentPage().getParameters().put('id',JO1.id);
        Id Wid=ApexPages.CurrentPage().getParameters().get('id');
        
        CSS_Parts_Options__c prts = new CSS_Parts_Options__c();
        prts.Service_Job__c = JO1.Id;
        insert prts;
        
        
        list<CSS_SRT__c> srtList = New  list<CSS_SRT__c>();
        CSS_SRT__c srt = new CSS_SRT__c();
        srt.Job_Order__c = JO1.id;
        //srt.Account_Code__c='SERVICE TOOL WARRANTY 52'; 
        srt.Solution_Number__c = sol.id;
        srt.SRT_Title__c='test';
        srt.SRT_Quantity__c=123;
        srt.SRT_Time__c=123;
        srt.SRT_Access_Code__c='test';
        srt.SRT_Category__c='Campaign';
        srt.CSS_Claims__c=claim.id;
        srt.Type__c='Diag Access';
        srt.Component_Id__c=JO.Id;
        srt.srt_type__c='Diag Access';
        srt.Fail_Code_Description__c = 'THAC';
        srt.SRT_AccessiblityCheck__c=TRUE;
        srt.Access_Code__c='';
        srt.Extended_Hours__c=4;
        srt.SRT_Select__c=true;
        srtList.add(srt);
        
        CSS_SRT__c srt1 = new CSS_SRT__c();
        srt1.Job_Order__c = JO1.id;
        srt1.Solution_Number__c = sol.id;
        srt1.SRT_Title__c='test';
        srt1.SRT_Quantity__c=123;
        srt1.SRT_Time__c=123;
        srt1.SRT_Access_Code__c='test';
        srt1.SRT_Category__c='Campaign';
        srt1.CSS_Claims__c=claim.id;
        srt1.Type__c='Diag Access';
        srt1.Component_Id__c=JO.Id;
        srt1.srt_type__c='Diag Access';
        srt1.Fail_Code_Description__c = 'WEQPEZ';
        srt1.SRT_AccessiblityCheck__c=TRUE;
        srt1.Access_Code__c='';
        srt1.Extended_Hours__c=4;
        srt1.SRT_Select__c=true;
        srtList.add(srt1);
        
        CSS_SRT__c srt2 = new CSS_SRT__c();
        srt2.Job_Order__c = JO1.id;
        srt2.Solution_Number__c = sol.id;
        srt2.SRT_Title__c='test';
        srt2.SRT_Quantity__c=123;
        srt2.SRT_Time__c=123;
        srt2.SRT_Access_Code__c='test';
        srt2.SRT_Category__c='Campaign';
        srt2.CSS_Claims__c=claim.id;
        srt2.Type__c='Diag Access';
        srt2.Component_Id__c=JO.Id;
        srt2.srt_type__c='Diag Access';
        srt2.Fail_Code_Description__c = 'TRP-35';
        srt2.SRT_AccessiblityCheck__c=TRUE;
        srt2.Access_Code__c='';
        srt2.Extended_Hours__c=4;
        srt2.SRT_Select__c=true;
        srtList.add(srt2);
        
        insert srtList;
        
        
        test.startTest();
        CSS_JobPlanQuoteController obj = new CSS_JobPlanQuoteController();
        obj.claimsSRTList = srtList;
        obj.fetchAccountFailCodeCombo();
        test.stopTest();
        
    }
    
    static testmethod void fetchAccountFailCodeCombomethodFailcodeNullElse(){
        
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02650';
        acc.IAM_Service_Provider_Code__c='97895';
        acc.type='Dealer Account';
        insert acc;
        CSS_Job_Order__c JO1 = css_testdata.createJobOrder(true);
        JO1.BMSStatus__c = 'QTFI0';
        JO1.chevron_page__c = 'jpq';
        update JO1;
        CSS_Claims__c claim = new CSS_Claims__C();
        claim.AccessCode__c='test';
        claim.CSS_Job__c=JO1.id;
        claim.Account__c=acc.Id;
        insert claim;
        
        CSS_Solutions__c sol = new CSS_Solutions__c();
        sol.Service_Job__c = JO1.ID;
        sol.Case_Name__c = 'ABC';
        sol.Solution_Title__c='CDE';
        sol.Name='ABC';
        sol.Diagnostic_Response__c ='Most likely the solution';
        sol.Repair_Response__c = 'Most likely';
        insert sol;
        CSS_Solution_Component__c JO = new CSS_Solution_Component__c();
        JO.Service_Job__c = JO1.id;
        JO.AccountCode__c = 'Testing';
        JO.AccountCodeType__c ='Testing';
        JO.AccountCodeEdit__c='Testing';
        JO.System_Code__c='Testing';
        JO.Component_Code__c='Testing';
        JO.Failure_Mode__c='Testing';
        JO.Selected_Component__c=true;
        JO.CSS_Claims__c=claim.id;
        JO.Solutions__c=Sol.Id;
        insert JO;
        
        ApexPages.currentPage().getParameters().put('id',JO1.id);
        Id Wid=ApexPages.CurrentPage().getParameters().get('id');
        
        CSS_Parts_Options__c prts = new CSS_Parts_Options__c();
        prts.Service_Job__c = JO1.Id;
        insert prts;
        
        CSS_SRT__c srt = new CSS_SRT__c();
        srt.Solution_Number__c = sol.id;
        srt.SRT_Title__c='test';
        srt.SRT_Quantity__c=123;
        srt.SRT_Time__c=123;
        srt.SRT_Access_Code__c='test';
        srt.SRT_Category__c='Campaign';
        srt.CSS_Claims__c=claim.id;
        srt.Type__c='Diag Access';
        srt.Component_Id__c=Jo.Id;
        srt.srt_type__c='Diag Access';
        srt.FailCode__c='';
        srt.Access_Code__c='';
        srt.Extended_Hours__c=4;
        srt.SRT_Select__c=true;
        insert srt;
        
        test.startTest();
        
        CSS_JobPlanQuoteController obj = new CSS_JobPlanQuoteController();
        obj.fetchAccountFailCodeCombo();
        test.stopTest();
        
    }
    
    static testmethod void fetchAccountFailCodeCombomethodFailCode(){
        
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02650';
        acc.IAM_Service_Provider_Code__c='97895';
        acc.type='Dealer Account';
        insert acc;
        CSS_Job_Order__c JO1 = css_testdata.createJobOrder(true);
        CSS_Solutions__c sol = new CSS_Solutions__c();
        sol.Service_Job__c = JO1.ID;
        sol.Case_Name__c = 'ABC';
        sol.Solution_Title__c='CDE';
        sol.Name='ABC';
        sol.Diagnostic_Response__c ='Most likely the solution';
        sol.Repair_Response__c = 'Most likely';
        insert sol;
        CSS_Claims__c claim = new CSS_Claims__C();
        claim.AccessCode__c='test';
        claim.CSS_Job__c=JO1.id;
        claim.Account__c=acc.Id;
        insert claim;
       CSS_Solution_Component__c JO = new CSS_Solution_Component__c();
        JO.Service_Job__c = JO1.id;
        JO.AccountCode__c = 'Testing';
        JO.AccountCodeType__c ='Testing';
        JO.AccountCodeEdit__c='Testing';
        JO.System_Code__c='Testing';
        JO.Component_Code__c='Testing';
        JO.Failure_Mode__c='Testing';
        JO.Selected_Component__c=true;
        JO.CSS_Claims__c=claim.id;
        JO.Solutions__c=Sol.Id;
        insert JO;
        
        ApexPages.currentPage().getParameters().put('id',JO1.id);
        Id Wid=ApexPages.CurrentPage().getParameters().get('id');
        
        CSS_Parts_Options__c prts = new CSS_Parts_Options__c();
        prts.Service_Job__c = JO1.Id;
        insert prts;
        
        CSS_SRT__c srt = new CSS_SRT__c();
        srt.Solution_Number__c = sol.id;
        srt.SRT_Title__c='test';
        srt.SRT_Quantity__c=123;
        srt.SRT_Time__c=123;
        srt.SRT_Access_Code__c='test';
        srt.SRT_Category__c='Campaign';
        srt.CSS_Claims__c=claim.id;
        srt.Type__c='Diag Access';
        srt.Component_Id__c=JO.Id;
        srt.srt_type__c='Diag Access';
        srt.FailCode__c='';
        srt.Access_Code__c='';
        srt.Extended_Hours__c=4;
        srt.SRT_Select__c=true;
        insert srt;
        
        test.startTest();
        
        CSS_JobPlanQuoteController obj = new CSS_JobPlanQuoteController();
        obj.fetchAccountFailCodeCombo();
        test.stopTest();
        
    }
    
    static testmethod void getReasonQuoteDeclnemethod(){
        CSS_Job_Order__c JO1 = CSS_TestData.createJobOrder(true);
        CSS_JobPlanQuoteController jobplan = new CSS_JobPlanQuoteController();
        system.assert(string.isblank(jobplan.ERPErrorMsg));
        system.assert(string.isBlank(jobplan.assignSelectedDeclineQuotevalue));
        system.assert(jobplan.complaintcounter==null);
        system.assert(jobplan.coveragecounter==null);
        system.assert(jobplan.coveragecounter==null);
        system.assert(jobplan.correctioncounter==null);
        system.assert(jobplan.quote==null);
        system.assert(jobplan.EnableDecline==null);
        system.assert(jobplan.datetoday==null);
        system.assert(jobplan.attachObj==null);
        system.assert(jobplan.showErrorERP==null);
        system.assert(jobplan.causecounter==null);
        system.assert(jobplan.accURL==null);
        
        CSS_JobPlanQuoteController.getReasonQuoteDeclne(null,'creater location');
        
        
    }
    
    static testmethod void generateQuoteButtonmethod(){
        
        CSS_Job_Order__c JO1 = css_testdata.createJobOrder(true);
        
        Id recTyIdpart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'TTML'); 
        
        
        CSS_Parts_Options__c cssprts = new CSS_Parts_Options__c();
        cssprts.Service_Job__c=JO1.id;
        cssprts.RecordTypeId = recTyIdpart;
        cssprts.selected_part__c=true;
        insert cssprts;
        
        ApexPages.currentPage().getParameters().put('id',JO1.id);
        Id Wid=ApexPages.CurrentPage().getParameters().get('id');
        
        test.startTest();
        CSS_JobPlanQuoteController obj = new CSS_JobPlanQuoteController();
        obj.generateQuoteButton();
        test.stopTest();
        
    }
    
    
}