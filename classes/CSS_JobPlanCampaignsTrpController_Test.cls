/*
 * Block comments with details of changes
 */
@isTest
public class CSS_JobPlanCampaignsTrpController_Test
{
  static  testMethod void CSS_JobPlanCampaignsTrpController_method1()
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
        
        CSS_Solution_Component__c solComp = new CSS_Solution_Component__c();
            solComp.Component_Id__c ='F0051000';
            solComp.Service_Job__c = Jo.id;
            solComp.Action__c = '';
        	solComp.Type__c = 'Campaign';
        	solComp.Campaign_Description__c = 'Hey Hai Man Camp';
        	solComp.CampaignPartsPercentage__c = '20';
        	solcomp.Performed_Review__c = True;
        	solcomp.Status__c = 'Approved';
        	solComp.Complete_Indicator__c = True;
        	solcomp.Multiple_Times__c = True;
        insert solComp;
        
        CSS_Solution_Component__c solComptrp = new CSS_Solution_Component__c();
            solComptrp.Component_Id__c ='F0051000';
            solComptrp.Service_Job__c = Jo.id;
        	solComptrp.Type__c = 'TRP';
        	solComptrp.Campaign_Description__c = 'Hey Hai Man TRP';
        	solComptrp.CampaignPartsPercentage__c = '10';
        	solcomptrp.Performed_Review__c = True;
        	solComptrp.Status__c = 'Approved';
        	solComptrp.Complete_Indicator__c = True;
        	solComptrp.Multiple_Times__c = True;
        insert solComptrp;
        
        CSS_Solution_Component__c solCompatc = new CSS_Solution_Component__c();
            solCompatc.Component_Id__c ='F0051000';
            solCompatc.Service_Job__c = Jo.id;
        	solCompatc.Type__c = 'ATC';
        	solCompatc.Campaign_Description__c = 'Hey Hai Man ATC';
        	solCompatc.CampaignPartsPercentage__c = '10';
        	solcompatc.Performed_Review__c = True;
        	solcompatc.Status__c = 'Approved';
        	solcompatc.Complete_Indicator__c = True;
        	solcompatc.Multiple_Times__c = True;
        insert solCompatc;
        
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
        
        CSS_CampTsbTrp__c ctt = new CSS_CampTsbTrp__c();
        	ctt.Type__c = 'ATC';
        	ctt.URL__c = 'https://qs-stg.cummins.com/qs3/pubsys2/xml/en/atc/19TC/atc1623.html';
        	ctt.Doc_Num__c = 'ATCF0051000';
            ctt.Doc_Title__c = 'DUAL FUEL DATAPLATE ATC';
        	ctt.Performed__c = false;
            ctt.Performed_Review__c = true;
        	ctt.Reviewed__c = false;
        	ctt.job_order__c = JO.id;
        ctt.esn__c = JO.esn__C;
        insert ctt;
        
        CSS_CampTsbTrp__c ctt1 = new CSS_CampTsbTrp__c();
        	ctt1.Type__c = 'TRP';
        	ctt1.URL__c = 'https://qs-stg.cummins.com/qs3/pubsys2/xml/en/atc/19TC/atc1623.html';
        	ctt1.Doc_Num__c = 'TF0051000';
            ctt1.Doc_Title__c = 'DUAL FUEL DATAPLATE ATC';
        	ctt1.Performed__c = false;
            ctt1.Performed_Review__c = true;
        	ctt1.Reviewed__c = false;
        	ctt1.job_order__c = JO.id;
        ctt1.esn__c = JO.esn__C;
        insert ctt1;
        CSS_CampTsbTrp__c ctt2 = new CSS_CampTsbTrp__c();
        	ctt2.Type__c = 'CAM';
        	ctt2.URL__c = 'https://qs-stg.cummins.com/qs3/pubsys2/xml/en/atc/19TC/atc1623.html';
        	ctt2.Doc_Num__c = 'CF0051000';
            ctt2.Doc_Title__c = 'DUAL FUEL DATAPLATE ATC';
        	ctt2.Performed__c = false;
            ctt2.Performed_Review__c = true;
        	ctt2.Reviewed__c = false;
        	ctt2.job_order__c = JO.id;
        ctt2.esn__c = JO.esn__C;
        insert ctt2;
     
        Test.startTest();
        
        
        ApexPages.CurrentPage().getParameters().put('Id', JO.id);
        
         CSS_JobPlanCampaignsTrpController campTrp = new CSS_JobPlanCampaignsTrpController();       
        
        Test.stopTest();
    }
}