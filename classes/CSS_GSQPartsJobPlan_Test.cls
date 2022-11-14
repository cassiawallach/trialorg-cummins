/**********************************************************************
Name: CSS_sendGSQParts_Test
Copyright © 2016  Cummins
======================================================
======================================================
Purpose:    Test Class for CSS_GSQPartsJobPlan

======================================================
======================================================
History                                                            
-------                                                            
VERSION       AUTHOR                   DATE          DETAIL                                 
1.0           shanthi                    14/9/2017   INITIAL dEVELOPMENT

***********************************************************************/
@isTest
public class CSS_GSQPartsJobPlan_Test {
    
    static testmethod void CSS_GSQPartsJobPlantest2(){
        
        //Add test data for Service job orders
        // CSS_Job_Order__c JO = CSS_TestData.createJobOrder(true);
        CSS_Job_Order__c SerRec =new CSS_Job_Order__c();
        SerRec.DSID__c='12345';
        //SerRec.OwnerId = tq.Id;
        SerRec.DSID_Status__c='open';
        SerRec.ESN__c ='79464646';
        SerRec.Customer_Name__c='ABC';
        //SerRec.Failure_Date__c =d;
        SerRec.Failure_Point__c=2.2;
        SerRec.Unit_Number__c='1234';
        SerRec.Service_Model__c='ESN';
        SerRec.Service_Model_N__c = 445566;
        SerRec.Make__c='test';
        SerRec.Model__c='test1';
        SerRec.VIN__c='1XKAD49X6CJ305490';
        SerRec.Customer_Name__c='ABC';
        //SerRec.Warranty_Start_Date__c=d;
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
        insert SerRec;
        CSS_Solutions__c solAdd = new CSS_Solutions__c();
        solAdd.Service_Job__c = SerRec.id;
        solAdd.Case_Name__c = 'Additional SRTS';
        solAdd.Solution_Title__c='Additional SRTS';
        
        solAdd.Name='TestSRTS'+Math.random();
        solAdd.Diagnostic_Response__c ='Most likely the solution';
        solAdd.Diagnostic_notes__c = 'solutions diagnostic notes';
        solAdd.Repair_Notes__c = 'Repair Notes';
        //solAdd.FaultCode__c = 'solution faultcode';
        //solAdd.Repair_Response__c = 'Most likely ';
        solAdd.Repair_Response__c = 'Repair Successful.';
        solAdd.Rank__c = 3;
        insert solAdd;
        CSS_GSQPartsJobPlan cdf = new CSS_GSQPartsJobPlan();
        cdf.SelectedFailCode = 'ATHAS';
        // CSS_Solution_Component__c csc = CSS_TestData.createSRT(true,SerRec.id,solAdd.id);
        List<CSS_Solution_Component__c> solsComp = new List<CSS_Solution_Component__c>();
        CSS_Solution_Component__c AddsolComp = new CSS_Solution_Component__c();
        AddsolComp.Component_Id__c ='F0051000';
        AddsolComp.Service_Job__c = SerRec.id;
        AddsolComp.Action__c = 'Repair';
        AddsolComp.Solutions__c = solAdd.id;
        AddsolComp.Quantity__c = 4;
        AddsolComp.type__c='OTH';
        Addsolcomp.System_Code__c='TH';
        AddsolComp.Component_Code__c= 'AC';
        AddsolComp.Selected_Component__c = false;
        AddsolComp.AccountCode__c = 'Test-AccountCode';
        AddsolComp.AccountCodeEdit__c = 'Test-ACEdit';
        AddsolComp.CoveredPartsQty__c = '0';
        AddsolComp.AccountCodeType__c='ASAS';
        //AddsolComp.Fail_Code__c=null;
        AddsolComp.Fail_Code_Editable__c=cdf.SelectedFailCode;
        AddsolComp.Charlength__c = true;
        // AddsolComp.SysCodeAndCompCode__c='THAC';
        AddsolComp.Name = 'Test'+Math.random();
        
        solsComp.add(AddsolComp);
        insert solsComp;
        CSS_Solution_Component__c solcomp = new CSS_Solution_Component__c();
        solcomp.Selected_Component__c = false;
        solcomp.AccountCode__c = 'Test-AccountCode';
        solcomp.AccountCodeEdit__c = 'Test-ACEdit';
        solcomp.System_Code__c = 'Testing';
        solcomp.Component_Code__c='gyhgkg';
        solsComp.add(solcomp);
        system.debug('solsComp'+solsComp);
        upsert solsComp;
        //CSS_JobEventTemporary__c jobevent = CSS_TestData.createJobEventTempObj(true);
        List<CSS_JobEventTemporary__c> jobeventlist = new List<CSS_JobEventTemporary__c>();
        CSS_JobEventTemporary__c jobevent = new CSS_JobEventTemporary__c();
        jobevent.File_Name__c='Test';
        jobevent.Circuit_Description__c='rrrr';
        jobevent.Comp_Location__c='dfgh';
        jobevent.Effect__c='klkl';
        jobevent.Engine__c='bfr';
        jobevent.Fault_Code_Description__c = 'intake';
        jobevent.File_Name__c = 'testing';
        jobevent.FMI__c = 'htyu';
        jobevent.Lamp__c = 'nhgt';
        jobevent.Reason__c = 'yyyy';
        jobevent.Service_Model_Name__c = 'fault';
        jobevent.SPN__c = 'bfgfhhj';
        jobevent.Attribute1__c= 'OTH'; //string.valueof(system.now());
        jobevent.Attribute2__c='test2';
        jobevent.Attribute3__c='test3';
        jobevent.Attribute4__c='1.0';
        jobevent.Attribute5__c='test5';
        jobevent.Attribute6__c='test6';
        jobevent.Attribute7__c='test7';
        jobevent.Attribute8__c='test9';
        jobevent.Attribute9__c='test10';
        jobevent.Attribute10__c='test11';
        jobevent.Attribute11__c='2014-05-08T00:00:00.000-05:00';
        jobevent.Attribute12__c='test13';
        date d =  Date.today();
        jobevent.Attribute13__c=d;
        jobevent.Attribute14__c='test15';
        jobevent.Attribute15__c='test8';
        jobevent.Reason__c='tEst';
        jobevent.key__c='AccountCodes';
        jobevent.type__c='ClaimHistory';
        jobevent.Active__c=true;
        jobeventlist.add(jobevent);
        Id recTypeIdpart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'Parts');
        List<CSS_Parts_Options__c> toDeleteCustPartsList = new list<CSS_Parts_Options__c>();
        //for(integer i=0;i<5;i++){
        CSS_Parts_Options__c parts = new CSS_Parts_Options__c();
        parts.recordtypeId = recTypeIdpart;
        parts.Notes__c = 'wenchin Chinnoy';
        parts.OEM__c = 'Wenchin Test';
        parts.Replacement_Reason__c = 'Root Cause';
        //parts.Quantity__c = 45645123;
        parts.Quantity__c = null;
        parts.Part_Name__c = '6.2 CALIBRATION FLT REG.';
        parts.Service_partnumber__c ='4034289RX';
        parts.Solutions__c = solAdd.Id;
        parts.Option_Number__c = 'O-111';
        parts.Service_Job__c = SerRec.Id;
        parts.selected_part__c = true;
        parts.FailurepartId__c = AddsolComp.Id;
        parts.Parts_Type__c ='Custom';
        parts.Account_Code__c ='NEW PARTS WARRANTY 62';
        parts.Quantity__c = 1;
        insert parts;
        
        CSS_Parts_Options__c parts2 = new CSS_Parts_Options__c();
        parts2.recordtypeId = recTypeIdpart;
        parts2.Notes__c = 'wenchin Chinnoy';
        parts2.OEM__c = 'Wenchin Test';
        parts2.Replacement_Reason__c = 'Root Cause';
        parts2.Quantity__c = 45645123;
        parts2.Part_Name__c = '6.2 CALIBRATION FLT REG.';
        parts2.Service_partnumber__c ='4034289RX';
        parts2.Solutions__c = solAdd.Id;
        parts2.Option_Number__c = 'O-111';
        parts2.Service_Job__c = SerRec.Id;
        parts2.selected_part__c = true;
        parts2.FailurepartId__c = AddsolComp.Id;
        parts2.Parts_Type__c ='Custom';
        // parts.Part_Name__c='test';
        parts2.Quantity__c = 1;
        insert parts2;
        
        CSS_Parts_Options__c parts3 = new CSS_Parts_Options__c();
        parts3.recordtypeId = recTypeIdpart;
        parts3.Notes__c = 'wenchin Chinnoy';
        parts3.OEM__c = 'Wenchin Test';
        parts3.Replacement_Reason__c = 'Root Cause';
        parts3.Quantity__c = 45645123;
        parts3.Part_Name__c = '6.2 CALIBRATION FLT REG.';
        parts3.Service_partnumber__c ='4034289RX';
        parts3.Solutions__c = solAdd.Id;
        parts3.Option_Number__c = 'O-111';
        parts3.Service_Job__c = SerRec.Id;
        parts3.selected_part__c = true;
        parts3.FailurepartId__c = AddsolComp.Id;
        parts3.Parts_Type__c ='Custom';
        // parts.Part_Name__c='test';
        parts3.Quantity__c = 1;
        insert parts3;
        
        CSS_Parts_Options__c parts4 = new CSS_Parts_Options__c();
        parts4.recordtypeId = recTypeIdpart;
        parts4.Notes__c = 'wenchin Chinnoy';
        parts4.OEM__c = 'Wenchin Test';
        parts4.Replacement_Reason__c = 'Root Cause';
        parts4.Quantity__c = 45645123;
        parts4.Part_Name__c = '6.2 CALIBRATION FLT REG.';
        parts4.Service_partnumber__c ='4034289RX';
        parts4.Solutions__c = solAdd.Id;
        parts4.Option_Number__c = 'O-111';
        parts4.Service_Job__c = SerRec.Id;
        parts4.selected_part__c = true;
        parts4.FailurepartId__c = AddsolComp.Id;
        parts4.Parts_Type__c ='Custom';
        // parts.Part_Name__c='test';
        parts4.Quantity__c = 1;
        insert parts4;
        
        CSS_Parts_Options__c parts5 = new CSS_Parts_Options__c();
        parts5.recordtypeId = recTypeIdpart;
        parts5.Notes__c = 'wenchin Chinnoy';
        parts5.OEM__c = 'Wenchin Test';
        parts5.Replacement_Reason__c = 'Root Cause';
        parts5.Quantity__c = 45645123;
        parts5.Part_Name__c = '6.2 CALIBRATION FLT REG.';
        parts5.Service_partnumber__c ='4034289RX';
        parts5.Solutions__c = solAdd.Id;
        parts5.Option_Number__c = 'O-111';
        parts5.Service_Job__c = SerRec.Id;
        parts5.selected_part__c = true;
        parts5.FailurepartId__c = AddsolComp.Id;
        parts5.Parts_Type__c ='Custom';
        // parts.Part_Name__c='test';
        parts5.Quantity__c = 1;
        insert parts5;
        
        toDeleteCustPartsList.add(parts);
        toDeleteCustPartsList.add(parts2);
        toDeleteCustPartsList.add(parts3);
        toDeleteCustPartsList.add(parts4);
        toDeleteCustPartsList.add(parts5);
        //insert toDeleteCustPartsList;
        
        CSS_JobEventTemporary__c tmpObj = new CSS_JobEventTemporary__c();
        tmpObj.key__c = 'AccountCodes';
        jobeventlist.add(tmpObj);
        insert jobeventlist;
        PageReference prefs;
        prefs = new PageReference('/'+SerRec.id);
        prefs.getParameters().put('id',SerRec.id);
        Test.setCurrentPage(prefs);        
        
        Test.startTest();
        CSS_GSQPartsJobPlan gsq = new CSS_GSQPartsJobPlan ();
        set<string> errMsgLst = new set<string>();
        CG_CL_CoverageLimitExceedValidation contr = new CG_CL_CoverageLimitExceedValidation();
            errMsgLst = contr.covLimitValidation(serRec.Id, null, toDeleteCustPartsList, null);
            errMsgLst = contr.covLimitValidationJob(serRec.Id, toDeleteCustPartsList);
        gsq.servicepartname = 'Testing';
        css_job_order__c fd=gsq.workJob;
        list<string> lstAccountCodes = gsq.lstAccountCodes;
        List<SelectOption> accCodes = gsq.accCodes;
        list<CSS_JobEventTemporary__c> jobEventTemp = gsq.jobEventTemp;
        gsq.partrownumber='0';
        gsq.recTypeIdpart = parts5.id;
        gsq.coverageType='coverageType';
        //list<CSS_JobEventTemporary__c> jobEventLst = gsq.jobEventLst;
        gsq.SelectedPartID = 0;
        List<SelectOption> sel= gsq.getfailcodeDropDown();
        List<CSS_GSQPartsJobPlan.partWrapperClass> lstpart= new List<CSS_GSQPartsJobPlan.partWrapperClass>();
        CSS_GSQPartsJobPlan.partWrapperClass partWrap=new CSS_GSQPartsJobPlan.partWrapperClass(10,parts.id,'10','4034289RX','partName','replacementReasson','notes','oem',true,'returnToFactory','60','failCode','accountCode',sel);
        CSS_GSQPartsJobPlan.partWrapperClass partWrap2=new CSS_GSQPartsJobPlan.partWrapperClass(10,parts2.id,'11','4034289RX','partName','replacementReasson','notes','oem',true,'returnToFactory','60','failCode','accountCode',sel);  
        CSS_GSQPartsJobPlan.partWrapperClass partWrap3=new CSS_GSQPartsJobPlan.partWrapperClass(10,parts3.id,'12','4034289RX','partName','replacementReasson','notes','oem',true,'returnToFactory','60','failCode','accountCode',sel);  
        CSS_GSQPartsJobPlan.partWrapperClass partWrap4=new CSS_GSQPartsJobPlan.partWrapperClass(10,parts4.id,'13','4034289RX','partName','replacementReasson','notes','oem',true,'returnToFactory','60','failCode','accountCode',sel);  
        CSS_GSQPartsJobPlan.partWrapperClass partWrap5=new CSS_GSQPartsJobPlan.partWrapperClass(10,parts5.id,'14','4034289RX','partName','replacementReasson','notes','oem',true,'returnToFactory','60','failCode','accountCode',sel);  
        lstpart.add(partWrap);
        lstpart.add(partWrap2);
        lstpart.add(partWrap3);
        lstpart.add(partWrap4);
        lstpart.add(partWrap5);
        
        gsq.Ins_JobId =SerRec.Id;
        gsq.assignedParts=0;
        //gsq.coverageType='OTH';
        //pageReference pref1 = gsq.saveCustomParts();
        //pageReference pred2 = gsq.onChangeofFailCode();
        gsq.getreplacementReasonOptions();
        CG_OP_OAGWrapper opres = new CG_OP_OAGWrapper();
        gsq.listpartWrapper=lstpart;
         gsq.partrownumber='10';
        opres = CSS_FN_SIEBEL.getpartsdata(lstpart[0].servPartNumber);
        system.debug('opres'+opres);
        Test.setMock(HttpCalloutMock.class, new CSS_WS_SBL_getPartReturnDetailsMock_Test());
        gsq.CallGetPartDataService();
        gsq.getallCustomPartsData(true);
        //gsq.saveCustomParts();
        gsq.SelectedFailCode = 'Select One';
        gsq.onChangeofFailCode();
        //gsq.onChangeofPartNumber(57380);
        gsq.AddRow();
        gsq.removingRow();
        gsq.closePopup2();
        Test.stopTest();
    }
    
    
    static testmethod void CSS_GSQPartsJobPlantest4(){
        
        //Add test data for Service job order
        CSS_Job_Order__c JO = CSS_TestData.createJobOrder(true);
        PageReference prefs;
        prefs = new PageReference('/'+JO.id);
        prefs.getParameters().put('id',JO.id);
        Test.setCurrentPage(prefs);
        CSS_Solutions__c sol1= CSS_TestData.createSolutions(true,JO.id);
        CSS_Solution_Component__c csc = CSS_TestData.createSRT(true,JO.id,sol1.id);
        CSS_JobEventTemporary__c jobevent = CSS_TestData.createJobEventTempObj(true);
        Id recTypeIdpart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'Parts');
        
        
        
        Test.startTest();
        CSS_GSQPartsJobPlan  gsq = new CSS_GSQPartsJobPlan ();
        // gsq.Ins_JobId =JO.Id;
        //gsq.assignedParts=0;
        //gsq.onChangeofFailCode();
        // gsq.getreplacementReasonOptions();
        //gsq.getallCustomPartsData(false);
        //gsq.onChangeofFailCode();
        //pageReference pref1 = gsq.saveCustomParts();
        gsq.deleteParts();
        gsq.removeIdsMap.clear();
        gsq.deleteParts();
        //gsq.CallGetPartDataService();
        gsq.AddRow();
        gsq.removingRow();
        gsq.closePopup2();
        Test.stopTest();
    }
    
    static testmethod void testmethod6()
    {
        test.startTest();
        System.runAs ( new User(Id = UserInfo.getUserId()) ) {
            
            Group Q = new Group();
            Q.Type = 'Queue';
            //Q.OwnerId=objUser1.id;
            Q.Name = 'JQ'+'-'+'57380-57380';
            insert Q;
            QueueSObject q1 = new QueueSObject(SobjectType='CSS_Job_Order__c', QueueId=Q.Id);
            insert q1;
            
            css_job_order__c wo = css_testdata.createJobOrder(false);
            wo.CSS_Job_Location_Code__c='57380-57380';
            wo.Customer_Name__c='Gopal';
            wo.Customer_Code__c='123';
            wO.OwnerId = UserInfo.getUserId();
            // wO.CSS_Job_Location_Code__c = '03520-04892';
            insert wo;
            
            css_job_order__c wo1=[Select Id,Name,AccessCode__c,BMSWSStatus__c,BMSStatus__c,Customer_Name__c,Shop_Work_Order__c, Application__c, Unit_Number__c, Unit_Type__c, Date_in__c, INSITE_UpdateTimeStamp__c, First_Name__c,
                                  Service_Model__c, VIN__c, Customer_Code__c,Status__c, Model__c,Creator_Location__c,ESN__c 
                                  from CSS_Job_Order__c where id=:wo.id];
            CSS_Solutions__c sol=css_testdata.createSolutions(false, wo1.id);
            insert sol;
            CSS_Solution_Component__c Solcomp3 = css_testdata.createSRT(false, wo1.Id, sol.Id);
            Solcomp3.AccountCodeEdit__c='Test-AccountCode';
            solcomp3.Fail_Code_Editable__c='Batteries-QCGK';
            Solcomp3.System_Code__c='TH';
            Solcomp3.Component_Code__c='AC';
            insert Solcomp3;
            CSS_Solution_Component__c Solcomp4 = css_testdata.createSRT(false, wo1.Id, sol.Id);
            Solcomp4.AccountCodeEdit__c='Test-AccountCode';
            solcomp4.Fail_Code_Editable__c='Batteries-QCGK';
            solcomp4.AccountCode__c = 'Test-AccountCode';
            solcomp4.Component_Id__c='F0051001';
            solcomp4.System_Code__c='TH';
            solcomp4.Component_Code__c='AC';
            insert Solcomp4;
            system.assert(wo1!=null);
            List<CSS_Solution_Component__c> SolCmps = [SELECT  Id,SysCodeAndCompCode__c,FailCode_Formula__c,Fail_Code_Editable__c,AccountCode__c,AccountCodeEdit__c ,CoveredPartsQty__c,Fail_Code__c, CSS_Account_Formula__c from CSS_Solution_Component__c where Service_Job__c =:wo1.Id]; 
            system.assert(SolCmps!=null);
            //        test.startTest();
            CSS_GSQPartsJobPlan gsq = new CSS_GSQPartsJobPlan();
            gsq.Ins_JobId =wo1.Id;
            system.debug('GetAccountCode starts');
            //gsq.getAccountCodeDropDown();
            system.debug('GetAccountCode ends');
            gsq.SelectedAccountCode='Test-AccountCode';
            gsq.SelectedFailCode='Batteries-QCGK';
            gsq.SelectedPartID = 1;
            //gsq.onChangeofFailCode();
            gsq.onChangeofAccountCode();
            gsq.SelectedAccountCode = 'Select One';
            gsq.onChangeofAccountCode();
            //gsq.saveCustomParts();
            gsq.deleteParts();
            //gsq.CallGetPartDataService();
            gsq.AddRow();
            gsq.removingRow();
            gsq.closePopup2();
        }
        test.stopTest();
    }
    
    static testmethod void testmethod7()
    {
        
        System.runAs ( new User(Id = UserInfo.getUserId()) ) {
            
            Group Q = new Group();
            Q.Type = 'Queue';
            //Q.OwnerId=objUser1.id;
            Q.Name = 'JQ'+'-'+'57380-57380';
            insert Q;
            QueueSObject q1 = new QueueSObject(SobjectType='CSS_Job_Order__c', QueueId=Q.Id);
            insert q1;
            
            css_job_order__c wo = css_testdata.createJobOrder(false);
            wo.CSS_Job_Location_Code__c='57380-57380';
            wo.Customer_Name__c='Gopal';
            wo.Customer_Code__c='123';
            wO.OwnerId = UserInfo.getUserId();
            insert wo;
            css_job_order__c wo1=[Select Id,Name,AccessCode__c,BMSWSStatus__c,BMSStatus__c,Customer_Name__c,Shop_Work_Order__c, Application__c, Unit_Number__c, Unit_Type__c, Date_in__c, INSITE_UpdateTimeStamp__c, First_Name__c,
                                  Service_Model__c, VIN__c, Customer_Code__c,Status__c, Model__c,Creator_Location__c,ESN__c 
                                  from CSS_Job_Order__c where id=:wo.id];
            CSS_Solutions__c sol=css_testdata.createSolutions(false, wo1.id);
            insert sol;
            CSS_Solution_Component__c Solcomp3 = css_testdata.createSRT(false, wo1.Id, sol.Id);
            Solcomp3.AccountCodeEdit__c='Test-AccountCode';
            solcomp3.Fail_Code_Editable__c='Batteries-QCGK';
            solcomp3.System_Code__c='TH';
            solcomp3.Component_Code__c='AC';
            insert Solcomp3;
            
            Id recTypeIdpart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'Parts');
            CSS_Parts_Options__c parts = new CSS_Parts_Options__c();
            parts.recordtypeId = recTypeIdpart;
            parts.Option_Number__c = 'O-111';
            parts.Service_Job__c = WO.Id;
            parts.selected_part__c = true;
            parts.FailurepartId__c = Solcomp3.Id;
            parts.Parts_Type__c ='Custom';
            parts.Part_Name__c='test';
            parts.Service_partnumber__c='';
            parts.Quantity__c=1;
            parts.Covered__c=1.0;
            
            insert parts;
            
            css_header_nav__c headerNav = new css_header_nav__c();
            headerNav.RSWButtonEnable__c = true;
            insert headerNav;
            
            system.assert(wo1!=null);
            List<CSS_Solution_Component__c> SolCmps = [SELECT  Id, SysCodeAndCompCode__c,FailCode_Formula__c,Fail_Code_Editable__c,AccountCode__c,AccountCodeEdit__c ,CoveredPartsQty__c,Fail_Code__c, CSS_Account_Formula__c from CSS_Solution_Component__c where Service_Job__c =:wo1.Id]; 
            system.assert(SolCmps!=null);
            test.startTest();
            CSS_GSQPartsJobPlan gsq = new CSS_GSQPartsJobPlan();
            gsq.Ins_JobId =wo1.Id;
            system.debug('GetAccountCode starts');
            //gsq.getAccountCodeDropDown();
            system.debug('GetAccountCode ends');
            gsq.SelectedAccountCode='Test-AccountCode';
            gsq.SelectedFailCode='Batteries-QCGK';
            
            gsq.onChangeofAccountCode();
            //gsq.saveCustomParts();
            gsq.onChangeofFailCode();
            gsq.deleteParts();
            //gsq.CallGetPartDataService();
            gsq.AddRow();
            gsq.removingRow();
            gsq.closePopup2();
        }
        test.stopTest();
    }
    
    static testmethod void testmethod8()
    {
        System.runAs ( new User(Id = UserInfo.getUserId()) ) {
            Group Q = new Group();
            Q.Type = 'Queue';
            //Q.OwnerId=objUser1.id;
            Q.Name = 'JQ'+'-'+'57380-57380';
            insert Q;
            QueueSObject q1 = new QueueSObject(SobjectType='CSS_Job_Order__c', QueueId=Q.Id);
            insert q1;
            css_job_order__c wo = css_testdata.createJobOrder(false);
            wo.CSS_Job_Location_Code__c='57380-57380';
            wo.Customer_Name__c='Gopal';
            wo.Customer_Code__c='123';
            wO.OwnerId = UserInfo.getUserId();
            insert wo;
            css_job_order__c wo1=[Select Id,Name,AccessCode__c,BMSWSStatus__c,BMSStatus__c,Customer_Name__c,Shop_Work_Order__c, Application__c, Unit_Number__c, Unit_Type__c, Date_in__c, INSITE_UpdateTimeStamp__c, First_Name__c,
                                  Service_Model__c, VIN__c, Customer_Code__c,Status__c, Model__c,Creator_Location__c,ESN__c 
                                  from CSS_Job_Order__c where id=:wo.id];
            CSS_Solutions__c sol=css_testdata.createSolutions(false, wo1.id);
            insert sol;
            CSS_Solution_Component__c Solcomp3 = css_testdata.createSRT(false, wo1.Id, sol.Id);
            Solcomp3.AccountCodeEdit__c='Test-AccountCode';
            solcomp3.Fail_Code_Editable__c='Batteries-QCGK';
            solcomp3.System_Code__c='TH';
            solcomp3.Component_Code__c='AC';
            insert Solcomp3;
            CSS_Solution_Component__c Solcomp4 = css_testdata.createSRT(false, wo1.Id, sol.Id);
            Solcomp4.AccountCodeEdit__c='Test-AccountCode';
            solcomp4.Fail_Code_Editable__c='Batteries-QCGK';
            solcomp4.AccountCode__c = 'Test-AccountCode';
            solcomp4.Component_Id__c='F0051001';
            solcomp4.System_Code__c='TH';
            solcomp4.Component_Code__c='AC';
            insert Solcomp4;
            Id recTypeIdpart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'Parts');
            CSS_Parts_Options__c parts = new CSS_Parts_Options__c();
            parts.recordtypeId = recTypeIdpart;
            parts.Option_Number__c = 'O-111';
            parts.Service_Job__c = WO.Id;
            parts.selected_part__c = true;
            parts.FailurepartId__c = Solcomp3.Id;
            parts.Parts_Type__c ='Custom';
            parts.Part_Name__c='test';
            parts.Service_partnumber__c='';
            parts.Quantity__c=1;
            parts.Covered__c=1.0;
            
            insert parts;
            system.assert(wo1!=null);
            List<CSS_Solution_Component__c> SolCmps = [SELECT  Id,SysCodeAndCompCode__c,FailCode_Formula__c,Fail_Code_Editable__c,AccountCode__c,AccountCodeEdit__c ,CoveredPartsQty__c,Fail_Code__c, CSS_Account_Formula__c from CSS_Solution_Component__c where Service_Job__c =:wo1.Id]; 
            system.assert(SolCmps!=null);
            test.startTest();
            CSS_GSQPartsJobPlan gsq = new CSS_GSQPartsJobPlan();
            gsq.Ins_JobId =wo1.Id;
            system.debug('GetAccountCode starts');
            //gsq.getAccountCodeDropDown();
            system.debug('GetAccountCode ends');
            gsq.SelectedAccountCode='Test-AccountCode';
            gsq.SelectedFailCode='Batteries-QCGK';
            //gsq.onChangeofFailCode();
            gsq.onChangeofAccountCode();
            gsq.closePopup1();
            gsq.deleteParts();
            //gsq.saveCustomParts();
            gsq.onChangeofFailCode();
            //gsq.CallGetPartDataService();
            gsq.AddRow();
            gsq.removingRow();
            gsq.closePopup2();
        }
        test.stopTest();
    }
    
    static testmethod void testmethod9()
    {
        System.runAs ( new User(Id = UserInfo.getUserId()) ) {
            Group Q = new Group();
            Q.Type = 'Queue';
            //Q.OwnerId=objUser1.id;
            Q.Name = 'JQ'+'-'+'57380-57380';
            insert Q;
            QueueSObject q1 = new QueueSObject(SobjectType='CSS_Job_Order__c', QueueId=Q.Id);
            insert q1;
            
            css_job_order__c wo = css_testdata.createJobOrder(false);
            wo.CSS_Job_Location_Code__c='57380-57380';
            wo.Customer_Name__c='Gopal';
            wo.Customer_Code__c='123';
            wo.ownerId = UserInfo.getUserId();
            insert wo;
            PageReference prefs;
            prefs = new PageReference('/'+wo.id);
            prefs.getParameters().put('id',wo.id);
            Test.setCurrentPage(prefs);
            css_job_order__c wo1=[Select Id,Name,AccessCode__c,BMSWSStatus__c,BMSStatus__c,Customer_Name__c,Shop_Work_Order__c, Application__c, Unit_Number__c, Unit_Type__c, Date_in__c, INSITE_UpdateTimeStamp__c, First_Name__c,
                                  Service_Model__c, VIN__c, Customer_Code__c,Status__c, Model__c,Creator_Location__c,ESN__c 
                                  from CSS_Job_Order__c where id=:wo.id];
            CSS_Solutions__c sol=css_testdata.createSolutions(false, wo1.id);
            insert sol;
            CSS_Solution_Component__c Solcomp3 = css_testdata.createSRT(false, wo1.Id, sol.Id);
            Solcomp3.AccountCodeEdit__c='Test-AccountCode';
            solcomp3.Fail_Code_Editable__c='Batteries-QCGK';
            solcomp3.System_Code__c='TH';
            solcomp3.Component_Code__c='AC';
            insert Solcomp3;
            CSS_Solution_Component__c Solcomp4 = css_testdata.createSRT(false, wo1.Id, sol.Id);
            Solcomp4.AccountCodeEdit__c='Test-AccountCode';
            solcomp4.Fail_Code_Editable__c='Batteries-QCGK';
            solcomp4.AccountCode__c = 'Test-AccountCode';
            solcomp4.Component_Id__c='F0051001';
            solcomp4.System_Code__c='TH';
            solcomp4.Component_Code__c='AC';
            insert Solcomp4;
            Id recTypeIdpart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'Parts');
            
            system.assert(wo1!=null);
            List<CSS_Solution_Component__c> SolCmps = [SELECT  Id, SysCodeAndCompCode__c,FailCode_Formula__c,Fail_Code_Editable__c,AccountCode__c,AccountCodeEdit__c ,CoveredPartsQty__c,Fail_Code__c, CSS_Account_Formula__c from CSS_Solution_Component__c where Service_Job__c =:wo1.Id]; 
            system.assert(SolCmps!=null);
            test.startTest();
            CSS_GSQPartsJobPlan gsq = new CSS_GSQPartsJobPlan();
            gsq.Ins_JobId =wo1.Id;
            system.debug('GetAccountCode starts');
            
            system.debug('GetAccountCode ends');
            gsq.SelectedAccountCode='Test-AccountCode';
            gsq.SelectedFailCode='Batteries-QCGK';
            
            gsq.onChangeofAccountCode();
            GSQ.closePopup1();
            GSQ.listpartWrapper=null;
            
            gsq.closePopup2();
            
        }
        test.stopTest();
    }
    
    static testmethod void testmethod10()
    {
        System.runAs ( new User(Id = UserInfo.getUserId()) ) {
            Group Q = new Group();
            Q.Type = 'Queue';
			Q.Name = 'JQ'+'-'+'57380-57380';
            insert Q;
            QueueSObject q1 = new QueueSObject(SobjectType='CSS_Job_Order__c', QueueId=Q.Id);
            insert q1;
            css_job_order__c wo = css_testdata.createJobOrder(false);
            wo.CSS_Job_Location_Code__c='57380-57380';
            wo.Customer_Name__c='Gopal';
            wo.Customer_Code__c='123';
            wo.ownerId = UserInfo.getUserId();
            insert wo;
            PageReference prefs;
            prefs = new PageReference('/'+wo.id);
            prefs.getParameters().put('id',wo.id);
            Test.setCurrentPage(prefs);
            css_job_order__c wo1=[Select Id,Name,AccessCode__c,BMSWSStatus__c,BMSStatus__c,Customer_Name__c,Shop_Work_Order__c, Application__c, Unit_Number__c, Unit_Type__c, Date_in__c, INSITE_UpdateTimeStamp__c, First_Name__c,
                                  Service_Model__c, VIN__c, Customer_Code__c,Status__c, Model__c,Creator_Location__c,ESN__c 
                                  from CSS_Job_Order__c where id=:wo.id];
            CSS_Solutions__c sol=css_testdata.createSolutions(false, wo1.id);
            insert sol;
            CSS_Solution_Component__c Solcomp3 = css_testdata.createSRT(false, wo1.Id, sol.Id);
            Solcomp3.AccountCodeEdit__c='Test-AccountCode';
            solcomp3.Fail_Code_Editable__c='Batteries-QCGK';
            solcomp3.System_Code__c='TH';
            solcomp3.Component_Code__c='AC';
            insert Solcomp3;
            CSS_Solution_Component__c Solcomp4 = css_testdata.createSRT(false, wo1.Id, sol.Id);
            Solcomp4.AccountCodeEdit__c='Test-AccountCode';
            solcomp4.Fail_Code_Editable__c='Batteries-QCGK';
            solcomp4.AccountCode__c = 'Test-AccountCode';
            solcomp4.Component_Id__c='F0051001';
            solcomp4.System_Code__c='TH';
            solcomp4.Component_Code__c='AC';
            insert Solcomp4;
            Id recTypeIdpart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'Parts');
            list<CSS_Parts_Options__c> partlst = new list<CSS_Parts_Options__c>();
            CSS_Parts_Options__c parts = new CSS_Parts_Options__c();
            parts.recordtypeId = recTypeIdpart;
            parts.Option_Number__c = null;
            parts.Service_Job__c = WO.Id;
            parts.selected_part__c = false;
            parts.FailurepartId__c = Solcomp3.Id;
            parts.Parts_Type__c ='Custom';
            parts.Part_Name__c=null;
            parts.Service_partnumber__c=null;
            parts.Quantity__c=null;
            parts.Covered__c=null;
            parts.Service_partnumber__c=null;
            parts.Fail_Code__c=null;
            
            //insert parts;
            partlst.add(parts);
            CSS_Parts_Options__c part = new CSS_Parts_Options__c();
            part.recordtypeId = recTypeIdpart;
            part.Option_Number__c = null;
            part.Service_Job__c = WO.Id;
            part.selected_part__c = false;
            part.FailurepartId__c = Solcomp3.Id;
            part.Parts_Type__c ='Custom';
            part.Part_Name__c=null;
            part.Service_partnumber__c=null;
            part.Quantity__c=null;
            part.Covered__c=null;
            part.Service_partnumber__c=null;
            part.Fail_Code__c=null;
            
            //insert part;
            partlst.add(part);
            insert partlst;
            system.assert(wo1!=null);
            List<CSS_Solution_Component__c> SolCmps = [SELECT  Id,SysCodeAndCompCode__c,FailCode_Formula__c,Fail_Code_Editable__c,AccountCode__c,AccountCodeEdit__c ,CoveredPartsQty__c,Fail_Code__c, CSS_Account_Formula__c from CSS_Solution_Component__c where Service_Job__c =:wo1.Id]; 
            system.assert(SolCmps!=null);
            List<CSS_GSQPartsJobPlan.partWrapperClass> lstpart= new List<CSS_GSQPartsJobPlan.partWrapperClass>();
            CSS_GSQPartsJobPlan.partWrapperClass partWrap=new CSS_GSQPartsJobPlan.partWrapperClass(10,parts.id,null,null,null,null,null,null,null,null,null,null,null,null);
            //CSS_GSQPartsJobPlan.partWrapperClass partWrap=new CSS_GSQPartsJobPlan.partWrapperClass(10,parts.id,'10','4034289RX','partName','replacementReasson','notes','oem',true,'returnToFactory','60','failCode','accountCode',null);
            CSS_GSQPartsJobPlan.partWrapperClass partWrap2=new CSS_GSQPartsJobPlan.partWrapperClass(10,parts.id,'11','4034289RX','partName','replacementReasson','notes','oem',true,'returnToFactory','60','failCode','accountCode',null);  
            CSS_GSQPartsJobPlan.partWrapperClass partWrap3=new CSS_GSQPartsJobPlan.partWrapperClass(10,parts.id,'12','4034289RX','partName','replacementReasson','notes','oem',true,'returnToFactory','60','failCode','accountCode',null);  
            CSS_GSQPartsJobPlan.partWrapperClass partWrap4=new CSS_GSQPartsJobPlan.partWrapperClass(10,parts.id,'13','4034289RX','partName','replacementReasson','notes','oem',true,'returnToFactory','60','failCode','accountCode',null);  
            CSS_GSQPartsJobPlan.partWrapperClass partWrap5=new CSS_GSQPartsJobPlan.partWrapperClass(10,parts.id,'14','4034289RX','partName','replacementReasson','notes','oem',true,'returnToFactory','60','failCode','accountCode',null);  
            lstpart.add(partWrap);
            lstpart.add(partWrap2);
            lstpart.add(partWrap3);
            lstpart.add(partWrap4);
            lstpart.add(partWrap5);
            Set<String> errMsgLst=new Set<String>();
            test.startTest();
            CG_CL_CoverageLimitExceedValidation contr = new CG_CL_CoverageLimitExceedValidation();
            errMsgLst = contr.covLimitValidation(wo1.Id, null, partlst, null);
            errMsgLst = contr.covLimitValidationJob(wo1.Id, partlst);
            CSS_GSQPartsJobPlan gsq = new CSS_GSQPartsJobPlan();
            gsq.Ins_JobId =wo1.Id;
            system.debug('GetAccountCode starts');
            //gsq.getAccountCodeDropDown();
            system.debug('GetAccountCode ends');
            gsq.SelectedAccountCode='Test-AccountCode';
            gsq.SelectedFailCode='Batteries-QCGK';
            gsq.onChangeofAccountCode();
            GSQ.closePopup1();
            GSQ.listpartWrapper.clear();
            GSQ.onChangeofFailCode();
            system.assert(gsq.existPartList==null);
            
        }
        test.stopTest();
        
    }
    static testmethod void testmethod21()
    {
        test.startTest();
        System.runAs ( new User(Id = UserInfo.getUserId()) ) {
            Group Q = new Group();
            Q.Type = 'Queue';
            //Q.OwnerId=objUser1.id;
            Q.Name = 'JQ'+'-'+'57380-57380';
            insert Q;
            QueueSObject q1 = new QueueSObject(SobjectType='CSS_Job_Order__c', QueueId=Q.Id);
            insert q1;
            css_job_order__c wo = css_testdata.createJobOrder(false);
            wo.CSS_Job_Location_Code__c='57380-57380';
            wo.Customer_Name__c='Gopal';
            wo.Customer_Code__c='123';
            wo.ownerId = UserInfo.getUserId();
            insert wo;
            PageReference prefs;
            prefs = new PageReference('/'+wo.id);
            prefs.getParameters().put('id',wo.id);
            Test.setCurrentPage(prefs);
            CSS_GSQPartsJobPlan gsq = new CSS_GSQPartsJobPlan();
            //  gsq.Ins_JobId =wo.Id;
            // GSQ.listpartWrapper.clear();
            gsq.getallCustomPartsData(true);
            //gsq.saveCustomParts();
            gsq.closePopup2();
        }
        test.stopTest();
    }
    static testmethod void method1(){
        
        //Add test data for Service job order
        CSS_Job_Order__c JO = CSS_TestData.createJobOrder(true);
        CSS_Solutions__c sol1= CSS_TestData.createSolutions(true,JO.id);
        CSS_Solution_Component__c csc = CSS_TestData.createSRT(true,JO.id,sol1.id);
        Id recTypeIdpart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'Parts');
        
        CSS_Parts_Options__c parts = new CSS_Parts_Options__c();
        parts.recordtypeId = recTypeIdpart;
        parts.Option_Number__c = 'O-111';
        parts.Service_Job__c = JO.Id;
        parts.selected_part__c = true;
        parts.FailurepartId__c = csc.Id;
        parts.Parts_Type__c ='Custom';
        parts.Part_Name__c='test';
        parts.Service_partnumber__c='';
        parts.Quantity__c=1;
        
        insert parts;
        
        Test.startTest();
        CSS_GSQPartsJobPlan gsq = new CSS_GSQPartsJobPlan();
        gsq.Ins_JobId =JO.Id;
        
        gsq.assignedParts=0;
        gsq.getreplacementReasonOptions();
        gsq.getallCustomPartsData(false);
        //gsq.saveCustomParts();
        gsq.AddRow();
        gsq.removingRow();
        
        gsq.deleteParts();
        pageReference pref = gsq.closePopup2();
        Test.stopTest();
    }
    
    
    static testmethod void CSS_GSQPartsJobPlantest3(){
        
        //Add test data for Service job order
        // CSS_Job_Order__c JO = CSS_TestData.createJobOrder(true);
        CSS_GSQPartsJobPlan  gq = new CSS_GSQPartsJobPlan ();
        gq.SelectedFailCode='THAC';
        CSS_Job_Order__c SerRec =new CSS_Job_Order__c();
        SerRec.DSID__c='12345';
        //SerRec.OwnerId = tq.Id;
        SerRec.DSID_Status__c='open';
        SerRec.ESN__c ='79464646';
        SerRec.Customer_Name__c='ABC';
        //SerRec.Failure_Date__c =d;
        SerRec.Failure_Point__c=2.2;
        SerRec.Unit_Number__c='1234';
        SerRec.Service_Model__c='ESN';
        SerRec.Service_Model_N__c = 445566;
        SerRec.Make__c='test';
        SerRec.Model__c='test1';
        SerRec.VIN__c='1XKAD49X6CJ305490';
        SerRec.Customer_Name__c='ABC';
        //SerRec.Warranty_Start_Date__c=d;
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
        insert SerRec;
        PageReference prefs;
        prefs = new PageReference('/'+SerRec.id);
        prefs.getParameters().put('id',SerRec.id);
        Test.setCurrentPage(prefs);
        // CSS_Solutions__c sol1= CSS_TestData.createSolutions(true,JO.id);
        CSS_Solutions__c solAdd = new CSS_Solutions__c();
        solAdd.Service_Job__c = SerRec.id;
        solAdd.Case_Name__c = 'Additional SRTS';
        solAdd.Solution_Title__c='Additional SRTS';
        
        solAdd.Name='TestSRTS'+Math.random();
        solAdd.Diagnostic_Response__c ='Most likely the solution';
        solAdd.Diagnostic_notes__c = 'solutions diagnostic notes';
        solAdd.Repair_Notes__c = 'Repair Notes';
        //solAdd.FaultCode__c = 'solution faultcode';
        //solAdd.Repair_Response__c = 'Most likely ';
        solAdd.Repair_Response__c = 'Repair Successful.';
        solAdd.Rank__c = 3;
        insert solAdd;
        // CSS_Solution_Component__c csc = CSS_TestData.createSRT(true,SerRec.id,solAdd.id);
        list<CSS_Solution_Component__c> AddsolCompList = new list<CSS_Solution_Component__c>();
        CSS_Solution_Component__c AddsolComp = new CSS_Solution_Component__c();
        AddsolComp.Component_Id__c ='F0051000';
        AddsolComp.Service_Job__c = SerRec.Id;
        AddsolComp.Action__c = 'Repair';
        AddsolComp.Solutions__c = solAdd.id;
        AddsolComp.Quantity__c = 4;
        AddsolComp.type__c='Campaign';
        AddsolComp.Selected_Component__c = True;
        AddsolComp.AccountCode__c = 'Test-AccountCode';
        AddsolComp.AccountCodeEdit__c = 'Test-ACEdit';
        AddsolComp.CoveredPartsQty__c = '10';
        AddsolComp.AccountCodeType__c='ASAS';
        AddsolComp.Fail_Code_Editable__c='test';
        AddsolComp.System_Code__c='TH';
        AddsolComp.Component_Code__c='AC';
        AddsolComp.Charlength__c = true;
        AddsolComp.Name = 'Test'+Math.random();
        AddsolCompList.add(AddsolComp);
        
        CSS_Solution_Component__c AddsolComp1 = new CSS_Solution_Component__c();
        AddsolComp1.System_Code__c = 'Testing';
        AddsolComp1.Component_Code__c='gyhgkg';
        AddsolComp1.Component_Id__c ='F0051000';
        AddsolComp1.Service_Job__c = SerRec.Id;
        AddsolComp1.Action__c = 'Repair';
        AddsolComp1.Solutions__c = solAdd.id;
        AddsolComp1.Quantity__c = 4;
        AddsolComp1.type__c='Campaign';
        AddsolComp1.Selected_Component__c = True;
        AddsolComp1.AccountCode__c = 'Test-AccountCode';
        AddsolComp1.AccountCodeEdit__c = 'Test-ACEdit';
        AddsolComp1.CoveredPartsQty__c = '10';
        AddsolComp1.AccountCodeType__c='ASAS';
        AddsolComp1.Fail_Code_Editable__c=gq.SelectedFailCode;
        AddsolComp1.Charlength__c = true;
        // AddsolComp1.FailCode_Formula__c= gq.SelectedFailCode;
        AddsolComp1.Name = 'Test'+Math.random();
        AddsolCompList.add(AddsolComp1);
        insert AddsolCompList;
        //CSS_JobEventTemporary__c jobevent = CSS_TestData.createJobEventTempObj(true);
        CSS_JobEventTemporary__c jobevent = new CSS_JobEventTemporary__c();
        jobevent.File_Name__c='Test';
        jobevent.Circuit_Description__c='rrrr';
        jobevent.Comp_Location__c='dfgh';
        jobevent.Effect__c='klkl';
        jobevent.Engine__c='bfr';
        jobevent.Fault_Code_Description__c = 'intake';
        jobevent.File_Name__c = 'testing';
        jobevent.FMI__c = 'htyu';
        jobevent.Lamp__c = 'nhgt';
        jobevent.Reason__c = 'yyyy';
        jobevent.Service_Model_Name__c = 'fault';
        jobevent.SPN__c = 'bfgfhhj';
        jobevent.Attribute1__c= '2014-05-08T00:00:00.000-05:00'; //string.valueof(system.now());
        jobevent.Attribute2__c='test2';
        jobevent.Attribute3__c='test3';
        jobevent.Attribute4__c='1.0';
        jobevent.Attribute5__c='test5';
        jobevent.Attribute6__c='test6';
        jobevent.Attribute7__c='test7';
        jobevent.Attribute8__c='test9';
        jobevent.Attribute9__c='test10';
        jobevent.Attribute10__c='test11';
        jobevent.Attribute11__c='2014-05-08T00:00:00.000-05:00';
        jobevent.Attribute12__c='test13';
        date d =  Date.today();
        jobevent.Attribute13__c=d;
        jobevent.Attribute14__c='test15';
        jobevent.Attribute15__c='test8';
        jobevent.Reason__c='tEst';
        //jobevent.key__c='79464646'+':'+cl.id;
        jobevent.type__c='ClaimHistory';
        jobevent.Active__c=true;
        Id recTypeIdpart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'Parts');
        // list<CSS_Parts_Options__c> lstparts = new  list<CSS_Parts_Options__c>();
        CSS_Parts_Options__c parts = new CSS_Parts_Options__c();
        parts.recordtypeId = recTypeIdpart;
        parts.Option_Number__c = 'O-111';
        parts.Service_Job__c = SerRec.Id;
        parts.selected_part__c = true;
        parts.FailurepartId__c = AddsolComp.Id;
        parts.Service_partnumber__c = '';
        parts.Part_Name__c = 'aasf';
        parts.Notes__c = '';
        parts.OEM__c = '';
        parts.Parts_Type__c ='Custom';
        parts.Fail_Code__c = '';
        //parts.
        // parts.Part_Name__c='test';
        //parts.Quantity__c = 1;
        //parts.Replacement_Reason__c = '';
        //lstparts.add(parts);
        insert parts;
        
        Test.startTest();
        CSS_GSQPartsJobPlan  gsq = new CSS_GSQPartsJobPlan ();
        List<SelectOption> sel= gsq.getfailcodeDropDown();
        
        list<CSS_GSQPartsJobPlan.partWrapperClass> lstpart= new list<CSS_GSQPartsJobPlan.partWrapperClass>();
        CSS_GSQPartsJobPlan.partWrapperClass partWrap=new CSS_GSQPartsJobPlan.partWrapperClass(10,parts.id,'10','1234','368433800','replacementReasson','notes','oem',true,'returnToFactory','60','failCode','accountCode',sel);
        lstpart.add(partWrap);
        
        gsq.Ins_JobId =serRec.Id;
        gsq.assignedParts=0;
        //gsq.coverageType='CAMPIGN';
        gsq.SelectedFailCode='test';
        gsq.SelectedPartID=0;
        gsq.recTypeIdpart=parts.id;
        gsq.onChangeofFailCode();
        CG_OP_OAGWrapper opres = new CG_OP_OAGWrapper();
        opres = CSS_FN_SIEBEL.getpartsdata(lstpart[0].servPartNumber);
        system.debug('opres'+opres);
        gsq.getreplacementReasonOptions();
        gsq.getallCustomPartsData(false);
        
        // gsq.onChangeofFailCode();
        gsq.removeIdsMap.put(parts.Id, string.valueOf(parts.Id));
        gsq.isDealer = false;
        //pageReference pref1 = gsq.saveCustomParts();
        gsq.onChangeofFailCode();
        gsq.deleteParts();
        //gsq.CallGetPartDataService();
        gsq.AddRow();
        gsq.removingRow();
        gsq.closePopup2();
        Test.stopTest();
    }
    static testmethod void saveCustomPartsMethod(){
        
        //Insert Service job
        CSS_Job_Order__c SerRec =new CSS_Job_Order__c();
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
        insert SerRec;
        
        //Insert Solutions
        CSS_Solutions__c solAdd = new CSS_Solutions__c();
        solAdd.Service_Job__c = SerRec.id;
        solAdd.Case_Name__c = 'Additional SRTS';
        solAdd.Solution_Title__c='Additional SRTS';
        solAdd.Name='TestSRTS'+Math.random();
        solAdd.Diagnostic_Response__c ='Most likely the solution';
        solAdd.Diagnostic_notes__c = 'solutions diagnostic notes';
        solAdd.Repair_Notes__c = 'Repair Notes';
        solAdd.Repair_Response__c = 'Repair Successful.';
        solAdd.Rank__c = 3;
        insert solAdd;
        
        //Insert Solution Comp
        CSS_Solution_Component__c AddsolComp = new CSS_Solution_Component__c();
        AddsolComp.Component_Id__c ='F0051000';
        AddsolComp.System_Code__c='TH';
        AddsolComp.Component_Code__c='AC';
        AddsolComp.Service_Job__c = SerRec.Id;
        AddsolComp.Action__c = 'Repair';
        AddsolComp.Solutions__c = solAdd.id;
        AddsolComp.Quantity__c = 4;
        AddsolComp.type__c='Campaign';
        AddsolComp.Selected_Component__c = True;
        AddsolComp.AccountCode__c = 'Test-AccountCode';
        AddsolComp.AccountCodeEdit__c = 'Test-ACEdit';
        AddsolComp.CoveredPartsQty__c = '10';
        AddsolComp.AccountCodeType__c='ASAS';
        AddsolComp.Fail_Code_Editable__c='test';
        AddsolComp.Name = 'Test'+Math.random();
        insert AddsolComp;
        
        
        //Insert Part options
        List<CSS_Parts_Options__c> prtslst = new List<CSS_Parts_Options__c>();
        CSS_Parts_Options__c parts = new CSS_Parts_Options__c();
        parts.Option_Number__c = 'O-111';
        parts.Service_Job__c = SerRec.Id;
        parts.selected_part__c = true;
        parts.FailurepartId__c = AddsolComp.Id;
        parts.Part_Assignment__c = 'Primary';
        parts.Solutions__c=solAdd.Id;
        parts.Type__c='Commercial-Travel';
        parts.ExpenseTotal__c=100;
        prtslst.add(parts);
        
        CSS_Parts_Options__c prtobj = new CSS_Parts_Options__c();
        prtobj.Option_Number__c = 'O-111';
        prtobj.Service_Job__c = SerRec.Id;
        prtobj.selected_part__c = true;
        prtobj.FailurepartId__c = AddsolComp.Id;
        prtobj.Part_Assignment__c = 'Primary';
        prtobj.Solutions__c=solAdd.Id;
        prtobj.Type__c='Commercial-Travel';
        prtobj.ExpenseTotal__c=100;
        prtslst.add(prtobj);
        insert prtslst;
        
        
        
        Test.startTest();
        CSS_GSQPartsJobPlan prtsobj = new CSS_GSQPartsJobPlan();
        PageReference prefs;
        prefs = new PageReference('/'+SerRec.id);
        prefs.getParameters().put('id',SerRec.id);
        Test.setCurrentPage(prefs);
        
        List<SelectOption> sel= prtsobj.getfailcodeDropDown();
        
        List<CSS_GSQPartsJobPlan.partWrapperClass> prtslst1 = new List<CSS_GSQPartsJobPlan.partWrapperClass>();
        
        CSS_GSQPartsJobPlan.partWrapperClass wrpr1 = new CSS_GSQPartsJobPlan.partWrapperClass(null,parts.id,null,null,'test',null,null,null,null,null,null,null,null,sel);
        prtslst1.add(wrpr1);
       prtsobj.Ins_JobId=SerRec.id;
        prtsobj.listpartWrapper = prtslst1;
        prtsobj.saveCustomParts();
        Test.stopTest();
    }
    
    static testmethod void saveCustomPartsMethod1(){
        
        //Insert Service job
        CSS_Job_Order__c SerRec =new CSS_Job_Order__c();
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
        insert SerRec;
        
        //Insert Solutions
        CSS_Solutions__c solAdd = new CSS_Solutions__c();
        solAdd.Service_Job__c = SerRec.id;
        solAdd.Case_Name__c = 'Additional SRTS';
        solAdd.Solution_Title__c='Additional SRTS';
        solAdd.Name='TestSRTS'+Math.random();
        solAdd.Diagnostic_Response__c ='Most likely the solution';
        solAdd.Diagnostic_notes__c = 'solutions diagnostic notes';
        solAdd.Repair_Notes__c = 'Repair Notes';
        solAdd.Repair_Response__c = 'Repair Successful.';
        solAdd.Rank__c = 3;
        insert solAdd;
        
        //Insert Solution Comp
        CSS_Solution_Component__c AddsolComp = new CSS_Solution_Component__c();
        AddsolComp.Component_Id__c ='F0051000';
        AddsolComp.Service_Job__c = SerRec.Id;
        AddsolComp.Action__c = 'Repair';
        AddsolComp.Solutions__c = solAdd.id;
        AddsolComp.Quantity__c = 4;
        AddsolComp.type__c='Campaign';
        AddsolComp.Selected_Component__c = True;
        AddsolComp.AccountCode__c = 'Test-AccountCode';
        AddsolComp.AccountCodeEdit__c = 'Test-ACEdit';
        AddsolComp.CoveredPartsQty__c = '10';
        AddsolComp.AccountCodeType__c='ASAS';
        AddsolComp.Fail_Code_Editable__c='test';
        AddsolComp.System_Code__c='TH';
        AddsolComp.Component_Code__c='AC';
        AddsolComp.Name = 'Test'+Math.random();
        insert AddsolComp;
        
        
        //Insert Part options
        List<CSS_Parts_Options__c> prtslst = new List<CSS_Parts_Options__c>();
        CSS_Parts_Options__c parts = new CSS_Parts_Options__c();
        parts.Option_Number__c = 'O-111';
        parts.Service_Job__c = SerRec.Id;
        parts.selected_part__c = true;
        parts.FailurepartId__c = AddsolComp.Id;
        parts.Part_Assignment__c = 'Primary';
        parts.Solutions__c=solAdd.Id;
        parts.Type__c='Commercial-Travel';
        parts.ExpenseTotal__c=100;
        prtslst.add(parts);
        
        CSS_Parts_Options__c prtobj = new CSS_Parts_Options__c();
        prtobj.Option_Number__c = 'O-111';
        prtobj.Service_Job__c = SerRec.Id;
        prtobj.selected_part__c = true;
        prtobj.FailurepartId__c = AddsolComp.Id;
        prtobj.Part_Assignment__c = 'Primary';
        prtobj.Solutions__c=solAdd.Id;
        prtobj.Type__c='Commercial-Travel';
        prtobj.ExpenseTotal__c=100;
        prtslst.add(prtobj);
        insert prtslst;
        
        
        
        Test.startTest();
        CSS_GSQPartsJobPlan prtsobj = new CSS_GSQPartsJobPlan();
        PageReference prefs;
        prefs = new PageReference('/'+SerRec.id);
        prefs.getParameters().put('id',SerRec.id);
        Test.setCurrentPage(prefs);
        
        List<SelectOption> sel= prtsobj.getfailcodeDropDown();
        
        List<CSS_GSQPartsJobPlan.partWrapperClass> prtslst1 = new List<CSS_GSQPartsJobPlan.partWrapperClass>();
        for(integer i=0;i<=100;i++){
            CSS_GSQPartsJobPlan.partWrapperClass wrpr = new CSS_GSQPartsJobPlan.partWrapperClass(0,parts.id,'','','','replacementReasson','','',true,'returnToFactory','','','accountCode',sel);
            prtslst1.add(wrpr);
        }    
        
        prtsobj.listpartWrapper = prtslst1;
        prtsobj.saveCustomParts();
        Test.stopTest();
    }
    
    static testmethod void fetchAccountCodeDropDownMethod(){
        Test.startTest();
        CSS_GSQPartsJobPlan gsq = new CSS_GSQPartsJobPlan ();
        gsq.selectedFailCode='Te-St';
        gsq.fetchAccountCodeDropDown('Te-st');
        Test.stopTest();
    }
    static testmethod void testmethod101()
    {
        System.runAs ( new User(Id = UserInfo.getUserId()) ) {
            Group Q = new Group();
            Q.Type = 'Queue';
			Q.Name = 'JQ'+'-'+'57380-57380';
            insert Q;
            QueueSObject q1 = new QueueSObject(SobjectType='CSS_Job_Order__c', QueueId=Q.Id);
            insert q1;
            css_job_order__c wo = css_testdata.createJobOrder(false);
            wo.CSS_Job_Location_Code__c='57380-57380';
            wo.Customer_Name__c='Gopal';
            wo.Customer_Code__c='123';
            wo.ownerId = UserInfo.getUserId();
            insert wo;
          
            css_job_order__c wo1=[Select Id,Name,AccessCode__c,BMSWSStatus__c,BMSStatus__c,Customer_Name__c,Shop_Work_Order__c, Application__c, Unit_Number__c, Unit_Type__c, Date_in__c, INSITE_UpdateTimeStamp__c, First_Name__c,
                                  Service_Model__c, VIN__c, Customer_Code__c,Status__c, Model__c,Creator_Location__c,ESN__c 
                                  from CSS_Job_Order__c where id=:wo.id];
            CSS_Solutions__c sol=css_testdata.createSolutions(false, wo1.id);
            insert sol;
            CSS_Solution_Component__c Solcomp3 = css_testdata.createSRT(false, wo1.Id, sol.Id);
            Solcomp3.AccountCodeEdit__c='Test-AccountCode';
            solcomp3.Fail_Code_Editable__c='Batteries-QCGK';
            solcomp3.System_Code__c='TH';
            solcomp3.Component_Code__c='AC';
           solcomp3.Name='Test';
            insert Solcomp3;
            CSS_Solution_Component__c Solcomp4 = css_testdata.createSRT(false, wo1.Id, sol.Id);
            Solcomp4.AccountCodeEdit__c='Test-AccountCode';
           // solcomp4.Fail_Code__c ='';
            solcomp4.Fail_Code_Editable__c='Batteries-QCGK';
            solcomp4.AccountCode__c = 'Test-AccountCode';
            solcomp4.Component_Id__c='F0051001';
            solcomp4.System_Code__c='TH';
            solcomp4.Component_Code__c='AC';
            solcomp4.Name='Test';
            insert Solcomp4;
            List<CSS_Solution_Component__c> so =[select id, FailCode_Formula__c, CSS_Account_Formula__c from CSS_Solution_Component__c];
           system.debug('soOne '+so);
            Id recTypeIdpart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'Parts');
            list<CSS_Parts_Options__c> partlst = new list<CSS_Parts_Options__c>();
            CSS_Parts_Options__c parts = new CSS_Parts_Options__c();
            parts.recordtypeId = recTypeIdpart;
            parts.Option_Number__c = null;
            parts.Service_Job__c = WO.Id;
            parts.selected_part__c = false;
            parts.FailurepartId__c = Solcomp3.Id;
            parts.Parts_Type__c ='Custom';
            parts.Part_Name__c=null;
            parts.Service_partnumber__c=null;
            parts.Quantity__c=null;
            parts.Covered__c=null;
            parts.Service_partnumber__c=null;
            parts.Fail_Code__c=null;
            
            //insert parts;
            partlst.add(parts);
            CSS_Parts_Options__c part = new CSS_Parts_Options__c();
            part.recordtypeId = recTypeIdpart;
            part.Option_Number__c = null;
            part.Service_Job__c = WO.Id;
            part.selected_part__c = false;
            part.FailurepartId__c = Solcomp3.Id;
            part.Parts_Type__c ='Custom';
            part.Part_Name__c=null;
            part.Service_partnumber__c=null;
            part.Quantity__c=null;
            part.Covered__c=null;
            part.Service_partnumber__c=null;
            part.Fail_Code__c=null;
            
            //insert part;
            partlst.add(part);
            insert partlst;
            system.assert(wo1!=null);
            List<CSS_Solution_Component__c> SolCmps = [SELECT  Id,SysCodeAndCompCode__c,FailCode_Formula__c,Fail_Code_Editable__c,AccountCode__c,AccountCodeEdit__c ,CoveredPartsQty__c,Fail_Code__c, CSS_Account_Formula__c from CSS_Solution_Component__c where Service_Job__c =:wo1.Id]; 
            system.assert(SolCmps!=null);
            List<CSS_GSQPartsJobPlan.partWrapperClass> lstpart= new List<CSS_GSQPartsJobPlan.partWrapperClass>();
            CSS_GSQPartsJobPlan.partWrapperClass partWrap=new CSS_GSQPartsJobPlan.partWrapperClass(10,parts.id,null,null,null,null,null,null,null,null,null,null,null,null);
            //CSS_GSQPartsJobPlan.partWrapperClass partWrap=new CSS_GSQPartsJobPlan.partWrapperClass(10,parts.id,'10','4034289RX','partName','replacementReasson','notes','oem',true,'returnToFactory','60','failCode','accountCode',null);
            CSS_GSQPartsJobPlan.partWrapperClass partWrap2=new CSS_GSQPartsJobPlan.partWrapperClass(10,parts.id,'11','4034289RX','partName','replacementReasson','notes','oem',true,'returnToFactory','60','failCode','accountCode',null);  
            CSS_GSQPartsJobPlan.partWrapperClass partWrap3=new CSS_GSQPartsJobPlan.partWrapperClass(10,parts.id,'12','4034289RX','partName','replacementReasson','notes','oem',true,'returnToFactory','60','failCode','accountCode',null);  
            CSS_GSQPartsJobPlan.partWrapperClass partWrap4=new CSS_GSQPartsJobPlan.partWrapperClass(10,parts.id,'13','4034289RX','partName','replacementReasson','notes','oem',true,'returnToFactory','60','failCode','accountCode',null);  
            CSS_GSQPartsJobPlan.partWrapperClass partWrap5=new CSS_GSQPartsJobPlan.partWrapperClass(10,parts.id,'14','4034289RX','partName','replacementReasson','notes','oem',true,'returnToFactory','60','failCode','accountCode',null);  
            lstpart.add(partWrap);
            lstpart.add(partWrap2);
            lstpart.add(partWrap3);
            lstpart.add(partWrap4);
            lstpart.add(partWrap5);
            Set<String> errMsgLst=new Set<String>();
            test.startTest();
            CG_CL_CoverageLimitExceedValidation contr = new CG_CL_CoverageLimitExceedValidation();
            errMsgLst = contr.covLimitValidation(wo1.Id, null, partlst, null);
            errMsgLst = contr.covLimitValidationJob(wo1.Id, partlst);
              PageReference prefs;
            prefs = new PageReference('/'+wo1.id);
            prefs.getParameters().put('id',wo1.id);
            Test.setCurrentPage(prefs);
            CSS_GSQPartsJobPlan gsq = new CSS_GSQPartsJobPlan();
            GSQ.listpartWrapper=lstpart;
            gsq.SelectedPartID=10;
            gsq.Ins_JobId =wo1.Id;
            system.debug('GetAccountCode starts');
            //gsq.getAccountCodeDropDown();
            system.debug('GetAccountCode ends');
            gsq.SelectedAccountCode='Test-AccountCode';
            gsq.SelectedFailCode='Test-THAC';
            gsq.onChangeofAccountCode();
            GSQ.closePopup1();
             GSQ.listpartWrapper=lstpart;
            gsq.SelectedPartID=10;
            GSQ.onChangeofFailCode();
            system.assert(gsq.existPartList==null);
            
        }
        test.stopTest();
        
    }
    static testMethod void onChangeofPartNumberMethod(){
        CSS_Job_Order__c SerRec =new CSS_Job_Order__c();
        SerRec.DSID__c='12345';
        //SerRec.OwnerId = tq.Id;
        SerRec.DSID_Status__c='open';
        SerRec.ESN__c ='79464646';
        SerRec.Customer_Name__c='ABC';
        //SerRec.Failure_Date__c =d;
        SerRec.Failure_Point__c=2.2;
        SerRec.Unit_Number__c='1234';
        SerRec.Service_Model__c='ESN';
        SerRec.Service_Model_N__c = 445566;
        SerRec.Make__c='test';
        SerRec.Model__c='test1';
        SerRec.VIN__c='1XKAD49X6CJ305490';
        SerRec.Customer_Name__c='ABC';
        //SerRec.Warranty_Start_Date__c=d;
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
        insert SerRec;
        id wid = apexpages.currentpage().getparameters().put('id' , SerRec.id);
        list<CSS_Solution_Component__c> lstSolComp = new list<CSS_Solution_Component__c>();
        CSS_Solution_Component__c obj = new CSS_Solution_Component__c();
        obj.Service_Job__c = wid;
        obj.System_Code__c  = 'Data';
        obj.Component_Code__c = 'Testing';
        obj.Fail_Code_Editable__c='Test';
        obj.Selected_Component__c = true;
        insert obj;
        CSS_Solution_Component__c obj1 = new CSS_Solution_Component__c();
        obj1.Service_Job__c = wid;
        obj.System_Code__c  = 'Data';
        obj.Component_Code__c = 'Testing';
        obj1.Fail_Code_Editable__c='Test';
        obj1.Selected_Component__c = true;
        insert obj1;
        lstSolComp.add(obj);
        lstSolComp.add(obj1);
        Test.startTest();
        CSS_GSQPartsJobPlan gsq = new CSS_GSQPartsJobPlan();
        gsq.onChangeofPartNumber(57380);
        Test.stopTest();
    }
}