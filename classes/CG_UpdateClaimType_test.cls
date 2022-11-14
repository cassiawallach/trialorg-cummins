@istest
public class CG_UpdateClaimType_test {
    static TestMethod void testSRT1() {
        test.startTest();
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
        upsert solcomp1;
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
        List<CSS_SRT__c> lstSrt = new List<CSS_SRT__c>();
        CSS_SRT__c strobj = new CSS_SRT__c();
        strobj.Job_Order__c = servicejob.Id;
        strobj.SRT_AccessiblityCheck__c=True;
        strobj.Access_Code_A__c = 65;
        strobj.name = 'TestClassName';
        strobj.Assignment__c = 'PRIMARY';
        strobj.SRT_ID__c = '00-901-10';
        strobj.isPerformed__c = true;
        strobj.FailCode__c = 'testing';
        insert strobj;
        lstSrt.add(strobj);
        

        
        
        
         List<Id> prtsListIds = new List<Id>();
         CSS_Parts_Options__c parts = new CSS_Parts_Options__c();
          parts.FailurepartId__c = solComp.Id;
         // parts.Service_Job__c = Jo.id;
          parts.selected_part__c = True;
          parts.Service_partnumber__c = '540571401';
          parts.OEM__c = 'OEMWRS';
          parts.Part_Name__c = 'TestPartCamp';
          parts.ReturnToFactory__c = 'Campaign-TRP-ATC';
      	  parts.Replacement_Reason__c = 'Campaign-TRP-ATC';
          parts.Quantity__c = 55;
          parts.Notes__c = 'Hey how are you guys';
          parts.Fail_Code__c = '';
          parts.Account_Code__c = 'ACCOUNT TEAM COVERAGE 27';
          
        insert parts;
        prtsListIds.add(parts.id);
        
        CG_UpdateClaimType ClaimType = new CG_UpdateClaimType();
        CG_UpdateClaimType.updateClaimType(prtsListIds);
        test.stopTest();
        
    } 
    
    static TestMethod void testSRT3() {
        test.startTest();
        CSS_Job_Order__c JO = new CSS_Job_Order__c();
        //JO = CSS_TestData.createJobOrder(true);
       // Jo.Account__c = acc.id;
        
        CSS_Claims__c  claimsRec= new CSS_Claims__c();
        	claimsRec.odm_Status__c = '';
        	//insert claimsRec;
    	
        List<Id> prtsListIds = new List<Id>();
		 CSS_Parts_Options__c parts = new CSS_Parts_Options__c();
          //parts.FailurepartId__c = solComp.Id;
          parts.Service_Job__c = JO.id;
          parts.selected_part__c = True;
          parts.Service_partnumber__c = '540571401';
          parts.OEM__c = 'OEMWRS';
          parts.Part_Name__c = 'TestPartCamp';
          parts.ReturnToFactory__c = 'Campaign-TRP-ATC';
      	  parts.Replacement_Reason__c = 'Campaign-TRP-ATC';
          parts.Quantity__c = 55;
          parts.Notes__c = 'Hey how are you guys';
          parts.css_claims__c = claimsRec.id;
          parts.Fail_Code__c = ''; 
          parts.Account_Code__c = 'ACCOUNT TEAM COVERAGE 27';
          insert parts;
        prtsListIds.add(parts.Id);
        
        
                
        CSS_Solution_Component__c solComp = new CSS_Solution_Component__c();
            solComp.Component_Id__c ='F0051000';
           // solComp.Service_Job__c = Jo.id;
            solComp.Action__c = '';
            solComp.Type__c = 'Campaign';
            solComp.Campaign_Description__c = 'Hey Hai Man Camp';
            solComp.CampaignPartsPercentage__c = '20';
            solcomp.Performed_Review__c = True;
        	solcomp.Claim_Type__c = 'Test';
        	solComp.Selected_Claim_Type__c = 'Testing';
        	solComp.AccountCodeType__c	= 'ACCOUNT TEAM COVERAGE';
        	solcomp.AccountCode__c = '27';
        	solcomp.AccountCodeEdit__c = 'ACCOUNT TEAM COVERAGE 27';
        	
        	insert solcomp;
        
        CG_UpdateClaimType ClaimType = new CG_UpdateClaimType();
        CG_UpdateClaimType.updateClaimType(prtsListIds);
        test.stopTest();
} 
    
    static TestMethod void testSRT32() {
        test.startTest();
        CSS_Job_Order__c JO = new CSS_Job_Order__c();
        //JO = CSS_TestData.createJobOrder(true);
        
        /*CSS_Claims__c  claimsRec= new CSS_Claims__c();
        	claimsRec.odm_Status__c = '';
        	insert claimsRec;*/
    	
        List<Id> prtsListIds = new List<Id>();
		 CSS_Parts_Options__c parts = new CSS_Parts_Options__c();
          //parts.FailurepartId__c = solComp.Id;
          parts.Service_Job__c = JO.id;
          parts.selected_part__c = True;
          parts.Service_partnumber__c = '540571401';
          parts.OEM__c = 'OEMWRS';
          parts.Part_Name__c = 'TestPartCamp';
          parts.ReturnToFactory__c = 'Campaign-TRP-ATC';
      	  parts.Replacement_Reason__c = 'Campaign-TRP-ATC';
          parts.Quantity__c = 55;
          parts.Notes__c = 'Hey how are you guys';
          //parts.css_claims__c = claimsRec.id;
          parts.Fail_Code__c = 'test-ing'; 
          parts.Account_Code__c = 'ACCOUNT TEAM COVERAGE 27';
          //insert parts;
        prtsListIds.add(parts.Id);
        
        
                
        CSS_Solution_Component__c solComp = new CSS_Solution_Component__c();
            solComp.Component_Id__c ='F0051000';
           // solComp.Service_Job__c = Jo.id;
            solComp.Action__c = '';
            solComp.Type__c = 'Campaign';
            solComp.Campaign_Description__c = 'Hey Hai Man Camp';
            solComp.CampaignPartsPercentage__c = '20';
            solcomp.Performed_Review__c = True;
        	//solcomp.Claim_Type__c = 'Test';
        	solComp.Selected_Claim_Type__c = 'Testing';
        	solComp.AccountCodeType__c	= 'ACCOUNT TEAM COVERAGE';
        	solcomp.AccountCode__c = '27';
        	solcomp.AccountCodeEdit__c = 'ACCOUNT TEAM COVERAGE 27';
        	
        	insert solcomp;
        
        CG_UpdateClaimType ClaimType = new CG_UpdateClaimType();
        CG_UpdateClaimType.updateClaimType(prtsListIds);
        test.stopTest();
} 
    
     static TestMethod void testSRT31() {
        test.startTest();
        CSS_Job_Order__c JO = new CSS_Job_Order__c();
        //JO = CSS_TestData.createJobOrder(true);
        
        /*CSS_Claims__c  claimsRec= new CSS_Claims__c();
        	claimsRec.odm_Status__c = '';
        	insert claimsRec;*/
    	
        List<Id> prtsListIds = new List<Id>();
		 CSS_Parts_Options__c parts = new CSS_Parts_Options__c();
          //parts.FailurepartId__c = solComp.Id;
          parts.Service_Job__c = JO.id;
          parts.selected_part__c = True;
          parts.Service_partnumber__c = '540571401';
          parts.OEM__c = 'OEMWRS';
          parts.Part_Name__c = 'TestPartCamp';
          parts.ReturnToFactory__c = 'Campaign-TRP-ATC';
      	  parts.Replacement_Reason__c = 'Campaign-TRP-ATC';
          parts.Quantity__c = 55;
          parts.Notes__c = 'Hey how are you guys';
          //parts.css_claims__c = claimsRec.id;
          parts.Fail_Code__c = 'testing'; 
          parts.Account_Code__c = 'ACCOUNT TEAM COVERAGE 27';
          //insert parts;
        prtsListIds.add(parts.Id);
        
        
                
        CSS_Solution_Component__c solComp = new CSS_Solution_Component__c();
            solComp.Component_Id__c ='F0051000';
           // solComp.Service_Job__c = Jo.id;
            solComp.Action__c = '';
            solComp.Type__c = 'Campaign';
            solComp.Campaign_Description__c = 'Hey Hai Man Camp';
            solComp.CampaignPartsPercentage__c = '20';
            solcomp.Performed_Review__c = True;
        	//solcomp.Claim_Type__c = 'Test';
        	solComp.Selected_Claim_Type__c = 'Testing';
        	solComp.AccountCodeType__c	= 'ACCOUNT TEAM COVERAGE';
        	solcomp.AccountCode__c = '27';
        	solcomp.AccountCodeEdit__c = 'ACCOUNT TEAM COVERAGE 27';
        	
        	insert solcomp;
        
        CG_UpdateClaimType ClaimType = new CG_UpdateClaimType();
        CG_UpdateClaimType.updateClaimType(prtsListIds);
        test.stopTest();
} 
    
    static TestMethod void testSRT34() {
        test.startTest();
        CSS_Job_Order__c JO = new CSS_Job_Order__c();
        //JO = CSS_TestData.createJobOrder(true);
        
        /*CSS_Claims__c  claimsRec= new CSS_Claims__c();
        	claimsRec.odm_Status__c = '';
        	insert claimsRec;*/
    	
        CSS_Solution_Component__c solComp = new CSS_Solution_Component__c();
        	solComp.Fail_Code_Editable__c = 'testing';
            solComp.Component_Id__c ='F0051000';
            solComp.Service_Job__c = Jo.id;
        	solComp.System_Code__c = 'rite12';
            solComp.Action__c = '';
            solComp.Type__c = 'Campaign';
            solComp.Campaign_Description__c = 'Hey Hai Man Camp';
            solComp.CampaignPartsPercentage__c = '20';
            solcomp.Performed_Review__c = True;
        	solcomp.Claim_Type__c = 'Test';
        	solComp.Selected_Claim_Type__c = 'Testing';
        	solComp.AccountCodeType__c	= 'ACCOUNT TEAM COVERAGE';
        	solcomp.AccountCode__c = '27';
        	solcomp.AccountCodeEdit__c = 'ACCOUNT TEAM COVERAGE 27';
        	
        	//insert solcomp;
        
        List<Id> prtsListIds = new List<Id>();
		 CSS_Parts_Options__c parts = new CSS_Parts_Options__c();
          parts.FailurepartId__c = solComp.Id;
          parts.Service_Job__c = JO.id;
          //parts.Get_Fail_Code_Formula__c = 
          parts.selected_part__c = True;
          parts.Service_partnumber__c = '540571401';
          parts.OEM__c = 'OEMWRS';
          parts.Part_Name__c = 'TestPartCamp';
          parts.ReturnToFactory__c = 'Campaign-TRP-ATC';
      	  parts.Replacement_Reason__c = 'Campaign-TRP-ATC';
          parts.Quantity__c = 55;
          parts.Notes__c = 'Hey how are you guys';
          //parts.css_claims__c = claimsRec.id;
          parts.Fail_Code__c = ''; 
          parts.Account_Code__c = 'ACCOUNT TEAM COVERAGE 27';
          insert parts;
        prtsListIds.add(parts.Id);
       
        CG_UpdateClaimType ClaimType = new CG_UpdateClaimType();
        //ClaimType.fCode = '12';
        CG_UpdateClaimType.updateClaimType(prtsListIds);
        test.stopTest();
} 
    
	static TestMethod void testSRT14() {
        test.startTest();
        CSS_Job_Order__c JO = new CSS_Job_Order__c();
        //JO = CSS_TestData.createJobOrder(true);
        
        /*CSS_Claims__c  claimsRec= new CSS_Claims__c();
        	claimsRec.odm_Status__c = '';
        	insert claimsRec;*/
    	
        CSS_Solution_Component__c solComp = new CSS_Solution_Component__c();
        	solComp.Fail_Code_Editable__c = 'testing';
            solComp.Component_Id__c ='F0051000';
            solComp.Service_Job__c = Jo.id;
        	solComp.System_Code__c = 'rite12';
            solComp.Action__c = '';
            solComp.Type__c = 'Campaign';
            solComp.Campaign_Description__c = 'Hey Hai Man Camp';
            solComp.CampaignPartsPercentage__c = '20';
            solcomp.Performed_Review__c = True;
        	//solcomp.Claim_Type__c = 'Test';
        	solComp.Selected_Claim_Type__c = 'Testing';
        	solComp.AccountCodeType__c	= 'ACCOUNT TEAM COVERAGE';
        	solcomp.AccountCode__c = '27';
        	solcomp.AccountCodeEdit__c = 'ACCOUNT TEAM COVERAGE 27';
        	
        	//insert solcomp;
        
        List<Id> prtsListIds = new List<Id>();
		 CSS_Parts_Options__c parts = new CSS_Parts_Options__c();
          parts.FailurepartId__c = solComp.Id;
          parts.Service_Job__c = JO.id;
          //parts.Get_Fail_Code_Formula__c = 
          parts.selected_part__c = True;
          parts.Service_partnumber__c = '540571401';
          parts.OEM__c = 'OEMWRS';
          parts.Part_Name__c = 'TestPartCamp';
          parts.ReturnToFactory__c = 'Campaign-TRP-ATC';
      	  parts.Replacement_Reason__c = 'Campaign-TRP-ATC';
          parts.Quantity__c = 55;
          parts.Notes__c = 'Hey how are you guys';
          //parts.css_claims__c = claimsRec.id;
          parts.Fail_Code__c = ''; 
          parts.Account_Code__c = 'ACCOUNT TEAM COVERAGE 27';
          insert parts;
        prtsListIds.add(parts.Id);
       
        CG_UpdateClaimType ClaimType = new CG_UpdateClaimType();
        //ClaimType.fCode = '12';
        CG_UpdateClaimType.updateClaimType(prtsListIds);
        test.stopTest();
} 
    
    static TestMethod void testSRT04() {
        test.startTest();
        CSS_Job_Order__c JO = NEW CSS_Job_Order__c();
            JO.Customer_Name__c = 'CumminsTnD';
            JO.ESN__c = '79464646';
            JO.Mileage_Measure__c='19';
            JO.Failure_Date__c=system.today();
            JO.Qsol_Engine_Family_Code__c='IN';
            JO.Service_Model__c='Fire truck';
            insert JO;

    	List<CSS_Solution_Component__c> lisSolCom =new List<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solComp = new CSS_Solution_Component__c();
        	solComp.Fail_Code_Editable__c = 'Engine Wiring Harness-EUWH';
            solComp.Component_Id__c ='F0051000';
            solComp.Service_Job__c = Jo.id;
            solComp.Action__c = '';
            solComp.Type__c = 'Campaign';
            solComp.Campaign_Description__c = 'Hey Hai Man Camp';
            solComp.CampaignPartsPercentage__c = '20';
            solcomp.Performed_Review__c = True;
        	solcomp.Claim_Type__c = 'AMMPS';
        	//solComp.Selected_Claim_Type__c = 'Testing';
        	solComp.AccountCodeType__c	= 'ACCOUNT TEAM COVERAGE';
        	solcomp.AccountCode__c = '27';
        	solcomp.AccountCodeEdit__c = 'ACCOUNT TEAM COVERAGE 27';
        	//solcomp.FailCode_Formula__c='Engine Wiring Harness-EUWH';
        	insert solcomp;
        lisSolCom.add(solcomp);
        CSS_Solution_Component__c solComp1 = new CSS_Solution_Component__c();
        	solComp1.Fail_Code_Editable__c = 'Turbocharger Actuator-THAC';
            solComp1.Component_Id__c ='F0051000';
            solComp1.Service_Job__c = Jo.id;
            solComp1.Action__c = '';
            solComp1.Type__c = 'Campaign';
            solComp1.Campaign_Description__c = 'Hey Hai Man Camp';
            solComp1.CampaignPartsPercentage__c = '20';
            solcomp1.Performed_Review__c = True;
        	solcomp1.Claim_Type__c = 'AMMPS';
        	//solComp.Selected_Claim_Type__c = 'Testing';
        	solComp1.AccountCodeType__c	= 'NEW PRODUCT WARRANTY';
        	solcomp1.AccountCode__c = '67';
        	solcomp1.AccountCodeEdit__c = 'NEW PRODUCT WARRANTY 67';
        	//solcomp.FailCode_Formula__c='Engine Wiring Harness-EUWH';
        	insert solcomp1;
        lisSolCom.add(solcomp1);
         map<id,List<CSS_Solution_Component__c>> solutionListMap = new map<id,List<CSS_Solution_Component__c>>();
         solutionListMap.put(Jo.id, lisSolCom);
        List<Id> prtsListIds = new List<Id>();
		 CSS_Parts_Options__c parts = new CSS_Parts_Options__c();
          parts.FailurepartId__c = solComp.Id;
          parts.Service_Job__c = JO.id;
          parts.selected_part__c = True;
          parts.Service_partnumber__c = '540571401';
          parts.OEM__c = 'OEMWRS';
          parts.Part_Name__c = 'TestPartCamp';
          parts.ReturnToFactory__c = 'Campaign-TRP-ATC';
      	  parts.Replacement_Reason__c = 'Campaign-TRP-ATC';
          parts.Quantity__c = 55;
          parts.Notes__c = 'Hey how are you guys';
          parts.Fail_Code__c = 'OEM Wiring Harness-XXOE'; 
          parts.Account_Code__c = 'ACCOUNT TEAM COVERAGE 27';
          insert parts;
          CSS_Parts_Options__c parts1 = new CSS_Parts_Options__c();
          parts1.FailurepartId__c = solComp.Id;
          parts1.Service_Job__c = JO.id;
          parts1.selected_part__c = True;
          parts1.Service_partnumber__c = '540571401';
          parts1.OEM__c = 'OEMWRS';
          parts1.Part_Name__c = 'TestPartCamp';
          parts1.ReturnToFactory__c = 'Campaign-TRP-ATC';
      	  parts1.Replacement_Reason__c = 'Campaign-TRP-ATC';
          parts1.Quantity__c = 55;
          parts1.Notes__c = 'Hey how are you guys';
          parts1.Fail_Code__c = 'Turbocharger Actuator-THAC'; 
          parts1.Account_Code__c = 'ACCOUNT TEAM COVERAGE 27';
          insert parts1;
        prtsListIds.add(parts1.Id);
       
        CG_UpdateClaimType ClaimType = new CG_UpdateClaimType();
        CG_UpdateClaimType.updateClaimType(prtsListIds);
        test.stopTest();
} 
    
     static TestMethod void testSRT05() {
        test.startTest();
        CSS_Job_Order__c JO = new CSS_Job_Order__c();
        //JO = CSS_TestData.createJobOrder(true);
        
        CSS_Claims__c  claimsRec= new CSS_Claims__c();
        	claimsRec.odm_Status__c = '';
        	//insert claimsRec;
    	
        CSS_Solution_Component__c solComp = new CSS_Solution_Component__c();
        	solComp.Fail_Code_Editable__c = 'Turbocharger Actuator-THAC';
            solComp.Component_Id__c ='F0051000';
            //solComp.Service_Job__c = Jo.id;
            solComp.Action__c = '';
            solComp.Type__c = 'Campaign';
            solComp.Campaign_Description__c = 'Hey Hai Man Camp';
            solComp.CampaignPartsPercentage__c = '20';
            solcomp.Performed_Review__c = True;
        	solcomp.CSS_Claims__c = claimsRec.id;
        	solComp.Selected_Claim_Type__c = 'Testing';
        	solComp.AccountCodeType__c	= 'ACCOUNT TEAM COVERAGE';
        	solcomp.AccountCode__c = '27';
        	solcomp.AccountCodeEdit__c = 'ACCOUNT TEAM COVERAGE 27';
        	
        	insert solcomp;
        
        List<Id> prtsListIds = new List<Id>();
		 CSS_Parts_Options__c parts = new CSS_Parts_Options__c();
          parts.FailurepartId__c = solComp.Id;
          parts.Service_Job__c = JO.id;
          parts.selected_part__c = True;
          parts.Service_partnumber__c = '540571401';
          parts.OEM__c = 'OEMWRS';
          parts.Part_Name__c = 'TestPartCamp';
          parts.ReturnToFactory__c = 'Campaign-TRP-ATC';
      	  parts.Replacement_Reason__c = 'Campaign-TRP-ATC';
          parts.Quantity__c = 55;
          parts.Notes__c = 'Hey how are you guys';
          //parts.Get_Fail_Code_Formula__c = 'OEM Wiring Harness-XXOE';        
         parts.Fail_Code__c ='';
          parts.Account_Code__c = 'ACCOUNT TEAM COVERAGE 27';
          insert parts;
         prtsListIds.add(parts.Id);
          CSS_Parts_Options__c parts1 = new CSS_Parts_Options__c();
          parts1.FailurepartId__c = solComp.Id;
          parts1.Service_Job__c = JO.id;
          parts1.selected_part__c = True;
          parts1.Service_partnumber__c = '540571401';
          parts1.OEM__c = 'OEMWRS';
          parts1.Part_Name__c = 'TestPartCamp';
          parts1.ReturnToFactory__c = 'Campaign-TRP-ATC';
      	  parts1.Replacement_Reason__c = 'Campaign-TRP-ATC';
          parts1.Quantity__c = 55;
          parts1.Notes__c = 'Hey how are you guys';
          //parts1.Get_Fail_Code_Formula__c = 'Turbocharger Actuator-THAC';
          parts1.Fail_Code__c ='';
          parts1.Account_Code__c = 'ACCOUNT TEAM COVERAGE 27';
          insert parts1;
        prtsListIds.add(parts1.Id);
        
       
        CG_UpdateClaimType ClaimType = new CG_UpdateClaimType();
        CG_UpdateClaimType.updateClaimType(prtsListIds);
        test.stopTest();
} 
    
    static TestMethod void testSRT13() {
        test.startTest();
      
        
        CSS_Claims__c  claimsRec= new CSS_Claims__c();
        	claimsRec.odm_Status__c = '';
        	insert claimsRec;
    	
        List<Id> prtsListIds = new List<Id>();
		 CSS_Parts_Options__c parts = new CSS_Parts_Options__c();
          //parts.FailurepartId__c = solComp.Id;
          parts.selected_part__c = True;
          parts.Service_partnumber__c = '540571401';
          parts.OEM__c = 'OEMWRS';
          parts.Part_Name__c = 'TestPartCamp';
          parts.ReturnToFactory__c = 'Campaign-TRP-ATC';
      	  parts.Replacement_Reason__c = 'Campaign-TRP-ATC';
          parts.Quantity__c = 55;
          parts.Notes__c = 'Hey how are you guys';
          parts.css_claims__c = claimsRec.id;
          parts.Fail_Code__c = 'test-ing'; 
          parts.Account_Code__c = 'ACCOUNT TEAM COVERAGE 27';
          insert parts;
        prtsListIds.add(parts.Id);
        
        
                
        CSS_Solution_Component__c solComp = new CSS_Solution_Component__c();
            solComp.Component_Id__c ='F0051000';
           // solComp.Service_Job__c = Jo.id;
            solComp.Action__c = '';
            solComp.Type__c = 'Campaign';
            solComp.Campaign_Description__c = 'Hey Hai Man Camp';
            solComp.CampaignPartsPercentage__c = '20';
            solcomp.Performed_Review__c = True;
        	solcomp.Claim_Type__c = 'Test';
        	solComp.Selected_Claim_Type__c = 'Testing';
        	solComp.AccountCodeType__c	= 'ACCOUNT TEAM COVERAGE';
        	solcomp.AccountCode__c = '27';
        	solcomp.AccountCodeEdit__c = 'ACCOUNT TEAM COVERAGE 27';
        	
        	insert solcomp;
        
        CG_UpdateClaimType ClaimType = new CG_UpdateClaimType();
        CG_UpdateClaimType.updateClaimType(prtsListIds);
        test.stopTest();
} 
    
     static TestMethod void testSRT23() {
        test.startTest();
      
        
        CSS_Claims__c  claimsRec= new CSS_Claims__c();
        	claimsRec.odm_Status__c = '';
        	insert claimsRec;
    	
        List<Id> prtsListIds = new List<Id>();
		 CSS_Parts_Options__c parts = new CSS_Parts_Options__c();
          //parts.FailurepartId__c = solComp.Id;
          parts.selected_part__c = True;
          parts.Service_partnumber__c = '540571401';
          parts.OEM__c = 'OEMWRS';
          parts.Part_Name__c = 'TestPartCamp';
          parts.ReturnToFactory__c = 'Campaign-TRP-ATC';
      	  parts.Replacement_Reason__c = 'Campaign-TRP-ATC';
          parts.Quantity__c = 55;
          parts.Notes__c = 'Hey how are you guys';
          parts.css_claims__c = claimsRec.id;
          parts.Fail_Code__c = 'testing'; 
          parts.Account_Code__c = 'ACCOUNT TEAM COVERAGE 27';
          insert parts;
        prtsListIds.add(parts.Id);
        
        
                
        CSS_Solution_Component__c solComp = new CSS_Solution_Component__c();
            solComp.Component_Id__c ='F0051000';
           // solComp.Service_Job__c = Jo.id;
            solComp.Action__c = '';
            solComp.Type__c = 'Campaign';
            solComp.Campaign_Description__c = 'Hey Hai Man Camp';
            solComp.CampaignPartsPercentage__c = '20';
            solcomp.Performed_Review__c = True;
        	solcomp.Claim_Type__c = 'Test';
        	solComp.Selected_Claim_Type__c = 'Testing';
        	solComp.AccountCodeType__c	= 'ACCOUNT TEAM COVERAGE';
        	solcomp.AccountCode__c = '27';
        	solcomp.AccountCodeEdit__c = 'ACCOUNT TEAM COVERAGE 27';
        	
        	insert solcomp;
        
        CG_UpdateClaimType ClaimType = new CG_UpdateClaimType();
        CG_UpdateClaimType.updateClaimType(prtsListIds);
        test.stopTest();
} 
    
    static TestMethod void testSRT03() {
        test.startTest();
      
        
        CSS_Claims__c  claimsRec= new CSS_Claims__c();
        	claimsRec.odm_Status__c = '';
        	insert claimsRec;
    	 
        CSS_Solution_Component__c solComp = new CSS_Solution_Component__c();
           solComp.Fail_Code_Editable__c = 'testing';
        	solComp.Component_Id__c ='F0051000';
           // solComp.Service_Job__c = Jo.id;
            solComp.Action__c = '';
            solComp.Type__c = 'Campaign';
            solComp.Campaign_Description__c = 'Hey Hai Man Camp';
            solComp.CampaignPartsPercentage__c = '20';
            solcomp.Performed_Review__c = True;
        	solcomp.Claim_Type__c = 'Test';
        	solComp.Selected_Claim_Type__c = 'Testing';
        	solComp.AccountCodeType__c	= 'ACCOUNT TEAM COVERAGE';
        	solcomp.AccountCode__c = '27';
        	solcomp.AccountCodeEdit__c = 'ACCOUNT TEAM COVERAGE 27';
        	
        	insert solcomp;
        
        List<Id> prtsListIds = new List<Id>();
		 CSS_Parts_Options__c parts = new CSS_Parts_Options__c();
          parts.FailurepartId__c = solComp.Id;
          parts.selected_part__c = True;
          parts.Service_partnumber__c = '540571401';
          parts.OEM__c = 'OEMWRS';
          parts.Part_Name__c = 'TestPartCamp';
          parts.ReturnToFactory__c = 'Campaign-TRP-ATC';
      	  parts.Replacement_Reason__c = 'Campaign-TRP-ATC';
          parts.Quantity__c = 55;
          parts.Notes__c = 'Hey how are you guys';
          parts.css_claims__c = claimsRec.id;
          parts.Fail_Code__c = ''; 
          parts.Account_Code__c = 'ACCOUNT TEAM COVERAGE 27';
          insert parts;
        prtsListIds.add(parts.Id);
        
        
                
       
        CG_UpdateClaimType ClaimType = new CG_UpdateClaimType();
        CG_UpdateClaimType.updateClaimType(prtsListIds);
        test.stopTest();
} 
    
      static TestMethod void testSRT33() {
        test.startTest();
      
        
        CSS_Claims__c  claimsRec= new CSS_Claims__c();
        	claimsRec.odm_Status__c = '';
        	insert claimsRec;
    	
        CSS_Solution_Component__c solComp = new CSS_Solution_Component__c();
            
           // solComp.Service_Job__c = Jo.id;
            solComp.Fail_Code_Editable__c = 'testing';
         	solComp.Component_Id__c ='F0051000';
		solcomp.CSS_Claims__c = claimsRec.id;
         	solComp.System_Code__c = 'rite12';
         	solComp.Action__c = '';
         
            solComp.Type__c = 'Campaign';
            solComp.Campaign_Description__c = 'Hey Hai Man Camp';
            solComp.CampaignPartsPercentage__c = '20';
            solcomp.Performed_Review__c = True;
        	//solcomp.Claim_Type__c = 'Test';
        	solComp.Selected_Claim_Type__c = 'Testing';
        	solComp.AccountCodeType__c	= 'ACCOUNT TEAM COVERAGE';
        	solcomp.AccountCode__c = '27';
        	solcomp.AccountCodeEdit__c = 'ACCOUNT TEAM COVERAGE 27';
        	
        	insert solcomp;

        List<Id> prtsListIds = new List<Id>();
		 CSS_Parts_Options__c parts = new CSS_Parts_Options__c();
          parts.FailurepartId__c = solComp.Id;
          parts.css_claims__c = claimsRec.id;
          
          parts.selected_part__c = True;
          parts.Service_partnumber__c = '540571401';
          parts.OEM__c = 'OEMWRS';
          parts.Part_Name__c = 'TestPartCamp';
          parts.ReturnToFactory__c = 'Campaign-TRP-ATC';
      	  parts.Replacement_Reason__c = 'Campaign-TRP-ATC';
          parts.Quantity__c = 55;
          parts.Notes__c = 'Hey how are you guys';
	  parts.Fail_Code__c = ''; 
          parts.Account_Code__c = 'ACCOUNT TEAM COVERAGE 27';
          insert parts;
        prtsListIds.add(parts.Id);
        
        
                
                
        CG_UpdateClaimType ClaimType = new CG_UpdateClaimType();
        CG_UpdateClaimType.updateClaimType(prtsListIds);
        test.stopTest();
} 
    
    static TestMethod void testSRT39() {
        test.startTest();
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
        
        CSS_Claims__c  claimsRec= new CSS_Claims__c();
        	claimsRec.odm_Status__c = '';
        	claimsRec.Account__c = acc.id;
        	insert claimsRec;
    	
        CSS_Solution_Component__c solComp = new CSS_Solution_Component__c();
            
           // solComp.Service_Job__c = Jo.id;
            solComp.Fail_Code_Editable__c = 'testing';
         	solComp.Component_Id__c ='F0051000';
		solcomp.CSS_Claims__c = claimsRec.id;
         	solComp.System_Code__c = 'rite12';
         	solComp.Action__c = '';
         
            solComp.Type__c = 'Campaign';
            solComp.Campaign_Description__c = 'Hey Hai Man Camp';
            solComp.CampaignPartsPercentage__c = '20';
            solcomp.Performed_Review__c = True;
        	solcomp.Claim_Type__c = 'Test';
        	solComp.Selected_Claim_Type__c = 'Testing';
        	solComp.AccountCodeType__c	= 'ACCOUNT TEAM COVERAGE';
        	solcomp.AccountCode__c = '27';
        	solcomp.AccountCodeEdit__c = 'ACCOUNT TEAM COVERAGE 27';
        	
        	insert solcomp;

        List<Id> prtsListIds = new List<Id>();
		 CSS_Parts_Options__c parts = new CSS_Parts_Options__c();
          parts.FailurepartId__c = solComp.Id;
          parts.css_claims__c = claimsRec.id;
          
          parts.selected_part__c = True;
          parts.Service_partnumber__c = '540571401';
          parts.OEM__c = 'OEMWRS';
          parts.Part_Name__c = 'TestPartCamp';
          parts.ReturnToFactory__c = 'Campaign-TRP-ATC';
      	  parts.Replacement_Reason__c = 'Campaign-TRP-ATC';
          parts.Quantity__c = 55;
          parts.Notes__c = 'Hey how are you guys';
	  parts.Fail_Code__c = ''; 
          parts.Account_Code__c = 'ACCOUNT TEAM COVERAGE 27';
          insert parts;
        prtsListIds.add(parts.Id);
        
		List<Id> lstSrt = new List<Id>();
        CSS_SRT__c strobj = new CSS_SRT__c();
        strobj.Job_Order__c = servicejob.id;
        strobj.CSS_Claims__c = claimsRec.id;
        strobj.Account_Code__c = 'ACCOUNT TEAM COVERAGE 27';
        strobj.Type__c = 'test';
        strobj.SRT_AccessiblityCheck__c=True;
        strobj.Access_Code_A__c = 65;
        strobj.name = 'TestClassName';
        strobj.Assignment__c = 'PRIMARY';
        strobj.SRT_ID__c = '00-901-10';
        strobj.isPerformed__c = true;
        strobj.FailCode__c = 'testing';
        insert strobj;
        lstSrt.add(strobj.Id);        
                
                
        CG_UpdateClaimType ClaimType = new CG_UpdateClaimType();
        CG_UpdateClaimType.updateClaimType(lstSrt);
        test.stopTest();
} 
    static TestMethod void testSRT40() {
        test.startTest();
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
        
        CSS_Claims__c  claimsRec= new CSS_Claims__c();
        	claimsRec.odm_Status__c = '';
        	claimsRec.Account__c = acc.id;
        	insert claimsRec;
    	
        CSS_Solution_Component__c solComp = new CSS_Solution_Component__c();
            
           // solComp.Service_Job__c = Jo.id;
            solComp.Fail_Code_Editable__c = 'testing';
         	solComp.Component_Id__c ='F0051000';
			solcomp.CSS_Claims__c = claimsRec.id;
         	solComp.System_Code__c = 'rite12';
        	solComp.Component_Code__c = 'test';
         	solComp.Action__c = '';
         	solComp.Service_Job__c = servicejob.id;
            solComp.Type__c = 'Campaign';
            solComp.Campaign_Description__c = 'Hey Hai Man Camp';
            solComp.CampaignPartsPercentage__c = '20';
            solcomp.Performed_Review__c = True;
        	solcomp.Claim_Type__c = 'Test1';
        	solComp.Selected_Claim_Type__c = 'Testing';
        	solComp.AccountCodeType__c	= 'ACCOUNT TEAM COVERAGE';
        	solcomp.AccountCode__c = '27';
        	solcomp.AccountCodeEdit__c = 'ACCOUNT TEAM COVERAGE 27';
        	
        	insert solcomp;

        List<Id> prtsListIds = new List<Id>();
		 CSS_Parts_Options__c parts = new CSS_Parts_Options__c();
          parts.FailurepartId__c = solComp.Id;
          parts.css_claims__c = claimsRec.id;
          
          parts.selected_part__c = True;
          parts.Service_partnumber__c = '540571401';
          parts.OEM__c = 'OEMWRS';
          parts.Part_Name__c = 'TestPartCamp';
          parts.ReturnToFactory__c = 'Campaign-TRP-ATC';
      	  parts.Replacement_Reason__c = 'Campaign-TRP-ATC';
          parts.Quantity__c = 55;
          parts.Notes__c = 'Hey how are you guys';
	  parts.Fail_Code__c = ''; 
          parts.Account_Code__c = 'ACCOUNT TEAM COVERAGE 27';
          insert parts;
        prtsListIds.add(parts.Id);
        
		List<Id> lstSrt = new List<Id>();
        CSS_SRT__c strobj = new CSS_SRT__c();
        strobj.Job_Order__c = servicejob.id;
        strobj.Account_Code__c = 'ACCOUNT TEAM COVERAGE 27';
        strobj.Type__c = 'test';
        strobj.SRT_AccessiblityCheck__c=True;
        strobj.Access_Code_A__c = 65;
        strobj.name = 'TestClassName';
        strobj.Assignment__c = 'PRIMARY';
        strobj.SRT_ID__c = '00-901-10';
        strobj.isPerformed__c = true;
        strobj.FailCode__c = 'rite';
        insert strobj;
        lstSrt.add(strobj.Id);        
                
                
        CG_UpdateClaimType ClaimType = new CG_UpdateClaimType();
        CG_UpdateClaimType.updateClaimType(lstSrt);
        test.stopTest();
} 
     static TestMethod void testSRT5() {
        List<Id> idList = new List<Id>();

        
    CG_UpdateClaimType updClaimType = new CG_UpdateClaimType();
        CG_UpdateClaimType.updateClaimType(idList);
    }
    static TestMethod void testSRTmethod() {
        test.startTest();
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
        
        CSS_Claims__c  claimsRec= new CSS_Claims__c();
        	claimsRec.odm_Status__c = '';
        	claimsRec.Account__c = acc.id;
        	insert claimsRec;
    	
        CSS_Solution_Component__c solComp = new CSS_Solution_Component__c();
            
           // solComp.Service_Job__c = Jo.id;
            solComp.Fail_Code_Editable__c = 'testing';
         	solComp.Component_Id__c ='F0051000';
			solcomp.CSS_Claims__c = claimsRec.id;
         	solComp.System_Code__c = 'rite12';
        	solComp.Component_Code__c = 'test';
         	solComp.Action__c = '';
         	solComp.Service_Job__c = servicejob.id;
            solComp.Type__c = 'Campaign';
            solComp.Campaign_Description__c = 'Hey Hai Man Camp';
            solComp.CampaignPartsPercentage__c = '20';
            solcomp.Performed_Review__c = True;
        	solcomp.Claim_Type__c = 'Test1';
        	solComp.Selected_Claim_Type__c = 'Testing';
        	solComp.AccountCodeType__c	= 'ACCOUNT TEAM COVERAGE';
        	solcomp.AccountCode__c = '27';
        	solcomp.AccountCodeEdit__c = 'ACCOUNT TEAM COVERAGE 27';
        	
        	insert solcomp;

        List<Id> prtsListIds = new List<Id>();
		 CSS_Parts_Options__c parts = new CSS_Parts_Options__c();
          parts.FailurepartId__c = solComp.Id;
          parts.css_claims__c = claimsRec.id;
          
          parts.selected_part__c = True;
          parts.Service_partnumber__c = '540571401';
          parts.OEM__c = 'OEMWRS';
          parts.Part_Name__c = 'TestPartCamp';
          parts.ReturnToFactory__c = 'Campaign-TRP-ATC';
      	  parts.Replacement_Reason__c = 'Campaign-TRP-ATC';
          parts.Quantity__c = 55;
          parts.Notes__c = 'Hey how are you guys';
	  parts.Fail_Code__c = ''; 
          parts.Account_Code__c = 'ACCOUNT TEAM COVERAGE 27';
          insert parts;
        prtsListIds.add(parts.Id);
        
		List<Id> lstSrt = new List<Id>();
        CSS_SRT__c strobj = new CSS_SRT__c();
        //strobj.Job_Order__c = servicejob.id;
        strobj.CSS_Claims__c = claimsRec.id;
        strobj.Account_Code__c = 'ACCOUNT TEAM COVERAGE 27';
        strobj.Type__c = 'test';
        strobj.SRT_AccessiblityCheck__c=True;
        strobj.Access_Code_A__c = 65;
        strobj.name = 'TestClassName';
        strobj.Assignment__c = 'PRIMARY';
        strobj.SRT_ID__c = '00-901-10';
        strobj.isPerformed__c = true;
        strobj.FailCode__c = 'rite';
        insert strobj;
        lstSrt.add(strobj.Id);        
                
                
        CG_UpdateClaimType ClaimType = new CG_UpdateClaimType();
        CG_UpdateClaimType.updateClaimType(lstSrt);
        test.stopTest();
} 
}