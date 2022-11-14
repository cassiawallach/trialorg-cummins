@istest
public class CG_CL_UpdateJob_FC_AC_ChildEntities_Test {
    static testMethod void updateFailCodeAccCodeMethod1(){
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02466';
        acc.IAM_Service_Provider_Code__c='19134';
        acc.Type='Dealer Account';
        acc.CMI_Account_Status__c = 'Active';
        insert acc;
        
        CSS_Job_Order__c servicejob= new CSS_Job_Order__c();
        servicejob.Status__c = 'Intake';
        servicejob.INSITE_UpdateTimeStamp__c =system.today();
        servicejob.INSITE_ESN_Choice__c='Not Selected';
        servicejob.Qsol_Engine_Family_Code__c = 'code';
        servicejob.Warranty_Start_Date__c = date.today();
        servicejob.CSS_Job_Location_Code__c = 'location';
        servicejob.DSID_WorkGroup__c='Wrkgrp';
        servicejob.Status__c = 'Triage & Diagnosis Complete' ;
        servicejob.Previous_Status__c = 'Triage & Diagnosis' ;
        servicejob.Failure_Date__c = date.today();
        servicejob.Account__c = acc.id;
        insert servicejob; 
        
        List<CSS_Solution_Component__c> lstsol = new List<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solcomp = new CSS_Solution_Component__c();
        solcomp.Selected_Component__c=true;
        solcomp.AccountCode__c='NEW PRODUCT WARRANTY 67';
        solcomp.Status__c='Approved';
        solcomp.Type__c='Test';
        solcomp.Service_Job__c = servicejob.Id;
        solcomp.System_Code__c = 'TH';
        solcomp.Component_Code__c = 'AC';
        solcomp.Fail_Code_Editable__c = 'YENB';
        lstsol.add(solcomp);
        
        CSS_Solution_Component__c solcomp1 = new CSS_Solution_Component__c();
        solcomp1.Selected_Component__c=true;
        solcomp1.AccountCode__c='ACCOUNT TEAM COVERAGE 27';
        solcomp1.Status__c='Approved';
        solcomp1.Type__c='Test';
        solcomp1.Service_Job__c = servicejob.Id;
        solcomp1.System_Code__c = 'YN';
        solcomp1.Component_Code__c = 'BC';
        solcomp1.Fail_Code_Editable__c = 'WEQPEZ';
        insert solcomp1;
        
        lstsol.add(solcomp1);
       
        solcomp1.Fail_Code_Editable__c = 'WFHASW';
        solcomp1.AccountCode__c='ACCOUNT TEAM COVERAGE 27';
        update solcomp1;
        solcomp1 = [select id,Fail_Code__c,CampaignLaborPercentage__c,CoveredLaborHrs__c,AccountCode__c from CSS_Solution_Component__c where id=:solcomp1.id];
        
        CSS_Solution_Component__c solcomp2 = new CSS_Solution_Component__c();
        solcomp2.Selected_Component__c=true;
        solcomp2.AccountCode__c='NEW PRODUCT WARRANTY 67';
        solcomp2.Status__c='Approved';
        solcomp2.Type__c=null;
        solcomp2.Service_Job__c = servicejob.Id;
        solcomp2.System_Code__c = 'TH';
        solcomp2.Component_Code__c = 'AC';
        solcomp2.Fail_Code_Editable__c = 'WEQPEZ';
        insert solcomp2;
        solcomp2 = [select id,Fail_Code__c,CampaignLaborPercentage__c,CoveredLaborHrs__c,AccountCode__c from CSS_Solution_Component__c where id=:solcomp2.id];
        Id recTypeIdPart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'Parts');
        
        CSS_Parts_Options__c prtsoptn = new CSS_Parts_Options__c();
        prtsoptn.Service_Job__c = servicejob.Id;
        prtsoptn.RecordTypeId = recTypeIdPart;
        prtsoptn.FailurepartId__c = solcomp2.Id;
        prtsoptn.Parts_Type__c = 'Test';
        prtsoptn.Fail_Code__c = 'YNBC';
        prtsoptn.Account_Code__c = 'ACCOUNT TEAM COVERAGE 27';
        insert prtsoptn;
        
        CSS_SRT__c strobj = new CSS_SRT__c();
        strobj.Job_Order__c = servicejob.Id;
        strobj.Type__c = 'Repair Access';
        strobj.FailCode__c = 'YNBC';
        strobj.Account_Code__c = 'ACCOUNT TEAM COVERAGE 27';
        strobj.Component_Id__c =solcomp2.Id;
        insert strobj;
        
        Test.startTest();
        CG_CL_UpdateJob_FC_AC_ChildEntities Upfc = new CG_CL_UpdateJob_FC_AC_ChildEntities();
        Map<String, List<CSS_Solution_Component__c>> failCodeMapTest = new Map<String, List<CSS_Solution_Component__c>>();
        failCodeMapTest.put(lstsol[0].SysCodeAndCompCode__c,lstsol);
        Map<String, List<CSS_Solution_Component__c>> accCodeMapTest = new Map<String, List<CSS_Solution_Component__c>>();
        accCodeMapTest.put(lstsol[0].CSS_Account_Formula__c,lstsol);
        upfc.updateFailCodeAccCode(solcomp1.Fail_Code__c,solcomp1.AccountCode__c,solcomp1.Fail_Code__c,solcomp1.AccountCode__c,solcomp1,servicejob.Id,'Test');
        //scenario1
        Id recTypeIdOC = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'OtherClaimables');
        CSS_Parts_Options__c prtsoptn1 = new CSS_Parts_Options__c();
        prtsoptn1.Service_Job__c = servicejob.Id;
        prtsoptn1.RecordTypeId = recTypeIdOC;
        prtsoptn1.FailurepartId__c = solcomp2.Id;
        prtsoptn1.Parts_Type__c = 'Test';
        prtsoptn1.Fail_Code__c = 'YNBC';
        prtsoptn1.Account_Code__c = 'ACCOUNT TEAM COVERAGE 27';
        insert prtsoptn1;
        upfc.updateFailCodeAccCode(solcomp1.Fail_Code__c,solcomp1.AccountCode__c,solcomp2.Fail_Code__c,solcomp1.AccountCode__c,solcomp2,servicejob.Id,'Test');
        Test.stopTest();
        
    }
    
    static testMethod void updateFailCodeAccCodeMethod2(){
         Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02466';
        acc.IAM_Service_Provider_Code__c='19134';
        acc.Type='Dealer Account';
        acc.CMI_Account_Status__c = 'Active';
        insert acc;
        
        CSS_Job_Order__c servicejob= new CSS_Job_Order__c();
        servicejob.Status__c = 'Intake';
        servicejob.INSITE_UpdateTimeStamp__c =system.today();
        servicejob.INSITE_ESN_Choice__c='Not Selected';
        servicejob.Qsol_Engine_Family_Code__c = 'code';
        servicejob.Warranty_Start_Date__c = date.today();
        servicejob.CSS_Job_Location_Code__c = 'location';
        servicejob.DSID_WorkGroup__c='Wrkgrp';
        servicejob.Status__c = 'Triage & Diagnosis Complete' ;
        servicejob.Previous_Status__c = 'Triage & Diagnosis' ;
        servicejob.Failure_Date__c = date.today();
        servicejob.Account__c = acc.id;
        insert servicejob; 
        
        List<CSS_Solution_Component__c> lstsol = new List<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solcomp = new CSS_Solution_Component__c();
        solcomp.Selected_Component__c=true;
        solcomp.AccountCode__c='NEW PRODUCT WARRANTY 32';
        solcomp.Status__c='Approved';
        solcomp.Type__c='Test';
        solcomp.Service_Job__c = servicejob.Id;
        solcomp.System_Code__c = 'YN';
        solcomp.Component_Code__c = 'BC';
        solcomp.Fail_Code_Editable__c = 'YENB';
        solcomp.CoveredTravelMiles__c='5678';
        insert solcomp;
        lstsol.add(solcomp);
        
        solcomp.Fail_Code_Editable__c = 'WFHASW';
        solcomp.AccountCode__c='ACCOUNT TEAM COVERAGE 69';
        update solcomp;
        solcomp = [select id,Fail_Code__c,CoveredMealsLodgingAmt__c,CoveredTowingMiles__c,CoveredTravelBaseFareAmt__c,CoveredTravelLabor__c,CoveredOCAmount__c,CampaignLaborPercentage__c,CoveredPartsQty__c,CoveredLaborHrs__c,AccountCode__c from CSS_Solution_Component__c where id=:solcomp.id];
        
        CSS_Solution_Component__c solcomp1 = new CSS_Solution_Component__c();
        solcomp1.Selected_Component__c=true;
        solcomp1.AccountCode__c='NEW PRODUCT WARRANTY 32';
        solcomp1.Status__c='Approved';
        solcomp1.Type__c='Test';
        solcomp1.Service_Job__c = servicejob.Id;
        solcomp1.System_Code__c = 'YN';
        solcomp1.Component_Code__c = 'BC';
        solcomp1.CoveredTravelMiles__c='3456';
        solcomp1.Fail_Code_Editable__c = 'WEQPEZ';
        insert solcomp1;
        
        lstsol.add(solcomp1);
       
        solcomp1.Fail_Code_Editable__c = 'WFHASW';
        solcomp1.AccountCode__c='ACCOUNT TEAM COVERAGE 67';
        update solcomp1;
        
        solcomp1 = [select id,Fail_Code__c,CoveredMealsLodgingAmt__c,CoveredTowingMiles__c,CoveredTravelBaseFareAmt__c,CoveredTravelLabor__c,CoveredOCAmount__c,CampaignLaborPercentage__c,CoveredPartsQty__c,CoveredLaborHrs__c,AccountCode__c from CSS_Solution_Component__c where id=:solcomp1.id];
        
        CSS_Solution_Component__c solcomp2 = new CSS_Solution_Component__c();
        solcomp2.Selected_Component__c=true;
        solcomp2.AccountCode__c='NEW PRODUCT WARRANTY 67';
        solcomp2.Status__c='Approved';
        solcomp2.CoveredTravelMiles__c='3456';
        solcomp2.Type__c=null;
        solcomp2.Service_Job__c = servicejob.Id;
        solcomp2.System_Code__c = 'TN';
        solcomp2.Component_Code__c = 'AC';
        solcomp2.Fail_Code_Editable__c = 'WEQPEZ';
        insert solcomp2;
        solcomp2 = [select id,Fail_Code__c,CoveredMealsLodgingAmt__c,CoveredTowingMiles__c,CoveredTravelMiles__c,CoveredTravelLabor__c,CoveredTravelBaseFareAmt__c,CoveredOCAmount__c,CampaignLaborPercentage__c,CoveredPartsQty__c,CoveredLaborHrs__c,AccountCode__c from CSS_Solution_Component__c where id=:solcomp2.id];

        CSS_SRT__c strobj = new CSS_SRT__c();
        strobj.Job_Order__c = servicejob.Id;
        strobj.Type__c = 'Repair Access';
        strobj.FailCode__c = 'YNBC';
        strobj.Account_Code__c = 'ACCOUNT TEAM COVERAGE 69';
        strobj.Component_Id__c =solcomp2.Id;
        insert strobj;
        
        Test.startTest();
        CG_CL_UpdateJob_FC_AC_ChildEntities Upfc = new CG_CL_UpdateJob_FC_AC_ChildEntities();
        Map<String, List<CSS_Solution_Component__c>> failCodeMapTest = new Map<String, List<CSS_Solution_Component__c>>();
        failCodeMapTest.put(lstsol[0].SysCodeAndCompCode__c,lstsol);
        Map<String, List<CSS_Solution_Component__c>> accCodeMapTest = new Map<String, List<CSS_Solution_Component__c>>();
        accCodeMapTest.put(lstsol[0].CSS_Account_Formula__c,lstsol);
        upfc.updateFailCodeAccCode(solcomp.Fail_Code__c,solcomp.AccountCode__c,solcomp1.Fail_Code__c,solcomp1.AccountCode__c,solcomp1,servicejob.Id,'Test');
        //scenario2
        Id recTypeIdPart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'Parts');
        CSS_Parts_Options__c prtsoptn1 = new CSS_Parts_Options__c();
        prtsoptn1.Service_Job__c = servicejob.Id;
        prtsoptn1.RecordTypeId = recTypeIdPart;
        prtsoptn1.FailurepartId__c = solcomp2.Id;
        prtsoptn1.Parts_Type__c = 'Test';
        prtsoptn1.Fail_Code__c = 'YNBC';
        prtsoptn1.Type__c = 'Towing';
        prtsoptn1.Account_Code__c = 'ACCOUNT TEAM COVERAGE 69';
        insert prtsoptn1;
        Id recTypeIdOC = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'OtherClaimables');
        upfc.updateFailCodeAccCode(solcomp.Fail_Code__c,solcomp.AccountCode__c,solcomp1.Fail_Code__c,solcomp1.AccountCode__c,solcomp2,servicejob.Id,'Test');
        CSS_Parts_Options__c prtsoptn12 = new CSS_Parts_Options__c();
        prtsoptn12.Service_Job__c = servicejob.Id;
        prtsoptn12.RecordTypeId = recTypeIdOC;
        prtsoptn12.FailurepartId__c = solcomp2.Id;
        prtsoptn12.Parts_Type__c = 'Test';
        prtsoptn12.Fail_Code__c = 'YNBC';
        prtsoptn12.Type__c = 'Non Commercial-Travel';
        prtsoptn12.Account_Code__c = 'ACCOUNT TEAM COVERAGE 69';
        insert prtsoptn12;
        upfc.updateFailCodeAccCode(solcomp.Fail_Code__c,solcomp.AccountCode__c,solcomp1.Fail_Code__c,solcomp1.AccountCode__c,solcomp2,servicejob.Id,'Test');
        Id recTypeIdTTML = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'TTML');
        CSS_Parts_Options__c prtsoptn2 = new CSS_Parts_Options__c();
        prtsoptn2.Service_Job__c = servicejob.Id;
        prtsoptn2.RecordTypeId = recTypeIdTTML;
        prtsoptn2.FailurepartId__c = solcomp2.Id;
        prtsoptn2.Parts_Type__c = 'Test';
        prtsoptn2.Fail_Code__c = 'YNBC';
        prtsoptn2.Type__c = 'Commercial-Travel';
        prtsoptn2.Account_Code__c = 'ACCOUNT TEAM COVERAGE 69';
        insert prtsoptn2;
        upfc.updateFailCodeAccCode(solcomp.Fail_Code__c,solcomp.AccountCode__c,solcomp1.Fail_Code__c,solcomp1.AccountCode__c,solcomp2,servicejob.Id,'Test');
           Id recTypeIdTTML1 = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'TTML');
        CSS_Parts_Options__c prts = new CSS_Parts_Options__c();
        prts.Service_Job__c = servicejob.Id;
        prts.RecordTypeId = recTypeIdTTML1;
        prts.FailurepartId__c = solcomp2.Id;
        prts.Parts_Type__c = 'Test';
        prts.Fail_Code__c = 'YNBC';
        prts.Type__c = 'NON Commercial-Travel';
        prts.Account_Code__c = 'ACCOUNT TEAM COVERAGE 69';
        insert prts;
         upfc.updateFailCodeAccCode(solcomp.Fail_Code__c,solcomp.AccountCode__c,solcomp1.Fail_Code__c,solcomp1.AccountCode__c,solcomp2,servicejob.Id,'Test');
        Id recTypeIdTTML2 = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'TTML');
        CSS_Parts_Options__c prt = new CSS_Parts_Options__c();
        prt.Service_Job__c = servicejob.Id;
        prt.RecordTypeId = recTypeIdTTML2;
        prt.FailurepartId__c = solcomp2.Id;
        prt.Parts_Type__c = 'Test';
        prt.Fail_Code__c = 'YNBC';
        prt.Type__c = 'Towing';
        prt.Account_Code__c = 'ACCOUNT TEAM COVERAGE 69';
        insert prt;
         upfc.updateFailCodeAccCode(solcomp.Fail_Code__c,solcomp.AccountCode__c,solcomp1.Fail_Code__c,solcomp1.AccountCode__c,solcomp2,servicejob.Id,'Test');
        Id recTypeIdTTML3 = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'TTML');
        CSS_Parts_Options__c pr = new CSS_Parts_Options__c();
        pr.Service_Job__c = servicejob.Id;
        pr.RecordTypeId = recTypeIdTTML3;
        pr.FailurepartId__c = solcomp2.Id;
        pr.Parts_Type__c = 'Test';
        pr.Fail_Code__c = 'YNBC';
        pr.Type__c = 'Meals';
        pr.Account_Code__c = 'ACCOUNT TEAM COVERAGE 69';
        insert pr;
         upfc.updateFailCodeAccCode(solcomp.Fail_Code__c,solcomp.AccountCode__c,solcomp1.Fail_Code__c,solcomp1.AccountCode__c,solcomp2,servicejob.Id,'Test');
        Test.stopTest();
        
    }
    static testMethod void updateFailCodeAccCodeMethod3(){
         Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02466';
        acc.IAM_Service_Provider_Code__c='19134';
        acc.Type='Dealer Account';
        acc.CMI_Account_Status__c = 'Active';
        insert acc;
        
        CSS_Job_Order__c servicejob= new CSS_Job_Order__c();
        servicejob.Status__c = 'Intake';
        servicejob.Account__c = acc.id;
        servicejob.INSITE_UpdateTimeStamp__c =system.today();
        servicejob.INSITE_ESN_Choice__c='Not Selected';
        servicejob.Qsol_Engine_Family_Code__c = 'code';
        servicejob.Warranty_Start_Date__c = date.today();
        servicejob.CSS_Job_Location_Code__c = 'location';
        servicejob.DSID_WorkGroup__c='Wrkgrp';
        servicejob.Status__c = 'Triage & Diagnosis Complete' ;
        servicejob.Previous_Status__c = 'Triage & Diagnosis' ;
        servicejob.Failure_Date__c = date.today();
        insert servicejob; 
        
        List<CSS_Solution_Component__c> lstsol = new List<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solcomp = new CSS_Solution_Component__c();
        solcomp.Selected_Component__c=true;
        solcomp.AccountCode__c='NEW PRODUCT WARRANTY 32';
        solcomp.Status__c='Approved';
        solcomp.Type__c='Test';
        solcomp.Service_Job__c = servicejob.Id;
        solcomp.System_Code__c = 'YN';
        solcomp.Component_Code__c = 'BC';
        solcomp.Fail_Code_Editable__c = 'YENB';
        insert solcomp;
        lstsol.add(solcomp);
        
        solcomp.Fail_Code_Editable__c = 'WFHASW';
        solcomp.AccountCode__c='ACCOUNT TEAM COVERAGE 69';
        update solcomp;
        solcomp = [select id,CoveredPartsQty__c,Fail_Code__c,CampaignLaborPercentage__c,CoveredLaborHrs__c,AccountCode__c from CSS_Solution_Component__c where id=:solcomp.id];
        
        CSS_Solution_Component__c solcomp1 = new CSS_Solution_Component__c();
        solcomp1.Selected_Component__c=true;
        solcomp1.AccountCode__c='Select One';
        solcomp1.Status__c='Approved';
        solcomp1.Type__c='Test';
        solcomp1.Service_Job__c = servicejob.Id;
        solcomp1.System_Code__c = 'YN';
        solcomp1.Component_Code__c = 'BC';
        solcomp1.Fail_Code_Editable__c = 'WEQPEZ';
        solcomp1.CoveredLaborHrs__c = '123';
        insert solcomp1;
        
        lstsol.add(solcomp1);
       
        solcomp1.Fail_Code_Editable__c = 'WFHASW';
        solcomp1.AccountCode__c='Select One';
        update solcomp1;
        solcomp1 = [select id,CoveredPartsQty__c,Fail_Code__c,CampaignLaborPercentage__c,CoveredLaborHrs__c,AccountCode__c from CSS_Solution_Component__c where id=:solcomp1.id];
  
        CSS_Solution_Component__c solcomp2 = new CSS_Solution_Component__c();
        solcomp2.Selected_Component__c=true;
        solcomp2.AccountCode__c='NEW PRODUCT WARRANTY 67';
        solcomp2.Status__c='Approved';
        solcomp2.Type__c=null;
        solcomp2.Service_Job__c = servicejob.Id;
        solcomp2.System_Code__c = 'YN';
        solcomp2.Component_Code__c = 'BC';
        solcomp2.Fail_Code_Editable__c = 'WEQPEZ';
        solcomp2.CoveredLaborHrs__c = '123';
        //decimal cvrdvalue = Decimal.valueOf(solcomp2.CoveredLaborHrs__c);
        insert solcomp2;
        solcomp2 = [select id,CoveredPartsQty__c,Fail_Code__c,CampaignLaborPercentage__c,CoveredLaborHrs__c,AccountCode__c from CSS_Solution_Component__c where id=:solcomp2.id];
       
        Id recTypeIdPart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'Parts');
        CSS_Parts_Options__c prtsoptn = new CSS_Parts_Options__c();
        prtsoptn.Service_Job__c = servicejob.Id;
        prtsoptn.RecordTypeId = recTypeIdPart;
        prtsoptn.FailurepartId__c = solcomp2.Id;
        prtsoptn.Parts_Type__c = 'Test';
        prtsoptn.Fail_Code__c = 'YNBC';
        prtsoptn.Account_Code__c = 'Select One';
        insert prtsoptn;
        
        CSS_SRT__c strobj = new CSS_SRT__c();
        strobj.Job_Order__c = servicejob.Id;
        strobj.Type__c = 'Repair';
        strobj.FailCode__c = 'YNBC';
        strobj.Account_Code__c = 'ACCOUNT TEAM COVERAGE 69';
        strobj.Component_Id__c =solcomp2.Id;
        insert strobj;
        
        Test.startTest();
        CG_CL_UpdateJob_FC_AC_ChildEntities Upfc = new CG_CL_UpdateJob_FC_AC_ChildEntities();
        Map<String, List<CSS_Solution_Component__c>> failCodeMapTest = new Map<String, List<CSS_Solution_Component__c>>();
        failCodeMapTest.put(lstsol[0].SysCodeAndCompCode__c,lstsol);
        Map<String, List<CSS_Solution_Component__c>> accCodeMapTest = new Map<String, List<CSS_Solution_Component__c>>();
        accCodeMapTest.put(lstsol[0].CSS_Account_Formula__c,lstsol);
        upfc.updateFailCodeAccCode(solcomp1.Fail_Code__c,solcomp1.AccountCode__c,solcomp1.Fail_Code__c,solcomp1.AccountCode__c,solcomp1,servicejob.Id,'Test');
        //scenario3
        Id recTypeIdOC = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'OtherClaimables');
        CSS_Parts_Options__c prtsoptn1 = new CSS_Parts_Options__c();
        prtsoptn1.Service_Job__c = servicejob.Id;
        prtsoptn1.RecordTypeId = recTypeIdOC;
        prtsoptn1.FailurepartId__c = solcomp2.Id;
        prtsoptn1.Parts_Type__c = 'Test';
        prtsoptn1.Fail_Code__c = 'YNBC';
        prtsoptn1.Account_Code__c = 'Select One';
        insert prtsoptn1;
        upfc.updateFailCodeAccCode(solcomp1.Fail_Code__c,solcomp1.AccountCode__c,solcomp2.Fail_Code__c,solcomp2.AccountCode__c,solcomp2,servicejob.Id,'Test');
        Test.stopTest();
 }
    static testMethod void updateFailCodeAccCodeMethod4(){
         Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02466';
        acc.IAM_Service_Provider_Code__c='19134';
        acc.Type='Dealer Account';
        acc.CMI_Account_Status__c = 'Active';
        insert acc;
        
        CSS_Job_Order__c servicejob= new CSS_Job_Order__c();
        servicejob.Status__c = 'Intake';
        servicejob.Account__c = acc.id;
        servicejob.INSITE_UpdateTimeStamp__c =system.today();
        servicejob.INSITE_ESN_Choice__c='Not Selected';
        servicejob.Qsol_Engine_Family_Code__c = 'code';
        servicejob.Warranty_Start_Date__c = date.today();
        servicejob.CSS_Job_Location_Code__c = 'location';
        servicejob.DSID_WorkGroup__c='Wrkgrp';
        servicejob.Status__c = 'Triage & Diagnosis Complete' ;
        servicejob.Previous_Status__c = 'Triage & Diagnosis' ;
        servicejob.Failure_Date__c = date.today();
        insert servicejob; 
        
        List<CSS_Solution_Component__c> lstsol = new List<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solcomp = new CSS_Solution_Component__c();
        solcomp.Selected_Component__c=true;
        solcomp.AccountCode__c='NEW PRODUCT WARRANTY 67';
        solcomp.Status__c='Approved';
        solcomp.Type__c='Test';
        solcomp.Service_Job__c = servicejob.Id;
        solcomp.System_Code__c = 'TH';
        solcomp.Component_Code__c = 'AC';
        solcomp.Fail_Code_Editable__c = 'YENB';
        lstsol.add(solcomp);
        
        CSS_Solution_Component__c solcomp1 = new CSS_Solution_Component__c();
        solcomp1.Selected_Component__c=true;
        solcomp1.AccountCode__c='NEW PRODUCT WARRANTY 67';
        solcomp1.Status__c='Approved';
        solcomp1.Type__c='Test';
        solcomp1.Service_Job__c = servicejob.Id;
        solcomp1.System_Code__c = 'YN';
        solcomp1.Component_Code__c = 'BC';
        solcomp1.Fail_Code_Editable__c = 'WEQPEZ';
        insert solcomp1;
        
        lstsol.add(solcomp1);
       
        solcomp1.Fail_Code_Editable__c = 'WFHASW';
        solcomp1.AccountCode__c='ACCOUNT TEAM COVERAGE 27';
        update solcomp1;
        solcomp1 = [select id,Fail_Code__c,CampaignLaborPercentage__c,CoveredLaborHrs__c,AccountCode__c from CSS_Solution_Component__c where id=:solcomp1.id];
        
        CSS_Solution_Component__c solcomp2 = new CSS_Solution_Component__c();
        solcomp2.Selected_Component__c=true;
        solcomp2.AccountCode__c='Select One';
        solcomp2.Status__c='Approved';
        solcomp2.Type__c=null;
        solcomp2.Service_Job__c = servicejob.Id;
        solcomp2.System_Code__c = 'YN';
        solcomp2.Component_Code__c = 'BC';
        solcomp2.Fail_Code_Editable__c = 'WEQPEZ';
        insert solcomp2;
        
        lstsol.add(solcomp2);
        
        solcomp2.Fail_Code_Editable__c = 'WFHASW';
        solcomp2.AccountCode__c='Select One';
        update solcomp2;
        
        solcomp2 = [select id,Fail_Code__c,CampaignLaborPercentage__c,CoveredLaborHrs__c,AccountCode__c from CSS_Solution_Component__c where id=:solcomp2.id];
        Id recTypeIdPart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'Parts');
        
        CSS_Parts_Options__c prtsoptn = new CSS_Parts_Options__c();
        prtsoptn.Service_Job__c = servicejob.Id;
        prtsoptn.RecordTypeId = recTypeIdPart;
        prtsoptn.FailurepartId__c = solcomp2.Id;
        prtsoptn.Parts_Type__c = 'Test';
        prtsoptn.Fail_Code__c = 'YNBC';
        prtsoptn.Account_Code__c = 'ACCOUNT TEAM COVERAGE 27';
        insert prtsoptn;
        
        CSS_SRT__c strobj = new CSS_SRT__c();
        strobj.Job_Order__c = servicejob.Id;
        strobj.Type__c = 'Repair Access';
        strobj.FailCode__c = 'YNBC';
        strobj.Account_Code__c = 'ACCOUNT TEAM COVERAGE 27';
        strobj.Component_Id__c =solcomp2.Id;
        insert strobj;
        
        Test.startTest();
        CG_CL_UpdateJob_FC_AC_ChildEntities Upfc = new CG_CL_UpdateJob_FC_AC_ChildEntities();
        Map<String, List<CSS_Solution_Component__c>> failCodeMapTest = new Map<String, List<CSS_Solution_Component__c>>();
        failCodeMapTest.put(lstsol[0].SysCodeAndCompCode__c,lstsol);
        Map<String, List<CSS_Solution_Component__c>> accCodeMapTest = new Map<String, List<CSS_Solution_Component__c>>();
        accCodeMapTest.put(lstsol[0].CSS_Account_Formula__c,lstsol);
        upfc.updateFailCodeAccCode(solcomp1.Fail_Code__c,solcomp1.AccountCode__c,solcomp1.Fail_Code__c,solcomp1.AccountCode__c,solcomp1,servicejob.Id,'Test');
        //scenario4
        Id recTypeIdOC = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'OtherClaimables');
        CSS_Parts_Options__c prtsoptn1 = new CSS_Parts_Options__c();
        prtsoptn1.Service_Job__c = servicejob.Id;
        prtsoptn1.RecordTypeId = recTypeIdOC;
        prtsoptn1.FailurepartId__c = solcomp2.Id;
        prtsoptn1.Parts_Type__c = 'Test';
        prtsoptn1.Fail_Code__c = 'YNBC';
        prtsoptn1.Account_Code__c = 'ACCOUNT TEAM COVERAGE 27';
        insert prtsoptn1;
        upfc.updateFailCodeAccCode(solcomp1.Fail_Code__c,solcomp1.AccountCode__c,solcomp2.Fail_Code__c,solcomp2.AccountCode__c,solcomp2,servicejob.Id,'Test');
        Test.stopTest();
        
    }
    static testMethod void updateFailCodeAccCodeMethod5(){
         Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02466';
        acc.IAM_Service_Provider_Code__c='19134';
        acc.Type='Dealer Account';
        acc.CMI_Account_Status__c = 'Active';
        insert acc;
        
        CSS_Job_Order__c servicejob= new CSS_Job_Order__c();
        servicejob.Status__c = 'Intake';
        servicejob.Account__c = acc.id;
        servicejob.INSITE_UpdateTimeStamp__c =system.today();
        servicejob.INSITE_ESN_Choice__c='Not Selected';
        servicejob.Qsol_Engine_Family_Code__c = 'code';
        servicejob.Warranty_Start_Date__c = date.today();
        servicejob.CSS_Job_Location_Code__c = 'location';
        servicejob.DSID_WorkGroup__c='Wrkgrp';
        servicejob.Status__c = 'Triage & Diagnosis Complete' ;
        servicejob.Previous_Status__c = 'Triage & Diagnosis' ;
        servicejob.Failure_Date__c = date.today();
        insert servicejob; 
        
        List<CSS_Solution_Component__c> lstsol = new List<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solcomp = new CSS_Solution_Component__c();
        solcomp.Selected_Component__c=true;
        solcomp.AccountCode__c='NEW PRODUCT WARRANTY 67';
        solcomp.Status__c='Approved';
        solcomp.Type__c='Test';
        solcomp.Service_Job__c = servicejob.Id;
        solcomp.System_Code__c = 'TH';
        solcomp.Component_Code__c = 'AC';
        solcomp.Fail_Code_Editable__c = 'YENB';
        lstsol.add(solcomp);
        
        CSS_Solution_Component__c solcomp1 = new CSS_Solution_Component__c();
        solcomp1.Selected_Component__c=true;
        solcomp1.AccountCode__c='NEW PRODUCT WARRANTY 67';
        solcomp1.Status__c='Approved';
        solcomp1.Type__c='Test';
        solcomp1.Service_Job__c = servicejob.Id;
        solcomp1.System_Code__c = 'YN';
        solcomp1.Component_Code__c = 'BC';
        solcomp1.Fail_Code_Editable__c = 'WEQPEZ';
        insert solcomp1;
        
        lstsol.add(solcomp1);
       
        solcomp1.Fail_Code_Editable__c = 'WFHASW';
        solcomp1.AccountCode__c='ACCOUNT TEAM COVERAGE 69';
        update solcomp1;
        solcomp1 = [select id,Fail_Code__c,CampaignLaborPercentage__c,CoveredLaborHrs__c,AccountCode__c from CSS_Solution_Component__c where id=:solcomp1.id];
        
        CSS_Solution_Component__c solcomp2 = new CSS_Solution_Component__c();
        solcomp2.Selected_Component__c=true;
        solcomp2.AccountCode__c='ACCOUNT TEAM COVERAGE 27';
        solcomp2.Status__c='Approved';
        solcomp2.Type__c=null;
        solcomp2.Service_Job__c = servicejob.Id;
        solcomp2.System_Code__c = 'TN';
        solcomp2.Component_Code__c = 'AC';
        solcomp2.Fail_Code_Editable__c = 'WEQPEZ';
        insert solcomp2;
        
        lstsol.add(solcomp2);
        
        solcomp2.Fail_Code_Editable__c = 'WFHASW';
        solcomp2.AccountCode__c='ACCOUNT TEAM COVERAGE 29';
        update solcomp2;
        
        solcomp2 = [select id,Fail_Code__c,CampaignLaborPercentage__c,CoveredLaborHrs__c,AccountCode__c from CSS_Solution_Component__c where id=:solcomp2.id];
        Id recTypeIdPart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'Parts');
        
        CSS_Parts_Options__c prtsoptn = new CSS_Parts_Options__c();
        prtsoptn.Service_Job__c = servicejob.Id;
        prtsoptn.RecordTypeId = recTypeIdPart;
        prtsoptn.FailurepartId__c = solcomp2.Id;
        prtsoptn.Parts_Type__c = 'Test';
        prtsoptn.Fail_Code__c = 'YNBC';
        prtsoptn.Account_Code__c = 'ACCOUNT TEAM COVERAGE 27';
        insert prtsoptn;
        
        CSS_SRT__c strobj = new CSS_SRT__c();
        strobj.Job_Order__c = servicejob.Id;
        strobj.Type__c = 'Repair Access';
        strobj.FailCode__c = 'YNBC';
        strobj.Account_Code__c = 'ACCOUNT TEAM COVERAGE 69';
        strobj.Component_Id__c =solcomp2.Id;
        insert strobj;
        
        Test.startTest();
        CG_CL_UpdateJob_FC_AC_ChildEntities Upfc = new CG_CL_UpdateJob_FC_AC_ChildEntities();
        Map<String, List<CSS_Solution_Component__c>> failCodeMapTest = new Map<String, List<CSS_Solution_Component__c>>();
        failCodeMapTest.put(lstsol[0].SysCodeAndCompCode__c,lstsol);
        Map<String, List<CSS_Solution_Component__c>> accCodeMapTest = new Map<String, List<CSS_Solution_Component__c>>();
        accCodeMapTest.put(lstsol[0].CSS_Account_Formula__c,lstsol);
        upfc.updateFailCodeAccCode(solcomp1.Fail_Code__c,solcomp1.AccountCode__c,solcomp1.Fail_Code__c,solcomp1.AccountCode__c,solcomp1,servicejob.Id,'Test');
        //scenario4
        Id recTypeIdOC = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'OtherClaimables');
        CSS_Parts_Options__c prtsoptn1 = new CSS_Parts_Options__c();
        prtsoptn1.Service_Job__c = servicejob.Id;
        prtsoptn1.RecordTypeId = recTypeIdOC;
        prtsoptn1.FailurepartId__c = solcomp2.Id;
        prtsoptn1.Parts_Type__c = 'Test';
        prtsoptn1.Fail_Code__c = 'YNBC';
        prtsoptn1.Account_Code__c = 'ACCOUNT TEAM COVERAGE 69';
        insert prtsoptn1;
        upfc.updateFailCodeAccCode(solcomp1.Fail_Code__c,solcomp1.AccountCode__c,solcomp2.Fail_Code__c,solcomp2.AccountCode__c,solcomp2,servicejob.Id,'Test');
        Test.stopTest();
        
    }
    static testMethod void FetchGSQPartsMethod(){
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02466';
        acc.IAM_Service_Provider_Code__c='19134';
        acc.Type='Dealer Account';
        acc.CMI_Account_Status__c = 'Active';
        insert acc;
        CSS_Job_Order__c servicejob= new CSS_Job_Order__c();
        servicejob.Status__c = 'Intake';
        servicejob.Account__c = acc.id;
        servicejob.INSITE_UpdateTimeStamp__c =system.today();
        servicejob.INSITE_ESN_Choice__c='Not Selected';
        servicejob.Qsol_Engine_Family_Code__c = 'code';
        servicejob.Warranty_Start_Date__c = date.today();
        servicejob.CSS_Job_Location_Code__c = 'location';
        servicejob.ApplicationCode__c = 'code';
        insert servicejob; 
        
        CSS_Solution_Component__c solcomp = new CSS_Solution_Component__c();
        solcomp.Selected_Component__c=true;
        solcomp.AccountCode__c='NEW PRODUCT WARRANTY 67';
        solcomp.Status__c='Approved';
        solcomp.Type__c='Test';
        solcomp.Service_Job__c = servicejob.Id;
        solcomp.System_Code__c = 'TH';
        solcomp.Component_Code__c = 'AC';
        solcomp.Fail_Code_Editable__c = 'YENB';
        insert solcomp; 
        
        test.startTest();
        CG_CL_UpdateJob_FC_AC_ChildEntities.FetchGSQParts(solcomp.Id,servicejob.Id);
        test.stopTest();
    }
    static testMethod void callGSQSrtsMethod(){
        
        CSS_Job_Order__c servicejob= new CSS_Job_Order__c();
        servicejob.Status__c = 'Intake';
        servicejob.INSITE_UpdateTimeStamp__c =system.today();
        servicejob.INSITE_ESN_Choice__c='Not Selected';
        servicejob.Qsol_Engine_Family_Code__c = 'code';
        servicejob.Warranty_Start_Date__c = date.today();
        servicejob.CSS_Job_Location_Code__c = 'location';
        servicejob.ApplicationCode__c = 'code';
        insert servicejob; 
        
        CSS_Solution_Component__c solcomp = new CSS_Solution_Component__c();
        solcomp.Selected_Component__c=true;
        solcomp.AccountCode__c='NEW PRODUCT WARRANTY 67';
        solcomp.Status__c='Approved';
        solcomp.Type__c='Test';
        solcomp.Service_Job__c = servicejob.Id;
        solcomp.System_Code__c = 'TH';
        solcomp.Component_Code__c = 'AC';
        solcomp.Fail_Code_Editable__c = 'YENB';
        solcomp.CoveredLaborHrs__c='100';
        solcomp.CampaignLaborPercentage__c = '222';
        insert solcomp; 
        
        CSS_Solution_Component__c solcomp1 = new CSS_Solution_Component__c();
        solcomp1.Selected_Component__c=true;
        solcomp1.AccountCode__c='NEW PRODUCT WARRANTY 67';
        solcomp1.Status__c='Approved';
        solcomp1.Type__c='Test';
        solcomp1.Service_Job__c = servicejob.Id;
        solcomp1.System_Code__c = 'TH';
        solcomp1.Component_Code__c = 'AC';
        solcomp1.Fail_Code_Editable__c = 'YENB';
        solcomp1.CoveredLaborHrs__c='100';
        solcomp1.CampaignLaborPercentage__c = '222';
        insert solcomp1; 
        
        test.startTest();
        CG_CL_UpdateJob_FC_AC_ChildEntities.callGSQSrts(solcomp,servicejob.Id,solcomp1,'failCode','accCode');
        test.stopTest();
    }
}