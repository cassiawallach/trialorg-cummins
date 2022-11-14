@IsTest
public class CSS_JobPlanSRTController_Test {
    //static   PageReference pref;
    static testmethod void jobPlanSRTControllertestmethod(){
        
        Test.startTest();
        
        Id currentUserID=UserInfo.getUserId();
        //list<user> userids = [select id,name from user limit 3]; 
        
        //Add test data for Service job order
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
        JO.Unit_Number__c = 'test123';
        Jo.Assigned_To__c = UserInfo.getUserId();
        JO.Additional_Tech1__c = UserInfo.getUserId(); //userids[0].id
        JO.Additional_Tech2__c = UserInfo.getUserId(); //userids[1].id
        JO.CSS_Job_Location_Code__c='56270-56255';
        Jo.esn__c='1234';
        JO.Equipment_ID__c = 'EQ7667';
        JO.Qsol_Engine_Family_Code__c ='56';
        JO.AccessCode__c = 'A';
        JO.BMSWSStatus__c = 'UI';
        JO.BMSStatus__c = 'sample';
        JO.CSS_Resolution__c='TEST';
        JO.chevron_page__c='srt';
        insert(JO);      
        PageReference pref;
        pref = new PageReference('/'+JO.id);
        pref.getParameters().put('id',JO.id);
        pref.getParameters().put('partsUr','Parts');
        Test.setCurrentPage(pref);
        
        CSS_JobPlanSRTController jobPlan= new CSS_JobPlanSRTController();
        
        
        JobPlan.workJob = [Select Id,Name,AccessCode__c,Customer_Name__c,Shop_Work_Order__c, Application__c, Application_Desc__c, BMS_Last_Name__c, DSID_WorkGroup__c, Unit_Number__c, Date_in__c, INSITE_UpdateTimeStamp__c, First_Name__c,
                           Repair_Location__c,Failure_Date__c, Failure_Point__c, Failure_Point_Measure__c, Service_Model__c,BMSStatus__c,Unit_Type__c, VIN__c, Warranty_Start_Date__c,Make__c, Qsol_Engine_Family_Code__c,
                           DSID__c, DSID_Creation_Timestamp__c, DSID_Status__c, Repeat_Or_Recent_Calc__c, DSID_UpdateTimestamp__c,Customer_Code__c,Status__c,
                           Phone_Number__c, Previous_Status__c,Sub_Type__c, Category__c, Complaint_Type__c, Model__c,Creator_Location__c, Control_Number__c,
                           Assigned_to__r.Name,Additional_Tech1__r.Name,Additional_Tech2__r.Name,OwnerId,JobLocation__c,CSS_Resolution__c,CSS_Feedback_Comments__c, BMSWSStatus__c,
                           ESN__c, Mileage__c, Mileage_Measure__c, chevron_page__c, General_Symptoms__c, Assigned_To__c, LastModifiedDate,CreatedDate,ESN_Locked__c,Region__c,Territory__c
                           from CSS_Job_Order__c where id= :JO.id];
        
        
        CSS_List_Of_Values__c CLV = new CSS_List_Of_Values__c();
        CLV.Name = 'Test'+math.random();
        CLV.Type__c = 'ApplicationCode';
        CLV.Code__c = 'UKEU';
        CLV.Picklist_Values_1__c = 'EUROPE';
        insert(CLV);
        
        CSS_Job_Order__c jobOrder = new CSS_Job_Order__c();
        jobOrder.Status__c = 'Created/Not Assigned';
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
        
        //jobPlan.pgSaveAssign();
        jobPlan.showPopup();
        jobPlan.closePopup();        
        jobPlan.redirectPopup();  
        
        
        //CSS_WPR_JobPlanOverview jpo = new CSS_WPR_JobPlanOverview();
        
        Test.stopTest();
    }
    
    static testmethod void jobPlanControllertestmethod3(){
        Test.startTest();
        
        Id currentUserID=UserInfo.getUserId();
        //list<user> userids = [select id,name from user limit 3]; 
        
        //Add test data for Service job order
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
        JO.Unit_Number__c = 'test123';
        Jo.Assigned_To__c = UserInfo.getUserId();
        JO.Additional_Tech1__c = UserInfo.getUserId();//userids[0].id;
        JO.Additional_Tech2__c = UserInfo.getUserId();//userids[1].id;
        Jo.esn__c='1234';
        JO.Equipment_ID__c = 'EQ7667';
        JO.Qsol_Engine_Family_Code__c ='56';
        JO.AccessCode__c = 'A';
        JO.BMSWSStatus__c = 'UI';
        JO.BMSStatus__c = 'UII';
        JO.EditCoverage__c='TEST';
        JO.EditComplaint__c='TEST';
        JO.EditCause__c='TEST';
        JO.EditCorrection__c='TEST';
        JO.chevron_page__c='srt';
        JO.CSS_Resolution__c='TEST';
        insert(JO);      
        PageReference pref;
        pref = new PageReference('/'+JO.id);
        pref.getParameters().put('id',JO.id);
        pref.getParameters().put('joPa','Parts');
        Test.setCurrentPage(pref);
        
        CSS_JobPlanSRTController jobPlan= new CSS_JobPlanSRTController();
        //jobPlan.bmsEnabled=TRUE;
        
        
        JobPlan.workJob = [Select Id,Name,AccessCode__c,Customer_Name__c,CSS_Hours__c,Shop_Work_Order__c, Application__c, Application_Desc__c, BMS_Last_Name__c, DSID_WorkGroup__c, Unit_Number__c, Date_in__c, INSITE_UpdateTimeStamp__c, First_Name__c,
                           Repair_Location__c,Failure_Date__c, Failure_Point__c, Failure_Point_Measure__c, Service_Model__c,BMSStatus__c,Unit_Type__c, VIN__c, Warranty_Start_Date__c,Make__c, Qsol_Engine_Family_Code__c,
                           DSID__c, DSID_Creation_Timestamp__c, DSID_Status__c, Repeat_Or_Recent_Calc__c, DSID_UpdateTimestamp__c,Customer_Code__c,Status__c,
                           Phone_Number__c, Previous_Status__c,Sub_Type__c, Category__c, Complaint_Type__c, Model__c,Creator_Location__c, Control_Number__c,
                           Assigned_to__r.Name,Additional_Tech1__r.Name,Additional_Tech2__r.Name,OwnerId,JobLocation__c,CSS_Resolution__c,CSS_Feedback_Comments__c, BMSWSStatus__c,
                           ESN__c, Mileage__c, Mileage_Measure__c, chevron_page__c, General_Symptoms__c, Assigned_To__c, LastModifiedDate,CreatedDate,ESN_Locked__c,Region__c,Territory__c
                           from CSS_Job_Order__c where id= :JO.id];
        
        CSS_Job_Order__c jobOrder = new CSS_Job_Order__c();
        jobOrder.Status__c = 'Created/Not Assigned';
        insert jobOrder;
        
        CSS_Fault_Code__c fc1 = new CSS_Fault_Code__c(FaultCodeR2__c = '441',Related_Fault_Code__c = '234,546');
        fc1.Name = '441';
        fc1.Job_Order__c = JO.Id;
        fc1.Sequence__c = 1;
        fc1.Fault_Code_Type__c = 'APD-P';
        fc1.Mod__c = '0';
        fc1.isPole__c = false;
        insert fc1;
        List<CSS_Fault_Code__c> lstFC = new List<CSS_Fault_Code__c>();
        lstFC.add(fc1);
        
        CSS_Solutions__c sol1 = new CSS_Solutions__c();
        sol1.FaultCode__c = fc1.Id;
        sol1.Service_Job__c = jobOrder.Id;
        sol1.Name = 'Sample Case Name';
        sol1.Case_Name__c = 'Sample Case Name';
        sol1.Solution_Title__c = 'Sample Title';
        sol1.Rank__c =0;
        insert sol1; 
        
        CSS_Solutions__c cssSol ;
        cssSol = new CSS_Solutions__c();
        cssSol.Name = 'Test Solution';
        cssSol.service_job__c = JO.id;
        cssSol.Out_Of_Order__c = true;
        cssSol.Diagnostic_Response__c = 'Most likely the solution';
        
        list<CSS_Solutions__c> solListSol = new list<CSS_Solutions__c>();
        solListSol.add(cssSol);
        insert solListSol;
        
        CSS_Solution_Component__c csc=new CSS_Solution_Component__c();
        csc.Action__c='test';
        csc.Solutions__c=sol1.id;
        csc.Service_Job__c=jobOrder.id;
        insert csc;
        /* CSS_SRT__c srt1= new CSS_SRT__c();
srt1.Id=  'a1E3B000001WOgoUAG';
srt1.Name='testing';
insert srt1;
CSS_SRT__c srt2= new CSS_SRT__c();
srt2.Id=  'a1E3B000001WOgtUAG';
srt2.Name='testing';
insert srt2;
map<string,CSS_SRT__c> mapStepIdtoSrt;
mapStepIdtoSrt.put('abc',srt1);
mapStepIdtoSrt.put('abc1',srt2);*/
        
        
        
        //jobplan.onChangeOfUnitNumber();
        Jobplan.bmsUserCloseFlag = true;
        jobplan.dsidStatus = true;
        Jobplan.countquote=0;
        //jobplan.isPrioritized = true;
        jobPlan.showJobPlanBlocks(true,false,true, false,false,false,false);
        //jobplan.faultCodes= lstFc;
        //jobplan.getFaultCodes();
        jobPlan.jobplan_prt();
        jobPlan.jobplan_war();
        jobPlan.jobplan_jpq();
        pref = jobPlan.jobplan_jo();
        jobPlan.jobplan_srt();
        //jobPlan.callWOComment();
        jobPlan.updateservjob();
        jobPlan.Cancel();
        CSS_OverlapSRTResponse overLap=new CSS_OverlapSRTResponse();
        // jobPlan.createOverLapSrtList(overLap);
        jobPlan.populateMap(JO);
        //  jobPlan.loadRequestData();
        jobPlan.sendSRTsToBMS('testing','testing');
        CSS_jobPlanInboundJSON2Apex jobPlanRespWO = new CSS_jobPlanInboundJSON2Apex();
        jobPlan.sendSRTsToBMSWOQT('testing');
        jobPlan.sendSRTsToBMSWO();
        Test.stopTest();            
        pref = jobPlan.jobplan_narr();
    }
    
    static testmethod void jobPlanControllertestmethod2(){
        
        Test.startTest();
        
        CSS_JobPlanSRTController jobPlan= new CSS_JobPlanSRTController();
        jobPlan.complaintcounter=2;
        jobPlan.displaySRTButton = true;
        jobPlan.coveragecounter=2;
        jobPlan.causecounter=2;
        jobPlan.correctioncounter=2;
        jobPlan.timemin=2;
        jobPlan.timeminov=2;
        jobPlan.TotalOverlapHours=2;
        jobPlan.TotalAdjustedHours=2;
        jobPlan.overlapErrorMsg='Test23';
        
        CSS_JobPlanSRTController.overLapSrtWrapper OvpW=new  CSS_JobPlanSRTController.overLapSrtWrapper();
        OvpW.overide=true;
        ovpW.OverlapSRTTime =10;
        ovpw.SRT_Code ='90';
        ovpW.SRT_Description ='Test';
        ovpW.SRT_Notes ='Test';
        ovpw.SRT_Overlap =89;
        ovpw.SRT_OverrideReason ='Test';
        ovpw.SRT_Time ='19';
        ovpw.Id ='243536';
        List<CSS_JobPlanSRTController.overLapSrtWrapper> LstJP=new List<CSS_JobPlanSRTController.overLapSrtWrapper>();
        jobPlan.lstOverLapSrt=null;
        Id currentUserID=UserInfo.getUserId();
        //list<user> userids = [select id,name from user limit 3];
        
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02466';
        acc.IAM_Service_Provider_Code__c='19134';
        acc.Type='Dealer Account';
        acc.CMI_Account_Status__c = 'Active';
        acc.ERP_System__c = 'One BMS';
        insert acc;
        
        //Add test data for Service job order
        CSS_Job_Order__c JO = new CSS_Job_Order__c();
        JO.Customer_Name__c = 'Test';
        JO.Customer_Code__c=null;
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
        JO.Unit_Number__c = 'test123';
        Jo.Assigned_To__c = UserInfo.getUserId();
        JO.Additional_Tech1__c =  UserInfo.getUserId();// userids[0].id;
        JO.Additional_Tech2__c =  UserInfo.getUserId();//userids[1].id;
        Jo.esn__c='1234';
        JO.Equipment_ID__c = 'EQ7667';
        JO.Qsol_Engine_Family_Code__c ='56';
        JO.AccessCode__c = 'A';
        JO.BMSWSStatus__c = 'UI';
        JO.Unit_Number__c = '12345';
        JO.Shop_Work_Order__c='12345';
        JO.EditCoverage__c = 'Test';
        JO.EditComplaint__c = 'Test';
        JO.EditCorrection__c = 'TEST';
        JO.EditCause__c = 'TEST';
        JO.BMSStatus__c = 'UII';
        JO.chevron_page__c='srt';
        JO.CSS_Resolution__c='test';
        JO.Customer_Code__c ='8989';
        JO.Shop_Work_Order__c='Test78';
        JO.Account__c = acc.id;
        insert(JO);      
        
        JobPlan.workJob = [Select Id,Name,AccessCode__c,Customer_Name__c,Shop_Work_Order__c, Application__c, Application_Desc__c, BMS_Last_Name__c, DSID_WorkGroup__c, Unit_Number__c, Date_in__c, INSITE_UpdateTimeStamp__c, First_Name__c,
                           Repair_Location__c,Failure_Date__c, Failure_Point__c, Failure_Point_Measure__c, Service_Model__c, VIN__c,BMSStatus__c,Unit_Type__c, Warranty_Start_Date__c,Make__c, Qsol_Engine_Family_Code__c,
                           DSID__c, DSID_Creation_Timestamp__c, DSID_Status__c, Repeat_Or_Recent_Calc__c, DSID_UpdateTimestamp__c,Customer_Code__c,Status__c,
                           Phone_Number__c, Previous_Status__c,Sub_Type__c, Category__c, Complaint_Type__c, Model__c,Creator_Location__c, Control_Number__c,
                           Assigned_to__r.Name,Additional_Tech1__r.Name,Additional_Tech2__r.Name,OwnerId,JobLocation__c,CSS_Resolution__c,CSS_Feedback_Comments__c,BMSWSStatus__c,EditCoverage__c,EditComplaint__c,
                           ESN__c, Mileage__c, Mileage_Measure__c, chevron_page__c,General_Symptoms__c, Assigned_To__c, LastModifiedDate,CreatedDate,ESN_Locked__c,Region__c,Territory__c
                           from CSS_Job_Order__c where id= :JO.id];
        
        /*PageReference p=Page.CSS_Jobplan; 
Test.setCurrentPage(p);  */
        ApexPages.currentPage().getParameters().put('id',jo.Id);         
        
        CSS_Fault_Code__c fc1 = new CSS_Fault_Code__c(FaultCodeR2__c = '441',Related_Fault_Code__c = '234,546');
        fc1.Name = '441';
        fc1.Job_Order__c = JO.Id;
        fc1.Sequence__c = 1;
        fc1.Fault_Code_Type__c = 'APD-P';
        fc1.Mod__c = '0';
        fc1.isPole__c = false;
        insert fc1;
        List<CSS_Fault_Code__c> lstFC1 = new List<CSS_Fault_Code__c>();
        lstFC1.add(fc1);
        
        CSS_Solutions__c sol1 = new CSS_Solutions__c();
        sol1.FaultCode__c = fc1.Id;
        sol1.Service_Job__c = JO.Id;
        sol1.Name = 'Sample Case Name';
        sol1.Case_Name__c = 'Sample Case Name';
        sol1.Solution_Title__c = 'Sample Title';
        sol1.Rank__c =0;
        sol1.Diagnostic_Response__c = 'Most likely the solution';
        // sol1.Repair_Response__c ='';
        sol1.Repair_Response__c='Repair Successful.';
        //sol1.Out_Of_Order__c = true;
        insert sol1;
        
        
        CSS_Solution_Component__c csc=new CSS_Solution_Component__c();
        csc.Action__c='test';
        csc.Solutions__c=sol1.id;
        csc.Service_Job__c=JO.id;
        insert csc;
        
        css_srt__c srt = new css_srt__c();
        
        srt.Solution_Number__c = sol1.id;
        srt.SRT_AccessiblityCheck__c=True;
        srt.SRT_Time__c = 1.1;
        srt.Job_Order__c = JO.id;
        srt.isPerformed__c = true;
        srt.name = 'Test';
        srt.SRT_Type__c = 'Repair';
        srt.SRT_ID__c = '00-11';
        // insert srt;
        
        css_srt__c srt1 = new css_srt__c();
        srt1.Solution_Number__c = sol1.id;
        srt1.SRT_AccessiblityCheck__c=True;
        srt1.SRT_Time__c = 1.1;
        srt1.Job_Order__c = JO.id;
        srt1.name = 'Test';
        srt1.isPerformed__c = true;
        srt1.SRT_Type__c = 'Repair';
        srt1.SRT_ID__c = '00-11';
        //insert srt1;
        
        css_srt__c srt3 = new css_srt__c();
        srt3.Solution_Number__c = sol1.id;
        srt3.SRT_AccessiblityCheck__c=True;
        srt3.SRT_Time__c = 1.1;
        srt3.Job_Order__c = JO.id;
        srt3.name = 'Test';
        // srt3.isPerformed__c = true;
        srt3.SRT_Type__c = 'Overlap';
        srt3.SRT_ID__c = '00-11';
        insert srt3;
        //siva
        CSS_SRT__C FieldAction = new CSS_SRT__C();
        FieldAction.Solution_Number__c = sol1.id;
        FieldAction.Job_Order__c = JO.id;
        FieldAction.SRT_Quantity__c =2;
        FieldAction.SRT_Warrantable__c ='3';
        FieldAction.SRT_AccessiblityCheck__c=True;
        FieldAction.SRT_Time__c = 1.1;
        FieldAction.name = 'Test';
        FieldAction.Type__c = 'Field Action';
        FieldAction.SRT_ID__c = '00-11';
        insert FieldAction;
        CSS_SRT__C srtoverlp = new CSS_SRT__C();
        srtoverlp.Solution_Number__c = sol1.id;
        srtoverlp.Job_Order__c = JO.id;
        srtoverlp.SRT_Quantity__c =2;
        srtoverlp.SRT_Warrantable__c ='3';
        srtoverlp.SRT_AccessiblityCheck__c=True;
        srtoverlp.SRT_Time__c = 1.1;
        srtoverlp.name = 'Test';
        srtoverlp.Type__c = 'Overlap';
        srtoverlp.SRT_ID__c = '00-11';
        insert srtoverlp;
        jobPlan.jobPlanSRTAction();
        
        CSS_SRT__C srtDiagAccess = new CSS_SRT__C();
        srtDiagAccess.Solution_Number__c = sol1.id;
        srtDiagAccess.Job_Order__c = JO.id;
        srtDiagAccess.SRT_Quantity__c =2;
        srtDiagAccess.SRT_Warrantable__c ='3';
        srtDiagAccess.SRT_AccessiblityCheck__c=True;
        srtDiagAccess.SRT_Time__c = 1.1;
        srtDiagAccess.name = 'Test';
        srtDiagAccess.Type__c = 'Repair Access';
        srtDiagAccess.SRT_ID__c = '00-11';
        insert srtDiagAccess;
        
        jobPlan.jobPlanSRTAction();
        List<css_srt__c> lstSRT = new List<css_srt__c>();
        lstSRT.add(srt);
        lstSRT.add(srt1);
        // lstSRT.add(srt2);
        lstSRT.add(srt3);
        
         List<css_srt__c> lstSRTAccess = new List<css_srt__c>();
        
        css_srt__c srt4 = new css_srt__c();
        
        srt4.Solution_Number__c = sol1.id;
        srt4.SRT_AccessiblityCheck__c=True;
        srt4.SRT_Time__c = 1.1;
        srt4.Job_Order__c = JO.id;
        srt4.isPerformed__c = true;
        srt4.name = 'Test';
        srt4.SRT_Type__c = 'Repair';
        srt4.SRT_ID__c = '1211';
        srt4.Step_Id__c = '1';
        // insert srt;
        lstSRTAccess.add(srt4);
        
        insert lstSRTAccess;
        
        jobPlan.mutualOverlapSRTCallout(lstSRTAccess);
        
        //jobPlan.callUnitInboundGeneric();
        CSS_Quote__c qt = new CSS_Quote__c(); 
        qt.AcceptQuote__c = true;
        qt.QuoteTotal__c = 1000;
        qt.Service_Job__c = JO.id;
        
        list<Attachment> attachmentList = new list<Attachment>();
        // Add test file for attachment            
        
        Attachment attach=new Attachment();    
        attach.Name='Unit Test Attachment';
        Blob bodyBlob1=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob1;
        attach.parentId=jo.id;
        attachmentList.add(attach);
        
        Attachment attach1=new Attachment();    
        attach1.Name='Unit Test Attachment1';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body1');
        attach1.body=bodyBlob;
        attach1.parentId=jo.id;
        
        insert attach;
        
        CSS_accountLanguage__c accntLang = new CSS_accountLanguage__c();
        accntLang.name = 'en';
        accntLang.CSS_QsolLanguage__c = 'en';
        accntLang.CSS_userLanguage__c = 'en';
        accntLang.CSS_EDSLanguage__c = 'en';
        insert(accntLang);
        
        Id recTypeIdoption = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'Options');
        Id recTypeIdpart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'Parts');
        
        CSS_Solution_Component__c comp = new CSS_Solution_Component__c();
        
        comp.Component_Id__c = 'Fooo1';
        comp.Service_Job__c = JO.Id;
        insert comp;
        
        CSS_Parts_Options__c parts = new CSS_Parts_Options__c();
        parts.recordtypeId = recTypeIdpart;
        parts.Option_Number__c = 'O-111';
        parts.Service_Job__c = Jo.Id;
        parts.selected_part__c = true;
        parts.FailurepartId__c = comp.Id;
        insert parts;
        
        /*CSS_CampTsbTrp__c x1 = new CSS_CampTsbTrp__c();
x1.Job_order__c = Jo.Id;
x1.performed_review__c = true;
x1.performed__c =false;
insert x1;*/
        
        
        jobplan.Wid = Jo.Id;
        jobplan.comm = 'sample';
        Note x2 = new Note();
        x2.Title = 'CAMPCOMMENTS';
        x2.ParentId = jobplan.Wid; 
        x2.Body =  jobplan.comm;
        insert x2;
        
        jobplan.NotesBody = 'sample';
        jobplan.show_war_pnl = true;
        jobplan.showResolution = true;
        jobplan.showRepairs = true;
        jobplan.nocamptsbtrps = true;
        jobPlan.accQuoteFlag = true;
        jobplan.showResolutionWithRepair = false;
        jobPlan.showRepairErrorMessage = true;
        jobPlan.requiredBMSMessage = true;
        //jobPlan.bmsEnabled=TRUE;
        //Attachment attach;
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Miles',system.Label.CSS_Miles));
        options.add(new SelectOption('Kilometers',system.Label.CSS_Kilometers)); 
        
        jobPlan.savecheckbox();
        jobPlan.updatestatus();
        jobPlan.closeSession();
        jobPlan.updateservjob();
        jobPlan.closeSession_close();
        jobPlan.jobClosePopup();
        jobPlan.pgsave();
        jobPlan.pgSaveFinish();
        jobplan.saveAndCloseJob();
        //   pageReference pref = jobplan.saveAndCloseJob();
        Test.stopTest();
    }
    
    static testmethod void jobPlanControllertestmethod23(){
        
        Test.startTest();
        
        CSS_JobPlanSRTController jobPlan= new CSS_JobPlanSRTController();
        jobPlan.complaintcounter=2;
        jobPlan.coveragecounter=2;
        jobPlan.causecounter=2;
        jobPlan.correctioncounter=2;
        jobPlan.timemin=2;
        jobPlan.timeminov=2;
        jobPlan.TotalOverlapHours=2;
        jobPlan.TotalAdjustedHours=2;
        jobPlan.overlapErrorMsg='Test23';
        
        CSS_JobPlanSRTController.overLapSrtWrapper OvpW=new  CSS_JobPlanSRTController.overLapSrtWrapper();
        OvpW.overide=true;
        ovpW.OverlapSRTTime =10;
        ovpw.SRT_Code ='90';
        ovpW.SRT_Description ='Test';
        ovpW.SRT_Notes ='Test';
        ovpw.SRT_Overlap =89;
        ovpw.SRT_OverrideReason ='Test';
        ovpw.SRT_Time ='19';
        ovpw.Id ='243536';
        List<CSS_JobPlanSRTController.overLapSrtWrapper> LstJP=new List<CSS_JobPlanSRTController.overLapSrtWrapper>();
        jobPlan.lstOverLapSrt=null;
        Id currentUserID=UserInfo.getUserId();
       // list<user> userids = [select id,name from user limit 3];
        
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02466';
        acc.IAM_Service_Provider_Code__c='19134';
        acc.Type='Dealer Account';
        acc.CMI_Account_Status__c = 'Active';
        insert acc;
        
        //Add test data for Service job order
        CSS_Job_Order__c JO = new CSS_Job_Order__c();
        JO.Account__c = acc.id;
        JO.Customer_Name__c = 'Test';
        JO.Customer_Code__c=null;
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
        JO.Unit_Number__c = 'test123';
        Jo.Assigned_To__c = UserInfo.getUserId();
        JO.Additional_Tech1__c =  UserInfo.getUserId();//userids[0].id;
        JO.Additional_Tech2__c =  UserInfo.getUserId();//userids[1].id;
        Jo.esn__c='1234';
        JO.Equipment_ID__c = 'EQ7667';
        JO.Qsol_Engine_Family_Code__c ='56';
        JO.AccessCode__c = 'A';
        JO.BMSWSStatus__c = 'UI';
        JO.Unit_Number__c = '12345';
        JO.Shop_Work_Order__c='12345';
        JO.EditCoverage__c = 'Test';
        JO.EditComplaint__c = 'Test';
        JO.EditCorrection__c = 'TEST';
        JO.EditCause__c = 'TEST';
        JO.BMSStatus__c = 'UII';
        JO.chevron_page__c='srt';
        JO.CSS_Resolution__c='test';
        JO.Customer_Code__c ='8989';
        JO.Shop_Work_Order__c='Test78';
        insert(JO);      
        
        JobPlan.workJob = [Select Id,Name,AccessCode__c,Customer_Name__c,Shop_Work_Order__c, Application__c, Application_Desc__c, BMS_Last_Name__c, DSID_WorkGroup__c, Unit_Number__c, Date_in__c, INSITE_UpdateTimeStamp__c, First_Name__c,
                           Repair_Location__c,Failure_Date__c, Failure_Point__c, Failure_Point_Measure__c, Service_Model__c, VIN__c,BMSStatus__c,Unit_Type__c, Warranty_Start_Date__c,Make__c, Qsol_Engine_Family_Code__c,
                           DSID__c, DSID_Creation_Timestamp__c, DSID_Status__c, Repeat_Or_Recent_Calc__c, DSID_UpdateTimestamp__c,Customer_Code__c,Status__c,
                           Phone_Number__c, Previous_Status__c,Sub_Type__c, Category__c, Complaint_Type__c, Model__c,Creator_Location__c, Control_Number__c,
                           Assigned_to__r.Name,Additional_Tech1__r.Name,Additional_Tech2__r.Name,OwnerId,JobLocation__c,CSS_Resolution__c,CSS_Feedback_Comments__c,BMSWSStatus__c,EditCoverage__c,EditComplaint__c,
                           ESN__c, Mileage__c, Mileage_Measure__c, chevron_page__c,General_Symptoms__c, Assigned_To__c, LastModifiedDate,CreatedDate,ESN_Locked__c,Region__c,Territory__c
                           from CSS_Job_Order__c where id= :JO.id];
        
        /*PageReference p=Page.CSS_Jobplan; 
Test.setCurrentPage(p);  */
        ApexPages.currentPage().getParameters().put('id',jo.Id);         
        
        CSS_Fault_Code__c fc1 = new CSS_Fault_Code__c(FaultCodeR2__c = '441',Related_Fault_Code__c = '234,546');
        fc1.Name = '441';
        fc1.Job_Order__c = JO.Id;
        fc1.Sequence__c = 1;
        fc1.Fault_Code_Type__c = 'APD-P';
        fc1.Mod__c = '0';
        fc1.isPole__c = false;
        insert fc1;
        List<CSS_Fault_Code__c> lstFC1 = new List<CSS_Fault_Code__c>();
        lstFC1.add(fc1);
        List<CSS_Solutions__c> repairSolutions = new List<CSS_Solutions__c>();
        CSS_Solutions__c sol1 = new CSS_Solutions__c();
        repairSolutions.add(sol1);
        
        
        
        CSS_Solution_Component__c csc=new CSS_Solution_Component__c();
        csc.Action__c='test';
        //csc.Solutions__c=sol1.id;
        csc.Service_Job__c=JO.id;
        insert csc;
        
        css_srt__c srt = new css_srt__c();
        
        //srt.Solution_Number__c = sol1.id;
        srt.SRT_AccessiblityCheck__c=True;
        srt.SRT_Time__c = 1.1;
        srt.Job_Order__c = JO.id;
        srt.isPerformed__c = true;
        srt.name = 'Test';
        srt.SRT_Type__c = 'Repair';
        srt.SRT_ID__c = '00-11';
        //insert srt;
        
        css_srt__c srt1 = new css_srt__c();
        srt1.Solution_Number__c = sol1.id;
        srt1.SRT_AccessiblityCheck__c=True;
        srt1.SRT_Time__c = 1.1;
        srt1.Job_Order__c = JO.id;
        srt1.name = 'Test';
        srt1.isPerformed__c = true;
        srt1.SRT_Type__c = 'Repair';
        srt1.SRT_ID__c = '00-11';
        //insert srt1;
        
        css_srt__c srt3 = new css_srt__c();
        srt3.Solution_Number__c = sol1.id;
        srt3.SRT_AccessiblityCheck__c=True;
        srt3.SRT_Time__c = 1.1;
        srt3.Job_Order__c = JO.id;
        srt3.name = 'Test';
        // srt3.isPerformed__c = true;
        srt3.SRT_Type__c = 'Overlap';
        srt3.SRT_ID__c = '00-11';
        insert srt3;
        //siva
        CSS_SRT__C FieldAction = new CSS_SRT__C();
        FieldAction.Solution_Number__c = sol1.id;
        FieldAction.Job_Order__c = JO.id;
        FieldAction.SRT_Quantity__c =2;
        FieldAction.SRT_Warrantable__c ='3';
        FieldAction.SRT_AccessiblityCheck__c=True;
        FieldAction.SRT_Time__c = 1.1;
        FieldAction.name = 'Test';
        FieldAction.Type__c = 'Field Action';
        FieldAction.SRT_ID__c = '00-11';
        insert FieldAction;
        CSS_SRT__C srtoverlp = new CSS_SRT__C();
        srtoverlp.Solution_Number__c = sol1.id;
        srtoverlp.Job_Order__c = JO.id;
        srtoverlp.SRT_Quantity__c =2;
        srtoverlp.SRT_Warrantable__c ='3';
        srtoverlp.SRT_AccessiblityCheck__c=True;
        srtoverlp.SRT_Time__c = 1.1;
        srtoverlp.name = 'Test';
        srtoverlp.Type__c = 'Overlap';
        srtoverlp.SRT_ID__c = '00-11';
        insert srtoverlp;
        jobPlan.jobPlanSRTAction();
        CSS_SRT__C srtDiagAccess = new CSS_SRT__C();
        srtDiagAccess.Solution_Number__c = sol1.id;
        srtDiagAccess.Job_Order__c = JO.id;
        srtDiagAccess.SRT_Quantity__c =2;
        srtDiagAccess.SRT_Warrantable__c ='3';
        srtDiagAccess.SRT_AccessiblityCheck__c=True;
        srtDiagAccess.SRT_Time__c = 1.1;
        srtDiagAccess.name = 'Test';
        srtDiagAccess.Type__c = 'Repair Access';
        srtDiagAccess.SRT_ID__c = '00-11';
        insert srtDiagAccess;
        
        jobPlan.jobPlanSRTAction();
        List<css_srt__c> lstSRT = new List<css_srt__c>();
        lstSRT.add(srt);
        lstSRT.add(srt1);
        // lstSRT.add(srt2);
        lstSRT.add(srt3);
        
        CSS_Quote__c qt = new CSS_Quote__c(); 
        qt.AcceptQuote__c = true;
        qt.QuoteTotal__c = 1000;
        qt.Service_Job__c = JO.id;
        
        list<Attachment> attachmentList = new list<Attachment>();
        // Add test file for attachment            
        
        Attachment attach=new Attachment();    
        attach.Name='Unit Test Attachment';
        Blob bodyBlob1=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob1;
        attach.parentId=jo.id;
        attachmentList.add(attach);
        
        Attachment attach1=new Attachment();    
        attach1.Name='Unit Test Attachment1';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body1');
        attach1.body=bodyBlob;
        attach1.parentId=jo.id;
        
        insert attach;
        
        CSS_accountLanguage__c accntLang = new CSS_accountLanguage__c();
        accntLang.name = 'en';
        accntLang.CSS_QsolLanguage__c = 'en';
        accntLang.CSS_userLanguage__c = 'en';
        accntLang.CSS_EDSLanguage__c = 'en';
        insert(accntLang);
        
        Id recTypeIdoption = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'Options');
        Id recTypeIdpart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'Parts');
        
        CSS_Solution_Component__c comp = new CSS_Solution_Component__c();
        
        comp.Component_Id__c = 'Fooo1';
        comp.Service_Job__c = JO.Id;
        insert comp;
        
        CSS_Parts_Options__c parts = new CSS_Parts_Options__c();
        parts.recordtypeId = recTypeIdpart;
        parts.Option_Number__c = 'O-111';
        parts.Service_Job__c = Jo.Id;
        parts.selected_part__c = true;
        parts.FailurepartId__c = comp.Id;
        insert parts;
        
        /*CSS_CampTsbTrp__c x1 = new CSS_CampTsbTrp__c();
x1.Job_order__c = Jo.Id;
x1.performed_review__c = true;
x1.performed__c =false;
insert x1;*/
        
        
        jobplan.Wid = Jo.Id;
        jobplan.comm = 'sample';
        Note x2 = new Note();
        x2.Title = 'CAMPCOMMENTS';
        x2.ParentId = jobplan.Wid; 
        x2.Body =  jobplan.comm;
        insert x2;
        
        jobplan.NotesBody = 'sample';
        jobplan.show_war_pnl = true;
        jobplan.showResolution = true;
        jobplan.showRepairs = true;
        jobplan.nocamptsbtrps = true;
        jobPlan.accQuoteFlag = true;
        jobplan.showResolutionWithRepair = false;
        jobPlan.showRepairErrorMessage = true;
        jobPlan.requiredBMSMessage = true;
        //jobPlan.bmsEnabled=TRUE;
        //Attachment attach;
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Miles',system.Label.CSS_Miles));
        options.add(new SelectOption('Kilometers',system.Label.CSS_Kilometers)); 
        
        jobPlan.savecheckbox();
        jobPlan.updatestatus();
        jobPlan.closeSession();
        jobPlan.updateservjob();
        jobPlan.closeSession_close();
        jobPlan.jobClosePopup();
        jobPlan.pgsave();
        jobPlan.pgSaveFinish();
        jobplan.saveAndCloseJob();
        //   pageReference pref = jobplan.saveAndCloseJob();
        Test.stopTest();
    }
    
    static testmethod void jobPlanControllertestmethod21(){
        
        Test.startTest();
        
        CSS_JobPlanSRTController jobPlan= new CSS_JobPlanSRTController();
        jobPlan.complaintcounter=2;
        jobPlan.coveragecounter=2;
        jobPlan.causecounter=2;
        jobPlan.correctioncounter=2;
        jobPlan.timemin=2;
        jobPlan.timeminov=2;
        jobPlan.TotalOverlapHours=2;
        jobPlan.TotalAdjustedHours=2;
        jobPlan.overlapErrorMsg='Test23';
        
        CSS_JobPlanSRTController.overLapSrtWrapper OvpW=new  CSS_JobPlanSRTController.overLapSrtWrapper();
        OvpW.overide=true;
        ovpW.OverlapSRTTime =10;
        ovpw.SRT_Code ='90';
        ovpW.SRT_Description ='Test';
        ovpW.SRT_Notes ='Test';
        ovpw.SRT_Overlap =89;
        ovpw.SRT_OverrideReason ='Test';
        ovpw.SRT_Time ='19';
        ovpw.Id ='243536';
        List<CSS_JobPlanSRTController.overLapSrtWrapper> LstJP=new List<CSS_JobPlanSRTController.overLapSrtWrapper>();
        jobPlan.lstOverLapSrt=null;
        Id currentUserID=UserInfo.getUserId();
       // list<user> userids = [select id,name from user limit 3];
        
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02466';
        acc.IAM_Service_Provider_Code__c='19134';
        acc.Type='Dealer Account';
        acc.CMI_Account_Status__c = 'Active';
        insert acc;
        
        //Add test data for Service job order
        CSS_Job_Order__c JO = new CSS_Job_Order__c();
        JO.Account__c = acc.id;
        JO.Customer_Name__c = 'Test';
        JO.Customer_Code__c=null;
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
        JO.Unit_Number__c = 'test123';
        Jo.Assigned_To__c = UserInfo.getUserId();
        JO.Additional_Tech1__c =  UserInfo.getUserId();// userids[0].id;
        JO.Additional_Tech2__c =  UserInfo.getUserId(); //userids[1].id;
        Jo.esn__c='1234';
        JO.Equipment_ID__c = 'EQ7667';
        JO.Qsol_Engine_Family_Code__c ='56';
        JO.AccessCode__c = 'A';
        JO.BMSWSStatus__c = 'UI';
        JO.Unit_Number__c = '12345';
        JO.Shop_Work_Order__c='12345';
        JO.EditCoverage__c = 'Test';
        JO.EditComplaint__c = 'Test';
        JO.EditCorrection__c = 'TEST';
        JO.EditCause__c = 'TEST';
        JO.BMSStatus__c = 'UII';
        JO.chevron_page__c='srt';
        JO.CSS_Resolution__c='test';
        JO.Customer_Code__c ='8989';
        JO.Shop_Work_Order__c='Test78';
        insert(JO);      
        
        JobPlan.workJob = [Select Id,Name,AccessCode__c,Customer_Name__c,Shop_Work_Order__c, Application__c, Application_Desc__c, BMS_Last_Name__c, DSID_WorkGroup__c, Unit_Number__c, Date_in__c, INSITE_UpdateTimeStamp__c, First_Name__c,
                           Repair_Location__c,Failure_Date__c, Failure_Point__c, Failure_Point_Measure__c, Service_Model__c, VIN__c,BMSStatus__c,Unit_Type__c, Warranty_Start_Date__c,Make__c, Qsol_Engine_Family_Code__c,
                           DSID__c, DSID_Creation_Timestamp__c, DSID_Status__c, Repeat_Or_Recent_Calc__c, DSID_UpdateTimestamp__c,Customer_Code__c,Status__c,
                           Phone_Number__c, Previous_Status__c,Sub_Type__c, Category__c, Complaint_Type__c, Model__c,Creator_Location__c, Control_Number__c,
                           Assigned_to__r.Name,Additional_Tech1__r.Name,Additional_Tech2__r.Name,OwnerId,JobLocation__c,CSS_Resolution__c,CSS_Feedback_Comments__c,BMSWSStatus__c,EditCoverage__c,EditComplaint__c,
                           ESN__c, Mileage__c, Mileage_Measure__c, chevron_page__c,General_Symptoms__c, Assigned_To__c, LastModifiedDate,CreatedDate,ESN_Locked__c,Region__c,Territory__c
                           from CSS_Job_Order__c where id= :JO.id];
        
        /*PageReference p=Page.CSS_Jobplan; 
Test.setCurrentPage(p);  */
        ApexPages.currentPage().getParameters().put('id',jo.Id);         
        
        CSS_Fault_Code__c fc1 = new CSS_Fault_Code__c(FaultCodeR2__c = '441',Related_Fault_Code__c = '234,546');
        fc1.Name = '441';
        fc1.Job_Order__c = JO.Id;
        fc1.Sequence__c = 1;
        fc1.Fault_Code_Type__c = 'APD-P';
        fc1.Mod__c = '0';
        fc1.isPole__c = false;
        insert fc1;
        List<CSS_Fault_Code__c> lstFC1 = new List<CSS_Fault_Code__c>();
        lstFC1.add(fc1);
        
        CSS_Solutions__c sol1 = new CSS_Solutions__c();
        sol1.FaultCode__c = fc1.Id;
        sol1.Service_Job__c = JO.Id;
        sol1.Name = 'Sample Case Name';
        sol1.Case_Name__c = 'Sample Case Name';
        sol1.Solution_Title__c = 'Sample Title';
        sol1.Rank__c =0;
        sol1.Diagnostic_Response__c = 'Most likely the solution';
        // sol1.Repair_Response__c ='';
        sol1.Repair_Response__c='Repair Successful.';
        sol1.Out_Of_Order__c = true;
        insert sol1;
        
        
        CSS_Solution_Component__c csc=new CSS_Solution_Component__c();
        csc.Action__c='test';
        csc.Solutions__c=sol1.id;
        csc.Service_Job__c=JO.id;
        insert csc;
        
        css_srt__c srt = new css_srt__c();
        
        srt.Solution_Number__c = sol1.id;
        srt.SRT_AccessiblityCheck__c=True;
        srt.SRT_Time__c = 1.1;
        srt.Job_Order__c = JO.id;
        srt.isPerformed__c = true;
        srt.name = 'Test';
        srt.SRT_Type__c = 'Repair';
        srt.SRT_ID__c = '00-11';
        // insert srt;
        
        css_srt__c srt1 = new css_srt__c();
        srt1.Solution_Number__c = sol1.id;
        srt1.SRT_AccessiblityCheck__c=True;
        srt1.SRT_Time__c = 1.1;
        srt1.Job_Order__c = JO.id;
        srt1.name = 'Test';
        srt1.isPerformed__c = true;
        srt1.SRT_Type__c = 'Repair';
        srt1.SRT_ID__c = '00-11';
        //insert srt1;
        
        css_srt__c srt3 = new css_srt__c();
        srt3.Solution_Number__c = sol1.id;
        srt3.SRT_AccessiblityCheck__c=True;
        srt3.SRT_Time__c = 1.1;
        srt3.Job_Order__c = JO.id;
        srt3.name = 'Test';
        // srt3.isPerformed__c = true;
        srt3.SRT_Type__c = 'Overlap';
        srt3.SRT_ID__c = '00-11';
        insert srt3;
        //siva
        CSS_SRT__C FieldAction = new CSS_SRT__C();
        FieldAction.Solution_Number__c = sol1.id;
        FieldAction.Job_Order__c = JO.id;
        FieldAction.SRT_Quantity__c =2;
        FieldAction.SRT_Warrantable__c ='3';
        FieldAction.SRT_AccessiblityCheck__c=True;
        FieldAction.SRT_Time__c = 1.1;
        FieldAction.name = 'Test';
        FieldAction.Type__c = 'Field Action';
        FieldAction.SRT_ID__c = '00-11';
        insert FieldAction;
        CSS_SRT__C srtoverlp = new CSS_SRT__C();
        srtoverlp.Solution_Number__c = sol1.id;
        srtoverlp.Job_Order__c = JO.id;
        srtoverlp.SRT_Quantity__c =2;
        srtoverlp.SRT_Warrantable__c ='3';
        srtoverlp.SRT_AccessiblityCheck__c=True;
        srtoverlp.SRT_Time__c = 1.1;
        srtoverlp.name = 'Test';
        srtoverlp.Type__c = 'Overlap';
        srtoverlp.SRT_ID__c = '00-11';
        insert srtoverlp;
        jobPlan.jobPlanSRTAction();
        CSS_SRT__C srtDiagAccess = new CSS_SRT__C();
        srtDiagAccess.Solution_Number__c = sol1.id;
        srtDiagAccess.Job_Order__c = JO.id;
        srtDiagAccess.SRT_Quantity__c =2;
        srtDiagAccess.SRT_Warrantable__c ='3';
        srtDiagAccess.SRT_AccessiblityCheck__c=True;
        srtDiagAccess.SRT_Time__c = 1.1;
        srtDiagAccess.name = 'Test';
        srtDiagAccess.Type__c = 'Repair Access';
        srtDiagAccess.SRT_ID__c = '00-11';
        insert srtDiagAccess;
        
        jobPlan.jobPlanSRTAction();
        List<css_srt__c> lstSRT = new List<css_srt__c>();
        lstSRT.add(srt);
        lstSRT.add(srt1);
        // lstSRT.add(srt2);
        lstSRT.add(srt3);
        
        CSS_Quote__c qt = new CSS_Quote__c(); 
        qt.AcceptQuote__c = true;
        qt.QuoteTotal__c = 1000;
        qt.Service_Job__c = JO.id;
        
        list<Attachment> attachmentList = new list<Attachment>();
        // Add test file for attachment            
        
        Attachment attach=new Attachment();    
        attach.Name='Unit Test Attachment';
        Blob bodyBlob1=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob1;
        attach.parentId=jo.id;
        attachmentList.add(attach);
        
        Attachment attach1=new Attachment();    
        attach1.Name='Unit Test Attachment1';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body1');
        attach1.body=bodyBlob;
        attach1.parentId=jo.id;
        
        insert attach;
        
        CSS_accountLanguage__c accntLang = new CSS_accountLanguage__c();
        accntLang.name = 'en';
        accntLang.CSS_QsolLanguage__c = 'en';
        accntLang.CSS_userLanguage__c = 'en';
        accntLang.CSS_EDSLanguage__c = 'en';
        insert(accntLang);
        
        Id recTypeIdoption = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'Options');
        Id recTypeIdpart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'Parts');
        
        CSS_Solution_Component__c comp = new CSS_Solution_Component__c();
        
        comp.Component_Id__c = 'Fooo1';
        comp.Service_Job__c = JO.Id;
        insert comp;
        
        CSS_Parts_Options__c parts = new CSS_Parts_Options__c();
        parts.recordtypeId = recTypeIdpart;
        parts.Option_Number__c = 'O-111';
        parts.Service_Job__c = Jo.Id;
        parts.selected_part__c = true;
        parts.FailurepartId__c = comp.Id;
        insert parts;
        
        /*CSS_CampTsbTrp__c x1 = new CSS_CampTsbTrp__c();
x1.Job_order__c = Jo.Id;
x1.performed_review__c = true;
x1.performed__c =false;
insert x1;*/
        
        
        jobplan.Wid = Jo.Id;
        jobplan.comm = 'sample';
        Note x2 = new Note();
        x2.Title = 'CAMPCOMMENTS';
        x2.ParentId = jobplan.Wid; 
        x2.Body =  jobplan.comm;
        insert x2;
        
        jobplan.NotesBody = 'sample';
        jobplan.show_war_pnl = true;
        jobplan.showResolution = true;
        jobplan.showRepairs = true;
        jobplan.nocamptsbtrps = true;
        jobPlan.accQuoteFlag = true;
        jobplan.showResolutionWithRepair = false;
        jobPlan.showRepairErrorMessage = true;
        jobPlan.requiredBMSMessage = true;
        //jobPlan.bmsEnabled=TRUE;
        //Attachment attach;
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Miles',system.Label.CSS_Miles));
        options.add(new SelectOption('Kilometers',system.Label.CSS_Kilometers)); 
        
        jobPlan.savecheckbox();
        jobPlan.updatestatus();
        jobPlan.closeSession();
        jobPlan.updateservjob();
        jobPlan.closeSession_close();
        jobPlan.jobClosePopup();
        jobPlan.pgsave();
        jobPlan.pgSaveFinish();
        jobplan.saveAndCloseJob();
        //   pageReference pref = jobplan.saveAndCloseJob();
        Test.stopTest();
    }
    
    static testmethod void jobPlanControllertestmethod221(){
        
        Test.startTest();
        
        CSS_JobPlanSRTController jobPlan= new CSS_JobPlanSRTController();
        jobPlan.complaintcounter=2;
        jobPlan.coveragecounter=2;
        jobPlan.causecounter=2;
        jobPlan.correctioncounter=2;
        jobPlan.timemin=2;
        jobPlan.timeminov=2;
        jobPlan.TotalOverlapHours=2;
        jobPlan.TotalAdjustedHours=2;
        jobPlan.overlapErrorMsg='Test23';
        
        CSS_JobPlanSRTController.overLapSrtWrapper OvpW=new  CSS_JobPlanSRTController.overLapSrtWrapper();
        OvpW.overide=true;
        ovpW.OverlapSRTTime =10;
        ovpw.SRT_Code ='90';
        ovpW.SRT_Description ='Test';
        ovpW.SRT_Notes ='Test';
        ovpw.SRT_Overlap =89;
        ovpw.SRT_OverrideReason ='Test';
        ovpw.SRT_Time ='19';
        ovpw.Id ='243536';
        List<CSS_JobPlanSRTController.overLapSrtWrapper> LstJP=new List<CSS_JobPlanSRTController.overLapSrtWrapper>();
        jobPlan.lstOverLapSrt=null;
        Id currentUserID=UserInfo.getUserId();
        list<user> userids = [select id,name from user limit 3];
        
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02466';
        acc.IAM_Service_Provider_Code__c='19134';
        acc.Type='Dealer Account';
        acc.CMI_Account_Status__c = 'Active';
        insert acc;
        
        //Add test data for Service job order
        CSS_Job_Order__c JO = new CSS_Job_Order__c();
        JO.Account__c = acc.id;
        JO.Customer_Name__c = 'Test';
        JO.Customer_Code__c=null;
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
        JO.Unit_Number__c = 'test123';
        Jo.Assigned_To__c = UserInfo.getUserId();
        JO.Additional_Tech1__c = userids[0].id;
        JO.Additional_Tech2__c = userids[1].id;
        Jo.esn__c='1234';
        JO.Equipment_ID__c = 'EQ7667';
        JO.Qsol_Engine_Family_Code__c ='56';
        JO.AccessCode__c = 'A';
        JO.BMSWSStatus__c = 'UI';
        JO.Unit_Number__c = '12345';
        JO.Shop_Work_Order__c='12345';
        JO.EditCoverage__c = 'Test';
        JO.EditComplaint__c = 'Test';
        JO.EditCorrection__c = 'TEST';
        JO.EditCause__c = 'TEST';
        JO.BMSStatus__c = 'UII';
        JO.chevron_page__c='srt';
        JO.CSS_Resolution__c='test';
        JO.Customer_Code__c ='8989';
        JO.Shop_Work_Order__c='Test78';
        insert(JO);      
        
        JobPlan.workJob = [Select Id,Name,AccessCode__c,Customer_Name__c,Shop_Work_Order__c, Application__c, Application_Desc__c, BMS_Last_Name__c, DSID_WorkGroup__c, Unit_Number__c, Date_in__c, INSITE_UpdateTimeStamp__c, First_Name__c,
                           Repair_Location__c,Failure_Date__c, Failure_Point__c, Failure_Point_Measure__c, Service_Model__c, VIN__c,BMSStatus__c,Unit_Type__c, Warranty_Start_Date__c,Make__c, Qsol_Engine_Family_Code__c,
                           DSID__c, DSID_Creation_Timestamp__c, DSID_Status__c, Repeat_Or_Recent_Calc__c, DSID_UpdateTimestamp__c,Customer_Code__c,Status__c,
                           Phone_Number__c, Previous_Status__c,Sub_Type__c, Category__c, Complaint_Type__c, Model__c,Creator_Location__c, Control_Number__c,
                           Assigned_to__r.Name,Additional_Tech1__r.Name,Additional_Tech2__r.Name,OwnerId,JobLocation__c,CSS_Resolution__c,CSS_Feedback_Comments__c,BMSWSStatus__c,EditCoverage__c,EditComplaint__c,
                           ESN__c, Mileage__c, Mileage_Measure__c, chevron_page__c,General_Symptoms__c, Assigned_To__c, LastModifiedDate,CreatedDate,ESN_Locked__c,Region__c,Territory__c
                           from CSS_Job_Order__c where id= :JO.id];
        
        /*PageReference p=Page.CSS_Jobplan; 
Test.setCurrentPage(p);  */
        ApexPages.currentPage().getParameters().put('id',jo.Id);         
        
        CSS_Fault_Code__c fc1 = new CSS_Fault_Code__c(FaultCodeR2__c = '441',Related_Fault_Code__c = '234,546');
        fc1.Name = '441';
        fc1.Job_Order__c = JO.Id;
        fc1.Sequence__c = 1;
        fc1.Fault_Code_Type__c = 'APD-P';
        fc1.Mod__c = '0';
        fc1.isPole__c = false;
        insert fc1;
        List<CSS_Fault_Code__c> lstFC1 = new List<CSS_Fault_Code__c>();
        lstFC1.add(fc1);
        
        CSS_Solutions__c sol1 = new CSS_Solutions__c();
        sol1.FaultCode__c = fc1.Id;
        sol1.Service_Job__c = JO.Id;
        sol1.Name = 'Sample Case Name';
        sol1.Case_Name__c = 'Sample Case Name';
        sol1.Solution_Title__c = 'Sample Title';
        sol1.Rank__c =0;
        sol1.Diagnostic_Response__c = 'Most likely the solution';
        sol1.Repair_Response__c ='';
        //sol1.Repair_Response__c='Repair Successful.';
        insert sol1;
          CSS_Solutions__c sol11 = new CSS_Solutions__c();
        sol11.FaultCode__c = fc1.Id;
        sol11.Service_Job__c = JO.Id;
        sol11.Name = 'Sample Case Name';
        sol11.Case_Name__c = 'Sample Case Name';
        sol11.Solution_Title__c = 'Sample Title';
        sol11.Rank__c =0;
        sol11.Diagnostic_Response__c = 'Most likely the solution';
        sol11.Repair_Response__c ='Repair Successful';
        //sol1.Repair_Response__c='Repair Successful.';
        insert sol11;
        
        CSS_Solution_Component__c csc=new CSS_Solution_Component__c();
        csc.Action__c='test';
        csc.Solutions__c=sol1.id;
        csc.Service_Job__c=JO.id;
        csc.Selected_Component__c = true;
        csc.Performed__c = true;
         csc.Performed_Review__c = true;
        csc.AccountCodeEdit__c='test';
        csc.Fail_Code_Editable__c='test';
        insert csc;
        
        css_srt__c srt = new css_srt__c();
        
        srt.Solution_Number__c = sol1.id;
        srt.SRT_AccessiblityCheck__c=True;
        srt.SRT_Time__c = 65;
        srt.Job_Order__c = JO.id;
        srt.isPerformed__c = true;
        srt.name = 'Test';
        srt.SRT_Type__c = 'Repair';
        srt.SRT_ID__c = '00-11';
         srt.Step_Id__c='6';
        srt.SRT_Quantity__c=2;
         srt.Override__c=true;
        // insert srt;
        
        css_srt__c srt1 = new css_srt__c();
        srt1.Solution_Number__c = sol1.id;
        srt1.SRT_AccessiblityCheck__c=True;
        srt1.SRT_Time__c = 65;
        srt1.Job_Order__c = JO.id;
        srt1.name = 'Test';
        srt1.isPerformed__c = true;
        srt1.SRT_Type__c = 'Repair';
        srt1.SRT_ID__c = '00-11';
         srt1.Step_Id__c='6';
         srt1.SRT_Quantity__c=2;
         srt1.Override__c=true;
        //insert srt1;
        
        css_srt__c srt3 = new css_srt__c();
        srt3.Solution_Number__c = sol1.id;
        srt3.SRT_AccessiblityCheck__c=True;
        srt3.SRT_Time__c = 1.1;
        srt3.Job_Order__c = JO.id;
        srt3.name = 'Test';
        // srt3.isPerformed__c = true;
        srt3.SRT_Type__c = 'Overlap';
        srt3.SRT_ID__c = '00-11';
        srt3.Step_Id__c='6';
         srt3.SRT_Quantity__c=2;
         srt3.Override__c=true;
        insert srt3;
        //siva
        CSS_SRT__C FieldAction = new CSS_SRT__C();
        FieldAction.Solution_Number__c = sol1.id;
        FieldAction.Job_Order__c = JO.id;
        FieldAction.SRT_Quantity__c =2;
        FieldAction.SRT_Warrantable__c ='3';
        FieldAction.SRT_AccessiblityCheck__c=True;
        FieldAction.SRT_Time__c = 1.1;
        FieldAction.name = 'Test';
        FieldAction.Type__c = 'Field Action';
        FieldAction.SRT_ID__c = '00-11';
        FieldAction.Step_Id__c='6';
         FieldAction.SRT_Quantity__c=2;
        FieldAction.Override__c=true;
        insert FieldAction;
        CSS_SRT__C srtoverlp = new CSS_SRT__C();
        srtoverlp.Solution_Number__c = sol1.id;
        srtoverlp.Job_Order__c = JO.id;
        srtoverlp.SRT_Quantity__c =2;
        srtoverlp.SRT_Warrantable__c ='3';
        srtoverlp.SRT_AccessiblityCheck__c=True;
        srtoverlp.SRT_Time__c = 1.1;
        srtoverlp.name = 'Test';
        srtoverlp.Type__c = 'Overlap';
        srtoverlp.SRT_ID__c = '00-11';
        srtoverlp.Step_Id__c='6';
          srtoverlp.SRT_Quantity__c=2;
        srtoverlp.Override__c=true;
        insert srtoverlp;
        jobPlan.jobPlanSRTAction();
        CSS_SRT__C srtDiagAccess = new CSS_SRT__C();
        srtDiagAccess.Solution_Number__c = sol1.id;
        srtDiagAccess.Job_Order__c = JO.id;
        srtDiagAccess.SRT_Quantity__c =2;
        srtDiagAccess.SRT_Warrantable__c ='3';
        srtDiagAccess.SRT_AccessiblityCheck__c=True;
        srtDiagAccess.SRT_Time__c = 1.1;
        srtDiagAccess.name = 'Test';
        srtDiagAccess.Type__c = 'Repair Access';
        srtDiagAccess.SRT_ID__c = '00-11';
        srtDiagAccess.Step_Id__c='6';
        srtDiagAccess.SRT_Quantity__c=2;
        srtDiagAccess.Override__c=true;
        insert srtDiagAccess;
        
        jobPlan.jobPlanSRTAction();
        List<css_srt__c> lstSRT = new List<css_srt__c>();
        lstSRT.add(srt);
        lstSRT.add(srt1);
        // lstSRT.add(srt2);
        lstSRT.add(srt3);
        
        CSS_Quote__c qt = new CSS_Quote__c(); 
        qt.AcceptQuote__c = true;
        qt.QuoteTotal__c = 1000;
        qt.Service_Job__c = JO.id;
        
        list<Attachment> attachmentList = new list<Attachment>();
        // Add test file for attachment            
        
        Attachment attach=new Attachment();    
        attach.Name='Unit Test Attachment';
        Blob bodyBlob1=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob1;
        attach.parentId=jo.id;
        attachmentList.add(attach);
        
        Attachment attach1=new Attachment();    
        attach1.Name='Unit Test Attachment1';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body1');
        attach1.body=bodyBlob;
        attach1.parentId=jo.id;
        
        insert attach;
        
        CSS_accountLanguage__c accntLang = new CSS_accountLanguage__c();
        accntLang.name = 'en';
        accntLang.CSS_QsolLanguage__c = 'en';
        accntLang.CSS_userLanguage__c = 'en';
        accntLang.CSS_EDSLanguage__c = 'en';
        insert(accntLang);
        
        Id recTypeIdoption = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'Options');
        Id recTypeIdpart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'Parts');
        
        CSS_Solution_Component__c comp = new CSS_Solution_Component__c();
        
        comp.Component_Id__c = 'Fooo1';
        comp.Service_Job__c = JO.Id;
        
        insert comp;
        
        CSS_Parts_Options__c parts = new CSS_Parts_Options__c();
        parts.recordtypeId = recTypeIdpart;
        parts.Option_Number__c = 'O-111';
        parts.Service_Job__c = Jo.Id;
        parts.selected_part__c = true;
        parts.FailurepartId__c = comp.Id;
        insert parts;
        
        /*CSS_CampTsbTrp__c x1 = new CSS_CampTsbTrp__c();
x1.Job_order__c = Jo.Id;
x1.performed_review__c = true;
x1.performed__c =false;
insert x1;*/
        
        
        jobplan.Wid = Jo.Id;
        jobplan.comm = 'sample';
        Note x2 = new Note();
        x2.Title = 'CAMPCOMMENTS';
        x2.ParentId = jobplan.Wid; 
        x2.Body =  jobplan.comm;
        insert x2;
        

        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Miles',system.Label.CSS_Miles));
        options.add(new SelectOption('Kilometers',system.Label.CSS_Kilometers)); 
        
       
        
        
        jobplan.BMSSuccessWOQTMsg='';
        //   pageReference pref = jobplan.saveAndCloseJob();
        Test.stopTest();
    }
    static testmethod void jobPlanControllertestmethod22(){
        
        
        
        CSS_JobPlanSRTController jobPlan= new CSS_JobPlanSRTController();
        jobPlan.complaintcounter=2;
        jobPlan.coveragecounter=2;
        jobPlan.causecounter=2;
        jobPlan.correctioncounter=2;
        jobPlan.timemin=2;
        jobPlan.timeminov=2;
        jobPlan.TotalOverlapHours=2;
        jobPlan.TotalAdjustedHours=2;
        jobPlan.overlapErrorMsg='Test23';
        
        CSS_JobPlanSRTController.overLapSrtWrapper OvpW=new  CSS_JobPlanSRTController.overLapSrtWrapper();
        OvpW.overide=true;
        ovpW.OverlapSRTTime =10;
        ovpw.SRT_Code ='90';
        ovpW.SRT_Description ='Test';
        ovpW.SRT_Notes ='Test';
        ovpw.SRT_Overlap =89;
        ovpw.SRT_OverrideReason ='Test';
        ovpw.SRT_Time ='19';
        ovpw.Id ='243536';
        List<CSS_JobPlanSRTController.overLapSrtWrapper> LstJP=new List<CSS_JobPlanSRTController.overLapSrtWrapper>();
        jobPlan.lstOverLapSrt=null;
        Id currentUserID=UserInfo.getUserId();
        list<user> userids = [select id,name from user limit 3];
        
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02466';
        acc.IAM_Service_Provider_Code__c='19134';
        acc.Type='Dealer Account';
        acc.CMI_Account_Status__c = 'Active';
        insert acc;
        
        //Add test data for Service job order
        CSS_Job_Order__c JO = new CSS_Job_Order__c();
        JO.Account__c = acc.id;
        JO.Customer_Name__c = 'Test';
        JO.Customer_Code__c=null;
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
        JO.Unit_Number__c = 'test123';
        Jo.Assigned_To__c = UserInfo.getUserId();
        JO.Additional_Tech1__c = userids[0].id;
        JO.Additional_Tech2__c = userids[1].id;
        Jo.esn__c='1234';
        JO.Equipment_ID__c = 'EQ7667';
        JO.Qsol_Engine_Family_Code__c ='56';
        JO.AccessCode__c = 'A';
        JO.BMSWSStatus__c = 'UI';
        JO.Unit_Number__c = '12345';
        JO.Shop_Work_Order__c='12345';
        JO.EditCoverage__c = 'Test';
        JO.EditComplaint__c = 'Test';
        JO.EditCorrection__c = 'TEST';
        JO.EditCause__c = 'TEST';
        JO.BMSStatus__c = 'UII';
        JO.chevron_page__c='srt';
        JO.CSS_Resolution__c='test';
        JO.Customer_Code__c ='8989';
        JO.Shop_Work_Order__c='Test78';
        insert(JO);      
        
        JobPlan.workJob = [Select Id,Name,AccessCode__c,Customer_Name__c,Shop_Work_Order__c, Application__c, Application_Desc__c, BMS_Last_Name__c, DSID_WorkGroup__c, Unit_Number__c, Date_in__c, INSITE_UpdateTimeStamp__c, First_Name__c,
                           Repair_Location__c,Failure_Date__c, Failure_Point__c, Failure_Point_Measure__c, Service_Model__c, VIN__c,BMSStatus__c,Unit_Type__c, Warranty_Start_Date__c,Make__c, Qsol_Engine_Family_Code__c,
                           DSID__c, DSID_Creation_Timestamp__c, DSID_Status__c, Repeat_Or_Recent_Calc__c, DSID_UpdateTimestamp__c,Customer_Code__c,Status__c,
                           Phone_Number__c, Previous_Status__c,Sub_Type__c, Category__c, Complaint_Type__c, Model__c,Creator_Location__c, Control_Number__c,
                           Assigned_to__r.Name,Additional_Tech1__r.Name,Additional_Tech2__r.Name,OwnerId,JobLocation__c,CSS_Resolution__c,CSS_Feedback_Comments__c,BMSWSStatus__c,EditCoverage__c,EditComplaint__c,
                           ESN__c, Mileage__c, Mileage_Measure__c, chevron_page__c,General_Symptoms__c, Assigned_To__c, LastModifiedDate,CreatedDate,ESN_Locked__c,Region__c,Territory__c
                           from CSS_Job_Order__c where id= :JO.id];
        
        /*PageReference p=Page.CSS_Jobplan; 
Test.setCurrentPage(p);  */
        ApexPages.currentPage().getParameters().put('id',jo.Id);         
        
        CSS_Fault_Code__c fc1 = new CSS_Fault_Code__c(FaultCodeR2__c = '441',Related_Fault_Code__c = '234,546');
        fc1.Name = '441';
        fc1.Job_Order__c = JO.Id;
        fc1.Sequence__c = 1;
        fc1.Fault_Code_Type__c = 'APD-P';
        fc1.Mod__c = '0';
        fc1.isPole__c = false;
        insert fc1;
        List<CSS_Fault_Code__c> lstFC1 = new List<CSS_Fault_Code__c>();
        lstFC1.add(fc1);
        
        CSS_Solutions__c sol1 = new CSS_Solutions__c();
        sol1.FaultCode__c = fc1.Id;
        sol1.Service_Job__c = JO.Id;
        sol1.Name = 'Sample Case Name';
        sol1.Case_Name__c = 'Sample Case Name';
        sol1.Solution_Title__c = 'Sample Title';
        sol1.Rank__c =0;
        sol1.Diagnostic_Response__c = 'Most likely the solution';
        sol1.Repair_Response__c ='';
        //sol1.Repair_Response__c='Repair Successful.';
        insert sol1;
          CSS_Solutions__c sol11 = new CSS_Solutions__c();
        sol11.FaultCode__c = fc1.Id;
        sol11.Service_Job__c = JO.Id;
        sol11.Name = 'Sample Case Name';
        sol11.Case_Name__c = 'Sample Case Name';
        sol11.Solution_Title__c = 'Sample Title';
        sol11.Rank__c =0;
        sol11.Diagnostic_Response__c = 'Most likely the solution';
        sol11.Repair_Response__c ='Repair Successful';
        //sol1.Repair_Response__c='Repair Successful.';
        insert sol11;
        
        CSS_Solution_Component__c csc=new CSS_Solution_Component__c();
        csc.Action__c='test';
        csc.Solutions__c=sol1.id;
        csc.Service_Job__c=JO.id;
        csc.Selected_Component__c = true;
        csc.Performed__c = true;
        csc.Performed_Review__c = true;
        csc.AccountCodeEdit__c='test';
        csc.Fail_Code_Editable__c='test';
        insert csc;
        
        css_srt__c srt = new css_srt__c();
        
        srt.Solution_Number__c = sol1.id;
        srt.SRT_AccessiblityCheck__c=True;
        srt.SRT_Time__c = 65;
        srt.Job_Order__c = JO.id;
        srt.isPerformed__c = true;
        srt.name = 'Test';
        srt.SRT_Type__c = 'Repair';
        srt.SRT_ID__c = '00-11';
        // insert srt;
        
        css_srt__c srt1 = new css_srt__c();
        srt1.Solution_Number__c = sol1.id;
        srt1.SRT_AccessiblityCheck__c=True;
        srt1.SRT_Time__c = 65;
        srt1.Job_Order__c = JO.id;
        srt1.name = 'Test';
        srt1.isPerformed__c = true;
        srt1.SRT_Type__c = 'Repair';
        srt1.SRT_ID__c = '00-11';
        //insert srt1;
        
        css_srt__c srt3 = new css_srt__c();
        srt3.Solution_Number__c = sol1.id;
        srt3.SRT_AccessiblityCheck__c=True;
        srt3.SRT_Time__c = 1.1;
        srt3.Job_Order__c = JO.id;
        srt3.name = 'Test';
        // srt3.isPerformed__c = true;
        srt3.SRT_Type__c = 'Overlap';
        srt3.SRT_ID__c = '00-11';
        insert srt3;
        //siva
        CSS_SRT__C FieldAction = new CSS_SRT__C();
        FieldAction.Solution_Number__c = sol1.id;
        FieldAction.Job_Order__c = JO.id;
        FieldAction.SRT_Quantity__c =2;
        FieldAction.SRT_Warrantable__c ='3';
        FieldAction.SRT_AccessiblityCheck__c=True;
        FieldAction.SRT_Time__c = 1.1;
        FieldAction.name = 'Test';
        FieldAction.Type__c = 'Field Action';
        FieldAction.SRT_ID__c = '00-11';
        insert FieldAction;
        CSS_SRT__C srtoverlp = new CSS_SRT__C();
        srtoverlp.Solution_Number__c = sol1.id;
        srtoverlp.Job_Order__c = JO.id;
        srtoverlp.SRT_Quantity__c =2;
        srtoverlp.SRT_Warrantable__c ='3';
        srtoverlp.SRT_AccessiblityCheck__c=True;
        srtoverlp.SRT_Time__c = 1.1;
        srtoverlp.name = 'Test';
        srtoverlp.Type__c = 'Overlap';
        srtoverlp.SRT_ID__c = '00-11';
        insert srtoverlp;
        //jobPlan.jobPlanSRTAction();
        CSS_SRT__C srtDiagAccess = new CSS_SRT__C();
        srtDiagAccess.Solution_Number__c = sol1.id;
        srtDiagAccess.Job_Order__c = JO.id;
        srtDiagAccess.SRT_Quantity__c =2;
        srtDiagAccess.SRT_Warrantable__c ='3';
        srtDiagAccess.SRT_AccessiblityCheck__c=True;
        srtDiagAccess.SRT_Time__c = 1.1;
        srtDiagAccess.name = 'Test';
        srtDiagAccess.Type__c = 'Repair Access';
        srtDiagAccess.SRT_ID__c = '00-11';
        insert srtDiagAccess;
        
        
        List<css_srt__c> lstSRT = new List<css_srt__c>();
        lstSRT.add(srt);
        lstSRT.add(srt1);
        // lstSRT.add(srt2);
        lstSRT.add(srt3);
        
        CSS_Quote__c qt = new CSS_Quote__c(); 
        qt.AcceptQuote__c = true;
        qt.QuoteTotal__c = 1000;
        qt.Service_Job__c = JO.id;
        
        list<Attachment> attachmentList = new list<Attachment>();
        // Add test file for attachment            
        
        Attachment attach=new Attachment();    
        attach.Name='Unit Test Attachment';
        Blob bodyBlob1=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob1;
        attach.parentId=jo.id;
        attachmentList.add(attach);
        
        Attachment attach1=new Attachment();    
        attach1.Name='Unit Test Attachment1';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body1');
        attach1.body=bodyBlob;
        attach1.parentId=jo.id;
        
        insert attach;
        
        CSS_accountLanguage__c accntLang = new CSS_accountLanguage__c();
        accntLang.name = 'en';
        accntLang.CSS_QsolLanguage__c = 'en';
        accntLang.CSS_userLanguage__c = 'en';
        accntLang.CSS_EDSLanguage__c = 'en';
        insert(accntLang);
        
        Id recTypeIdoption = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'Options');
        Id recTypeIdpart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'Parts');
        
        CSS_Solution_Component__c comp = new CSS_Solution_Component__c();
        
        comp.Component_Id__c = 'Fooo1';
        comp.Service_Job__c = JO.Id;
        insert comp;
        
        CSS_Parts_Options__c parts = new CSS_Parts_Options__c();
        parts.recordtypeId = recTypeIdpart;
        parts.Option_Number__c = 'O-111';
        parts.Service_Job__c = Jo.Id;
        parts.selected_part__c = true;
        parts.FailurepartId__c = comp.Id;
        insert parts;
        
        /*CSS_CampTsbTrp__c x1 = new CSS_CampTsbTrp__c();
x1.Job_order__c = Jo.Id;
x1.performed_review__c = true;
x1.performed__c =false;
insert x1;*/
        
        
        jobplan.Wid = Jo.Id;
        jobplan.comm = 'sample';
        Note x2 = new Note();
        x2.Title = 'CAMPCOMMENTS';
        x2.ParentId = jobplan.Wid; 
        x2.Body =  jobplan.comm;
        insert x2;
        
        jobplan.NotesBody = 'sample';
        jobplan.show_war_pnl = true;
        jobplan.showResolution = true;
        jobplan.showRepairs = true;
        jobplan.nocamptsbtrps = true;
        jobPlan.accQuoteFlag = true;
        jobplan.showResolutionWithRepair = false;
        jobPlan.showRepairErrorMessage = true;
        jobPlan.requiredBMSMessage = true;
        //jobPlan.bmsEnabled=TRUE;
        //Attachment attach;
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Miles',system.Label.CSS_Miles));
        options.add(new SelectOption('Kilometers',system.Label.CSS_Kilometers)); 
        Test.startTest();
        jobPlan.jobPlanSRTAction();
        jobPlan.savecheckbox();
        jobPlan.updatestatus();
        jobPlan.closeSession();
        jobPlan.updateservjob();
        jobPlan.closeSession_close();
        jobPlan.jobClosePopup();
        jobplan.saveAndCloseJob();
        jobPlan.pgsave();
        jobPlan.pgSaveFinish();
        
        
        jobplan.BMSSuccessWOQTMsg='';
        //   pageReference pref = jobplan.saveAndCloseJob();
        Test.stopTest();
    }
    static testmethod void  closeSession(){
        Test.startTest();
        
        Id currentUserID=UserInfo.getUserId();
        list<user> userids = [select id,name from user limit 3]; 
        
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02466';
        acc.IAM_Service_Provider_Code__c='19134';
        acc.Type='Dealer Account';
        acc.CMI_Account_Status__c = 'Active';
        insert acc;
        
        //Add test data for Service job order
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
        JO.Unit_Number__c = 'test123';
        Jo.Assigned_To__c = UserInfo.getUserId();
        JO.Additional_Tech1__c = userids[0].id;
        JO.Additional_Tech2__c = userids[1].id;
        Jo.esn__c='1234';
        JO.Equipment_ID__c = 'EQ7667';
        JO.Qsol_Engine_Family_Code__c ='56';
        JO.AccessCode__c = 'A';
        JO.BMSWSStatus__c = 'UI';
        JO.BMSStatus__c = 'IUU';
        JO.Account__c = acc.id;
        insert(JO);      
        PageReference pref;
        pref = new PageReference('/'+JO.id);
        pref.getParameters().put('id',JO.id);
        
        Test.setCurrentPage(pref);
        
        CSS_JobPlanSRTController jobPlan= new CSS_JobPlanSRTController();
        
        
        CSS_Job_Order__c jobOrder = new CSS_Job_Order__c();
        jobOrder.Status__c = 'Created/Not Assigned';
        insert jobOrder;
        
        CSS_Fault_Code__c fc1 = new CSS_Fault_Code__c(FaultCodeR2__c = '441',Related_Fault_Code__c = '234,546');
        fc1.Name = '441';
        fc1.Job_Order__c = jobOrder.Id;
        fc1.Sequence__c = 1; 
        fc1.Fault_Code_Type__c = 'APD-P';
        fc1.Mod__c = '0';
        fc1.isPole__c = false;
        insert fc1;
        List<CSS_Fault_Code__c> lstFC = new List<CSS_Fault_Code__c>();
        lstFC.add(fc1);
        
        CSS_Solutions__c sol1 = new CSS_Solutions__c();
        sol1.FaultCode__c = fc1.Id;
        sol1.Service_Job__c = jobOrder.Id;
        sol1.Name = 'Sample Case Name';
        sol1.Case_Name__c = 'Sample Case Name';
        sol1.Solution_Title__c = 'Sample Title';
        sol1.Rank__c =0;
        insert sol1; 
        
        CSS_SRT__C srtoverlp = new CSS_SRT__C();
        srtoverlp.Solution_Number__c = sol1.id;
        srtoverlp.Job_Order__c = JO.id;
        srtoverlp.SRT_Quantity__c =2;
        srtoverlp.SRT_Warrantable__c ='3';
        srtoverlp.SRT_AccessiblityCheck__c=True;
        srtoverlp.SRT_Time__c = 1.1;
        srtoverlp.name = 'Test';
        srtoverlp.Type__c = 'Overlap';
        srtoverlp.SRT_ID__c = '00-11';
        insert srtoverlp;
        //siva
        CSS_SRT__C srtDiagAccess = new CSS_SRT__C();
        srtDiagAccess.Solution_Number__c = sol1.id;
        srtDiagAccess.Job_Order__c = JO.id;
        srtDiagAccess.SRT_Quantity__c =2;
        srtDiagAccess.SRT_Warrantable__c ='3';
        srtDiagAccess.SRT_AccessiblityCheck__c=True;
        srtDiagAccess.SRT_Time__c = 1.1;
        srtDiagAccess.name = 'Test';
        srtDiagAccess.Type__c = 'Repair Access';
        srtDiagAccess.SRT_ID__c = '00-11';
        insert srtDiagAccess;
        jobPlan.jobPlanSRTAction();
        
        list<CSS_Solutions__c> solListSol = new list<CSS_Solutions__c>();
        CSS_Solutions__c cssSol ;
        cssSol = new CSS_Solutions__c();
        cssSol.Name = 'Test Solution';
        cssSol.service_job__c = JO.id;
        cssSol.Out_Of_Order__c = true;
        cssSol.Diagnostic_Response__c = 'Most likely the solution';
        //cssSol.Repair_Response__c= 'Repair Successful.';
        solListSol.add(cssSol);
        CSS_Solutions__c cssSol2 ;
        cssSol2 = new CSS_Solutions__c();
        cssSol2.Name = 'Test Solution1';
        cssSol2.service_job__c = JO.id;
        cssSol2.Out_Of_Order__c = true;
        cssSol2.Diagnostic_Response__c = 'Most likely the solution';
        
        solListSol.add(cssSol2);
        insert solListSol;
        
        CSS_Solution_Component__c csc=new CSS_Solution_Component__c();
        csc.Action__c='test';
        csc.Solutions__c=sol1.id;
        csc.Service_Job__c=jobOrder.id;
        insert csc;
        
        
        
        jobplan.dsidStatus = true;
        jobPlan.showJobPlanBlocks(true,false,true, false,false,false,false);
        
        CSS_CampTsbTrp__c x1 = new CSS_CampTsbTrp__c();
        x1.Job_order__c = Jo.Id;
        x1.performed_review__c = true;
        x1.performed__c =false;
        insert x1;
        
        jobPlan.closeSession();
        
        Test.stopTest();
    } 
    
    static testmethod void  closeSession1(){
        Test.startTest();
        
        Id currentUserID=UserInfo.getUserId();
        list<user> userids = [select id,name from user limit 3]; 
        
        //Add test data for Service job order
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
        JO.Unit_Number__c = 'test123';
        Jo.Assigned_To__c = UserInfo.getUserId();
        JO.Additional_Tech1__c = userids[0].id;
        JO.Additional_Tech2__c = userids[1].id;
        Jo.esn__c='1234';
        JO.Equipment_ID__c = 'EQ7667';
        JO.Qsol_Engine_Family_Code__c ='56';
        JO.AccessCode__c = 'A';
        JO.BMSWSStatus__c = 'UI';
        JO.BMSStatus__c = 'IUU';
        insert(JO);      
        PageReference pref;
        pref = new PageReference('/'+JO.id);
        pref.getParameters().put('id',JO.id);
        
        Test.setCurrentPage(pref);
        
        CSS_JobPlanSRTController jobPlan= new CSS_JobPlanSRTController();
        
        
        CSS_Job_Order__c jobOrder = new CSS_Job_Order__c();
        jobOrder.Status__c = 'Created/Not Assigned';
        insert jobOrder;
        
        CSS_Fault_Code__c fc1 = new CSS_Fault_Code__c(FaultCodeR2__c = '441',Related_Fault_Code__c = '234,546');
        fc1.Name = '441';
        fc1.Job_Order__c = jobOrder.Id;
        fc1.Sequence__c = 1; 
        fc1.Fault_Code_Type__c = 'APD-P';
        fc1.Mod__c = '0';
        fc1.isPole__c = false;
        insert fc1;
        List<CSS_Fault_Code__c> lstFC = new List<CSS_Fault_Code__c>();
        lstFC.add(fc1);
        
        
        
        jobplan.dsidStatus = true;
        jobPlan.showJobPlanBlocks(true,false,true, false,false,false,false);
        jobplan.bmsUserCloseFlag =false;
        jobplan.displaycancelModPopup=false;
        jobPlan.showcancelpopup();
        jobPlan.cancelModPopup();
        //jobPlan.bmsEnabled=TRUE;
        jobPlan.countquote=0;
        jobPlan.closeSession();
        
        Test.stopTest();
    } 
    
    static testmethod void  ChkFieldBlank(){
        Test.startTest();
        
        Id currentUserID=UserInfo.getUserId();
        list<user> userids = [select id,name from user limit 3]; 
        
        //Add test data for Service job order
        CSS_Job_Order__c JO = new CSS_Job_Order__c();  
        JO.Customer_Name__c =  null;
        JO.Shop_Work_Order__c= null;
        JO.Application_Desc__c=null;
        JO.Unit_number__c=null;
        JO.Mileage__c=null;
        JO.ESN__c=null;
        JO.General_Symptoms__c=null;
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
        //JO.Unit_Number__c = 'test123';
        Jo.Assigned_To__c = UserInfo.getUserId();
        JO.Additional_Tech1__c = userids[0].id;
        JO.Additional_Tech2__c = userids[1].id;
        //Jo.esn__c='1234';
        JO.Equipment_ID__c = 'EQ7667';
        JO.Qsol_Engine_Family_Code__c ='56';
        JO.AccessCode__c = 'A';
        JO.BMSWSStatus__c = 'UI';
        JO.BMSStatus__c = 'IUU';
        insert(JO);      
        PageReference pref;
        pref = new PageReference('/'+JO.id);
        pref.getParameters().put('id',JO.id);
        
        Test.setCurrentPage(pref);
        
        CSS_JobPlanSRTController jobPlan= new CSS_JobPlanSRTController();
        JobPlan.workJob = [Select Id,Name,AccessCode__c,Customer_Name__c,Shop_Work_Order__c, Application__c, Application_Desc__c, BMS_Last_Name__c, DSID_WorkGroup__c, Unit_Number__c, Date_in__c, INSITE_UpdateTimeStamp__c, First_Name__c,
                           Repair_Location__c,Failure_Date__c, Failure_Point__c, Failure_Point_Measure__c, Service_Model__c,BMSStatus__c,Unit_Type__c, VIN__c, Warranty_Start_Date__c,Make__c, Qsol_Engine_Family_Code__c,
                           DSID__c, DSID_Creation_Timestamp__c, DSID_Status__c, Repeat_Or_Recent_Calc__c, DSID_UpdateTimestamp__c,Customer_Code__c,Status__c,
                           Phone_Number__c, Previous_Status__c,Sub_Type__c, Category__c, Complaint_Type__c, Model__c,Creator_Location__c, Control_Number__c,
                           Assigned_to__r.Name,Additional_Tech1__r.Name,Additional_Tech2__r.Name,OwnerId,JobLocation__c,CSS_Resolution__c,CSS_Feedback_Comments__c, BMSWSStatus__c,
                           ESN__c, Mileage__c, Mileage_Measure__c, chevron_page__c, General_Symptoms__c, Assigned_To__c, LastModifiedDate,CreatedDate,ESN_Locked__c,Region__c,Territory__c
                           from CSS_Job_Order__c where id= :JO.id];
        
        
        jobPlan.ChkFieldBlank();
        jobPlan.jobplan_prt();
        jobPlan.jobplan_war();
        jobPlan.jobplan_jpq();
        pref = jobPlan.jobplan_jo();
        
        jobPlan.jobplan_srt();
        jobPlan.pgSave();
        jobPlan.Cancel();
        
        Test.stopTest();
    } 
    
    static testmethod void testSRTjobplancon(){
        
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02466';
        acc.IAM_Service_Provider_Code__c='19134';
        acc.Type='Dealer Account';
        acc.CMI_Account_Status__c = 'Active';
        insert acc;
        
        css_job_order__c jo = new css_job_order__c();
        jo.ESN__c='58675876';
        jo.Customer_Name__c='TestUser';
        jo.Customer_Code__c='123';
        jo.Status__c='Job Plan';
        jo.CSS_Job_Location_Code__c ='56255-56255';
        jo.Account__c = acc.id;
        insert jo;
        
        Account a = new account();
        a.name='Testing';
        a.BMS_Enabled__c=true;
        a.IAM_Service_Provider_Code__c='56255';
        a.CSS_DistributorCode__c='56255';
        insert a;
        
        CSS_UserLocation__c userloc = new CSS_UserLocation__c();
        
        userloc.Location_code__c='56255-56255';
        insert userloc;
        css_solutions__c sol2 = new css_solutions__c();
        sol2.Service_Job__c=jo.Id;
        sol2.Diagnostic_Response__c='Most likely the solution';
        insert sol2;
        
        css_srt__c srt = new css_srt__c();
        srt.CSS_Claims__c=null;
        srt.Job_Order__c=jo.Id;
        srt.Step_Id__c='1';
        srt.SRT_ID__c='00-901-00';
        SRT.SRT_Title__c='Non-SRT detail';
        srt.Type__c='Overlap';
        srt.SRT_AccessiblityCheck__c=true;
        srt.SRT_Estimate__c=false;
        srt.SRT_Category__c='AdditionalDiag';
        
        
        insert srt;
        //siva
        css_job_order__c jo1=[select id,name,(select id,Step_Id__c,Job_Order__c,SRT_ID__c,SRT_Title__c,Type__c from CSS_SRTS__r) from css_job_order__c];
        apexpages.currentPage().getparameters().put('id',jo.Id);
        apexpages.currentPage().getparameters().put('status','Job Plan');
        string json='{ "Header": { "ReturnCodeDescription": "<Message from SRT>", "ReturnCode": "<MessageCode from SRT>", "MessageIdentifier": "Identifier from MW" }, "DataArea": { "TotalOverlapHours": 5.5, "TotalAdjustedHours": 0.5, "OverlapSRTTime": [ { "SRTNumber": "11", "OverlapHrs": 1, "SRTTitle": "SRTTitle", "OverlapStepId": 5, "OverlapSRTNumber": "0.5", "StepId": 1, "OverlapSRTTitle": "1.5" } ], "Steps": [ { "TotalOverlapHours": [ { "SRTNumber": "11-111-11", "OverlapHrs": 1.5 }, { "SRTNumber": "12-121-12", "OverlapHrs": 3 } ], "StepId": 1, "SRTHours": 2.5, "SRTAdjustedHours": 0.5, "Qty": 2, "AccessCode": "R" } ] } }';
        CSS_OverlapSRTResponse bc = CSS_OverlapSRTResponse.parse(json);
        system.debug('BC>>'+bc);
        
        test.startTest();
        CSS_JobPlanSRTController jobcon = new CSS_JobPlanSRTController();
        jobcon.populateMap(jo1);
        // jobcon.createOverLapSrtList(bc);
        
        test.stopTest();
    }
    
    static testmethod void testSRTjobplancon1(){
        
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02466';
        acc.IAM_Service_Provider_Code__c='19134';
        acc.Type='Dealer Account';
        acc.CMI_Account_Status__c = 'Active';
        insert acc;
        
        css_job_order__c jo = CSS_TestData.createJobOrder(false);
        jo.ESN__c='58675876';
        jo.Customer_Name__c='TestUser';
        jo.Customer_Code__c='123';
        jo.Status__c='Job Plan';
        jo.CSS_Job_Location_Code__c ='56255-56255';
        jo.Shop_Work_Order__c='123';
        jo.Account__c = acc.id;
        insert jo;
        
        Account a = new account();
        a.name='Testing';
        a.BMS_Enabled__c=true;
        a.IAM_Service_Provider_Code__c='56255';
        a.CSS_DistributorCode__c='56255';
        insert a;
        
        CSS_UserLocation__c userloc = new CSS_UserLocation__c();
        
        userloc.Location_code__c='56255-56255';
        insert userloc;
        css_solutions__c sol2 = new css_solutions__c();
        sol2.Service_Job__c=jo.Id;
        sol2.Diagnostic_Response__c='Most likely the solution';
        insert sol2;
        
        css_srt__c srt = new css_srt__c();
        srt.CSS_Claims__c=null;
        srt.Job_Order__c=jo.Id;
        srt.Step_Id__c='1';
        srt.SRT_ID__c='00-901-00';
        SRT.SRT_Title__c='Non-SRT detail';
        srt.Type__c='Field Action';
        srt.SRT_AccessiblityCheck__c=true;
        srt.SRT_Estimate__c=false;
        srt.SRT_Category__c='AdditionalDiag';
        srt.Solution_Number__c=sol2.id;
        
        insert srt;
        //siva
        css_job_order__c jo1=[select id,name,(select id,Step_Id__c,Job_Order__c,SRT_ID__c,SRT_Title__c,Type__c from CSS_SRTS__r) from css_job_order__c];
        apexpages.currentPage().getparameters().put('id',jo.Id);
        apexpages.currentPage().getparameters().put('status','Job Plan');
        string json='{ "Header": { "ReturnCodeDescription": "<Message from SRT>", "ReturnCode": "<MessageCode from SRT>", "MessageIdentifier": "Identifier from MW" }, "DataArea": { "TotalOverlapHours": 5.5, "TotalAdjustedHours": 0.5, "OverlapSRTTime": [ { "SRTNumber": "11", "OverlapHrs": 1, "SRTTitle": "SRTTitle", "OverlapStepId": 5, "OverlapSRTNumber": "0.5", "StepId": 1, "OverlapSRTTitle": "1.5" } ], "Steps": [ { "TotalOverlapHours": [ { "SRTNumber": "11-111-11", "OverlapHrs": 1.5 }, { "SRTNumber": "12-121-12", "OverlapHrs": 3 } ], "StepId": 1, "SRTHours": 2.5, "SRTAdjustedHours": 0.5, "Qty": 2, "AccessCode": "R" } ] } }';
        CSS_OverlapSRTResponse bc = CSS_OverlapSRTResponse.parse(json);
        system.debug('BC>>'+bc);
        
        test.startTest();
        CSS_JobPlanSRTController jobcon = new CSS_JobPlanSRTController();
        jobcon.sendSRTsToBMS('WO','123'); 
        jobcon.sendSRTsToBMSWOQT('WOQT');
        test.stopTest();
    }
    
    static testmethod void testSRTjobplancon2(){
        
        Account a = new account();
        a.name='Testing';
        a.BMS_Enabled__c=true;
        a.IAM_Service_Provider_Code__c='56255';
        a.CSS_DistributorCode__c='56255';
        a.IAM_Service_Provider_Code__c = '56255';
        a.Type = 'Customer';
        a.IAM_Service_Provider_Code__c = '56270';
        a.CMI_Account_Status__c = 'Active';
        insert a;
        
        css_job_order__c jo = CSS_TestData.createJobOrder(false);
        jo.ESN__c='58675876';
        jo.Customer_Name__c='TestUser';
        jo.Customer_Code__c='123';
        jo.Status__c='Job Plan';
        //jo.CSS_Job_Location_Code__c ='56255-56255';
        jo.Account__c = a.id;
        jo.Shop_Work_Order__c='123';
        
        insert jo;
        
        
        
        CSS_UserLocation__c userloc = new CSS_UserLocation__c();
        
        userloc.Location_code__c='56255-56255';
        insert userloc;
        css_solutions__c sol2 = new css_solutions__c();
        sol2.Service_Job__c=jo.Id;
        sol2.Diagnostic_Response__c='Most likely the solution';
        insert sol2;
        
        css_srt__c srt = new css_srt__c();
        srt.CSS_Claims__c=null;
        srt.Job_Order__c=jo.Id;
        srt.Step_Id__c='1';
        srt.SRT_ID__c='00-901-00';
        SRT.SRT_Title__c='Non-SRT detail';
        srt.Type__c='Field Action';
        srt.SRT_AccessiblityCheck__c=true;
        srt.SRT_Estimate__c=false;
        srt.SRT_Category__c='AdditionalDiag';
        srt.Solution_Number__c=sol2.id;
        
        insert srt;
        //siva
        css_job_order__c jo1=[select id,name,(select id,Step_Id__c,Job_Order__c,SRT_ID__c,SRT_Title__c,Type__c from CSS_SRTS__r) from css_job_order__c];
        apexpages.currentPage().getparameters().put('id',jo.Id);
        apexpages.currentPage().getparameters().put('status','Job Plan');
        string json='{ "Header": { "ReturnCodeDescription": "<Message from SRT>", "ReturnCode": "<MessageCode from SRT>", "MessageIdentifier": "Identifier from MW" }, "DataArea": { "TotalOverlapHours": 5.5, "TotalAdjustedHours": 0.5, "OverlapSRTTime": [ { "SRTNumber": "11", "OverlapHrs": 1, "SRTTitle": "SRTTitle", "OverlapStepId": 5, "OverlapSRTNumber": "0.5", "StepId": 1, "OverlapSRTTitle": "1.5" } ], "Steps": [ { "TotalOverlapHours": [ { "SRTNumber": "11-111-11", "OverlapHrs": 1.5 }, { "SRTNumber": "12-121-12", "OverlapHrs": 3 } ], "StepId": 1, "SRTHours": 2.5, "SRTAdjustedHours": 0.5, "Qty": 2, "AccessCode": "R" } ] } }';
        CSS_OverlapSRTResponse bc = CSS_OverlapSRTResponse.parse(json);
        system.debug('BC>>'+bc);
        
        test.startTest();
        CSS_JobPlanSRTController jobcon = new CSS_JobPlanSRTController();
        jobcon.sendSRTsToBMS('WO','123'); 
        jobcon.sendSRTsToBMSWOQT('WOQT');
        jobcon.sendSRTsToBMS('WO',null);
        jobcon.sendSRTsToBMSWOQT('null');
        jobcon.workJob=null;
        jobcon.sendSRTsToBMS('WO','123');     
        jobcon.sendSRTsToBMSWOQT('WOQT');
        test.stopTest();
    }
    
    static testmethod void testSRTjobplancon222(){
        
        Account a = new account();
        a.name='Testing';
        a.BMS_Enabled__c=true;
        a.IAM_Service_Provider_Code__c='56255';
        a.CSS_DistributorCode__c='56255';
        a.IAM_Service_Provider_Code__c = '56255';
        a.Type = 'Customer';
        a.IAM_Service_Provider_Code__c = '56270';
        a.CMI_Account_Status__c = 'Active';
        insert a;
        
        css_job_order__c jo = CSS_TestData.createJobOrder(false);
        jo.ESN__c='58675876';
        jo.Customer_Name__c='TestUser';
        jo.Customer_Code__c='123';
        jo.Status__c='Job Plan';
        //jo.CSS_Job_Location_Code__c ='56255-56255';
        jo.Account__c = a.id;
        jo.Shop_Work_Order__c='123';
        
        insert jo;
        
        
        
        CSS_UserLocation__c userloc = new CSS_UserLocation__c();
        
        userloc.Location_code__c='56255-56255';
        insert userloc;
        css_solutions__c sol2 = new css_solutions__c();
        sol2.Service_Job__c=jo.Id;
        sol2.Diagnostic_Response__c='Most likely the solution';
        insert sol2;
        
        css_srt__c srt = new css_srt__c();
        srt.CSS_Claims__c=null;
        srt.Job_Order__c=jo.Id;
        srt.Step_Id__c='1';
        srt.SRT_ID__c='99-999';
        SRT.SRT_Title__c='Non-SRT detail';
        srt.Type__c='Field Action';
        srt.SRT_AccessiblityCheck__c=true;
        srt.SRT_Estimate__c=false;
        srt.SRT_Category__c='AdditionalDiag';
        srt.Solution_Number__c=sol2.id;
        srt.isPerformed__c = true;
        
        insert srt;
        //siva
        css_job_order__c jo1=[select id,name,(select id,Step_Id__c,Job_Order__c,SRT_ID__c,SRT_Title__c,Type__c from CSS_SRTS__r) from css_job_order__c];
        apexpages.currentPage().getparameters().put('id',jo.Id);
        apexpages.currentPage().getparameters().put('status','Job Plan');
        string json='{ "Header": { "ReturnCodeDescription": "<Message from SRT>", "ReturnCode": "<MessageCode from SRT>", "MessageIdentifier": "Identifier from MW" }, "DataArea": { "TotalOverlapHours": 5.5, "TotalAdjustedHours": 0.5, "OverlapSRTTime": [ { "SRTNumber": "11", "OverlapHrs": 1, "SRTTitle": "SRTTitle", "OverlapStepId": 5, "OverlapSRTNumber": "0.5", "StepId": 1, "OverlapSRTTitle": "1.5" } ], "Steps": [ { "TotalOverlapHours": [ { "SRTNumber": "11-111-11", "OverlapHrs": 1.5 }, { "SRTNumber": "12-121-12", "OverlapHrs": 3 } ], "StepId": 1, "SRTHours": 2.5, "SRTAdjustedHours": 0.5, "Qty": 2, "AccessCode": "R" } ] } }';
        CSS_OverlapSRTResponse bc = CSS_OverlapSRTResponse.parse(json);
        system.debug('BC>>'+bc);
        
        test.startTest();
        CSS_JobPlanSRTController jobcon = new CSS_JobPlanSRTController();
        jobcon.sendSRTsToBMS('WO','123');  
        jobcon.sendSRTsToBMSWOQT('WOQT');
        jobcon.sendSRTsToBMS('WO',null);
        jobcon.sendSRTsToBMSWOQT('null');
        jobcon.workJob=null;
        jobcon.sendSRTsToBMS('WO','123');     
        jobcon.sendSRTsToBMSWOQT('WOQT');
        test.stopTest();
    }
    
    static testmethod void testSRTjobplancon2221(){
        
        Account a = new account();
        a.name='Testing';
        a.BMS_Enabled__c=true;
        a.IAM_Service_Provider_Code__c='56255';
        a.CSS_DistributorCode__c='56255';
        a.IAM_Service_Provider_Code__c = '56255';
        a.Type = 'Customer';
        a.IAM_Service_Provider_Code__c = '56270';
        a.CMI_Account_Status__c = 'Active';
        insert a;
        
        css_job_order__c jo = CSS_TestData.createJobOrder(false);
        jo.ESN__c='58675876';
        jo.Customer_Name__c='TestUser';
        jo.Customer_Code__c='123';
        jo.Status__c='Job Plan';
        //jo.CSS_Job_Location_Code__c ='56255-56255';
        jo.Account__c = a.id;
        jo.Shop_Work_Order__c='123';
        
        insert jo;
        
        
        
        CSS_UserLocation__c userloc = new CSS_UserLocation__c();
        
        userloc.Location_code__c='56255-56255';
        insert userloc;
        css_solutions__c sol2 = new css_solutions__c();
        sol2.Service_Job__c=jo.Id;
        sol2.Diagnostic_Response__c='Most likely the solution';
        insert sol2;
        
        css_srt__c srt = new css_srt__c();
        srt.CSS_Claims__c=null;
        srt.Job_Order__c=jo.Id;
        srt.Step_Id__c='1';
        srt.SRT_ID__c='99-999';
        SRT.SRT_Title__c='Non-SRT detail';
        srt.Type__c='Field Action';
        srt.SRT_AccessiblityCheck__c=true;
        srt.SRT_Estimate__c=false;
        srt.SRT_Category__c='AdditionalDiag';
        srt.Solution_Number__c=sol2.id;
        srt.isPerformed__c = true;
        
        insert srt;
        //siva
        css_job_order__c jo1=[select id,name,(select id,Step_Id__c,Job_Order__c,SRT_ID__c,SRT_Title__c,Type__c from CSS_SRTS__r) from css_job_order__c];
        apexpages.currentPage().getparameters().put('id',jo.Id);
        apexpages.currentPage().getparameters().put('status','Job Plan');
        string json='{ "Header": { "ReturnCodeDescription": "<Message from SRT>", "ReturnCode": "<MessageCode from SRT>", "MessageIdentifier": "Identifier from MW" }, "DataArea": { "TotalOverlapHours": 5.5, "TotalAdjustedHours": 0.5, "OverlapSRTTime": [ { "SRTNumber": "11", "OverlapHrs": 1, "SRTTitle": "SRTTitle", "OverlapStepId": 5, "OverlapSRTNumber": "0.5", "StepId": 1, "OverlapSRTTitle": "1.5" } ], "Steps": [ { "TotalOverlapHours": [ { "SRTNumber": "11-111-11", "OverlapHrs": 1.5 }, { "SRTNumber": "12-121-12", "OverlapHrs": 3 } ], "StepId": 1, "SRTHours": 2.5, "SRTAdjustedHours": 0.5, "Qty": 2, "AccessCode": "R" } ] } }';
        CSS_OverlapSRTResponse bc = CSS_OverlapSRTResponse.parse(json);
        system.debug('BC>>'+bc);
        
        test.startTest();
        CSS_JobPlanSRTController jobcon = new CSS_JobPlanSRTController();
        jobcon.sendSRTsToBMS('WO','123');  
        jobcon.sendSRTsToBMSWOQT('');
        jobcon.sendSRTsToBMS('WO',null);
        jobcon.sendSRTsToBMSWOQT('null');
        jobcon.workJob=null;
        jobcon.sendSRTsToBMS('WO','123');     
        jobcon.sendSRTsToBMSWOQT('WOQT');
        test.stopTest();
    }
    
    static testmethod void testSRTjobplancon3(){
        
        Account a = new account();
        a.name='Testing';
        a.BMS_Enabled__c=true;
        //a.IAM_Service_Provider_Code__c='56255';
        a.CSS_DistributorCode__c='56255';
        a.IAM_Service_Provider_Code__c = '56255';
        a.Type = 'Customer';
        a.IAM_Service_Provider_Code__c = '56270';
        a.CMI_Account_Status__c = 'Active';
        insert a;
        
        css_job_order__c jo = CSS_TestData.createJobOrder(false);
        jo.ESN__c='58675876';
        jo.Customer_Name__c='TestUser';
        jo.Customer_Code__c='123';
        jo.Status__c='Job Plan';
        jo.CSS_Job_Location_Code__c ='56255-56255';
        jo.Shop_Work_Order__c='123';
        jo.Account__c = a.id;
        insert jo;
        
        
        CSS_UserLocation__c userloc = new CSS_UserLocation__c();
        
        userloc.Location_code__c='56255-56255';
        insert userloc;
        css_solutions__c sol2 = new css_solutions__c();
        sol2.Service_Job__c=jo.Id;
        sol2.Diagnostic_Response__c='Most likely the solution';
        insert sol2;
        
        css_srt__c srt = new css_srt__c();
        srt.CSS_Claims__c=null;
        srt.Job_Order__c=jo.Id;
        srt.Step_Id__c='1';
        srt.SRT_ID__c='901';
        SRT.SRT_Title__c='Non-SRT detail';
        srt.Type__c='Field Action';
        srt.SRT_AccessiblityCheck__c=true;
        srt.SRT_Estimate__c=false;
        srt.SRT_Category__c='AdditionalDiag';
        srt.Solution_Number__c=sol2.id;
        
        insert srt;
        //siva
        css_job_order__c jo1=[select id,name,(select id,Step_Id__c,Job_Order__c,SRT_ID__c,SRT_Title__c,Type__c from CSS_SRTS__r) from css_job_order__c];
        apexpages.currentPage().getparameters().put('id',jo.Id);
        apexpages.currentPage().getparameters().put('status','Job Plan');
        string json='{ "Header": { "ReturnCodeDescription": "<Message from SRT>", "ReturnCode": "<MessageCode from SRT>", "MessageIdentifier": "Identifier from MW" }, "DataArea": { "TotalOverlapHours": 5.5, "TotalAdjustedHours": 0.5, "OverlapSRTTime": [ { "SRTNumber": "11", "OverlapHrs": 1, "SRTTitle": "SRTTitle", "OverlapStepId": 5, "OverlapSRTNumber": "0.5", "StepId": 1, "OverlapSRTTitle": "1.5" } ], "Steps": [ { "TotalOverlapHours": [ { "SRTNumber": "11-111-11", "OverlapHrs": 1.5 }, { "SRTNumber": "12-121-12", "OverlapHrs": 3 } ], "StepId": 1, "SRTHours": 2.5, "SRTAdjustedHours": 0.5, "Qty": 2, "AccessCode": "R" } ] } }';
        CSS_OverlapSRTResponse bc = CSS_OverlapSRTResponse.parse(json);
        system.debug('BC>>'+bc);
        
        test.startTest();
        CSS_JobPlanSRTController jobcon = new CSS_JobPlanSRTController();
        jobcon.sendSRTsToBMS('WO','123');       
        jobcon.sendSRTsToBMSWOQT('WOQT');
        test.stopTest();
    }
    
    static testmethod void testSRTjobplancon34(){
        
        Account a = new account();
        a.name='Testing';
        a.BMS_Enabled__c=true;
        //a.IAM_Service_Provider_Code__c='56255';
        a.CSS_DistributorCode__c='56255';
        a.IAM_Service_Provider_Code__c = '56255';
        a.Type = 'Customer';
        a.IAM_Service_Provider_Code__c = '56270';
        a.CMI_Account_Status__c = 'Active';
        insert a;
       
        css_job_order__c jo = new css_job_order__c();
        jo.ESN__c='58675876';
        jo.Customer_Name__c='TestUser';
        jo.Customer_Code__c='123';
        jo.Status__c='Job Plan';
        jo.CSS_Job_Location_Code__c ='56255-56255';
        jo.Shop_Work_Order__c='123';
        jo.Account__c = a.Id;
        insert jo;
        
        css_claims__c claim = new css_claims__c();
        claim.CSS_Job__c=jo.id;
        claim.AccessCode__c='Test';
        claim.EditCause__c='Testing';
        claim.EditComplaint__c='Testing';
        claim.EditCorrection__c='Testing';
        claim.EditCoverage__c='Testing';
        claim.JobEditCause__c='Testing';
        claim.JobEditComplaint__c='Testing';
        claim.JobEditCorrection__c='Testing';
        claim.JobEditCoverage__c='Testing';
        insert claim;
        
        CSS_UserLocation__c userloc = new CSS_UserLocation__c();
        
        userloc.Location_code__c='56255-56255';
        insert userloc;
        css_solutions__c sol2 = new css_solutions__c();
        sol2.Service_Job__c=jo.Id;
        sol2.Diagnostic_Response__c='Most likely the solution';
        insert sol2;
        
        css_srt__c srt = new css_srt__c();
        srt.CSS_Claims__c=claim.id;
        srt.Job_Order__c=jo.id;
        srt.Claim_Type__c = '123';
        srt.Step_Id__c='1';
        srt.SRT_ID__c='901';
        SRT.SRT_Title__c='Non-SRT detail';
        srt.Type__c='Field Action';
        srt.SRT_AccessiblityCheck__c=true;
        srt.SRT_Estimate__c=false;
        srt.SRT_Category__c='AdditionalDiag';
        srt.Solution_Number__c=sol2.id;
        
        //insert srt;
        //siva
        css_job_order__c jo1=[select id,name,(select id,Step_Id__c,Job_Order__c,SRT_ID__c,SRT_Title__c,Type__c from CSS_SRTS__r) from css_job_order__c];
        apexpages.currentPage().getparameters().put('id',jo.Id);
        apexpages.currentPage().getparameters().put('status','Job Plan');
        string json='{ "Header": { "ReturnCodeDescription": "<Message from SRT>", "ReturnCode": "<MessageCode from SRT>", "MessageIdentifier": "Identifier from MW" }, "DataArea": { "TotalOverlapHours": 5.5, "TotalAdjustedHours": 0.5, "OverlapSRTTime": [ { "SRTNumber": "11", "OverlapHrs": 1, "SRTTitle": "SRTTitle", "OverlapStepId": 5, "OverlapSRTNumber": "0.5", "StepId": 1, "OverlapSRTTitle": "1.5" } ], "Steps": [ { "TotalOverlapHours": [ { "SRTNumber": "11-111-11", "OverlapHrs": 1.5 }, { "SRTNumber": "12-121-12", "OverlapHrs": 3 } ], "StepId": 1, "SRTHours": 2.5, "SRTAdjustedHours": 0.5, "Qty": 2, "AccessCode": "R" } ] } }';
        CSS_OverlapSRTResponse bc = CSS_OverlapSRTResponse.parse(json);
        system.debug('BC>>'+bc);
        
        test.startTest();
        CSS_JobPlanSRTController jobcon = new CSS_JobPlanSRTController();
        jobcon.sendSRTsToBMS('WO','123');       
        jobcon.sendSRTsToBMSWOQT('WOQT');
        test.stopTest();
    }
    
    static testmethod void testSRTjobplancon33(){
        
        Account a = new account();
        a.name='Testing';
        a.BMS_Enabled__c=true;
        //a.IAM_Service_Provider_Code__c='56255';
        a.CSS_DistributorCode__c='56255';
        a.IAM_Service_Provider_Code__c = '56255';
        a.Type = 'Customer';
        a.IAM_Service_Provider_Code__c = '56270';
        a.CMI_Account_Status__c = 'Active';
        insert a;
       
        css_job_order__c jo = CSS_TestData.createJobOrder(false);
        jo.ESN__c='58675876';
        jo.Customer_Name__c='TestUser';
        jo.Customer_Code__c='123';
        jo.Status__c='Job Plan';
        jo.CSS_Job_Location_Code__c ='56255-56255';
        jo.Shop_Work_Order__c='123';
        jo.Account__c = a.id;
        insert jo;
        
        
        CSS_UserLocation__c userloc = new CSS_UserLocation__c();
        
        userloc.Location_code__c='56255-56255';
        insert userloc;
        css_solutions__c sol2 = new css_solutions__c();
        sol2.Service_Job__c=jo.Id;
        sol2.Diagnostic_Response__c='Most likely the solution';
        insert sol2;
        
        List<String> srtIdLst = new List<String>();
        css_srt__c srt = new css_srt__c();
        srt.CSS_Claims__c=null;
        srt.Job_Order__c=jo.Id;
        srt.Step_Id__c='1';
        srt.SRT_ID__c='901';
        SRT.SRT_Title__c='Non-SRT detail';
        srt.Type__c='Field Action';
        srt.SRT_AccessiblityCheck__c=true;
        srt.SRT_Quantity__c = 23;
        srt.SRT_Estimate__c=false;
        srt.SRT_Category__c='AdditionalDiag';
        srt.Solution_Number__c=sol2.id;
        insert srt;
        //siva
        srtIdLst.add(srt.SRT_ID__c);
        
        
        
        css_job_order__c jo1=[select id,name,(select id,Step_Id__c,Job_Order__c,SRT_ID__c,SRT_Title__c,Type__c from CSS_SRTS__r) from css_job_order__c];
        apexpages.currentPage().getparameters().put('id',jo.Id);
        apexpages.currentPage().getparameters().put('status','Job Plan');
        string json='{ "Header": { "ReturnCodeDescription": "<Message from SRT>", "ReturnCode": "<MessageCode from SRT>", "MessageIdentifier": "Identifier from MW" }, "DataArea": { "TotalOverlapHours": 5.5, "TotalAdjustedHours": 0.5, "OverlapSRTTime": [ { "SRTNumber": "11", "OverlapHrs": 1, "SRTTitle": "SRTTitle", "OverlapStepId": 5, "OverlapSRTNumber": "0.5", "StepId": 1, "OverlapSRTTitle": "1.5" } ], "Steps": [ { "TotalOverlapHours": [ { "SRTNumber": "11-111-11", "OverlapHrs": 1.5 }, { "SRTNumber": "12-121-12", "OverlapHrs": 3 } ], "StepId": 1, "SRTHours": 2.5, "SRTAdjustedHours": 0.5, "Qty": 2, "AccessCode": "R" } ] } }';
        CSS_OverlapSRTResponse bc = CSS_OverlapSRTResponse.parse(json);
        system.debug('BC>>'+bc);
        
        test.startTest();
        CSS_JobPlanSRTController jobcon = new CSS_JobPlanSRTController();
        jobcon.sendSRTsToBMS('WO','123');       
        jobcon.sendSRTsToBMSWOQT('WOQT');
        test.stopTest();
    }
    
    static testmethod void testSRTjobplanconnull(){
        
        Account a = new account();
        a.name='Testing';
        a.BMS_Enabled__c=true;
        a.IAM_Service_Provider_Code__c='56255';
        a.CSS_DistributorCode__c='56255';
        a.IAM_Service_Provider_Code__c = '56270';
        a.Type = 'Customer';
        a.IAM_Service_Provider_Code__c = '56270';
        a.CMI_Account_Status__c = 'Active';
        insert a;
        
        css_job_order__c jo = CSS_TestData.createJobOrder(false);
        jo.ESN__c='58675876';
        jo.Customer_Name__c='TestUser';
        jo.Customer_Code__c='123';
        jo.Status__c='Job Plan';
        //jo.CSS_Job_Location_Code__c =Null;
        jo.Shop_Work_Order__c='123';
        jo.Account__c = a.id;
        insert jo;
        
        
        CSS_UserLocation__c userloc = new CSS_UserLocation__c();
        userloc.Name='Testing';
        //  userloc.Location_code__c='56255-56255';
        insert userloc;
        css_solutions__c sol2 = new css_solutions__c();
        sol2.Service_Job__c=jo.Id;
        sol2.Diagnostic_Response__c='Most likely the solution';
        insert sol2;
        
        css_srt__c srt = new css_srt__c();
        srt.CSS_Claims__c=null;
        srt.Job_Order__c=jo.Id;
        srt.Step_Id__c='1';
        srt.SRT_ID__c='1';
        SRT.SRT_Title__c='Non-SRT detail';
        srt.Type__c='Field Action';
        srt.SRT_AccessiblityCheck__c=true;
        srt.SRT_Estimate__c=false;
        srt.SRT_Category__c='AdditionalDiag';
        srt.Solution_Number__c=sol2.id;
        
        insert srt;
        //siva
        css_job_order__c jo1=[select id,name,(select id,Step_Id__c,Job_Order__c,SRT_ID__c,SRT_Title__c,Type__c from CSS_SRTS__r) from css_job_order__c];
        apexpages.currentPage().getparameters().put('id',jo.Id);
        apexpages.currentPage().getparameters().put('status','Job Plan');
        string json='{ "Header": { "ReturnCodeDescription": "<Message from SRT>", "ReturnCode": "<MessageCode from SRT>", "MessageIdentifier": "Identifier from MW" }, "DataArea": { "TotalOverlapHours": 5.5, "TotalAdjustedHours": 0.5, "OverlapSRTTime": [ { "SRTNumber": "11", "OverlapHrs": 1, "SRTTitle": "SRTTitle", "OverlapStepId": 5, "OverlapSRTNumber": "0.5", "StepId": 1, "OverlapSRTTitle": "1.5" } ], "Steps": [ { "TotalOverlapHours": [ { "SRTNumber": "11-111-11", "OverlapHrs": 1.5 }, { "SRTNumber": "12-121-12", "OverlapHrs": 3 } ], "StepId": 1, "SRTHours": 2.5, "SRTAdjustedHours": 0.5, "Qty": 2, "AccessCode": "R" } ] } }';
        CSS_OverlapSRTResponse bc = CSS_OverlapSRTResponse.parse(json);
        system.debug('BC>>'+bc);
        
        test.startTest();
        CSS_JobPlanSRTController jobcon = new CSS_JobPlanSRTController();
        jobcon.sendSRTsToBMS('WO',null); 
        jobcon.sendSRTsToBMS('WO','123'); 
        jobcon.sendSRTsToBMSWOQT('WOQT');
        test.stopTest();
    }
    
    static testmethod void testmethod11(){
        
        Test.startTest();
        
        Id currentUserID=UserInfo.getUserId();
        list<user> userids = [select id,name from user limit 3]; 
        
        //Add test data for Service job order
        CSS_Job_Order__c JO = new CSS_Job_Order__c();
        JO.Customer_Name__c = 'Test';
        JO.DSID__c = 'DS455';
        JO.EditComplaint__c = 'wwwwwweeeeee';
        JO.EditCoverage__c = 'ccddddddd';
        JO.EditCorrection__c = 'dcsscscs';
        JO.chevron_page__c = 'war';
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
        JO.Unit_Number__c = 'test123';
        Jo.Assigned_To__c = UserInfo.getUserId();
        JO.Additional_Tech1__c = userids[0].id;
        JO.Additional_Tech2__c = userids[1].id;
        JO.CSS_Job_Location_Code__c='56270-56255';
        Jo.esn__c='1234';
        JO.Equipment_ID__c = 'EQ7667';
        JO.Qsol_Engine_Family_Code__c ='56';
        JO.AccessCode__c = 'A';
        JO.BMSWSStatus__c = 'UI';
        JO.BMSStatus__c = 'sample';
        JO.CSS_Resolution__c='TEST';
        JO.chevron_page__c = 'war';
        insert(JO);      
        PageReference pref;
        pref = new PageReference('/'+JO.id);
        pref.getParameters().put('id',JO.id);
        //pref.getParameters().put('partsUr','Parts');
        Test.setCurrentPage(pref);
        
        CSS_JobPlanSRTController jobPlan= new CSS_JobPlanSRTController();
        
        
        JobPlan.workJob = [Select Id,Name,AccessCode__c,Customer_Name__c,Shop_Work_Order__c, Application__c, Application_Desc__c, BMS_Last_Name__c, DSID_WorkGroup__c, Unit_Number__c, Date_in__c, INSITE_UpdateTimeStamp__c, First_Name__c,
                           Repair_Location__c,Failure_Date__c, Failure_Point__c, Failure_Point_Measure__c, Service_Model__c,BMSStatus__c,Unit_Type__c, VIN__c, Warranty_Start_Date__c,Make__c, Qsol_Engine_Family_Code__c,
                           DSID__c, DSID_Creation_Timestamp__c, DSID_Status__c, Repeat_Or_Recent_Calc__c, DSID_UpdateTimestamp__c,Customer_Code__c,Status__c,
                           Phone_Number__c, Previous_Status__c,Sub_Type__c, Category__c, Complaint_Type__c, Model__c,Creator_Location__c, Control_Number__c,
                           Assigned_to__r.Name,Additional_Tech1__r.Name,Additional_Tech2__r.Name,OwnerId,JobLocation__c,CSS_Resolution__c,CSS_Feedback_Comments__c, BMSWSStatus__c,
                           ESN__c, Mileage__c, Mileage_Measure__c, chevron_page__c, General_Symptoms__c, Assigned_To__c, LastModifiedDate,CreatedDate,ESN_Locked__c,Region__c,Territory__c
                           from CSS_Job_Order__c where id= :JO.id];
        
        
        CSS_List_Of_Values__c CLV = new CSS_List_Of_Values__c();
        CLV.Name = 'Test'+math.random();
        CLV.Type__c = 'ApplicationCode';
        CLV.Code__c = 'UKEU';
        CLV.Picklist_Values_1__c = 'EUROPE';
        insert(CLV);
        
        CSS_Job_Order__c jobOrder = new CSS_Job_Order__c();
        jobOrder.Status__c = 'Created/Not Assigned';
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
        List<CSS_Solutions__c> sol = new List<CSS_Solutions__c>();
        CSS_Solutions__c solRef = new CSS_Solutions__c();
        solRef.Diagnostic_Response__c='Most likely the solution';
        solRef.Repair_Response__c = 'Successful';
        solRef.Service_Job__c=JO.Id;
        solRef.FaultCode__c = fc1.Id;
        solRef.Solution_title__c='TestData';
        solRef.Out_Of_Order__c = true;
        //solRef.Account_Code__c ='A';
        //insert solRef;
        sol.add(solRef);
        insert sol;
        //jobPlan.outOfOrderSolList = sol.id;
        CSS_CampTsbTrp__c x1 = new CSS_CampTsbTrp__c();
        //x1.Job_order__c = Jo.Id;
        x1.performed_review__c = true;
        x1.performed__c =false;
        insert x1;
        
        //pref = jobplan.saveAndCloseJob();
        string x = jobPlan.comm = 'euiewdh';
        jobPlan.showJobPlanBlocks(false,false,false,true,false,false,false); 
        jobPlan.ChkFieldBlank();
        jobPlan.showRepairErrorMessage = true;
        jobplan.showResolutionWithRepair = true;
        jobplan.showResolution = true;
        jobplan.showRepairs = false;
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
        pref = jobPlan.closeSession();
        jobPlan.closeSession_Close();
        jobPlan.showPopup();
        jobPlan.jobClosePopup();        
        jobPlan.redirectPopup();  
        jobPlan.Cancel();
        jobPlan.saveAndCloseJob();
        Note n = new Note();
        n.Title = 'CAMPCOMMENTS';
        n.ParentId = JO.Id;  
        n.Body = x;
        insert n;
        
        //CSS_WPR_JobPlanOverview jpo = new CSS_WPR_JobPlanOverview();
        
        Test.stopTest();
    }
    
    static testmethod void testSRTjobplancon30(){
        
        Account a = new account();
        a.name='Testing';
        a.BMS_Enabled__c=true;
        //a.IAM_Service_Provider_Code__c='56255';
        a.CSS_DistributorCode__c='56255';
        a.IAM_Service_Provider_Code__c = '56255';
        a.Type = 'Customer';
        a.IAM_Service_Provider_Code__c = '56270';
        a.CMI_Account_Status__c = 'Active';
        insert a;
        
        css_job_order__c jo = CSS_TestData.createJobOrder(false);
        jo.ESN__c='58675876';
        jo.Customer_Name__c='TestUser';
        jo.Customer_Code__c='123';
        jo.Status__c='Job Plan';
        jo.CSS_Job_Location_Code__c ='56255-56255';
        jo.Shop_Work_Order__c='123';
        jo.Account__c = a.id;
        insert jo;
        
        
        CSS_UserLocation__c userloc = new CSS_UserLocation__c();
        
        userloc.Location_code__c='56255-56255';
        insert userloc;
        css_solutions__c sol2 = new css_solutions__c();
        sol2.Service_Job__c=jo.Id;
        sol2.Diagnostic_Response__c='Most likely the solution';
        insert sol2;
        
        css_srt__c srt = new css_srt__c();
        srt.CSS_Claims__c=null;
        srt.Job_Order__c=jo.Id;
        srt.Step_Id__c='1';
        srt.SRT_ID__c='901';
        SRT.SRT_Title__c='Non-SRT detail';
        srt.Type__c='Field Action';
        srt.SRT_AccessiblityCheck__c=true;
        srt.SRT_Type__c = 'Overlap';
        srt.SRT_Estimate__c=false;
        srt.claim_type__c = null;
        srt.SRT_Category__c='AdditionalDiag';
        srt.Extended_Hours__c = null;
        srt.Solution_Number__c=sol2.id;
        
        insert srt;
        //siva
        css_job_order__c jo1=[select id,name,(select id,Step_Id__c,Job_Order__c,SRT_ID__c,SRT_Title__c,Type__c from CSS_SRTS__r) from css_job_order__c];
        apexpages.currentPage().getparameters().put('id',jo.Id);
        apexpages.currentPage().getparameters().put('status','Job Plan');
        string json='{ "Header": { "ReturnCodeDescription": "<Message from SRT>", "ReturnCode": "<MessageCode from SRT>", "MessageIdentifier": "Identifier from MW" }, "DataArea": { "TotalOverlapHours": 5.5, "TotalAdjustedHours": 0.5, "OverlapSRTTime": [ { "SRTNumber": "11", "OverlapHrs": 1, "SRTTitle": "SRTTitle", "OverlapStepId": 5, "OverlapSRTNumber": "0.5", "StepId": 1, "OverlapSRTTitle": "1.5" } ], "Steps": [ { "TotalOverlapHours": [ { "SRTNumber": "11-111-11", "OverlapHrs": 1.5 }, { "SRTNumber": "12-121-12", "OverlapHrs": 3 } ], "StepId": 1, "SRTHours": 2.5, "SRTAdjustedHours": 0.5, "Qty": 2, "AccessCode": "R" } ] } }';
        CSS_OverlapSRTResponse bc = CSS_OverlapSRTResponse.parse(json);
        system.debug('BC>>'+bc);
        
        test.startTest();
        CSS_JobPlanSRTController jobcon = new CSS_JobPlanSRTController();
        jobcon.sendSRTsToBMS('WO','123');       
        jobcon.sendSRTsToBMSWOQT('WOQT');
        test.stopTest();
    }
    
    static testmethod void testSRTjobplancon38(){
        
        Account a = new account();
        a.name='Testing';
        a.BMS_Enabled__c=true;
        //a.IAM_Service_Provider_Code__c='56255';
        a.CSS_DistributorCode__c='56255';
        a.IAM_Service_Provider_Code__c = '56255';
        a.Type = 'Customer';
        a.IAM_Service_Provider_Code__c = '56270';
        a.CMI_Account_Status__c = 'Active';
        insert a;
        
        css_job_order__c jo = CSS_TestData.createJobOrder(false);
        jo.ESN__c='58675876';
        jo.Customer_Name__c='TestUser';
        jo.Customer_Code__c='123';
        jo.Status__c='Job Plan';
        jo.CSS_Job_Location_Code__c ='56255-56255';
        jo.Shop_Work_Order__c='123';
        jo.Account__c = a.id;
        insert jo;
        
        
        CSS_UserLocation__c userloc = new CSS_UserLocation__c();
        
        userloc.Location_code__c='56255-56255';
        insert userloc;
        css_solutions__c sol2 = new css_solutions__c();
        sol2.Service_Job__c=jo.Id;
        sol2.Diagnostic_Response__c='Most likely the solution';
        insert sol2;
        
        css_srt__c srt = new css_srt__c();
        srt.CSS_Claims__c=null;
        srt.Job_Order__c=jo.Id;
        srt.Step_Id__c='1';
        srt.SRT_ID__c='901';
        SRT.SRT_Title__c='Non-SRT detail';
        srt.Type__c= '99Time';
        srt.SRT_AccessiblityCheck__c=true;
        srt.SRT_Type__c = 'Overlap';
        srt.SRT_Estimate__c=false;
        srt.SRT_Category__c='AdditionalDiag';
        srt.Extended_Hours__c = null;
        srt.Solution_Number__c=sol2.id;
        
        insert srt;
        //siva
        css_job_order__c jo1=[select id,name,(select id,Step_Id__c,Job_Order__c,SRT_ID__c,SRT_Title__c,Type__c from CSS_SRTS__r) from css_job_order__c];
        apexpages.currentPage().getparameters().put('id',jo.Id);
        apexpages.currentPage().getparameters().put('status','Job Plan');
        string json='{ "Header": { "ReturnCodeDescription": "<Message from SRT>", "ReturnCode": "<MessageCode from SRT>", "MessageIdentifier": "Identifier from MW" }, "DataArea": { "TotalOverlapHours": 5.5, "TotalAdjustedHours": 0.5, "OverlapSRTTime": [ { "SRTNumber": "11", "OverlapHrs": 1, "SRTTitle": "SRTTitle", "OverlapStepId": 5, "OverlapSRTNumber": "0.5", "StepId": 1, "OverlapSRTTitle": "1.5" } ], "Steps": [ { "TotalOverlapHours": [ { "SRTNumber": "11-111-11", "OverlapHrs": 1.5 }, { "SRTNumber": "12-121-12", "OverlapHrs": 3 } ], "StepId": 1, "SRTHours": 2.5, "SRTAdjustedHours": 0.5, "Qty": 2, "AccessCode": "R" } ] } }';
        CSS_OverlapSRTResponse bc = CSS_OverlapSRTResponse.parse(json);
        system.debug('BC>>'+bc);
        
        test.startTest();
        CSS_JobPlanSRTController jobcon = new CSS_JobPlanSRTController();
        jobcon.sendSRTsToBMS('WO','123');       
        jobcon.sendSRTsToBMSWOQT('WOQT');
        test.stopTest();
    }
    
     static testmethod void testSRTjobplanconnewOne(){
        
         Account a = new account();
        a.name='Testing';
        a.BMS_Enabled__c=true;
        a.IAM_Service_Provider_Code__c='56255';
        a.CSS_DistributorCode__c='56255';
        a.IAM_Service_Provider_Code__c = '56255';
        a.Type = 'Customer';
        a.IAM_Service_Provider_Code__c = '56270';
        a.CMI_Account_Status__c = 'Active';
        insert a;
        
        css_job_order__c jo = CSS_TestData.createJobOrder(false);
        jo.ESN__c='58675876';
        jo.Customer_Name__c='TestUser';
        jo.Customer_Code__c='123';
        jo.Status__c='Job Plan';
        //jo.CSS_Job_Location_Code__c ='56255-56255';
        jo.Account__c = a.id;
        jo.Shop_Work_Order__c='123';
        
        insert jo;
        
        
        
        CSS_UserLocation__c userloc = new CSS_UserLocation__c();
        
        userloc.Location_code__c='56255-56255';
        insert userloc;
        css_solutions__c sol2 = new css_solutions__c();
        sol2.Service_Job__c=jo.Id;
        sol2.Diagnostic_Response__c='Most likely the solution';
        insert sol2;
        
        css_srt__c srt = new css_srt__c();
        srt.CSS_Claims__c=null;
        srt.Job_Order__c=jo.Id;
        srt.Step_Id__c='1';
        srt.SRT_ID__c='00-901-00';
        SRT.SRT_Title__c='Non-SRT detail';
        srt.Type__c='Field Action';
        srt.SRT_AccessiblityCheck__c=true;
        srt.SRT_Estimate__c=false;
        srt.SRT_Category__c='AdditionalDiag';
        srt.Solution_Number__c=sol2.id;
        srt.Extended_Hours__c = 2.0;
        
        insert srt;
        //siva
        css_job_order__c jo1=[select id,name,(select id,Step_Id__c,Job_Order__c,SRT_ID__c,SRT_Title__c,Type__c from CSS_SRTS__r) from css_job_order__c];
        apexpages.currentPage().getparameters().put('id',jo.Id);
        apexpages.currentPage().getparameters().put('status','Job Plan');
        string json='{ "Header": { "ReturnCodeDescription": "<Message from SRT>", "ReturnCode": "<MessageCode from SRT>", "MessageIdentifier": "Identifier from MW" }, "DataArea": { "TotalOverlapHours": 5.5, "TotalAdjustedHours": 0.5, "OverlapSRTTime": [ { "SRTNumber": "11", "OverlapHrs": 1, "SRTTitle": "SRTTitle", "OverlapStepId": 5, "OverlapSRTNumber": "0.5", "StepId": 1, "OverlapSRTTitle": "1.5" } ], "Steps": [ { "TotalOverlapHours": [ { "SRTNumber": "11-111-11", "OverlapHrs": 1.5 }, { "SRTNumber": "12-121-12", "OverlapHrs": 3 } ], "StepId": 1, "SRTHours": 2.5, "SRTAdjustedHours": 0.5, "Qty": 2, "AccessCode": "R" } ] } }';
        CSS_OverlapSRTResponse bc = CSS_OverlapSRTResponse.parse(json);
        system.debug('BC>>'+bc);
        
        test.startTest();
        CSS_JobPlanSRTController jobcon = new CSS_JobPlanSRTController();
        jobcon.sendSRTsToBMS('WO','123'); 
        jobcon.sendSRTsToBMSWOQT('WOQT');
        jobcon.sendSRTsToBMS('WO',null);
        jobcon.sendSRTsToBMSWOQT('null');
        jobcon.workJob=null;
        jobcon.sendSRTsToBMS('WO','123');     
        jobcon.sendSRTsToBMSWOQT('WOQT');
        test.stopTest();
    }
    
    static testmethod void testSRTjobplancon29() {
        Account a = new account();
        a.name='Testing';
        a.BMS_Enabled__c=true;
        a.IAM_Service_Provider_Code__c='56255';
        a.CSS_DistributorCode__c='56255';
        a.IAM_Service_Provider_Code__c = '56255';
        a.Type = 'Customer';
        a.IAM_Service_Provider_Code__c = '56270';
        a.CMI_Account_Status__c = 'Active';
        insert a;
        
        css_job_order__c jo = CSS_TestData.createJobOrder(false);
        jo.ESN__c='58675876';
        jo.Customer_Name__c='TestUser';
        jo.Customer_Code__c='123';
        jo.Status__c='Job Plan';
        //jo.CSS_Job_Location_Code__c ='56255-56255';
        jo.Shop_Work_Order__c='123';
        jo.Account__c = a.id;
        insert jo;
        
       CSS_UserLocation__c userloc = new CSS_UserLocation__c();
        
        userloc.Location_code__c='56255-56255';
        insert userloc;
        css_solutions__c sol2 = new css_solutions__c();
        sol2.Service_Job__c=jo.Id;
        sol2.Diagnostic_Response__c='Most likely the solution';
        insert sol2;
        
        css_srt__c srt = new css_srt__c();
        srt.CSS_Claims__c=null;
        srt.Job_Order__c=jo.Id;
        srt.Step_Id__c='1';
        srt.SRT_ID__c='00-901-00';
        SRT.SRT_Title__c='Non-SRT detail';
        srt.Type__c='Field Action';
        srt.Account_Code__c = '123';
        srt.SRT_AccessiblityCheck__c=true;
        srt.SRT_Estimate__c=false;
        srt.SRT_Category__c='AdditionalDiag';
        srt.Solution_Number__c=sol2.id;
        
        insert srt;
        //siva
        css_job_order__c jo1=[select id,name,(select id,Step_Id__c,Job_Order__c,SRT_ID__c,SRT_Title__c,Type__c from CSS_SRTS__r) from css_job_order__c];
        apexpages.currentPage().getparameters().put('id',jo.Id);
        apexpages.currentPage().getparameters().put('status','Job Plan');
        string json='{ "Header": { "ReturnCodeDescription": "<Message from SRT>", "ReturnCode": "<MessageCode from SRT>", "MessageIdentifier": "Identifier from MW" }, "DataArea": { "TotalOverlapHours": 5.5, "TotalAdjustedHours": 0.5, "OverlapSRTTime": [ { "SRTNumber": "11", "OverlapHrs": 1, "SRTTitle": "SRTTitle", "OverlapStepId": 5, "OverlapSRTNumber": "0.5", "StepId": 1, "OverlapSRTTitle": "1.5" } ], "Steps": [ { "TotalOverlapHours": [ { "SRTNumber": "11-111-11", "OverlapHrs": 1.5 }, { "SRTNumber": "12-121-12", "OverlapHrs": 3 } ], "StepId": 1, "SRTHours": 2.5, "SRTAdjustedHours": 0.5, "Qty": 2, "AccessCode": "R" } ] } }';
        CSS_OverlapSRTResponse bc = CSS_OverlapSRTResponse.parse(json);
        system.debug('BC>>'+bc);
        
        test.startTest();
        CSS_JobPlanSRTController jobcon = new CSS_JobPlanSRTController();
        jobcon.sendSRTsToBMS('WO','123'); 
        jobcon.sendSRTsToBMSWOQT('WOQT');
        jobcon.sendSRTsToBMS('WO',null);
        jobcon.sendSRTsToBMSWOQT('null');
        jobcon.workJob=null;
        jobcon.sendSRTsToBMS('WO','123');     
        jobcon.sendSRTsToBMSWOQT('WOQT');
        test.stopTest();
    }
    
    static testmethod void testSRTjobplancon11(){
        
        Account a = new account();
        a.name='Testing';
        a.BMS_Enabled__c=true;
        a.IAM_Service_Provider_Code__c='56255';
        a.CSS_DistributorCode__c='56255';
        a.IAM_Service_Provider_Code__c = '56255';
        a.Type = 'Customer';
        a.IAM_Service_Provider_Code__c = '56270';
        a.CMI_Account_Status__c = 'Active';
        insert a;
        
        css_job_order__c jo = CSS_TestData.createJobOrder(false);
        jo.ESN__c='58675876';
        jo.Customer_Name__c='TestUser';
        jo.Customer_Code__c='123';
        jo.Status__c='Job Plan';
        jo.CSS_Job_Location_Code__c ='56255-56255';
        jo.Shop_Work_Order__c='123';
        jo.Account__c = a.id;
        insert jo;

        CSS_UserLocation__c userloc = new CSS_UserLocation__c();
        
        userloc.Location_code__c='56255-56255';
        insert userloc;
        css_solutions__c sol2 = new css_solutions__c();
        sol2.Service_Job__c=jo.Id;
        sol2.Diagnostic_Response__c='Most likely the solution';
        insert sol2;
        
        css_srt__c srt = new css_srt__c();
        srt.CSS_Claims__c=null;
        srt.Job_Order__c=jo.Id;
        srt.Step_Id__c='1';
        srt.SRT_ID__c='00-901-00';
        SRT.SRT_Title__c='Non-SRT detail';
        srt.Type__c='Field Action';
        srt.SRT_AccessiblityCheck__c=true;
        srt.SRT_Estimate__c=false;
        srt.SRT_Warrantable__c = null;
        srt.SRT_Category__c='AdditionalDiag';
        srt.Solution_Number__c=sol2.id;
        
        insert srt;
        //siva
        css_job_order__c jo1=[select id,name,(select id,Step_Id__c,Job_Order__c,SRT_ID__c,SRT_Title__c,Type__c from CSS_SRTS__r) from css_job_order__c];
        apexpages.currentPage().getparameters().put('id',jo.Id);
        apexpages.currentPage().getparameters().put('status','Job Plan');
        string json='{ "Header": { "ReturnCodeDescription": "<Message from SRT>", "ReturnCode": "<MessageCode from SRT>", "MessageIdentifier": "Identifier from MW" }, "DataArea": { "TotalOverlapHours": 5.5, "TotalAdjustedHours": 0.5, "OverlapSRTTime": [ { "SRTNumber": "11", "OverlapHrs": 1, "SRTTitle": "SRTTitle", "OverlapStepId": 5, "OverlapSRTNumber": "0.5", "StepId": 1, "OverlapSRTTitle": "1.5" } ], "Steps": [ { "TotalOverlapHours": [ { "SRTNumber": "11-111-11", "OverlapHrs": 1.5 }, { "SRTNumber": "12-121-12", "OverlapHrs": 3 } ], "StepId": 1, "SRTHours": 2.5, "SRTAdjustedHours": 0.5, "Qty": 2, "AccessCode": "R" } ] } }';
        CSS_OverlapSRTResponse bc = CSS_OverlapSRTResponse.parse(json);
        system.debug('BC>>'+bc);
        
        test.startTest();
        CSS_JobPlanSRTController jobcon = new CSS_JobPlanSRTController();
        jobcon.sendSRTsToBMS('WO','123'); 
        jobcon.sendSRTsToBMSWOQT('WOQT');
        test.stopTest();
    }
    
    static testmethod void jobPlanControllertestmethod31(){
        Test.startTest();
        
        Id currentUserID=UserInfo.getUserId();
        //list<user> userids = [select id,name from user limit 3]; 
        
        //Add test data for Service job order
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
        JO.Unit_Number__c = 'test123';
        Jo.Assigned_To__c = UserInfo.getUserId();
        JO.Additional_Tech1__c =  UserInfo.getUserId();//userids[0].id;
        JO.Additional_Tech2__c =  UserInfo.getUserId();// userids[1].id;
        Jo.esn__c='1234';
        JO.Equipment_ID__c = 'EQ7667';
        JO.Qsol_Engine_Family_Code__c ='56';
        JO.AccessCode__c = 'A';
        JO.BMSWSStatus__c = 'UI';
        JO.BMSStatus__c = 'UII';
        JO.EditCoverage__c='TEST';
        JO.EditComplaint__c='TEST';
        JO.EditCause__c='TEST';
        JO.EditCorrection__c='TEST';
        JO.chevron_page__c='srt';
        JO.CSS_Resolution__c='TEST';
        insert(JO);      
        PageReference pref;
        pref = new PageReference('/'+JO.id);
        pref.getParameters().put('id',JO.id);
        pref.getParameters().put('joPa','Parts');
        Test.setCurrentPage(pref);
        
        CSS_JobPlanSRTController jobPlan= new CSS_JobPlanSRTController();
        //jobPlan.bmsEnabled=TRUE;
        
        
        JobPlan.workJob = [Select Id,Name,AccessCode__c,Customer_Name__c,CSS_Hours__c,Shop_Work_Order__c, Application__c, Application_Desc__c, BMS_Last_Name__c, DSID_WorkGroup__c, Unit_Number__c, Date_in__c, INSITE_UpdateTimeStamp__c, First_Name__c,
                           Repair_Location__c,Failure_Date__c, Failure_Point__c, Failure_Point_Measure__c, Service_Model__c,BMSStatus__c,Unit_Type__c, VIN__c, Warranty_Start_Date__c,Make__c, Qsol_Engine_Family_Code__c,
                           DSID__c, DSID_Creation_Timestamp__c, DSID_Status__c, Repeat_Or_Recent_Calc__c, DSID_UpdateTimestamp__c,Customer_Code__c,Status__c,
                           Phone_Number__c, Previous_Status__c,Sub_Type__c, Category__c, Complaint_Type__c, Model__c,Creator_Location__c, Control_Number__c,
                           Assigned_to__r.Name,Additional_Tech1__r.Name,Additional_Tech2__r.Name,OwnerId,JobLocation__c,CSS_Resolution__c,CSS_Feedback_Comments__c, BMSWSStatus__c,
                           ESN__c, Mileage__c, Mileage_Measure__c, chevron_page__c, General_Symptoms__c, Assigned_To__c, LastModifiedDate,CreatedDate,ESN_Locked__c,Region__c,Territory__c
                           from CSS_Job_Order__c where id= :JO.id];
        
        CSS_Job_Order__c jobOrder = new CSS_Job_Order__c();
        jobOrder.Status__c = 'Created/Not Assigned';
        insert jobOrder;
        
        CSS_Fault_Code__c fc1 = new CSS_Fault_Code__c(FaultCodeR2__c = '441',Related_Fault_Code__c = '234,546');
        fc1.Name = '441';
        fc1.Job_Order__c = JO.Id;
        fc1.Sequence__c = 1;
        fc1.Fault_Code_Type__c = 'APD-P';
        fc1.Mod__c = '0';
        fc1.isPole__c = false;
        insert fc1;
        List<CSS_Fault_Code__c> lstFC = new List<CSS_Fault_Code__c>();
        lstFC.add(fc1);
        
        CSS_Solutions__c sol1 = new CSS_Solutions__c();
        sol1.FaultCode__c = fc1.Id;
        sol1.Service_Job__c = jobOrder.Id;
        sol1.Name = 'Sample Case Name';
        sol1.Case_Name__c = 'Sample Case Name';
        sol1.Solution_Title__c = 'Sample Title';
        sol1.Rank__c =0;
        insert sol1; 
        
        CSS_Solutions__c cssSol ;
        cssSol = new CSS_Solutions__c();
        cssSol.Name = 'Test Solution';
        cssSol.service_job__c = JO.id;
        cssSol.Out_Of_Order__c = true;
        cssSol.Diagnostic_Response__c = 'Most likely the solution';
        
        list<CSS_Solutions__c> solListSol = new list<CSS_Solutions__c>();
        solListSol.add(cssSol);
        insert solListSol;
        
        CSS_Solution_Component__c csc=new CSS_Solution_Component__c();
        csc.Action__c='test';
        csc.Solutions__c=sol1.id;
        csc.Service_Job__c=jobOrder.id;
        insert csc;
        List <css_jobeventTemporary__c> JTList = new list <css_jobeventTemporary__c>();
        css_jobeventTemporary__c JT = new css_jobeventTemporary__c();
        JT.attribute1__C = 'ApplicationCodes';
        JT.attribute2__C = 'STARWARS';
        JT.attribute3__C = 'Avengers';
        JT.key__c = 'AccountCodes';
        JTList.add(JT);
        insert JTList;
        /* CSS_SRT__c srt1= new CSS_SRT__c();
srt1.Id=  'a1E3B000001WOgoUAG';
srt1.Name='testing';
insert srt1;
CSS_SRT__c srt2= new CSS_SRT__c();
srt2.Id=  'a1E3B000001WOgtUAG';
srt2.Name='testing';
insert srt2;
map<string,CSS_SRT__c> mapStepIdtoSrt;
mapStepIdtoSrt.put('abc',srt1);
mapStepIdtoSrt.put('abc1',srt2);*/
        
        
        jobplan.showErrorBMS = false;
        //jobplan.onChangeOfUnitNumber();
        Jobplan.bmsUserCloseFlag = true;
        jobplan.dsidStatus = true;
        Jobplan.countquote=0;
        //jobplan.isPrioritized = true;
        jobPlan.showJobPlanBlocks(true,false,true, false,false,false,false);
        //jobplan.faultCodes= lstFc;
        //jobplan.getFaultCodes();
        jobPlan.jobplan_prt();
        jobPlan.jobplan_war();
        jobPlan.jobplan_jpq();
        pref = jobPlan.jobplan_jo();
        jobPlan.jobplan_srt();
        //jobPlan.callWOComment();
        jobPlan.updateservjob();
        jobPlan.Cancel();
        CSS_OverlapSRTResponse overLap=new CSS_OverlapSRTResponse();
        //  jobPlan.createOverLapSrtList(overLap);
        jobPlan.populateMap(JO);
        //  jobPlan.loadRequestData();
        jobPlan.sendSRTsToBMS('testing','testing');
        CSS_jobPlanInboundJSON2Apex jobPlanRespWO = new CSS_jobPlanInboundJSON2Apex();
        jobPlan.sendSRTsToBMSWOQT('testing');
        jobPlan.sendSRTsToBMSWO();
        Test.stopTest();            
        
    }
    
    static testmethod void testSRTjobplancon27(){
        
        Account a = new account();
        a.name='Testing';
        a.BMS_Enabled__c=true;
        a.IAM_Service_Provider_Code__c='56255';
        a.CSS_DistributorCode__c='56255';
        a.IAM_Service_Provider_Code__c = '56255';
        a.Type = 'Customer';
        a.IAM_Service_Provider_Code__c = '56270';
        a.CMI_Account_Status__c = 'Active';
        insert a;
        
        css_job_order__c jo = CSS_TestData.createJobOrder(false);
        jo.ESN__c='58675876';
        jo.Customer_Name__c='TestUser';
        jo.Customer_Code__c='123';
        jo.Status__c='Job Plan';
        //jo.CSS_Job_Location_Code__c ='56255-56255';
        jo.Account__c = a.id;
        jo.Shop_Work_Order__c='123';
        
        insert jo;
    
    CSS_UserLocation__c userloc = new CSS_UserLocation__c();
        
        userloc.Location_code__c='56255-56255';
        insert userloc;
        css_solutions__c sol2 = new css_solutions__c();
        sol2.Service_Job__c=jo.Id;
        sol2.Diagnostic_Response__c='Most likely the solution';
        insert sol2;
        
        css_srt__c srt = new css_srt__c();
        srt.CSS_Claims__c=null;
        srt.Job_Order__c=jo.Id;
        srt.Step_Id__c='1';
        srt.SRT_ID__c='00-901-00';
        SRT.SRT_Title__c='Non-SRT detail';
        srt.Type__c='Field Action';
        srt.SRT_AccessiblityCheck__c=true;
        srt.SRT_Estimate__c=false;
        srt.SRT_Category__c='AdditionalDiag';
        srt.Solution_Number__c=sol2.id;
        
        insert srt;
        //siva
        css_job_order__c jo1=[select id,name,(select id,Step_Id__c,Job_Order__c,SRT_ID__c,SRT_Title__c,Type__c from CSS_SRTS__r) from css_job_order__c];
        apexpages.currentPage().getparameters().put('id',jo.Id);
        apexpages.currentPage().getparameters().put('status','Job Plan');
        string json='{ "Header": { "ReturnCodeDescription": "<Message from SRT>", "ReturnCode": "<MessageCode from SRT>", "MessageIdentifier": "Identifier from MW" }, "DataArea": { "TotalOverlapHours": 5.5, "TotalAdjustedHours": 0.5, "OverlapSRTTime": [ { "SRTNumber": "11", "OverlapHrs": 1, "SRTTitle": "SRTTitle", "OverlapStepId": 5, "OverlapSRTNumber": "0.5", "StepId": 1, "OverlapSRTTitle": "1.5" } ], "Steps": [ { "TotalOverlapHours": [ { "SRTNumber": "11-111-11", "OverlapHrs": 1.5 }, { "SRTNumber": "12-121-12", "OverlapHrs": 3 } ], "StepId": 1, "SRTHours": 2.5, "SRTAdjustedHours": 0.5, "Qty": 2, "AccessCode": "R" } ] } }';
        CSS_OverlapSRTResponse bc = CSS_OverlapSRTResponse.parse(json);
        system.debug('BC>>'+bc);
        
        test.startTest();
        CSS_JobPlanSRTController jobcon = new CSS_JobPlanSRTController();
        jobcon.sendSRTsToBMS('WO','123'); 
        jobcon.sendSRTsToBMSWOQT('WOQT');
        jobcon.sendSRTsToBMS('WO',null);
        jobcon.sendSRTsToBMSWOQT('null');
        jobcon.workJob=null;
        jobcon.sendSRTsToBMS('WO','123');     
        jobcon.sendSRTsToBMSWOQT('WOQT');
        test.stopTest();
    }
    
    static testmethod void testSRTjobplancon314(){
        
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02466';
        acc.IAM_Service_Provider_Code__c='19134';
        acc.Type='Dealer Account';
        acc.CMI_Account_Status__c = 'Active';
        insert acc;
        
        css_job_order__c jo = new css_job_order__c();
        jo.ESN__c='58675876';
        jo.Customer_Name__c='TestUser';
        jo.Customer_Code__c='123';
        jo.Status__c='Job Plan';
        jo.CSS_Job_Location_Code__c ='56255-56255';
        jo.Shop_Work_Order__c='123';
        jo.Account__c = acc.id;
        insert jo;
        
        css_claims__c claim = new css_claims__c();
        claim.CSS_Job__c=jo.id;
        claim.AccessCode__c='Test';
        claim.EditCause__c='Testing';
        claim.EditComplaint__c='Testing';
        claim.EditCorrection__c='Testing';
        claim.EditCoverage__c='Testing';
        claim.JobEditCause__c='Testing';
        claim.JobEditComplaint__c='Testing';
        claim.JobEditCorrection__c='Testing';
        claim.JobEditCoverage__c='Testing';
        insert claim;
        
        
        CSS_UserLocation__c userloc = new CSS_UserLocation__c();
        
        userloc.Location_code__c='56255-56255';
        insert userloc;
        css_solutions__c sol2 = new css_solutions__c();
        sol2.Service_Job__c=jo.Id;
        sol2.Diagnostic_Response__c='Most likely the solution';
        insert sol2;
        
        List<css_srt__c> srtlst = new List<css_srt__c>();
        
        css_srt__c srt = new css_srt__c();
        srt.CSS_Claims__c=claim.id;
        srt.Job_Order__c=jo.id;
        srt.Claim_Type__c = null;
        srt.Step_Id__c='1';
        srt.SRT_ID__c='901';
        SRT.SRT_Title__c='Non-SRT detail';
        srt.Type__c='Private';
        srt.SRT_AccessiblityCheck__c=true;
        srt.SRT_Estimate__c=false;
        srt.SRT_Category__c='AdditionalDiag';
        srt.Solution_Number__c=sol2.id;
        srt.SRT_Notes__c = '123';
        //insert srt;
        
        css_srt__c srt1 = new css_srt__c();
        srt1.CSS_Claims__c=claim.id;
        srt1.Job_Order__c=jo.id;
        srt1.Claim_Type__c = null;
        srt1.Step_Id__c='1';
        srt1.SRT_ID__c='901';
        srt1.SRT_Title__c='Non-SRT detail';
        srt1.Type__c='Private';
        srt1.SRT_AccessiblityCheck__c=true;
        srt1.SRT_Estimate__c=false;
        srt1.SRT_Category__c='AdditionalDiag';
        srt1.Solution_Number__c=sol2.id;
        srt1.SRT_Notes__c = '123';
        
        //insert srt1;
       
        //srtlst.add(srt)  ;
        //srtlst.add(srt1);
        
        css_job_order__c jo1=[select id,name,(select id,Step_Id__c,Job_Order__c,SRT_ID__c,SRT_Title__c,Type__c from CSS_SRTS__r) from css_job_order__c];
        apexpages.currentPage().getparameters().put('id',jo.Id);
        apexpages.currentPage().getparameters().put('status','Job Plan');
        string json='{ "Header": { "ReturnCodeDescription": "<Message from SRT>", "ReturnCode": "<MessageCode from SRT>", "MessageIdentifier": "Identifier from MW" }, "DataArea": { "TotalOverlapHours": 5.5, "TotalAdjustedHours": 0.5, "OverlapSRTTime": [ { "SRTNumber": "11", "OverlapHrs": 1, "SRTTitle": "SRTTitle", "OverlapStepId": 5, "OverlapSRTNumber": "0.5", "StepId": 1, "OverlapSRTTitle": "1.5" } ], "Steps": [ { "TotalOverlapHours": [ { "SRTNumber": "11-111-11", "OverlapHrs": 1.5 }, { "SRTNumber": "12-121-12", "OverlapHrs": 3 } ], "StepId": 1, "SRTHours": 2.5, "SRTAdjustedHours": 0.5, "Qty": 2, "AccessCode": "R" } ] } }';
        CSS_OverlapSRTResponse bc = CSS_OverlapSRTResponse.parse(json);
        system.debug('BC>>'+bc);
        
        test.startTest();
        CSS_JobPlanSRTController jobcon = new CSS_JobPlanSRTController();
        jobcon.sendSRTsToBMS('WO','123');       
        jobcon.sendSRTsToBMSWOQT('WOQT');
        test.stopTest();
    }
    
    static testmethod void testSRTjobplancon43() {
        Account a = new account();
        a.name='Testing';
        a.BMS_Enabled__c=true;
        //a.IAM_Service_Provider_Code__c='56255';
        a.CSS_DistributorCode__c='56255';
        a.IAM_Service_Provider_Code__c = '56255';
        a.Type = 'Customer';
        a.IAM_Service_Provider_Code__c = '56270';
        a.CMI_Account_Status__c = 'Active';
        insert a;
        
        css_job_order__c jo = new css_job_order__c();
        jo.ESN__c='58675876';
        jo.Customer_Name__c='TestUser';
        jo.Customer_Code__c='123';
        jo.Status__c='Job Plan';
        jo.CSS_Job_Location_Code__c ='56255-56255';
        jo.Shop_Work_Order__c='123';
        jo.Account__c = a.id;
        insert jo;
        
        css_claims__c claim = new css_claims__c();
        claim.CSS_Job__c=jo.id;
        claim.AccessCode__c='Test';
        claim.EditCause__c='Testing';
        claim.EditComplaint__c='Testing';
        claim.EditCorrection__c='Testing';
        claim.EditCoverage__c='Testing';
        claim.JobEditCause__c='Testing';
        claim.JobEditComplaint__c='Testing';
        claim.JobEditCorrection__c='Testing';
        claim.JobEditCoverage__c='Testing';
        insert claim;
        
     CSS_UserLocation__c userloc = new CSS_UserLocation__c();
        
        userloc.Location_code__c='56255-56255';
        insert userloc;
        css_solutions__c sol2 = new css_solutions__c();
        sol2.Service_Job__c=jo.Id;
        sol2.Diagnostic_Response__c='Most likely the solution';
        insert sol2;
        
        css_srt__c srt = new css_srt__c();
        srt.CSS_Claims__c=claim.id;
        srt.Job_Order__c=jo.id;
        srt.Claim_Type__c = null;
        srt.Step_Id__c='1';
        srt.SRT_ID__c='901';
        SRT.SRT_Title__c='Non-SRT detail';
        srt.Type__c='Custom';
        srt.Account_Code__c = '123';
        srt.SRT_AccessiblityCheck__c=true;
        srt.SRT_Estimate__c=false;
        srt.SRT_Category__c='AdditionalDiag';
        srt.Solution_Number__c=sol2.id;
        srt.SRT_Notes__c = '123';
        
        //insert srt;
        //siva
        css_job_order__c jo1=[select id,name,(select id,Step_Id__c,Job_Order__c,SRT_ID__c,SRT_Title__c,Type__c from CSS_SRTS__r) from css_job_order__c];
        apexpages.currentPage().getparameters().put('id',jo.Id);
        apexpages.currentPage().getparameters().put('status','Job Plan');
        string json='{ "Header": { "ReturnCodeDescription": "<Message from SRT>", "ReturnCode": "<MessageCode from SRT>", "MessageIdentifier": "Identifier from MW" }, "DataArea": { "TotalOverlapHours": 5.5, "TotalAdjustedHours": 0.5, "OverlapSRTTime": [ { "SRTNumber": "11", "OverlapHrs": 1, "SRTTitle": "SRTTitle", "OverlapStepId": 5, "OverlapSRTNumber": "0.5", "StepId": 1, "OverlapSRTTitle": "1.5" } ], "Steps": [ { "TotalOverlapHours": [ { "SRTNumber": "11-111-11", "OverlapHrs": 1.5 }, { "SRTNumber": "12-121-12", "OverlapHrs": 3 } ], "StepId": 1, "SRTHours": 2.5, "SRTAdjustedHours": 0.5, "Qty": 2, "AccessCode": "R" } ] } }';
        CSS_OverlapSRTResponse bc = CSS_OverlapSRTResponse.parse(json);
        system.debug('BC>>'+bc);
        
        test.startTest();
        CSS_JobPlanSRTController jobcon = new CSS_JobPlanSRTController();
        jobcon.sendSRTsToBMS('WO','123');       
        jobcon.sendSRTsToBMSWOQT('WOQT');
        CSS_JobPlanSRTController.overLapSrtWrapper overlapsrt = new CSS_JobPlanSRTController.overLapSrtWrapper();
        test.stopTest();
    }
    static testmethod void extended(){
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02466';
        acc.IAM_Service_Provider_Code__c='19134';
        acc.Type='Dealer Account';
        acc.CMI_Account_Status__c = 'Active';
        insert acc;
        
        CSS_Job_Order__c JO = new CSS_Job_Order__c(); 
        JO.Account__c = acc.id;
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
        JO.Unit_Number__c = 'test123';
        Jo.Assigned_To__c = UserInfo.getUserId();
        //JO.Additional_Tech1__c = userids[0].id;
       // JO.Additional_Tech2__c = userids[1].id;
        Jo.esn__c='1234';
        JO.Equipment_ID__c = 'EQ7667';
        JO.Qsol_Engine_Family_Code__c ='56';
        JO.AccessCode__c = 'A';
        JO.BMSWSStatus__c = 'UI';
        JO.BMSStatus__c = 'IUU';
        insert(JO);      
        PageReference pref;
        pref = new PageReference('/'+JO.id);
        pref.getParameters().put('id',JO.id);
        
        Test.setCurrentPage(pref);
        
        CSS_JobPlanSRTController jobPlan= new CSS_JobPlanSRTController();

        CSS_Solutions__c sol1 = new CSS_Solutions__c();
       // sol1.FaultCode__c = fc1.Id;
       // sol1.Service_Job__c = jobOrder.Id;
        sol1.Name = 'Sample Case Name';
        sol1.Case_Name__c = 'Sample Case Name';
        sol1.Solution_Title__c = 'Sample Title';
        sol1.Rank__c =0;
        sol1.Service_Job__c=Jo.id;
        //sol1.FSL_Service_Job__c=JO.id;
        insert sol1; 
        
        CSS_SRT__C srtoverlp = new CSS_SRT__C();
        srtoverlp.Solution_Number__c = sol1.id;
        srtoverlp.Job_Order__c = JO.id;
        srtoverlp.SRT_Quantity__c =2;
        srtoverlp.SRT_Warrantable__c ='3';
        srtoverlp.SRT_AccessiblityCheck__c=True;
        srtoverlp.SRT_Time__c = 1.1;
        srtoverlp.name = 'Test';
        srtoverlp.Type__c = 'Overlap';
        srtoverlp.SRT_ID__c = '00-11';
        insert srtoverlp;
        //siva
        CSS_SRT__C srtDiagAccess = new CSS_SRT__C();
        srtDiagAccess.Solution_Number__c = sol1.id;
        srtDiagAccess.Job_Order__c = JO.id;
        srtDiagAccess.SRT_Quantity__c =2;
        srtDiagAccess.SRT_Warrantable__c ='3';
        srtDiagAccess.SRT_AccessiblityCheck__c=True;
        srtDiagAccess.SRT_Time__c = 1.1;
        srtDiagAccess.name = 'Test';
        srtDiagAccess.Type__c = 'Diag Access';
        srtDiagAccess.SRT_ID__c = '00-11';
        insert srtDiagAccess;
        
         CSS_SRT__C srtDiagAccess1 = new CSS_SRT__C();
        srtDiagAccess1.Solution_Number__c = sol1.id;
        srtDiagAccess1.Job_Order__c = JO.id;
        srtDiagAccess1.SRT_Quantity__c =2;
        srtDiagAccess1.SRT_Warrantable__c ='3';
        srtDiagAccess1.SRT_AccessiblityCheck__c=True;
        srtDiagAccess1.SRT_Time__c = 1.1;
        srtDiagAccess1.name = 'Test';
        srtDiagAccess1.Type__c = 'Diagnosis';
        srtDiagAccess1.SRT_ID__c = '00-11';
        insert srtDiagAccess1;
         CSS_SRT__C srt = new CSS_SRT__C();
        srt.Solution_Number__c = sol1.id;
        srt.Job_Order__c = JO.id;
        srt.SRT_Quantity__c =2;
        srt.SRT_Warrantable__c ='3';
        srt.SRT_AccessiblityCheck__c=True;
        srt.SRT_Time__c = 1.1;
        srt.name = 'Test';
        srt.Type__c = 'Access';
        srt.SRT_ID__c = '00-11';
        insert srt;
        
        CSS_SRT__C srt1 = new CSS_SRT__C();
        srt1.Solution_Number__c = sol1.id;
        srt1.Job_Order__c = JO.id;
        srt1.SRT_Quantity__c =2;
        srt1.SRT_Warrantable__c ='3';
        srt1.SRT_AccessiblityCheck__c=True;
        srt1.SRT_Time__c = 1.1;
        srt1.name = 'Test';
        srt1.Type__c = '99Time';
        srt1.SRT_ID__c = '00-11';
        insert srt1;
        jobPlan.jobPlanSRTAction();
        
        list<CSS_Solutions__c> solListSol = new list<CSS_Solutions__c>();
        CSS_Solutions__c cssSol ;
        cssSol = new CSS_Solutions__c();
        cssSol.Name = 'Test Solution';
        cssSol.service_job__c = JO.id;
        cssSol.Out_Of_Order__c = true;
        cssSol.Diagnostic_Response__c = 'Most likely the solution';
        //cssSol.Repair_Response__c= 'Repair Successful.';
        solListSol.add(cssSol);
        CSS_Solutions__c cssSol2 ;
        cssSol2 = new CSS_Solutions__c();
        cssSol2.Name = 'Test Solution1';
        cssSol2.service_job__c = JO.id;
        cssSol2.Out_Of_Order__c = true;
        cssSol2.Diagnostic_Response__c = 'Most likely the solution';
        
        solListSol.add(cssSol2);
        insert solListSol;
   }
    
static testmethod void onChangeOfUnitNumberMethod(){
     //Test.setMock(HttpCalloutMock.class, new CSS_CustOutBoundMock1());
   
    Test.setMock(HttpCalloutMock.class, new CG_CallUnitInboundMock_Test());
    Id currentUserID=UserInfo.getUserId();
        //list<user> userids = [select id,name from user limit 3]; 
        
        //Add test data for Service job order
        CSS_Job_Order__c JO = new CSS_Job_Order__c();
        JO.Customer_Name__c = 'Rajesh';
        JO.Application_Desc__c='AUTOMOTIVE';
        JO.ApplicationCode__c='130';
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
        JO.Unit_Number__c = 'test123';
        Jo.Assigned_To__c = UserInfo.getUserId();
        JO.Additional_Tech1__c =  UserInfo.getUserId();//userids[0].id;
        JO.Additional_Tech2__c =  UserInfo.getUserId();//userids[1].id;
        JO.CSS_Job_Location_Code__c='56270-56255';
        Jo.esn__c='1234';
        JO.Equipment_ID__c = 'EQ7667';
        JO.Qsol_Engine_Family_Code__c ='56';
        JO.AccessCode__c = 'A';
        JO.BMSWSStatus__c = 'UI';
        JO.BMSStatus__c = 'WC1';
        JO.CSS_Resolution__c='TEST';
        JO.chevron_page__c='srt';
        JO.Customer_Code__c ='8989';
        JO.Unit_Type__c = 'inshop';
        insert JO;     
        CSS_Job_Order__c JO1 = new CSS_Job_Order__c();
        JO1.Unit_Number__c='65432';
        JO1.Id=JO.Id;
        update JO1;
      /*  String custCode;
        String unitNumber;
        String unitDescription;
        String model;
        String VIN;
        String make;
        String application;
        String serviceModelName;
        String ESN;
        String engineFamily;
    //    String applicationCode;
        String applicationCode = '210';
        String location;
        String distanceType;
        String distance = 'DIST';
        String hours;
        String failureDate;
        String WarrantyStartDate;
        String jsonResponseBody;
        Http h1 = new Http();
        HttpResponse res1;
        HttpRequest req1 = new HttpRequest();
        // res1 = h1.send(req1);
        //c.BMS_Claim_ReqJSON__c='';
        
         Test.startTest();
        CSS_JobPlanSRTController obj = new CSS_JobPlanSRTController();
        obj.workJob = [Select Id,Name,AccessCode__c,Customer_Name__c,Shop_Work_Order__c, Application__c, Application_Desc__c, BMS_Last_Name__c, DSID_WorkGroup__c, Unit_Number__c, Date_in__c, INSITE_UpdateTimeStamp__c, First_Name__c,
                           Repair_Location__c,Failure_Date__c, Failure_Point__c, Failure_Point_Measure__c, Service_Model__c, VIN__c,BMSStatus__c,Unit_Type__c, Warranty_Start_Date__c,Make__c, Qsol_Engine_Family_Code__c,
                           DSID__c, DSID_Creation_Timestamp__c, DSID_Status__c, Repeat_Or_Recent_Calc__c, DSID_UpdateTimestamp__c,Customer_Code__c,Status__c,
                           Phone_Number__c, Previous_Status__c,Sub_Type__c, Category__c, Complaint_Type__c, Model__c,Creator_Location__c, Control_Number__c,
                           Assigned_to__r.Name,Additional_Tech1__r.Name,Additional_Tech2__r.Name,OwnerId,JobLocation__c,CSS_Resolution__c,CSS_Feedback_Comments__c,BMSWSStatus__c,EditCoverage__c,EditComplaint__c,
                           ESN__c, Mileage__c, Mileage_Measure__c, chevron_page__c,General_Symptoms__c, Assigned_To__c, LastModifiedDate,CreatedDate,ESN_Locked__c,Region__c,Territory__c
                           from CSS_Job_Order__c where id= :JO.id];
        ApexPages.currentPage().getParameters().put('id',JO.Id);
        obj.mainSOQL();
        obj.onChangeOfUnitNumber();
        obj.callUnitInboundGeneric();
        CSS_WS_BMS.callUnitInbound(JO.Customer_Code__c,JO.Unit_Number__c,JO.Unit_Type__c ,JO.Model__c,JO.VIN__c,JO.Make__c,JO.Service_Model__c,JO.ESN__c,JO.Qsol_Engine_Family_Code__c,'ApplicationCode',JO.Creator_Location__c,JO.Mileage_Measure__c,string.valueof(JO.Mileage__c),string.valueof(JO.CSS_Hours__c),failureDate,failureDate,JO.AccessCode__c);
        
    //obj.onChangeOfUnitNumber();
    //obj.callUnitInboundGeneric();
    Test.stopTest();*/
    CSS_List_Of_Values__c CLV = new CSS_List_Of_Values__c();
            CLV.Picklist_Values_1__c = 'AUTOMOTIVE';
            CLV.type__c = 'Application Code';
            CLV.Name = 'getEngine'; 
            CLV.code__C = '130';
            insert CLV;
     CSS_Integration_Details__c cid = CSS_TestData.createIntegrationDetails(false);
        cid.name = 'BMS';
        cid.ApplicationName__c = 'BMS';
        cid.End_Point__c = 'https://services-test.cummins.com/css/';
        insert cid;
    
    CSS_JobPlanSRTController obj = new CSS_JobPlanSRTController();
    Test.startTest();
    obj.workJob = JO;
         //obj.onChangeOfUnitNumber();
        //obj.callUnitInboundGeneric();
    Test.stopTest();
}
   
 
    
    static testmethod void jobPlanControllertestmethodSaveandCloseJob(){
        
        
        
        CSS_JobPlanSRTController jobPlan= new CSS_JobPlanSRTController();
        jobPlan.complaintcounter=2;
        jobPlan.coveragecounter=2;
        jobPlan.causecounter=2;
        jobPlan.correctioncounter=2;
        jobPlan.timemin=2;
        jobPlan.timeminov=2;
        jobPlan.TotalOverlapHours=2;
        jobPlan.TotalAdjustedHours=2;
        jobPlan.overlapErrorMsg='Test23';
        
        CSS_JobPlanSRTController.overLapSrtWrapper OvpW=new  CSS_JobPlanSRTController.overLapSrtWrapper();
        OvpW.overide=true;
        ovpW.OverlapSRTTime =10;
        ovpw.SRT_Code ='90';
        ovpW.SRT_Description ='Test';
        ovpW.SRT_Notes ='Test';
        ovpw.SRT_Overlap =89;
        ovpw.SRT_OverrideReason ='Test';
        ovpw.SRT_Time ='19';
        ovpw.Id ='243536';
        List<CSS_JobPlanSRTController.overLapSrtWrapper> LstJP=new List<CSS_JobPlanSRTController.overLapSrtWrapper>();
        jobPlan.lstOverLapSrt=null;
        Id currentUserID=UserInfo.getUserId();
        //list<user> userids = [select id,name from user limit 3];
        
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02466';
        acc.IAM_Service_Provider_Code__c='19134';
        acc.Type='Dealer Account';
        acc.CMI_Account_Status__c = 'Active';
        insert acc;
        
        //Add test data for Service job order
        CSS_Job_Order__c JO = new CSS_Job_Order__c();
        JO.Account__c = acc.id;
        JO.Customer_Name__c = 'Test';
        JO.Customer_Code__c=null;
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
        JO.Unit_Number__c = 'test123';
        Jo.Assigned_To__c = UserInfo.getUserId();
        JO.Additional_Tech1__c =  UserInfo.getUserId();//userids[0].id;
        JO.Additional_Tech2__c =  UserInfo.getUserId();//userids[1].id;
        Jo.esn__c='1234';
        JO.Equipment_ID__c = 'EQ7667';
        JO.Qsol_Engine_Family_Code__c ='56';
        JO.AccessCode__c = 'A';
        JO.BMSWSStatus__c = 'UI';
        JO.Unit_Number__c = '12345';
        JO.Shop_Work_Order__c='12345';
        JO.EditCoverage__c = 'Test';
        JO.EditComplaint__c = 'Test';
        JO.EditCorrection__c = 'TEST';
        JO.EditCause__c = 'TEST';
        JO.BMSStatus__c = 'UII';
        JO.chevron_page__c='srt';
        JO.CSS_Resolution__c='Solved';
        JO.Customer_Code__c ='8989';
        JO.Shop_Work_Order__c='Test78';
        insert(JO);      
        
        JobPlan.workJob = [Select Id,Name,AccessCode__c,Customer_Name__c,Shop_Work_Order__c, Application__c, Application_Desc__c, BMS_Last_Name__c, DSID_WorkGroup__c, Unit_Number__c, Date_in__c, INSITE_UpdateTimeStamp__c, First_Name__c,
                           Repair_Location__c,Failure_Date__c, Failure_Point__c, Failure_Point_Measure__c, Service_Model__c, VIN__c,BMSStatus__c,Unit_Type__c, Warranty_Start_Date__c,Make__c, Qsol_Engine_Family_Code__c,
                           DSID__c, DSID_Creation_Timestamp__c, DSID_Status__c, Repeat_Or_Recent_Calc__c, DSID_UpdateTimestamp__c,Customer_Code__c,Status__c,
                           Phone_Number__c, Previous_Status__c,Sub_Type__c, Category__c, Complaint_Type__c, Model__c,Creator_Location__c, Control_Number__c,
                           Assigned_to__r.Name,Additional_Tech1__r.Name,Additional_Tech2__r.Name,OwnerId,JobLocation__c,CSS_Resolution__c,CSS_Feedback_Comments__c,BMSWSStatus__c,EditCoverage__c,EditComplaint__c,
                           ESN__c, Mileage__c, Mileage_Measure__c, chevron_page__c,General_Symptoms__c, Assigned_To__c, LastModifiedDate,CreatedDate,ESN_Locked__c,Region__c,Territory__c
                           from CSS_Job_Order__c where id= :JO.id];
        
        /*PageReference p=Page.CSS_Jobplan; 
Test.setCurrentPage(p);  */
        ApexPages.currentPage().getParameters().put('id',jo.Id);         
        
        CSS_Fault_Code__c fc1 = new CSS_Fault_Code__c(FaultCodeR2__c = '441',Related_Fault_Code__c = '234,546');
        fc1.Name = '441';
        fc1.Job_Order__c = JO.Id;
        fc1.Sequence__c = 1;
        fc1.Fault_Code_Type__c = 'APD-P';
        fc1.Mod__c = '0';
        fc1.isPole__c = false;
        insert fc1;
        List<CSS_Fault_Code__c> lstFC1 = new List<CSS_Fault_Code__c>();
        lstFC1.add(fc1);
        
        CSS_Solutions__c sol1 = new CSS_Solutions__c();
        sol1.FaultCode__c = fc1.Id;
        sol1.Service_Job__c = JO.Id;
        sol1.Name = 'Sample Case Name';
        sol1.Case_Name__c = 'Sample Case Name';
        sol1.Solution_Title__c = 'Sample Title';
        sol1.Rank__c =0;
        sol1.Diagnostic_Response__c = 'Most likely the solution';
        sol1.Repair_Response__c ='Repair not performed';
        //sol1.Repair_Response__c='Repair Successful.';
        insert sol1;
          CSS_Solutions__c sol11 = new CSS_Solutions__c();
        sol11.FaultCode__c = fc1.Id;
        sol11.Service_Job__c = JO.Id;
        sol11.Name = 'Sample Case Name';
        sol11.Case_Name__c = 'Sample Case Name';
        sol11.Solution_Title__c = 'Sample Title';
        sol11.Rank__c =0;
        sol11.Diagnostic_Response__c = 'Most likely the solution';
        sol11.Repair_Response__c ='';
        //sol1.Repair_Response__c='Repair Successful.';
        insert sol11;
        
        CSS_Solution_Component__c csc=new CSS_Solution_Component__c();
        csc.Action__c='test';
        csc.Solutions__c=sol1.id;
        csc.Service_Job__c=JO.id;
        csc.Selected_Component__c = true;
        csc.Performed__c = true;
         csc.Performed_Review__c = true;
        csc.AccountCodeEdit__c='test';
        csc.Fail_Code_Editable__c='test';
        insert csc;
        
        css_srt__c srt = new css_srt__c();
        
        srt.Solution_Number__c = sol1.id;
        srt.SRT_AccessiblityCheck__c=True;
        srt.SRT_Time__c = 65;
        srt.Job_Order__c = JO.id;
        srt.isPerformed__c = true;
        srt.name = 'Test';
        srt.SRT_Type__c = 'Repair';
        srt.SRT_ID__c = '00-11';
        // insert srt;
        
        css_srt__c srt1 = new css_srt__c();
        srt1.Solution_Number__c = sol1.id;
        srt1.SRT_AccessiblityCheck__c=True;
        srt1.SRT_Time__c = 65;
        srt1.Job_Order__c = JO.id;
        srt1.name = 'Test';
        srt1.isPerformed__c = true;
        srt1.SRT_Type__c = 'Repair';
        srt1.SRT_ID__c = '00-11';
        //insert srt1;
        
        css_srt__c srt3 = new css_srt__c();
        srt3.Solution_Number__c = sol1.id;
        srt3.SRT_AccessiblityCheck__c=True;
        srt3.SRT_Time__c = 1.1;
        srt3.Job_Order__c = JO.id;
        srt3.name = 'Test';
        // srt3.isPerformed__c = true;
        srt3.SRT_Type__c = 'Overlap';
        srt3.SRT_ID__c = '00-11';
        insert srt3;
        //siva
        CSS_SRT__C FieldAction = new CSS_SRT__C();
        FieldAction.Solution_Number__c = sol1.id;
        FieldAction.Job_Order__c = JO.id;
        FieldAction.SRT_Quantity__c =2;
        FieldAction.SRT_Warrantable__c ='3';
        FieldAction.SRT_AccessiblityCheck__c=True;
        FieldAction.SRT_Time__c = 1.1;
        FieldAction.name = 'Test';
        FieldAction.Type__c = 'Field Action';
        FieldAction.SRT_ID__c = '00-11';
        insert FieldAction;
        CSS_SRT__C srtoverlp = new CSS_SRT__C();
        srtoverlp.Solution_Number__c = sol1.id;
        srtoverlp.Job_Order__c = JO.id;
        srtoverlp.SRT_Quantity__c =2;
        srtoverlp.SRT_Warrantable__c ='3';
        srtoverlp.SRT_AccessiblityCheck__c=True;
        srtoverlp.SRT_Time__c = 1.1;
        srtoverlp.name = 'Test';
        srtoverlp.Type__c = 'Overlap';
        srtoverlp.SRT_ID__c = '00-11';
        insert srtoverlp;
        jobPlan.jobPlanSRTAction();
        CSS_SRT__C srtDiagAccess = new CSS_SRT__C();
        srtDiagAccess.Solution_Number__c = sol1.id;
        srtDiagAccess.Job_Order__c = JO.id;
        srtDiagAccess.SRT_Quantity__c =2;
        srtDiagAccess.SRT_Warrantable__c ='3';
        srtDiagAccess.SRT_AccessiblityCheck__c=True;
        srtDiagAccess.SRT_Time__c = 1.1;
        srtDiagAccess.name = 'Test';
        srtDiagAccess.Type__c = 'Repair Access';
        srtDiagAccess.SRT_ID__c = '00-11';
        insert srtDiagAccess;
        
       
        List<css_srt__c> lstSRT = new List<css_srt__c>();
        lstSRT.add(srt);
        lstSRT.add(srt1);
        // lstSRT.add(srt2);
        lstSRT.add(srt3);
        
        CSS_Quote__c qt = new CSS_Quote__c(); 
        qt.AcceptQuote__c = true;
        qt.QuoteTotal__c = 1000;
        qt.Service_Job__c = JO.id;
        
        list<Attachment> attachmentList = new list<Attachment>();
        // Add test file for attachment            
        
        Attachment attach=new Attachment();    
        attach.Name='Unit Test Attachment';
        Blob bodyBlob1=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob1;
        attach.parentId=jo.id;
        attachmentList.add(attach);
        
        Attachment attach1=new Attachment();    
        attach1.Name='Unit Test Attachment1';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body1');
        attach1.body=bodyBlob;
        attach1.parentId=jo.id;
        
        insert attach;
        
        CSS_accountLanguage__c accntLang = new CSS_accountLanguage__c();
        accntLang.name = 'en';
        accntLang.CSS_QsolLanguage__c = 'en';
        accntLang.CSS_userLanguage__c = 'en';
        accntLang.CSS_EDSLanguage__c = 'en';
        insert(accntLang);
        
        Id recTypeIdoption = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'Options');
        Id recTypeIdpart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'Parts');
        
        CSS_Solution_Component__c comp = new CSS_Solution_Component__c();
        
        comp.Component_Id__c = 'Fooo1';
        comp.Service_Job__c = JO.Id;
        insert comp;
        
        CSS_Parts_Options__c parts = new CSS_Parts_Options__c();
        parts.recordtypeId = recTypeIdpart;
        parts.Option_Number__c = 'O-111';
        parts.Service_Job__c = Jo.Id;
        parts.selected_part__c = true;
        parts.FailurepartId__c = comp.Id;
        insert parts;
        
        /*CSS_CampTsbTrp__c x1 = new CSS_CampTsbTrp__c();
x1.Job_order__c = Jo.Id;
x1.performed_review__c = true;
x1.performed__c =false;
insert x1;*/
        
        
        jobplan.Wid = Jo.Id;
        jobplan.comm = 'sample';
        Note x2 = new Note();
        x2.Title = 'CAMPCOMMENTS';
        x2.ParentId = jobplan.Wid; 
        x2.Body =  jobplan.comm;
        insert x2;
        
        jobplan.NotesBody = 'sample';
        jobplan.show_war_pnl = true;
        jobplan.showResolution = true;
        jobplan.showRepairs = true;
        jobplan.nocamptsbtrps = true;
        jobPlan.accQuoteFlag = true;
        jobplan.showResolutionWithRepair = false;
        jobPlan.showRepairErrorMessage = true;
        jobPlan.requiredBMSMessage = true;
        //jobPlan.bmsEnabled=TRUE;
        //Attachment attach;
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Miles',system.Label.CSS_Miles));
        options.add(new SelectOption('Kilometers',system.Label.CSS_Kilometers)); 
        Test.startTest();
         jobPlan.jobPlanSRTAction();
        jobPlan.savecheckbox();
        jobPlan.updatestatus();
        jobPlan.closeSession();
       jobPlan.updateservjob();
        jobPlan.closeSession_close();
        jobPlan.jobClosePopup();
             jobplan.show_war_pnl = true;
        jobplan.showResolution = true;
        jobplan.showRepairs = true;
        jobplan.nocamptsbtrps = true;
        jobPlan.accQuoteFlag = true;
        jobplan.showResolutionWithRepair = false;
        jobPlan.showRepairErrorMessage = true;
        jobPlan.requiredBMSMessage = true;
        jobplan.saveAndCloseJob();
        jobPlan.pgsave();

        
        
        jobplan.BMSSuccessWOQTMsg='';
        //   pageReference pref = jobplan.saveAndCloseJob();
        Test.stopTest();
    } 
    
    static testmethod void jobPlanControllertestmethodSaveandCloseJob1(){
        
      
        
        CSS_JobPlanSRTController jobPlan= new CSS_JobPlanSRTController();
        jobPlan.complaintcounter=2;
        jobPlan.coveragecounter=2;
        jobPlan.causecounter=2;
        jobPlan.correctioncounter=2;
        jobPlan.timemin=2;
        jobPlan.timeminov=2;
        jobPlan.TotalOverlapHours=2;
        jobPlan.TotalAdjustedHours=2;
        jobPlan.overlapErrorMsg='Test23';
        
        CSS_JobPlanSRTController.overLapSrtWrapper OvpW=new  CSS_JobPlanSRTController.overLapSrtWrapper();
        OvpW.overide=true;
        ovpW.OverlapSRTTime =10;
        ovpw.SRT_Code ='90';
        ovpW.SRT_Description ='Test';
        ovpW.SRT_Notes ='Test';
        ovpw.SRT_Overlap =89;
        ovpw.SRT_OverrideReason ='Test';
        ovpw.SRT_Time ='19';
        ovpw.Id ='243536';
        List<CSS_JobPlanSRTController.overLapSrtWrapper> LstJP=new List<CSS_JobPlanSRTController.overLapSrtWrapper>();
        jobPlan.lstOverLapSrt=null;
        Id currentUserID=UserInfo.getUserId();
        //list<user> userids = [select id,name from user limit 3];
        
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02466';
        acc.IAM_Service_Provider_Code__c='19134';
        acc.Type='Dealer Account';
        acc.CMI_Account_Status__c = 'Active';
        acc.ERP_System__c = 'One BMS';
        insert acc;
        
        //Add test data for Service job order
        CSS_Job_Order__c JO = new CSS_Job_Order__c();
        JO.Account__c = acc.id;
        JO.Customer_Name__c = 'Test';
        JO.Customer_Code__c=null;
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
        JO.Unit_Number__c = 'test123';
        Jo.Assigned_To__c = UserInfo.getUserId();
        JO.Additional_Tech1__c =  UserInfo.getUserId();// userids[0].id;
        JO.Additional_Tech2__c =  UserInfo.getUserId(); //userids[1].id;
        Jo.esn__c='1234';
        JO.Equipment_ID__c = 'EQ7667';
        JO.Qsol_Engine_Family_Code__c ='56';
        JO.AccessCode__c = 'A';
        JO.BMSWSStatus__c = 'UI';
        JO.Unit_Number__c = '12345';
        JO.Shop_Work_Order__c='12345';
        JO.EditCoverage__c = 'Test';
        JO.EditComplaint__c = 'Test';
        JO.EditCorrection__c = 'TEST';
        JO.EditCause__c = 'TEST';
        JO.BMSStatus__c = 'UII';
        JO.chevron_page__c='srt';
        JO.CSS_Resolution__c='Solved';
        JO.Customer_Code__c ='8989';
        JO.Shop_Work_Order__c='Test78';
        insert(JO);   
        
           
        
        JobPlan.workJob = [Select Id,Name,AccessCode__c,Customer_Name__c,Shop_Work_Order__c, Application__c, Application_Desc__c, BMS_Last_Name__c, DSID_WorkGroup__c, Unit_Number__c, Date_in__c, INSITE_UpdateTimeStamp__c, First_Name__c,
                           Repair_Location__c,Failure_Date__c, Failure_Point__c, Failure_Point_Measure__c, Service_Model__c, VIN__c,BMSStatus__c,Unit_Type__c, Warranty_Start_Date__c,Make__c, Qsol_Engine_Family_Code__c,
                           DSID__c, DSID_Creation_Timestamp__c, DSID_Status__c, Repeat_Or_Recent_Calc__c, DSID_UpdateTimestamp__c,Customer_Code__c,Status__c,
                           Phone_Number__c, Previous_Status__c,Sub_Type__c, Category__c, Complaint_Type__c, Model__c,Creator_Location__c, Control_Number__c,
                           Assigned_to__r.Name,Additional_Tech1__r.Name,Additional_Tech2__r.Name,OwnerId,JobLocation__c,CSS_Resolution__c,CSS_Feedback_Comments__c,BMSWSStatus__c,EditCoverage__c,EditComplaint__c,
                           ESN__c, Mileage__c, Mileage_Measure__c, chevron_page__c,General_Symptoms__c, Assigned_To__c, LastModifiedDate,CreatedDate,ESN_Locked__c,Region__c,Territory__c
                           from CSS_Job_Order__c where id= :JO.id];
        
        //PageReference p=Page.CSS_Jobplan; 
//Test.setCurrentPage(p);  
        ApexPages.currentPage().getParameters().put('id',jo.Id);         
        
        CSS_Fault_Code__c fc1 = new CSS_Fault_Code__c(FaultCodeR2__c = '441',Related_Fault_Code__c = '234,546');
        fc1.Name = '441';
        fc1.Job_Order__c = JO.Id;
        fc1.Sequence__c = 1;
        fc1.Fault_Code_Type__c = 'APD-P';
        fc1.Mod__c = '0';
        fc1.isPole__c = false;
        insert fc1;
        List<CSS_Fault_Code__c> lstFC1 = new List<CSS_Fault_Code__c>();
        lstFC1.add(fc1);
        
        CSS_Solutions__c sol1 = new CSS_Solutions__c();
        sol1.FaultCode__c = fc1.Id;
        sol1.Service_Job__c = JO.Id;
        sol1.Name = 'Sample Case Name';
        sol1.Case_Name__c = 'Sample Case Name';
        sol1.Solution_Title__c = 'Sample Title';
        sol1.Rank__c =0;
        sol1.Diagnostic_Response__c = 'Most likely the solution';
        sol1.Repair_Response__c ='Repair Successful';
        //sol1.Repair_Response__c='Repair Successful.';
        insert sol1;
          CSS_Solutions__c sol11 = new CSS_Solutions__c();
        sol11.FaultCode__c = fc1.Id;
        sol11.Service_Job__c = JO.Id;
        sol11.Name = 'Sample Case Name';
        sol11.Case_Name__c = 'Sample Case Name';
        sol11.Solution_Title__c = 'Sample Title';
        sol11.Rank__c =0;
        sol11.Diagnostic_Response__c = 'Most likely the solution';
        sol11.Repair_Response__c ='';
        //sol1.Repair_Response__c='Repair Successful.';
        //insert sol11;
        
        CSS_Solution_Component__c csc=new CSS_Solution_Component__c();
        csc.Action__c='test';
        csc.Solutions__c=sol1.id;
        csc.Service_Job__c=JO.id;
        csc.Selected_Component__c = true;
        csc.Performed__c = true;
         csc.Performed_Review__c = true;
        csc.AccountCodeEdit__c='test';
        csc.Fail_Code_Editable__c='test';
        insert csc;
        
        css_srt__c srt = new css_srt__c();
        
        srt.Solution_Number__c = sol1.id;
        srt.SRT_AccessiblityCheck__c=True;
        srt.SRT_Time__c = 65;
        srt.Job_Order__c = JO.id;
        srt.isPerformed__c = true;
        srt.name = 'Test';
        srt.SRT_Type__c = 'Repair';
        srt.SRT_ID__c = '00-11';
        // insert srt;
        
        css_srt__c srt1 = new css_srt__c();
        srt1.Solution_Number__c = sol1.id;
        srt1.SRT_AccessiblityCheck__c=True;
        srt1.SRT_Time__c = 65;
        srt1.Job_Order__c = JO.id;
        srt1.name = 'Test';
        srt1.isPerformed__c = true;
        srt1.SRT_Type__c = 'Repair';
        srt1.SRT_ID__c = '00-11';
        //insert srt1;
        
        css_srt__c srt3 = new css_srt__c();
        srt3.Solution_Number__c = sol1.id;
        srt3.SRT_AccessiblityCheck__c=True;
        srt3.SRT_Time__c = 1.1;
        srt3.Job_Order__c = JO.id;
        srt3.name = 'Test';
        // srt3.isPerformed__c = true;
        srt3.SRT_Type__c = 'Overlap';
        srt3.SRT_ID__c = '00-11';
        insert srt3;
        //siva
        CSS_SRT__C FieldAction = new CSS_SRT__C();
        FieldAction.Solution_Number__c = sol1.id;
        FieldAction.Job_Order__c = JO.id;
        FieldAction.SRT_Quantity__c =2;
        FieldAction.SRT_Warrantable__c ='3';
        FieldAction.SRT_AccessiblityCheck__c=True;
        FieldAction.SRT_Time__c = 1.1;
        FieldAction.name = 'Test';
        FieldAction.Type__c = 'Field Action';
        FieldAction.SRT_ID__c = '00-11';
        insert FieldAction;
        CSS_SRT__C srtoverlp = new CSS_SRT__C();
        srtoverlp.Solution_Number__c = sol1.id;
        srtoverlp.Job_Order__c = JO.id;
        srtoverlp.SRT_Quantity__c =2;
        srtoverlp.SRT_Warrantable__c ='3';
        srtoverlp.SRT_AccessiblityCheck__c=True;
        srtoverlp.SRT_Time__c = 1.1;
        srtoverlp.name = 'Test';
        srtoverlp.Type__c = 'Overlap';
        srtoverlp.SRT_ID__c = '00-11';
        insert srtoverlp;
        jobPlan.jobPlanSRTAction();
        CSS_SRT__C srtDiagAccess = new CSS_SRT__C();
        srtDiagAccess.Solution_Number__c = sol1.id;
        srtDiagAccess.Job_Order__c = JO.id;
        srtDiagAccess.SRT_Quantity__c =2;
        srtDiagAccess.SRT_Warrantable__c ='3';
        srtDiagAccess.SRT_AccessiblityCheck__c=True;
        srtDiagAccess.SRT_Time__c = 1.1;
        srtDiagAccess.name = 'Test';
        srtDiagAccess.Type__c = 'Repair Access';
        srtDiagAccess.SRT_ID__c = '00-11';
        insert srtDiagAccess;
        
        
        List<css_srt__c> lstSRT = new List<css_srt__c>();
        lstSRT.add(srt);
        lstSRT.add(srt1);
        // lstSRT.add(srt2);
        lstSRT.add(srt3);
        
        CSS_Quote__c qt = new CSS_Quote__c(); 
        qt.AcceptQuote__c = true;
        qt.QuoteTotal__c = 1000;
        qt.Service_Job__c = JO.id;
        
        list<Attachment> attachmentList = new list<Attachment>();
        // Add test file for attachment            
        
        Attachment attach=new Attachment();    
        attach.Name='Unit Test Attachment';
        Blob bodyBlob1=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob1;
        attach.parentId=jo.id;
        attachmentList.add(attach);
        
        Attachment attach1=new Attachment();    
        attach1.Name='Unit Test Attachment1';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body1');
        attach1.body=bodyBlob;
        attach1.parentId=jo.id;
        
        insert attach;
        
        CSS_accountLanguage__c accntLang = new CSS_accountLanguage__c();
        accntLang.name = 'en';
        accntLang.CSS_QsolLanguage__c = 'en';
        accntLang.CSS_userLanguage__c = 'en';
        accntLang.CSS_EDSLanguage__c = 'en';
        insert(accntLang);
        
        Id recTypeIdoption = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'Options');
        Id recTypeIdpart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'Parts');
        
        CSS_Solution_Component__c comp = new CSS_Solution_Component__c();
        
        comp.Component_Id__c = 'Fooo1';
        comp.Service_Job__c = JO.Id;
        insert comp;
        
        CSS_Parts_Options__c parts = new CSS_Parts_Options__c();
        parts.recordtypeId = recTypeIdpart;
        parts.Option_Number__c = 'O-111';
        parts.Service_Job__c = Jo.Id;
        parts.selected_part__c = true;
        parts.FailurepartId__c = comp.Id;
        insert parts;
        
       /* CSS_CampTsbTrp__c x1 = new CSS_CampTsbTrp__c();
        x1.Job_order__c = Jo.Id;
        x1.performed_review__c = true;
        x1.performed__c =false;
        insert x1; */
        
        
        jobplan.Wid = Jo.Id;
        jobplan.comm = 'sample';
        Note x2 = new Note();
        x2.Title = 'CAMPCOMMENTS';
        x2.ParentId = jobplan.Wid; 
        x2.Body =  jobplan.comm;
        insert x2;
        
        jobplan.NotesBody = 'sample';
        jobplan.show_war_pnl = true;
        jobplan.showResolution = true;
        jobplan.showRepairs = true;
        jobplan.nocamptsbtrps = true;
        jobPlan.accQuoteFlag = true;
        jobplan.showResolutionWithRepair = false;
        jobPlan.showRepairErrorMessage = true;
        jobPlan.requiredBMSMessage = true;
        //jobPlan.bmsEnabled=TRUE;
        //Attachment attach;
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Miles',system.Label.CSS_Miles));
        options.add(new SelectOption('Kilometers',system.Label.CSS_Kilometers)); 
          Test.startTest();
        jobPlan.jobPlanSRTAction();
        jobPlan.savecheckbox();
        jobPlan.updatestatus();
        jobPlan.closeSession();
       jobPlan.updateservjob();
        jobPlan.closeSession_close();
        jobPlan.jobClosePopup();
        jobplan.show_war_pnl = true;
        jobplan.showResolution = true;
        jobplan.showRepairs = true;
        jobplan.nocamptsbtrps = true;
        jobPlan.accQuoteFlag = true;
        jobplan.showResolutionWithRepair = false;
        jobPlan.showRepairErrorMessage = true;
        jobPlan.requiredBMSMessage = true;
        jobplan.saveAndCloseJob();
        jobPlan.pgsave();
        jobPlan.checkDuplicateSRTs();

        
        
        jobplan.BMSSuccessWOQTMsg='';
        //   pageReference pref = jobplan.saveAndCloseJob();
        Test.stopTest();
    } 
    
    
     static testmethod void jobPlanControllertestmethodSaveandCloseJob2(){
        
        
        
        CSS_JobPlanSRTController jobPlan= new CSS_JobPlanSRTController();
        jobPlan.complaintcounter=2;
        jobPlan.coveragecounter=2;
        jobPlan.causecounter=2;
        jobPlan.correctioncounter=2;
        jobPlan.timemin=2;
        jobPlan.timeminov=2;
        jobPlan.TotalOverlapHours=2;
        jobPlan.TotalAdjustedHours=2;
        jobPlan.overlapErrorMsg='Test23';
        
        CSS_JobPlanSRTController.overLapSrtWrapper OvpW=new  CSS_JobPlanSRTController.overLapSrtWrapper();
        OvpW.overide=true;
        ovpW.OverlapSRTTime =10;
        ovpw.SRT_Code ='90';
        ovpW.SRT_Description ='Test';
        ovpW.SRT_Notes ='Test';
        ovpw.SRT_Overlap =89;
        ovpw.SRT_OverrideReason ='Test';
        ovpw.SRT_Time ='19';
         ovpw.Id ='243536';
        List<CSS_JobPlanSRTController.overLapSrtWrapper> LstJP=new List<CSS_JobPlanSRTController.overLapSrtWrapper>();
        jobPlan.lstOverLapSrt=null;
        Id currentUserID=UserInfo.getUserId();
       // list<user> userids = [select id,name from user limit 3];
        
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02466';
        acc.IAM_Service_Provider_Code__c='19134';
        acc.Type='Dealer Account';
        acc.CMI_Account_Status__c = 'Active';
        acc.ERP_System__c = 'One BMS';
        insert acc;
        
        //Add test data for Service job order
        CSS_Job_Order__c JO = new CSS_Job_Order__c();
        JO.Account__c = acc.id;
        JO.Customer_Name__c = 'Test';
        JO.Customer_Code__c=null;
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
        JO.Unit_Number__c = 'test123';
        Jo.Assigned_To__c = UserInfo.getUserId();
        JO.Additional_Tech1__c =  UserInfo.getUserId();//userids[0].id;
        JO.Additional_Tech2__c =  UserInfo.getUserId();//userids[1].id;
        Jo.esn__c='1234';
        JO.Equipment_ID__c = 'EQ7667';
        JO.Qsol_Engine_Family_Code__c ='56';
        JO.AccessCode__c = 'A';
        JO.BMSWSStatus__c = 'UI';
        JO.Unit_Number__c = '12345';
        JO.Shop_Work_Order__c='12345';
        JO.EditCoverage__c = 'Test';
        JO.EditComplaint__c = 'Test';
        JO.EditCorrection__c = 'TEST';
        JO.EditCause__c = 'TEST';
        JO.BMSStatus__c = 'UII';
        JO.chevron_page__c='srt';
        JO.CSS_Resolution__c='Solved';
        JO.Customer_Code__c ='8989';
        JO.Shop_Work_Order__c='Test78';
        insert(JO);   
        
           
        
        JobPlan.workJob = [Select Id,Name,AccessCode__c,Customer_Name__c,Shop_Work_Order__c, Application__c, Application_Desc__c, BMS_Last_Name__c, DSID_WorkGroup__c, Unit_Number__c, Date_in__c, INSITE_UpdateTimeStamp__c, First_Name__c,
                           Repair_Location__c,Failure_Date__c, Failure_Point__c, Failure_Point_Measure__c, Service_Model__c, VIN__c,BMSStatus__c,Unit_Type__c, Warranty_Start_Date__c,Make__c, Qsol_Engine_Family_Code__c,
                           DSID__c, DSID_Creation_Timestamp__c, DSID_Status__c, Repeat_Or_Recent_Calc__c, DSID_UpdateTimestamp__c,Customer_Code__c,Status__c,
                           Phone_Number__c, Previous_Status__c,Sub_Type__c, Category__c, Complaint_Type__c, Model__c,Creator_Location__c, Control_Number__c,
                           Assigned_to__r.Name,Additional_Tech1__r.Name,Additional_Tech2__r.Name,OwnerId,JobLocation__c,CSS_Resolution__c,CSS_Feedback_Comments__c,BMSWSStatus__c,EditCoverage__c,EditComplaint__c,
                           ESN__c, Mileage__c, Mileage_Measure__c, chevron_page__c,General_Symptoms__c, Assigned_To__c, LastModifiedDate,CreatedDate,ESN_Locked__c,Region__c,Territory__c
                           from CSS_Job_Order__c where id= :JO.id];
        
        //PageReference p=Page.CSS_Jobplan; 
//Test.setCurrentPage(p);  
        ApexPages.currentPage().getParameters().put('id',jo.Id);         
        
        CSS_Fault_Code__c fc1 = new CSS_Fault_Code__c(FaultCodeR2__c = '441',Related_Fault_Code__c = '234,546');
        fc1.Name = '441';
        fc1.Job_Order__c = JO.Id;
        fc1.Sequence__c = 1;
        fc1.Fault_Code_Type__c = 'APD-P';
        fc1.Mod__c = '0';
        fc1.isPole__c = false;
        insert fc1;
        List<CSS_Fault_Code__c> lstFC1 = new List<CSS_Fault_Code__c>();
        lstFC1.add(fc1);
        
        CSS_Solutions__c sol1 = new CSS_Solutions__c();
        sol1.FaultCode__c = fc1.Id;
        sol1.Service_Job__c = JO.Id;
        sol1.Name = 'Sample Case Name';
        sol1.Case_Name__c = 'Sample Case Name';
        sol1.Solution_Title__c = 'Sample Title';
        sol1.Rank__c =0;
        sol1.Diagnostic_Response__c = 'Most likely the solution';
        sol1.Repair_Response__c ='';
        //sol1.Repair_Response__c='Repair Successful.';
        insert sol1;
          CSS_Solutions__c sol11 = new CSS_Solutions__c();
        sol11.FaultCode__c = fc1.Id;
        sol11.Service_Job__c = JO.Id;
        sol11.Name = 'Sample Case Name';
        sol11.Case_Name__c = 'Sample Case Name';
        sol11.Solution_Title__c = 'Sample Title';
        sol11.Rank__c =0;
        sol11.Diagnostic_Response__c = 'Most likely the solution';
        sol11.Repair_Response__c ='';
        //sol1.Repair_Response__c='Repair Successful.';
        //insert sol11;
        
        CSS_Solution_Component__c csc=new CSS_Solution_Component__c();
        csc.Action__c='test';
        csc.Solutions__c=sol1.id;
        csc.Service_Job__c=JO.id;
        csc.Selected_Component__c = true;
        csc.Performed__c = true;
        csc.Performed_Review__c = true;
        csc.AccountCodeEdit__c='test';
        csc.Fail_Code_Editable__c='test';
        insert csc;
        
        css_srt__c srt = new css_srt__c();
        
        srt.Solution_Number__c = sol1.id;
        srt.SRT_AccessiblityCheck__c=True;
        srt.SRT_Time__c = 65;
        srt.Job_Order__c = JO.id;
        srt.isPerformed__c = true;
        srt.name = 'Test';
        srt.SRT_Type__c = 'Repair';
        srt.SRT_ID__c = '00-11';
        // insert srt;
        
        css_srt__c srt1 = new css_srt__c();
        srt1.Solution_Number__c = sol1.id;
        srt1.SRT_AccessiblityCheck__c=True;
        srt1.SRT_Time__c = 65;
        srt1.Job_Order__c = JO.id;
        srt1.name = 'Test';
        srt1.isPerformed__c = true;
        srt1.SRT_Type__c = 'Repair';
        srt1.SRT_ID__c = '00-11';
        //insert srt1;
        
        css_srt__c srt3 = new css_srt__c();
        srt3.Solution_Number__c = sol1.id;
        srt3.SRT_AccessiblityCheck__c=True;
        srt3.SRT_Time__c = 1.1;
        srt3.Job_Order__c = JO.id;
        srt3.name = 'Test';
        // srt3.isPerformed__c = true;
        srt3.SRT_Type__c = 'Overlap';
        srt3.SRT_ID__c = '00-11';
        insert srt3;
        //siva
        CSS_SRT__C FieldAction = new CSS_SRT__C();
        FieldAction.Solution_Number__c = sol1.id;
        FieldAction.Job_Order__c = JO.id;
        FieldAction.SRT_Quantity__c =2;
        FieldAction.SRT_Warrantable__c ='3';
        FieldAction.SRT_AccessiblityCheck__c=True;
        FieldAction.SRT_Time__c = 1.1;
        FieldAction.name = 'Test';
        FieldAction.Type__c = 'Field Action';
        FieldAction.SRT_ID__c = '00-11';
        insert FieldAction;
        CSS_SRT__C srtoverlp = new CSS_SRT__C();
        srtoverlp.Solution_Number__c = sol1.id;
        srtoverlp.Job_Order__c = JO.id;
        srtoverlp.SRT_Quantity__c =2;
        srtoverlp.SRT_Warrantable__c ='3';
        srtoverlp.SRT_AccessiblityCheck__c=True;
        srtoverlp.SRT_Time__c = 1.1;
        srtoverlp.name = 'Test';
        srtoverlp.Type__c = 'Overlap';
        srtoverlp.SRT_ID__c = '00-11';
        insert srtoverlp;
        
        CSS_SRT__C srtDiagAccess = new CSS_SRT__C();
        srtDiagAccess.Solution_Number__c = sol1.id;
        srtDiagAccess.Job_Order__c = JO.id;
        srtDiagAccess.SRT_Quantity__c =2;
        srtDiagAccess.SRT_Warrantable__c ='3';
        srtDiagAccess.SRT_AccessiblityCheck__c=True;
        srtDiagAccess.SRT_Time__c = 1.1;
        srtDiagAccess.name = 'Test';
        srtDiagAccess.Type__c = 'Repair Access';
        srtDiagAccess.SRT_ID__c = '00-11';
        insert srtDiagAccess;
        
       
        List<css_srt__c> lstSRT = new List<css_srt__c>();
        lstSRT.add(srt);
        lstSRT.add(srt1);
        // lstSRT.add(srt2);
        lstSRT.add(srt3);
        
        CSS_Quote__c qt = new CSS_Quote__c(); 
        qt.AcceptQuote__c = true;
        qt.QuoteTotal__c = 1000;
        qt.Service_Job__c = JO.id;
        
        list<Attachment> attachmentList = new list<Attachment>();
        // Add test file for attachment            
        
        Attachment attach=new Attachment();    
        attach.Name='Unit Test Attachment';
        Blob bodyBlob1=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob1;
        attach.parentId=jo.id;
        attachmentList.add(attach);
        
        Attachment attach1=new Attachment();    
        attach1.Name='Unit Test Attachment1';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body1');
        attach1.body=bodyBlob;
        attach1.parentId=jo.id;
        
        insert attach;
        
        CSS_accountLanguage__c accntLang = new CSS_accountLanguage__c();
        accntLang.name = 'en';
        accntLang.CSS_QsolLanguage__c = 'en';
        accntLang.CSS_userLanguage__c = 'en';
        accntLang.CSS_EDSLanguage__c = 'en';
        insert(accntLang);
        
        Id recTypeIdoption = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'Options');
        Id recTypeIdpart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'Parts');
        
        CSS_Solution_Component__c comp = new CSS_Solution_Component__c();
        
        comp.Component_Id__c = 'Fooo1';
        comp.Service_Job__c = JO.Id;
        insert comp;
        
        CSS_Parts_Options__c parts = new CSS_Parts_Options__c();
        parts.recordtypeId = recTypeIdpart;
        parts.Option_Number__c = 'O-111';
        parts.Service_Job__c = Jo.Id;
        parts.selected_part__c = true;
        parts.FailurepartId__c = comp.Id;
        insert parts;
        
       /* CSS_CampTsbTrp__c x1 = new CSS_CampTsbTrp__c();
        x1.Job_order__c = Jo.Id;
        x1.performed_review__c = true;
        x1.performed__c =false;
        insert x1; */
        
        
        jobplan.Wid = Jo.Id;
        jobplan.comm = 'sample';
        Note x2 = new Note();
        x2.Title = 'CAMPCOMMENTS';
        x2.ParentId = jobplan.Wid; 
        x2.Body =  jobplan.comm;
        insert x2;
        
        jobplan.NotesBody = 'sample';
        jobplan.show_war_pnl = true;
        jobplan.showResolution = true;
        jobplan.showRepairs = true;
        jobplan.nocamptsbtrps = true;
        jobPlan.accQuoteFlag = true;
        jobplan.showResolutionWithRepair = false;
        jobPlan.showRepairErrorMessage = true;
        jobPlan.requiredBMSMessage = true;
        //jobPlan.bmsEnabled=TRUE;
        //Attachment attach;
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Miles',system.Label.CSS_Miles));
        options.add(new SelectOption('Kilometers',system.Label.CSS_Kilometers)); 
        Test.startTest();
          jobPlan.jobPlanSRTAction();
        jobPlan.savecheckbox();
        jobPlan.updatestatus();
        jobPlan.closeSession();
       jobPlan.updateservjob();
        jobPlan.closeSession_close();
        jobPlan.jobClosePopup();
        jobplan.show_war_pnl = true;
        jobplan.showResolution = true;
        jobplan.showRepairs = true;
        jobplan.nocamptsbtrps = true;
        jobPlan.accQuoteFlag = true;
        jobplan.showResolutionWithRepair = false;
        jobPlan.showRepairErrorMessage = true;
        jobPlan.requiredBMSMessage = true;
        jobplan.saveAndCloseJob();
        jobPlan.pgsave();

        
        
        jobplan.BMSSuccessWOQTMsg='';
        //   pageReference pref = jobplan.saveAndCloseJob();
        Test.stopTest();
    } 
static testmethod void overlapservicetestmethod20(){
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new CG_OverlapSRTMock_Test());
        CSS_JobPlanSRTController jobPlan= new CSS_JobPlanSRTController();
        jobPlan.complaintcounter=2;
        jobPlan.displaySRTButton = true;
        jobPlan.coveragecounter=2;
        jobPlan.causecounter=2;
        jobPlan.correctioncounter=2;
        jobPlan.timemin=2;
        jobPlan.timeminov=2;
        jobPlan.TotalOverlapHours=2;
        jobPlan.TotalAdjustedHours=2;
        jobPlan.overlapErrorMsg='Test23';
        
        CSS_JobPlanSRTController.overLapSrtWrapper OvpW=new  CSS_JobPlanSRTController.overLapSrtWrapper();
        OvpW.overide=true;
        ovpW.OverlapSRTTime =10;
        ovpw.SRT_Code ='90';
        ovpW.SRT_Description ='Test';
        ovpW.SRT_Notes ='Test';
        ovpw.SRT_Overlap =89;
        ovpw.SRT_OverrideReason ='Test';
        ovpw.SRT_Time ='19';
        ovpw.Id ='243536';
        List<CSS_JobPlanSRTController.overLapSrtWrapper> LstJP=new List<CSS_JobPlanSRTController.overLapSrtWrapper>();
        jobPlan.lstOverLapSrt=null;
        Id currentUserID=UserInfo.getUserId();
       // list<user> userids = [select id,name from user limit 3];
        
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02466';
        acc.IAM_Service_Provider_Code__c='19134';
        acc.Type='Dealer Account';
        acc.CMI_Account_Status__c = 'Active';
        acc.ERP_System__c = 'One BMS';
        insert acc;
        
        //Add test data for Service job order
        CSS_Job_Order__c JO = new CSS_Job_Order__c();
        JO.Customer_Name__c = 'Test';
        JO.Customer_Code__c=null;
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
        JO.Unit_Number__c = 'test123';
        Jo.Assigned_To__c = UserInfo.getUserId();
        JO.Additional_Tech1__c =  UserInfo.getUserId();// userids[0].id;
        JO.Additional_Tech2__c =  UserInfo.getUserId();//userids[1].id;
        Jo.esn__c='1234';
        JO.Equipment_ID__c = 'EQ7667';
        JO.Qsol_Engine_Family_Code__c ='56';
        JO.AccessCode__c = 'A';
        JO.BMSWSStatus__c = 'UI';
        JO.Unit_Number__c = '12345';
        JO.Shop_Work_Order__c='12345';
        JO.EditCoverage__c = 'Test';
        JO.EditComplaint__c = 'Test';
        JO.EditCorrection__c = 'TEST';
        JO.EditCause__c = 'TEST';
        JO.BMSStatus__c = 'UII';
        JO.chevron_page__c='srt';
        JO.CSS_Resolution__c='test';
        JO.Customer_Code__c ='8989';
        JO.Shop_Work_Order__c='Test78';
        JO.Account__c = acc.id;
        insert(JO);      
        
        JobPlan.workJob = [Select Id,Name,AccessCode__c,Customer_Name__c,Shop_Work_Order__c, Application__c, Application_Desc__c, BMS_Last_Name__c, DSID_WorkGroup__c, Unit_Number__c, Date_in__c, INSITE_UpdateTimeStamp__c, First_Name__c,
                           Repair_Location__c,Failure_Date__c, Failure_Point__c, Failure_Point_Measure__c, Service_Model__c, VIN__c,BMSStatus__c,Unit_Type__c, Warranty_Start_Date__c,Make__c, Qsol_Engine_Family_Code__c,
                           DSID__c, DSID_Creation_Timestamp__c, DSID_Status__c, Repeat_Or_Recent_Calc__c, DSID_UpdateTimestamp__c,Customer_Code__c,Status__c,
                           Phone_Number__c, Previous_Status__c,Sub_Type__c, Category__c, Complaint_Type__c, Model__c,Creator_Location__c, Control_Number__c,
                           Assigned_to__r.Name,Additional_Tech1__r.Name,Additional_Tech2__r.Name,OwnerId,JobLocation__c,CSS_Resolution__c,CSS_Feedback_Comments__c,BMSWSStatus__c,EditCoverage__c,EditComplaint__c,
                           ESN__c, Mileage__c, Mileage_Measure__c, chevron_page__c,General_Symptoms__c, Assigned_To__c, LastModifiedDate,CreatedDate,ESN_Locked__c,Region__c,Territory__c
                           from CSS_Job_Order__c where id= :JO.id];
        
        /*PageReference p=Page.CSS_Jobplan; 
Test.setCurrentPage(p);  */
        ApexPages.currentPage().getParameters().put('id',jo.Id);         
        
        CSS_Fault_Code__c fc1 = new CSS_Fault_Code__c(FaultCodeR2__c = '441',Related_Fault_Code__c = '234,546');
        fc1.Name = '441';
        fc1.Job_Order__c = JO.Id;
        fc1.Sequence__c = 1;
        fc1.Fault_Code_Type__c = 'APD-P';
        fc1.Mod__c = '0';
        fc1.isPole__c = false;
        insert fc1;
        List<CSS_Fault_Code__c> lstFC1 = new List<CSS_Fault_Code__c>();
        lstFC1.add(fc1);
        
        CSS_Solutions__c sol1 = new CSS_Solutions__c();
        sol1.FaultCode__c = fc1.Id;
        sol1.Service_Job__c = JO.Id;
        sol1.Name = 'Sample Case Name';
        sol1.Case_Name__c = 'Sample Case Name';
        sol1.Solution_Title__c = 'Sample Title';
        sol1.Rank__c =0;
        sol1.Diagnostic_Response__c = 'Most likely the solution';
        // sol1.Repair_Response__c ='';
        sol1.Repair_Response__c='Repair Successful.';
        //sol1.Out_Of_Order__c = true;
        insert sol1;
        
        
        CSS_Solution_Component__c csc=new CSS_Solution_Component__c();
        csc.Action__c='test';
        csc.Solutions__c=sol1.id;
        csc.Service_Job__c=JO.id;
        insert csc;
        
        css_srt__c srt = new css_srt__c();
        
        srt.Solution_Number__c = sol1.id;
        srt.SRT_AccessiblityCheck__c=True;
        srt.SRT_Time__c = 1.1;
        srt.Job_Order__c = JO.id;
        srt.isPerformed__c = true;
        srt.name = 'Test';
        srt.SRT_Type__c = 'Repair';
        srt.SRT_ID__c = '00-11';
        // insert srt;
        
        css_srt__c srt1 = new css_srt__c();
        srt1.Solution_Number__c = sol1.id;
        srt1.SRT_AccessiblityCheck__c=True;
        srt1.SRT_Time__c = 1.1;
        srt1.Job_Order__c = JO.id;
        srt1.name = 'Test';
        srt1.isPerformed__c = true;
        srt1.SRT_Type__c = 'Repair';
        srt1.SRT_ID__c = '00-11';
        //insert srt1;
        
        css_srt__c srt3 = new css_srt__c();
        srt3.Solution_Number__c = sol1.id;
        srt3.SRT_AccessiblityCheck__c=True;
        srt3.SRT_Time__c = 1.1;
        srt3.Job_Order__c = JO.id;
        srt3.name = 'Test';
        // srt3.isPerformed__c = true;
        srt3.SRT_Type__c = 'Overlap';
        srt3.SRT_ID__c = '00-11';
        insert srt3;
        //siva
        CSS_SRT__C FieldAction = new CSS_SRT__C();
        FieldAction.Solution_Number__c = sol1.id;
        FieldAction.Job_Order__c = JO.id;
        FieldAction.SRT_Quantity__c =2;
        FieldAction.SRT_Warrantable__c ='3';
        FieldAction.SRT_AccessiblityCheck__c=True;
        FieldAction.SRT_Time__c = 1.1;
        FieldAction.name = 'Test';
        FieldAction.Type__c = 'Field Action';
        FieldAction.SRT_ID__c = '00-11';
        insert FieldAction;
        CSS_SRT__C srtoverlp = new CSS_SRT__C();
        srtoverlp.Solution_Number__c = sol1.id;
        srtoverlp.Job_Order__c = JO.id;
        srtoverlp.SRT_Quantity__c =2;
        srtoverlp.SRT_Warrantable__c ='3';
        srtoverlp.SRT_AccessiblityCheck__c=True;
        srtoverlp.SRT_Time__c = 1.1;
        srtoverlp.name = 'Test';
        srtoverlp.Type__c = 'Overlap';
        srtoverlp.SRT_ID__c = '00-11';
        insert srtoverlp;
        jobPlan.jobPlanSRTAction();
        
        CSS_SRT__C srtDiagAccess = new CSS_SRT__C();
        srtDiagAccess.Solution_Number__c = sol1.id;
        srtDiagAccess.Job_Order__c = JO.id;
        srtDiagAccess.SRT_Quantity__c =2;
        srtDiagAccess.SRT_Warrantable__c ='3';
        srtDiagAccess.SRT_AccessiblityCheck__c=True;
        srtDiagAccess.SRT_Time__c = 1.1;
        srtDiagAccess.name = 'Test';
        srtDiagAccess.Type__c = 'Repair Access';
        srtDiagAccess.SRT_ID__c = '00-11';
        insert srtDiagAccess;
        
        jobPlan.jobPlanSRTAction();
        List<css_srt__c> lstSRT = new List<css_srt__c>();
        lstSRT.add(srt);
        lstSRT.add(srt1);
        // lstSRT.add(srt2);
        lstSRT.add(srt3);
        
         List<css_srt__c> lstSRTAccess = new List<css_srt__c>();
        
        css_srt__c srt4 = new css_srt__c();
        
        srt4.Solution_Number__c = sol1.id;
        srt4.SRT_AccessiblityCheck__c=True;
        srt4.SRT_Time__c = 1.1;
        srt4.Job_Order__c = JO.id;
        srt4.isPerformed__c = true;
        srt4.name = 'Test';
        srt4.SRT_Type__c = 'Repair';
        srt4.SRT_ID__c = '1211';
        srt4.Step_Id__c = '1';
        // insert srt;
        lstSRTAccess.add(srt4);
        
        insert lstSRTAccess;
     CSS_Integration_Details__c cid = CSS_TestData.createIntegrationDetails(false);
        cid.name = 'SRT';
        cid.ApplicationName__c = 'SRT';
        cid.End_Point__c = 'https://services-test.cummins.com/css';
        insert cid;
        jobPlan.overlapSRTCallout('',lstSRTAccess);
        //jobPlan.mutualOverlapSRTCallout(lstSRTAccess);
        
        //jobPlan.callUnitInboundGeneric();
        CSS_Quote__c qt = new CSS_Quote__c(); 
        qt.AcceptQuote__c = true;
        qt.QuoteTotal__c = 1000;
        qt.Service_Job__c = JO.id;
        
        list<Attachment> attachmentList = new list<Attachment>();
        // Add test file for attachment            
        
        Attachment attach=new Attachment();    
        attach.Name='Unit Test Attachment';
        Blob bodyBlob1=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob1;
        attach.parentId=jo.id;
        attachmentList.add(attach);
        
        Attachment attach1=new Attachment();    
        attach1.Name='Unit Test Attachment1';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body1');
        attach1.body=bodyBlob;
        attach1.parentId=jo.id;
        
        insert attach;
        
        CSS_accountLanguage__c accntLang = new CSS_accountLanguage__c();
        accntLang.name = 'en';
        accntLang.CSS_QsolLanguage__c = 'en';
        accntLang.CSS_userLanguage__c = 'en';
        accntLang.CSS_EDSLanguage__c = 'en';
        insert(accntLang);
        
        Id recTypeIdoption = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'Options');
        Id recTypeIdpart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'Parts');
        
        CSS_Solution_Component__c comp = new CSS_Solution_Component__c();
        
        comp.Component_Id__c = 'Fooo1';
        comp.Service_Job__c = JO.Id;
        insert comp;
        
        CSS_Parts_Options__c parts = new CSS_Parts_Options__c();
        parts.recordtypeId = recTypeIdpart;
        parts.Option_Number__c = 'O-111';
        parts.Service_Job__c = Jo.Id;
        parts.selected_part__c = true;
        parts.FailurepartId__c = comp.Id;
        insert parts;
        
        /*CSS_CampTsbTrp__c x1 = new CSS_CampTsbTrp__c();
x1.Job_order__c = Jo.Id;
x1.performed_review__c = true;
x1.performed__c =false;
insert x1;*/
        
        
        jobplan.Wid = Jo.Id;
        jobplan.comm = 'sample';
        Note x2 = new Note();
        x2.Title = 'CAMPCOMMENTS';
        x2.ParentId = jobplan.Wid; 
        x2.Body =  jobplan.comm;
        insert x2;
        
        jobplan.NotesBody = 'sample';
        jobplan.show_war_pnl = true;
        jobplan.showResolution = true;
        jobplan.showRepairs = true;
        jobplan.nocamptsbtrps = true;
        jobPlan.accQuoteFlag = true;
        jobplan.showResolutionWithRepair = false;
        jobPlan.showRepairErrorMessage = true;
        jobPlan.requiredBMSMessage = true;
        //jobPlan.bmsEnabled=TRUE;
        //Attachment attach;
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Miles',system.Label.CSS_Miles));
        options.add(new SelectOption('Kilometers',system.Label.CSS_Kilometers)); 
        
        /*jobPlan.savecheckbox();
        jobPlan.updatestatus();
        jobPlan.closeSession();
        jobPlan.updateservjob();
        jobPlan.closeSession_close();
        jobPlan.jobClosePopup();
        jobPlan.pgsave();
        jobPlan.pgSaveFinish();
        jobplan.saveAndCloseJob();*/
        //   pageReference pref = jobplan.saveAndCloseJob();
        Test.stopTest();
    }
    
}