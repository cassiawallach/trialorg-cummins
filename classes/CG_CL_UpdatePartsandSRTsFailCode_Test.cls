@isTest
public class CG_CL_UpdatePartsandSRTsFailCode_Test 
{

    static testMethod void doTest() 
    {
        list<css_job_order__c> joborderlist = new list<css_job_order__c>();
        css_job_order__c jo =new css_job_order__c();
        jo.ESN__c='58764-58764';
        jo.Equipment_ID__c='34567';
        jo.Qsol_Engine_Family_Code__c='12345';
        jo.Service_Model__c='98765';
        joborderlist.add(jo);
        insert joborderlist;
        
        List<CSS_Solutions__c> solu = new List<CSS_Solutions__c>();
        CSS_Solutions__c solRef = new CSS_Solutions__c();
        solRef.Diagnostic_Response__c='Most likely the solution';
        solRef.Service_Job__c=jo.Id;
        solRef.Solution_title__c='TestData';
        solu.add(solRef);
        insert solu;
        
        list<CSS_Solution_Component__c> solComRef = new list<CSS_Solution_Component__c>();
        css_solution_component__c solcomp = new css_solution_component__c();
        solcomp.Service_Job__c=jo.id;
        solcomp.Name='Testing';
        solcomp.type__c = 'ABC';
        solcomp.Solutions__c=solRef.Id;
        solComRef.add(solcomp);
        insert solComRef;
        
        list<CSS_SRT__c> srtlist = new list<CSS_SRT__c>();
        CSS_SRT__c SRT = new CSS_SRT__c();
		srt.Job_Order__c = jo.id;
        srtlist.add(srt);
        insert srtlist;
        
        Id recTypeIdpart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType,'BMS Parts');
     
        list<CSS_Parts_Options__c> lstpo =new list<CSS_Parts_Options__c>();
        CSS_Parts_Options__c partop = new CSS_Parts_Options__c();
        partop.Service_Job__c=jo.Id;
        partop.FailurepartId__c=solcomp.Id;
        partop.RecordTypeId=recTypeIdpart;
        partop.Parts_Type__c='Custom';
        partop.Account_Code__c='61';
        partop.Fail_Code__c = '345';
        lstpo.add(partop);
        insert lstpo;

        Test.startTest();
        CG_CL_UpdatePartsandSRTsFailCode.MyInvocableVariable inv;
        inv= new CG_CL_UpdatePartsandSRTsFailCode.MyInvocableVariable();
        inv.recId = solcomp.id;
        inv.oldVal= partop.Fail_Code__c;
        inv.currVal='123';
        List<CG_CL_UpdatePartsandSRTsFailCode.MyInvocableVariable> myInvocableVariableList= new List<CG_CL_UpdatePartsandSRTsFailCode.MyInvocableVariable>();
        myInvocableVariableList.add(inv);
         
        CG_CL_UpdatePartsandSRTsFailCode.UpdatePartsandSRTsFailCode(myInvocableVariableList);
        Test.stopTest();

    }
     static testMethod void doTestOne() 
    {
        list<css_job_order__c> joborderlist = new list<css_job_order__c>();
        css_job_order__c jo =new css_job_order__c();
        jo.ESN__c='58764-58764';
        jo.Equipment_ID__c='34567';
        jo.Qsol_Engine_Family_Code__c='12345';
        jo.Service_Model__c='98765';
        joborderlist.add(jo);
        insert joborderlist;
        
        List<CSS_Solutions__c> solu = new List<CSS_Solutions__c>();
        CSS_Solutions__c solRef = new CSS_Solutions__c();
        solRef.Diagnostic_Response__c='Most likely the solution';
        solRef.Service_Job__c=jo.Id;
        solRef.Solution_title__c='TestData';
        solu.add(solRef);
        insert solu;
        
        list<CSS_Solution_Component__c> solComRef = new list<CSS_Solution_Component__c>();
        css_solution_component__c solcomp = new css_solution_component__c();
        solcomp.Service_Job__c=jo.id;
        solcomp.Name='Testing';
        solcomp.type__c = 'ABC';
        solcomp.Solutions__c=solRef.Id;
        solComRef.add(solcomp);
        insert solComRef;
        
        list<CSS_SRT__c> srtlist = new list<CSS_SRT__c>();
        CSS_SRT__c srt = new CSS_SRT__c();
		srt.Job_Order__c = jo.id;
		srt.FailCode__c = '345';
        srtlist.add(srt);
        insert srtlist;
        
        Id recTypeIdpart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType,'BMS Parts');
     
        list<CSS_Parts_Options__c> lstpo =new list<CSS_Parts_Options__c>();
        CSS_Parts_Options__c partop = new CSS_Parts_Options__c();
        partop.Service_Job__c=jo.Id;
        partop.FailurepartId__c=solcomp.Id;
        partop.RecordTypeId=recTypeIdpart;
        partop.Parts_Type__c='Custom';
        partop.Account_Code__c='61';
        //partop.Fail_Code__c = '345';
        lstpo.add(partop);
        insert lstpo;

        Test.startTest();
        CG_CL_UpdatePartsandSRTsFailCode.MyInvocableVariable inv;
        inv= new CG_CL_UpdatePartsandSRTsFailCode.MyInvocableVariable();
        inv.recId = solcomp.id;
        inv.oldVal= srt.FailCode__c;
        inv.currVal='123';
        List<CG_CL_UpdatePartsandSRTsFailCode.MyInvocableVariable> myInvocableVariableList= new List<CG_CL_UpdatePartsandSRTsFailCode.MyInvocableVariable>();
        myInvocableVariableList.add(inv);
         
        CG_CL_UpdatePartsandSRTsFailCode.UpdatePartsandSRTsFailCode(myInvocableVariableList);
        Test.stopTest();

    }
}