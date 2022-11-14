@isTest
public class CSS_JobPlanPartsController_Test {
    static testMethod void TestMethod1() {
        Account acc = new Account();
        acc.ERP_System__c ='One BMS';
        acc.Name='Testing';
        insert acc;
        CSS_UserLocation__c userLocation = new CSS_UserLocation__c(AccountId__c=acc.id,isActive__c=true,isPrimary__c=true,UserId__c=userInfo.getUserId(),Location_code__c='56270-56255');
        // lstUserLocations.add(userLocation);
        insert userLocation;
        ID cId=apexpages.currentPage().getparameters().get('id');
        CSS_Job_Order__c JO = new CSS_Job_Order__c();
        JO.Customer_Name__c = 'Roopa';
        JO.Application__c = 'Recreational Vehicle';
        JO.Model__c = 'RoopaTest';
        JO.Make__c = 'CSSTest';
        JO.Notes__c = 'CAMPCOMMENTS';
        JO.Failure_Point__c = 122;
        JO.Failure_Point_Measure__c = 'Miles';
        JO.VIN__c = '12345677890';
        JO.Failure_Date__c = date.today() - 20;
        JO.Warranty_Start_Date__c = date.today() - 365;
        JO.Location_Certification__c = 'abc';
        JO.jobLocation__c = 'abc';
        JO.Before_In_Service__c = True;
        //JO.lo = 10;
        //JO.Shop_s_Work_Order__c = 120;
        JO.Status__c = 'closed';
        JO.Unit_Number__c = 'test123';
        Jo.Assigned_To__c = UserInfo.getUserId();
        Jo.esn__c = '79464646';
        JO.Unit_Type__c = 'type';
        Jo.Country__c = 'United States';
        Jo.CSS_State__c = 'Indiana';
        Jo.City__c = 'Columbus';
        Jo.Customer_Code__c = '23456';
        Jo.EditComplaint__c = 'complaint';
        Jo.EditCoverage__c = 'coverage';
        Jo.EditCause__c = 'cause';
        Jo.EditCorrection__c = 'correction';
        JO.chevron_page__c = 'prt';
        JO.CSS_Resolution__c = 'Test';
        JO.DSID__c = 'VFD23';
        JO.BMSWSStatus__c='UI0';
        JO.Account__c = acc.id;
        Jo.BMSStatus__c='yarn';
        Jo.CSS_Job_Location_Code__c ='56270-56255';
        insert JO;
        
        CSS_Job_Order__c JO1 = new CSS_Job_Order__c(); 
        JO1.Customer_Name__c = null;
        JO1.Shop_Work_Order__c = null;
        JO1.Application_Desc__c =null;
        JO1.Unit_Number__c = null;
        JO1.Mileage__c = null;
        JO1.ESN__c = null;
        JO1.General_Symptoms__c = null;
        insert JO1;
        
        
        PageReference pref;
        pref = new PageReference('/'+JO.id);
        pref.getParameters().put('id',JO.id);
        //pref.getParameters().put('partsUr','Parts');
        Test.setCurrentPage(pref);
        /*   
CSS_CampTsbTrp__c x1 = new CSS_CampTsbTrp__c();
x1.Job_order__c = Jo.Id;
x1.performed_review__c = true;
x1.performed__c =false;
insert x1;
*/
        
        
        
        List<CSS_Solutions__c> listcomp = new List<CSS_Solutions__c>();
        CSS_Solutions__c sol = new CSS_Solutions__c();
        sol.Service_Job__c = Jo.ID;
        sol.Case_Name__c = 'ABC';
        sol.Solution_Title__c='CDE';
        sol.Name='ABC';
        //sol.Fault_Codes__c =fc2.FaultCode__c;
        sol.Diagnostic_Response__c ='Most likely the solution';
        sol.Repair_Response__c = 'Most likely';
        insert sol;
        listcomp.add(sol);
        CSS_Solutions__c sole = new CSS_Solutions__c();
        sole.Service_Job__c = Jo.ID;
        sole.Case_Name__c = 'ABC';
        
        sole.Solution_Title__c='CDE';
        sole.Name='ABC';
        sole.Diagnostic_Response__c ='Most likely the solution';
        sole.Repair_Response__c = 'Most likely';
        insert sole;
        listcomp.add(sole);
        
        List<CSS_Solution_Component__c> sollist = new List<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solComp = new CSS_Solution_Component__c();
        solComp.Component_Id__c ='F0051000';
        solComp.Service_Job__c = Jo.id;
        solComp.Solutions__c = sol.id;
        solComp.Action__c = '';
        //solcomp.
        insert solComp;
        sollist.add(solComp);
        
        List<CSS_Solution_Component__c> solcomplist = new List<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solcomp1 = new CSS_Solution_Component__c();
        //solcomp1.Id =
        solcomp1.Component_Id__c ='F0051000';
        solcomp1.Service_Job__c = Jo.id;
        solcomp1.Solutions__c = sol.id; 
        solcomp1.Type__c='test';
        solcomp1.CampaignPartsPercentage__c ='2';
        solcomp1.CampaignOCPercentage__c = '3';
        insert solcomp1;
        CSS_Solution_Component__c solcomp2 = new CSS_Solution_Component__c();
        
        solcomp2.Component_Id__c ='F0051000';
        solcomp2.Service_Job__c = Jo.id;
        solcomp2.Solutions__c = sol.id; 
        solcomp2.Type__c='Campaign';
        solcomp2.CoveredPartsQty__c ='2';
        solcomp2.CoveredOCAmount__c = '3';
        insert solcomp2;
        solcomplist.add(solcomp1);
        solcomplist.add(solcomp2);
        List<id> ids = new List<id>();
        ids.add(solcomp1.id);
        ids.add(solcomp2.id);
        Id recTyIdpart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'Parts'); 
        Id recTyIdpart1 = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'OtherClaimables'); 
        List<CSS_Parts_Options__c> lstparts = new List<CSS_Parts_Options__c>();
        CSS_Parts_Options__c parts = new CSS_Parts_Options__c();
        parts.Covered__c =0.0;
        parts.RecordTypeId=recTyIdpart;
        parts.FailurepartId__c = solcomplist[0].id;
        parts.Fail_Code__c ='test';
        parts.Service_partnumber__c='test';
        parts.Account_Code__c = 'test1';
        lstparts.add(parts);
        // insert lstparts;
        CSS_Parts_Options__c parts1 = new CSS_Parts_Options__c();
        parts1.Covered__c =0.0;
        parts1.RecordTypeId=recTyIdpart1;
        parts1.FailurepartId__c = solcomplist[0].id;
        parts1.Fail_Code__c ='test';
        parts1.Service_partnumber__c='test';
        parts1.Account_Code__c = 'test1';
        lstparts.add(parts1);
        insert lstparts;
        css_parts_options__c poc1=new css_parts_options__c();
        
        poc1.RecordTypeId=recTyIdpart1;
        poc1.FailurepartId__c = solcomplist[1].id;
        poc1.selected_part__c=true;
        poc1.Service_Job__c = Jo.id;
        poc1.Parts_Type__c = 'Testing';
        insert poc1;
        css_parts_options__c poc2=new css_parts_options__c();
        
        poc2.RecordTypeId=recTyIdpart;
        poc2.FailurepartId__c = solcomplist[1].id;
        poc2.selected_part__c=true;
        poc2.Service_Job__c = Jo.id;
        poc2.Parts_Type__c = 'Testing';
        insert poc2;
        CSS_JobPlanPartsController.updateAccountCode(ids);
        
        list<css_parts_options__c> lpo=new list<css_parts_options__c>();
        
        
        css_parts_options__c poc=new css_parts_options__c();
        
        poc.RecordTypeId=recTyIdpart;
        // poc.FailurepartId__c = solcomplist[1].id;
        poc.selected_part__c=true;
        poc.Service_Job__c = Jo.id;
        poc.Parts_Type__c = 'Testing';
        insert poc;
        
        lpo.add(poc);
        
        CSS_getPartsListBMSRequestJ2A getGSQParts = new CSS_getPartsListBMSRequestJ2A();
        Test.setMock(HttpCalloutMock.class, new CSS_MockHttpResponseGenerator());
        
        Test.startTest();
        PageReference pg = Page.CSS_JobPlanParts;
        Test.setCurrentPage(pg);
        ApexPages.currentPage().getParameters().put('id', jo.Id);
        CSS_JobPlanPartsController jppc1 = new CSS_JobPlanPartsController ();
        string c = jppc1.comm = 'ghhyewk';
        jppc1.show_jo_pnl = false;
        jppc1.show_jov_pnl  = false;
        jppc1.show_jpq_pnl = true;
        jppc1.show_war_pnl = false;
        jppc1.show_prt_pnl = false;
        jppc1.show_narr_pnl = false;
        jppc1.show_srt_pnl = false ;      
        jppc1.workjobStatus = 'Testing';
        jppc1.sendparts = lstparts;
        jppc1.mil_measure ='Testing';
        jppc1.jobLocation = 'Bangalore';
        jppc1.bmsUserCloseFlag = false;
        jppc1.showErrorERP =  false;
        
        
        //jppc1.postRepairList = solComp;
        
        jppc1.showJobPlanBlocks(false,false,true,false,false,false,false);
        jppc1.jobplan_prt();
        jppc1.jobplan_srt();
        jppc1.jobplan_war();
        jppc1.ChkFieldBlank();
        jppc1.updatestatus();
        jppc1.pgSave();
        jppc1.pgSaveFinish();
        jppc1.saveCheckBox();
        jppc1.closeSession_close();
        //jppc1.updateAccountCode(idList);
        jppc1.jobPlanPartsAction();
        //jppc1.onChangeOfUnitNumber();
        jppc1.closeSession();
        jppc1.jobClosePopup();
        jppc1.showResolution = true;
        jppc1.showRepairs = false;
        //insert jppc1;
        CSS_Solutions__c solc = new CSS_Solutions__c();
        solc.Service_Job__c = Jo.ID;
        solc.Case_Name__c = 'ABC';
        solc.Solution_Title__c='CDE';
        solc.Name='ABC';
        solc.Diagnostic_Response__c ='Most likely the solution';
        solc.Repair_Response__c = 'Successful';
        //solc.jobClosePopup();
        insert solc;
        //jppc1.closeSession();
        //jppc1.jobClosePopup();
        //jppc1.showResolution = true;
        //jppc1.showRepairs = false;
        CSS_Job_Order__c JO3 = new CSS_Job_Order__c(); 
        //JO3.Name = 'ABC';
        //JO3.Creator_Location__c = 'NA';
        insert JO3;
        //jppc1.sendPartsToERP();
        
        //jppc1.callUnitInboundGeneric();
        Test.setMock(HttpCalloutMock.class, new CSS_MockHttpResponseGenerator()); 
        CSS_unitInboundJSON2Apex unj = new CSS_unitInboundJSON2Apex();
        CG_OP_OAGWrapper WOQTOPWrap = new CG_OP_OAGWrapper();
        //WOQTOPWrap = cg_sl_bms.sendMISCCharges('56270-56255',jo.Name,'56270','56255','123','WOQT',jo.Quote_ID__c,'Y');
        CG_BMSSendMiscChargesRespWrapper sendMiscRespJSON = new CG_BMSSendMiscChargesRespWrapper();
        CSS_unitInboundJSON2Apex.DataArea jidi = new CSS_unitInboundJSON2Apex.DataArea();
        unj.DataArea = jidi;
        jidi.UnitNumber = 'ERT23';
        //jppc1.onChangeOfUnitNumber();
        jppc1.updateservjob();
        jppc1.showPopup();
        jppc1.redirectPopup();
        jppc1.Cancel();
        jppc1.jobplan_jo();
        jppc1.jobplan_narr();
        jppc1.jobplan_jpq();
        jppc1.showRepairs=null;
        //jppc1.showResolutionWithRepair=null;
        jppc1.showRepairs=true;
        jppc1.showResolutionWithRepair=false;
        CSS_Job_Order__c JO2 = new CSS_Job_Order__c();
        JO2.Customer_Name__c = 'CumminsTnD';
        JO2.Equipment_ID__c = 'EQ7667';
        JO2.Qsol_Engine_Family_Code__c ='56';
        JO2.AccessCode__c = 'A';
        insert JO2;
        List<CSS_Solutions__c> responseValue = new List<CSS_Solutions__c>();
        CSS_Solutions__c solAdd = new CSS_Solutions__c();
        solAdd.Service_Job__c = JO2.ID;
        solAdd.Case_Name__c = 'Additional SRTS';
        solAdd.Solution_Title__c='Additional SRTS';
        solAdd.Name='Additional SRTS';
        solAdd.Diagnostic_Response__c ='Most likely the solution';
        solAdd.Repair_Response__c = 'Most likely ';
        insert solAdd;
        CSS_Solutions__c solAdd1 = new CSS_Solutions__c();
        solAdd1.Service_Job__c = JO2.ID;
        solAdd1.Case_Name__c = 'Additional SRTS';
        solAdd1.Solution_Title__c='Additional SRTS';
        solAdd1.Name='Additional SRTS';
        solAdd1.Diagnostic_Response__c ='Most likely the solution';
        solAdd1.Repair_Response__c = null;
        insert solAdd1;
        responseValue.add(solAdd);
        responseValue.add(solAdd1);
        
        CSS_Solutions__c solAdd3 = new CSS_Solutions__c();
        solAdd3.Service_Job__c = JO2.ID;
        solAdd3.Case_Name__c = 'Additional SRTS';
        solAdd3.Solution_Title__c='Additional SRTS';
        solAdd3.Name='Additional SRTS';
        solAdd3.Diagnostic_Response__c ='Most likely the solution';
        solAdd3.Repair_Response__c = 'Successful ';
        insert solAdd3;
        List<CSS_Solutions__c> postRepairList =new  List<CSS_Solutions__c>();
        postRepairList.add(solAdd3);
        //postRepairLis.add(solAdd2);
        
        //responseValue.add(solAdd);
        
        jppc1.responseValues = responseValue;
        //jppc1.postRepairList = postRepairLis;
        jppc1.saveAndCloseJob();
        jppc1.requiredBMSMessage = true;
        jppc1.updateSubstatus();
        jppc1.sendPartsAndClaimablesToERP();
        jppc1.showResolutionWithRepair = true;
        jppc1.showResolution = true;
        integer i = jppc1.complaintcounter = 2;
        integer int2 = jppc1.coveragecounter = 3;
        integer int1 = jppc1.causecounter = 3;
        integer int3 = jppc1.correctioncounter = 3;
        jppc1.accQuoteFlag = true;
        jppc1.NotesBody = 'hhhhh';
        jppc1.dsidStatus = true;
        jppc1.showRepairErrorMessage = true;
        jppc1.showRepairs = true;
        jppc1.displayPartsButton = true;
        jppc1.displayPartsButtonDist = true;
        jppc1.displayERPButtonDlr = true;
        jppc1.displaySendERP_Button= true;
        jppc1.requiredBMSMessage = true;
        jppc1.showSucessERP = true;
        jppc1.ERPErrorMsg1 ='Error';
        jppc1.workjobStatus ='Error';
        jppc1.mil_measure = 'measure';
        jppc1.showRepairs=true;
        jppc1.showResolutionWithRepair=null;
        
        
        Note x = new Note();
        x.Title = 'CAMPCOMMENTS';
        x.ParentId = JO.Id;  
        x.Body = c;
        insert x;
        PageReference pg1 = Page.CSS_JobPlanParts;
        Test.setCurrentPage(pg1);
        ApexPages.currentPage().getParameters().put('id', jo.Id);
        
        /*CSS_getPartsListBMSResponseJ2A WOQTOPWrap = new CSS_getPartsListBMSResponseJ2A();
WOQTOPWrap.partShowSucessERP = false;
WOQTOPWrap.showErrorERP = true;*/
        Test.stopTest();
    }
    
    
    static testMethod void TestMethod2_wid_null() {
        Test.startTest();
        CSS_JobPlanPartsController jppc = new CSS_JobPlanPartsController ();
        jppc.faultList = null;
        jppc.partlist = null;
        jppc.partlistFAULT = null;
        Test.stopTest();
    }
    
    static testMethod void TestMethod3() {
        Test.startTest();
        css_job_order__c worecord= new css_job_order__c();
        worecord.Previous_Status__c = 'Error';
        worecord.Status__c='Closed';
        worecord.BMSWSStatus__c = 'Open';
        worecord.Unit_Number__c = 'test123';
        //worecord.Actual_Technician_Time__c = ;
        insert worecord;
        CSS_JobPlanPartsController jppc = new CSS_JobPlanPartsController ();
        //   PageReference ref = jppc.pgSaveFinish();
        // cId=apexpages.currentPage().getparameters().get('null');
        jppc.wid=null;
        //jppc.pgSave();
        // jppc.pgSaveFinish();
        Test.stopTest();
    }
    
    
    static testmethod void sendOtherClaimableToERPmethod(){
        
        CSS_Job_Order__c JO = new CSS_Job_Order__c();
        JO.Customer_Name__c = 'Roopa';
        JO.Application__c = 'Recreational Vehicle';
        JO.Model__c = 'RoopaTest';
        JO.Make__c = 'CSSTest';
        JO.Notes__c = 'CAMPCOMMENTS';
        JO.Failure_Point__c = 122;
        JO.Failure_Point_Measure__c = 'Miles';
        JO.VIN__c = '12345677890';
        JO.Failure_Date__c = date.today() - 20;
        JO.Warranty_Start_Date__c = date.today() - 365;
        JO.Location_Certification__c = 'abc';
        JO.jobLocation__c = 'abc';
        JO.Before_In_Service__c = True;
        //JO.lo = 10;
        //JO.Shop_s_Work_Order__c = 120;
        JO.Status__c = 'Repair Complete';
        JO.Unit_Number__c = 'test123';
        Jo.Assigned_To__c = UserInfo.getUserId();
        Jo.esn__c = '79464646';
        JO.Unit_Type__c = 'type';
        Jo.Country__c = 'United States';
        Jo.CSS_State__c = 'Indiana';
        Jo.City__c = 'Columbus';
        Jo.Customer_Code__c = '23456';
        Jo.EditComplaint__c = 'complaint';
        Jo.EditCoverage__c = 'coverage';
        Jo.EditCause__c = 'cause';
        Jo.EditCorrection__c = 'correction';
        JO.chevron_page__c = 'prt';
        JO.CSS_Resolution__c = 'Test';
        JO.DSID__c = 'VFD23';
        JO.Quote_ID__c=null;
        
        insert JO;
        
        PageReference pref;
        pref = new PageReference('/'+JO.id);
        pref.getParameters().put('id',JO.id);
        //pref.getParameters().put('partsUr','Parts');
        Test.setCurrentPage(pref);
        CSS_JobEventTemporary__c je = CSS_TestData.createJobEventTempObj(false);
        String json = '{'+
            '  \"Details\": {'+
            '    \"ApplicationCode\": \"12345\",'+
            '    \"Description\": \"testing\",'+
            '    \"BusinessUnit\": \"GetAssessData\",'+
            '    \"AutomotiveFlag\": \"Fault Details Data sent successfully\",'+
            '    \"MarineFlag\": \"Fault Details Data sent successfully\",'+   
            '    \"ActiveFlag\": \"Y\",'+    
            '    \"DefaultUom\": \"Fault Details Data sent successfully\"'+     
            '  },'+
            '  \"Header\": {'+   
            '        \"ReturnCodeDescription\": \"Test\",'+
            '        \"Status\": \"completed\"'+
            '      }'+
            '}'; 
        String jsonCategory = '{"DataArea": {"Details": [{"ComplaintCode": "123","Description": "abc","BusinessUnit": "EBU","ActiveFlag": "Y","Category": "aaa"},{"ComplaintCode": "345","Description": "tavdg","BusinessUnit": "PSBU","ActiveFlag": "N","Category": "bbb"}]},"Header": {"ReturnCodeDescription": "","Status": "Success"}}';
        string jsonResponse='{"DataArea": {"Details": [{"ApplicationCode": "123","Description": "abc","BusinessUnit": "EBU","AutomotiveFlag": "Y","MarineFlag": "","ActiveFlag": "N","DefaultUom": "miles"},{"ApplicationCode": "555","Description": "zxcv","BusinessUnit": "PSBU","AutomotiveFlag": "","MarineFlag": "N","ActiveFlag": "Y","DefaultUom": "miles"}]},"Header": {"ReturnCodeDescription": "","Status": "Success"}}';
        je.Reason__c =  json;
        je.attribute1__c = 'ApplicationCodes';      
        insert je;
        
        Test.startTest();
        ApexPages.currentPage().getParameters().put('id',JO.id);
        Id Wid=ApexPages.CurrentPage().getParameters().get('id');
        
        css_parts_options__c poc1=new css_parts_options__c();
        poc1.Service_Job__c =JO.id;
        Id recTyIdpart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'TTML'); 
        poc1.RecordTypeId=recTyIdpart;
        poc1.Service_partnumber__c=null;
        poc1.selected_part__c=true;
        poc1.Item__c='Test';
        poc1.Siebel_Value__c='Test1';
        poc1.Type__c='Commercial-Travel';
        poc1.Type__c='Non Commercial-Travel';
        poc1.Type__c='Lodging';
        poc1.Type__c='Meals';
        poc1.Type__c='Towing';
        poc1.Quantity__c=null;
        
        insert poc1; 
        css_parts_options__c poc = [select ID,Service_Job__c,RecordType.name,Service_partnumber__c,selected_part__c from css_parts_options__c limit 1 ];
        System.debug('parts options' +poc);
        
        CSS_JobPlanPartsController jppc = new CSS_JobPlanPartsController ();
        jppc.Wid =Wid;
        jppc.sendOtherClaimableToERP();
        Test.stopTest();
    }
    
}