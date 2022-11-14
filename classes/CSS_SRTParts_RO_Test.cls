@isTest
public class CSS_SRTParts_RO_Test {
    
    
    
     static testMethod void testmethod2()
    {    
        list<CSS_Parts_Options__c> customPartlstUIList = new List<CSS_Parts_Options__c>();
        list<CSS_Parts_Options__c> existPartList = new List<CSS_Parts_Options__c>();
        
        Id recTypeIdpart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'Parts');
        Id recTypeIdoption = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'Options');
       boolean displaypopup2 = false;

       // Id recTypeIdoption = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'Options');
       // Id recTypeIdpart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'Parts');
         string userRole ='Factory'; 
        
        //Insert a service job
CSS_Job_Order__c servicejob= new CSS_Job_Order__c();
        servicejob.Status__c = 'Intake';
        servicejob.INSITE_UpdateTimeStamp__c =system.today();
        servicejob.INSITE_ESN_Choice__c='Not Selected';
        servicejob.Qsol_Engine_Family_Code__c = 'code';
        servicejob.Warranty_Start_Date__c = date.today();
        servicejob.CSS_Job_Location_Code__c = 'location';
        servicejob.ApplicationCode__c = 'code';
        servicejob.DSID__c='2323';
        servicejob.ESN__c ='21323';
        servicejob.Application__c='asdd';
        servicejob.Unit_Number__c='213';
        servicejob.Failure_Point__c=213.00;
        servicejob.Failure_Point_Measure__c='asd';
        servicejob.Make__c='Make';
        servicejob.ESN_Insite__c = 'insite';
        servicejob.Model__c='Model';
        servicejob.Equipment_ID__c='Equip';
        servicejob.Customer_Name__c='Peterbuilt';
        servicejob.Shop_Work_Order__c='213dssd';
        servicejob.Service_Model__c='SMNNUM';
        servicejob.DSID_Creation_Timestamp__c=system.today();
        servicejob.DSID_Status__c='Stat';
        servicejob.DSID_WorkGroup__c='Wrkgrp';
        servicejob.Status__c = 'Triage & Diagnosis Complete' ;
        servicejob.Previous_Status__c = 'Triage & Diagnosis' ;
        servicejob.Failure_Date__c = date.today();
        insert servicejob;        
        
        //Inserting Fault Code
CSS_Fault_Code__c faulCodeRec = new CSS_Fault_Code__c(Name='3478',Related_Fault_Code__c='98734,95869',isPole__c = true);
        insert faulCodeRec;
        
        //Inserting Symptom
        CSS_SymptomQA__c sym=new CSS_SymptomQA__c();
        sym.Job_Order__c=servicejob.id;
        sym.caption__c ='white smoke';
        sym.Option1__c  ='12213';
        sym.Option_type__c  ='qwewqe';
        sym.Guide_Question__c  ='Do you see smoke';
        sym.Type__c  ='SearchString';
        insert sym; 
        
        //Inserting SymQA
        CSS_SymptomQA__c symQA=new CSS_SymptomQA__c();
        sym.Job_Order__c=servicejob.id;
        sym.caption__c ='fault Code';
        sym.Option1__c  ='12213';
        sym.Job_Order__c  =servicejob.id;
        sym.SearchString__c  =sym.id;        
        sym.Type__c  ='QA';
        insert symQA;

        //Insert a Solution
        CSS_Solutions__c sol=new CSS_Solutions__c();
        sol.Case_Name__c='test';
        sol.Name='test';
        sol.FaultCode__c = faulCodeRec.id;
        sol.Diagnostic_Response__c='Most likely the solution';
        sol.Repair_Response__c='test';
        sol.Symptom__c=sym.id;
        sol.Service_Job__c=servicejob.id;
        sol.CSS_Nested_Solutions__c = sol.id;
        sol.rank__c=0;
        sol.Out_Of_Order__c = false;
        sol.Solution_Title__c = 'test';
        sol.Solution__c ='test';
        sol.Report_Comments__c ='qwewqewqewewqe';
        sol.Diagnostic_notes__c ='asdsadad';
        insert sol;
System.debug('The Test data for solution is:'+sol);

       // CSS_Solution_Component__c solComRef = new CSS_Solution_Component__c();//CSS_TestData.createSRT(true,servicejob.Id,sol.Id);
         List<CSS_Solution_Component__c> solComplist = new list<CSS_Solution_Component__c>();
        CSS_Solution_Component__c AddsolComp = new CSS_Solution_Component__c();
        AddsolComp.Component_Id__c ='F0051000';
        AddsolComp.Service_Job__c = servicejob.id;
        AddsolComp.Action__c = 'Repair';
        AddsolComp.Solutions__c = sol.id;
        AddsolComp.Quantity__c = 4;
        AddsolComp.type__c='CAMPAIGN';
        AddsolComp.CoveredLaborHrs__c='10';
        //AddsolComp.
        AddsolComp.Selected_Component__c = True;
        AddsolComp.AccountCode__c = 'test';
        AddsolComp.AccountCodeEdit__c = 'test';
        AddsolComp.CoveredPartsQty__c = '10';
        AddsolComp.AccountCodeType__c='test';
        AddsolComp.Fail_Code_Editable__c='test1';
        AddsolComp.CampaignPartsPercentage__c='10';
        //AddsolComp.Fail_Code__c='CAM';
        //AddsolComp.FailCode_Formula__c='test';
        addsolcomp.Solutions__c = sol.Id;
        AddsolComp.Charlength__c = true;
        AddsolComp.Component_Code__c='NE';
        AddsolComp.System_Code__c='WY';
        AddsolComp.Failure_Mode__c='E1';
        insert AddsolComp;
        solComplist.add(AddsolComp);
       Map<String, List<SelectOption>> failAccountCodeMap = new  Map<String, List<SelectOption>>();
        
        list<CSS_Parts_Options__c> lstpo =new list<CSS_Parts_Options__c>();

        CSS_Parts_Options__c po = new CSS_Parts_Options__c();
        //po.recordtypeId = recTypeIdpart;
        po.Option_Number__c = 'O-111';
        po.Option_ESN__c = 'esnnnstring';
        po.selected_part__c = true;
        po.FailureName__c = 'fname';
        po.Assignment__c = 'Replaced';
        po.Notes__c = 'partsoptionnotes';
        po.OEM__c = 'oem';
        po.Part_Description__c = 'descrtttt';
        po.Part_Name__c = 'nameee';
        po.part_size__c = '8';
        po.Quantity__c = 5;
        po.Service_partnumber__c = 'number';
        po.Replacement_Reason__c = 'Campaign-TRP-ATC';
        po.Service_Job__c = servicejob.id;
        po.FailurepartId__c = AddsolComp.Id;
        po.Part_Assignment__c = 'Primary';
        po.Solutions__c=sol.id;
        insert po;
        System.debug('The Test data for part options is:'+po);
        lstpo.add(po);
        //insert lstpo;
        
        //Creating a SRT Part Wrapper
        List<SelectOption> accCodes1 = new List<SelectOption>();
        accCodes1.add(new SelectOption('01', 'Jan'));
        accCodes1.add(new SelectOption('02', 'CAM-campaign'));
        CSS_SRTParts_RO.srtPartWrapper cspwrap = new CSS_SRTParts_RO.srtPartWrapper(10,po.id,AddsolComp.id,true,true,'Test','Test','Test','Test','Test','Test','Test',5,'Test','Test','Test','Test',accCodes1,'Test');
        
        system.debug('**********************************srtPartWrapper**********************************'+cspwrap); 
        
        list< CSS_SRTParts_RO.srtPartWrapper> srtpwrplist=new list <CSS_SRTParts_RO.srtPartWrapper>();
        srtpwrplist.add(cspwrap);
        
        CSS_SRTParts_RO.srtCompWrapper cscmpwrap=new CSS_SRTParts_RO.srtCompWrapper(sol.id,'Test','Test','Test','Test','Test','Test','Test',srtpwrplist,1);
        list< CSS_SRTParts_RO.srtCompWrapper> srtcmplist=new list <CSS_SRTParts_RO.srtCompWrapper>();
        srtcmplist.add(cscmpwrap);
        CSS_SRTParts_RO.srtsolWrapper srtsol= new CSS_SRTParts_RO.srtsolWrapper(sol.id,'solName','solTitle',srtcmplist,10,10, po.id,'ParentSolName');
        list< CSS_SRTParts_RO.srtsolWrapper> srtsollist=new list <CSS_SRTParts_RO.srtsolWrapper>();
        srtsollist.add(srtsol);
        existPartList.add(po);
        UserRole empRole = [Select Id From UserRole Where Name = 'Factory' Limit 1];
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User objUser1 = new User(Alias = 'cmi-u1', Email='css-cmi1@cummins.com',
                                 EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                 LocaleSidKey='en_US', ProfileId = p.Id,UserRoleId = empRole.id,isActive=true, 
                                 TimeZoneSidKey='America/Los_Angeles', UserName='css-cmi1@cummins.com', User_Location__c='123456');
        //insert existPartList;
        system.debug('existPartListis'+existPartList);
        list<CSS_JobEventTemporary__c> lstjobevTemRef = new list<CSS_JobEventTemporary__c>();
        CSS_JobEventTemporary__c jobevTemRef = new CSS_JobEventTemporary__c();
        jobevTemRef.Type__c='testData';
        jobevTemRef.File_Name__c='TestData';
        jobevTemRef.Key__c='AccountCodes';
        jobevTemRef.Attribute1__c='OTH';
        jobevTemRef.Attribute2__c='OTH2';
        jobevTemRef.Attribute3__c='OTH3';
        jobevTemRef.Attribute5__c='OTH5';
        insert jobevTemRef;
        lstjobevTemRef.add(jobevTemRef);
        
        CSS_JobEventTemporary__c jobevTemRef1 = new CSS_JobEventTemporary__c();
        jobevTemRef1.Type__c='testData';
        jobevTemRef1.File_Name__c='TestData';
        jobevTemRef1.Key__c='AccountCodes';
        jobevTemRef1.Attribute1__c='POL';
        jobevTemRef1.Attribute2__c='POL2';
        jobevTemRef1.Attribute3__c='POL3';
        jobevTemRef1.Attribute5__c='POL5';
        insert jobevTemRef1;
        lstjobevTemRef.add(jobevTemRef1);
        
        customPartlstUIList = existPartList.clone();
        customPartlstUIList[0].Selected_part__c= false;
        
        system.debug('customPartlstUIList'+customPartlstUIList);
        
        PageReference pageRef = new PageReference('/apex/JobPlan?id=');
        test.setCurrentPage(pageRef);        
        pageRef.getParameters().put('id',servicejob.id);
        User u = css_utility.getUserAttributes(userinfo.getUserId()); 
        string lang = u.LanguageLocaleKey;
       
        CSS_SRTParts_RO srtParts1 =new CSS_SRTParts_RO();
        
        List<SelectOption> accCodes = new List<SelectOption>();
        accCodes.add(new SelectOption('01', 'test1'));
        accCodes.add(new SelectOption('02', 'Feb'));
        string s1='abc';
        string s2='abc1';
        List<string> lstAccountCodes=new List<string>();
        lstAccountCodes.add(s1);
         lstAccountCodes.add(s2);
        
         Map<String, List<SelectOption>> failAccountCodeMap1=new  Map<String, List<SelectOption>>();
        failAccountCodeMap1.put('01',accCodes);
        srtParts1.srtpartsErrorMsg = 'Bad request';
        srtParts1.accCodes = accCodes;
         //srtParts1.coverageType='OTH';
        srtParts1.selectedPartRowCount=10;
        srtParts1.SelectedAccountCode='test';
        srtParts1.SelectedFailCode='test1';
       // srtParts1.CoveredParAC=100;
        //CSS_SRTParts_RO.failAccountCodeMap=failAccountCodeMap1;
        //srtParts1.accountCodelistN('ReCon Policy','9','wer');
        Test.startTest();
        srtParts1.saveParts();
      //srtParts1.getAccountCodes();
        srtParts1.displayPopup2 = true;
        srtParts1.getreplacementReasonOptions();
        //srtParts1.onChangeofAccountCode();    
        Test.stopTest();
        css_repair_job repJob = new css_repair_job();
        CSS_SRTParts_RO controller = new CSS_SRTParts_RO(repJob);
        //List<SelectOption> stOption= controller.getAccountCodeDropDown();
       
    }
    public static testMethod void testmethod3()
    {
        list<CSS_Parts_Options__c> customPartlstUIList = new List<CSS_Parts_Options__c>();
        list<CSS_Parts_Options__c> existPartList = new List<CSS_Parts_Options__c>();
        
        Id recTypeIdpart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'Parts');
        Id recTypeIdoption = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'Options');
       boolean displaypopup2 = false;

       // Id recTypeIdoption = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'Options');
       // Id recTypeIdpart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'Parts');
         string userRole ='Factory'; 
        
        //Insert a service job
        CSS_Job_Order__c servicejob= new CSS_Job_Order__c();
        servicejob.Status__c = 'Intake';
        servicejob.INSITE_UpdateTimeStamp__c =system.today();
        servicejob.INSITE_ESN_Choice__c='Not Selected';
        servicejob.Qsol_Engine_Family_Code__c = 'code';
        servicejob.Warranty_Start_Date__c = date.today();
        servicejob.CSS_Job_Location_Code__c = 'location';
        servicejob.ApplicationCode__c = 'code';
        servicejob.DSID__c='2323';
        servicejob.ESN__c ='21323';
        servicejob.Application__c='asdd';
        servicejob.Unit_Number__c='213';
        servicejob.Failure_Point__c=213.00;
        servicejob.Failure_Point_Measure__c='asd';
        servicejob.Make__c='Make';
        servicejob.ESN_Insite__c = 'insite';
        servicejob.Model__c='Model';
        servicejob.Equipment_ID__c='Equip';
        servicejob.Customer_Name__c='Peterbuilt';
        servicejob.Shop_Work_Order__c='213dssd';
        servicejob.Service_Model__c='SMNNUM';
        servicejob.DSID_Creation_Timestamp__c=system.today();
        servicejob.DSID_Status__c='Stat';
        servicejob.DSID_WorkGroup__c='Wrkgrp';
        servicejob.Status__c = 'Triage & Diagnosis Complete' ;
        servicejob.Previous_Status__c = 'Triage & Diagnosis' ;
        servicejob.Failure_Date__c = date.today();
        insert servicejob;        
        
        //Inserting Fault Code
CSS_Fault_Code__c faulCodeRec = new CSS_Fault_Code__c(Name='3478',Related_Fault_Code__c='98734,95869',isPole__c = true);
        insert faulCodeRec;
        
        //Inserting Symptom
        CSS_SymptomQA__c sym=new CSS_SymptomQA__c();
        sym.Job_Order__c=servicejob.id;
        sym.caption__c ='white smoke';
        sym.Option1__c  ='12213';
        sym.Option_type__c  ='qwewqe';
        sym.Guide_Question__c  ='Do you see smoke';
        sym.Type__c  ='SearchString';
        insert sym; 
        
        //Inserting SymQA
        CSS_SymptomQA__c symQA=new CSS_SymptomQA__c();
        sym.Job_Order__c=servicejob.id;
        sym.caption__c ='fault Code';
        sym.Option1__c  ='12213';
        sym.Job_Order__c  =servicejob.id;
        sym.SearchString__c  =sym.id;        
        sym.Type__c  ='QA';
        insert symQA;

        //Insert a Solution
        CSS_Solutions__c sol=new CSS_Solutions__c();
        sol.Case_Name__c='test';
        sol.Name='test';
        sol.FaultCode__c = faulCodeRec.id;
        sol.Diagnostic_Response__c='Most likely the solution';
        sol.Repair_Response__c='test';
        sol.Symptom__c=sym.id;
        sol.Service_Job__c=servicejob.id;
        sol.CSS_Nested_Solutions__c = sol.id;
        sol.rank__c=0;
        sol.Out_Of_Order__c = false;
        sol.Solution_Title__c = 'test';
        sol.Solution__c ='test';
        sol.Report_Comments__c ='qwewqewqewewqe';
        sol.Diagnostic_notes__c ='asdsadad';
        insert sol;
System.debug('The Test data for solution is:'+sol);

       // CSS_Solution_Component__c solComRef = new CSS_Solution_Component__c();//CSS_TestData.createSRT(true,servicejob.Id,sol.Id);
         List<CSS_Solution_Component__c> solComplist = new list<CSS_Solution_Component__c>();
        CSS_Solution_Component__c AddsolComp = new CSS_Solution_Component__c();
        AddsolComp.Component_Id__c ='F0051000';
        AddsolComp.Service_Job__c = servicejob.id;
        AddsolComp.Action__c = 'Repair';
        AddsolComp.Solutions__c = sol.id;
        AddsolComp.Quantity__c = 4;
        AddsolComp.type__c='CAMPAIGN';
        AddsolComp.CoveredLaborHrs__c='10';
        //AddsolComp.
        AddsolComp.Selected_Component__c = True;
        AddsolComp.AccountCode__c = 'test'; //Anvesh umcommented 
        AddsolComp.AccountCodeEdit__c = 'test'; //Anvesh umcommented
        AddsolComp.CoveredPartsQty__c = '10';
        AddsolComp.AccountCodeType__c='test';
        AddsolComp.Fail_Code_Editable__c='test1';
        AddsolComp.CampaignPartsPercentage__c='10';
        //AddsolComp.Fail_Code__c='CAM'; 
       // AddsolComp.FailCode_Formula__c='test';
       addsolcomp.Solutions__c = sol.Id;
        AddsolComp.Charlength__c = true;
        AddsolComp.Component_Code__c='WH'; //NE
        AddsolComp.System_Code__c='EX';  //WY
        AddsolComp.Failure_Mode__c='E1';
        insert AddsolComp;
        solComplist.add(AddsolComp);
       Map<String, List<SelectOption>> failAccountCodeMap = new  Map<String, List<SelectOption>>();
        
        list<CSS_Parts_Options__c> lstpo =new list<CSS_Parts_Options__c>();

        CSS_Parts_Options__c po = new CSS_Parts_Options__c();
        //po.recordtypeId = recTypeIdpart;
        po.Option_Number__c = 'O-111';
        po.Option_ESN__c = 'esnnnstring';
        po.selected_part__c = true;
        po.FailureName__c = 'fname';
        po.Assignment__c = 'Replaced';
        po.Notes__c = 'partsoptionnotes';
        po.OEM__c = 'oem';
        po.Part_Description__c = 'descrtttt';
        po.Part_Name__c = 'nameee';
        po.part_size__c = '8';
        po.Quantity__c = 5;
        po.Service_partnumber__c = 'number';
        po.Replacement_Reason__c = 'Campaign-TRP-ATC';
        po.Service_Job__c = servicejob.id;
        po.FailurepartId__c = AddsolComp.Id;
        po.Part_Assignment__c = 'Primary';
        po.Solutions__c=sol.id;
        insert po;
        System.debug('The Test data for part options is:'+po);
        lstpo.add(po);
        //insert lstpo;
        
        //Creating a SRT Part Wrapper
        List<SelectOption> accCodes1 = new List<SelectOption>();
        accCodes1.add(new SelectOption('01', 'Jan'));
        accCodes1.add(new SelectOption('02', 'CAM-campaign'));
        CSS_SRTParts_RO.srtPartWrapper cspwrap = new CSS_SRTParts_RO.srtPartWrapper(10,po.id,AddsolComp.id,true,true,'Test','Test','Test','Test','Test','Test','Test',5,'Test','Test','Test','Test',accCodes1,'Test');
        
        system.debug('**********************************srtPartWrapper**********************************'+cspwrap); 
        
        list< CSS_SRTParts_RO.srtPartWrapper> srtpwrplist=new list <CSS_SRTParts_RO.srtPartWrapper>();
        srtpwrplist.add(cspwrap);
        
        CSS_SRTParts_RO.srtCompWrapper cscmpwrap=new CSS_SRTParts_RO.srtCompWrapper(sol.id,'Test','Test','Test','Test','Test','Test','Test',srtpwrplist,1);
        list< CSS_SRTParts_RO.srtCompWrapper> srtcmplist=new list <CSS_SRTParts_RO.srtCompWrapper>();
        srtcmplist.add(cscmpwrap);
        CSS_SRTParts_RO.srtsolWrapper srtsol= new CSS_SRTParts_RO.srtsolWrapper(sol.id,'solName','solTitle',srtcmplist,10,10, po.id,'ParentSolName');
        list< CSS_SRTParts_RO.srtsolWrapper> srtsollist=new list <CSS_SRTParts_RO.srtsolWrapper>();
        srtsollist.add(srtsol);
        existPartList.add(po);
        UserRole empRole = [Select Id From UserRole Where Name = 'Factory' Limit 1];
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User objUser1 = new User(Alias = 'cmi-u1', Email='css-cmi1@cummins.com',
                                 EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                 LocaleSidKey='en_US', ProfileId = p.Id,UserRoleId = empRole.id,isActive=true, 
                                 TimeZoneSidKey='America/Los_Angeles', UserName='css-cmi1@cummins.com', User_Location__c='123456');
        //insert existPartList;
        system.debug('existPartListis'+existPartList);
        list<CSS_JobEventTemporary__c> lstjobevTemRef = new list<CSS_JobEventTemporary__c>();
        CSS_JobEventTemporary__c jobevTemRef = new CSS_JobEventTemporary__c();
        jobevTemRef.Type__c='testData';
        jobevTemRef.File_Name__c='TestData';
        jobevTemRef.Key__c='AccountCodes';
        jobevTemRef.Attribute1__c='OTH';
        jobevTemRef.Attribute2__c='OTH2';
        jobevTemRef.Attribute3__c='OTH3';
        jobevTemRef.Attribute5__c='OTH5';
        insert jobevTemRef;
        lstjobevTemRef.add(jobevTemRef);
        
        CSS_JobEventTemporary__c jobevTemRef1 = new CSS_JobEventTemporary__c();
        jobevTemRef1.Type__c='testData';
        jobevTemRef1.File_Name__c='TestData';
        jobevTemRef1.Key__c='AccountCodes';
        jobevTemRef1.Attribute1__c='POL';
        jobevTemRef1.Attribute2__c='POL2';
        jobevTemRef1.Attribute3__c='POL3';
        jobevTemRef1.Attribute5__c='POL5';
        insert jobevTemRef1;
        lstjobevTemRef.add(jobevTemRef1);
        
        customPartlstUIList = existPartList.clone();
        customPartlstUIList[0].Selected_part__c= false;
        
        system.debug('customPartlstUIList'+customPartlstUIList);
        
        PageReference pageRef = new PageReference('/apex/JobPlan?id=');
        test.setCurrentPage(pageRef);        
        pageRef.getParameters().put('id',servicejob.id);
        User u = css_utility.getUserAttributes(userinfo.getUserId()); 
        string lang = u.LanguageLocaleKey;
       
        CSS_SRTParts_RO srtParts1 =new CSS_SRTParts_RO();
        
        List<SelectOption> accCodes = new List<SelectOption>();
        accCodes.add(new SelectOption('01', 'test1'));
        accCodes.add(new SelectOption('02', 'Feb'));
        string s1='abc';
        string s2='abc1';
        List<string> lstAccountCodes=new List<string>();
        lstAccountCodes.add(s1);
         lstAccountCodes.add(s2);
        
         Map<String, List<SelectOption>> failAccountCodeMap1=new  Map<String, List<SelectOption>>();
        failAccountCodeMap1.put('01',accCodes);
        srtParts1.srtpartsErrorMsg = 'Bad request';
        srtParts1.accCodes = accCodes;
         //srtParts1.coverageType='OTH';
        srtParts1.selectedPartRowCount=10;
        srtParts1.SelectedAccountCode='NEW PRODUCT WARRANTY 67';
        srtParts1.SelectedFailCode='Engine Wiring Harness-EXWH';
       // srtParts1.CoveredParAC=100;
        //CSS_SRTParts_RO.failAccountCodeMap=failAccountCodeMap1;
        //srtParts1.accountCodelistN('ReCon Policy','9','wer');
        Test.startTest();
        srtParts1.saveParts();
      //srtParts1.getAccountCodes();
        srtParts1.displayPopup2 = true;
        srtParts1.listsrtsolWrapper =srtsollist; // Anvesh added
        srtParts1.getreplacementReasonOptions();
        srtParts1.onChangeofAccountCode();
         srtParts1.SelectedAccountCode='Select One'; // Anvesh added
        srtParts1.onChangeofAccountCode();// Anvesh added
        srtParts1.getfailAccountCodeMap(); // Anvesh added
        Test.stopTest();
        css_repair_job repJob = new css_repair_job();
        CSS_SRTParts_RO controller = new CSS_SRTParts_RO(repJob);
        // ANvesh commented controller.getfailAccountCodeMap();
    }
}