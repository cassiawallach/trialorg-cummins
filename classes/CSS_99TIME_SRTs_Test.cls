/**********************************************************************
Name: CSS_99TIME_SRTs_Test
Copyright © 2017  Cummins
======================================================
======================================================
Purpose:    Test Class for CSS_99TIME_SRTs

======================================================
======================================================
History                                                            
-------                                                            
VERSION       AUTHOR                   DATE          DETAIL                                 
1.0           Rajesh Pasupuleti        28/9/2017      INITIAL dEVELOPMENT

***********************************************************************/
@isTest
public class CSS_99TIME_SRTs_Test {
    
    public testMethod static void CSS_99TIME_SRTs_Method()
    {
        /*profile p = [select id from profile where name = 'CSS_Dealer_Advanced'];
        Account partnerAccount = new Account(Name = 'Test Partner Acccount');                                                                           
        insert partnerAccount; 
        Contact partnerContact = new Contact(FirstName = 'Test Contact',LastName = 'Test Contact',
                AccountId = partnerAccount.Id,Email = 'testemail'+Math.round(Math.random()*Math.pow(10, 7))+'@testemail.com');
        insert partnerContact;

        User newuser1 = new User(Username='abc@gmail.com',Email='abc@gmail.com',profileid=p.id,ContactId=partnerContact.id,LastName ='Test name',Alias ='tetest',TimeZoneSidKey ='Asia/Kolkata',LocaleSidKey ='en_IN',EmailEncodingKey ='UTF-8',LanguageLocaleKey ='en_US',isActive = true);
        insert newuser1;
         /*Profile p = [SELECT Id FROM Profile WHERE Name='CSS_Dealer_Advanced']; 
             User u = new User(Alias = 'standt', Email='standarduser4@testorg.com', 
                EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                LocaleSidKey='en_US',  ProfileId = p.Id, 
                TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTestUser4@testorg.com',User_Location__c = 'location');
            insert u;*/
        //system.runAs(newuser1){
        {
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02466';
        acc.IAM_Service_Provider_Code__c='19134';
        acc.Type='Dealer Account';
        acc.CMI_Account_Status__c = 'Active';
        insert acc;
            

       //Service Job 
        CSS_Job_Order__c SerRec = new CSS_Job_Order__c();
        SerRec.DSID__c='12345';
        //SerRec.OwnerId = tq.Id;
        SerRec.DSID_Status__c='open';
        SerRec.ESN__c ='79464646';
        SerRec.Customer_Name__c='ABC';
        // SerRec.Failure_Date__c =d;
        SerRec.Failure_Point__c=2.2;
        SerRec.Unit_Number__c='1234';
        SerRec.Service_Model__c='ESN';
        SerRec.Service_Model_N__c = 445566;
        SerRec.Make__c='test';
        SerRec.Model__c='test1';
        SerRec.VIN__c='1XKAD49X6CJ305490';
        SerRec.Customer_Name__c='ABC';
        SerRec.CSS_In_Shop_Labor_Rate__c='100';
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
            serrec.Account__c=acc.id;
        insert SerRec;
        System.assert(serRec!= null);
        
        
        //Job event Temporary 
        List<CSS_JobEventTemporary__c> jobEventLst= new List<CSS_JobEventTemporary__c>();
        CSS_JobEventTemporary__c jobevent = new CSS_JobEventTemporary__c();
        jobevent.File_Name__c='Test';
        jobevent.Circuit_Description__c='rrrr';
        jobevent.Comp_Location__c='dfgh';
        jobevent.Key__c='AccountCodes';
        jobevent.Effect__c='klkl';
        jobevent.Engine__c='bfr';
        jobevent.Fault_Code_Description__c = 'intake';
        jobevent.File_Name__c = 'testing';
        jobevent.FMI__c = 'htyu';
        jobevent.Lamp__c = 'nhgt';
        jobevent.Reason__c = 'yyyy';
        jobevent.Service_Model_Name__c = 'fault';
        jobevent.SPN__c = 'bfgfhhj';
        jobevent.Attribute1__c= 'POL'; //'2014-05-08T00:00:00.000-05:00'; //string.valueof(system.now());
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
        // jobevent.Attribute13__c=d;
        jobevent.Attribute14__c='test15';
        jobevent.Attribute15__c='test8';
        jobevent.Reason__c='tEst';
        jobevent.type__c='ClaimHistory';
        jobevent.Active__c=true;
        //jobevent.Account_Code__c='Test-AccountCode';
        insert jobevent;
        jobEventLst.add(jobevent);
        
        //Solution
        CSS_Solutions__c solAdd = new CSS_Solutions__c();
        solAdd.Service_Job__c = SerRec.Id;
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
        
        //Solution Comp
        List<CSS_Solution_Component__c> solComplist = new list<CSS_Solution_Component__c>();
        CSS_Solution_Component__c AddsolComp = new CSS_Solution_Component__c();
            AddsolComp.Name='test';
        AddsolComp.Component_Id__c ='F0051000';
        AddsolComp.Service_Job__c = SerRec.id;
        AddsolComp.Action__c = 'Repair';
        AddsolComp.Solutions__c = solAdd.id;
        AddsolComp.Quantity__c = 4;
        AddsolComp.type__c='CAMPAIGN';
        AddsolComp.CoveredLaborHrs__c='10';
        //AddsolComp.Fail_Code__c='THAC';
        AddsolComp.Selected_Component__c = True;
        //AddsolComp.AccountCode__c = 'Test-AccountCode';
        AddsolComp.AccountCodeEdit__c = 'test';
        AddsolComp.CoveredPartsQty__c = null;
        AddsolComp.AccountCodeType__c='ASAS';
        AddsolComp.Fail_Code_Editable__c='CAM-campaign';
        AddsolComp.CampaignLaborPercentage__c='test';
        // addsolcomp.='fail';
        AddsolComp.Charlength__c = true;
            //AddsolComp.Fail_Code_Editable__c='test';
            AddsolComp.System_Code__c='IF';
        AddsolComp.Component_Code__c='IA';
             AddsolComp.CampaignLaborPercentage__c='7';
        insert AddsolComp;
        
        CSS_Solution_Component__c AddsolCom = new CSS_Solution_Component__c();
            AddsolCom.Name='test';
        AddsolCom.Component_Id__c ='F0051000';
        AddsolCom.Service_Job__c = SerRec.id;
        AddsolCom.Action__c = 'Repair';
        AddsolCom.Solutions__c = solAdd.id;
        AddsolCom.Quantity__c = 4;
        AddsolCom.type__c='test';
        AddsolCom.CoveredLaborHrs__c='10';
        AddsolCom.Selected_Component__c = True;
        //AddsolCom.AccountCode__c = 'Test-AccountCode';
        AddsolCom.AccountCodeEdit__c = 'Test-ACEdit';
        AddsolCom.CoveredPartsQty__c = null;
        AddsolCom.AccountCodeType__c='ASAS';
        AddsolCom.Fail_Code_Editable__c='CAM-campaign';
        // addsolcomp.='fail';
        AddsolCom.Charlength__c = true;
        AddsolCom.System_Code__c='IF';
        AddsolCom.Component_Code__c='IA';
        AddsolCom.Failure_Mode__c='SC';
        AddsolCom.Type__c='Test';
            AddsolCom.AccountCodeEdit__c='test';
             AddsolCom.CampaignLaborPercentage__c='7';
        insert AddsolCom;
        CSS_Solution_Component__c AddsolCom4 = new CSS_Solution_Component__c();
            AddsolCom4.Name='test';
        AddsolCom4.Component_Id__c ='F0051000';
        AddsolCom4.Service_Job__c = SerRec.id;
        AddsolCom4.Action__c = 'Repair';
        AddsolCom4.Solutions__c = solAdd.id;
        AddsolCom4.Quantity__c = 4;
        AddsolCom4.type__c='test';
        AddsolCom4.CoveredLaborHrs__c='10';
        AddsolCom4.Selected_Component__c = True;
        //AddsolCom.AccountCode__c = 'Test-AccountCode';
        AddsolCom4.AccountCodeEdit__c = 'Test-ACEdit';
        AddsolCom4.CoveredPartsQty__c = null;
        AddsolCom4.AccountCodeType__c='ASAS';
        AddsolCom4.Fail_Code_Editable__c='CAM-campaign';
        // addsolcomp.='fail';
        AddsolCom4.Charlength__c = true;
        AddsolCom4.System_Code__c='IF';
        AddsolCom4.Component_Code__c='IS';
        AddsolCom4.Failure_Mode__c='SC';
        AddsolCom4.Type__c='CAMPAIGN';
            AddsolCom4.AccountCodeEdit__c='test';
              AddsolCom4.Failure_Measure__c = 'Miles';
            AddsolCom4.AccountCodeEdit__c='test';
            AddsolCom4.Fail_Code_Editable__c='CAM-campaign';
             AddsolCom4.Performed_Review__c=true;
            AddsolCom4.CampaignLaborPercentage__c='7';
        insert AddsolCom4;
        
        CSS_Solution_Component__c solcomp = new CSS_Solution_Component__c();
        solcomp.Name = 'test';
        solcomp.Service_Job__c=SerRec.id;
        solcomp.System_Code__c='IF';
        solcomp.Component_Code__c='IA';
        solcomp.Failure_Mode__c='BT';
        //solcomp.AccountCode__c = 'Test-AccountCode';//wil inturn be the account Formula
        solcomp.Type__c = 'CAMPAIGN';
            solcomp.Performed_Review__c=true;
        solcomp.Selected_Component__c = true;
        solcomp.Customer_Take_Possession__c = 'yes';
        solcomp.Part_Warranty_Start_Date__c = system.today() - 30;
        solComp.CoveredLaborHrs__c='0';
        solcomp.Failure_Date__c = system.today();
        solcomp.Failure_Point__c = 20;
        solcomp.Failure_Measure__c = 'Miles';
            solcomp.AccountCodeEdit__c='test';
            solcomp.Fail_Code_Editable__c='CAM-campaign';
            solcomp.CampaignLaborPercentage__c='7';
        insert Solcomp;
        
        solComplist.add(AddsolComp);
        solComplist.add(AddsolCom);
        solcompList.add(SolComp);

        //SRT object
        CSS_SRT__c srtVar = new CSS_SRT__c();
        list<CSS_SRT__c> srtVarLst = new list<CSS_SRT__c>();
        srtVar.Job_Order__c = SerRec.Id;
        srtVar.name = '99-999';
        srtVar.Type__c = '99Time';
        srtVar.SRT_Select__c = false;
        srtVar.SRT_Warrantable__c='32';
        srtVar.FailCode__c='THAC';
        srtvar.Account_Code_Description__c='test';
        srtvar.Fail_Code_Description__c='test-IFIA';
        srtvar.SRT_Time__c = 11;
        srtvar.CSS_nonSRTRow__c='test';
        srtvar.Extended_Hours__c=2.0;
        srtvar.isPerformed__c=true;
        //srtvar.SRT_Warrantable__c=100;
        srtvar.SRT_Notes__c='CAPTAINS BRIEFING CB';
        srtvar.SRT_Estimate__c=False;
        insert srtVar;
        
             CSS_SRT__c srtVar1 = new CSS_SRT__c();
        //list<CSS_SRT__c> srtVarLst = new list<CSS_SRT__c>();
        srtVar1.Job_Order__c = SerRec.Id;
        srtVar1.name = '99-999';
        srtVar1.Type__c = '99Time';
        srtVar1.SRT_Select__c = false;
        srtVar1.SRT_Warrantable__c='32';
        srtVar1.FailCode__c='THAC';
        srtvar1.Account_Code_Description__c='test';
        srtvar1.Fail_Code_Description__c='IFIS';
        srtvar1.SRT_Time__c = 11;
        srtvar1.CSS_nonSRTRow__c='test';
        srtvar1.Extended_Hours__c=2.0;
        srtvar1.isPerformed__c=true;
        //srtvar.SRT_Warrantable__c=100;
        srtvar1.SRT_Notes__c='CAPTAINS BRIEFING CB';
        srtvar1.SRT_Estimate__c=False;
        insert srtVar1;
            
             CSS_SRT__c srtVar11 = new CSS_SRT__c();
        //list<CSS_SRT__c> srtVarLst = new list<CSS_SRT__c>();
        srtVar11.Job_Order__c = SerRec.Id;
        srtVar11.name = '99-999';
        srtVar11.Type__c = '99Time';
        srtVar11.SRT_Select__c = false;
        srtVar11.SRT_Warrantable__c='200';
        srtVar11.FailCode__c='THAC';
        srtvar11.Account_Code_Description__c='teasdasst';
        srtvar11.Fail_Code_Description__c='IFISsdsd';
        srtvar11.SRT_Time__c = 11;
        srtvar11.CSS_nonSRTRow__c='test';
        srtvar11.Extended_Hours__c=2.0;
        srtvar11.isPerformed__c=true;
        //srtvar.SRT_Warrantable__c=100;
        srtvar11.SRT_Notes__c='CAPTAINS BRIEFING CB';
        srtvar11.SRT_Estimate__c=False;
        insert srtVar11;
       /*CSS_SRT__c lstRec = [select id,name,Type__c,SRT_Select__c,failcode__C,SRT_Warrantable__c from CSS_SRT__c limit 1];
        lstRec.SRT_Warrantable__c='12';
        insert lstRec;*/
        
        Test.startTest();
        PageReference pg = Page.CSS_JobTndRj;
        Test.setCurrentPage(pg);
        ApexPages.CurrentPage().getParameters().put('id',SerRec.Id);
        
        CSS_99TIME_SRTs ObjRef = new CSS_99TIME_SRTs();
        CSS_JobPlanSRTController obj = new CSS_JobPlanSRTController();
        ObjRef.JobID = SerRec.Id;
        objref.selectedRemoveRow = 0;
        objref.PName ='pname';
        objref.checkNonSRTRow=false;
        objref.mainContr = obj;
        objref.testing();
        objref.dealerLocation=true;
        //objref.coverageType='TRP';
        //objref.reqPercent='test';
        objref.removingNonSRTRow();
        objref.closePopup();
        objref.saveNonSRTPopup();
        objref.gotoJobPlanSrt();
        
        pageReference ref= objref.resetNonSRTMethod();
        pageReference ref1= objref.saveSRTMethod();
        system.assert(srtVar.Account_Code_Description__c!=null);
        system.assert(srtVar.Fail_Code_Description__c!=null);
        //  ObjRef.saveCustSRT();
        Test.stopTest();
        
        }  
        
    }
    
    public testMethod static void Method2()
    {
         Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02466';
        acc.IAM_Service_Provider_Code__c='19134';
        acc.Type='Dealer Account';
        acc.CMI_Account_Status__c = 'Active';
        insert acc;
       css_job_order__c jo = new css_job_order__c();
        jo.Customer_Name__c='TestUser';
        jo.Account__c=acc.id;
        jo.Customer_Code__c='123';
        jo.ESN__c='53467987';
        jo.Status__c='closed';
        insert jo; 
        css_header_nav__c cssHeaderObject = new css_header_nav__c();
        cssHeaderObject.RSWButtonEnable__c = true;
        insert cssHeaderObject;
       /* List<CSS_Solution_Component__c> lstsolcomp = new List<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solcomp = new CSS_Solution_Component__c();
        solcomp.Name = 'solcomp';
        solcomp.Service_Job__c=jo.id;
        solcomp.System_Code__c='TH';
        solcomp.Component_Code__c='AC';
        solcomp.Failure_Mode__c='BT';
        solcomp.AccountCodeEdit__c='TH';
        solcomp.Fail_Code_Editable__c='AC';
        solcomp.AccountCode__c = 'SERVICE TOOL WARRANTY 52';//wil inturn be the account Formula
        solcomp.Type__c = 'Campaign';
        solcomp.Selected_Component__c = true;
        solcomp.Customer_Take_Possession__c = 'yes';
        solcomp.Part_Warranty_Start_Date__c = system.today() - 30;
        solComp.CoveredLaborHrs__c='100.0';
        solcomp.Failure_Date__c = system.today();
        solcomp.Failure_Point__c = 20;
        solcomp.Failure_Measure__c = 'Miles';
        lstsolcomp.add(solcomp);
        
         CSS_Solution_Component__c AddsolCom4 = new CSS_Solution_Component__c();
            AddsolCom4.Name='test';
        //AddsolCom4.Component_Id__c ='F0051000';
        AddsolCom4.Service_Job__c = jo.id;
        AddsolCom4.Action__c = 'Repair';
        //AddsolCom4.Solutions__c = solAdd.id;
        AddsolCom4.Quantity__c = 4;
        AddsolCom4.type__c='test';
        AddsolCom4.CoveredLaborHrs__c='0';
        AddsolCom4.Selected_Component__c = True;
        //AddsolCom.AccountCode__c = 'Test-AccountCode';
        AddsolCom4.AccountCodeEdit__c = 'Test-ACEdit';
        AddsolCom4.CoveredPartsQty__c = null;
        AddsolCom4.AccountCodeType__c='ASAS';
        AddsolCom4.Fail_Code_Editable__c='CAM-campaign';
        // addsolcomp.='fail';
        AddsolCom4.Charlength__c = true;
        AddsolCom4.System_Code__c='IF';
        AddsolCom4.Component_Code__c='IS';
        AddsolCom4.Failure_Mode__c='SC';
        AddsolCom4.Type__c='CAMPAIGN';
            AddsolCom4.AccountCodeEdit__c='test';
              AddsolCom4.Failure_Measure__c = 'Miles';
            AddsolCom4.AccountCodeEdit__c='test';
            AddsolCom4.Fail_Code_Editable__c='CAM-campaign';
             AddsolCom4.Performed_Review__c=true;
            AddsolCom4.CampaignLaborPercentage__c='7';
        insert AddsolCom4;
        lstsolcomp.add(AddsolCom4);
        insert lstsolcomp;*/
        CSS_SRT__c srtVar1 = new CSS_SRT__c();
        //list<CSS_SRT__c> srtVarLst = new list<CSS_SRT__c>();
        srtVar1.Job_Order__c = jo.Id;
        srtVar1.name = '99-999';
        srtVar1.Type__c = '99Time';
        srtVar1.SRT_Select__c = false;
        srtVar1.SRT_Warrantable__c='32';
        srtVar1.FailCode__c='THAC';
        srtvar1.Account_Code_Description__c='test';
        srtvar1.Fail_Code_Description__c='IFIS';
        srtvar1.SRT_Time__c = 11;
        srtvar1.CSS_nonSRTRow__c='test';
        srtvar1.Extended_Hours__c=2.0;
        srtvar1.isPerformed__c=true;
        //srtvar.SRT_Warrantable__c=100;
        srtvar1.SRT_Notes__c='CAPTAINS BRIEFING CB';
        srtvar1.SRT_Estimate__c=False;
        insert srtVar1;
        CSS_SRT__c srtVar = new CSS_SRT__c();
        list<CSS_SRT__c> srtVarLst = new list<CSS_SRT__c>();
        srtVar.Job_Order__c = jo.Id;
        srtVar.name = '99-999';
        srtVar.Type__c = '99Time';
        srtVar.SRT_Select__c = false;
        srtVar.SRT_Warrantable__c='132';
        srtVar.FailCode__c='THACAB';
        srtvar.Account_Code_Description__c='test';
        srtvar.Fail_Code_Description__c='test-IFIA';
        //srtvar.Component_Id__c=srtvar1.id;
        srtvar.CSS_nonSRTRow__c=null;
        srtvar.SRT_Time__c = 11;
        srtvar.CSS_nonSRTRow__c='test';
        srtvar.Extended_Hours__c=2.0;
        srtvar.isPerformed__c=true;
        //srtvar.SRT_Warrantable__c=100;
        srtvar.SRT_Notes__c='CAPTAINS BRIEFING CB';
        srtvar.SRT_Estimate__c=False;
        insert srtVar;
        Test.startTest();
        
        PageReference pg = Page.CSS_JobTndRj;
        Test.setCurrentPage(pg);
        ApexPages.CurrentPage().getParameters().put('id',jo.Id);
        
        CSS_99TIME_SRTs SRTI= new CSS_99TIME_SRTs();
        //SRTI.coverageType='OTH';
        SRTI.getEditNonSRTValues();
        SRTI.saveSRTMethod();
        Test.stopTest();
        
        
    }
}