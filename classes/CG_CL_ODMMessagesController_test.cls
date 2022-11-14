@istest
public class CG_CL_ODMMessagesController_test {
    
    static testmethod void testmethod1()
    {
        
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02466';
        acc.IAM_Service_Provider_Code__c='19134';
        acc.Type='Dealer Account';
        acc.CMI_Account_Status__c = 'Active';
        insert acc;

        css_job_order__c jo = CSS_TestData.createJobOrder(false);
        jo.ODM_Status__c='warn';
        jo.Account__c = acc.id;
        jo.ODM_Status_Message__c='nullnull:BEA-382502-OSB Service Callout action received an error response-500;;null:BEA-382502-OSB Service Callout action received an error response-500;;';
        jo.ODM_Pre_submit_Status__c='ytbv';
        insert jo;
        
        ApexPages.currentPage().getParameters().put('Id',jo.Id);
        css_solutions__c sol = css_testdata.createSolutions(true, jo.Id);
        css_solution_component__c solcomp = css_testdata.createSRT(false, jo.Id, sol.id);
        solcomp.ODM_Status__c='WARN';
        solcomp.ODM_Status_Message__c='null:BEA-382502-OSB Service Callout action received an error response-500';
        solcomp.Fail_Code_Editable__c='Service Callout';
        insert solcomp;
        
        id recordpartid = schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName().get('TTML').getRecordTypeId();
        CSS_Parts_Options__c pa = new CSS_Parts_Options__c();
        pa.Option_Number__c = 'O-111';
        pa.Service_Job__c = jo.Id;
        pa.selected_part__c = true;
        pa.FailurepartId__c = solComp.Id;
        pa.Part_Assignment__c = 'Primary';
        pa.Solutions__c=sol.Id;
        pa.ODM_Status__c='warn';
        pa.ODM_Status_Message__c='null:BEA-382502-OSB Service Callout action received an error response-500';
        pa.Type__c='Commercial-Travel';
        pa.Item__c='Ties';
        pa.RecordTypeId=recordpartid;
        insert pa;
        
        CSS_SRT__C srt=css_testdata.createSRT(false,'Repair', sol.Id, jo.Id);
        srt.ODM_Status__c='warn';
        srt.ODM_Status_Message__c='SRT WArning';
        srt.FailCode__c='YNAPEW';
        srt.SRT_ID__c='00-901-00';
        insert srt;
        
        test.startTest();
        CG_CL_ODMMessagesController nw = new CG_CL_ODMMessagesController();
        nw.splitheaderjobRecStatusMsg();
        test.stopTest();
       
    }
   
     static testmethod void testmethod2()
    {
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02466';
        acc.IAM_Service_Provider_Code__c='19134';
        acc.Type='Dealer Account';
        acc.CMI_Account_Status__c = 'Active';
        insert acc;
        
        css_job_order__c jo = CSS_TestData.createJobOrder(false);
        jo.Account__c = acc.id;
        jo.ODM_Status__c='warn';
        jo.ODM_Status_Message__c='nullnull:BEA-382502-OSB Service Callout action received an error response-500;;null:BEA-382502-OSB Service Callout action received an error response-500;;';
        jo.ODM_Pre_submit_Status__c='ytbv';
        insert jo;
         ApexPages.currentPage().getParameters().put('Id',jo.Id);
        css_solutions__c sol = css_testdata.createSolutions(true, jo.Id);
        css_solution_component__c solcomp = css_testdata.createSRT(false, jo.Id, sol.id);
       solcomp.ODM_Status__c='WARN';
        solcomp.ODM_Status_Message__c='null:BEA-382502-OSB Service Callout action received an error response-500';
        solcomp.Fail_Code_Editable__c='Service Callout';
        insert solcomp;
        id recordpartid = schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName().get('BMS Parts').getRecordTypeId();
        CSS_Parts_Options__c pa = new CSS_Parts_Options__c();
        pa.Option_Number__c = 'O-111';
        pa.Service_Job__c = jo.Id;
        pa.selected_part__c = true;
        pa.FailurepartId__c = solComp.Id;
        pa.Part_Assignment__c = 'Primary';
        pa.Solutions__c=sol.Id;
        pa.ODM_Status__c='warn';
        pa.ODM_Status_Message__c='null:BEA-382502-OSB Service Callout action received an error response-500';
        pa.Type__c='Commercial-Travel';
        pa.Item__c='Ties';
        pa.RecordTypeId=recordpartid;
        insert pa;
        CSS_SRT__C srt=css_testdata.createSRT(false,'Repair', sol.Id, jo.Id);
        srt.ODM_Status__c='warn';
        srt.ODM_Status_Message__c='SRT WArning';
        srt.FailCode__c='YNAPEW';
        srt.SRT_ID__c='00-901-00';
        insert srt;
        test.startTest();
        CG_CL_ODMMessagesController nw = new CG_CL_ODMMessagesController();
        test.stopTest();
       
    }
    
    static testmethod void testmethod3()
    {
         Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02466';
        acc.IAM_Service_Provider_Code__c='19134';
        acc.Type='Dealer Account';
        acc.CMI_Account_Status__c = 'Active';
        insert acc;
        
        css_job_order__c jo = CSS_TestData.createJobOrder(false);
        jo.Account__c = acc.id;
        jo.ODM_Status__c='warn';
        jo.ODM_Status_Message__c='nullnull:BEA-382502-OSB Service Callout action received an error response-500;;null:BEA-382502-OSB Service Callout action received an error response-500;;';
        jo.ODM_Pre_submit_Status__c='ytbv';
        jo.ODM_Pre_Submit_Status_Message__c='null:BEA-382502-OSB Service Callout action received an error response-500';
        insert jo;
         ApexPages.currentPage().getParameters().put('Id',jo.Id);
        css_solutions__c sol = css_testdata.createSolutions(true, jo.Id);
        css_solution_component__c solcomp = css_testdata.createSRT(false, jo.Id, sol.id);
       solcomp.ODM_Status__c='WARN';
        solcomp.ODM_Status_Message__c='null:BEA-382502-OSB Service Callout action received an error response-500';
        solcomp.Fail_Code_Editable__c='Service Callout';
        insert solcomp;
        id recordpartid = schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName().get('OtherClaimables').getRecordTypeId();
        CSS_Parts_Options__c pa = new CSS_Parts_Options__c();
        pa.Option_Number__c = 'O-111';
        pa.Service_Job__c = jo.Id;
        pa.selected_part__c = true;
        pa.FailurepartId__c = solComp.Id;
        pa.Part_Assignment__c = 'Primary';
        pa.Solutions__c=sol.Id;
        pa.ODM_Status__c='warn';
        pa.ODM_Status_Message__c='null:BEA-382502-OSB Service Callout action received an error response-500';
        pa.Type__c='Commercial-Travel';
        pa.Item__c='Ties';
        pa.RecordTypeId=recordpartid;
        insert pa;
        CSS_SRT__C srt=css_testdata.createSRT(false,'Repair', sol.Id, jo.Id);
        srt.ODM_Status__c='warn';
        srt.ODM_Status_Message__c='SRT WArning';
        srt.FailCode__c='YNAPEW';
        srt.SRT_ID__c='00-901-00';
        insert srt;
        test.startTest();
        CG_CL_ODMMessagesController nw = new CG_CL_ODMMessagesController();
        test.stopTest();
       
    }
    
     static testmethod void testmethod4()
    {
        CG_CL_ODMMessagesController nw = new CG_CL_ODMMessagesController();
        system.assert(nw.jobODMStatus==null);
        system.assert(nw.failureODMStatus==null);
        system.assert(nw.failuresODMMsg==null);
        system.assert(nw.partsODMStatus==null);
		system.assert(nw.partsODMMsg==null);
       
    }
    
    static testmethod void testmethod5()
    {
        
         Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02466';
        acc.IAM_Service_Provider_Code__c='19134';
        acc.Type='Dealer Account';
        acc.CMI_Account_Status__c = 'Active';
        insert acc;
        
        css_job_order__c jo = CSS_TestData.createJobOrder(false);
        jo.Account__c = acc.id;
        jo.ODM_Status__c='warn';
        jo.ODM_Status_Message__c='';
        jo.ODM_Pre_submit_Status__c='ytbv';
        insert jo;
         ApexPages.currentPage().getParameters().put('Id',jo.Id);
        css_solutions__c sol = css_testdata.createSolutions(true, jo.Id);
        css_solution_component__c solcomp = css_testdata.createSRT(false, jo.Id, sol.id);
       solcomp.ODM_Status__c='WARN';
        solcomp.ODM_Status_Message__c='';
        solcomp.Fail_Code_Editable__c='Service Callout';
        insert solcomp;
        
        id recordpartid = schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName().get('Parts').getRecordTypeId();
        CSS_Parts_Options__c pa = new CSS_Parts_Options__c();
        pa.Option_Number__c = 'O-111';
        pa.Service_Job__c = jo.Id;
        pa.selected_part__c = true;
        pa.FailurepartId__c = solComp.Id;
        pa.Part_Assignment__c = 'Primary';
        pa.Solutions__c=sol.Id;
        pa.ODM_Status__c='warn';
        pa.ODM_Status_Message__c='';
        pa.Type__c='Commercial-Travel';
        pa.Item__c='Ties';
        pa.RecordTypeId=recordpartid;
        insert pa;
        
        CSS_SRT__C srt=css_testdata.createSRT(false,'Repair', sol.Id, jo.Id);
        srt.ODM_Status__c='warn';
        srt.ODM_Status_Message__c='SRT WArning';
        srt.FailCode__c='YNAPEW';
        srt.SRT_ID__c='00-901-00';
        insert srt;
        test.startTest();
        CG_CL_ODMMessagesController nw = new CG_CL_ODMMessagesController();
        nw.splitRelatedStatusMsg();
        test.stopTest();
       
    }
    
    static testmethod void testmethod6()
    {
         Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02466';
        acc.IAM_Service_Provider_Code__c='19134';
        acc.Type='Dealer Account';
        acc.CMI_Account_Status__c = 'Active';
        insert acc;
        
        css_job_order__c jo = CSS_TestData.createJobOrder(false);
        jo.Account__c = acc.id;
        jo.ODM_Status__c='warn';
        jo.ODM_Status_Message__c='Test;Test1;Test2;Test3';
        jo.ODM_Pre_submit_Status__c='';
        jo.ODM_Pre_Submit_Status_Message__c='ytbv;ytbv1;ytbv2';
        jo.ODM_Status_Code__c='500';
        jo.Mutual_Exclusive_Message__c='Test';
        jo.SRT_Olap_Reason_Msg__c='Test';
        jo.DupAccessCodePercentReqMsg__c='Test';
        jo.Overlap_Service_Failure_Msg__c='Test';
        jo.DuplicateSRTDetails__c='Duplicate';
        jo.CSS_In_Shop_Labor_Rate__c='0';
        jo.SPDataWebserviceResult__c='Error';
        insert jo;
        ApexPages.currentPage().getParameters().put('Id',jo.Id);
        css_solutions__c sol = css_testdata.createSolutions(true, jo.Id);
        css_solution_component__c solcomp = css_testdata.createSRT(false, jo.Id, sol.id);
        solcomp.CoverageLimitExceedMsg__c ='Fail Code';
        solcomp.ODM_Status__c='WARN';
        solcomp.ODM_Status_Message__c='Test1;test2;test3';
        solcomp.CoverageLimitExceedMsg_Status__c='Error';
        solcomp.ODM_Status_Code__c='500';
        insert solcomp;
        id recordpartid = schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName().get('TTML').getRecordTypeId();
        id recordpartid1 = schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName().get('BMS Parts').getRecordTypeId();
        id recordpartid2 = schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName().get('OtherClaimables').getRecordTypeId();
        List<CSS_Parts_Options__c> paList = new List<CSS_Parts_Options__c>();
        CSS_Parts_Options__c pa = new CSS_Parts_Options__c();
        pa.Option_Number__c = 'O-111';
        pa.Service_Job__c = jo.Id;
        pa.selected_part__c = true;
        pa.FailurepartId__c = solComp.Id;
        pa.Part_Assignment__c = 'Primary';
        pa.Solutions__c=sol.Id;
        pa.ODM_Status__c='warn';
        pa.ODM_Status_Message__c='Test1;test2;test3';
        pa.ODM_Status_Code__c='500';
        pa.Type__c='Commercial-Travel';
        pa.Item__c='Ties';
        pa.RecordTypeId=recordpartid;
        paList.add(pa);
        
        CSS_Parts_Options__c pa1 = new CSS_Parts_Options__c();
        pa1.Option_Number__c = 'O-111';
        pa1.Service_Job__c = jo.Id;
        pa1.selected_part__c = true;
        pa1.FailurepartId__c = solComp.Id;
        pa1.Part_Assignment__c = 'Primary';
        pa1.Solutions__c=sol.Id;
        pa1.ODM_Status__c='warn';
        pa1.ODM_Status_Message__c='Test1;test2;test3';
        pa1.ODM_Status_Code__c='500';
        pa1.Type__c='Commercial-Travel';
        pa1.Item__c='Ties';
        pa1.RecordTypeId=recordpartid1;
        paList.add(pa1);
        
        CSS_Parts_Options__c pa2 = new CSS_Parts_Options__c();
        pa2.Option_Number__c = 'O-111';
        pa2.Service_Job__c = jo.Id;
        pa2.selected_part__c = true;
        pa2.FailurepartId__c = solComp.Id;
        pa2.Part_Assignment__c = 'Primary';
        pa2.Solutions__c=sol.Id;
        pa2.ODM_Status__c='warn';
        pa2.ODM_Status_Message__c='Test1;test2;test3';
        pa2.ODM_Status_Code__c='500';
        pa2.Type__c='Commercial-Travel';
        pa2.Item__c='Ties';
        pa2.RecordTypeId=recordpartid2;
        paList.add(pa2);
        
        insert paList;
        
        CSS_SRT__C srt=css_testdata.createSRT(false,'Repair', sol.Id, jo.Id);
        srt.ODM_Status__c='warn';
        srt.ODM_Status_Message__c='SRT WArning';
        srt.FailCode__c='YNAPEW';
        srt.SRT_ID__c='00-901-00';
        srt.ODM_Status_Code__c='500';
        insert srt;
        test.startTest();
        CG_CL_ODMMessagesController nw = new CG_CL_ODMMessagesController();
        nw.splitRelatedStatusMsg();
        test.stopTest();
       
    }
    
    
}