/**********************************************************************
Name: CSS_CampaignControllerNew_Test
Copyright © 2017  Cummins
History                                                            
-------                                                            
VERSION  AUTHOR            				 DATE                DETAIL                                 
1.0     Agassishyam Thangakumar         01/11/2018    INITIAL DEVELOPMENT
2.0     Rupesh Pande        			01/11/2018    Covered Wrapper Functions and added some variables for full cover
***********************************************************************/
@isTest
public class CSS_CampaignControllerNew_Test 
{
    
    static testMethod void TestMethod1() 
    {
        
        CSS_Job_Order__c JO = new CSS_Job_Order__c();
        JO.Customer_Name__c = 'Agassi';
        JO.Application__c = 'Recreational Vehicle';
        JO.Model__c = 'AgassishyamTest';
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
        insert JO;
        
        PageReference pref;
        pref = new PageReference('/'+JO.id);
        pref.getParameters().put('id',JO.id);
        Test.setCurrentPage(pref);
        
        CSS_Solution_Component__c solComp = new CSS_Solution_Component__c();
        solComp.Component_Id__c ='F0051000';
        solComp.Service_Job__c = Jo.id;
        solComp.Action__c = '';
        solComp.Type__c = 'Campaign';
        solComp.Campaign_Description__c = 'Hey Hai Man Camp';
        solComp.CampaignPartsPercentage__c = '20';
        solcomp.Performed_Review__c = True;
        solcomp.Status__c='Approved';
        solcomp.Complete_Indicator__c=true; 
        solcomp.Multiple_Times__c=true;
        insert solComp;
        
        CSS_Solution_Component__c solComptrp = new CSS_Solution_Component__c();
        solComptrp.Component_Id__c ='F0051000';
        solComptrp.Service_Job__c = Jo.id;
        solComptrp.Type__c = 'TRP';
        solComptrp.Campaign_Description__c = 'Hey Hai Man TRP';
        solComptrp.CampaignPartsPercentage__c = '10';
        solcomptrp.Performed_Review__c = True;
        solcomptrp.Status__c='Approved';
        solcomptrp.Complete_Indicator__c=true; 
        solcomptrp.Multiple_Times__c=true;
        insert solComptrp;
        
        CSS_Solution_Component__c solCompatc = new CSS_Solution_Component__c();
        solCompatc.Component_Id__c ='F0051000';
        solCompatc.Service_Job__c = Jo.id;
        solCompatc.Type__c = 'ATC';
        solCompatc.Campaign_Description__c = 'Hey Hai Man ATC';
        solCompatc.CampaignPartsPercentage__c = '10';
        solcompatc.Performed_Review__c = True;
        solcompatc.Status__c='Approved';
        solcompatc.Complete_Indicator__c=true; 
        solcompatc.Multiple_Times__c=true;
        insert solCompatc;
        system.debug('Solution Component:'+solCompatc);
        
        CSS_Parts_Options__c parts = new CSS_Parts_Options__c();
        parts.FailurepartId__c = solComp.Id;
        parts.selected_part__c = True;
        parts.Service_partnumber__c = '540571401';
        parts.OEM__c = 'OEMWRS';
        parts.Part_Name__c = 'TestPartCamp';
        parts.ReturnToFactory__c = 'Campaign-TRP-ATC';
        parts.Replacement_Reason__c = 'Campaign-TRP-ATC';
        parts.Quantity__c = 55;
        parts.Notes__c = 'Hai how are you guys';
        parts.Service_Job__c = Jo.id;
        insert parts;
        
        CSS_Parts_Options__c partstrp = new CSS_Parts_Options__c();
        partstrp.FailurepartId__c = solComptrp.Id;
        partstrp.selected_part__c = True;
        partstrp.Service_partnumber__c = '540571401';
        partstrp.OEM__c = 'OEMWRS';
        partstrp.Part_Name__c = 'TestPartCamp';
        partstrp.ReturnToFactory__c = 'Campaign-TRP-ATC';
        partstrp.Replacement_Reason__c = 'Campaign-TRP-ATC';
        partstrp.Quantity__c = 55;
        partstrp.Notes__c = 'Hai how are you guys';
        partstrp.Service_Job__c = Jo.id;
        insert partstrp;
        
        CSS_Parts_Options__c partsatc = new CSS_Parts_Options__c();
        partsatc.FailurepartId__c = solCompatc.Id;
        partsatc.selected_part__c = True;
        partsatc.Service_partnumber__c = '540571401';
        partsatc.OEM__c = 'OEMWRS';
        partsatc.Part_Name__c = 'TestPartCamp';
        partsatc.ReturnToFactory__c = 'Campaign-TRP-ATC';
        partsatc.Replacement_Reason__c = 'Campaign-TRP-ATC';
        partsatc.Quantity__c = 55;
        partsatc.Notes__c = 'Hai how are you guys';
        partsatc.Service_Job__c = Jo.id;
        insert partsatc;
        
        Test.startTest();
        ApexPages.currentPage().getParameters().put('id',JO.id);
        List<CSS_CampaignControllerNew.PartWrapper> lstpartwrap = new list<CSS_CampaignControllerNew.PartWrapper>();
        CSS_CampaignControllerNew.PartWrapper wrap = new CSS_CampaignControllerNew.PartWrapper(solComp.id, true, 'fieldactnum', 'type', 'accountcode', 'quantity', 'servicepart',' oem', 'partname','returnToFactory', 'covered', 'failcode', 'replacementreason',' notes', 1,' percentage');
        lstpartwrap.add(wrap);
        List<CSS_CampaignControllerNew.CompWrapper> lstcompwrap = new List<CSS_CampaignControllerNew.CompWrapper>();
        CSS_CampaignControllerNew.CompWrapper compwrap = new CSS_CampaignControllerNew.CompWrapper(parts.id,'FieldActNum' ,lstpartwrap,1);
        lstcompwrap.add(compwrap);
        CSS_CampaignControllerNew ccn = new CSS_CampaignControllerNew();
        //CSS_CampaignControllerNew ccn = new CSS_CampaignControllerNew(new ApexPages.StandardController(JO));
        ccn.getAllCampPartsData();
        ccn.getAllTRPPartsData();
        ccn.getAllATCPartsData();
        ccn.saveCTAData();
        ccn.campPartsDetails();
        List<SelectOption> soption=ccn.getreplacementReasonOptions();
        List<SelectOption> nsb = new List<SelectOption>();
        nsb = ccn.getreplacementReasonOptions();
        ccn.ResetCTAData();
        Test.stopTest();        
    }
     static testMethod void TestMethod2() 
    {
        
        CSS_Job_Order__c JO = new CSS_Job_Order__c();
        JO.Customer_Name__c = 'Agassi';
        JO.Application__c = 'Recreational Vehicle';
        JO.Model__c = 'AgassishyamTest';
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
        insert JO;
        
        PageReference pref;
        pref = new PageReference('/'+JO.id);
        pref.getParameters().put('id',JO.id);
        Test.setCurrentPage(pref);
        
        CSS_Solution_Component__c solComp = new CSS_Solution_Component__c();
        solComp.Component_Id__c ='F0051000';
        solComp.Service_Job__c = Jo.id;
        solComp.Action__c = '';
        solComp.Type__c = 'Campaign';
        solComp.Campaign_Description__c = 'Hey Hai Man Camp';
        solComp.CampaignPartsPercentage__c = '20';
        solcomp.Performed_Review__c = True;
        solcomp.Status__c='Approved';
        solcomp.Complete_Indicator__c=true; 
        solcomp.Multiple_Times__c=true;
        insert solComp;
        
        CSS_Solution_Component__c solComptrp = new CSS_Solution_Component__c();
        solComptrp.Component_Id__c ='F0051000';
        solComptrp.Service_Job__c = Jo.id;
        solComptrp.Type__c = 'TRP';
        solComptrp.Campaign_Description__c = 'Hey Hai Man TRP';
        solComptrp.CampaignPartsPercentage__c = '10';
        solcomptrp.Performed_Review__c = True;
        solcomptrp.Status__c='Approved';
        solcomptrp.Complete_Indicator__c=true; 
        solcomptrp.Multiple_Times__c=true;
        insert solComptrp;
        
        CSS_Solution_Component__c solCompatc = new CSS_Solution_Component__c();
        solCompatc.Component_Id__c ='F0051000';
        solCompatc.Service_Job__c = Jo.id;
        solCompatc.Type__c = 'ATC';
        solCompatc.Campaign_Description__c = 'Hey Hai Man ATC';
        solCompatc.CampaignPartsPercentage__c = '10';
        solcompatc.Performed_Review__c = True;
        solcompatc.Status__c='Approved';
        solcompatc.Complete_Indicator__c=true; 
        solcompatc.Multiple_Times__c=true;
        insert solCompatc;
        system.debug('Solution Component:'+solCompatc);
        
        CSS_Parts_Options__c parts = new CSS_Parts_Options__c();
        parts.FailurepartId__c = solComp.Id;
        parts.selected_part__c = True;
        parts.Service_partnumber__c = '540571401';
        parts.OEM__c = 'OEMWRS';
        parts.Part_Name__c = 'TestPartCamp';
        parts.ReturnToFactory__c = 'Campaign-TRP-ATC';
        parts.Replacement_Reason__c = 'Campaign-TRP-ATC';
        parts.Quantity__c = 55;
        parts.Notes__c = 'Hai how are you guys';
        parts.Service_Job__c = Jo.id;
        insert parts;
        
        CSS_Parts_Options__c partstrp = new CSS_Parts_Options__c();
        partstrp.FailurepartId__c = solComptrp.Id;
        partstrp.selected_part__c = True;
        partstrp.Service_partnumber__c = '540571401';
        partstrp.OEM__c = 'OEMWRS';
        partstrp.Part_Name__c = 'TestPartCamp';
        partstrp.ReturnToFactory__c = 'Campaign-TRP-ATC';
        partstrp.Replacement_Reason__c = 'Campaign-TRP-ATC';
        partstrp.Quantity__c = 55;
        partstrp.Notes__c = 'Hai how are you guys';
        partstrp.Service_Job__c = Jo.id;
        insert partstrp;
        
        CSS_Parts_Options__c partsatc = new CSS_Parts_Options__c();
        partsatc.FailurepartId__c = solCompatc.Id;
        partsatc.selected_part__c = True;
        partsatc.Service_partnumber__c = '540571401';
        partsatc.OEM__c = 'OEMWRS';
        partsatc.Part_Name__c = 'TestPartCamp';
        partsatc.ReturnToFactory__c = 'Campaign-TRP-ATC';
        partsatc.Replacement_Reason__c = 'Campaign-TRP-ATC';
        partsatc.Quantity__c = 55;
        partsatc.Notes__c = 'Hai how are you guys';
        partsatc.Service_Job__c = Jo.id;
        insert partsatc;
        
        Test.startTest();
        ApexPages.currentPage().getParameters().put('id',JO.id);
        List<CSS_CampaignControllerNew.PartWrapper> lstpartwrap = new list<CSS_CampaignControllerNew.PartWrapper>();
        CSS_CampaignControllerNew.PartWrapper wrap = new CSS_CampaignControllerNew.PartWrapper(partstrp.id, true, 'fieldactnum', 'type', 'accountcode', 'quantity', 'servicepart',' oem', 'partname','returnToFactory', 'covered', 'failcode', 'replacementreason',' notes', 1,' percentage');
        lstpartwrap.add(wrap);
        List<CSS_CampaignControllerNew.CompWrapper> lstcompwrap = new List<CSS_CampaignControllerNew.CompWrapper>();
        CSS_CampaignControllerNew.CompWrapper compwrap = new CSS_CampaignControllerNew.CompWrapper(solComptrp.id,'FieldActNum' ,lstpartwrap,1);
        lstcompwrap.add(compwrap);
        CSS_CampaignControllerNew ccn = new CSS_CampaignControllerNew();
        //CSS_CampaignControllerNew ccn = new CSS_CampaignControllerNew(new ApexPages.StandardController(JO));
        ccn.getAllCampPartsData();
        ccn.getAllTRPPartsData();
        ccn.getAllATCPartsData();
        ccn.saveCTAData();
        ccn.campPartsDetails();
        List<SelectOption> soption=ccn.getreplacementReasonOptions();
        List<SelectOption> nsb = new List<SelectOption>();
        nsb = ccn.getreplacementReasonOptions();
        ccn.ResetCTAData();
        Test.stopTest();        
    }
     static testMethod void TestMethod3() 
    {
        
        CSS_Job_Order__c JO = new CSS_Job_Order__c();
        JO.Customer_Name__c = 'Agassi';
        JO.Application__c = 'Recreational Vehicle';
        JO.Model__c = 'AgassishyamTest';
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
        insert JO;
        
        PageReference pref;
        pref = new PageReference('/'+JO.id);
        pref.getParameters().put('id',JO.id);
        Test.setCurrentPage(pref);
        
        CSS_Solution_Component__c solComp = new CSS_Solution_Component__c();
        solComp.Component_Id__c ='F0051000';
        solComp.Service_Job__c = Jo.id;
        solComp.Action__c = '';
        solComp.Type__c = 'Campaign';
        solComp.Campaign_Description__c = 'Hey Hai Man Camp';
        solComp.CampaignPartsPercentage__c = '20';
        solcomp.Performed_Review__c = True;
        solcomp.Status__c='Approved';
        solcomp.Complete_Indicator__c=true; 
        solcomp.Multiple_Times__c=true;
        insert solComp;
        
        CSS_Solution_Component__c solComptrp = new CSS_Solution_Component__c();
        solComptrp.Component_Id__c ='F0051000';
        solComptrp.Service_Job__c = Jo.id;
        solComptrp.Type__c = 'TRP';
        solComptrp.Campaign_Description__c = 'Hey Hai Man TRP';
        solComptrp.CampaignPartsPercentage__c = '10';
        solcomptrp.Performed_Review__c = True;
        solcomptrp.Status__c='Approved';
        solcomptrp.Complete_Indicator__c=true; 
        solcomptrp.Multiple_Times__c=true;
        insert solComptrp;
        
        CSS_Solution_Component__c solCompatc = new CSS_Solution_Component__c();
        solCompatc.Component_Id__c ='F0051000';
        solCompatc.Service_Job__c = Jo.id;
        solCompatc.Type__c = 'ATC';
        solCompatc.Campaign_Description__c = 'Hey Hai Man ATC';
        solCompatc.CampaignPartsPercentage__c = '10';
        solcompatc.Performed_Review__c = True;
        solcompatc.Status__c='Approved';
        solcompatc.Complete_Indicator__c=true; 
        solcompatc.Multiple_Times__c=true;
        insert solCompatc;
        system.debug('Solution Component:'+solCompatc);
        
        CSS_Parts_Options__c parts = new CSS_Parts_Options__c();
        parts.FailurepartId__c = solComp.Id;
        parts.selected_part__c = True;
        parts.Service_partnumber__c = '540571401';
        parts.OEM__c = 'OEMWRS';
        parts.Part_Name__c = 'TestPartCamp';
        parts.ReturnToFactory__c = 'Campaign-TRP-ATC';
        parts.Replacement_Reason__c = 'Campaign-TRP-ATC';
        parts.Quantity__c = 55;
        parts.Notes__c = 'Hai how are you guys';
        parts.Service_Job__c = Jo.id;
        insert parts;
        
        CSS_Parts_Options__c partstrp = new CSS_Parts_Options__c();
        partstrp.FailurepartId__c = solComptrp.Id;
        partstrp.selected_part__c = True;
        partstrp.Service_partnumber__c = '540571401';
        partstrp.OEM__c = 'OEMWRS';
        partstrp.Part_Name__c = 'TestPartCamp';
        partstrp.ReturnToFactory__c = 'Campaign-TRP-ATC';
        partstrp.Replacement_Reason__c = 'Campaign-TRP-ATC';
        partstrp.Quantity__c = 55;
        partstrp.Notes__c = 'Hai how are you guys';
        partstrp.Service_Job__c = Jo.id;
        insert partstrp;
        
        CSS_Parts_Options__c partsatc = new CSS_Parts_Options__c();
        partsatc.FailurepartId__c = solCompatc.Id;
        partsatc.selected_part__c = True;
        partsatc.Service_partnumber__c = '540571401';
        partsatc.OEM__c = 'OEMWRS';
        partsatc.Part_Name__c = 'TestPartCamp';
        partsatc.ReturnToFactory__c = 'Campaign-TRP-ATC';
        partsatc.Replacement_Reason__c = 'Campaign-TRP-ATC';
        partsatc.Quantity__c = 55;
        partsatc.Notes__c = 'Hai how are you guys';
        partsatc.Service_Job__c = Jo.id;
        insert partsatc;
        
        Test.startTest();
        ApexPages.currentPage().getParameters().put('id',JO.id);
        List<CSS_CampaignControllerNew.PartWrapper> lstpartwrap = new list<CSS_CampaignControllerNew.PartWrapper>();
        CSS_CampaignControllerNew.PartWrapper wrap = new CSS_CampaignControllerNew.PartWrapper(partsatc.id, true, 'fieldactnum', 'type', 'accountcode', 'quantity', 'servicepart',' oem', 'partname','returnToFactory', 'covered', 'failcode', 'replacementreason',' notes', 1,' percentage');
        lstpartwrap.add(wrap);
        List<CSS_CampaignControllerNew.CompWrapper> lstcompwrap = new List<CSS_CampaignControllerNew.CompWrapper>();
        CSS_CampaignControllerNew.CompWrapper compwrap = new CSS_CampaignControllerNew.CompWrapper(solCompatc.id,'FieldActNum' ,lstpartwrap,1);
        lstcompwrap.add(compwrap);
        CSS_CampaignControllerNew ccn = new CSS_CampaignControllerNew();
        //CSS_CampaignControllerNew ccn = new CSS_CampaignControllerNew(new ApexPages.StandardController(JO));
        ccn.getAllCampPartsData();
        ccn.getAllTRPPartsData();
        ccn.getAllATCPartsData();
        ccn.saveCTAData();
        ccn.campPartsDetails();
        List<SelectOption> soption=ccn.getreplacementReasonOptions();
        List<SelectOption> nsb = new List<SelectOption>();
        nsb = ccn.getreplacementReasonOptions();
        ccn.ResetCTAData();
        Test.stopTest();        
    }
    
}