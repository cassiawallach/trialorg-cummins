/*This test class is written for job plan warranty controller*/
@isTest
public class CSS_JobPlanWarrantyController_Test 
{
    static testmethod void testmethod1()
    {
        
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
        
        
        Test.setCurrentPage(pref);
        
        CSS_JobPlanWarrantyController jobPlan= new CSS_JobPlanWarrantyController();
        
        
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
        sol.add(solRef);
        insert sol;
        
        CSS_CampTsbTrp__c x1 = new CSS_CampTsbTrp__c();
        x1.performed_review__c = true;
        x1.performed__c =false;
        insert x1;
        
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
        
        
        Test.stopTest();
    }
   
    static testmethod void testmethod4()
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
        Test.setCurrentPage(pref);
        
        Note x = new Note();
        x.Title = 'CAMPCOMMENTS';
        x.ParentId = JO.id;  
        x.Body = 'comm';
        insert x;
        
        CSS_JobPlanWarrantyController jobPlan= new CSS_JobPlanWarrantyController();
        
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
        
        
        jobplan.showResolution = true;
        jobplan.requiredBMSMessage = true;
        jobplan.showRepairErrorMessage = true;
        jobplan.dsidStatus = true;
        jobplan.showResolutionWithRepair = true;
        jobplan.showRepairs = true;
        jobPlan.saveAndCloseJob();
        
        Test.stopTest();
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
        
        CSS_JobPlanWarrantyController jobPlan= new CSS_JobPlanWarrantyController();
        jobPlan.cancelSJWrapperObj1 = cancelSJWrapperObj1;
        jobplan.showResolutionWithRepair = null;
        jobplan.showRepairs = true;
        jobplan.showResolution = false;
        jobplan.responseValues = CSLst;
       // jobplan.postRepairList = CSLst;
        jobplan.saveAndCloseJob();
        
    }
    
}