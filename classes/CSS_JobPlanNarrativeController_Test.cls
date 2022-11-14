@isTest
public class CSS_JobPlanNarrativeController_Test {
    
    static testmethod void testmethod1()
    {
        
        Test.startTest();
        Account acc = new Account();
      acc.ERP_System__c ='One BMS';
      acc.Name='Testing';
      insert acc;
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
        JO.CSS_Job_Location_Code__c='56270-56255';
        Jo.esn__c='1234';
        JO.Equipment_ID__c = 'EQ7667';
        JO.Qsol_Engine_Family_Code__c ='56';
        JO.AccessCode__c = 'A';
        JO.BMSWSStatus__c = 'UI';
        JO.BMSStatus__c = 'sample';
        JO.CSS_Resolution__c='TEST';
        JO.chevron_page__c = 'Narr';
        JO.EditComplaint__c = 'TEST COMPLAINT';
        JO.EditCorrection__c = 'TEST CORRECTION';
        JO.EditCoverage__c = 'TEST COVERAGE';
        JO.EditCause__c = 'TEST CAUSE';
        JO.Shop_Work_Order__c = '222';
        JO.CSS_Resolution__c = 'Solved';
        JO.DSID__c = '1234';
        JO.General_Symptoms__c = '';
        
        insert(JO);      
        PageReference pref;
        pref = new PageReference('/'+JO.id);
        pref.getParameters().put('id',JO.id);
        //pref.getParameters().put('partsUr','Parts');
        Test.setCurrentPage(pref);
        
        Note x = new Note();
        x.Title = 'CAMPCOMMENTS';
        x.ParentId = JO.id;  
        x.Body = 'comm';
        insert x;
        
        CSS_JobPlanNarrativeController jobPlan= new CSS_JobPlanNarrativeController();
        // jobPlan.showRepairs = FALSE;
        
              
        
        JobPlan.workJob = [Select Id,Name,AccessCode__c,Customer_Name__c,Shop_Work_Order__c, Application__c, Application_Desc__c, BMS_Last_Name__c, DSID_WorkGroup__c, Unit_Number__c, Date_in__c, INSITE_UpdateTimeStamp__c, First_Name__c,
                           Repair_Location__c,Failure_Date__c, Failure_Point__c, Failure_Point_Measure__c, Service_Model__c,BMSStatus__c,Unit_Type__c, VIN__c, Warranty_Start_Date__c,Make__c, Qsol_Engine_Family_Code__c,
                           DSID__c, DSID_Creation_Timestamp__c, DSID_Status__c, Repeat_Or_Recent_Calc__c, DSID_UpdateTimestamp__c,Customer_Code__c,Status__c,
                           Phone_Number__c, Previous_Status__c,Sub_Type__c, Category__c, Complaint_Type__c, Model__c,Creator_Location__c, Control_Number__c,
                           Assigned_to__r.Name,Additional_Tech1__r.Name,Additional_Tech2__r.Name,OwnerId,JobLocation__c,CSS_Resolution__c,CSS_Feedback_Comments__c, BMSWSStatus__c,
                           ESN__c, Mileage__c, Mileage_Measure__c, chevron_page__c, General_Symptoms__c, Assigned_To__c, LastModifiedDate,CreatedDate,ESN_Locked__c,Region__c,Territory__c,EditComplaint__c,EditCorrection__c,EditCoverage__c,EditCause__c
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
        CSS_CampTsbTrp__c x1 = new CSS_CampTsbTrp__c();
        x1.Job_order__c = Jo.Id;
        x1.performed_review__c = true;
        x1.performed__c =false;
        insert x1;
        jobPlan.jobClosePopup(); 
        CSS_Fault_Code__c fc2 = new CSS_Fault_Code__c(FaultCodeR2__c = '441',Related_Fault_Code__c = '234,546');
        fc2.Name = '441';
        fc2.Job_Order__c = Jo.Id;
        fc2.Sequence__c = 1; 
        fc2.Fault_Code_Type__c = 'BPD-P';
        fc2.Mod__c = '0';
        fc2.isPole__c = false;
        insert fc2;
        CSS_Solutions__c sol = new CSS_Solutions__c();
        sol.Service_Job__c = Jo.ID;
        sol.Case_Name__c = 'ABC';
        sol.Solution_Title__c='CDE';
        sol.Name='ABC';
        sol.Fault_Codes__c =fc2.FaultCode__c;
        sol.Diagnostic_Response__c ='	Most likely the solution';
        sol.Repair_Response__c = 'Most likely the solution';
        sol.Out_Of_Order__c = true;
        sol.Rank__c = 2;
        sol.Solution__c = 'Solution1';
        insert sol;
        CSS_Solution_Component__c solComp = new CSS_Solution_Component__c();
        solComp.Component_Id__c ='F0051000';
        solComp.Service_Job__c = Jo.id;
        solComp.Solutions__c = sol.id;
        solComp.Action__c = '';
        
        insert solComp;
        
        /*   CSS_CampTsbTrp__c ct = new CSS_CampTsbTrp__c();
ct.name = 'CAM';
ct.name = 'TRP';
ct.name = 'TSB';
insert ct;*/
        //  list < CSS_CampTsbTrp__c > solutionList = new list < CSS_CampTsbTrp__c > ();
        //CSS_Solutions__c cssSol;
        
        
        /*  CSS_CampTsbTrp__c solRec = new CSS_CampTsbTrp__c(Doc_Num__c = 'TSB140168', URL__c = 'https://qsolpilot.cummins.com/qs3/pubsys2/xml/en/tsb/2014/tsb140168.html',
Type__c = 'CAM', Doc_Title__c = 'xyz', Cu_Language__c = 'xc', Performed__c = false, Job_Order__c = Jo.Id,
Performed_Review__c = true, Reviewed__c = true, esn__c = '79464646');
insert solRec;*/
        
        //pref = jobplan.saveAndCloseJob();
        
        jobplan.Wid = jo.id;
        jobplan.comm = 'sample';
        Note x2 = new Note();
        x2.Title = 'CAMPCOMMENTS';
        x2.ParentId = jobplan.Wid; 
        x2.Body =  jobplan.comm;
        insert x2;
        jobPlan.showJobPlanBlocks(false,false,false,true,false,false,false); 
        List<CSS_Quote__c> quotelst = new List<CSS_Quote__c>();
        CSS_Quote__c quote = new CSS_Quote__c();
        //quote.id = jo.id;
        
        quote.OrderReference__c = 'qwerty1345';
        quote.Service_Job__c = jo.Id;
        insert quote;
        quotelst.add(quote);
        jobPlan.ChkFieldBlank();
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
        
        jobPlan.redirectPopup();  
        jobPlan.Cancel();
        jobPlan.saveCause();
        jobPlan.saveComplaint();
        jobPlan.saveCorrection(); 
        jobPlan.saveCoverage();
        jobPlan.saveNonSRTDetails();
        jobPlan.sendNarrativeToERP();
        
        jobplan.showResolution = true;
        jobplan.requiredBMSMessage = true;
        jobplan.showRepairErrorMessage = true;
        jobplan.dsidStatus = true;
        jobplan.showResolutionWithRepair = true;
        jobplan.showRepairs = true;
        jobPlan.saveAndCloseJob();
        jobplan.nonSRTnotes='test';
        //CSS_WPR_JobPlanOverview jpo = new CSS_WPR_JobPlanOverview();
        
        Test.stopTest();
    }
    
    static testmethod void testmethod2()
    {
        Account acc = new Account();
      acc.ERP_System__c ='One BMS';
      acc.Name='Testing';
      insert acc;
        Test.startTest();
        
        Id currentUserID=UserInfo.getUserId();
        list<user> userids = [select id,name from user limit 3]; 
        
        //Add test data for Service job order
       list<CSS_Job_Order__c> JOlist = new list<CSS_Job_Order__c>();
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
        JO.CSS_Job_Location_Code__c='56270-56255';
        Jo.esn__c='1234';
        JO.Equipment_ID__c = 'EQ7667';
        JO.Qsol_Engine_Family_Code__c ='56';
        JO.AccessCode__c = 'A';
        JO.BMSWSStatus__c = 'UI';
        JO.BMSStatus__c = 'sample';
        JO.CSS_Resolution__c='TEST';
        JO.chevron_page__c = 'Narr';
        JO.EditComplaint__c = '';
        JO.EditCorrection__c = '';
        JO.EditCoverage__c = '';
        JO.EditCause__c = '';
        JO.Shop_Work_Order__c = '222';
        JO.CSS_Resolution__c = 'Solved';
        JO.DSID__c = '1234';
        JO.General_Symptoms__c = '';
        insert(JO);  
        JOlist.add(JO);
         list<CSS_solutions__c> sollist12 = new list<CSS_solutions__c>();
        CSS_solutions__c sol12 = new CSS_solutions__c();
        sol12.Service_Job__c = Jo.ID;
        sol12.Case_Name__c = 'ABC';
        sol12.solution_Title__c='CDE';
        sol12.Name='ABC';
        //sol12.Fault_Codes__c =fc2.FaultCode__c;
        sol12.Diagnostic_Response__c ='	Most likely the sol12ution';
        sol12.Repair_Response__c = 'Most likely the sol12ution';
        sol12.Out_Of_Order__c = true;
        sol12.Rank__c = 2;
        sol12.solution__c = 'sol12ution1';
        insert sol12;
        sollist12.add(sol12);
        list < CSS_CampTsbTrp__c > solutionList = new list < CSS_CampTsbTrp__c > ();
         CSS_CampTsbTrp__c solRec = new CSS_CampTsbTrp__c(Doc_Num__c = 'TSB140168', URL__c = 'https://qsolpilot.cummins.com/qs3/pubsys2/xml/en/tsb/2014/tsb140168.html',
Type__c = 'CAM', Doc_Title__c = 'xyz', Cu_Language__c = 'xc', Performed__c = false, Job_Order__c = Jo.Id,Performed_Review__c = true, Reviewed__c = true, esn__c = '79464646');
insert solRec;
        solutionList.add(solRec);
     CSS_Job_Order__c closeJob = [Select id,DSID__c, (Select Id,Name, Case_Name__c, Service_Job__c,Repair_response__c,Out_Of_Order__c,Rank__c,Solution_Title__c ,
                                            Solution__c,Diagnostic_Response__c FROM CSS_Solutions__r where service_job__c =:JO.id), (Select id, name , performed__c, performed_review__c, 
                                                                                                                                   Reviewed__c from CSS_CampTsbTrp__r where job_order__C=:JO.id and( performed_review__c=True and performed__c=False))                    
                        from CSS_Job_Order__c where id= :JO.id];
            System.debug('closeJob'+closeJob);
        PageReference pref;
        pref = new PageReference('/'+JO.id);
        pref.getParameters().put('id',JO.id);
        //pref.getParameters().put('partsUr','Parts');
        Test.setCurrentPage(pref);
        
        Note x = new Note();
        x.Title = 'CAMPCOMMENTS';
        x.ParentId = JO.id;  
        x.Body = 'comm';
        insert x;
        
        CSS_JobPlanNarrativeController jobPlan= new CSS_JobPlanNarrativeController();
        // jobPlan.showRepairs = FALSE;
        
        
        
        JobPlan.workJob = [Select Id,Name,AccessCode__c,Customer_Name__c,Shop_Work_Order__c, Application__c, Application_Desc__c, BMS_Last_Name__c, DSID_WorkGroup__c, Unit_Number__c, Date_in__c, INSITE_UpdateTimeStamp__c, First_Name__c,
                           Repair_Location__c,Failure_Date__c, Failure_Point__c, Failure_Point_Measure__c, Service_Model__c,BMSStatus__c,Unit_Type__c, VIN__c, Warranty_Start_Date__c,Make__c, Qsol_Engine_Family_Code__c,
                           DSID__c, DSID_Creation_Timestamp__c, DSID_Status__c, Repeat_Or_Recent_Calc__c, DSID_UpdateTimestamp__c,Customer_Code__c,Status__c,
                           Phone_Number__c, Previous_Status__c,Sub_Type__c, Category__c, Complaint_Type__c, Model__c,Creator_Location__c, Control_Number__c,
                           Assigned_to__r.Name,Additional_Tech1__r.Name,Additional_Tech2__r.Name,OwnerId,JobLocation__c,CSS_Resolution__c,CSS_Feedback_Comments__c, BMSWSStatus__c,
                           ESN__c, Mileage__c, Mileage_Measure__c, chevron_page__c, General_Symptoms__c, Assigned_To__c, LastModifiedDate,CreatedDate,ESN_Locked__c,Region__c,Territory__c,EditComplaint__c,EditCorrection__c,EditCoverage__c,EditCause__c
                           from CSS_Job_Order__c where id= :JO.id];
        
        
        CSS_List_Of_Values__c CLV = new CSS_List_Of_Values__c();
        CLV.Name = 'Test'+math.random();
        CLV.Type__c = 'ApplicationCode';
        CLV.Code__c = 'UKEU';
        CLV.Picklist_Values_1__c = 'EUROPE';
        insert(CLV);
        
        /*CSS_Job_Order__c jobOrder = new CSS_Job_Order__c();
        jobOrder.Status__c = 'Created/Not Assigned';
        insert jobOrder;*/
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
        /*CSS_CampTsbTrp__c x1 = new CSS_CampTsbTrp__c();
        x1.Job_order__c = Jo.Id;
        x1.performed_review__c = true;
        x1.performed__c =false;
        insert x1;*/
        jobPlan.jobClosePopup(); 
        CSS_Fault_Code__c fc2 = new CSS_Fault_Code__c(FaultCodeR2__c = '441',Related_Fault_Code__c = '234,546');
        fc2.Name = '441';
        fc2.Job_Order__c = Jo.Id;
        fc2.Sequence__c = 1; 
        fc2.Fault_Code_Type__c = 'BPD-P';
        fc2.Mod__c = '0';
        fc2.isPole__c = false;
        insert fc2;
        CSS_Solutions__c sol = new CSS_Solutions__c();
        sol.Service_Job__c = Jo.ID;
        sol.Case_Name__c = 'ABC';
        sol.Solution_Title__c='CDE';
        sol.Name='ABC';
        sol.Fault_Codes__c =fc2.FaultCode__c;
        sol.Diagnostic_Response__c ='	Most likely the solution';
        sol.Repair_Response__c = 'Most likely the solution';
        sol.Out_Of_Order__c = true;
        sol.Rank__c = 2;
        sol.Solution__c = 'Solution1';
        insert sol;
        CSS_Solution_Component__c solComp = new CSS_Solution_Component__c();
        solComp.Component_Id__c ='F0051000';
        solComp.Service_Job__c = Jo.id;
        solComp.Solutions__c = sol.id;
        solComp.Action__c = '';
        
        insert solComp;
        
        /*   CSS_CampTsbTrp__c ct = new CSS_CampTsbTrp__c();
ct.name = 'CAM';
ct.name = 'TRP';
ct.name = 'TSB';
insert ct;*/
        //  list < CSS_CampTsbTrp__c > solutionList = new list < CSS_CampTsbTrp__c > ();
        //CSS_Solutions__c cssSol;
        
        
        /*  CSS_CampTsbTrp__c solRec = new CSS_CampTsbTrp__c(Doc_Num__c = 'TSB140168', URL__c = 'https://qsolpilot.cummins.com/qs3/pubsys2/xml/en/tsb/2014/tsb140168.html',
Type__c = 'CAM', Doc_Title__c = 'xyz', Cu_Language__c = 'xc', Performed__c = false, Job_Order__c = Jo.Id,
Performed_Review__c = true, Reviewed__c = true, esn__c = '79464646');
insert solRec;*/
        
        //pref = jobplan.saveAndCloseJob();
        jobplan.Wid = jo.id;
        jobplan.comm = 'sample';
        Note x2 = new Note();
        x2.Title = 'CAMPCOMMENTS';
        x2.ParentId = jobplan.Wid; 
        x2.Body =  jobplan.comm;
        insert x2;
        jobPlan.showJobPlanBlocks(false,false,false,true,false,false,false); 
        List<CSS_Quote__c> quotelst = new List<CSS_Quote__c>();
        CSS_Quote__c quote = new CSS_Quote__c();
        //quote.id = jo.id;
        
        quote.OrderReference__c = 'qwerty1345';
        quote.Service_Job__c = jo.Id;
        insert quote;
        quotelst.add(quote);
        jobPlan.ChkFieldBlank();
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
        solRec.clear();
        jobPlan.closeSession_Close();
        jobPlan.showPopup();
        
        jobPlan.redirectPopup();  
        jobPlan.Cancel();
        jobPlan.saveCause();
        jobPlan.saveComplaint();
        jobPlan.saveCorrection();
        jobPlan.saveCoverage();
        jobPlan.saveNonSRTDetails();
        jobPlan.sendNarrativeToERP();
        jobplan.showResolution = true;
        jobplan.requiredBMSMessage = true;
        jobplan.showRepairErrorMessage = true;
        jobplan.dsidStatus = true;
        jobplan.showResolutionWithRepair = true;
        jobplan.showRepairs = true;
        jobplan.saveAndCloseJob();
        jobplan.nonSRTnotes='test';
        
        
        
        //CSS_WPR_JobPlanOverview jpo = new CSS_WPR_JobPlanOverview();
        
        Test.stopTest();
    }
    
    static testmethod void testcancel()
    {
    CSS_JobPlanNarrativeController jobPlan= new CSS_JobPlanNarrativeController();
        //jobplan.ChkFieldBlank();
       // jobplan.cancel();
     // jobplan.closeSession();
        
    }
    
    static testmethod void testmethod3()
    {
		Account acc = new Account();
      acc.ERP_System__c ='One BMS';
      acc.Name='Testing';
      insert acc;        
        Test.startTest();
        
        Id currentUserID=UserInfo.getUserId();
        list<user> userids = [select id,name from user limit 3]; 
        
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
        JO.BMSStatus__c = 'QTFI0';
        JO.Shop_Work_Order__c = '222';
        JO.CSS_Resolution__c = 'Solved';
        JO.DSID__c = '1234';
        JO.General_Symptoms__c = '';
        JO.chevron_page__c = 'Narr';
        JO.Non_SRT_Details__c = '123';
        insert(JO);      
        PageReference pref;
        pref = new PageReference('/'+JO.id);
        pref.getParameters().put('id',JO.id);
        //pref.getParameters().put('partsUr','Parts');
        Test.setCurrentPage(pref);
        
        Note x = new Note();
        x.Title = 'CAMPCOMMENTS';
        x.ParentId = JO.id;  
        x.Body = 'comm';
        insert x;
        
        CSS_JobPlanNarrativeController jobPlan= new CSS_JobPlanNarrativeController();
        // jobPlan.showRepairs = FALSE;
        
        
        
        JobPlan.workJob = [Select Id,Name,AccessCode__c,Customer_Name__c,Shop_Work_Order__c, Application__c, Application_Desc__c, BMS_Last_Name__c, DSID_WorkGroup__c, Unit_Number__c, Date_in__c, INSITE_UpdateTimeStamp__c, First_Name__c,
                           Repair_Location__c,Failure_Date__c, Failure_Point__c, Failure_Point_Measure__c, Service_Model__c,BMSStatus__c,Unit_Type__c, VIN__c, Warranty_Start_Date__c,Make__c, Qsol_Engine_Family_Code__c,
                           DSID__c, DSID_Creation_Timestamp__c, DSID_Status__c, Repeat_Or_Recent_Calc__c, DSID_UpdateTimestamp__c,Customer_Code__c,Status__c,
                           Phone_Number__c, Previous_Status__c,Sub_Type__c, Category__c, Complaint_Type__c, Model__c,Creator_Location__c, Control_Number__c,
                           Assigned_to__r.Name,Additional_Tech1__r.Name,Additional_Tech2__r.Name,OwnerId,JobLocation__c,CSS_Resolution__c,CSS_Feedback_Comments__c, BMSWSStatus__c,
                           ESN__c, Mileage__c, Mileage_Measure__c, chevron_page__c, General_Symptoms__c, Assigned_To__c, LastModifiedDate,CreatedDate,ESN_Locked__c,Region__c,Territory__c,EditComplaint__c,EditCorrection__c,EditCoverage__c,EditCause__c
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
        CSS_CampTsbTrp__c x1 = new CSS_CampTsbTrp__c();
        x1.Job_order__c = Jo.Id;
        x1.performed_review__c = true;
        x1.performed__c =false;
        insert x1;
        jobPlan.jobClosePopup(); 
        CSS_Fault_Code__c fc2 = new CSS_Fault_Code__c(FaultCodeR2__c = '441',Related_Fault_Code__c = '234,546');
        fc2.Name = '441';
        fc2.Job_Order__c = Jo.Id;
        fc2.Sequence__c = 1; 
        fc2.Fault_Code_Type__c = 'BPD-P';
        fc2.Mod__c = '0';
        fc2.isPole__c = false;
        insert fc2;
        list<CSS_Solutions__c> postRepairList = new list<CSS_Solutions__c>();
        CSS_Solutions__c sol = new CSS_Solutions__c();
        sol.Service_Job__c = Jo.ID;
        sol.Case_Name__c = 'ABC';
        sol.Solution_Title__c='CDE';
        sol.Name='ABC';
        sol.Fault_Codes__c =fc2.FaultCode__c;
        sol.Diagnostic_Response__c ='	Most likely the solution';
        sol.Repair_Response__c = 'Most likely the solution';
        sol.Out_Of_Order__c = true;
        sol.Rank__c = 2;
        sol.Solution__c = 'Solution1';
        insert sol;
        postRepairList.add(sol);
        CSS_Solution_Component__c solComp = new CSS_Solution_Component__c();
        solComp.Component_Id__c ='F0051000';
        solComp.Service_Job__c = Jo.id;
        solComp.Solutions__c = sol.id;
        solComp.Action__c = '';
        
        insert solComp;
        
        /*   CSS_CampTsbTrp__c ct = new CSS_CampTsbTrp__c();
ct.name = 'CAM';
ct.name = 'TRP';
ct.name = 'TSB';
insert ct;*/
          list < CSS_CampTsbTrp__c > solutionList = new list < CSS_CampTsbTrp__c > ();
        //CSS_Solutions__c cssSol;
        
        
         CSS_CampTsbTrp__c solRec = new CSS_CampTsbTrp__c(Doc_Num__c = 'TSB140168', URL__c = 'https://qsolpilot.cummins.com/qs3/pubsys2/xml/en/tsb/2014/tsb140168.html',
Type__c = 'CAM', Doc_Title__c = 'xyz', Cu_Language__c = 'xc', Performed__c = false, Job_Order__c = Jo.Id,
Performed_Review__c = true, Reviewed__c = true, esn__c = '79464646');
insert solRec;
        solutionList.add(solRec);
        /*CSS_Job_Order__c closeJob = [Select id,DSID__c, (Select Id,Name, Case_Name__c, Service_Job__c,Repair_response__c,Out_Of_Order__c,Rank__c,Solution_Title__c ,
                                            Solution__c,Diagnostic_Response__c FROM CSS_Solutions__r where service_job__c =JO.id), (Select id, name , performed__c, performed_review__c, 
                                                                                                                                   Reviewed__c from CSS_CampTsbTrp__r where job_order__C=JO.id and( performed_review__c=True and performed__c=False))                    
                        from CSS_Job_Order__c where id=JO.id];*/
        
        //pref = jobplan.saveAndCloseJob();
        jobplan.Wid = jo.id;
        jobplan.comm = 'sample';
        Note x2 = new Note();
        x2.Title = 'CAMPCOMMENTS';
        x2.ParentId = jobplan.Wid; 
        x2.Body =  jobplan.comm;
        insert x2;
        jobPlan.showJobPlanBlocks(false,false,false,true,false,false,false); 
        List<CSS_Quote__c> quotelst = new List<CSS_Quote__c>();
        CSS_Quote__c quote = new CSS_Quote__c();
        //quote.id = jo.id;
        
        quote.OrderReference__c = 'qwerty1345';
        quote.Service_Job__c = jo.Id;
        insert quote;
        quotelst.add(quote);
        jobPlan.displayNarrativeButton = true;
        //jobPlan.ChkFieldBlank();
        pref = jobPlan.jobplan_prt();
        pref = jobPlan.jobplan_srt();
        pref = jobPlan.jobplan_war();
        pref = jobPlan.jobplan_narr();
        pref = jobPlan.jobplan_jo();
        pref = jobPlan.jobplan_jpq();
        pref = jobPlan.pgSave();
        pref = jobPlan.pgSaveFinish();
        pref = jobPlan.saveCheckBox();
        //list<css_CampTsbTrp__c> tsbTrpToBePerformed = null;
        pref = jobPlan.closeSession();
        solutionList=null;
         pref = jobPlan.closeSession();
        jobplan.jobClosePopup();
        jobplan.showResolutionWithRepair=true;
        jobplan.showRepairs=true;
        jobPlan.saveAndCloseJob();
        jobPlan.closeSession_Close();
        jobPlan.showPopup();
        
        jobPlan.redirectPopup();  
        jobPlan.Cancel();
        
        jobPlan.saveCause();
        jobPlan.saveComplaint();
        jobPlan.saveCorrection();
        jobPlan.saveCoverage();
        jobPlan.saveNonSRTDetails();
        jobPlan.sendNarrativeToERP();
        
        jobplan.showResolution = true;
        jobplan.requiredBMSMessage = true;
        jobplan.showRepairErrorMessage = true;
        jobplan.dsidStatus = true;
        jobplan.showResolutionWithRepair = true;
        jobplan.showRepairs = true;
        jobplan.bmsEnabled=true;
        jobPlan.saveAndCloseJob();
        jobplan.nonSRTnotes='test';
        
        
        //CSS_WPR_JobPlanOverview jpo = new CSS_WPR_JobPlanOverview();
        
        Test.stopTest();
    }
    
    static testmethod void  ChkFieldBlank()
    {
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
        
        CSS_JobPlanNarrativeController jobPlan= new CSS_JobPlanNarrativeController();
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
        pref = jobPlan.jobplan_narr();
        
        jobPlan.jobplan_narr();
        jobPlan.pgSave();
        // jobPlan.Cancel();
        
        Test.stopTest();
    } 
    
    static testmethod void m1()
    {
        CSS_CampTsbTrp__c ctt = new CSS_CampTsbTrp__c();
        ctt.Type__c = 'ATC';
        ctt.URL__c = 'https://qs-stg.cummins.com/qs3/pubsys2/xml/en/atc/19TC/atc1623.html';
        ctt.Doc_Num__c = 'ATCF0051000';
        ctt.Doc_Title__c = 'DUAL FUEL DATAPLATE ATC';
        ctt.Performed__c = false;
        ctt.Performed_Review__c = true;
        ctt.Reviewed__c = false;
        ctt.job_order__c = null;
        
        insert ctt;
        CSS_JobPlanNarrativeController jobPlan= new CSS_JobPlanNarrativeController();
        
        
        
    }
    
    static testmethod void testmethod5()
    {
        CSS_Job_Order__c JO = new CSS_Job_Order__c();
        JO.Customer_Name__c = 'Test';
        JO.DSID__c = 'DS455';
        JO.EditComplaint__c = 'wwwwwweeeeee';
        JO.EditCoverage__c = 'ccddddddd';
        JO.EditCorrection__c = 'dcsscscs';
        JO.chevron_page__c = 'war';
        Jo.CSS_Resolution__c = 'changed valve';
        insert JO;
        
        List<CSS_Solutions__c> CSLst = new List<CSS_Solutions__c>();
        CSS_Solutions__c CS = new CSS_Solutions__c();
        CS.Service_Job__c = Jo.Id;
        CS.Repair_Response__c = 'unsuccessful';
        CsLst.add(CS);
        
        CSS_Solutions__c CS1 = new CSS_Solutions__c();
        CS1.Service_Job__c = Jo.Id;
        CS1.Repair_Response__c = 'Successful';
        CsLst.add(CS1);
        
        insert CSLst;
        
        CSS_CampTsbTrp__c x1 = new CSS_CampTsbTrp__c();
        x1.Job_order__c = JO.Id;
        x1.performed_review__c = true;
        x1.performed__c =false;
        X1.Type__c = 'CAM';
        insert x1;
        
        CG_cancelServiceJobWrapper cancelSJWrapperObj1 = new CG_cancelServiceJobWrapper();
        cancelSJWrapperObj1.errorFlag = true;
        
        
        PageReference pref;
        pref = new PageReference('/'+JO.id);
        pref.getParameters().put('id',JO.id);
        Test.setCurrentPage(pref);
        
        CSS_JobPlanNarrativeController jobPlan= new CSS_JobPlanNarrativeController();
        jobPlan.cancelSJWrapperObj1 = cancelSJWrapperObj1;
        jobplan.showResolutionWithRepair = null;
        jobplan.showRepairs = true;
        jobplan.showResolution = false;
        jobplan.responseValues = CSLst;
       // jobplan.postRepairList = CSLst;
        jobplan.saveAndCloseJob();
        
        PageReference pref1;
        pref1 = new PageReference('/');
        pref1.getParameters().put('id',null);
        Test.setCurrentPage(pref1);
        
        jobPlan.pgSave();
        jobplan.pgSaveFinish();
        
        
    }
    
  
    
}