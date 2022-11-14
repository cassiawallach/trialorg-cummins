@istest
public class CG_CL_SolutionComp_TriggerHandler_Test {
	public testMethod static void CG_CL_SolutionComp_TriggerHandler_Test_Method()
    {
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02466';
        acc.IAM_Service_Provider_Code__c='19134';
        acc.Type='Dealer Account';
        acc.CMI_Account_Status__c = 'Active';
        insert acc;
        
        CSS_Job_Order__c SerRec = new CSS_Job_Order__c();
        SerRec.DSID__c='12345';
        SerRec.DSID_Status__c='open';
        SerRec.ESN__c ='79464646';
        SerRec.Customer_Name__c='ABC';
        SerRec.Failure_Point__c=2.2;
        SerRec.Unit_Number__c='1234';
        SerRec.Service_Model__c='ESN';
        SerRec.Service_Model_N__c = 445566;
        SerRec.Make__c='test';
        SerRec.Model__c='test1';
        SerRec.VIN__c='1XKAD49X6CJ305490';
        SerRec.Customer_Name__c='ABC';
        SerRec.CSS_In_Shop_Labor_Rate__c='100';
        SerRec.Failure_Point_Measure__c = 'MI'; 
        SerRec.Application__c='Automotive'; 
        SerRec.sub_Type__c='cedan';
        SerRec.INSITE_UpdateTimeStamp__c= system.today();
        SerRec.INSITE_ESN_Choice__c='Not Selected';
        SerRec.Shop_Work_Order__c='1234';
        SerRec.DSID_Creation_Timestamp__c=system.today();
        SerRec.DSID_WorkGroup__c='Wrkgrp';
        SerRec.Equipment_ID__c='Equip';
        SerRec.Status__c = 'Triage & Diagnosis/Repair' ;
        SerRec.Previous_Status__c = 'Triage & Diagnosis' ;
        SerRec.CSS_Job_Location_Code__c='56270-56255';
        SerRec.PSN_Not_Available__c = true;
        SerRec.Actual_Technician_Time__c=1.2;
        serrec.Account__c=acc.id;
        insert SerRec;
        
        list<CSS_SRT__c> SRTLst = new list<CSS_SRT__c>();        
        Set<String> failAccLst = new Set<String>();        
        
        CSS_SRT__c srtVar = new CSS_SRT__c();
        srtVar.Job_Order__c = SerRec.Id;
        srtVar.name = '00-10S-00';
        srtVar.SRT_ID__c = '00-10S-00';
        srtVar.Account_Code__c = 'NEW PRODUCT WARRANTY 67';
        srtVar.Type__c = 'Diagnosis';
        srtVar.FailCode__c='THAC';
        srtvar.Account_Code_Description__c='NEW PRODUCT WARRANTY 67';
        srtvar.Fail_Code_Description__c='THAC';
        srtvar.isPerformed__c=true;
        SRTLst.add(srtvar);
        String temp = srtvar.FailCode__c + ';;' + srtvar.Account_Code__c;
        failAccLst.add(temp);
        
        CSS_SRT__c srtVar1 = new CSS_SRT__c();
        srtVar1.Job_Order__c = SerRec.Id;
        srtVar1.name = '10-117-00';
        srtVar1.SRT_ID__c = '10-117-00';
        srtVar1.Account_Code__c = 'NEW PRODUCT WARRANTY 67';
        srtVar1.Type__c = 'Repair';
        srtVar1.FailCode__c='EUWX';
        srtvar1.Account_Code_Description__c='NEW PRODUCT WARRANTY 67';
        srtvar1.Fail_Code_Description__c='EUWX';
        SRTLst.add(srtvar1);
        String temp1 = srtvar1.FailCode__c + ';;' + srtvar1.Account_Code__c;
        failAccLst.add(temp1);
        
        CSS_SRT__c srtVar2 = new CSS_SRT__c();
        srtVar2.Job_Order__c = SerRec.Id;
        srtVar2.name = '10-117-00';
        srtVar2.SRT_ID__c = '10-117-00';
        srtVar2.Account_Code__c = 'NEW PARTS WARRANTY 35';
        srtVar2.Type__c = 'Diag Access';
        srtVar2.SRT_Type__c='Access';
        srtVar2.FailCode__c='EXWH';
        srtvar2.Account_Code_Description__c='NEW PARTS WARRANTY 35';
        srtvar2.Fail_Code_Description__c='EXWH';
        SRTLst.add(srtvar2);
        String temp2 = srtvar2.FailCode__c + ';;' + srtvar2.Account_Code__c;
        failAccLst.add(temp2);
        
        CSS_SRT__c srtVar3 = new CSS_SRT__c();
        srtVar3.Job_Order__c = SerRec.Id;
        srtVar3.name = '99-999';
        srtVar3.Type__c = '99Time';
        srtVar3.SRT_ID__c = '10-117-00';
        srtVar3.Account_Code__c = 'NEW PARTS WARRANTY 35';
        srtVar3.FailCode__c='EXWH';
        srtvar3.Account_Code_Description__c='NEW PARTS WARRANTY 35';
        srtvar3.Fail_Code_Description__c='EXWH';
        SRTLst.add(srtvar3);
        String temp3 = srtvar3.FailCode__c + ';;' + srtvar3.Account_Code__c;
        failAccLst.add(temp3);
        
        insert SRTLst;
        
        Test.startTest();
        CG_CL_SolutionComp_TriggerHandler trigHandlerObj = new CG_CL_SolutionComp_TriggerHandler();
        trigHandlerObj.deleteChildRecordsOnRootCauseUnSelect(failAccLst,SerRec.Id);
        Test.stopTest();
    }
}